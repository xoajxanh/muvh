local panel_ZhangBaTeamTemplate = {}

function panel_ZhangBaTeamTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function panel_ZhangBaTeamTemplate:InitControls()
  self.lab_name = self:GetControl("lab_name")
end

function panel_ZhangBaTeamTemplate:InitUI()
end

function panel_ZhangBaTeamTemplate:BindUIEvent()
end

function panel_ZhangBaTeamTemplate:Refresh()
  self:UIControl():SetActive(true)
end

function panel_ZhangBaTeamTemplate:SetObjActive(isActive)
  self:UIControl():SetActive(isActive)
end

function panel_ZhangBaTeamTemplate:ShowByData(data)
  if data == nil or data.UnionName == nil then
    self:UIControl():SetActive(false)
    return
  end
  self:UIControl():SetActive(true)
  local format = "S%d.%s"
  local showStr = string.format(format, data.serverId, data.UnionName)
  self.lab_name:SetText(showStr)
end

function panel_ZhangBaTeamTemplate:OnDisable()
end

function panel_ZhangBaTeamTemplate:Exit()
  self:UIControl():SetActive(false)
end

return panel_ZhangBaTeamTemplate
