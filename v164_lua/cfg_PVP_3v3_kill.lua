local cfg_PVP_3v3_kill = {
  {
    id = 640001,
    killId = 1,
    type = 0,
    position = "B",
    chatId = 17011
  },
  {
    id = 640002,
    killId = 2,
    type = 1,
    position = "D",
    chatId = 17002
  },
  {
    id = 640003,
    killId = 3,
    type = 1,
    position = "E",
    chatId = 17003
  },
  {
    id = 640004,
    killId = 4,
    type = 1,
    position = "N",
    chatId = 17004
  },
  {
    id = 640005,
    killId = 5,
    type = 1,
    position = "O",
    chatId = 17005
  },
  {
    id = 640006,
    killId = 1,
    type = 10,
    position = "C",
    chatId = 17001
  },
  {
    id = 640009,
    killId = 3,
    position = "F",
    chatId = 17007
  },
  {
    id = 640010,
    killId = 4,
    position = "F",
    chatId = 17007
  },
  {
    id = 640011,
    killId = 5,
    position = "H",
    chatId = 17008
  },
  {
    id = 640012,
    killId = 6,
    position = "H",
    chatId = 17008
  },
  {
    id = 640013,
    killId = 7,
    position = "G",
    chatId = 17009
  },
  {
    id = 640014,
    killId = 8,
    position = "G",
    chatId = 17009
  },
  {
    id = 640015,
    killId = 9,
    position = "M",
    chatId = 17010
  }
}
local defaults = {type = 2}
local mt = {__index = defaults}
for _, v in ipairs(cfg_PVP_3v3_kill) do
  setmetatable(v, mt)
end
return cfg_PVP_3v3_kill
