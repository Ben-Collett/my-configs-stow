--- @sync entry
return {
	entry = function()
    -- Capture the output of the `ls` command in Linux/macOS
    local file = io.popen("ls")
    local output = file:read("*all")
    file:close()
    
    -- Split the string on newlines
    local lines = {}
    for line in output:gmatch("([^\n]+)") do
        table.insert(lines, line)
        print(line)
    end

    local list  = ui.list(lines)
    ui.display(list)
		local h = cx.active.current.hovered
		--ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
	end,
}
