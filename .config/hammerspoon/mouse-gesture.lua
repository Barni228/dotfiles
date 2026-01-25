-- on my mouse, the good button when pressed instantly sends <C-up> key event pressed and released
-- so when i release it nothing happens, because it pressed and released immediately
-- so here, when i press <C-up> (ctrl up), I check where the mouse moves after `delay`
-- and if it moved more than `distance` pixels in some direction, I call corresponding direction function
-- if it didn't move more that `distance`, I call `pressed`

local utils = require("utils")


--#region Important stuff
local delay = 0.1
local distance = 8


local function up()
    -- there is also toggleMissionControl
    hs.spaces.openMissionControl()
end


local function right()
    -- when my mouse went right, i want this to move to to left space, because it feels more natural
    utils.move_to_space("left")
end


local function down()
    hs.spaces.closeMissionControl()
end

local function left()
    utils.move_to_space("right")
end


local function pressed()
    hs.spaces.toggleShowDesktop()
end
--#endregion Important stuff


--#region Implementation logic
local function determine_movement(init_pos)
    local pos = hs.mouse.absolutePosition()
    local dx = pos.x - init_pos.x
    local dy = pos.y - init_pos.y

    -- if we moved x more than y, so diagonals don't run two directions at once
    if math.abs(dx) > math.abs(dy) then
        if dx > distance then
            right()
        elseif dx < -distance then
            left()
        else
            pressed()
        end
    else
        if dy > distance then
            down()
        elseif dy < -distance then
            up()
        else
            pressed()
        end
    end
end

PRESS_EVENT = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    local flags = e:getFlags()
    local keyCode = e:getKeyCode()

    if flags.ctrl and keyCode == hs.keycodes.map.up then
        local pos = hs.mouse.absolutePosition()
        -- this will start the timer, but will not wait until it finishes (so this returns immediately)
        hs.timer.doAfter(delay, function()
            determine_movement(pos)
        end)
        return true
    end
    return false
end)
PRESS_EVENT:start()
--#endregion Implementation logic
