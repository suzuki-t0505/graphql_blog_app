defmodule BlogApi.Objects.CustomType do
  defmacro __using__(_) do
    quote do
      scalar :datetime do
        description "DateTime for 2022-03-01 00:00:00"
        parse &parse_datetime/1
        serialize &Calendar.strftime(&1, "%c")
      end

      defp parse_datetime(data) do
        with {:ok, naive_datetime} <- Timex.parse(data, "{ISOdate} {ISOtime}"),
          datetime <- Timex.to_datetime(naive_datetime) do
            {:ok, datetime}
        else
          _ -> {:error, data}
        end
      end
    end
  end
end
