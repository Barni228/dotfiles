-- this code works as well as it can, but hammerspoon cannot really simulate mouse dragging well
-- so just use karabiner elements for this (simple modifications > button4 -> button3)

-- local time = hs.timer.secondsSinceEpoch()

-- DOWN = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown, hs.eventtap.event.types.otherMouseUp }, function(e)
--     if e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) ~= 3 then
--         return false
--     end

--     local event = hs.eventtap.event.newMouseEvent(e:getType(), hs.mouse.absolutePosition(), 2)
--     event:setProperty(hs.eventtap.event.properties.mouseEventClickState, 1)

--     event:post()
--     if e:getType() == hs.eventtap.event.types.otherMouseDown then
--         DRAGGED:start()
--     elseif e:getType() == hs.eventtap.event.types.otherMouseUp then
--         DRAGGED:stop()
--     end
--     return true
--     --     print("down")
--     --     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseDragged, pos, 2):post()
--     -- elseif e:getType() == hs.eventtap.event.types.otherMouseUp then
--     --     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseDragged, pos, 2):post()
--     --     -- print("up")
--     -- end
-- end)
-- DOWN:start()

-- DRAGGED = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDragged }, function(e)
--     if e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) ~= 3 then
--         return false
--     end

--     if time - hs.timer.secondsSinceEpoch() < 0.1 then return false end
--     time = hs.timer.secondsSinceEpoch()


--     local pos = hs.mouse.absolutePosition()
--     local event = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseDragged, pos, 2)
--     event:setProperty(hs.eventtap.event.properties.mouseEventClickState, 0)
--     event:post()

--     return true -- swallow original clicked
-- end)








-- t = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, function(e)
--     if e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) == 3 then
--         hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.getAbsolutePosition()):post()
--         hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.getAbsolutePosition()):post()
--         return true -- swallow original click
--     end
--     return false
-- end)
-- t:start()

-- T = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown }, function(e)
--     if e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) == 3 then
--         -- hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.getAbsolutePosition()):post()
--         -- hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.getAbsolutePosition()):post()
--         return true -- swallow original click
--     end
--     return false
-- end)
-- T:start()

-- button 4 → middle click
-- BUTTON4TAP = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown, hs.eventtap.event.types.otherMouseUp },
--     function(e)
--         local button = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
--         local pos = hs.mouse.getAbsolutePosition()

--         if button == 4 then -- button 4 pressed
--             print("4")
--             if e:getType() == hs.eventtap.event.types.otherMouseDown then
--                 print("down")
--                 local pos = hs.mouse.getAbsolutePosition()
-- hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseDown, pos, 2):post()
-- hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseUp, pos, 2):post()
--                 hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.middleMouseDown, pos):post()
--             elseif e:getType() == hs.eventtap.event.types.otherMouseUp then
--                 print("up")
--                 hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.middleMouseUp, pos):post()
--             end
--             return true -- swallow original button 4 event
--         end
--         return false
--     end)

-- BUTTON4TAP:start()










-- HANDLE_DRAG = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function(e)
--     -- if e:getProperty(hs.eventtap.event.properties.mouseEventClickState) == 1 then
--     --     local p = hs.mouse.absolutePosition()
--     --     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, p):post()
--     --     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, p):post()
--     --     return true -- swallow original click
--     -- end
--     -- return false
-- end)
-- -- spell:disable
-- hs.alert.show("Config loaded")

-- local now = hs.timer.secondsSinceEpoch

-- local evte = hs.eventtap.event
-- local evtypes = hs.eventtap.event.types
-- local evp = evte.properties

-- local drag_last = now()
-- local drag_intv = 0.01

-- local mouse_pos = { ['x'] = 0, ['y'] = 0 } -- mouse point. coords and last posted event
-- -- local l = hs.logger.new('keybmouse', 'debug')
-- -- local dmp = hs.inspect

-- -- The event tap. Started with the keyboard click:
-- local handled = { evtypes.mouseMoved, evtypes.keyUp }
-- handle_drag = hs.eventtap.new(handled, function(e)
--     if e:getType() == evtypes.keyUp then
--         handle_drag:stop()
--         post_evt(2)
--         return nil -- otherwise the up seems not processed by the OS
--     end

--     mouse_pos['x'] = mouse_pos['x'] + e:getProperty(evp.mouseEventDeltaX)
--     mouse_pos['y'] = mouse_pos['y'] + e:getProperty(evp.mouseEventDeltaY)

--     -- giving the key up a chance:
--     if now() - drag_last > drag_intv then
--         -- l.d('pos', mp.x, 'dx', dx)
--         post_evt(6) -- that sometimes makes dx negative in the log above
--         drag_last = now()
--     end
--     return true -- important
-- end)

-- function post_evt(mode)
--     -- 1: down, 2: up, 6: drag
--     if mode == 1 or mode == 2 then
--         local p = hs.mouse.absolutePosition()
--         mouse_pos['x'] = p.x
--         mouse_pos['y'] = p.y
--     end
--     -- local e = hs.eventtap.event.newMouseEvent(mode, mouse_pos)
--     local e
--     if mode == 6 then
--         e = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseDragged, mouse_pos, 2)
--     elseif mode == 1 then
--         e = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseDown, mouse_pos, 2)
--     elseif mode == 2 then
--         e = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseUp, mouse_pos, 2)
--     end
--     -- local e = hs.eventtap.event.newMouseEvent(mode, mouse_pos, 2)
--     local cs
--     if mode == 6 then
--         cs = 0
--     else
--         cs = 1
--     end
--     e:setProperty(evte.properties.mouseEventClickState, cs)
--     e:post()
-- end

-- hs.hotkey.bind({ "alt" }, "d",
--     function(event)
--         post_evt(1)
--         handle_drag:start()
--     end
-- )
