-- spell:enableCompoundWords
if true then return end

-- -- on my mouse, upper configurable key is 4, lower is 3
hs.hotkey.bind({ "alt", "ctrl" }, "W", function()
    hs.alert.show("Hello World!")
end)

-- -- determine what mouse button is clicked
-- see_mouse_buttons = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, function(e)
--     hs.alert.show("Button " .. e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber))
--     return false
-- end)
-- see_mouse_buttons:start()
-- t = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, function(e)
--     if e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) == 3 then
--         hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.getAbsolutePosition()):post()
--         hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.getAbsolutePosition()):post()
--         return true -- swallow original click
--     end
--     return false
-- end)
-- t:start()
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--     hs.notify.new({
--         title = "Hammerspoon",
--         informativeText = "Hello World"
--     }):send()
-- end)
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
--     local win = hs.window.focusedWindow()
--     local f = win:frame()
--     f.x = f.x - 10
--     win:setFrame(f)
-- end)

local dragButton = 4 -- mouse button
local threshold = 50 -- pixels before it triggers
local startPos = nil

function Move_to_space(direction)
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    -- hs.alert.show(direction)
    local uuid = screen:spacesUUID()
    local spacesLayout = hs.spaces.allSpaces()
    local currentSpaceID = win:space()
    local spaceIndex = nil

    -- Find the index of the current space
    for i, id in ipairs(spacesLayout[uuid]) do
        if id == currentSpaceID then
            spaceIndex = i
            break
        end
    end

    -- Calculate the index of the previous space (wrap around if needed)
    local prevIndex = spaceIndex - direction
    if prevIndex < 1 then
        prevIndex = #spacesLayout[uuid]
    end
    local targetSpaceID = spacesLayout[uuid][prevIndex]
    -- hs.alert.show(targetSpaceID)
    hs.spaces.gotoSpace(targetSpaceID)
end

PRESS_EVENT = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    local flags = e:getFlags()
    local keyCode = e:getKeyCode()

    if flags.ctrl and keyCode == hs.keycodes.map.up then
        startPos = hs.mouse.absolutePosition()
        hs.alert.show(startPos.x)
    end
    return false
end)
PRESS_EVENT:start()


DRAG_EVENT = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDragged }, function(e)
    if not startPos then return false end

    local pos = hs.mouse.absolutePosition()
    local dx = pos.x - startPos.x
    local dy = pos.y - startPos.y

    if dx < -threshold then
        -- hs.eventtap.keyStroke({ "ctrl" }, "p")
        -- hs.eventtap.keyStroke({ "ctrl" }, "p")
        -- print(hs.spaces.allSpaces())
        -- hs.spaces
        -- hs.spaces.gotoSpace(76)

        -- hs.spaces.openMissionControl()
        -- hs.spaces.openMissionControl()
        -- hs.spaces.gotoSpace(hs.spaces.focusedSpace() + 1)
        -- Move_to_space(1)
        startPos = nil
    elseif dx > threshold then
        -- hs.spaces.closeMissionControl()
        -- hs.spaces.gotoSpace(hs.spaces.focusedSpace() - 1)
        Move_to_space(-1)
        startPos = nil
    end
    -- if math.abs(dx) > math.abs(dy) then
    --     if dx > threshold then
    --         hs.eventtap.keyStroke({ "ctrl" }, "right")
    --         startPos = nil
    --     elseif dx < -threshold then
    --         hs.eventtap.keyStroke({ "ctrl" }, "left")
    --         startPos = nil
    --     end
    -- else
    --     if dy < -threshold then
    --         hs.eventtap.keyStroke({ "ctrl" }, "up")
    --         startPos = nil
    --     end
    -- end
    return false
end)
DRAG_EVENT:start()

-- this all is not needed, because on my mouse when i press the button, it INSTANTLY goes down and up
CTRL_ARROW_UP_EVENT = hs.eventtap.new({ hs.eventtap.event.types.keyUp }, function(e)
    local flags = e:getFlags()
    local keyCode = e:getKeyCode()

    -- i will stop it when we release up key, without thinking about flags
    -- because what if I release ctrl first, and then release up
    -- if flags.ctrl and keyCode == hs.keycodes.map["up"] then
    if keyCode == hs.keycodes.map.up then
        hs.alert.show("up")
        startPos = nil
    end

    return false
end)
CTRL_ARROW_UP_EVENT:start()

