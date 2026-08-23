Equip_XiLianUI = class(BaseUI)
Equip_XiLianUI.layer = UILayer.Panel
Equip_XiLianUI.orderInLayer = 1
Equip_XiLianUI.hideType = UIHideType.WaitDestroy
Equip_XiLianUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_XiLianUI.escClose = UIEscClose.DontClose

function Equip_XiLianUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.fisrtframe = self:GetControl("bg_equip/panel_euqip/fisrtframe")
  self.state_main = self:GetControl("bg_equip/panel_euqip/fisrtframe/state_main")
  self.main_plus = self:GetControl("bg_equip/panel_euqip/main_plus")
  self.Grid_Attribute = self:GetControl("bg_equip/panel_result/Grid_Attribute")
  self.NormalAttribute = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute")
  self.lab = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab")
  self.text_atk = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab/lab_atk/text_atkimg")
  self.NewAttribute = self:GetControl("bg_equip/panel_result/Grid_Attribute/NewAttribute")
  self.btn_ok = self:GetControl("btn_ok")
  self.descBtn = self:GetControl("descBtn")
  self.cost = self:GetControl("cost")
  self.Content = self:GetControl("cost/Viewport/Content")
  self.sellProfit = self:GetControl("cost/Viewport/Content/sellProfit")
  self.coin_Item = self:GetControl("cost/Viewport/Content/sellProfit/coin_Item")
  self.lab_num = self:GetControl("cost/Viewport/Content/sellProfit/lab_num")
  self.btn_obtain = self:GetControl("cost/Viewport/Content/sellProfit/btn_obtain")
  self.lab_item = self:GetControl("bg_equip/panel_euqip/bg_item/lab_item")
  self.needMaterial = self:GetControl("bg_equip/needMaterial")
  self.frame_item = self:GetControl("bg_equip/needMaterial/materialParent/frame_item")
  self.Img_noItem = self:GetControl("bg_equip/Img_noItem")
end

function Equip_XiLianUI:Init()
end

function Equip_XiLianUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_XiLianUI:InitUI()
  self.attributesTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.costItemsTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
end

function Equip_XiLianUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.fisrtframe:SetOnClick(self, self.fisrtframeOnClick)
end

function Equip_XiLianUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_XiLianUI)
end

function Equip_XiLianUI:btn_okOnClick(control)
  if self.equipData == nil then
    return
  end
  local lackCostItemInfo = self.equipData:GetXiLianLackCostItemId()
  if lackCostItemInfo ~= nil then
    TipUtility.ShowQuickGetTipPanel(lackCostItemInfo.itemId)
    return
  end
  if self.equipData:GetXiLianExcellenceDesList() ~= nil and next(self.equipData:GetXiLianExcellenceDesList()) ~= nil then
    UIManager.Show(UIID.Equip_XiLianShowUI)
  else
    networkRequest.ReqEquipExcellentClear(self.equipData.id, 1)
  end
end

function Equip_XiLianUI:descBtnOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1065})
end

function Equip_XiLianUI:fisrtframeOnClick(control)
  self:ResetDataAndPanel()
end

function Equip_XiLianUI:OnShow()
  self:ResetData()
  self:RegistEvents()
  self:Refresh()
  self:RefreshPanel()
end

function Equip_XiLianUI:ResetData()
  if self.itemCellData ~= nil then
    ItemUtility.HideItemCell(self.fisrtframe, self.itemCellData)
  end
  gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():ClearXiLianData()
  self.itemCellData = nil
  self.equipData = nil
end

function Equip_XiLianUI:RegistEvents()
  self:RegistEvent(Event.Equip_XiLianChange, self.OnEquip_XiLianChange, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBag_ResBagChange, self)
end

function Equip_XiLianUI:OnEquip_XiLianChange(id, itemCellData)
  if self.itemCellData ~= nil then
    ItemUtility.HideItemCell(self.fisrtframe, self.itemCellData)
  end
  self.itemCellData = itemCellData
  self.equipData = self.itemCellData.itemData
  self:RefreshPanel()
end

function Equip_XiLianUI:OnBag_ResBagChange()
  self:RefreshCost()
end

function Equip_XiLianUI:Refresh()
  UIManager.Show(UIID.NewBagInfoUI, {
    OpenType = TransferOpenType.XiLian
  })
end

function Equip_XiLianUI:RefreshPanel()
  self:RefreshEquip()
  self:RefreshExcellenceAttribute()
  self:RefreshCost()
  self:RefreshXiLianBtn()
  self:RefreshNoItem()
end

function Equip_XiLianUI:RefreshEquip()
  self.lab_item:SetActive(self:HaveChooseData())
  if self.equipData ~= nil then
    self.lab_item:SetText(self.equipData.tblItem.name)
  end
  self.main_plus:SetActive(not self:HaveChooseData())
  if self.itemCellData ~= nil then
    ItemUtility.ShowItemCell(self.fisrtframe, self.itemCellData, self)
  end
end

function Equip_XiLianUI:RefreshExcellenceAttribute()
  self.NormalAttribute:SetActive(self:HaveExcellenceList())
  if self.equipData ~= nil then
    self.attributesTemplate:SetData(self.equipData:GetEquipExcellenceTemplateDesList())
  end
end

function Equip_XiLianUI:RefreshCost()
  self.needMaterial:SetActive(self:HaveCost())
  if self.equipData ~= nil then
    local costList = self.equipData:GetXilianCost()
    if type(costList) == "table" then
      self.costItemsTemplate:SetData(costList)
    end
  end
end

function Equip_XiLianUI:RefreshXiLianBtn()
  self.btn_ok:SetActive(self:HaveChooseData() and self:HaveExcellenceList())
end

function Equip_XiLianUI:RefreshNoItem()
  self.Img_noItem:SetActive(not self:HaveChooseData() or not self:HaveExcellenceList())
end

function Equip_XiLianUI:HaveChooseData()
  return self.itemCellData ~= nil and self.equipData ~= nil and self.equipData:CheckCanXiLian() == true
end

function Equip_XiLianUI:HaveExcellenceList()
  return self:HaveChooseData() and #self.equipData:GetEquipExcellenceDesList() > 0
end

function Equip_XiLianUI:HaveCost()
  return self:HaveChooseData() and type(self.equipData:GetXilianCost()) == "table" and #self.equipData:GetXilianCost() > 0
end

function Equip_XiLianUI:ResetDataAndPanel()
  self:ResetData()
  self:RefreshPanel()
  EventManager.Dispatch(Event.Bag_RefreshShowXiLian)
end

function Equip_XiLianUI:OnHide()
  self:ResetData()
end

function Equip_XiLianUI:OnDestroy()
  self:ResetData()
end
