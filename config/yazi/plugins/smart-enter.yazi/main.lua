--- @sync entry
return {
	entry = function()
		local emit = ya.mgr_emit or ya.manager_emit
		if not emit then
			return
		end

		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			emit("enter", { hovered = true })
		elseif h and h:is_selected() then
			emit("open", {})
		else
			emit("open", { hovered = true })
		end
	end,
}
