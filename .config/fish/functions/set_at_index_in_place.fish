#requires first arr to be in scope
#input arr index val
function set_at_index_in_place
	set -l index $argv[2]
	set -l val $argv[3]
	set -l input_array $$argv[1]
	set -l output
	for i in (seq (count $input_array))
		if test $index = $i
			set -a output $val
		else 
			set -a output $input_array[$i]
		end
	end
	set $argv[1] $output
end

