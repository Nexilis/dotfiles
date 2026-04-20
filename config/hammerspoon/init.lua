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
local tileIndex = 0
local tileTimer = nil

hs.hotkey.bind(hyper, "o", function()
    if tileTimer then tileTimer:stop() end
    tileTimer = hs.timer.doAfter(10, function() tileIndex = 0 end)
    local currentScreen = hs.screen.mainScreen()
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
        wins[1]:setFrame(frame)
        return
    end

    tileIndex = (tileIndex % #tileLayouts) + 1
    local layout = tileLayouts[tileIndex]

    -- first two windows get the layout proportions, rest split equally after
    local x = frame.x
    for i, win in ipairs(wins) do
        local ratio = layout[i] or (1 / #wins)
        local w = frame.w * ratio
        win:setFrame(hs.geometry.rect(x, frame.y, w, frame.h))
        x = x + w
    end
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
