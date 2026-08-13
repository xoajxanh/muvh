local cfg_puzzle_entry = {
  [4029101] = {
    id = 4029101,
    excellType = 1,
    uiWordAttribute = "minimumPhysBaseDmg#66&maximumPhysBaseDmg#110&minimumWizBaseDmg#66&maximumWizBaseDmg#110&minimumCurseBaseDmg#66&maximumCurseBaseDmg#110",
    minimumPhysBaseDmg = 66,
    maximumPhysBaseDmg = 110,
    minimumWizBaseDmg = 66,
    maximumWizBaseDmg = 110,
    minimumCurseBaseDmg = 66,
    maximumCurseBaseDmg = 110
  },
  [4029102] = {
    id = 4029102,
    excellType = 1,
    uiWordAttribute = "defenseBase#70",
    defenseBase = 70
  },
  [4029103] = {
    id = 4029103,
    excellType = 1,
    uiWordAttribute = "career_maximumHealth&11#5000&12#3200&13#4000&14#3200&16#3200",
    career_maximumHealth = {
      {11, 5000},
      {12, 3200},
      {13, 4000},
      {14, 3200},
      {16, 3200}
    }
  },
  [5029101] = {
    id = 5029101,
    uiWordAttribute = "minimumPhysAndWizDmg_mul#20&maximumPhysAndWizDmg_mul#20",
    minimumPhysAndWizDmg_mul = 20,
    maximumPhysAndWizDmg_mul = 20
  },
  [5029102] = {
    id = 5029102,
    uiWordAttribute = "defenseBase_mul#20",
    defenseBase_mul = 20
  },
  [5029103] = {
    id = 5029103,
    uiWordAttribute = "maximumHealth_mul#20",
    maximumHealth_mul = 20
  },
  [5029104] = {
    id = 5029104,
    uiWordAttribute = "baseDefenseByLevel#400",
    baseDefenseByLevel = 400
  },
  [5029105] = {
    id = 5029105,
    uiWordAttribute = "physAndWizDmgLevel#400",
    physAndWizDmgLevel = 400
  },
  [5029106] = {
    id = 5029106,
    uiWordAttribute = "baseLifeByLevel#20000",
    baseLifeByLevel = 20000
  },
  [5029107] = {
    id = 5029107,
    uiWordAttribute = "excellentDamageChance#30",
    excellentDamageChance = 30
  },
  [5029108] = {
    id = 5029108,
    uiWordAttribute = "excellentDamageChanceResistance#30",
    excellentDamageChanceResistance = "30"
  },
  [5029109] = {
    id = 5029109,
    uiWordAttribute = "criticalDamageChance#30",
    criticalDamageChance = 30
  },
  [5029110] = {
    id = 5029110,
    uiWordAttribute = "criticalDamageBonusResistance#30",
    criticalDamageBonusResistance = "30"
  },
  [5029111] = {
    id = 5029111,
    uiWordAttribute = "attackRatePvm#1&attackRatePvp#1",
    attackRatePvm = 1,
    attackRatePvp = 1
  },
  [5029112] = {
    id = 5029112,
    uiWordAttribute = "defenseRatePvm#1&defenseRatePvp#1",
    defenseRatePvm = 1,
    defenseRatePvp = 1
  }
}
local defaults = {
  excellType = 2,
  attributeType = 1,
  excellentWight = 10,
  minimumPhysBaseDmg = 0,
  maximumPhysBaseDmg = 0,
  minimumWizBaseDmg = 0,
  maximumWizBaseDmg = 0,
  minimumCurseBaseDmg = 0,
  maximumCurseBaseDmg = 0,
  defenseBase = 0,
  minimumPhysAndWizDmg_mul = 0,
  maximumPhysAndWizDmg_mul = 0,
  defenseBase_mul = 0,
  maximumHealth_mul = 0,
  physAndWizDmgLevel = 0,
  baseDefenseByLevel = 0,
  baseLifeByLevel = 0,
  criticalDamageChance = 0,
  criticalDamageBonusResistance = "",
  excellentDamageChance = 0,
  excellentDamageChanceResistance = "",
  attackRatePvm = 0,
  attackRatePvp = 0,
  defenseRatePvm = 0,
  defenseRatePvp = 0
}
local mt = {__index = defaults}
for _, v in pairs(cfg_puzzle_entry) do
  setmetatable(v, mt)
end
return cfg_puzzle_entry
