function rp
  if test (count $argv) -gt 1
    find . -type f -exec sed -i "s|$argv[1]|$argv[2]|g" {} +
  end
end


