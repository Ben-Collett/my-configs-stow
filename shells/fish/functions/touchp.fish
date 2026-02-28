function fishp
	set -l arg_count (count $argv)
	if test $arg_count -eq 0
		echo "no arg given" >&2
		exit 1
	else if test $arg_count -gt 1
		echo "You passed in $arg_count arguments, would you like to proceed, Y/n"
		read yesOrNo
		set -l yesOrNo (string lower yesOrNo)
		if yesOrNo -eq "y"
			echo "proceeding"
		else if yesOrNo -eq "n"
			echo "cancelling"
		else 
			echo "you didn't enter y or n" >&2
		end
	end	
end
