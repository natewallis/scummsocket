defmodule Helpers do

  def reverse_binary(binary) do
    binary
    |> :binary.decode_unsigned(:little)
    |> :binary.encode_unsigned(:big)
  end

  def xor(binary, byte) when is_binary(binary) and byte in 0..255 do
    for <<b <- binary>>, into: <<>> do
      byte = Bitwise.bxor(b, byte)
      if byte !== 0 do
        <<byte>>
      else
        <<32>>
      end
    end
  end
end
