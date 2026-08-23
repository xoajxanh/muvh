local EnemyListTemplate = {}
EnemyListTemplate._campInfo = nil
EnemyListTemplate._myCampInfo = nil
EnemyListTemplate._refreshRightEnemyList = nil
EnemyListTemplate._baseUI = nil

function EnemyListTemplate:Init()
  self:InitComponent()
  self:InitTemplate()
  self:InitOther()
end

function EnemyListTemplate:InitComponent()
  self.Viewport = self:GetControl("Viewport")
  self.Viewport_left = self:GetControl("Viewport_left")
end

function EnemyListTemplate:InitTemplate()
  self._rightEnemyListTemplate = luaTemplateManager.GetNewTemplate(self.Viewport, LuaComponentTemplates.SingleEnemyListTemplate)
  self._leftEnemyListTemplate = luaTemplateManager.GetNewTemplate(self.Viewport_left, LuaComponentTemplates.SingleEnemyListTemplate)
end

function EnemyListTemplate:InitOther()
  self._refreshRightEnemyList = true
end

function EnemyListTemplate:Refresh(data, baseUI)
  self.ThreeVsThreeDataMgr = QuickFind:GetThreeVsThreeDataMgr()
  self._baseUI = baseUI
  self:SetIsDirty()
  self._campInfo = self.ThreeVsThreeDataMgr:GetEnemyCampInfoList()
  self._myCampInfo = self.ThreeVsThreeDataMgr:GetPlayerCampInfoList()
  if table.count(self._myCampInfo) > 0 then
    self._leftEnemyListTemplate:Refresh(self._myCampInfo, self)
  end
  if table.count(self._campInfo) > 0 then
    self._rightEnemyListTemplate:Refresh(self._campInfo, self)
  end
end

function EnemyListTemplate:RefreshSinglePlayer(data)
  if data._serverData.id == RoleManager.me.id then
    return
  end
  if table.count(self._myCampInfo) > 0 and self._campInfo[1]:IsInPlayerList(data:GetId()) then
    self._rightEnemyListTemplate:RefreshSinglePlayer(data)
  end
  if table.count(self._myCampInfo) > 0 and self._myCampInfo[1]:IsInPlayerList(data:GetId()) then
    self._leftEnemyListTemplate:RefreshSinglePlayer(data)
  end
end

function EnemyListTemplate:RefreshChoose()
  self._rightEnemyListTemplate:RefreshChoose()
end

function EnemyListTemplate:GetRefreshTemplate()
  if self._refreshRightEnemyList then
    return self._rightEnemyListTemplate
  else
    return self._leftEnemyListTemplate
  end
end

function EnemyListTemplate:SetIsDirty()
  self._rightEnemyListTemplate.IsDirty = true
  self._leftEnemyListTemplate.IsDirty = true
end

function EnemyListTemplate:Update()
  self._rightEnemyListTemplate:Update()
  self._leftEnemyListTemplate:Update()
end

return EnemyListTemplate
