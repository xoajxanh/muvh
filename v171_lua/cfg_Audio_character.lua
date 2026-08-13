local cfg_Audio_character = {
  [11] = {career = 11},
  [21] = {career = 21},
  [31] = {career = 31},
  [41] = {career = 41},
  [12] = {career = 12},
  [22] = {career = 22},
  [32] = {career = 32},
  [42] = {career = 42},
  [13] = {
    career = 13,
    hitAudios = "6201#6202",
    die = 6203
  },
  [23] = {
    career = 23,
    hitAudios = "6201#6202",
    die = 6203
  },
  [33] = {
    career = 33,
    hitAudios = "6201#6202",
    die = 6203
  },
  [43] = {
    career = 43,
    hitAudios = "6201#6202",
    die = 6203
  },
  [14] = {career = 14},
  [24] = {career = 24},
  [34] = {career = 34},
  [44] = {career = 44},
  [16] = {
    career = 16,
    hitAudios = "6201#6202",
    die = 6203
  },
  [26] = {
    career = 26,
    hitAudios = "6201#6202",
    die = 6203
  },
  [36] = {
    career = 36,
    hitAudios = "6201#6202",
    die = 6203
  },
  [46] = {
    career = 46,
    hitAudios = "6201#6202",
    die = 6203
  }
}
local defaults = {
  hitAudios = "6101#6102#6103",
  die = 6104
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Audio_character) do
  setmetatable(v, mt)
end
return cfg_Audio_character
