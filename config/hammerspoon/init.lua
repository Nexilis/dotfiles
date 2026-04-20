-- Hide Hammerspoon menubar icon
hs.menuIcon(false)

local home = os.getenv("HOME")

-- Auto-reload config by polling file modification time
local initPath = home .. "/.config/hammerspoon/init.lua"
local lastMod = hs.fs.attributes(initPath, "modification")
hs.timer.doEvery(2, function()
    local mod = hs.fs.attributes(initPath, "modification")
    if mod ~= lastMod then
        lastMod = mod
        hs.reload()
    end
end)

local hyper = { "cmd", "ctrl", "alt", "shift" }

hs.loadSpoon("MiroWindowsManager")

spoon.MiroWindowsManager:bindHotkeys({
    up         = { hyper, "k" },
    down       = { hyper, "j" },
    left       = { hyper, "h" },
    right      = { hyper, "l" },
    fullscreen = { hyper, "f" },
    nextscreen = { hyper, "n" },
})

-- Tile visible windows: cycles 50/50 -> 30/70 -> 70/30 on repeated presses
local tileLayouts = { {0.5, 0.5}, {0.3, 0.7}, {0.7, 0.3} }
local tileState = {
    index = 0,
    swapped = false,
    screen = nil,
    windowIds = nil,
}
local tileTimer = nil

local function resetTileState()
    tileState.index = 0
    tileState.swapped = false
    tileState.screen = nil
    tileState.windowIds = nil
end

local function sameWindowSet(wins)
    if not tileState.windowIds or #wins ~= #tileState.windowIds then
        return false
    end

    local ids = {}
    for _, win in ipairs(wins) do
        ids[win:id()] = true
    end

    for _, id in ipairs(tileState.windowIds) do
        if not ids[id] then
            return false
        end
    end

    return true
end

local function initializeTileWindows(wins, focusedWindow, currentScreen)
    table.sort(wins, function(a, b)
        local aIsFocused = focusedWindow and a:id() == focusedWindow:id()
        local bIsFocused = focusedWindow and b:id() == focusedWindow:id()
        if aIsFocused ~= bIsFocused then
            return aIsFocused
        end

        local aFrame = a:frame()
        local bFrame = b:frame()
        if aFrame.x ~= bFrame.x then
            return aFrame.x < bFrame.x
        end

        return a:id() < b:id()
    end)

    tileState.swapped = false
    tileState.screen = currentScreen
    tileState.windowIds = {}
    for _, win in ipairs(wins) do
        table.insert(tileState.windowIds, win:id())
    end
end

local function orderedTileWindows(wins)
    if not tileState.windowIds then
        return wins
    end

    local winsById = {}
    for _, win in ipairs(wins) do
        winsById[win:id()] = win
    end

    local ordered = {}
    for _, id in ipairs(tileState.windowIds) do
        local win = winsById[id]
        if win then
            table.insert(ordered, win)
        end
    end

    if tileState.swapped and #ordered >= 2 then
        ordered[1], ordered[2] = ordered[2], ordered[1]
    end

    return ordered
end

local function applyTileLayout(wins, frame, layout)
    local x = frame.x
    for i, win in ipairs(wins) do
        local ratio = layout[i] or (1 / #wins)
        local w = frame.w * ratio
        win:setFrame(hs.geometry.rect(x, frame.y, w, frame.h))
        x = x + w
    end
end

hs.hotkey.bind(hyper, "o", function()
    if tileTimer then tileTimer:stop() end
    tileTimer = hs.timer.doAfter(10, resetTileState)

    local focusedWindow = hs.window.focusedWindow()
    local currentScreen = focusedWindow and focusedWindow:screen() or hs.screen.mainScreen()
    local allWindows = hs.window.visibleWindows()

    local wins = {}
    for _, win in ipairs(allWindows) do
        if win:isStandard() and win:screen() == currentScreen then
            table.insert(wins, win)
        end
    end

    if #wins == 0 then return end

    local frame = currentScreen:frame()

    if #wins == 1 then
        resetTileState()
        wins[1]:setFrame(frame)
        return
    end

    tileState.index = (tileState.index % #tileLayouts) + 1

    if #wins == 2 then
        if tileState.screen ~= currentScreen or not sameWindowSet(wins) then
            initializeTileWindows(wins, focusedWindow, currentScreen)
            tileState.index = 1
        elseif tileState.index == 1 then
            tileState.swapped = not tileState.swapped
        end

        local layout = tileLayouts[tileState.index]
        local orderedWins = orderedTileWindows(wins)
        applyTileLayout(orderedWins, frame, layout)

        if layout[1] ~= layout[2] then
            local largerWindow = layout[1] > layout[2] and orderedWins[1] or orderedWins[2]
            largerWindow:focus()
        end
        return
    end

    tileState.swapped = false
    tileState.screen = nil
    tileState.windowIds = nil
    applyTileLayout(wins, frame, tileLayouts[tileState.index])
end)

-- Caffeinate toggle in menubar
local caffMenu = hs.menubar.new()
local function setCaffState(state)
    if state then
        hs.caffeinate.set("displayIdle", true)
        hs.caffeinate.set("systemIdle", true)
        caffMenu:setTitle("AW")
    else
        hs.caffeinate.set("displayIdle", false)
        hs.caffeinate.set("systemIdle", false)
        caffMenu:setTitle("zz")
    end
end

setCaffState(false)
caffMenu:setClickCallback(function()
    setCaffState(not hs.caffeinate.get("displayIdle"))
end)

-- Auto-disable caffeinate when switching to battery
hs.battery.watcher.new(function()
    if not hs.battery.isCharging() and not hs.battery.isCharged() then
        setCaffState(false)
    end
end):start()

-- Current space number in menubar
local spaceMenu = hs.menubar.new()
local function runPrivilegedScript(scriptPath)
    local appleScript = string.format(
        'do shell script "/bin/bash " & quoted form of POSIX path of "%s" with administrator privileges',
        scriptPath
    )
    local ok, _, err = hs.osascript.applescript(appleScript)
    if not ok then
        hs.alert.show("Admin command failed")
        print(("Failed to run %s: %s"):format(scriptPath, tostring(err)))
    end
end

spaceMenu:setMenu({
    {
        title = "Kill Zscaler",
        fn = function()
            runPrivilegedScript(home .. "/kill-zscaler.sh")
        end,
    },
    {
        title = "Run Zscaler",
        fn = function()
            runPrivilegedScript(home .. "/run-zscaler.sh")
        end,
    },
})

local function updateSpaceNumber()
    local currentSpace = hs.spaces.focusedSpace()
    local screen = hs.screen.mainScreen()
    local spaces = hs.spaces.spacesForScreen(screen)
    for i, space in ipairs(spaces) do
        if space == currentSpace then
            spaceMenu:setTitle(tostring(i))
            return
        end
    end
end

updateSpaceNumber()
hs.spaces.watcher.new(updateSpaceNumber):start()
