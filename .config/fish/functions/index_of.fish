function index_of 
	set -l target $argv[1]
	set -l index -1
	for i in (seq 2 (count $argv))
		if test "$target" = "$argv[$i]" 
			set -u index (math "$i-1") # -1 from i becase the target is the first argument
			break
		end
	end
	echo $index
end
