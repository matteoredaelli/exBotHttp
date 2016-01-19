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

defmodule ExBotHttp.Html do
  require Logger

  def extractLinks(body) do
    links = Floki.find(body, "a")
    links
    |> Enum.map( fn({"a",x,_}) -> x end)
    |> Enum.map( fn([h|_]) -> h end)
    |> Enum.map( fn({"href", u}) -> u end)
  end

end
