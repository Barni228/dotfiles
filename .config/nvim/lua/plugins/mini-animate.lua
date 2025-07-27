if true then return {} end

local anim = require "mini.animate"
anim.setup {
  scroll = {
    timing = anim.gen_timing.linear { duration = 7 },
    subscroll = anim.gen_subscroll.equal { max_output_steps = 12 },
  },
  cursor = {
    enable = false,
    timing = anim.gen_timing.linear { duration = 65, unit = "total" },
  },
}

return {}
