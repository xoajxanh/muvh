local HolySpiritPointTemplate = {}

function HolySpiritPointTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function HolySpiritPointTemplate:InitControls()
  self.img_DarkLine = self:GetControl("LineParent/dark")
  self.img_LightLine = self:GetControl("LineParent/light")
  self.img_PurpleLight = self:GetControl("LineParent/purpleLight")
  self.img_Frame = self:GetControl("img_Frame")
  self.img_Select = self:GetControl("img_Select")
  self.img_NotSelectable = self:GetControl("img_NotSelectable")
  self.img_Selectable = self:GetControl("img_Selectable")
  self.img_Activation = self:GetControl("Activation/img_Activation")
  self.img_PurpleActivation = self:GetControl("Activation/img_PurpleActivation")
  self.stage_title = self:GetControl("stage_title")
  self.title_bg = self:GetControl("stage_title/title_bg")
  self.title = self:GetControl("stage_title/title")
end

function HolySpiritPointTemplate:BindUIEvent()
  self.img_Selectable:SetOnClick(self, self.OnClickFun)
  self.img_Activation:SetOnClick(self, self.OnClickFun)
  self.img_PurpleActivation:SetOnClick(self, self.OnClickFun)
  self.img_NotSelectable:SetOnClick(self, self.OnClickFun)
end

function HolySpiritPointTemplate:OnClickFun()
  gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():SetCurShowHolySpiritPoint(self.data.CfgInfo.id)
end

function HolySpiritPointTemplate:Refresh(data, ui)
  if data == nil then
    self:UIControl():SetActive(false)
    return
  end
  self.data = data
  self.parent = ui
  self.lineTab = {
    [1] = self.img_LightLine,
    [2] = self.img_PurpleLight
  }
  self.activationTab = {
    [1] = self.img_Activation,
    [2] = self.img_PurpleActivation
  }
  self:RefreshPointStateUI()
  self:RefreshSelectStateUI()
  self:RefreshUpgradeUI()
  self:RefreshPointPosition()
  self:SetLineParentAndPosition()
  self:RefreshLineRotation()
  self:RefreshLineLength()
end

function HolySpiritPointTemplate:RefreshPointStateUI()
  self.img_NotSelectable:SetActive(false)
  self.img_Selectable:SetActive(false)
  for i, v in pairs(self.activationTab) do
    v:SetActive(false)
  end
  self.stage_title:SetActive(false)
  if self.data.serverInfo.active then
    self.activationTab[self.data.CfgInfo.subType]:SetActive(true)
    self.stage_title:SetActive(false)
  else
    local lastPointState = HolySpiritPointData.GetLastPointState(self.data.CfgInfo.id)
    self.img_NotSelectable:SetActive(not lastPointState)
    self.img_Selectable:SetActive(lastPointState)
    self.stage_title:SetActive(lastPointState)
  end
end

function HolySpiritPointTemplate:RefreshSelectStateUI()
  local curShowHolySpiritPointId = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritPointId()
  self.img_Select:SetActive(self.data.serverInfo.id == curShowHolySpiritPointId)
end

function HolySpiritPointTemplate:RefreshUpgradeUI()
  self.title:SetText(string.format("%d/%d", self.data.serverInfo.level, self.data.CfgInfo.numUpgrades))
end

function HolySpiritPointTemplate:RefreshPointPosition()
  self:UIControl().transform.localPosition = ClientTable.cfg_Holyspirit_panelManager:GetPositionById(self.data.CfgInfo.id)
end

function HolySpiritPointTemplate:SetLineParentAndPosition()
  self.img_DarkLine:SetActive(false)
  for i, v in pairs(self.lineTab) do
    v:SetActive(false)
  end
  if self.data.CfgInfo.previous ~= 0 and ClientTable.cfg_Holyspirit_panelManager:GetSubTypeById(self.data.CfgInfo.previous) == self.data.CfgInfo.subType then
    self.img_DarkLine:SetActive(not self.data.serverInfo.active)
    self.lineTab[self.data.CfgInfo.subType]:SetActive(self.data.serverInfo.active)
  end
  self.img_DarkLine:SetParent(self.parent.LineParent)
  self.img_DarkLine.transform.localPosition = ClientTable.cfg_Holyspirit_panelManager:GetPositionById(self.data.CfgInfo.id)
  self.lineTab[self.data.CfgInfo.subType]:SetParent(self.parent.LineParent)
  self.lineTab[self.data.CfgInfo.subType].transform.localPosition = ClientTable.cfg_Holyspirit_panelManager:GetPositionById(self.data.CfgInfo.id)
end

function HolySpiritPointTemplate:RefreshLineRotation()
  local dir = ClientTable.cfg_Holyspirit_panelManager:GetPositionById(self.data.CfgInfo.previous) - ClientTable.cfg_Holyspirit_panelManager:GetPositionById(self.data.CfgInfo.id)
  dir = dir.normalized
  local angle = Mathf.Atan2(dir.y, dir.x) * Mathf.Rad2Deg
  self.img_DarkLine.transform.localEulerAngles = Vector3(0, 0, angle)
  self.lineTab[self.data.CfgInfo.subType].transform.localEulerAngles = Vector3(0, 0, angle)
end

function HolySpiritPointTemplate:RefreshLineLength()
  local width = Vector3.Distance(ClientTable.cfg_Holyspirit_panelManager:GetPositionById(self.data.CfgInfo.previous), ClientTable.cfg_Holyspirit_panelManager:GetPositionById(self.data.CfgInfo.id))
  self.img_DarkLine:SetSizeDelta(width, 2)
  self.lineTab[self.data.CfgInfo.subType]:SetSizeDelta(width, 10)
end

return HolySpiritPointTemplate
