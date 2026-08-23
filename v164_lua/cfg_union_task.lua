local cfg_union_task = {
  [2002] = {
    id = 2002,
    goalId = 2402001,
    completeCondition = "1602#2002#1",
    navi = ""
  },
  [2003] = {
    id = 2003,
    goalId = 2403001,
    completeCondition = "1602#2003#1",
    navi = ""
  },
  [2004] = {
    id = 2004,
    goalId = 2404001,
    completeCondition = "1602#2004#1",
    navi = "2480100"
  },
  [2005] = {
    id = 2005,
    goalId = 2405001,
    taskLv = "1",
    weight = 1,
    reward = "1000021#15000",
    unionExp = "6000",
    completeCondition = "1602#2005#1",
    navi = "4020601"
  },
  [2006] = {
    id = 2006,
    goalId = 2406001,
    completeCondition = "1602#2006#1",
    navi = "10000003"
  },
  [2008] = {
    id = 2008,
    goalId = 2408001,
    completeCondition = "1602#2008#1",
    navi = "10000003"
  },
  [2009] = {
    id = 2009,
    goalId = 2409001,
    taskLv = "1",
    weight = 1,
    reward = "1000021#15000",
    unionExp = "6000",
    completeCondition = "1602#2009#1",
    navi = "4020601"
  }
}
local defaults = {
  type = 2,
  taskLv = "2",
  weight = 2,
  reward = "1000021#10000",
  unionExp = "3000",
  unionFund = "",
  help = 2,
  helpReward = "",
  condition = "",
  autoFight = 1
}
local mt = {__index = defaults}
for _, v in pairs(cfg_union_task) do
  setmetatable(v, mt)
end
return cfg_union_task
