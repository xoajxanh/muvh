local cfg_Unit_unit = {
  {
    id = 100101,
    param = {
      totalTime = 1800000,
      state = 1,
      attribute = {experienceRate = 3000}
    }
  },
  {
    id = 100103,
    param = {
      totalTime = 86400000,
      state = 1,
      attribute = {experienceRate = 3000}
    }
  },
  {
    id = 100104,
    param = {
      totalTime = 604800000,
      state = 1,
      attribute = {experienceRate = 3000}
    }
  },
  {
    id = 100105,
    param = {
      totalTime = 43200000,
      state = 1,
      attribute = {experienceRate = 3000}
    }
  },
  {
    id = 100601,
    name = "Th\225\186\187 Buff EXP",
    type = 6,
    param = {
      totalTime = 300000,
      state = 1,
      attribute = {experienceRate = 2000}
    }
  },
  {
    id = 100602,
    name = "Th\225\186\187 Buff EXP Tr\225\187\159 L\225\186\161i",
    type = 21,
    param = {
      totalTime = 604800000,
      state = 1,
      attribute = {experienceRate = 2000}
    }
  },
  {
    id = 101101,
    name = "Th\225\186\187 B\225\186\163o H\225\187\153 Treo M\195\161y",
    type = 11,
    param = {
      totalTime = 7200000,
      state = 2,
      attribute = {hangUpProtection = 1}
    }
  },
  {
    id = 101102,
    name = "Th\225\186\187 B\225\186\163o H\225\187\153 Treo M\195\161y",
    type = 13,
    param = {
      totalTime = 7200000,
      state = 2,
      attribute = {hangUpProtection = 1}
    }
  },
  {
    id = 101401,
    name = "Th\225\186\187 C\195\160y V\195\160ng (Trung)",
    type = 18,
    param = {
      totalTime = 86400000,
      state = 1,
      attribute = {sellGoldUpRatio = 2500}
    }
  },
  {
    id = 101402,
    name = "Th\225\186\187 C\195\160y V\195\160ng (Cao)",
    type = 18,
    param = {
      totalTime = 86400000,
      state = 1,
      attribute = {sellGoldUpRatio = 5000}
    }
  },
  {
    id = 101403,
    name = "Th\225\186\187 C\195\160y V\195\160ng (C\225\187\177c)",
    type = 18,
    param = {
      totalTime = 86400000,
      state = 1,
      attribute = {sellGoldUpRatio = 10000}
    }
  },
  {
    id = 200103,
    name = "EXP Th\195\161nh L\225\187\177c g\225\186\165p b\225\187\153i",
    type = 20,
    param = {
      totalTime = 86400000,
      state = 1,
      attribute = {ringExperienceRate = 3000}
    }
  },
  {
    id = 200104,
    name = "EXP Th\195\161nh L\225\187\177c Tr\225\187\159 L\225\186\161i",
    type = 22,
    param = {
      totalTime = 604800000,
      state = 1,
      attribute = {ringExperienceRate = 2000}
    }
  }
}
local defaults = {
  name = "G\225\186\165p b\225\187\153i EXP",
  type = 1
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Unit_unit) do
  setmetatable(v, mt)
end
return cfg_Unit_unit
