local cfg_union_member = {
  {
    id = 1,
    level = 5,
    desc = "Tr\198\176\225\187\159ng Guild",
    hr = 1,
    reg = 1,
    post = 1,
    changeName = 1,
    leader = 1,
    newjob = 1,
    activity = 1,
    limit = 1,
    impeach = 0,
    autokick = 0,
    makeEnemy = 1,
    joinCamp = 1
  },
  {
    id = 2,
    level = 4,
    desc = "Ph\195\179 Guild",
    hr = 1,
    reg = 1,
    post = 1,
    newjob = 1,
    activity = 1,
    limit = 1,
    autokick = 0
  },
  {
    id = 3,
    level = 3,
    desc = "\196\144\225\187\153i Tr\198\176\225\187\159ng",
    hr = 1,
    reg = 1,
    post = 0,
    newjob = 0,
    activity = 0,
    limit = 4,
    autokick = 0
  },
  {
    id = 4,
    level = 2,
    desc = "Tinh Anh",
    hr = 0,
    reg = 0,
    post = 0,
    newjob = 0,
    activity = 0,
    limit = 8,
    autokick = 1
  },
  {
    id = 5,
    level = 1,
    desc = "Th\195\160nh vi\195\170n",
    hr = 0,
    reg = 0,
    post = 0,
    newjob = 0,
    activity = 0,
    limit = 0,
    autokick = 1
  }
}
local defaults = {
  changeName = 0,
  leader = 0,
  impeach = 1,
  makeEnemy = 0,
  joinCamp = 0
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_union_member) do
  setmetatable(v, mt)
end
return cfg_union_member
