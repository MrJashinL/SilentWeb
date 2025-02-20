defmodule AnonForge do
  @author "Jashin L."
  
  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    {opts, _, _} = OptionParser.parse(args,
      switches: [
        remove: :boolean,
        analyze: :boolean,
        forge: :boolean,
        input: :string,
        output: :string
      ],
      aliases: [
        r: :remove,
        a: :analyze,
        f: :forge,
        i: :input,
        o: :output
      ]
    )
    opts
  end

  def process(opts) do
    cond do
      opts[:remove] -> remove_metadata(opts[:input], opts[:output])
      opts[:analyze] -> analyze_metadata(opts[:input])
      opts[:forge] -> forge_metadata(opts[:input], opts[:output])
      true -> print_usage()
    end
  end

  defp remove_metadata(input, output) do
    file_data = File.read!(input)
    clean_data = strip_exif(file_data)
    File.write!(output, clean_data)
  end

  defp analyze_metadata(input) do
    metadata = extract_metadata(input)
    print_metadata(metadata)
  end

  defp forge_metadata(input, output) do
    file_data = File.read!(input)
    forged_data = inject_fake_metadata(file_data)
    File.write!(output, forged_data)
  end

  defp strip_exif(data) do
    case get_file_type(data) do
      :jpeg -> strip_jpeg_exif(data)
      :png -> strip_png_metadata(data)
      :pdf -> strip_pdf_metadata(data)
      _ -> data
    end
  end

  defp strip_jpeg_exif(data) do
    <<0xFF, 0xD8, rest::binary>> = data
    case :binary.match(rest, <<0xFF, 0xE1>>) do
      {offset, _} ->
        <<head::binary-size(offset), _exif::binary>> = rest
        <<0xFF, 0xD8, head::binary>>
      :nomatch ->
        data
    end
  end

  defp extract_metadata(file_path) do
    data = File.read!(file_path)
    case get_file_type(data) do
      :jpeg -> extract_jpeg_metadata(data)
      :png -> extract_png_metadata(data)
      :pdf -> extract_pdf_metadata(data)
      _ -> %{error: "Unsupported file type"}
    end
  end

  defp inject_fake_metadata(data) do
    fake_metadata = generate_fake_metadata()
    case get_file_type(data) do
      :jpeg -> inject_jpeg_metadata(data, fake_metadata)
      :png -> inject_png_metadata(data, fake_metadata)
      :pdf -> inject_pdf_metadata(data, fake_metadata)
      _ -> data
    end
  end

  defp generate_fake_metadata do
    %{
      make: random_camera_make(),
      model: random_camera_model(),
      datetime: random_datetime(),
      gps: random_gps(),
      software: random_software()
    }
  end

  defp print_metadata(metadata) do
    metadata
    |> Map.to_list()
    |> Enum.each(fn {key, value} ->
      IO.puts "#{key}: #{value}"
    end)
  end

  defp print_usage do
    IO.puts """
    AnonForge - Metadata Manipulation Tool

    Usage:
      anonforge -r -i input_file -o output_file    Remove metadata
      anonforge -a -i input_file                   Analyze metadata
      anonforge -f -i input_file -o output_file    Forge metadata
    """
  end
end
