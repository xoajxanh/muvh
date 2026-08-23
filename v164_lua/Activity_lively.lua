local Activity_lively = {
  ["ForbiddenEmpty#ForbiddenBlank"] = {
    id = {
      ForbiddenEmpty,
      ForbiddenBlank
    },
    goalId = {
      ForbiddenEmpty,
      ForbiddenBlank
    },
    times = {
      ForbiddenEmpty,
      ForbiddenBlank
    },
    getLively = {
      ForbiddenEmpty,
      ForbiddenBlank
    },
    type = {
      AllowEmpty,
      ForbiddenBlank
    },
    sort = {
      AllowEmpty,
      ForbiddenBlank
    },
    showIcon = "AllowEmpty#ForbiddenBlank",
    showName = "AllowEmpty#ForbiddenBlank",
    showDesc = "AllowEmpty#ForbiddenBlank",
    toFunction = "AllowEmpty#ForbiddenBlank",
    functionId = {
      AllowEmpty,
      ForbiddenBlank
    },
    showRequire = "AllowEmpty#ForbiddenBlank"
  },
  id = {
    id = id,
    goalId = goalId,
    times = times,
    getLively = getLively,
    type = type,
    sort = sort,
    showIcon = "showIcon",
    showName = "showName",
    showDesc = "showDesc",
    toFunction = "toFunction",
    functionId = functionId,
    showRequire = "showRequire"
  },
  [1001] = {
    id = 1001,
    goalId = 8000008,
    times = 1,
    getLively = 20,
    sort = 6,
    showIcon = "ac_hjg",
    showName = "\230\136\152\231\155\159BOSS",
    showDesc = "\229\143\130\229\138\160\228\184\128\230\172\161<color=#3CD937>\230\136\152\231\155\159BOSS</color>",
    toFunction = "4010003",
    functionId = 10030003,
    showRequire = "\231\173\137\231\186\167\232\190\190\229\136\176100\231\186\167\229\188\128\230\148\190"
  },
  [1002] = {
    id = 1002,
    goalId = 8000002,
    times = 10,
    sort = 5,
    showIcon = "ac_ywboss",
    showName = "\233\135\142\229\164\150BOSS",
    showDesc = "\229\135\187\230\157\128\228\184\128\230\172\161<color=#3CD937>\233\135\142\229\164\150BOSS</color>",
    toFunction = "2440101",
    functionId = 2440002,
    showRequire = "\231\173\137\231\186\167\232\190\190\229\136\17640\231\186\167\229\188\128\230\148\190"
  },
  [1003] = {
    id = 1003,
    goalId = 8000003,
    sort = 2,
    showIcon = "ac_grboss",
    showName = "\231\167\152\229\162\131BOSS",
    showDesc = "\229\135\187\230\157\128\228\184\128\230\172\161<color=#3CD937>\231\167\152\229\162\131BOSS</color>",
    toFunction = "2440702",
    functionId = 2440007,
    showRequire = "\231\173\137\231\186\167\232\190\190\229\136\17630\231\186\167\229\188\128\230\148\190"
  },
  [1004] = {
    id = 1004,
    goalId = 8000004,
    sort = 3,
    showIcon = "ac_xscb",
    showName = "\232\161\128\232\137\178\229\159\142\229\160\161",
    showDesc = "\229\174\140\230\136\144\228\184\128\230\172\161<color=#3CD937>\232\161\128\232\137\178\229\159\142\229\160\161</color>",
    toFunction = "-1",
    functionId = 4020301,
    showRequire = "\229\174\140\230\136\144\231\155\184\229\186\148\230\148\175\231\186\191\228\187\187\229\138\161"
  },
  [1005] = {
    id = 1005,
    goalId = 8000005,
    sort = 4,
    showIcon = "ac_emgc",
    showName = "\230\129\182\233\173\148\229\185\191\229\156\186",
    showDesc = "\229\174\140\230\136\144\228\184\128\230\172\161<color=#3CD937>\230\129\182\233\173\148\229\185\191\229\156\186</color>",
    toFunction = "-1",
    functionId = 4020201,
    showRequire = "\231\173\137\231\186\167\232\190\190\229\136\17660\231\186\167\229\188\128\230\148\190"
  },
  [1006] = {
    id = 1006,
    goalId = 8000006,
    sort = 1,
    showIcon = "ac_ysrw",
    showName = "\229\139\135\229\163\171\228\187\187\229\138\161",
    showDesc = "\229\174\140\230\136\144\228\184\128\230\172\161<color=#3CD937>\229\139\135\229\163\171\228\187\187\229\138\161</color>",
    toFunction = "2480100",
    functionId = 2480001,
    showRequire = "\231\173\137\231\186\167\232\190\190\229\136\176110\231\186\167\229\188\128\230\148\190"
  },
  [1007] = {
    id = 1007,
    goalId = 8000009,
    times = 1,
    getLively = 20,
    sort = 7,
    showIcon = "ac_hllx",
    showName = "\231\129\171\233\190\153\230\157\165\232\162\173",
    showDesc = "\229\143\130\229\138\160\228\184\128\230\172\161<color=#3CD937>\231\129\171\233\190\153\230\157\165\232\162\173</color>",
    toFunction = "4010003",
    functionId = 4021001,
    showRequire = "\231\173\137\231\186\167\232\190\190\229\136\176100\231\186\167\229\188\128\230\148\190"
  }
}
local defaults = {
  times = 3,
  getLively = 5,
  type = 1
}
local mt = {__index = defaults}
for _, v in pairs(Activity_lively) do
  setmetatable(v, mt)
end
return Activity_lively
