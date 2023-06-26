defmodule BlogApi.Objects do
  use Absinthe.Schema.Notation
  use BlogApi.Objects.Post

  defp parse_datetime(data) do
    with {:ok, naive_datetime} <- Timex.parse(data, "{ISOdate} {ISOtime}"),
      datetime <- Timex.to_datetime(naive_datetime) do
        {:ok, datetime}
    else
      _ -> {:error, data}
    end
  end
end
