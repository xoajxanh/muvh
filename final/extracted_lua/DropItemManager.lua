require("GamePlay/DropItem/DropItem")
require("GamePlay/DropItem/Head/DropItemHead3DMesh")
require("GamePlay/DropItem/Head/DropItemHead")
require("GamePlay/DropItem/Model/DropItemModel")
require("GamePlay/Effect/EffectModel")
DropItemManager = {}
local dropItems = {}
local this = DropItemManager

function DropItemManager.OnEnterGame()
  this.RegistEvents()
  this.InitHibitAutoDropCd()
  Timer.StartLoopForever(1, this.RefreShAutoDropActive)
end

function DropItemManager.Init()
  this.InitDropItemsRootGo()
end

function DropItemManager.InitDropItemsRootGo()
  this.root = CS.UnityEngine.GameObject("DropItemManager").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
end

function DropItemManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyDropItems()
end

function DropItemManager.Update()
  if dropItems then
    for _, v in pairs(dropItems) do
      if v then
        v:Update()
      end
    end
    DropItemManager.OnPickupBoneItemClientToServer()
  end
end

function DropItemManager.LateUpdate()
  if dropItems then
    for _, v in pairs(dropItems) do
      if v then
        v:LateUpdate()
      end
    end
  end
end

function DropItemManager.DestroyDropItem(id)
  local dropItem = dropItems[id]
  if dropItem then
    dropItems[id] = nil
    dropItem:Destroy()
  end
end

function DropItemManager.DestroyDropItems()
  for k, v in pairs(dropItems) do
    v:Destroy()
  end
  dropItems = {}
end

function DropItemManager.CreateDropItem(itemData)
  if dropItems[itemData.id] then
    return
  end
  local item = DropItem(itemData)
  dropItems[itemData.id] = item
  return item
end

function DropItemManager.AddDropItem(dropItem)
  if dropItems[dropItem.id] then
    return
  end
  dropItems[dropItem.id] = dropItem
  PickupManager.AddDropSceneCellPos(dropItem)
end

function DropItemManager.GetDropItemById(id)
  return dropItems[id]
end

function DropItemManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.DropItem_OnDropItemEnterView, this.OnDropItemEnterView)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnDropItemLeaveView)
  this.eventContainer:Regist(Event.QiJiHelper_SetAutoPickup, this.PutDropItemWhenAutoPickupChange)
  this.eventContainer:Regist(Event.Bag_ResBagInfo, this.PutDropItemWhenAutoPickupChange)
end

function DropItemManager.OnDropItemEnterView(_, dropItemData)
  if not dropItemData then
    return
  end
  local item
  local isVip = false
  if dropItemData.isMonsterDeath == true then
    isVip = this.PutDropItemInWhenIamVip(dropItemData)
    if isVip then
      return
    end
    local targetCell = {
      x = dropItemData.x,
      y = dropItemData.y
    }
    item = this.CreateDropItem(dropItemData)
    if not item then
      return
    end
    item:SetDropItemPos(targetCell)
    if dropItemData.dropAudio ~= 0 then
      AudioManager.PlayMusicClipById(dropItemData.dropAudio)
    end
  else
    item = this.CreateDropItem(dropItemData)
    if not item then
      return
    end
  end
  if not isVip then
    PickupManager.AddDropSceneCellPos(item)
  end
end

function DropItemManager.PutDropItemInWhenIamVip(dropItemData)
  return ConditionalMgr:CanAutoPickUpDropItem(dropItemData)
end

function DropItemManager.IsHasPowerToAutoPickUp()
  if RoleEquipUtility.IsHaveAutoPickEquip() and PlayerControlForceData.autoPickupState then
    return true
  end
  return false
end

function DropItemManager.PutDropItemWhenAutoPickupChange()
  for i, v in pairs(dropItems) do
    if v.data.isMonsterDeath then
      local isVip = this.PutDropItemInWhenIamVip(v.data)
      if isVip then
        dropItems[v.id] = nil
        VipManager.AddAutoPickupDropItem(v)
        PickupManager.RemoveDropSceneCellPos(v.data)
      else
      end
    else
    end
  end
end

function DropItemManager.OnDropItemLeaveView(_, dropItemData)
  if not dropItemData then
    return
  end
  this.RemoveDropItem(dropItemData)
  this.DestroyDropItem(dropItemData.id)
end

function DropItemManager.RemoveDropItem(dropItemData)
  local dropItem = dropItems[dropItemData.id]
  if dropItem then
    PickupManager.RemoveDropSceneCellPos(dropItemData)
  end
end

local dropTargetCell = Vector2Int(0, 0)

