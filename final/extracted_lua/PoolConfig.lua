PoolConfig = {
  [EModelType.Monster] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Monster"
  },
  [EModelType.NPC] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "NPC"
  },
  [EModelType.Charactor] = {
    cullDeSpawned = false,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Charactor"
  },
  [EModelType.Pet] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Pet"
  },
  [EModelType.EquipItem] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Item"
  },
  [EModelType.Mount] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Mount"
  },
  [EModelType.Item] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Item"
  },
  [EModelType.Gold] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Item"
  },
  [EModelType.InstanceItem] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Item"
  },
  [EModelType.Equip] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Equip"
  },
  [EModelType.Skill] = {
    cullDeSpawned = false,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Effect"
  },
  [EEffectModelType.Scene] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Scene"
  },
  [EEffectModelType.Skill] = {
    cullDeSpawned = false,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "Effect"
  },
  [EEffectModelType.UI] = {
    cullDeSpawned = true,
    cullAbove = 0,
    cullDelay = 30,
    cullMaxPerPass = 5,
    cullLoseVitality = 60,
    poolName = "UI"
  }
}
setmetatable(PoolConfig, {
  __index = function()
    return {
      cullDeSpawned = true,
      cullAbove = 0,
      cullDelay = 30,
      cullMaxPerPass = 5,
      cullLoseVitality = 60,
      poolName = "Other"
    }
  end
})
