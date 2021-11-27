defmodule Helpers do

  def reverse_binary(binary) do
    binary
    |> :binary.decode_unsigned(:little)
    |> :binary.encode_unsigned(:big)
  end

  def xor(binary, byte) when is_binary(binary) and byte in 0..255 do
    for <<b <- binary>>, b != 0xFF, into: <<>>, do: <<Bitwise.bxor(b, byte)>>
  end

end
