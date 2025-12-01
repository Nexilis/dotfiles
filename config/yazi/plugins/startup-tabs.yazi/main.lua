--- @sync entry
return {
    entry = function(state)
        ya.manager_emit("tab_create", { "~/Downloads" })
        ya.manager_emit("tab_create", { "~/Documents/sync/work-sync" })
        ya.manager_emit("tab_create", { "~/Documents/sync/private-sync" })
        ya.manager_emit("tab_create", { "~/code/gh/cyb" })
        ya.manager_emit("tab_create", { "~/code/gh/prv" })
    end,
}

