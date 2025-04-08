defmodule HelpersTest do
  use ExUnit.Case
  doctest Helpers


  describe "reverse_binary/1" do
    test "reverses a binary as little-endian to big-endian" do
      assert Helpers.reverse_binary(<<255, 128>>) == <<128, 255>>
    end

    test "returns :eof unchanged" do
      assert Helpers.reverse_binary(:eof) == :eof
    end
  end

  describe "xor/2" do
    test "xors each byte with the given byte" do
      assert Helpers.xor(<<0x01, 0x02, 0x03>>, 0x01) == <<0x00, 0x03, 0x02>>
    end

    test "ignores bytes that are 0xFF" do
      assert Helpers.xor(<<0xFF, 0x01>>, 0x01) == <<0x00>>
    end
  end

  describe "binread_decode/2" do
    test "reads and decodes binary as unsigned int" do
      {:ok, file} = StringIO.open(<<0x01, 0x00>>)
      assert Helpers.binread_decode(file, 2) == 256
    end
  end

  describe "binread_reverse_decode/2" do
    test "reads, reverses, and decodes binary" do
      {:ok, file} = StringIO.open(<<0x01, 0x00>>)
      assert Helpers.binread_reverse_decode(file, 2) == 1
    end
  end

end
