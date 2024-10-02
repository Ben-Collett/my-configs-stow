set -u jumper_keys
set -u jump_locations
set -u active_key
function init_nnn_style_jumper
	for key in jumper_keys
		bind -e key
	end
	set -u jumper_keys $argv 
	set -u active_key $jumper_keys[1]
	echo "active_key: $active_key"
	for key in $jumper_keys
		echo $key
		bind -M normal $key "nnn_jumper $key"
		set -a jumper_keys $key
		set -a jump_locations ''
	end

end
function nnn_jumper
	set -l key_pressed $argv[1]
	if test $active_key != $key_pressed
		set -l active_index (index_of $active_key $jumper)
		set_at_index_in_place jump_locations $active_key (pwd)
		set -l new_active_index (index_of $key_pressed $jumper_keys)
		if test -n $jump_locations[$new_active_index]
			cd (echo "$jump_locations[$new_active_index]")
		end

		set -u active_key $key_pressed 
	end 
end

