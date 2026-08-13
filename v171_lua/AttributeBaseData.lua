local AttributeBaseData = {}
local this = AttributeBaseData
this.id = 0
this.roundPlayerInfo = 0
this.serverCoord = Vector2Int(0, 0)
this.serverDir8 = Direction8.Down
this.roleBuffData = RoleBuffData()
this.hp = 0
this.mp = 0
this.shield = 0
this.hasShield = false
this.maxShield = 0
local changeAttrTab = {}

function AttributeBaseData:Init()
end

function AttributeBaseData:Refresh(data)
  self.roundPlayerInfo = data
  self.id = data.info.roleId
  self:SetServerPos(data.x, data.y)
  self.serverDir8 = Direction8.Down
  self.roleBuffData = RoleBuffData()
  self:SetHp(data.hp)
  self:SetMp(data.mp)
  self:SetEnemyUnionList(data.info.enemyUnionList)
  self:SetShield(data.shield)
  self:SetShieldState()
  self:RefreshPlayerPosBySetting()
end

function AttributeBaseData:RefreshPlayerPosBySetting()
  GameSettingsController.SetHidePlayerBootType(GameSettingsData.hidePlayerBootCamp, true)
end

function AttributeBaseData:RefreshByTOOT(data)
  self:RefreshMapData(data.map)
  self:RefreshBasicData(data)
end

function AttributeBaseData:RefreshBasicData(data)
  self.id = data.basic.info.roleId
  self.hasShield = data.basic.info.hasShield
  self.roleBuffData = RoleBuffData()
end

function AttributeBaseData:RefreshMapData(data)
  if data.map then
    if data.map.hp then
      self.hp = data.map.hp
    end
    if data.map.mp then
      self.mp = data.map.mp
    end
    if data.map.shield then
      self.shield = data.map.shield
    end
  end
end

function AttributeBaseData:SetServerPos(x, y)
  if self.serverCoord.x ~= x or self.serverCoord.y ~= y then
    self.serverCoord:Set(x, y)
  end
end

function AttributeBaseData:SetHp(hp)
  if self.hp ~= hp then
    changeAttrTab.oldValue = self.hp
    self.hp = hp
    changeAttrTab.newValue = hp
    changeAttrTab.roleId = self.id
    changeAttrTab.roleData = self.roundPlayerInfo
    EventManager.Dispatch(Event.Role_RefreshHp, changeAttrTab)
  end
end

function AttributeBaseData:SetMp(mp)
  if self.mp ~= mp then
    changeAttrTab.oldValue = self.mp
    self.mp = mp
    changeAttrTab.newValue = mp
    changeAttrTab.roleId = self.id
    changeAttrTab.roleData = self.roundPlayerInfo
    EventManager.Dispatch(Event.Role_RefreshMp, changeAttrTab)
  end
end

function AttributeBaseData:SetEnemyUnionList(data)
  if #RoleManager.me.enemyUnionList ~= #data then
    RoleManager.me.enemyUnionList = data
  end
end

function AttributeBaseData:SetShield(shield)
  if self.shield ~= shield then
    changeAttrTab.oldValue = self.shield
    self.shield = shield
    changeAttrTab.newValue = shield
    changeAttrTab.roleId = self.id
    changeAttrTab.roleData = self.roundPlayerInfo
    EventManager.Dispatch(Event.Role_RefreshShield, changeAttrTab)
  end
end

function AttributeBaseData:SetShieldState()
  if self.roundPlayerInfo and self.shield ~= self.roundPlayerInfo.shield then
    self.hasShield = self.roundPlayerInfo.info.hasShield
    self.maxShield = self.roundPlayerInfo.maxShield
    self.shield = self.roundPlayerInfo.shield
    changeAttrTab = {}
    changeAttrTab.roleId = self.id
    changeAttrTab.boolValue = self.hasShield
    EventManager.Dispatch(Event.Role_RefreshMyShield, changeAttrTab)
  end
end

function AttributeBaseData:SetAttributeByReliveInfo(data)
  if data == nil then
    return
  end
  self:SetHp(data.hp)
  self:SetMp(data.mp)
  self:SetShield(data.shield)
end

return AttributeBaseData
