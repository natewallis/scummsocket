defmodule Helpers do

  def reverse_binary(binary) do
    binary
    |> :binary.decode_unsigned(:little)
    |> :binary.encode_unsigned(:big)
  end

end
