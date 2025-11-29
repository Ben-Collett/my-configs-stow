function cpdf
    if test (count $argv) -lt 1
        echo "Usage: sanitize_pdf <input.pdf> [output.pdf]"
        return 1
    end

    set input $argv[1]

    if not test -f $input
        echo "Error: File '$input' not found."
        return 1
    end

    if test (count $argv) -ge 2
        set output $argv[2]
    else
        set output (basename $input .pdf)"_sanitized.pdf"
    end

    echo "Sanitizing PDF..."
    gs \
        -dSAFER \
        -dNOPAUSE \
        -dBATCH \
        -dDetectDuplicateImages=true \
        -dPDFSETTINGS=/screen \
        -sDEVICE=pdfwrite \
        -sOutputFile="$output" \
        "$input"

    if test $status -eq 0
        echo "Sanitized PDF written to: $output"
    else
        echo "Ghostscript failed to sanitize the file."
        return 1
    end
end
