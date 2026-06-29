-- Hide Hammerspoon menubar icon
hs.menuIcon(false)

local home = os.getenv("HOME")
local hyper = { "cmd", "ctrl", "alt", "shift" }

-- Instant Space Switcher (github.com/joshuarli/iss)
local issDir = home .. "/.config/hammerspoon/iss"
local issPath = issDir .. "/iss"
if not hs.fs.attributes(issPath) then
    hs.execute("cd " .. issDir .. " && make 2>&1")
end
hs.execute("pkill -xf '" .. issPath .. "' 2>/dev/null", true)
if hs.fs.attributes(issPath) then
    issTask = hs.task.new(issPath, function() end)
    issTask:start()
end

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

-- Hyper+1..9: send the focused window to the Nth space on its OWN screen.
-- Move only (the view stays put), with a brief alert. N indexes the same list
-- the menubar number uses (hs.spaces.spacesForScreen orders user + fullscreen
-- spaces the way Mission Control shows them), so Hyper+N matches what the
-- menubar would read after switching there. Pairs with iss (Hyper+arrow) for
-- switching spaces. moveWindowToSpace cannot move a fullscreen/tiled window,
-- nor target a fullscreen space, so those cases just alert instead.
local function moveFocusedWindowToSpace(n)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window", 0.7)
        return
    end
    if win:isFullScreen() then
        hs.alert.show("Can't move a fullscreen window", 0.9)
        return
    end

    local screen = win:screen()
    local spaces = hs.spaces.spacesForScreen(screen)
    local target = spaces and spaces[n]
    if not target then
        hs.alert.show("No space " .. n .. " on this screen", 0.9)
        return
    end
    if target == hs.spaces.activeSpaceOnScreen(screen) then
        hs.alert.show("Already on space " .. n, 0.7)
        return
    end

    local ok, err = hs.spaces.moveWindowToSpace(win, target)
    if ok then
        hs.alert.show("→ space " .. n, 0.7)
    else
        hs.alert.show("Move failed: " .. (err or "?"), 1.2)
    end
end

for i = 1, 9 do
    hs.hotkey.bind(hyper, tostring(i), function() moveFocusedWindowToSpace(i) end)
end

-- Hyper+Tab application switcher: a searchable, most-recently-used list of
-- running apps (hs.chooser). It switches at the application level on purpose.
-- An earlier version listed individual windows via hs.window.filter, but
-- getWindows() forces a synchronous all-windows AX refresh that freezes for
-- seconds after a Space switch (Hammerspoon issue #3712: _timed_allWindows
-- stalls on WebKit helper processes). Running apps and app:activate() read
-- cached NSRunningApplication data and are Space-independent, so there is no
-- window-AX enumeration and no freeze. Trade-off: it switches by app (its
-- frontmost window), not between separate windows of the same app, which is
-- exactly the macOS cmd+tab model.
-- cmd+tab itself is owned by the system switcher (which wins the race for it),
-- so we trigger on Hyper+Tab via an eventtap (a CGEventTap, the same primitive
-- AltTab uses). Caveat: like iss, the tap is blocked while any app holds Secure
-- Event Input; Hyper+Tab then does nothing (see the menubar Secure Input item).
local switcherChooser = nil
local switcherApps = {}   -- chooser row index -> hs.application
local iconCache = {}      -- bundleID -> hs.image (false once known to have none)
local appMRU = {}         -- bundleIDs, most-recently-activated first

-- Track activation order so the list is MRU like cmd+tab. The watcher reads
-- only NSRunningApplication data, so it is cheap and never touches window AX.
appSwitcherWatcher = hs.application.watcher.new(function(_, event, app)
    if event == hs.application.watcher.activated and app then
        local bid = app:bundleID()
        if bid then
            for i, b in ipairs(appMRU) do
                if b == bid then
                    table.remove(appMRU, i)
                    break
                end
            end
            table.insert(appMRU, 1, bid)
        end
    end
end)
appSwitcherWatcher:start()
do
    -- Seed MRU with the current frontmost app so the first switch is sensible.
    local front = hs.application.frontmostApplication()
    if front and front:bundleID() then
        appMRU = { front:bundleID() }
    end
end

local function appIcon(bundleID)
    if not bundleID then return nil end
    if iconCache[bundleID] == nil then
        iconCache[bundleID] = hs.image.imageFromAppBundle(bundleID) or false
    end
    return iconCache[bundleID] or nil
end

