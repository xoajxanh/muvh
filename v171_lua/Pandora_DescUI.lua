Pandora_DescUI = class(BaseUI)
Pandora_DescUI.layer = UILayer.Tip
Pandora_DescUI.orderInLayer = 0
Pandora_DescUI.hideType = UIHideType.WaitDestroy
Pandora_DescUI.hideFunc = UIHideFunc.MoveOutOfScreen
Pandora_DescUI.escClose = UIEscClose.DontClose

function Pandora_DescUI:InitControls()
  self.Panel_Desc = self:GetControl("Panel_Desc")
  self.CloseBtn = self:GetControl("Img_DescBg/CloseBtn")
  self.lab_DescTitle = self:GetControl("Img_DescBg/lab_DescTitle")
  self.pro_level = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/pro_level")
  self.lab_pro = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/pro_level/Content/lab_pro")
  self.lab_DescContent = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/lab_DescContent")
end

function Pandora_DescUI:Init()
end

function Pandora_DescUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnLabProCreate(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.lab_pro = UIControl(ctr.transform, "lab_pro")
end

local function OnLabProRefresh(ctr, _, itemData, ui)
  if itemData then
    local newStr = "<color=%s>%s</color>"
    ctr.lab_name:SetText(string.format(newStr, itemData.color, itemData.rewardName .. "*" .. itemData.count))
    ctr.lab_pro:SetText(itemData.weight .. "%")
  end
end

local function OnPerLevelCreate(ctr)
  ctr.title = UIControl(ctr.transform, "img_bg/title")
  ctr.lab_pro = UIControl(ctr.transform, "Content/lab_pro")
end

local function OnPerLevelRefresh(ctr, _, itemData, ui)
  local titleNameStr = itemData[1].poolName
  ctr.title:SetText(titleNameStr)
  if ctr.labProContainer == nil then
    ctr.labProContainer = UIContainer(ctr.lab_pro, ui, OnLabProCreate, OnLabProRefresh)
  end
  itemData.isRich = nil
  ctr.labProContainer:SetData(itemData)
end

function Pandora_DescUI:InitUI()
  self.perLevelContainer = UIContainer(self.pro_level, self, OnPerLevelCreate, OnPerLevelRefresh)
end

function Pandora_DescUI:RegistUIEvents()
  self.Panel_Desc:SetOnClick(self, self.Panel_DescOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
end

function Pandora_DescUI:Panel_DescOnClick(control)
  UIManager.Hide(UIID.Pandora_DescUI)
end

function Pandora_DescUI:CloseBtnOnClick(control)
  UIManager.Hide(UIID.Pandora_DescUI)
end

function Pandora_DescUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Pandora_DescUI:RegistEvents()
  self:RegistEvent(Event.PandoraActivityRefreshDesc, self.OnRefreshDesc, self)
end

function Pandora_DescUI:OnRefreshDesc()
  self:Refresh()
end

function Pandora_DescUI:Refresh()
  PandoraActivityData.SetPandoraActivityAllRateInfo()
  local rewardData = PandoraActivityData.GetPandoraActivityAllRateInfo()
  self.perLevelContainer:SetData(rewardData)
  local lvCfg = ClientTable.cfg_Ui_descriptionManager:TryGetValue(1127)
  self.lab_DescTitle:SetText(lvCfg.title)
  self.lab_DescContent:SetText(lvCfg.desc)
end

function Pandora_DescUI:OnHide()
end

function Pandora_DescUI:OnDestroy()
end
