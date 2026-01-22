--- @sync entry
return {
    entry = function(state)
        local emit = ya.manager_emit or ya.mgr_emit or ya.emit
        if not emit then
            return
        end

        emit("tab_create", { "~/Downloads" })
        emit("tab_create", { "~/Documents/sync/work-sync" })
        emit("tab_create", { "~/Documents/sync/private-sync" })
        emit("tab_create", { "~/code/gh/cyb" })
        emit("tab_create", { "~/code/gh/prv" })
    end,
}

