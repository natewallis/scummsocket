defmodule HelpersTest do
  use ExUnit.Case
  doctest Helpers

  test "binary is reveresed" do
    assert Helpers.reverse_binary(<<255, 128>>) === <<128, 255>>
  end
end