function DropItemManager.IsCanPickup(dropItem)
  if this.IsMeetPickUpCondition() == false then
    return false
  end
  if this.isHibitAutoDrop == true then
    if QuickFind.LuaSceneOnHookPointDataManager():IsMainPlayerInTheOnHookPoint() then
      return false
    end
    if ClientTable.cfg_Global_globalManager:CheckHibitAutoDropMapByCurMapId() then
      return false
    end
  end
  dropTargetCell:Set(dropItem.x, dropItem.y)
  if Scene.IsRoleTile(dropTargetCell) or Scene.IsBlock(dropTargetCell) then
    return false
  end
  return this.IsMeSelectPickUpType(dropItem.data)
end

function DropItemManager.IsMeetPickUpCondition()
  local isMeetOnHook = DropItemManager.IsNeedOnHookPickup()
  if this.isHibitAutoDrop == true and isMeetOnHook then
    return DropItemManager.CheckPickupByCurMapId()
  end
  return isMeetOnHook
end

function DropItemManager.IsNeedOnHookPickup()
  if this.isHibitAutoDrop == true and QuickFind.LuaSceneOnHookPointDataManager():IsMainPlayerInTheOnHookPoint() and RoleManager.me:GetAutoFightState() == AutoFightStateEnum.Open then
    return false
  end
  return true
end

function DropItemManager.CheckPickupByCurMapId()
  if this.isHibitAutoDrop == true and ClientTable.cfg_Global_globalManager:CheckHibitAutoDropMapByCurMapId() and RoleManager.me:GetAutoFightState() == AutoFightStateEnum.Open then
    return false
  end
  return true
end

function DropItemManager.IsMeSelectPickUpType(dropItemData)
  if QiJiHelperData.SettingData.selectPickupType == AutoPickupEnum.SelectAll then
    return true
  elseif dropItemData.type ~= EItemType.Equipe and not QiJiHelperData.pickupTab[tostring(dropItemData.type)] then
    return true
  elseif dropItemData.type == EItemType.Equipe and not QiJiHelperData.pickupTab[string.format("%s#%s", dropItemData.type, dropItemData.item.rarity)] then
    return true
  end
  return false
end

function DropItemManager.JudgeDropItemFullFitMyCareer(itemId)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  local career = string.split(itemConfig.career, "#")
  for i, v in pairs(career) do
    if RoleUtility.GetBasicCareer(RoleManager.me.career) == RoleUtility.GetBasicCareer(tonumber(v)) then
      return true
    end
  end
  return false
end

function DropItemManager.IsCanReachPos(dropItem)
  Scene.SetRoleTilesInfor(true)
  local reachable, path = Scene.SearchTilePath(RoleManager.me.cellPos, dropItem.data.serverCoord, 0)
  Scene.SetRoleTilesInfor(false)
  return reachable
end

local DistanceTab = {}
local keyDistanceTab = {}

function DropItemManager.GetNearestDropItem()
  local mostRareDropItem
  local shortestDis = math.maxinteger
  local defaultDis = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390003)
  defaultDis = defaultDis * defaultDis
  local dropItemIndex = 0
  
  local function JudgeDropItem(dropItem, key)
    local res = PickupManager.IsCanPickUpDropItem(dropItem.data)
    if not res then
      return res
    end
    if ConditionalMgr:CanAutoPickUpDropItem(dropItem.data) then
      return false
    end
    res = res and ConditionalMgr:CanPickUpDropItem(dropItem.data) or false
    if not res then
      return res
    end
    local tempDistance = (dropItem.serverCoord.x - RoleManager.me.serverCoord.x) * (dropItem.serverCoord.x - RoleManager.me.serverCoord.x) + (dropItem.serverCoord.y - RoleManager.me.serverCoord.y) * (dropItem.serverCoord.y - RoleManager.me.serverCoord.y)
    dropItemIndex = dropItemIndex + 1
    DistanceTab[dropItemIndex] = tempDistance
    keyDistanceTab[dropItemIndex] = key
    if tempDistance <= defaultDis and tempDistance < shortestDis then
      shortestDis = tempDistance
      mostRareDropItem = dropItem
    end
  end
  
  for k, v in pairs(dropItems) do
    if this.IsCanPickup(v) then
      JudgeDropItem(v, k)
    end
  end
  if 1 < dropItemIndex and (mostRareDropItem == nil or not this.IsCanReachPos(mostRareDropItem)) then
    DropItemManager.distanceSortFunc(DistanceTab, dropItemIndex, keyDistanceTab)
    for i = 2, dropItemIndex do
      local key = keyDistanceTab[i]
      if dropItems[key] ~= nil and this.IsCanReachPos(dropItems[key]) then
        return dropItems[key]
      end
    end
  end
  return mostRareDropItem
end

