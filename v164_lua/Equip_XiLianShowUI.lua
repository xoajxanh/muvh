Equip_XiLianShowUI = class(BaseUI)
Equip_XiLianShowUI.layer = UILayer.Tip
Equip_XiLianShowUI.orderInLayer = 1
Equip_XiLianShowUI.hideType = UIHideType.WaitDestroy
Equip_XiLianShowUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_XiLianShowUI.escClose = UIEscClose.DontClose

function Equip_XiLianShowUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.Grid_Attribute = self:GetControl("bg_equip/panel_result/Grid_Attribute")
  self.NormalAttribute = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute")
  self.lab = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab")
  self.text_atk = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atkimg")
  self.NewAttribute = self:GetControl("bg_equip/panel_result/Grid_Attribute/NewAttribute")
  self.NewAttribute_lab = self:GetControl("bg_equip/panel_result/Grid_Attribute/NewAttribute/lab_normalAttribute/img_titleico/content/lab")
  self.needMaterial = self:GetControl("bg_equip/needMaterial")
  self.frame_item = self:GetControl("bg_equip/needMaterial/materialParent/frame_item")
  self.Img_noItem = self:GetControl("bg_equip/Img_noItem")
  self.btn_save = self:GetControl("btn_save")
  self.btn_ok = self:GetControl("btn_ok")
  self.descBtn = self:GetControl("descBtn")
  self.cost = self:GetControl("cost")
  self.Content = self:GetControl("cost/Viewport/Content")
  self.sellProfit = self:GetControl("cost/Viewport/Content/sellProfit")
  self.coin_Item = self:GetControl("cost/Viewport/Content/sellProfit/coin_Item")
  self.lab_num = self:GetControl("cost/Viewport/Content/sellProfit/lab_num")
  self.btn_obtain = self:GetControl("cost/Viewport/Content/sellProfit/btn_obtain")
end

function Equip_XiLianShowUI:Init()
end

function Equip_XiLianShowUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_XiLianShowUI:InitUI()
  self.oldAttributesTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.newAttributesTemplate = UIUtility.BindUIContainerTemp(self.NewAttribute_lab, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.costItemsTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
end

function Equip_XiLianShowUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_save:SetOnClick(self, self.btn_saveOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
end

function Equip_XiLianShowUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_XiLianShowUI)
end

function Equip_XiLianShowUI:btn_saveOnClick(control)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr().XiLianEquipCellData ~= nil then
    networkRequest.ReqEquipExcellentClear(gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr().XiLianEquipCellData.itemData.id, 0)
    UIManager.Hide(UIID.Equip_XiLianShowUI)
  end
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {
      name = "Eff_UI_xilianchenggong",
      time = 1
    })
  else
    UIManager.Show(UIID.EffectTipUI, {
      name = "Eff_UI_xilianchenggong",
      effectTime = 1
    })
  end
end

function Equip_XiLianShowUI:btn_okOnClick(control)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr().XiLianEquipCellData ~= nil then
    local lackCostItemInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr().XiLianEquipCellData.itemData:GetXiLianLackCostItemId()
    if lackCostItemInfo ~= nil then
      TipUtility.ShowQuickGetTipPanel(lackCostItemInfo.itemId)
      return
    end
    networkRequest.ReqEquipExcellentClear(gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr().XiLianEquipCellData.itemData.id, 1)
  end
end

function Equip_XiLianShowUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_XiLianShowUI:RegistEvents()
  self:RegistEvent(Event.Equip_XiLianNewExcellenceChange, self.OnEquip_XiLianNewExcellenceChange, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBag_ResBagChange, self)
end

function Equip_XiLianShowUI:OnEquip_XiLianNewExcellenceChange()
  self:RefreshNewExcellenceList()
end

function Equip_XiLianShowUI:OnBag_ResBagChange()
  self:RefreshCost()
end

function Equip_XiLianShowUI:Refresh()
  self:RefreshEquipExcellenceList()
  self:RefreshNewExcellenceList()
  self:RefreshCost()
end

function Equip_XiLianShowUI:RefreshEquipExcellenceList()
  local haveExcellenceList = gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():HaveExcellenceList()
  self.NormalAttribute:SetActive(haveExcellenceList)
  if haveExcellenceList then
    self.oldAttributesTemplate:SetData(gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr().XiLianEquipCellData.itemData:GetEquipExcellenceTemplateDesList())
  end
end

function Equip_XiLianShowUI:RefreshNewExcellenceList()
  local haveNewExcellenceList = gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():HaveNewExcellenceList()
  self.NewAttribute:SetActive(haveNewExcellenceList)
  if haveNewExcellenceList then
    self.newAttributesTemplate:SetData(gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():GetXiLianNewExcellenceTemplateDesList())
  end
end

function Equip_XiLianShowUI:RefreshCost()
  local needCost = gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():NeedCost()
  self.needMaterial:SetActive(needCost)
  if needCost then
    self.costItemsTemplate:SetData(gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr().XiLianEquipCellData.itemData:GetXilianCost())
  end
end

function Equip_XiLianShowUI:OnHide()
  gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():ClearXiLianNewExcellenceList()
end

function Equip_XiLianShowUI:OnDestroy()
  gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():ClearXiLianNewExcellenceList()
end
