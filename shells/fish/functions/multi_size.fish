function multi_size
    if test (count $argv) -lt 2
        echo "Usage: multi_size <image_path> <size1> <size2> ..."
        return 1
    end

    set input $argv[1]
    set sizes $argv[2..-1]

    if not test -f $input
        echo "Error: '$input' is not a file."
        return 1
    end

    set base (basename $input | sed 's/\.[^.]*$//')

    for s in $sizes
        if not string match -qr '^[0-9]+$' $s
            echo "Skipping invalid size: $s"
            continue
        end

        set output "$base-$s.png"
        echo "Creating $output ..."
        convert $input -resize "$s"x"$s" $output
    end
end
