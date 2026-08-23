local cfg_Commerce_RegularUpdates = {
  [1] = {
    id = 1,
    taskId = 750001,
    giftId = 750001,
    sort = 1
  },
  [2] = {
    id = 2,
    taskId = 750002,
    giftId = 750002,
    sort = 2
  },
  [3] = {
    id = 3,
    taskId = 750003,
    giftId = 750003,
    sort = 3
  },
  [4] = {
    id = 4,
    taskId = 750004,
    giftId = 750004,
    sort = 4
  },
  [5] = {
    id = 5,
    taskId = 750005,
    giftId = 750005,
    sort = 5
  },
  [6] = {
    id = 6,
    taskId = 750006,
    giftId = 750006,
    sort = 6
  },
  [7] = {
    id = 7,
    taskId = 750007,
    giftId = 750007,
    sort = 7
  },
  [8] = {
    id = 8,
    activityId = 111002,
    taskId = 750101,
    giftId = 750101,
    sort = 1
  },
  [9] = {
    id = 9,
    activityId = 111002,
    taskId = 750102,
    giftId = 750102,
    sort = 2
  },
  [10] = {
    id = 10,
    activityId = 111002,
    taskId = 750103,
    giftId = 750103,
    sort = 3
  },
  [11] = {
    id = 11,
    activityId = 111002,
    taskId = 750104,
    giftId = 750104,
    sort = 4
  },
  [12] = {
    id = 12,
    activityId = 111002,
    taskId = 750105,
    giftId = 750105,
    sort = 5
  },
  [13] = {
    id = 13,
    activityId = 111002,
    taskId = 750106,
    giftId = 750106,
    sort = 6
  },
  [14] = {
    id = 14,
    activityId = 111002,
    taskId = 750107,
    giftId = 750107,
    sort = 7
  }
}
local defaults = {activityId = 111001}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_RegularUpdates) do
  setmetatable(v, mt)
end
return cfg_Commerce_RegularUpdates
