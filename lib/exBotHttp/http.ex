#    exBotHttp, a simple Bot written in Elixir
#    Copyright (C) 2016 matteo.redaelli@gmail.com
#                       http://www-redaelli.org/matteo/ 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

defmodule ExBotHttp.Http do
  require Logger

  def head(url) do
    case HTTPotion.head(url, [timeout: 30_000]) do
      %HTTPotion.Response{ body: _, headers: headers, status_code: 200 } ->
        {:ok, headers}
      _ ->
        {:err, "not found"}
    end
  end

  def get(url) do
    case HTTPotion.get(url, [timeout: 30_000]) do
      %HTTPotion.Response{ body: body, headers: _headers, status_code: 200 } ->
        {:ok, body}
      _ ->
        {:err, "not found"}
    end
  end

    # Field name in headers are case insensitive in HTTP so use downcase
  defp canonical_field_name(key) do
    key
    |> Atom.to_string
    |> String.downcase
  end

  def getHeaderValue(headers, string) do
    {_key, value} = Enum.find(headers, nil, fn {key, _value} ->
      canonical_field_name(key) == string
    end)
    value
  end
  
  defp location(headers) do
    getHeaderValue(headers, "location")
  end

  defp is_special_case(url) do
    url in [
      "https://www.facebook.com/unsupportedbrowser"  # Facebook redirects HTTPotion to the unsupported browser page
    ]
  end

  defp handle_redirect(short, headers) do
    new_location = location(headers)
    case is_special_case(new_location) do
      :true -> short
      :false -> expand(new_location)
    end
  end

  @spec expand(String.t) :: String.t
  def expand(short) do
    try do
      case HTTPotion.head(short) do
        %HTTPotion.Response{headers: headers, status_code: redirect} when 301 <= redirect and redirect <= 302 ->
          handle_redirect(short, headers)
        # Assumes all shortening services respond to HEAD and that target URLs may not.
        # In that case expansion is done.
        %HTTPotion.Response{headers: _headers, status_code: 405} -> short
        %HTTPotion.Response{headers: _headers, status_code: success} when 200 <= success and success < 300 -> short
      end
    rescue
      _ -> :error
    end
  end
  
end
