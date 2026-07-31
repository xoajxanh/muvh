VipManager = {}
local vipAutoPickDropItems = {}
local vipFlyToMeDropItems = {}
local vipPickDropItems = {}
local this = VipManager
this.loopFlyDropItem = nil
this.dropItemStopTime = 0
this.flyTime = 0
this.lowFlySpeed = 9
this.highFlySpeed = 12
this.delaySpeedTime = 2000
this.firstPartTime = 300
this.maxScale = 1.3
this.secondPartTime = 1000
this.ScanFlyTime = 0.5

function VipManager.Init()
  this.dropItemStopTime = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390008))
  this.flyTime = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390007))
  local flySpeedStr = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2070004)
  flySpeedStr = string.split(flySpeedStr, "#")
  this.lowFlySpeed = tonumber(flySpeedStr[1])
  this.highFlySpeed = tonumber(flySpeedStr[2])
end

function VipManager.OnEnterGame()
  this.RegistEvents()
end

function VipManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyVipDropItems()
  this.DestroyFlyDropItems()
end

function VipManager.Update()
  if vipAutoPickDropItems then
    for _, v in pairs(vipAutoPickDropItems) do
      if v then
        v:Update()
      end
    end
  end
  if vipFlyToMeDropItems then
    for _, v in pairs(vipFlyToMeDropItems) do
      if v then
        this.UpdateVipDropItemPos(v.dropItem, v.startTime)
      end
    end
  end
end

function VipManager.UpdateVipDropItemPos(dropItem, startTime)
  if dropItem then
    this.UpdateFlyToMe(dropItem, startTime)
  end
end

function VipManager.CreateDropItem(itemData)
  if vipAutoPickDropItems[itemData.id] then
    return
  end
  local item = DropItem(itemData)
  vipAutoPickDropItems[itemData.id] = item
  this.DropItemFlyToMeWhenIHasVip()
  return item
end

function VipManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.DropItem_OnDropItemEnterView, this.OnDropItemEnterView)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnDropItemLeaveView)
  this.eventContainer:Regist(Event.SendPickupMsgSuccessful, this.PickupSuccessful)
end

function VipManager.OnDropItemEnterView(_, dropItemData)
  if not dropItemData then
    return
  end
  if dropItemData.isMonsterDeath == true then
    local isVip = DropItemManager.PutDropItemInWhenIamVip(dropItemData)
    if not isVip then
      return
    end
    local targetCell = {
      x = dropItemData.x,
      y = dropItemData.y
    }
    local item = this.CreateDropItem(dropItemData)
    if not item then
      return
    end
    item:SetDropItemPos(targetCell)
    if dropItemData.dropAudio ~= 0 then
      AudioManager.PlayMusicClipById(dropItemData.dropAudio)
    end
  end
end

function VipManager.AddAutoPickupDropItem(dropItem)
  if vipAutoPickDropItems[dropItem.id] then
    return
  end
  vipAutoPickDropItems[dropItem.id] = dropItem
  this.DropItemFlyToMeWhenIHasVip()
end

function VipManager.GetIsHaveAutoPickupDrop()
  return vipAutoPickDropItems ~= nil and next(vipAutoPickDropItems) ~= nil
end

function VipManager.OnDropItemLeaveView(_, dropItemData)
  if not dropItemData then
    return
  end
  this.DestroyVipDropItem(dropItemData.id)
end

function VipManager.DestroyVipDropItem(id)
  local dropItem = vipAutoPickDropItems[id]
  if dropItem then
    dropItem:Destroy()
    vipAutoPickDropItems[id] = nil
  end
end

function VipManager.DestroyVipDropItems()
  for k, v in pairs(vipAutoPickDropItems) do
    v:Destroy()
  end
  vipAutoPickDropItems = {}
  vipPickDropItems = {}
end

function VipManager.IsCanFlyToMe(dropItem, stopInterval)
  if dropItem.stopTime == 0 then
    return false
  end
  local curTime = Time.GetServerTime()
  local intervalTime = curTime - dropItem.stopTime
  if stopInterval <= intervalTime then
    return true
  end
  return false
end

function VipManager.IsInFlyingTime(startTime)
  if this.flyTime > Time.GetServerTime() - startTime then
    return true
  else
    return false
  end
end

function VipManager.DestroyFlyDropItem(id)
  local dropItem = vipFlyToMeDropItems[id].dropItem
  if dropItem then
    dropItem:Destroy()
    vipFlyToMeDropItems[id] = nil
  end
end

