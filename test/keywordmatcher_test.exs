defmodule KeywordmatcherTest do
  use ExUnit.Case
  @module Keywordmatcher
  setup [:data]
  defp data(context) do
    text = "Elixir is a functional, concurrent, general-purpose programming language that runs on the BEAM virtual machine which is also used to implement the Erlang programming language. Elixir builds on top of Erlang and shares the same abstractions for building distributed, fault-tolerant applications. lang:de"
    Map.put(context, :text, text)
  end

  describe "match?" do
    test "should return true if keyword appears in text", context do
      keyword = "elixir"
      assert @module.match?(context.text, keyword) == true
    end

    test "should return true if keyword is written in uppercase", context do
      keyword = "ELIXIR"
      assert @module.match?(context.text, keyword) == true
    end

    test "should return true if keyword is written in mixed case", context do
      keyword = "Elixir"
      assert @module.match?(context.text, keyword) == true
    end

    test "should return true if keyword is surrounded with parantheses", context do
      keyword = "(elixir)"
      assert @module.match?(context.text, keyword) == true
    end

    test "should return false if keyword does not appear in text", context do
      keyword = "java"
      assert @module.match?(context.text, keyword) == false
    end

    # WORD BOUNDARIES
    test "WILDCARD | should return true if keyword appears as complete word", context do
      keyword = "elixir*"
      assert @module.match?(context.text, keyword) == true
    end

    test "WILDCARD | should return true if keyword appears as substring", context do
      keyword = "function*"
      assert @module.match?(context.text, keyword) == true
    end

    test "WILDCARD | should return false if keyword does not appear at all", context do
      keyword = "foo*"
      assert @module.match?(context.text, keyword) == false
    end

    test "NO WILDCARD | should return true if keyword appears as complete word", context do
      keyword = "elixir"
      assert @module.match?(context.text, keyword) == true
    end

    test "NO WILDCARD | should return false if keyword appears as substring", context do
      keyword = "function"
      assert @module.match?(context.text, keyword) == false
    end

    test "NO WILDCARD | should return false if keyword does not appear at all", context do
      keyword = "foo"
      assert @module.match?(context.text, keyword) == false
    end

    # MULTIPLE KEYWORDS
    test "AND | should return true if all keywords appear in text", context do
      keyword = "language elixir erlang"
      assert @module.match?(context.text, keyword) == true
    end

    test "AND | should return false if one keyword is missing in text", context do
      keyword = "language ruby erlang"
      assert @module.match?(context.text, keyword) == false
    end

    test "AND | should return false if all keywords are missing in text", context do
      keyword = "java ruby jvm"
      assert @module.match?(context.text, keyword) == false
    end

    test "AND | should not matter if parantheses were set", context do
      keyword = "(language elixir (erlang))"
      assert @module.match?(context.text, keyword) == true
    end

    test "OR | should return true if all keywords appear in text", context do
      keyword = "language OR elixir OR erlang"
      assert @module.match?(context.text, keyword) == true
    end

    test "OR | should return true if one keyword is missing in text", context do
      keyword = "language OR ruby OR erlang"
      assert @module.match?(context.text, keyword) == true
    end

    test "OR | should return false if all keywords are missing in text", context do
      keyword = "java OR ruby OR jvm"
      assert @module.match?(context.text, keyword) == false
    end

    test "OR | should not matter if parantheses were set", context do
      keyword = "((language) OR elixir OR (erlang))"
      assert @module.match?(context.text, keyword) == true
    end

    # SPECIAL CASES
    test "should not matter if opening and closing parantheses do not match", context do
      keyword = "(elixir OR (ruby"
      assert @module.match?(context.text, keyword) == true
      keyword = "(elixir) OR ruby)"
      assert @module.match?(context.text, keyword) == true
      keyword = "())elixir OR ruby("
      assert @module.match?(context.text, keyword) == true
    end

    test "should not matter if the 'OR' operator is written in downcase", context do
      keyword = "elixir or ruby"
      assert @module.match?(context.text, keyword) == true
      keyword = "elixir Or ruby"
      assert @module.match?(context.text, keyword) == true
      keyword = "elixir oR ruby"
      assert @module.match?(context.text, keyword) == true
    end

    test "should not matter how much whitespace is surrounding the 'OR' operator", context do
      keyword = "elixir  OR  ruby"
      assert @module.match?(context.text, keyword) == true
      keyword = "elixir     OR     ruby"
      assert @module.match?(context.text, keyword) == true
      # Intentionally inserted tab characters here
      keyword = "elixir    OR  ruby"
      assert @module.match?(context.text, keyword) == true
    end

    # COMPLEX EXAMPLES
    test "should work corretly for real world example 01", _context do
      keyword =
        "(??lm??hle OR (??lz b??cker*) OR ??NB OR ??rag OR ??SA OR ??schberghof OR ??SEG OR ??sterreich OR (??sterreich Werbung) OR ??sterreich*) AND (lang:de OR lang:en OR lang:fr OR lang:it)"

      assert @module.match?("lorem ??sterreich ipsum", keyword) == true
      assert @module.match?("lorem Werbung ipsum", keyword) == false
      assert @module.match?("lorem ??lz b??ckerei ipsum", keyword) == true
    end

    test "should work corretly for real world example 02", _context do
      keyword =
        "(??HTB OR ??KOFEN OR (??KON* SERV) OR (??kosozialen Forum) OR (??kosoziales Forum) OR (??kumenisch* Gemeinschaftswerk Pfalz) OR ??l) AND (lang:de OR lang:en OR lang:fr OR lang:it)"

      assert @module.match?("lorem ??KOFEN ipsum", keyword) == true
      assert @module.match?("lorem ??kumenisches ipsum Gemeinschaftswerk", keyword) == false
      assert @module.match?("lorem ??kumenisches ipsum Pfalz", keyword) == false

      assert @module.match?("lorem ??kumenisches ipsum Gemeinschaftswerk dolor Pfalz", keyword) ==
               true
    end

    test "should work corretly for real world example 03", _context do
      keyword =
        "(??VP OR ??WD OR (??WG Wohnbau*) OR (??zlem ??nsal) OR ??rsted OR (??berkinger wasser*) OR (??berlandwerk Gro??-Gerau)) AND (lang:de OR lang:en OR lang:fr OR lang:it)"

      assert @module.match?("lorem ??rsted ipsum", keyword) == true
      assert @module.match?("lorem Wasserwerk ipsum", keyword) == false
      assert @module.match?("lorem ??berkinger ipsum", keyword) == false
      assert @module.match?("lorem Wasserwerk ipsum ??berkinger", keyword) == true
    end
  end
end
