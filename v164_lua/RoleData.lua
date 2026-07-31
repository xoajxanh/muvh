require("GameModel/RoleBuffData")
RoleData = class()
setgetters(RoleData, {
  x = function(self)
    logPurple("[warning]    RoleData.x has been deprecated,use RoleData.serverCoord.x instead!")
    return self.serverCoord.x
  end,
  y = function(self)
    logPurple("[warning]    RoleData.y has been deprecated,use RoleData.serverCoord.y instead!")
    return self.serverCoord.y
  end
})

function RoleData:Init(data)
  self:RecycleData()
  self.data = data
  self.id = data.id
  self.serverCoord = Vector2Int(data.x, data.y)
  self.serverDir8 = Direction8.Down
  self.roleBuffData = RoleBuffData()
  self:SetHp(self.data.hp)
  self:SetMp(self.data.mp)
  self:SetShield(self.data.shield)
  self:SetShieldState(self.data)
end

function RoleData:Refresh(data)
  self:Init(data)
  EventManager.Dispatch(Event.Role_OnRefreshRoleData, self)
end

function RoleData:SetServerPos(x, y)
  if self.serverCoord.x ~= x or self.serverCoord.y ~= y then
    self.serverCoord:Set(x, y)
  end
end

function RoleData:SetServerDir(dir8)
  self.serverDir8 = dir8
end

function RoleData:SetHp(hp)
  if self.hp ~= hp then
    local oldHp = self.hp
    self.hp = hp
    EventManager.Dispatch(Event.Role_RefreshHp, {
      roleId = self.id,
      oldValue = oldHp,
      newValue = hp,
      roleData = self.data
    })
  end
end

function RoleData:SetMp(mp)
  if self.mp ~= mp then
    local oldMp = self.mp
    self.mp = mp
    EventManager.Dispatch(Event.Role_RefreshMp, {
      id = self.id,
      oldValue = oldMp,
      newValue = mp
    })
  end
end

function RoleData:SetShield(Shield)
  if self.shield ~= Shield then
    local oldShield = self.shield
    self.shield = Shield
    EventManager.Dispatch(Event.Role_RefreshShield, {
      roleId = self.id,
      oldValue = oldShield,
      newValue = Shield,
      roledata = self.data
    })
  end
end

function RoleData:SetShieldState(roleData)
  if roleData and self.shield ~= roleData.shield then
    self.hasShield = roleData.info.hasShield
    self.maxShield = roleData.maxShield
    self.shield = roleData.shield
  end
end

function RoleData:Destroy()
  self:RecycleData()
end

function RoleData:RecycleData()
  if NetManager.RecycleMessage(self.data) then
    self.data = nil
  end
end
