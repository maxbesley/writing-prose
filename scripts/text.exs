# This Elixir script is for formatting and analyzing written prose.
#
# NOTE: The program breaks (loops forever) if any individual
#       word is greater than or equal to the width 'n'.
#
# TODO: Rewrite this after I learn Elixir properly.
# TODO: Make the program preserve the amount of space between paragraphs.
# TODO: Make the program ignore comments, metadata and frontmatter.


defmodule Text do
  defp split_in_two(str, n) do
    if String.length(str) < n do
      {str, ""}
    else
      split_in_two_helper(str, "", n)
    end
  end

  defp split_in_two_helper(str, acc, n) do
    [word | rest] = String.split(str, " ")
    words = Enum.join(rest, " ")

    concat = acc <> " " <> word |> String.trim

    if String.length(concat) < n do
      split_in_two_helper(words, concat, n)
    else
      {acc, str}
    end
  end

  # Evaluates to a list of (often very long) strings
  # where each string represents a single paragraph
  defp break_into_long_strings(text) do
    text
    |> String.split("\n\n")
    |> Enum.map(fn s -> String.replace(s, "\n", " ") end)
    |> Enum.map(fn s -> String.trim_trailing s end)
  end

  defp format_into_para("", _), do: ""

  # 'p' is a string and so is the return type
  defp format_into_para(p, n) do
    {part1, part2} = split_in_two(p, n)
    case part2 do
      "" -> part1
      _  -> part1 <> "\n" <> format_into_para(part2, n)
    end
  end

  # Evaluates to a string
  def force_within_margin(text, n) do
    text
    |> break_into_long_strings
    |> Enum.map(fn s -> format_into_para(s, n) end)
    |> Enum.join("\n\n")
  end

  def char_freqs(text) do
    text
    |> String.graphemes
    |> Enum.frequencies
    |> IO.inspect(label: "Character frequencies",
                  limit: :infinity,
                  binaries: :as_strings,
                  syntax_colors: IO.ANSI.syntax_colors())
  end

  def is_all_ascii(text) do
    text
    |> String.graphemes
    |> MapSet.new
    |> MapSet.to_list
    |> Enum.sort
    |> IO.inspect(limit: :infinity)
  end
end


arg = case System.argv do
        [x] ->
          x
        [] ->
          raise ArgumentError, message: "No args"
        _ ->
          raise ArgumentError, message: "Too many args"
      end

path = Path.expand arg
content = File.read! path

n = 80
result = Text.force_within_margin(content, n)
File.write!(path, result)
