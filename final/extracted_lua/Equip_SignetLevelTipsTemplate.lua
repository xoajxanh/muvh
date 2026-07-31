local Equip_SignetLevelTipsTemplate = {}

function Equip_SignetLevelTipsTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function Equip_SignetLevelTipsTemplate:InitParams()
  self.levelInfo = nil
end

function Equip_SignetLevelTipsTemplate:InitControls()
  self.lab_attributeDec = self:GetControl("Scroll_attribute/Viewport/Content/item_attribute/lab_attributeDec")
end

function Equip_SignetLevelTipsTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function Equip_SignetLevelTipsTemplate:ClickGoCallBack()
  self:HideView()
end

function Equip_SignetLevelTipsTemplate:Refresh(data)
  self:RefreshView(data)
  self:ShowView()
end

function Equip_SignetLevelTipsTemplate:RefreshView(data)
  if self.levelInfo ~= nil and self.levelInfo.id == data.id then
    return
  end
  self.levelInfo = data
  self.lab_attributeDec:SetText(self.levelInfo.buffDes)
end

function Equip_SignetLevelTipsTemplate:ShowView()
  self:UIControl():SetActive(true)
end

function Equip_SignetLevelTipsTemplate:HideView()
  self:UIControl():SetActive(false)
end

return Equip_SignetLevelTipsTemplate
