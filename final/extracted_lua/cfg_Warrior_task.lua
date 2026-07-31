local cfg_Warrior_task = {
  [40001] = {taskId = 40001},
  [40002] = {taskId = 40002},
  [40003] = {taskId = 40003},
  [40004] = {taskId = 40004},
  [40005] = {taskId = 40005},
  [40006] = {taskId = 40006},
  [40007] = {taskId = 40007},
  [40008] = {taskId = 40008},
  [40009] = {taskId = 40009},
  [40010] = {taskId = 40010},
  [40011] = {taskId = 40011},
  [40012] = {taskId = 40012},
  [40013] = {taskId = 40013},
  [40014] = {taskId = 40014},
  [40015] = {taskId = 40015},
  [40016] = {taskId = 40016},
  [40017] = {taskId = 40017},
  [40018] = {taskId = 40018},
  [40019] = {taskId = 40019},
  [40020] = {taskId = 40020},
  [40021] = {taskId = 40021},
  [40022] = {taskId = 40022},
  [40023] = {taskId = 40023},
  [40024] = {taskId = 40024},
  [40025] = {taskId = 40025},
  [40026] = {taskId = 40026},
  [40027] = {taskId = 40027},
  [40028] = {taskId = 40028},
  [40029] = {taskId = 40029},
  [40030] = {taskId = 40030},
  [40031] = {taskId = 40031},
  [40032] = {taskId = 40032},
  [40033] = {taskId = 40033},
  [40034] = {taskId = 40034},
  [40035] = {taskId = 40035},
  [40036] = {taskId = 40036},
  [40037] = {taskId = 40037},
  [40038] = {taskId = 40038},
  [40039] = {taskId = 40039},
  [40040] = {taskId = 40040}
}
local defaults = {navi = ""}
local mt = {__index = defaults}
for _, v in pairs(cfg_Warrior_task) do
  setmetatable(v, mt)
end
return cfg_Warrior_task
