local Activity_findBack = {
  {
    id = {
      ForbiddenEmpty,
      ForbiddenBlank
    },
    livelyId = {
      ForbiddenEmpty,
      ForbiddenBlank
    },
    condition = "AllowEmpty#ForbiddenBlank",
    cost = "ForbiddenEmpty#ForbiddenBlank",
    reward = {
      AllowEmpty,
      ForbiddenBlank
    },
    showIcon = "AllowEmpty#ForbiddenBlank",
    showName = "AllowEmpty#ForbiddenBlank",
    showDesc = "AllowEmpty#ForbiddenBlank"
  },
  {
    id = id,
    livelyId = livelyId,
    condition = "condition",
    cost = "cost",
    reward = reward,
    showIcon = "showIcon",
    showName = "showName",
    showDesc = "showDesc"
  },
  {
    id = 11001,
    livelyId = 1001,
    showName = "\229\135\187\230\157\128<color=#3CD937>\232\156\152\232\155\155</color>",
    showDesc = "\229\135\187\230\157\128<color=#3CD937>\232\156\152\232\155\155</color>"
  },
  {
    id = 11002,
    livelyId = 1002,
    showName = "\229\135\187\230\157\128<color=#3CD937>\229\185\188\233\190\153</color>",
    showDesc = "\229\135\187\230\157\128<color=#3CD937>\229\185\188\233\190\153</color>"
  },
  {
    id = 11003,
    livelyId = 1003,
    showName = "\229\135\187\230\157\128<color=#3CD937>\231\137\155\230\128\170</color>",
    showDesc = "\229\135\187\230\157\128<color=#3CD937>\231\137\155\230\128\170</color>"
  },
  {
    id = 11004,
    livelyId = 1004,
    showName = "\229\135\187\230\157\128<color=#3CD937>\231\140\142\231\138\172\230\128\170</color>",
    showDesc = "\229\135\187\230\157\128<color=#3CD937>\231\140\142\231\138\172\230\128\170</color>"
  },
  {
    id = 11005,
    livelyId = 1005,
    showName = "\229\135\187\230\157\128<color=#3CD937>\232\155\174\231\137\155\230\128\170</color>",
    showDesc = "\229\135\187\230\157\128<color=#3CD937>\232\155\174\231\137\155\230\128\170</color>"
  }
}
local defaults = {
  condition = "101#1",
  cost = "1000010#100&1000050#50",
  reward = {491001, 1},
  showIcon = ""
}
local mt = {__index = defaults}
for _, v in ipairs(Activity_findBack) do
  setmetatable(v, mt)
end
return Activity_findBack