function DropItemManager.GetNearestDropItemInHookRange(onHookPoint)
  local mostRareDropItem
  local shortestDis = math.maxinteger
  local defaultDis = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390003)
  defaultDis = defaultDis * defaultDis
  local dropItemIndex = 0
  
  local function JudgeDropItem(dropItem, key)
    local res = PickupManager.IsCanPickUpDropItem(dropItem.data)
    if not res then
      return res
    end
    if ConditionalMgr:CanAutoPickUpDropItem(dropItem.data) then
      return false
    end
    res = res and ConditionalMgr:CanPickUpDropItem(dropItem.data) or false
    if not res then
      return res
    end
    local tempDistance = (dropItem.serverCoord.x - RoleManager.me.serverCoord.x) * (dropItem.serverCoord.x - RoleManager.me.serverCoord.x) + (dropItem.serverCoord.y - RoleManager.me.serverCoord.y) * (dropItem.serverCoord.y - RoleManager.me.serverCoord.y)
    dropItemIndex = dropItemIndex + 1
    DistanceTab[dropItemIndex] = tempDistance
    keyDistanceTab[dropItemIndex] = key
    if tempDistance <= defaultDis and tempDistance < shortestDis then
      shortestDis = tempDistance
      mostRareDropItem = dropItem
    end
  end
  
  for k, v in pairs(dropItems) do
    if Vector2.DistancePow(onHookPoint, v.serverCoord) <= OnHookData.hookRange * OnHookData.hookRange and this.IsCanPickup(v) then
      JudgeDropItem(v, k)
    end
  end
  if 1 < dropItemIndex and (mostRareDropItem == nil or not this.IsCanReachPos(mostRareDropItem)) then
    DropItemManager.distanceSortFunc(DistanceTab, dropItemIndex, keyDistanceTab)
    for i = 2, dropItemIndex do
      local key = keyDistanceTab[i]
      if dropItems[key] ~= nil and this.IsCanReachPos(dropItems[key]) then
        return dropItems[key]
      end
    end
  end
  return mostRareDropItem
end

function DropItemManager.distanceSortFunc(tbl, count, tbl2)
  for i = 1, count - 1 do
    for j = 1, count - 1 - i do
      if tbl[j] > tbl[j + 1] then
        tbl[j], tbl[j + 1] = tbl[j + 1], tbl[j]
        tbl2[j], tbl2[j + 1] = tbl2[j + 1], tbl2[j]
      end
    end
  end
end

function DropItemManager.IsExistDropItem(id)
  if dropItems[id] then
    return true
  end
  return false
end

function DropItemManager.InitHibitAutoDropCd()
  this.nowDropCd = 0
  this.nowImmunityDropCd = 0
  this.isImmunityHibitAutoDrop = false
end

function DropItemManager.SetAutoDropActive()
  if this.isImmunityHibitAutoDrop == false then
    this.isHibitAutoDrop = true
    this.isImmunityHibitAutoDrop = true
  end
end

function DropItemManager.RefreShAutoDropActive()
  this.hibitAutoDropCd, this.immunityHibitAutoDropCd = ClientTable.cfg_Global_globalManager:GetHibitAutoDropCd()
  if this.hibitAutoDropCd == nil or this.immunityHibitAutoDropCd == nil or this.nowDropCd == nil or this.nowImmunityDropCd == nil then
    this.InitHibitAutoDropCd()
    return
  end
  if this.isHibitAutoDrop then
    this.nowDropCd = this.nowDropCd + 1
  end
  if this.nowDropCd >= this.hibitAutoDropCd then
    this.nowDropCd = 0
    this.isHibitAutoDrop = false
  end
  if this.isImmunityHibitAutoDrop then
    this.nowImmunityDropCd = this.nowImmunityDropCd + 1
  end
  if this.nowImmunityDropCd >= this.immunityHibitAutoDropCd then
    this.nowImmunityDropCd = 0
    this.isImmunityHibitAutoDrop = false
  end
end

function DropItemManager:GetPickupBoneItemData()
  local DropItemDataEquipList = {}
  local DropItemDataID = {}
  if dropItems == nil then
    return
  end
  for i, v in pairs(dropItems) do
    if v.data.type == 26 or v.data.type == 24 then
      table.insert(DropItemDataEquipList, v)
      table.insert(DropItemDataID, v.data.id)
    end
  end
  return DropItemDataID, DropItemDataEquipList
end

function DropItemManager.OnPickupBoneItemClientToServer()
  if DropItemManager.boneTime == nil then
    DropItemManager.boneTime = 0
  end
  if DropItemManager.boneTime >= 1 then
    DropItemManager.boneTime = 0
  else
    DropItemManager.boneTime = DropItemManager.boneTime + Time.deltaTime
    return
  end
  if not QiJiHelperData.isAutoFight then
    return
  end
  if not ClientTable.cfg_Global_globalManager:GetSceneBoneDic(SceneData.mapId) then
    return
  end
  local DropItemDataID, DropItemDataEquipList = DropItemManager.GetPickupBoneItemData()
  if not DropItemDataEquipList or 0 >= table.count(DropItemDataEquipList) then
    return
  end
  if ConditionalMgr:CanPickUpDropItemTip(DropItemDataEquipList[1].data) then
    return
  end
  networkRequest.ReqPickUpMapItemsByType(DropItemDataID, 4)
end

DropItemManager.Init()
