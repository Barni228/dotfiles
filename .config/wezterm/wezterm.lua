-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local fonts = {
	-- {
	-- 	family = "OpenDyslexicM Nerd Font Mono",
	-- 	weight = "Medium",
	-- 	stretch = "SemiExpanded",
	-- 	style = "Italic",
	-- },
	-- { "Symbol", 17 },
	-- { "FiraCode Nerd Font", 19 },
	{
		{
			family = "FiraCode Nerd Font",
			harfbuzz_features = { "ss05", "ss03", "cv30", "ss02", "ss08" }, -- enable ligatures
			-- "@", "&", "|", "<= >=", "== === != !=="
		},
		19,
	},
	{ "ComicShannsMono Nerd Font", 20 },
	{ "JetBrainsMono Nerd Font", 19 },
	{ "CaskaydiaCove Nerd Font", 19 },
	{ "Hack Nerd Font", 19 },
}
local font_i = 0
-- This is where you actually apply your config choices -> @ &

-- For example, changing the color scheme:
-- config.cursor_blink_ease_in = "Constant" |--| ---------> === =========> =>   => <= >= <>
-- config.cursor_blink_ease_out = "Constant" -> |--| === => ==> != == <= >=

-- Key bindings to adjust font size without affecting the window size
-- config.keys = {
-- 	keys = {
-- config.color_scheme = "TwoDark++"

wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "font-size" then
		window:set_config_overrides({
			font_size = tonumber(value),
		})
	elseif name == "fullscreen" then
		window:perform_action(wezterm.action.ToggleFullScreen, pane)
	end
end)

config.window_background_gradient = {
	orientation = "Vertical",
	colors = {
		"#1e1f20",
		"#1e1f25",
		"#1e1f2a",
	},
}

config.colors = {
	cursor_bg = "#9a9faa",
	cursor_border = "#9a9faa",
	cursor_fg = "#1d222b", -- Optional: Set the cursor text color
	background = "#1d222b",
}
config.font_size = 19.0
config.font = wezterm.font(fonts[1][1])
config.window_background_opacity = 0.97
config.integrated_title_button_style = "MacOsNative"
config.window_decorations = "RESIZE" -- Enables resizing borders
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.initial_cols = 120
config.initial_rows = 34
config.animation_fps = 30
config.macos_window_background_blur = 10
config.keys = {
	-- Bind Ctrl+Option+F to change the font
	{
		key = "f",
		mods = "CTRL|OPT",
		action = wezterm.action_callback(function(window, pane)
			font_i = font_i % #fonts + 1
			-- Change the font to your desired font with fallback
			window:set_config_overrides({
				font = wezterm.font_with_fallback({
					fonts[font_i][1],
					"Hack Nerd Font", -- Fallback font
				}),
				font_size = fonts[font_i][2],
			})
		end),
	},
	{
		key = "f",
		mods = "CTRL|OPT|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			font_i = font_i % #fonts - 1
			-- Change the font to your desired font with fallback
			window:set_config_overrides({
				font = wezterm.font_with_fallback({
					fonts[font_i][1],
					"Hack Nerd Font", -- Fallback font
				}),
				font_size = fonts[font_i][2],
			})
		end),
	},
}

-- 		{
-- 			mods = "CTRL|SHIFT",
-- 			key = "i",
-- 			action = wezterm.action_callback(function(win, pane)
-- 				wezterm.log_info("Hello from callback!")
-- 				wezterm.log_info("WindowID:", win:window_id(), "PaneID:", pane:pane_id())
-- 			end),
-- 		},
-- 	},
-- }

-- and finally, return the configuration to wezterm

-- return {
--
-- 	keys = {
-- 		{
-- 			key = "Delete",
-- 			action = wezterm.action_callback(function()
-- 				-- wezterm.write("\027[3;5~") -- Send the forward delete escape sequence
-- 				wezterm.write("hi")
-- 			end),
-- 		},
-- 	},
-- }
return config
