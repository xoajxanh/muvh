MeStandState = class(RoleMoveState)

function MeStandState:StartAutoFightCountDown()
  if not SceneData.mapId or not RoleManager.me then
    return
  end
  self:StopAllTimer()
  if self:StartPauseAutoFight() then
  elseif self:StartMapAutoFight() then
  end
end

function MeStandState:StopAllTimer()
  if self.pauseAutoFight then
    Timer.Stop(self.pauseAutoFight)
    self.pauseAutoFight = nil
  end
  if self.mapAutoFight then
    Timer.Stop(self.mapAutoFight)
    self.mapAutoFight = nil
  end
end

function MeStandState:IsCanOpenAutoFight()
  if not RoleManager.me:IsCurSafeZone() and not LoginData.reconnectState and not RoleManager.me.isDead then
    return true
  end
  return false
end

function MeStandState:StartMapAutoFight()
  local mapAutoFightTime = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId, "id").autoFightTime / 1000
  if not QiJiHelperData.isAutoFight and 0 < mapAutoFightTime and self:IsCanOpenAutoFight() then
    self.mapAutoFight = Timer.Start(mapAutoFightTime, function()
      if self:IsCanOpenAutoFight() and not QiJiHelperData.isAutoFight then
        RoleManager.me:MainUIOpenAutoFightStart()
      end
    end)
    return true
  end
  return false
end

function MeStandState:StartPauseAutoFight()
  local isPauseState = RoleManager.me:GetAutoFightState() == AutoFightStateEnum.Pause
  local autoTime = ClientTable.cfg_Global_globalManager:TryGetValue(2390015, "id").effect
  autoTime = tonumber(autoTime) / 1000
  local pauseAutoFightTime = isPauseState and autoTime or 0
  if QiJiHelperData.isAutoFight and 0 < pauseAutoFightTime and self:IsCanOpenAutoFight() then
    self.pauseAutoFight = Timer.Start(pauseAutoFightTime, function()
      if self:IsCanOpenAutoFight() and QiJiHelperData.isAutoFight then
        RoleManager.me:MainUIOpenAutoFightStart()
      end
    end)
    return true
  end
  return false
end

function MeStandState:HandleMove()
  PickupManager.StartCountDown()
  self:StartAutoFightCountDown()
end

function MeStandState:ChangeMove()
  PickupManager.StopCountDown()
  self:StopAllTimer()
end

function MeStandState:RefreshAutoFightCountDown()
  self:StartAutoFightCountDown()
end

function MeStandState:StopAutoFightCountDown()
  self:StopAllTimer()
end

function MeStandState:Destroy()
  self:StopAutoFightCountDown()
end
