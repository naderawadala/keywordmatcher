defmodule Keywordmatcher do

  @regex_haswhitespace ~r/^(.*\s+.*)+$/i
  @regex_hasOR ~r/^.*\sOR\s.*$/i
  @regex_haswildcard ~r/^(.*\*.*)$/i

  # (.*\*\s+.*)
  # better wildcard regex, checks for star before a whitespace, can't fetch the last word though so temporary for now.

  def match?(text, keyword) do

    #text = " has a really cool and robust functional concurrent as well as possessing the capability of working on BEAM which is not
     #a programming language however Erlang allows us to be build cool applications and build distributed stuff, also bla bla bla there is this thing
     #called HEX DOC and then there's unit testing with uhh ExUnit or whatever, then there's also this cool thing called the Phoenix Framework"

    #keyword = "(Elixir) OR (functional concurrent) OR BEAM OR (programming language) OR (Erlang application*) OR (build* distributed) OR (HEX DOC) OR ExUnit"
    #keyword = "has a really* cool"

    conditions = List.insert_at([],0,has_OR(keyword))
    |> List.insert_at(1,has_AND(keyword))
    |> List.insert_at(2,has_wildcard(keyword))

    case conditions do
      [false,true, _] -> get_match(text,keyword)
      [true, _, _] -> operation_OR?(text,keyword)
      [false, false, true] -> Regex.match?(~r/#{keyword}/i, text)
      [false,false,false] -> get_match(text,keyword)
    end



  end

  def operation_OR?(text,keyword) do
    kw_list = split_kw_OR(keyword)
    match_list(text,kw_list)
    |> Enum.member?(true)

  end

  #get direct match for each word
  defp get_match(text,keyword) do
    if(has_wildcard(keyword)) do
      String.replace(keyword,"*",".*")
      case Regex.match?(~r/#{keyword}/i, text) do
        true -> true
        false -> false
      end
    else
    case Regex.match?(~r/\W*((?i)#{keyword}(?-i))\W*/, text) do
      true -> true
      false -> false
    end
  end
end

# remove parantheses from text, iterate through the list of keywords and get a match
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

  #split keyword string into a list of elements seperated by the OR operator
  def split_kw_OR(keyword) do
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
