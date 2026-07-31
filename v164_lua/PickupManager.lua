PickupManager = {}
local this = PickupManager
local countdown, pickupSecond, pickupDelaySecond, pickupSuccessfulDelay
local dropSceneCellPos = {}

function PickupManager.OnEnterGame()
  this.RegistEvents()
  local globalConfig = ClientTable.cfg_Global_globalManager:TryGetValue(6030004)
  pickupSecond = tonumber(globalConfig.effect) / 1000
  globalConfig = ClientTable.cfg_Global_globalManager:TryGetValue(2390010)
  pickupDelaySecond = tonumber(globalConfig.effect) / 1000
  globalConfig = ClientTable.cfg_Global_globalManager:TryGetValue(6030008)
  pickupSuccessfulDelay = tonumber(globalConfig.effect)
end

function PickupManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
end

function PickupManager.IsBelongToYou(owners)
  if #owners == 0 then
    return true
  end
  for i = 1, #owners do
    if owners[i] == RoleManager.me.id then
      return true
    end
  end
  return false
end

function PickupManager.IsCanPickUpDropItem(dropItemData)
  local isBelongYour = false
  if this.IsBelongToYou(dropItemData.owner) then
    isBelongYour = true
  end
  if dropItemData.ownerProtectedTime < Time.GetServerSecondTime() then
    isBelongYour = true
  end
  return isBelongYour
end

function PickupManager.IsBelongToYourDropItemOnUnNewPeriod(dropItemData)
  local isBelongYour = false
  if this.IsBelongToYou(dropItemData.owner) then
    isBelongYour = true
  end
  if dropItemData.ownerProtectedTime < Time.GetServerSecondTime() then
    isBelongYour = true
  end
  return isBelongYour
end

function PickupManager.IsBelongToYourDropItemOnNewPeriod(dropItemData)
  local owners = dropItemData.owner
  if #owners == 0 then
    return false
  end
  if 1 < #owners then
    return false
  end
  for i = 1, #owners do
    if owners[i] == RoleManager.me.id then
      return true
    end
  end
  return false
end

function PickupManager.IsOnlyBelongToYourDropItem(dropItemData)
  if not RoleManager.me then
    return
  end
  local isBelongYour = false
  if this.IsBelongToYourDropItemOnNewPeriod(dropItemData) and dropItemData.ownerProtectedTime > Time.GetServerSecondTime() or dropItemData.wholeOwner == RoleManager.me.id then
    isBelongYour = true
  else
  end
  return isBelongYour
end

function PickupManager.AddDropSceneCellPos(item)
  local dropItemData = item.data
  local dropItem = {
    id = dropItemData.id,
    rarity = dropItemData.item.rarity,
    itemId = dropItemData.item.itemId,
    type = dropItemData.type,
    count = dropItemData.item.count,
    ownerProtectedTime = dropItemData.ownerProtectedTime,
    owner = dropItemData.owner,
    dropItem = item
  }
  
  local function CompareRarity(a, b)
    return a.rarity > b.rarity
  end
  
  if not dropSceneCellPos[dropItemData.x] then
    dropSceneCellPos[dropItemData.x] = {}
    dropSceneCellPos[dropItemData.x][dropItemData.y] = List:New()
  elseif not dropSceneCellPos[dropItemData.x][dropItemData.y] then
    dropSceneCellPos[dropItemData.x][dropItemData.y] = List:New()
  end
  dropSceneCellPos[dropItemData.x][dropItemData.y]:Push(dropItem)
  dropSceneCellPos[dropItemData.x][dropItemData.y]:Sort(CompareRarity)
  this.UpdatePickupItemStatus(dropItemData.x, dropItemData.y)
end

function PickupManager.RemoveDropSceneCellPos(dropItemData)
  local function FindDropItem(dropItem)
    if dropItem.id == dropItemData.id then
      return true
    end
  end
  
  local dropItemIndex = dropSceneCellPos[dropItemData.x][dropItemData.y]:FindIndex(FindDropItem)
  if dropItemIndex == 0 then
    return
  end
  dropSceneCellPos[dropItemData.x][dropItemData.y]:RemoveAt(dropItemIndex)
end

function PickupManager.GetDropItem(playerCellPos)
  if not (dropSceneCellPos[playerCellPos.x] and dropSceneCellPos[playerCellPos.x][playerCellPos.y]) or dropSceneCellPos[playerCellPos.x][playerCellPos.y]:Count() == 0 then
    return
  end
  local dropItemData = dropSceneCellPos[playerCellPos.x][playerCellPos.y]:FindTopFitItem(this.IsBelongToYourDropItemOnUnNewPeriod)
  if not dropItemData and dropSceneCellPos[playerCellPos.x][playerCellPos.y]:Count() > 0 then
    FloatingWordUtility.QuickMsg("V\225\186\173t ph\225\186\169m n\195\160y kh\195\180ng thu\225\187\153c v\225\187\129 b\225\186\161n")
  end
  return dropItemData
end

function PickupManager.UpdatePickupItemStatus(dropItemPosX, dropItemPosY)
  if RoleManager.me:IsStillState() then
    local meCell = RoleManager.me.serverCoord
    if meCell == Vector2Int(dropItemPosX, dropItemPosY) then
      this.StartCountDown()
    end
  end
end

function PickupManager.ReqPickUpMapItem(dropItemId)
  networkRequest.ReqPickUpMapItem(dropItemId)
end

function PickupManager.ReqPickUpMapItems(dropItemIds)
  networkRequest.ReqPickUpMapItems(dropItemIds)
end

function PickupManager.GetDropItemOnMeCellPos()
  local cellPos = RoleManager.me.serverCoord
  local dropItemData = this.GetDropItem(cellPos)
  return dropItemData
end

function PickupManager.StartPickup()
  local dropItemData = this.GetDropItemOnMeCellPos()
  if dropItemData then
    if ConditionalMgr:CanPickUpDropItemTip(dropItemData.dropItem.data) then
      this.ReqPickUpMapItem(dropItemData.id)
      QiJiHelperData.autoPickupDelay = Time.GetServerTime() + pickupSuccessfulDelay
    elseif dropItemData.type == 24 or dropItemData.type == 26 then
      this.ReqPickUpMapItem(dropItemData.id)
      QiJiHelperData.autoPickupDelay = Time.GetServerTime() + pickupSuccessfulDelay
    end
  end
end

function PickupManager.StartCountDown()
  if (not countdown or countdown.isRunning == false) and RoleManager.me then
    local dropItemData = this.GetDropItemOnMeCellPos()
    if dropItemData then
      local delayPickup = (1 - dropItemData.dropItem.passPercent) * pickupDelaySecond + pickupSecond
      countdown = Timer.StartLoop(delayPickup, 1, function()
        this.StartPickup()
      end)
    end
  end
end

function PickupManager.StopCountDown()
  if countdown then
    Timer.Stop(countdown)
    countdown = nil
  end
end

function PickupManager.OnLeaveGame()
  this.StopCountDown()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.RefreshDropSceneCellPos()
end

function PickupManager.RefreshDropSceneCellPos()
  dropSceneCellPos = {}
end
