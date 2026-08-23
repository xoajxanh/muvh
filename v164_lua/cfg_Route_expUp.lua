local cfg_Route_expUp = {
  {
    id = 1001,
    expUpType = "Buff Th\225\187\167 H\225\187\153",
    route = "236010106",
    type = 1,
    condition = "103#0",
    order = 0
  },
  {
    id = 1002,
    expUpType = "VIP c\225\187\153ng th\195\170m",
    route = "2540102",
    condition = "103#0",
    order = 1
  },
  {
    id = 1003,
    expUpType = "Buff EXP",
    route = "4012011",
    type = 2,
    type2 = 1,
    order = 2
  },
  {
    id = 1004,
    expUpType = "Buff Danh Hi\225\187\135u",
    order = 3
  },
  {
    id = 1005,
    expUpType = "EXP Th\225\186\191 Gi\225\187\155i",
    order = 4
  },
  {
    id = 1006,
    expUpType = "EXP Ng\195\160y L\225\187\133",
    order = 5
  },
  {
    id = 1007,
    expUpType = "EXP \196\145a t\195\161c d\225\187\165ng",
    order = 6
  },
  {
    id = 1008,
    expUpType = "Buff B\225\186\163n \196\144\225\187\147",
    route = "2540103",
    type = 8,
    condition = "3101#1",
    type2 = 1,
    order = 7
  },
  {
    id = 1009,
    expUpType = "Buff Th\195\161nh L\225\187\177c",
    route = "240000002",
    type = 2,
    condition = "101#1201",
    type2 = 1,
    order = 8
  }
}
local defaults = {
  route = "",
  type = 9,
  condition = "101#40",
  type2 = 2
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Route_expUp) do
  setmetatable(v, mt)
end
return cfg_Route_expUp
