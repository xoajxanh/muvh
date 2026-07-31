Attribute_AddTipsUI = class(BaseUI)
Attribute_AddTipsUI.layer = UILayer.Background
Attribute_AddTipsUI.orderInLayer = 1
Attribute_AddTipsUI.hideType = UIHideType.Hide
Attribute_AddTipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Attribute_AddTipsUI.escClose = UIEscClose.DontClose

function Attribute_AddTipsUI:InitControls()
  self.BG = self:GetControl("BG")
  self.img_Bg = self:GetControl("BG/img_Bg")
  self.lab_attributetips = self:GetControl("BG/img_Bg/lab_attributetips")
  self.lab_attributepoints = self:GetControl("BG/img_Bg/lab_attributepoints")
  self.lab_attributeadd = self:GetControl("BG/lab_attributeadd")
  self.btn_quickadd = self:GetControl("BG/btn_quickadd")
  self.lab_quickeadd = self:GetControl("BG/btn_quickadd/lab_quickeadd")
  self.btn_close = self:GetControl("BG/btn_close")
end

local this = Attribute_AddTipsUI

function Attribute_AddTipsUI:OnPreLoad()
end

function Attribute_AddTipsUI:Init()
end

function Attribute_AddTipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Attribute_AddTipsUI:InitUI()
  self.BG_pos = self.BG.transform.localPosition
  self.Point = 0
end

function Attribute_AddTipsUI:OnShow()
  if SceneData.mapId and SceneData.mapId == 1095 then
    UIManager.Hide(UIID.AttributeAddTipsUI)
    return
  end
  self:RegistEvents()
  local main = UIManager.GetUiByName(UIID.MainMenuUI)
  if main then
    if main.state then
      self.BG.transform.localPosition = self.BG_pos
    else
      self.BG.transform.localPosition = Vector3.New(self.BG_pos.x, self.BG_pos.y - 500, self.BG_pos.z)
    end
  else
    self.BG.transform.localPosition = self.BG_pos
  end
  self:ShowData()
  self:Refresh()
end

function Attribute_AddTipsUI:ShowData()
  if table.count(self.args.ItemInfo) == 0 then
    if self.Point == 0 then
      self:btn_closeOnClick()
    else
      self.args.ItemInfo[1] = self.Point
    end
  end
end

function Attribute_AddTipsUI:OnHide()
  self.args.ItemInfo = {}
end

function Attribute_AddTipsUI:OnDestroy()
end

function Attribute_AddTipsUI:RegistUIEvents()
  self.btn_quickadd:SetOnClick(self, self.btn_quickaddOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Attribute_AddTipsUI:btn_quickaddOnClick(control)
  UIManager.Show(UIID.Role_AttributeUI, {FristPanelUI = true})
  self.Point = 0
  UIManager.Hide(UIID.AttributeAddTipsUI)
  TipData.OpenNextUI()
end

function Attribute_AddTipsUI:btn_closeOnClick(control)
  self.Point = 0
  UIManager.Hide(UIID.AttributeAddTipsUI)
  TipData.OpenNextUI()
end

function Attribute_AddTipsUI:RegistEvents()
  self:RegistEvent(Event.Role_MyAttributeChanged, self.On_RoleAttributeChanged, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.TipsMainUIPosChange, self.TipsMainUIPosChange, self)
  self:RegistEvent(Event.HideQuickUseWindow, self.HideThisUI, self)
end

function Attribute_AddTipsUI:HideThisUI()
  UIManager.Hide(UIID.AttributeAddTipsUI)
end

function Attribute_AddTipsUI:PointChanged(_, data)
  if data.attributePoint == 0 then
    self:btn_closeOnClick()
  else
    self.Point = data.attributePoint
    self.lab_attributepoints:SetText(self.Point)
  end
end

function Attribute_AddTipsUI:OnBagChange(id, msg)
  local id
  if msg and msg.removeItems and TipData.bageChangeType(msg) then
    for i, v in pairs(msg.removeItems) do
      if v.id then
        id = v.id
        TipData.BagChangeRefrsh(id)
      end
    end
  end
end

function Attribute_AddTipsUI:TipsMainUIPosChange(_, state)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  if state then
    self.BG.transform:DOLocalMove(self.BG_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.BG.transform:DOLocalMove(self.BG_pos + Vector3.New(0, -distance - 500, 0), animalTime):SetEase(Ease.OutQuad)
  end
end

function Attribute_AddTipsUI:On_RoleAttributeChanged(_, changeList)
  if changeList[EAttributeType.strength] ~= nil or changeList[EAttributeType.agility] ~= nil or changeList[EAttributeType.vitality] ~= nil or changeList[EAttributeType.energy] ~= nil then
    if ViewData.meData.validAttributePoint == 0 then
      self:btn_closeOnClick()
    else
      self.Point = ViewData.meData.validAttributePoint
      self.lab_attributepoints:SetText(self.Point)
    end
  end
end

function Attribute_AddTipsUI:Refresh()
  self.Point = ViewData.meData.validAttributePoint
  self.lab_attributeadd:SetText("C\195\179 th\225\187\131 t\196\131ng \196\145i\225\187\131m")
  self.lab_attributepoints:SetText(self.Point)
  if not string.isNullOrEmpty(self.args.attributetips) then
    self.lab_attributetips:SetText(self.args.attributetips)
  end
  if not string.isNullOrEmpty(self.args.quickeaddbutton) then
    self.btn_quickadd:SetText(self.args.quickeaddbutton)
  end
end

function Attribute_AddTipsUI:PushStackData()
  TipData.PopUpItemData(TipShowSort.addPoint, {
    self.Point
  })
  self:btn_closeOnClick()
end
