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

defmodule ExBotHttp.Url do
  require Logger
  

  
  def normalizePath(path, nil) do
    normalizePath(path, "/")
  end
  
  def normalizePath(path, parent_path) do
    cond do
      String.starts_with?(path, "/") -> path
      String.ends_with?(parent_path, "/") -> "#{parent_path}#{path}"
      true ->
        ## removing file name from parent path
        fields = Regex.split(~r/\//, parent_path)
        prefix = Enum.join(List.delete_at(fields, -1), "/")
        "#{prefix}/#{path}"
    end
  end
    
  def normalizeUrl(url, parent_url) do
    uri = URI.parse(to_string(url))
    parent_uri = URI.parse(to_string(parent_url))
    if uri.host && uri.scheme do
      url
    else
      newpath = normalizePath(uri.path, parent_uri.path)
      "#{parent_uri.scheme}://#{parent_uri.host}#{newpath}"
    end
  end

  def transformUrl(url, [:remove_anchors|opts]) do
    ## removing after #
    newurl = List.first(String.split(url, "#", trim: true))
    transformUrl(newurl, opts)
  end
  
  def transformUrl(url, [:remove_query|opts]) do
    ## removing after #
    newurl = List.first(String.split(url, "?", trim: true))
    transformUrl(newurl, opts)
  end
  
  # skipping unknown options
  def transformUrl(url, [unknown|opts]) do
    Loffer.info "transformUrl: Skipping unkown option #{unknown}"
    transformUrl(url, opts)
  end
  
  # empty list or others
  def transformUrl(url, _) do
    url
  end
 
end
