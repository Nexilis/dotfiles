--- @sync entry
return {
    entry = function(state)
        ya.emit("tab_create", { "~/Downloads" })
        ya.emit("tab_create", { "~/Documents" })
        ya.emit("tab_create", { "~/Documents/sync/work-sync" })
        ya.emit("tab_create", { "~/Documents/sync/private-sync" })
        ya.emit("tab_create", { "~/code/gh/cyb" })
        ya.emit("tab_create", { "~/code/gh/prv" })
        ya.emit("tab_switch", { 0, relative = false })
    end,
}