-- Running, regular (Dock-visible) apps, ordered most-recently-used first.
local function buildAppChoices()
    local byBundle = {}
    for _, app in ipairs(hs.application.runningApplications()) do
        local bid = app:bundleID()
        if bid and app:kind() == 1 and not byBundle[bid] then
            byBundle[bid] = app
        end
    end

    local ordered = {}
    local added = {}
    for _, bid in ipairs(appMRU) do
        if byBundle[bid] and not added[bid] then
            ordered[#ordered + 1] = byBundle[bid]
            added[bid] = true
        end
    end
    for bid, app in pairs(byBundle) do
        if not added[bid] then
            ordered[#ordered + 1] = app
        end
    end

    local choices = {}
    switcherApps = {}
    for i, app in ipairs(ordered) do
        switcherApps[i] = app
        choices[i] = {
            text = app:name() or "?",
            image = appIcon(app:bundleID()),
            index = i,
        }
    end
    return choices
end

local function showSwitcher()
    if not switcherChooser then
        switcherChooser = hs.chooser.new(function(choice)
            if choice and choice.index then
                local app = switcherApps[choice.index]
                if app then app:activate(true) end
            end
        end)
        switcherChooser:bgDark(true)
        switcherChooser:width(28)
        switcherChooser:rows(7)
        switcherChooser:placeholderText("Switch to app…")
    end
    switcherChooser:choices(buildAppChoices())
    switcherChooser:query("")
    switcherChooser:show()
    -- Row 1 is the current app (MRU head); default to row 2 so Hyper+Tab then
    -- Return/Space jumps to the previous app.
    if #switcherApps >= 2 then
        switcherChooser:selectedRow(2)
    end
end

-- Wrap-around move of the chooser selection.
local function moveSelection(delta)
    local n = #switcherApps
    if n == 0 then return end
    local cur = switcherChooser:selectedRow()
    switcherChooser:selectedRow((cur - 1 + delta) % n + 1)
end

-- Global so the tap is not garbage-collected after init.lua finishes.
-- Trigger is Hyper+Tab. While the chooser is open the tap drives it directly:
-- Tab (or another Hyper+Tab) steps down, a bare Shift+Tab steps up, Space
-- activates the highlighted app. A repeated Hyper+Tab steps through the list
-- instead of rebuilding it, which also debounces. Return and the arrow keys
-- keep working via the chooser itself.
windowSwitcherTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
    local code = event:getKeyCode()
    local flags = event:getFlags()
    local open = switcherChooser ~= nil and switcherChooser:isVisible()

    if code == hs.keycodes.map.tab then
        if open then
            -- step up only on a bare Shift+Tab; a repeated Hyper+Tab steps down
            local up = flags.shift and not flags.cmd and not flags.ctrl and not flags.alt
            moveSelection(up and -1 or 1)
        elseif flags.cmd and flags.ctrl and flags.alt and flags.shift then
            showSwitcher()
        else
            return false
        end
        return true
    end

    if open and code == hs.keycodes.map.space then
        switcherChooser:select()
        return true
    end

    return false
end)
windowSwitcherTap:start()

-- Unified menubar: space number + caffeinate + Zscaler
local menu = hs.menubar.new()

local function setCaffState(state)
    if state then
        hs.caffeinate.set("displayIdle", true)
        hs.caffeinate.set("systemIdle", true)
    else
        hs.caffeinate.set("displayIdle", false)
        hs.caffeinate.set("systemIdle", false)
    end
end

setCaffState(false)

hs.battery.watcher.new(function()
    if not hs.battery.isCharging() and not hs.battery.isCharged() then
        setCaffState(false)
    end
end):start()

local function runPrivilegedScript(scriptPath)
    local f = io.open(scriptPath, "r")
    if not f then
        hs.alert.show("Script not found: " .. scriptPath)
        return
    end
    local content = f:read("*a")
    f:close()
    local tmp = os.tmpname()
    local tf = io.open(tmp, "w")
    tf:write(content)
    tf:close()
    os.execute("chmod +x " .. tmp)
    local appleScript = string.format(
        'do shell script "/bin/bash %s; rm -f %s" with administrator privileges',
        tmp, tmp
    )
    local ok = hs.osascript.applescript(appleScript)
    if not ok then
        hs.alert.show("Admin command failed")
        os.execute("rm -f " .. tmp)
    end
end

-- Secure Event Input blocks all CGEventTaps from seeing keystrokes, which kills
-- iss (Hyper+arrow). Apps sometimes enable it and leak it on quit, leaving it
-- stuck on a dead pid. This surfaces the current holder in the menu.
local function secureInputStatus()
    -- Target only the IOConsoleUsers property (~0.02s) instead of dumping the
    -- whole IORegistry with `ioreg -l` (~1.5s, which froze the menu).
    local out = hs.execute("ioreg -w0 -d1 -k IOConsoleUsers")
    local pid = out and out:match('kCGSSessionSecureInputPID"=(%d+)')
    if not pid or pid == "0" then
        return { enabled = false }
    end
    local app = hs.execute("ps -p " .. pid .. " -o comm= 2>/dev/null")
    app = app and app:gsub("%s+", "") -- comm path, no spaces; trims trailing newline
    local alive = app ~= nil and app ~= ""
    return {
        enabled = true,
        pid = pid,
        app = alive and (app:match("([^/]+)$") or app) or nil,
        dead = not alive,
    }
end

menu:setMenu(function()
    local caffOn = hs.caffeinate.get("displayIdle")
    local sec = secureInputStatus()
    local secTitle, secAction, secDetail, secCopy
    if not sec.enabled then
        secTitle  = "✅ Secure Input: OK"
        secAction = "      Caps+arrow works"
        secDetail = "Secure Event Input is off. Keystrokes reach iss; Caps+arrow works."
        secCopy   = "Secure Input: off (OK)"
    elseif sec.dead then
        secTitle  = string.format("🛑 Secure Input: stuck (dead pid %s)", sec.pid)
        secAction = "      Reboot to clear — blocks Caps+arrow"
        secDetail = string.format(
            "Secure Event Input is stuck on dead pid %s, which blocks iss Caps+arrow. Reboot to clear it.",
            sec.pid)
        secCopy   = string.format("Secure Input stuck on dead pid %s", sec.pid)
    else
        secTitle  = string.format("⚠️ Secure Input: held by %s", sec.app or "?")
        secAction = string.format("      Quit %s to fix Caps+arrow", sec.app or "?")
        secDetail = string.format(
            "%s (pid %s) holds Secure Event Input, which blocks iss Caps+arrow. Quit %s to release it.",
            sec.app or "?", sec.pid, sec.app or "?")
        secCopy   = string.format("%s (pid %s) holds Secure Input", sec.app or "?", sec.pid)
    end
    return {
        {
            title = caffOn and "☕ Caffeinate: ON" or "💤 Caffeinate: OFF",
            fn = function() setCaffState(not caffOn) end,
        },
        { title = "-" },
        {
            title = secTitle,
            tooltip = secDetail,
            fn = function()
                hs.pasteboard.setContents(secCopy)
                hs.alert.show(secDetail)
            end,
        },
        { title = secAction, tooltip = secDetail, disabled = true },
        { title = "-" },
        {
            title = "Window",
            menu = {
                { title = "Hyper+H   Left",         fn = function() hs.eventtap.keyStroke(hyper, "h") end },
                { title = "Hyper+J   Down",         fn = function() hs.eventtap.keyStroke(hyper, "j") end },
                { title = "Hyper+K   Up",           fn = function() hs.eventtap.keyStroke(hyper, "k") end },
                { title = "Hyper+L   Right",        fn = function() hs.eventtap.keyStroke(hyper, "l") end },
                { title = "Hyper+N   Next Screen",  fn = function() hs.eventtap.keyStroke(hyper, "n") end },
                { title = "Hyper+O   Tile",         fn = function() hs.eventtap.keyStroke(hyper, "o") end },
                { title = "-" },
                { title = "Hyper+1…9  Send window to space N", disabled = true },
            },
        },
        { title = "-" },
        {
            title = "Kill Zscaler",
            fn = function() runPrivilegedScript(home .. "/kill-zscaler.sh") end,
        },
        {
            title = "Run Zscaler",
            fn = function() runPrivilegedScript(home .. "/run-zscaler.sh") end,
        },
        { title = "-" },
        {
            title = "Reload",
            fn = function() hs.reload() end,
        },
        {
            title = "Close",
            fn = function() hs.closeConsole(); os.exit() end,
        },
    }
end)

local function numberIcon(n)
    local size = 18
    local r = 3
    local fontSize = 12
    local canvas = hs.canvas.new({ x = 0, y = 0, w = size, h = size })
    canvas:appendElements(
        {
            type = "rectangle",
            fillColor = { white = 0 },
            roundedRectRadii = { xRadius = r, yRadius = r },
            frame = { x = 1, y = 1, w = size - 2, h = size - 2 },
        },
        {
            type = "text",
            text = tostring(n),
            textFont = "Helvetica Bold",
            textSize = fontSize,
            textColor = { white = 1 },
            textAlignment = "center",
            frame = { x = 0.5, y = (size - fontSize) / 2 - 1, w = size, h = fontSize + 4 },
            compositeRule = "destinationOut",
        }
    )
    local image = canvas:imageFromCanvas()
    canvas:delete()
    image:template(true)
    return image
end

local function updateSpaceNumber()
    local currentSpace = hs.spaces.focusedSpace()
    local screen = hs.screen.mainScreen()
    local spaces = hs.spaces.spacesForScreen(screen)
    for i, space in ipairs(spaces) do
        if space == currentSpace then
            menu:setTitle("")
            menu:setIcon(numberIcon(i))
            return
        end
    end
end

updateSpaceNumber()
hs.spaces.watcher.new(updateSpaceNumber):start()
