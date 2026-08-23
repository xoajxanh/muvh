local cfg_Character_attribute = {
  {
    id = 11,
    strength = 28,
    vitality = 25,
    energy = 10,
    pointsPerLevelUp = 5
  },
  {
    id = 12,
    agility = 18,
    vitality = 15,
    energy = 30,
    pointsPerLevelUp = 5,
    headPortrait = 12
  },
  {
    id = 13,
    strength = 22,
    agility = 25,
    pointsPerLevelUp = 5,
    headPortrait = 13
  },
  {
    id = 14,
    strength = 27,
    agility = 26,
    vitality = 26,
    energy = 27,
    headPortrait = 14,
    defenseBase = 3
  },
  {
    id = 15,
    strength = 26,
    leadership = 25,
    headPortrait = 15
  },
  {
    id = 16,
    strength = 21,
    agility = 21,
    vitality = 18,
    energy = 24,
    pointsPerLevelUp = 5,
    headPortrait = 16
  },
  {
    id = 21,
    strength = 28,
    vitality = 25,
    energy = 10,
    pointsPerLevelUp = 5
  },
  {
    id = 22,
    agility = 18,
    vitality = 15,
    energy = 30,
    pointsPerLevelUp = 5,
    headPortrait = 12
  },
  {
    id = 23,
    strength = 22,
    agility = 25,
    pointsPerLevelUp = 5,
    headPortrait = 13
  },
  {
    id = 24,
    strength = 27,
    agility = 26,
    vitality = 26,
    energy = 27,
    headPortrait = 14
  },
  {
    id = 25,
    strength = 26,
    leadership = 25,
    headPortrait = 15
  },
  {
    id = 26,
    strength = 21,
    agility = 21,
    vitality = 18,
    energy = 24,
    pointsPerLevelUp = 5,
    headPortrait = 16
  },
  {
    id = 31,
    strength = 28,
    vitality = 25,
    energy = 10,
    pointsPerLevelUp = 6
  },
  {
    id = 32,
    agility = 18,
    vitality = 15,
    energy = 30,
    pointsPerLevelUp = 6,
    headPortrait = 12
  },
  {
    id = 33,
    strength = 22,
    agility = 25,
    pointsPerLevelUp = 6,
    headPortrait = 13
  },
  {
    id = 34,
    strength = 27,
    agility = 26,
    vitality = 26,
    energy = 27,
    headPortrait = 14
  },
  {
    id = 35,
    strength = 26,
    leadership = 25,
    headPortrait = 15
  },
  {
    id = 36,
    strength = 21,
    agility = 21,
    vitality = 18,
    energy = 24,
    pointsPerLevelUp = 6,
    headPortrait = 16
  },
  {
    id = 41,
    strength = 28,
    vitality = 25,
    energy = 10,
    pointsPerLevelUp = 6
  },
  {
    id = 42,
    agility = 18,
    vitality = 15,
    energy = 30,
    pointsPerLevelUp = 6,
    headPortrait = 12
  },
  {
    id = 43,
    strength = 22,
    agility = 25,
    pointsPerLevelUp = 6,
    headPortrait = 13
  },
  {
    id = 44,
    strength = 27,
    agility = 26,
    vitality = 26,
    energy = 27,
    headPortrait = 14
  },
  {
    id = 45,
    strength = 26,
    leadership = 25,
    headPortrait = 15
  },
  {
    id = 46,
    agility = 18,
    vitality = 15,
    energy = 30,
    headPortrait = 16
  }
}
local defaults = {
  strength = 18,
  agility = 20,
  vitality = 20,
  energy = 15,
  leadership = 0,
  maximumMana = 150,
  staticMoveSpeed = 400,
  pointsPerLevelUp = 7,
  headPortrait = 11,
  roleicon = "Icon_1",
  defenseBase = 0
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Character_attribute) do
  setmetatable(v, mt)
end
return cfg_Character_attribute
