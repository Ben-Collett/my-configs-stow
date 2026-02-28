function sub_array_inclusive 
	set -l output 
	set -l start $argv[1]
	set -l end $argv[2]
	if test $start -gt $end 
		echo "start=$start end=$end start>end" >&2
		return 1
	else if test $start -lt 0
		echo "start=$start start<0" >&2
		return 1
	else if test $end -gt (math (count $argv) - 2)
		echo "end > list length" >&2
	end
	set -l array_start_shift 2 # starts at 3 instead of 1 because two args before array
	for i in (seq $start $end)
		
		set -a output $argv[(math "$array_start_shift + $i")]
	end
	echo $output
end
