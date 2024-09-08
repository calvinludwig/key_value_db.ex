defmodule Command.Parser do
  def parse_command(input) do
    case String.split(input, " ", parts: 2) do
      [intention, arguments] -> {String.upcase(intention), arguments}
      [intention] -> {String.upcase(intention), ""}
      _ -> {"", ""}
    end
  end

  def parse_arguments(string, number_of_arguments) do
    regex = ~r/(?:[^\s"]|"(?:\\.|[^"\\])*")+/u

    arguments =
      Regex.scan(regex, string)
      |> Enum.map(&List.first/1)

    if length(arguments) == number_of_arguments do
      {:ok, arguments}
    else
      :error
    end
  end

  def convert_value("TRUE"), do: true
  def convert_value("FALSE"), do: false

  def convert_value(value) do
    case Integer.parse(value) do
      {int, _} -> int
      _ -> remove_quotes(value)
    end
  end

  def remove_quotes(segment) do
    segment
    |> String.trim(~s("))
    |> String.replace(~r/\\"/, "\"")
  end
end
