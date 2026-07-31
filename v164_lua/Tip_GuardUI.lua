Tip_GuardUI = class(BaseUI)
Tip_GuardUI.layer = UILayer.Tip
Tip_GuardUI.orderInLayer = 8
Tip_GuardUI.hideType = UIHideType.WaitDestroy
Tip_GuardUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_GuardUI.escClose = UIEscClose.DontClose

function Tip_GuardUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.go_obtain = self:GetControl("ExtendPanel/go_obtain")
  self.img_obtainBg = self:GetControl("ExtendPanel/go_obtain/img_obtainBg")
  self.grid_obtain = self:GetControl("ExtendPanel/go_obtain/grid_obtain")
  self.bg_obtain = self:GetControl("ExtendPanel/go_obtain/grid_obtain/bg_obtain")
  self.buy_thing = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing")
  self.model_item = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/model_item")
  self.btn_quick_buy = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/btn_quick_buy")
  self.model_money = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/model_money")
  self.img_itemicon = self:GetControl("ExtendPanel/go_obtain/buy_content/buy_thing/img_itemicon")
  self.Img_TipBg = self:GetControl("Img_TipBg")
  self.grid_attribute = self:GetControl("Img_TipBg/sv_center/Viewport/Content/grid_attribute")
  self.Model = self:GetControl("Img_TipBg/sv_center/Viewport/Content/grid_attribute/Attribute/Model")
  self.Attribute = self:GetControl("Img_TipBg/sv_center/Viewport/Content/grid_attribute/Attribute")
  self.img_topBg = self:GetControl("Img_TipBg/go_top/img_topBg")
  self.go_btns = self:GetControl("Img_TipBg/go_bottom/go_btns/btn_CenterClick")
  self.go_bottom = self:GetControl("Img_TipBg/go_bottom")
end

function Tip_GuardUI:Init()
  self.minWidth = 360
  self.minHeight = 120
end

function Tip_GuardUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_GuardUI:InitUI()
  self.AttributeTemp = UIUtility.BindUIContainerTemp(self.Attribute, LuaComponentTemplates.Tips_GuardAttributesTemplate, self)
end

function Tip_GuardUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.model_item:SetOnClick(self, self.model_itemOnClick)
  self.btn_quick_buy:SetOnClick(self, self.btn_quick_buyOnClick)
  self.model_money:SetOnClick(self, self.model_moneyOnClick)
  self.img_itemicon:SetOnClick(self, self.img_itemiconOnClick)
  self.Model:SetOnClick(self, self.ModelOnClick)
  self.go_btns:SetOnClick(self, self.go_btnsOnClick)
end

function Tip_GuardUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Tip_GuardUI)
end

function Tip_GuardUI.go_btnsOnClick()
  UIManager.Hide(UIID.Tip_GuardUI)
  UIManager.Hide(UIID.Bag_EquipInfoUI)
  UIManager.Hide(UIID.Bag_3DBagInfoUI)
  UIManager.Show(UIID.Equip_GuardNavUI)
end

function Tip_GuardUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_GuardUI:RegistEvents()
end

function Tip_GuardUI:Refresh()
  self.TipShowData = self:GetDataInfo():GetTipShowData()
  if self.TipShowData == nil or #self.TipShowData == 0 then
    UIManager.Hide(UIID.Tip_GuardUI)
  end
  self.AttributeTemp:SetData(self.TipShowData)
  self:RefreshPositionAdaptation()
  self:RefreshBtnShow()
end

function Tip_GuardUI:RefreshPositionAdaptation()
  if self.TipShowData == nil then
    self.TipShowData = self:GetDataInfo():GetTipShowData()
  end
  if self.TipShowData == nil then
    return
  end
  local datalength = #self.TipShowData
  local GridLayoutGroup = self.grid_attribute.transform:GetComponent("GridLayoutGroup")
  local cell = GridLayoutGroup.cellSize
  local spa = GridLayoutGroup.spacing
  local switchplusY = cell.y + spa.y
  local Size_Y = switchplusY * datalength
  local maxheight = self.minHeight + Size_Y
  self.go_bottom:SetAnchoredPosition(0, -Size_Y - 50)
  self.img_topBg:SetSizeDelta(self.minWidth, maxheight + 50)
end

function Tip_GuardUI:GetDataInfo()
  if self.args ~= nil and self.args.plyerType == EUIPlyerType.OtherPlayer then
    return gameMgr:GetAvatarManager():GetOtherPlayer():GetGuardData()
  end
  return gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData()
end

function Tip_GuardUI:RefreshBtnShow()
  if UIManager.IsVisible(UIID.Bag_EquipInfoUI) then
    self.go_btns:SetActive(true)
  else
    self.go_btns:SetActive(false)
  end
end

function Tip_GuardUI:OnHide()
end

function Tip_GuardUI:OnDestroy()
end
