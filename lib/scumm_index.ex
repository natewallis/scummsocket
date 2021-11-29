defmodule ScummIndex do

  defguard basic_block_type(value) when value === "0R" or value === "0S" or value === "0N" or value === "0C"

  def parse do

    index_data = %{}
    assets_file_pointer = File.open!("assets/000.lfl")

    block_meta_data = parse_block(assets_file_pointer)
    block_contents = parse_block(block_meta_data, assets_file_pointer)
    index_data = Map.merge(index_data, block_contents)

    block_meta_data = parse_block(assets_file_pointer)
    block_contents = parse_block(block_meta_data, assets_file_pointer)
    index_data = Map.merge(index_data, block_contents)

    block_meta_data = parse_block(assets_file_pointer)
    block_contents = parse_block(block_meta_data, assets_file_pointer)
    index_data = Map.merge(index_data, block_contents)

    block_meta_data = parse_block(assets_file_pointer)
    block_contents = parse_block(block_meta_data, assets_file_pointer)
    index_data = Map.merge(index_data, block_contents)

    block_meta_data = parse_block(assets_file_pointer)
    block_contents = parse_block(block_meta_data, assets_file_pointer)
    index_data = Map.merge(index_data, block_contents)

    block_meta_data = parse_block(assets_file_pointer)
    block_contents = parse_block(block_meta_data, assets_file_pointer)
    index_data = Map.merge(index_data, block_contents)

  end

  def parse_block(assets_file_pointer) do

    block_size = assets_file_pointer
    |> IO.binread(4)
    |> Helpers.reverse_binary
    |> :binary.decode_unsigned

    block_type = assets_file_pointer
    |> IO.binread(2)

    {block_size, block_type}

  end

  def parse_block( {block_size, "RN"} , assets_file_pointer) do

    # block data includes block size of 4 bytes, block type of 2 bytes and trailing null byte
    # so 7 bytes in total, each room is 10 bytes in size.  This does not currently account fo
    # a corrupt disk image

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
      Map.put(acc, room_number, room_name)

    end)

    # discard end of block null byte
    :file.position(assets_file_pointer, block_size)

    %{"rooms" => room_data}

  end

  def parse_block( {block_size, block_type} , assets_file_pointer) when basic_block_type(block_type) do

    number_of_entries = (block_size - 8) / 5
    |> trunc

    number_of_items = assets_file_pointer
    |> IO.binread(2)
    |> Helpers.reverse_binary
    |> :binary.decode_unsigned

    IO.puts "#{block_type} number of items: #{number_of_items} ^^^"

    block_data = Enum.reduce(1..number_of_entries, %{}, fn(_, acc) ->

      file_number = assets_file_pointer
      |> IO.binread(1)
      |> Helpers.reverse_binary
      |> :binary.decode_unsigned

      offset = assets_file_pointer
      |> IO.binread(4)
      |> Helpers.reverse_binary
      |> :binary.decode_unsigned

      IO.puts "#{file_number} => #{offset}"

      Map.put(acc, "dummy", "data")

    end)

    %{"scripts_data" => block_data}

  end

  def parse_block( {block_size, "0O"} , assets_file_pointer) do

    number_of_entries = (block_size - 8) / 5
    |> trunc

    number_of_items = assets_file_pointer
    |> IO.binread(2)
    |> Helpers.reverse_binary
    |> :binary.decode_unsigned

    IO.puts "Number of items in room directory: #{number_of_items} ^^^"

    block_data = Enum.reduce(1..number_of_entries, %{}, fn(_, acc) ->

      class_data = assets_file_pointer
      |> IO.binread(3)
      #|> Helpers.reverse_binary
      |> :binary.decode_unsigned

      owner_state = assets_file_pointer
      |> IO.binread(1)
      |> :binary.decode_unsigned

      owner = owner_state
      |> Bitwise.band(0xF0)
      |> Bitwise.>>>(4)

      state = Bitwise.band(owner_state, 0x0F)

      Map.put(acc, class_data, %{owner: owner, state: state})

    end)

    %{"room_directory" => block_data}

  end

end
