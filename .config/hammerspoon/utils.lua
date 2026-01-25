---@param t number[]
---@param value number
---@return integer|nil
local function find(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
end


---@param direction "left" | "right"
---@return nil
local function move_to_space(direction)
    assert(direction == "left" or direction == "right", "direction must be 'left' or 'right'")

    local key = hs.keycodes.map[direction]

    -- tell "System Events" that ctrl left/right is pressed
    -- so for this to work, ctrl left/right must be bound to move to different space (default)
    hs.osascript.applescript(string.format([[
        tell application "System Events"
            key code %d using control down
        end tell
    ]], key))
end

---@param direction number
local function move_to_space_weird(direction)
    ---@type string
    local screen_uuid = hs.screen.mainScreen():getUUID()

    ---@type table<string, number[]>
    local all_spaces = hs.spaces.allSpaces()

    -- find only spaces on the current screen
    local spaces = all_spaces[screen_uuid]

    ---@type number
    local currentSpaceID = hs.spaces.focusedSpace()

    ---@type number | nil
    local spaceIndex = find(spaces, currentSpaceID) -- I defined this 'find' above

    -- Calculate the index needed space
    local targetIndex = spaceIndex + direction
    -- if prevIndex < 1 then
    --     prevIndex = #spaces[screen_uuid]
    -- end
    local targetSpaceID = spaces[targetIndex]
    if targetSpaceID then
        hs.spaces.gotoSpace(targetSpaceID)
    else
        -- hs.sound.getByName("Ping"):play()
        hs.osascript.applescript('beep')
    end
end

return {
    find = find,
    move_to_space = move_to_space,
    move_to_space_weird = move_to_space_weird,
}
