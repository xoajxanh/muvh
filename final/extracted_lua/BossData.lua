BossData = {}
local this = BossData
local togDataList = {}
local togObjectList = {}
local curSelectTogType = BossTogType.none
local curSelectBossTbl = {}
local count = 0
local monsterBossDropRateList = {}
local togTypeToBossType = {
  [BossTogType.wildBossTog] = MonsterBossType.wildBoss,
  [BossTogType.privateBossTog] = MonsterBossType.privateBoss,
  [BossTogType.goldMonsterTog] = MonsterBossType.goldMonster,
  [BossTogType.brilliantMonsterTog] = MonsterBossType.brilliantMonster,
  [BossTogType.secretBossTog] = MonsterBossType.secretBoss,
  [BossTogType.spanBossTog] = MonsterBossType.spanBoss,
  [BossTogType.OnHookPointTog] = MonsterBossType.OnHookPoint,
  [BossTogType.reinBossTog] = MonsterBossType.reinBoss,
  [BossTogType.KaLiMaTog] = MonsterBossType.KaLiMaBoss,
  [BossTogType.PersonKaLiMaTog] = MonsterBossType.PersonKaLiMaBoss,
  [BossTogType.AngelBossTog] = MonsterBossType.AngelBoss,
  [BossTogType.RegenerateBossTog] = MonsterBossType.RegenerateBoss,
  [BossTogType.HolySkeletonBossTog] = MonsterBossType.HolySkeletonBoss,
  [BossTogType.RunesNewBossTog] = MonsterBossType.RunesNewBoss,
  [BossTogType.EnchantSmeltBossTog] = MonsterBossType.EnchantSmeltBoss
}
local togTypeToTogSort = {
  [BossTogType.OnHookPointTog] = 1,
  [BossTogType.wildBossTog] = 2,
  [BossTogType.privateBossTog] = 3,
  [BossTogType.goldMonsterTog] = 4,
  [BossTogType.brilliantMonsterTog] = 5,
  [BossTogType.secretBossTog] = 6,
  [BossTogType.spanBossTog] = 7,
  [BossTogType.reinBossTog] = 8,
  [BossTogType.KaLiMaTog] = 9,
  [BossTogType.PersonKaLiMaTog] = 10,
  [BossTogType.AngelBossTog] = 11,
  [BossTogType.RegenerateBossTog] = 12,
  [BossTogType.HolySkeletonBossTog] = 13,
  [BossTogType.RunesNewBossTog] = 14,
  [BossTogType.EnchantSmeltBossTog] = 15
}

function BossData:InitData()
  this:InitTogTabData()
end

function BossData:InitTogTabData()
  count = 0
  for i, v in pairs(BossTogType) do
    if v ~= BossTogType.none then
      count = togTypeToTogSort[v]
      if togDataList[count] == nil then
        togDataList[count] = this:GetTogInfo(v)
      end
    end
  end
end

function BossData:InitTogObject(type, object)
  print(togObjectList, type, object)
  togObjectList[type] = object
end

function BossData:GetTogListCount()
  return table.count(togDataList)
end

function BossData:GetTogDataList()
  return togDataList
end

function BossData:GetTogList()
  return togObjectList
end

function BossData:GetTogDataByType(type)
  count = 0
  for i, v in pairs(BossTogType) do
    if v ~= BossTogType.none then
      count = togTypeToTogSort[v]
    end
    if v == type then
      return togDataList[count]
    end
  end
  return nil
end

function BossData:GetTogByType(type)
  for i, v in pairs(togObjectList) do
    if i == type then
      return v
    end
  end
  return nil
end

function BossData:GetTogByName(name)
  for i, v in pairs(togObjectList) do
    if v.gameObject.name == name then
      return v
    end
  end
  return nil
end

function BossData:GSetCurTog(type)
  if type ~= nil then
    curSelectTogType = type
  end
  return curSelectTogType
end

function BossData:GetCurSelectBossTbl()
  return curSelectBossTbl
end

function BossData:SetCurSelectBossTbl(bossTbl)
  if bossTbl ~= nil then
    curSelectBossTbl = bossTbl
  end
end

function BossData:GetBossTypeByTogType(togType)
  return togTypeToBossType[togType]
end

function BossData:GetTogByBossType(togType)
  for key, value in pairs(togTypeToBossType) do
    if togType == value and togObjectList[key] then
      return togObjectList[key]
    end
  end
  return nil
end

function BossData:GetTogInfo(id)
  local funTab = ClientTable.cfg_Function_functionManager:TryGetValue(id)
  local tab = {}
  if funTab then
    local str = string.split(funTab.route, "#")
    if str ~= nil and 1 < #str then
      tab.name = str[2]
    end
    tab.index = id
    tab.text = funTab.name
  else
    print("\230\156\170\230\137\190\229\136\176ID\239\188\154", id)
  end
  return tab
end

function BossData:DoOnclick(tog, value, type)
  if tog then
    tog:SetIsOn(value)
  end
  if value then
    BossData:GSetCurTog(type)
  end
  EventManager.Dispatch(Event.Boss_ClickTog, type)
end

function BossData.IsVipCanIn(mapType)
  return 3100 <= mapType and mapType <= 3104
end

function BossData:GetBossDropNumber(monsterId)
  if not table.containsKey(monsterBossDropRateList, monsterId) then
    return nil
  end
  return monsterBossDropRateList[monsterId]
end

function BossData:RefreshDropNumber(dropRateInfos)
  for _, v in pairs(dropRateInfos.drapRates) do
    monsterBossDropRateList[v.monsterConfigId] = v.dropNum
  end
end
