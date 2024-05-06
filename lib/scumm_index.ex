defmodule ScummIndex do
  defguard common_block_type(value)
           when value === "0R" or value === "0S" or value === "0N" or value === "0C"

  @block_type_data %{
    # CODE => { storage_key, one_byte_read_name, four_byte_read_name}
    "0R" => {"room_directory", "file_number", "offset"},
    "0S" => {"script_directory", "room_number", "offset"},
    "0N" => {"sound_directory", "room_number", "offset"},
    "0C" => {"costume_directory", "room_number", "offset"}
  }

  def parse do
    File.open!("assets/000.lfl")
    |> find_a_block(%{})
  end

  def find_a_block(assets_file_pointer, data_store) do
    {:ok, current_cursor_position} = :file.position(assets_file_pointer, :cur)
    %File.Stat{size: size} = File.stat!("assets/000.lfl")

    if current_cursor_position < size do
      block_meta_data = get_block_meta_data(assets_file_pointer)
      data_store = Map.merge(data_store, parse_block(block_meta_data, assets_file_pointer))
      find_a_block(assets_file_pointer, data_store)
    else
      data_store
    end
  end

  defp get_block_meta_data(assets_file_pointer) do
    block_size = Helpers.binread_reverse_decode(assets_file_pointer, 4)
    block_type = IO.binread(assets_file_pointer, 2)
    {block_size, block_type}
  end

  # Some blocks share the same data structure, single function to parse multiple block types
  def parse_block({_block_size, block_type}, assets_file_pointer)
      when common_block_type(block_type) do
    number_of_items = Helpers.binread_reverse_decode(assets_file_pointer, 2)

    {index_name, one_byte_read_name, four_byte_read_name} = Map.get(@block_type_data, block_type)

    block_data =
      Enum.reduce(1..number_of_items, [], fn _, acc ->
        one_byte_read_value = Helpers.binread_reverse_decode(assets_file_pointer, 1)
        four_byte_read_value = Helpers.binread_reverse_decode(assets_file_pointer, 4)

        [
          %{
            one_byte_read_name => one_byte_read_value,
            four_byte_read_name => four_byte_read_value
          }
          | acc
        ]
      end)

    %{index_name => block_data}
  end

  # Object directory
  def parse_block({_block_size, "0O"}, assets_file_pointer) do
    # Block Size        (4 bytes)
    # Block Name        (2 bytes)
    # No of items       (2 bytes)
    # Class data        (3 bytes)
    # Owner+state       (1 byte)
    # Class data is little endian
    # No Class = 0
    # State definitions
    # kObjectClassYFlip = 18
    # kObjectClassXFlip = 19
    # kObjectClassNeverClip = 20
    # kObjectClassAlwaysClip = 21
    # kObjectClassIgnoreBoxes = 22
    # kObjectClassPlayer = 23	// Actor is controlled by the player
    # kObjectClassUntouchable = 24

    number_of_items = Helpers.binread_reverse_decode(assets_file_pointer, 2)

    block_data =
      Enum.reduce(1..number_of_items, %{}, fn _, acc ->
        class_data = Helpers.binread_decode(assets_file_pointer, 3)
        owner_state = Helpers.binread_decode(assets_file_pointer, 1)

        # extract the 4 bits for state and owner
        owner =
          owner_state
          |> Bitwise.band(0xF0)
          |> Bitwise.>>>(4)

        state = Bitwise.band(owner_state, 0x0F)

        Map.put(acc, class_data, %{owner: owner, state: state})
      end)

    %{"object_directory" => block_data}
  end

  # Room Names 
  def parse_block({block_size, "RN"}, assets_file_pointer) do
    # Block Size      (4 bytes)
    # Block Name      (2 bytes)
    # Room No         (1 byte)
    # Room Name       (9 bytes) XOR'ed with FF
    # Blank (00) byte (1 byte) Marks end of chunk

    number_of_rooms = trunc((block_size - 7) / 10)

    room_data =
      Enum.reduce(1..number_of_rooms, %{}, fn _, acc ->
        room_number = Helpers.binread_decode(assets_file_pointer, 1)

        room_name =
          assets_file_pointer
          |> IO.binread(9)
          |> Helpers.xor(0xFF)

        Map.put(acc, room_name, room_number)
        Map.put(acc, room_number, room_name)
      end)

    # discard end of block null byte
    :file.position(assets_file_pointer, block_size)

    %{"room_names" => room_data}
  end
end
