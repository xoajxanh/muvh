EfficientExpired_Tips = class(BaseUI)
EfficientExpired_Tips.layer = UILayer.Panel
EfficientExpired_Tips.orderInLayer = 0
EfficientExpired_Tips.hideType = UIHideType.WaitDestroy
EfficientExpired_Tips.hideFunc = UIHideFunc.MoveOutOfScreen
EfficientExpired_Tips.escClose = UIEscClose.DontClose

function EfficientExpired_Tips:InitControls()
  self.bg = self:GetControl("bg")
  self.ImgTitle = self:GetControl("ImgTitle")
  self.But_Close = self:GetControl("But_Close")
  self.go_itemModel = self:GetControl("go_itemModel")
  self.Btn_Efficient = self:GetControl("Btn_Efficient")
  self.Btn_EfficientText = self:GetControl("Btn_Efficient/Btn_EfficientText")
end

function EfficientExpired_Tips:OnPreLoad()
end

function EfficientExpired_Tips:Init()
end

function EfficientExpired_Tips:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function EfficientExpired_Tips:InitUI()
  self.showCellData = ItemCellData()
end

function EfficientExpired_Tips:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function EfficientExpired_Tips:OnHide()
end

function EfficientExpired_Tips:OnDestroy()
end

function EfficientExpired_Tips:RegistUIEvents()
  self.bg:SetOnClick(self, self.But_CloseOnClick)
  self.But_Close:SetOnClick(self, self.But_CloseOnClick)
  self.Btn_Efficient:SetOnClick(self, self.Btn_EfficientOnClick)
end

function EfficientExpired_Tips:But_CloseOnClick(control)
  EventManager.Dispatch(Event.EfficientExpired_DownTips)
  UIManager.Hide(UIID.EfficientExpired_Tips)
  ExpiredPromptData.TraverseShowUI()
end

function EfficientExpired_Tips:Btn_EfficientOnClick(control)
  self:But_CloseOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Shop_ExpUpUI)
end

function EfficientExpired_Tips:RegistEvents()
end

function EfficientExpired_Tips:Refresh()
  ExpiredPromptData.RemoveExpiredByType(ExpiredTypeEnum.Efficient)
  local Efficientid = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2210108))
  local itemData = ItemUtility.GenerateItemData(Efficientid)
  self.showCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.go_itemModel, self.showCellData, self, true)
end
