#   asapi/lv
#   Copyright (C) 2017  tynn
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.

defmodule Asapi.Ext.Data do
  alias Asapi.Aar
  alias Asapi.Ext.Redis
  import Asapi.Ext.Repo

  def get!(%Aar{} = aar) do
    aar = resolved! aar
    Cachex.get! :lvc, aar, from(&load!/1, 7)
  end

  defp resolved!(%Aar{} = aar) do
    aar.revision
    |> case do
      nil -> true
      "" -> true
      "latest.integration" -> true
      "latest.milestone" -> true
      "latest.release" -> true
      rev -> String.ends_with? rev, "+"
    end
    |> unless do
      aar
    else
      rev = Cachex.get! :lvc, aar, from(&resolve!/1, 1)
      %{aar | revision: rev}
    end
  end

  defp from(fallback, dtl) do
    [ fallback: &Redis.get!(&1, fallback, dtl) ]
  end
end