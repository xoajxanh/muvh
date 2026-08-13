local cfg_Team3v3_Reward = {
  {
    id = 10001,
    type = 1,
    reward = 930001,
    previewType = 1,
    rewardPreview = 930001
  },
  {
    id = 20001,
    type = 2,
    reward = 930002,
    rewardTitle = "Th\198\176\225\187\159ng Tham Gia V\195\178ng Th\196\131ng H\225\186\161ng",
    previewType = 2,
    rewardPreview = 930002
  },
  {
    id = 30001,
    type = 3,
    reward = 930003,
    rewardTitle = "Th\198\176\225\187\159ng V\195\160o V\195\178ng 2 ",
    previewType = 3,
    rewardPreview = 930003
  },
  {
    id = 30002,
    type = 4,
    reward = 930004,
    rewardTitle = "Th\198\176\225\187\159ng V\195\160o V\195\178ng 3 ",
    previewType = 3,
    rewardPreview = 930004
  },
  {
    id = 30003,
    type = 5,
    reward = 930005,
    rewardTitle = "Th\198\176\225\187\159ng V\195\160o V\195\178ng 4 ",
    previewType = 3,
    rewardPreview = 930005
  },
  {
    id = 30004,
    type = 6,
    reward = 930006,
    rewardTitle = "Th\198\176\225\187\159ng V\195\160o TOP 16",
    previewType = 3,
    rewardPreview = 930006
  },
  {
    id = 30005,
    type = 7,
    reward = 930007,
    rewardTitle = "Th\198\176\225\187\159ng V\195\160o TOP 8",
    previewType = 3,
    rewardPreview = 930007
  },
  {
    id = 30006,
    type = 8,
    reward = 930008,
    rewardTitle = "Th\198\176\225\187\159ng V\195\160o TOP 4",
    previewType = 3,
    rewardPreview = 930008
  },
  {
    id = 30007,
    type = 9,
    reward = 0,
    previewType = 3,
    rewardPreview = 0
  },
  {
    id = 40001,
    type = 11,
    reward = 930010,
    previewType = 4,
    rewardPreview = 930010
  },
  {
    id = 40002,
    type = 12,
    reward = 930011,
    previewType = 4,
    rewardPreview = 930011
  },
  {
    id = 40003,
    type = 13,
    reward = 930012,
    previewType = 4,
    rewardPreview = 930012
  },
  {
    id = 40004,
    type = 14,
    reward = 930013,
    previewType = 4,
    rewardPreview = 930013
  },
  {
    id = 40005,
    type = 15,
    reward = 930014,
    previewType = 4,
    rewardPreview = 930014
  },
  {
    id = 40006,
    type = 16,
    reward = 930015,
    previewType = 4,
    rewardPreview = 930015
  },
  {
    id = 40007,
    type = 17,
    reward = 930016,
    previewType = 4,
    rewardPreview = 930016
  },
  {
    id = 50001,
    type = 27,
    reward = 930026,
    rewardTitle = "Th\198\176\225\187\159ng Qu\195\161n Qu\195\162n",
    rewardPreview = 930026
  },
  {
    id = 50002,
    type = 26,
    reward = 930025,
    rewardTitle = "Th\198\176\225\187\159ng \195\129 Qu\195\162n",
    rewardPreview = 930025
  },
  {
    id = 50003,
    type = 25,
    reward = 930024,
    rewardTitle = "Th\198\176\225\187\159ng Qu\195\189 Qu\195\162n",
    rewardPreview = 930024
  },
  {
    id = 50004,
    type = 24,
    reward = 930023,
    rewardTitle = "Th\198\176\225\187\159ng Top 4",
    rewardPreview = 930023
  },
  {
    id = 50005,
    type = 23,
    reward = 930022,
    rewardTitle = "Th\198\176\225\187\159ng Top 8",
    rewardPreview = 930022
  },
  {
    id = 50006,
    type = 22,
    reward = 930021,
    rewardTitle = "Th\198\176\225\187\159ng Top 16",
    rewardPreview = 930021
  },
  {
    id = 50007,
    type = 21,
    reward = 930020,
    rewardTitle = "Th\198\176\225\187\159ng Th\196\131ng H\225\186\161ng - V\195\178ng 4",
    rewardPreview = 930020
  },
  {
    id = 50008,
    type = 20,
    reward = 930019,
    rewardTitle = "Th\198\176\225\187\159ng Th\196\131ng H\225\186\161ng - V\195\178ng 3",
    rewardPreview = 930019
  },
  {
    id = 50009,
    type = 19,
    reward = 930018,
    rewardTitle = "Th\198\176\225\187\159ng Th\196\131ng H\225\186\161ng - V\195\178ng 2",
    rewardPreview = 930018
  },
  {
    id = 50010,
    type = 18,
    reward = 0,
    rewardPreview = 0
  }
}
local defaults = {rewardTitle = "", previewType = 5}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Team3v3_Reward) do
  setmetatable(v, mt)
end
return cfg_Team3v3_Reward
