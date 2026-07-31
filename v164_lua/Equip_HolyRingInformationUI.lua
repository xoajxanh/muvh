Equip_HolyRingInformationUI = class(BaseUI)
Equip_HolyRingInformationUI.layer = UILayer.Panel
Equip_HolyRingInformationUI.orderInLayer = 0
Equip_HolyRingInformationUI.hideType = UIHideType.WaitDestroy
Equip_HolyRingInformationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolyRingInformationUI.escClose = UIEscClose.DontClose

function Equip_HolyRingInformationUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.go_alphaFilled = self:GetControl("bg_equip/PowerLevel/img_slider/go_alpha/go_alphaFilled")
  self.go_progress = self:GetControl("bg_equip/PowerLevel/img_slider/go_progress")
  self.lab = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab")
  self.text_atk = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atkimg")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.img_bg_xu = self:GetControl("bg_equip/PowerLevel/img_bg_hei/img_bg_xu")
  self.btn_add = self:GetControl("bg_equip/PowerLevel/btn_add")
end

function Equip_HolyRingInformationUI:Init()
end

function Equip_HolyRingInformationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolyRingInformationUI:InitUI()
  self.attributeTemp = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.HolyRingInformationAttributeTemp, self)
  self:InitAttribute()
end

function Equip_HolyRingInformationUI:InitAttribute()
  self.HolyRingAttribute = {}
  for attrType, index in pairs(HolyRingInformationAttributeEnum) do
    local itemAttribute = {}
    itemAttribute.attributeName = attrType
    itemAttribute.sort = index
    itemAttribute.type = HolyRingAttributeType.BasicAttributes
    table.insert(self.HolyRingAttribute, itemAttribute)
  end
  table.sort(self.HolyRingAttribute, function(a, b)
    return a.sort < b.sort
  end)
  local holeCount = ClientTable.cfg_Ring_levelManager:GetHolyRingHoleCount()
  for i = 1, holeCount do
    local itemAttribute = {}
    itemAttribute.attributeName = i
    itemAttribute.type = HolyRingAttributeType.HoleAddition
    table.insert(self.HolyRingAttribute, itemAttribute)
  end
end

function Equip_HolyRingInformationUI:RegistUIEvents()
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_add:SetOnClick(self, self.btn_AddOnClick)
end

function Equip_HolyRingInformationUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_HolyRingInformationUI")
  if lvCfg and table.count(lvCfg) > 0 then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_HolyRingInformationUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_HolyRingInformationUI)
end

function Equip_HolyRingInformationUI:btn_AddOnClick()
  local level = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingLevel()
  local experienceId = ClientTable.cfg_Ring_levelManager:GetExperienceIdByLevel(level)
  local itemData = ItemUtility.GenerateItemData(experienceId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  self.btn_add.itemData = itemData
  self.btn_add.OpenTipsType = EOpenTipsType.FastBuy
  ItemUtility.ClickObtainItemBtn(_, self.btn_add)
end

function Equip_HolyRingInformationUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolyRingInformationUI:RegistEvents()
  self:RegistEvent(Event.HolyRingWearChange, self.HolyRingWearChange, self)
end

function Equip_HolyRingInformationUI:Refresh()
  self:RefreshLevelAndExp()
  self:RefreshTotalAttribute()
end

function Equip_HolyRingInformationUI:HolyRingWearChange()
  self:RefreshLevelAndExp()
  self:RefreshTotalAttribute()
end

function Equip_HolyRingInformationUI:RefreshLevelAndExp()
  local level = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingLevel()
  local exp = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingExp()
  local totalExp = ClientTable.cfg_Ring_levelManager:GetTotalExpByLevel(level)
  if exp and totalExp then
    self.img_bg_xu:SetText(string.format("C\225\186\165p Th\195\161nh L\225\187\177c %d", level))
    self.go_progress:SetText(string.format("%d/%d", exp, totalExp))
    self.go_alphaFilled:SetFillAmount(exp / totalExp)
  end
end

function Equip_HolyRingInformationUI:RefreshTotalAttribute()
  self.attributeTemp:SetData(self.HolyRingAttribute)
end

function Equip_HolyRingInformationUI:OnHide()
end

function Equip_HolyRingInformationUI:OnDestroy()
end
