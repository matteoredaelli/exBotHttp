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

defmodule ExBotHttp.Crawler do
  use GenServer
  require Logger
  
  ## Client API

  @doc """
  Starts the server
  """
  def start_link(_, opts) do
    GenServer.start_link(__MODULE__, 0, opts)
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.call(server, :stop)
  end
    
  @doc """

  """
  def crawl(server, url, opts, caller, visited, tobe_visisted, external_urls) do
    GenServer.cast(server, {:crawl, url, opts, caller, visited, tobe_visisted, external_urls})
  end
  
  ## Server Callbacks

  def init(0) do
    {:ok, 0}
  end

  def handle_cast({:crawl, url, opts, caller, visited, tobe_visisted, external_urls}, state) do
    IO.puts url
    {:noreply, state + 1}
  end

end
