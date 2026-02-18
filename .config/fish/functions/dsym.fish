function dsym --description "Replace a symlink with the file it points to (accepts link or target)"
    if test (count $argv) -ne 1
        echo "Usage: dymlink <symlink-or-target>"
        return 1
    end

    set input $argv[1]

    # Case 1: input is a symlink
    if test -L $input
        set link $input
        set target (readlink $link)

        # Case 2: input is a regular file — try to find a symlink pointing to it
    else if test -f $input
        set target (realpath $input)

        # Search current directory tree for symlink pointing to this file
        for candidate in (find . -type l 2>/dev/null)
            if test (realpath (readlink $candidate) 2>/dev/null) = $target
                set link $candidate
                break
            end
        end

        if not set -q link
            echo "No symlink found pointing to $input"
            return 1
        end
    else
        echo "Error: $input is neither a symlink nor a regular file"
        return 1
    end

    # Resolve full path of target
    set target (realpath $target)

    if not test -e $target
        echo "Target file does not exist: $target"
        return 1
    end

    echo "Replacing symlink:"
    echo "  Link:   $link"
    echo "  Target: $target"

    # Remove symlink
    rm $link

    # Move file into link location
    mv $target $link

    echo "Done."
end
