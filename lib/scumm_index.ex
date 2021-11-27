defmodule ScummIndex do

  def parse do

    assets_file = File.open!("assets/000.lfl")

    block_size = assets_file
    |> IO.binread(4)
    |> Helpers.reverse_binary()
    |> :binary.decode_unsigned()

    block_type = assets_file
    |> IO.binread(2)

    {_, _} = parse_block(block_type, block_size, assets_file)

  end

  def parse_block("RN", block_size, assets_file_pointer) do

    number_of_rooms = (block_size - 7) / 10 |> trunc

    room_data = Enum.reduce(1..number_of_rooms, %{}, fn(_, acc) ->

      room_number = assets_file_pointer
      |> IO.binread(1)
      |> :binary.decode_unsigned

      room_name = assets_file_pointer
      |> IO.binread(9)
      |> Helpers.xor(0xFF)
      |> String.trim

      Map.put(acc, room_name, room_number)

    end)

    #Discard the end of block null pointer
    IO.binread(1)

    {assets_file_pointer, room_data}

  end

end
