defmodule Keywordmatcher do

  @regex_haswhitespace ~r/^(.*\s+.*)+$/i
  @regex_hasOR ~r/^.*\sOR\s.*$/i
  @regex_haswildcard ~r/^(.*\*.*)$/i

  # (.*\*\s+.*)
  # better wildcard regex, checks for star before a whitespace, can't fetch the last word though so temporary for now.

  def match?(text, keyword) do

    text = " has a really cool and robust functional concurrent as well as possessing the capability of working on BEAM which is not
     a programming language however Erlang allows us to be build cool applications and build distributed stuff, also bla bla bla there is this thing
     called HEX DOC and then there's unit testing with uhh ExUnit or whatever, then there's also this cool thing called the Phoenix Framework"

    keyword = "(Elixir) OR (functional concurrent) OR BEAM OR (programming language) OR (Erlang application*) OR (build* distributed) OR (HEX DOC) OR ExUnit"



    kw_list = split_kw(keyword)
    match_list(text,kw_list)
    #|> Enum.member?(true)

  end

  defp get_match(text,keyword) do
    if(has_wildcard(keyword)) do

    else
    case Regex.match?(~r/\W*((?i)#{keyword}(?-i))\W*/, text) do
      true -> true
      false -> false
    end
  end
end

  defp match_list(text,kw_list) do
    split_text = String.split(text,~r{\(})
    |> Enum.join()
    |> String.split(~r{\)})
    |> Enum.join()
    for x <- kw_list do
      IO.puts(x)
      get_match(split_text, x)
    end
  end

  def split_kw(keyword) do
    String.split(keyword, ~r{\sOR\s})
  end

  defp has_OR(keyword) do
    case Regex.match?(@regex_hasOR, keyword) do
      true -> true
      false -> false
    end
  end

  defp has_wildcard(keyword) do
    case Regex.match?(@regex_haswildcard, keyword) do
      true -> true
      false -> false
    end
  end

  defp has_AND(keyword) do
    case Regex.match?(@regex_haswhitespace, keyword) do
      true -> true
      false -> false
    end
  end


end