function VipManager.DestroyFlyDropItems()
  for k, v in pairs(vipFlyToMeDropItems) do
    v.dropItem:Destroy()
  end
  vipFlyToMeDropItems = {}
end

function VipManager.UpdateFirstPartMovement(moveTime, dropItem)
  if moveTime >= this.firstPartTime then
    return
  end
  local dropItemPos = dropItem:GetPosByCell()
  local movePos = Vector3(dropItemPos.x, dropItemPos.y + 0.5, dropItemPos.z)
  local pos = Vector3.Lerp(dropItemPos, movePos, moveTime / this.firstPartTime)
  dropItem:SetPosition(pos.x, pos.y, pos.z)
  local scale = Mathf.Lerp(1, this.maxScale, moveTime / this.firstPartTime)
  dropItem:SetScale(scale, scale, scale)
end

function VipManager.UpdateSecondPartMovement(moveTime, dropItem, mePos)
  if moveTime < this.firstPartTime + 100 then
    return
  end
  local speed = Mathf.Lerp(this.lowFlySpeed, this.highFlySpeed, moveTime / this.delaySpeedTime)
  local pos = Vector3.MoveTowards(dropItem.pos, mePos, speed * Time.deltaTime)
  dropItem:SetPosition(pos.x, pos.y, pos.z)
  local scale = Mathf.Lerp(this.maxScale, 0.1, moveTime / this.secondPartTime)
  dropItem:SetScale(scale, scale, scale)
end

function VipManager.UpdateFlyToMe(dropItem, startTime)
  if this.IsInFlyingTime(startTime) then
    local dropItemCell = Vector2(dropItem.transform.localPosition.x, dropItem.transform.localPosition.z)
    local meCell = Vector2(RoleManager.me.transform.localPosition.x, RoleManager.me.transform.localPosition.z)
    if Vector2.DistancePow(dropItemCell, meCell) > 0.01 then
      local mePos = Vector3(RoleManager.me.pos.x, RoleManager.me.pos.y, RoleManager.me.pos.z)
      mePos.y = mePos.y + 1.1
      local timeInterval = Time.GetServerTime() - startTime
      this.UpdateFirstPartMovement(timeInterval, dropItem)
      this.UpdateSecondPartMovement(timeInterval, dropItem, mePos)
    else
      this.DestroyFlyDropItem(dropItem.id)
    end
  else
    this.DestroyFlyDropItem(dropItem.id)
  end
end

function VipManager.PickupSuccessful(_, itemIdList)
  for i, v in pairs(itemIdList) do
    if vipPickDropItems[v] then
      vipFlyToMeDropItems[v] = {
        dropItem = vipPickDropItems[v],
        startTime = Time.GetServerTime()
      }
      vipPickDropItems[v] = nil
    end
  end
  for i, v in pairs(vipPickDropItems) do
    vipAutoPickDropItems[v.id] = v
  end
  vipPickDropItems = {}
end

function VipManager.IsFlyItem(id)
  return vipPickDropItems[id] ~= nil or vipFlyToMeDropItems[id] ~= nil
end

function VipManager.TryRemoveAutoPickItem(id)
  vipAutoPickDropItems[id] = nil
end

function VipManager.DropItemFlyToMeWhenIHasVip()
  if not RoleManager.me then
    return
  end
  if this.loopFlyDropItem then
    return
  end
  
  local function StartFlyDropItem()
    while true do
      local flyDropItemTab = {}
      local isHasBelongToY = false
      local isNeedOnHookPickup = DropItemManager.IsMeetPickUpCondition()
      for i, v in pairs(vipAutoPickDropItems) do
        if ConditionalMgr:CanAutoPickUpDropItem(v.data) then
          if this.IsCanFlyToMe(v, this.dropItemStopTime) and isNeedOnHookPickup then
            table.insert(flyDropItemTab, v)
          end
          isHasBelongToY = true
        else
          vipAutoPickDropItems[v.id] = nil
          DropItemManager.AddDropItem(v)
        end
      end
      if 0 < #flyDropItemTab then
        local dropItemIds = {}
        for i, v in pairs(flyDropItemTab) do
          table.insert(dropItemIds, v.id)
          vipAutoPickDropItems[v.id] = nil
          vipPickDropItems[v.id] = v
        end
        PickupManager.ReqPickUpMapItems(dropItemIds)
      end
      if not isHasBelongToY then
        this.loopFlyDropItem = nil
        Coroutine.Break()
      end
      Coroutine.Wait(this.ScanFlyTime)
    end
  end
  
  this.loopFlyDropItem = Coroutine.Start(StartFlyDropItem)
end

this.Init()
