function set_at_index 
	set -l index $argv[1]
	set -l value $argv[2]
	set -l array_start 3
	set -l shifted_index (math "$index + 2")
	set -l output 
	for i in (seq $array_start (count $argv))
		if test $shifted_index -eq $i
			set -a output $value
		else
			set -a output $argv[$i]
		end
	end
	echo (count $output)
	echo $output
end
