function rplace
  rg -l $argv[1] | xarg set -i 's/$argv[1]/$argv[2]/g'
end
