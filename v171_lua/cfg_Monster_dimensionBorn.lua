local cfg_Monster_dimensionBorn = {
  [71] = {
    id = 71,
    monsterId = "20190611#10",
    desTips = "dimensionBorn7"
  },
  [72] = {
    id = 72,
    monsterId = "20190621#10",
    desTips = "dimensionBorn7"
  },
  [73] = {
    id = 73,
    monsterId = "20190631#10",
    desTips = "dimensionBorn7"
  },
  [81] = {
    id = 81,
    monsterId = "20190711#10",
    desTips = "dimensionBorn8"
  },
  [82] = {
    id = 82,
    monsterId = "20190721#10",
    desTips = "dimensionBorn8"
  },
  [83] = {
    id = 83,
    monsterId = "20190731#10",
    desTips = "dimensionBorn8"
  },
  [91] = {
    id = 91,
    monsterId = "20190811#10",
    desTips = "dimensionBorn9"
  },
  [92] = {
    id = 92,
    monsterId = "20190821#10",
    desTips = "dimensionBorn9"
  },
  [93] = {
    id = 93,
    monsterId = "20190831#10",
    desTips = "dimensionBorn9"
  },
  [101] = {
    id = 101,
    monsterId = "20190911#10",
    desTips = "dimensionBorn10"
  },
  [102] = {
    id = 102,
    monsterId = "20190921#10",
    desTips = "dimensionBorn10"
  },
  [103] = {
    id = 103,
    monsterId = "20190931#10",
    desTips = "dimensionBorn10"
  },
  [111] = {
    id = 111,
    monsterId = "20191011#10",
    desTips = "dimensionBorn11"
  },
  [112] = {
    id = 112,
    monsterId = "20191021#10",
    desTips = "dimensionBorn11"
  },
  [113] = {
    id = 113,
    monsterId = "20191031#10",
    desTips = "dimensionBorn11"
  },
  [121] = {
    id = 121,
    monsterId = "20191111#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn12"
  },
  [122] = {
    id = 122,
    monsterId = "20191121#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn12"
  },
  [123] = {
    id = 123,
    monsterId = "20191131#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn12"
  },
  [131] = {
    id = 131,
    monsterId = "20191211#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn13"
  },
  [132] = {
    id = 132,
    monsterId = "20191221#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn13"
  },
  [133] = {
    id = 133,
    monsterId = "20191231#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn13"
  },
  [141] = {
    id = 141,
    monsterId = "20191311#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn14"
  },
  [142] = {
    id = 142,
    monsterId = "20191321#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn14"
  },
  [143] = {
    id = 143,
    monsterId = "20191331#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn14"
  },
  [151] = {
    id = 151,
    monsterId = "20191411#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn15"
  },
  [152] = {
    id = 152,
    monsterId = "20191421#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn15"
  },
  [153] = {
    id = 153,
    monsterId = "20191431#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn15"
  },
  [161] = {
    id = 161,
    monsterId = "20191511#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn16"
  },
  [162] = {
    id = 162,
    monsterId = "20191521#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn16"
  },
  [163] = {
    id = 163,
    monsterId = "20191531#10",
    randomCost = "1000021#2000",
    desTips = "dimensionBorn16"
  }
}
local defaults = {
  probability = "1#2083",
  littleMonster = "",
  interval = 0,
  guaranteed = 999,
  randomCost = "1000021#1000",
  showProbability = "2000",
  fixedCost = "1000050#75",
  showFixedProbability = "10000",
  countdown = 300000
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Monster_dimensionBorn) do
  setmetatable(v, mt)
end
return cfg_Monster_dimensionBorn