print(hs.spaces.allSpaces())
hs.alert.show("Reloaded!")

hs.alert.show("Config loaded")

-- remap alt-d to leftMouseDown
-- all mechanics stolen from here:
-- local vimouse = require('vimouse')
-- vimouse('cmd', 'm')

now = hs.timer.secondsSinceEpoch

evt = hs.eventtap
evte = evt.event
evtypes = evte.types
evp = evte.properties

drag_last = now(); drag_intv = 0.01 -- we only synth drags from time to time

mp = { ['x'] = 0, ['y'] = 0 }       -- mouse point. coords and last posted event
l = hs.logger.new('keybmouse', 'debug')
dmp = hs.inspect

-- The event tap. Started with the keyboard click:
handled = { evtypes.mouseMoved, evtypes.keyUp }
handle_drag = evt.new(handled, function(e)
    if e:getType() == evtypes.keyUp then
        handle_drag:stop()
        post_evt(2)
        return nil -- otherwise the up seems not processed by the OS
    end

    mp['x'] = mp['x'] + e:getProperty(evp.mouseEventDeltaX)
    mp['y'] = mp['y'] + e:getProperty(evp.mouseEventDeltaY)

    -- giving the key up a chance:
    if now() - drag_last > drag_intv then
        -- l.d('pos', mp.x, 'dx', dx)
        post_evt(6) -- that sometimes makes dx negative in the log above
        drag_last = now()
    end
    return true -- important
end)

function post_evt(mode)
    -- 1: down, 2: up, 6: drag
    if mode == 1 or mode == 2 then
        local p = hs.mouse.getAbsolutePosition()
        mp['x'] = p.x
        mp['y'] = p.y
    end
    local e = evte.newMouseEvent(mode, mp)
    if mode == 6 then cs = 0 else cs = 1 end
    e:setProperty(evte.properties.mouseEventClickState, cs)
    e:post()
end

hs.hotkey.bind({ "alt" }, "d",
    function(event)
        post_evt(1)
        handle_drag:start()
    end
)





hs.hotkey.bind('ctrl', '1', nil, function() hs.window.filter.switchedToSpace(1) end)

--#region move_to_space_fast
-- idea here is: find window on next space and focus it
-- problems: hammerspoon is too annoying, and it thinks that litterally everything is a window

--- same as `move_to_space` but attempts to shorten the **annoying** animation
---@param direction 1 | -1
local function move_to_space_fast(direction)
    -- find only spaces on the current screen
    ---@type number[]
    local spaces = hs.spaces.allSpaces()[hs.screen.mainScreen():getUUID()]

    ---@type number
    local currentSpaceID = hs.spaces.focusedSpace()

    local spaceIndex = find(spaces, currentSpaceID) -- I defined this 'find' above

    local targetSpaceID = spaces[spaceIndex + direction]

    ---@type number[]
    local windows_there = hs.spaces.windowsForSpace(targetSpaceID)
    for index, value in ipairs(windows_there) do
        print(hs.window.find(value))
    end
    local windows_here = hs.spaces.windowsForSpace(currentSpaceID)
    local unique_apps = {}

    -- for _, id in ipairs(windows_there) do
    --     local unique = true
    --     -- this is hs.window
    --     local there = hs.window.find(id)
    --     for _, id2 in ipairs(windows_here) do
    --         local here = hs.window.find(id2)
    --         if here:application():bundleID() == there:application():bundleID() then
    --             unique = false
    --             break
    --         end
    --     end
    --     if unique then
    --         -- unique_apps[#unique_apps + 1] = there:application():bundleID()
    --         unique_apps[#unique_apps + 1] = there
    --     end
    -- end
    -- print(windows)
    if unique_apps[1] then
        print(unique_apps[1]:name())
        unique_apps[1]:focus()
        -- local window = hs.window.find(windows[1])
        -- print(window)
        -- print(window:application():name())
        -- hs.application.launchOrFocusByBundleID(window:application():bundleID())
        -- -- print(window:application():activate())
        -- -- print(window:focus())
    else
        local translate = { [1] = "right", [-1] = "left" }
        move_to_space(translate[direction])
        -- hs.spaces.gotoSpace(targetSpace)
    end
end
--#endregion
