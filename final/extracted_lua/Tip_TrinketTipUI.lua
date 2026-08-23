Tip_TrinketTipUI = class(BaseUI)
Tip_TrinketTipUI.layer = UILayer.MessageBox
Tip_TrinketTipUI.orderInLayer = 1
Tip_TrinketTipUI.hideType = UIHideType.WaitDestroy
Tip_TrinketTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_TrinketTipUI.escClose = UIEscClose.DontClose

function Tip_TrinketTipUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.mask = self:GetControl("mask")
  self.background = self:GetControl("background")
  self.Img_TipBg = self:GetControl("Img_TipBg")
  self.go_Item = self:GetControl("Img_TipBg/go_Item")
  self.lab_title = self:GetControl("Img_TipBg/lab_title")
  self.btn_3DItem = self:GetControl("Img_TipBg/go_Item/Viewport/grid_Item/btn_3DItem")
end

function Tip_TrinketTipUI:Init()
end

function Tip_TrinketTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_TrinketTipUI:InitUI()
  local infoData = {
    dataInfo = self:GetDataInfo(),
    plyerType = self.args.plyerType
  }
  self.btn_3DItemTemp = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.Tip_TrinketTipTemplate, self, infoData)
end

function Tip_TrinketTipUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
end

function Tip_TrinketTipUI:btn_CloseOnClick(control)
  UIManager.Hide("Tip_TrinketTipUI")
end

function Tip_TrinketTipUI:btn_3DItemOnClick(control)
end

function Tip_TrinketTipUI:OnShow()
  self:InitTemplateData()
  self:RegistEvents()
  self:Refresh()
end

function Tip_TrinketTipUI:RegistEvents()
  self:RegistEvent(Event.EquipInfoChange, self.OnEquipInfoChange, self)
end

function Tip_TrinketTipUI:OnEquipInfoChange()
  local equipData = self:GetDataInfo():TryGetStartEquipDataItem(self.args.equipIndex)
  if equipData == nil then
    self:btn_CloseOnClick()
    return
  end
  self:Refresh()
end

function Tip_TrinketTipUI:InitTemplateData()
  local infoData = {
    dataInfo = self:GetDataInfo(),
    plyerType = self.args.plyerType
  }
  self.btn_3DItemTemp:InitTemplateData(infoData)
end

function Tip_TrinketTipUI:Refresh()
  if self.args ~= nil then
    self.equipIndex = self.args.equipIndex
    self.baseTransform = self.args.baseTransform
    self:SetSprite("Atlas_Language", "txt_tip_trinket_" .. self.equipIndex, self.lab_title)
    self.btn_3DItemTemp:SetData(self:GetDataInfo():GetIndexList(self.args.equipIndex))
    if self.baseTransform ~= nil then
      local y = self.baseTransform.position.y - 0.7
      local x = self.baseTransform.position.x + 3.1
      local z = self.Img_TipBg.transform.position.z
      self.Img_TipBg.transform.position = Vector3.New(x, y, z)
      self.mask.transform.position = Vector3.New(self.baseTransform.position.x, self.baseTransform.position.y + 0.35, z)
      self.background.transform.position = Vector3.New(self.baseTransform.position.x + 1, self.background.transform.position.y, z)
    end
  end
end

function Tip_TrinketTipUI:GetDataInfo()
  if self.args ~= nil and self.args.plyerType == EUIPlyerType.OtherPlayer then
    return gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData()
  end
  return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData()
end

function Tip_TrinketTipUI:OnHide()
  self.btn_3DItemTemp:SetTemplateData(nil, function(itemTemp, data)
    itemTemp:RecycleRes()
  end)
end

function Tip_TrinketTipUI:OnDestroy()
end
