defmodule ScummIndex do

  def parse do

    assets_file_pointer = File.open!("assets/000.lfl")
    block_meta_data = parse_block(assets_file_pointer)
    block_data = parse_block(block_meta_data, assets_file_pointer)
    IO.inspect block_data

  end

  def parse_block(assets_file_pointer) do

    block_size = assets_file_pointer
    |> IO.binread(4)
    |> Helpers.reverse_binary()
    |> :binary.decode_unsigned()

    block_type = assets_file_pointer
    |> IO.binread(2)

    {block_size, block_type}

  end

  def parse_block( {block_size, "RN"} , assets_file_pointer) do

    number_of_rooms = (block_size - 7) / 10
    |> trunc

    room_data = Enum.reduce(1..number_of_rooms, %{}, fn(_, acc) ->

      room_number = assets_file_pointer
      |> IO.binread(1)
      |> :binary.decode_unsigned

      room_name = assets_file_pointer
      |> IO.binread(9)
      |> Helpers.xor(0xFF)

      Map.put(acc, room_name, room_number)

    end)

    #Discard the end of block null pointer
    IO.binread(1)

    {assets_file_pointer, room_data}

  end

end
