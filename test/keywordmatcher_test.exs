defmodule KeywordmatcherTest do
  use ExUnit.Case
  @module Keywordmatcher

  describe "match?" do
    test "return true if kw is in" do
      keyword = "one"
      text = "one OR three"

      actual = @module.match?(text,keyword)
      assert actual == true
    end

    test "test sentence of ands" do
      keyword = "one two three four"
      text = "one two three four five six seven"

      actual = @module.match?(text,keyword)

      assert actual == true
    end

    test "test case insensitivity" do
      keyword = "One Two Three FOUR"
      text = "one two three four five six seven"

      actual = @module.match?(text,keyword)

      assert actual == true
    end

    test "test parantheses" do
      keyword = "(one) two three four"
      text = "one two (three) four five six seven"

      actual = @module.match?(text,keyword)

      assert actual == true
    end

    test "test sentence of ORS" do
      keyword = "one OR RO ninetyneneen ooo bugsbunny randomtext for no reason whatsoever"
      text = "one two three four five six seven"

      actual = @module.match?(text,keyword)

      assert actual == true
    end

    test "order of words does not matter with OR operator" do
      keyword = "five OR two one three"
      text = "one two three four five six seven"

      actual = @module.match?(text,keyword)

      assert actual == true
    end

    test "returns false if there are no matches at all" do
      keyword = "five two OR one three"
      text = "sixtynine fifty four thirty fivftenteoon"

      actual = @module.match?(text,keyword)

      assert actual == false
    end

    test "match wildcard" do
      keyword = "five* three"
      text = "one two three four five six seven"

      actual = @module.match?(text,keyword)

      assert actual == true
    end
  end

end
