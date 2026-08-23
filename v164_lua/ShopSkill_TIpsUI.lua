ShopSkill_TIpsUI = class(BaseUI)
ShopSkill_TIpsUI.layer = UILayer.Background
ShopSkill_TIpsUI.orderInLayer = 2
ShopSkill_TIpsUI.hideType = UIHideType.Hide
ShopSkill_TIpsUI.hideFunc = UIHideFunc.MoveOutOfScreen
ShopSkill_TIpsUI.escClose = UIEscClose.DontClose

function ShopSkill_TIpsUI:InitControls()
  self.Bg = self:GetControl("Bg")
  self.btn_3DItem = self:GetControl("Bg/img_Bg/btn_3DItem")
  self.lab_name = self:GetControl("Bg/img_Bg/btn_3DItem/lab_name")
  self.MyName = self:GetControl("Bg/img_Bg/btn_3DItem/MyName")
  self.lab_equiptips = self:GetControl("Bg/lab_equiptips")
  self.btn_goBuy = self:GetControl("Bg/btn_goBuy")
  self.lab_goBuy = self:GetControl("Bg/btn_goBuy/lab_goBuy")
  self.btn_close = self:GetControl("Bg/btn_close")
end

function ShopSkill_TIpsUI:OnPreLoad()
end

function ShopSkill_TIpsUI:Init()
  self.showCellData = ItemCellData()
end

function ShopSkill_TIpsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function ShopSkill_TIpsUI:InitUI()
  self.BG_pos = self.Bg.transform.localPosition
end

function ShopSkill_TIpsUI:OnShow()
  if SceneData.mapId and SceneData.mapId == 1095 then
    UIManager.Hide(UIID.ShopSkillTIpsUI)
    return
  end
  if self.Bg == nil then
    UIManager.Hide(UIID.ShopSkillTIpsUI)
    return
  end
  self:RegistEvents()
  local main = UIManager.GetUiByName(UIID.MainMenuUI)
  if main then
    if main.state then
      self.Bg.transform.localPosition = self.BG_pos
    else
      self.Bg.transform.localPosition = Vector3.New(self.BG_pos.x, self.BG_pos.y - 500, self.BG_pos.z)
    end
  else
    self.Bg.transform.localPosition = self.BG_pos
  end
  self:ShowData()
  self:Refresh()
end

function ShopSkill_TIpsUI:ShowData()
  if table.count(self.args.ItemInfo) ~= 0 then
    self.ShowItem = self.args.ItemInfo[1]
    table.remove(self.args.ItemInfo, 1)
  elseif self.ShowItem == nil then
    self:btn_closeOnClick()
  end
end

function ShopSkill_TIpsUI:OnHide()
end

function ShopSkill_TIpsUI:OnDestroy()
end

function ShopSkill_TIpsUI:Update()
  if self.showCellData and self.showCellData.model then
    local obj = self.showCellData.model.modelObject
    RoleEquipUtility.EquipModelRotation(obj, self.showCellData.itemData.tblItem.SpinAxis, 2)
  end
end

function ShopSkill_TIpsUI:RegistUIEvents()
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
  self.btn_goBuy:SetOnClick(self, self.btn_goBuyOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function ShopSkill_TIpsUI:btn_3DItemOnClick(control)
end

function ShopSkill_TIpsUI:btn_goBuyOnClick(control)
  TipData.CloseItemData(TipShowSort.ShopSkill)
  UIManager.Show(UIID.Shop, TipData.shopTypeTbl)
  self:btn_closeOnClick()
end

function ShopSkill_TIpsUI:btn_closeOnClick(control)
  self.ShowItem = nil
  UIManager.Hide(UIID.ShopSkillTIpsUI)
  TipData.OpenNextUI()
end

function ShopSkill_TIpsUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.TipsMainUIPosChange, self.TipsMainUIPosChange, self)
  self:RegistEvent(Event.HideQuickUseWindow, self.HideThisUI, self)
end

function ShopSkill_TIpsUI:HideThisUI()
  UIManager.Hide(UIID.ShopSkillTIpsUI)
end

function ShopSkill_TIpsUI:OnBagChange(id, msg)
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

function ShopSkill_TIpsUI:TipsMainUIPosChange(_, state)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  if self.Bg == nil then
    return
  end
  if state then
    self.Bg.transform:DOLocalMove(self.BG_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.Bg.transform:DOLocalMove(self.BG_pos + Vector3.New(0, -distance - 500, 0), animalTime):SetEase(Ease.OutQuad)
  end
end

function ShopSkill_TIpsUI:Refresh()
  if self.ShowItem then
    local itemData = ItemUtility.GenerateItemData(self.ShowItem.id)
    self.showCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.btn_3DItem, self.showCellData, self, true)
    local textWidth = self.lab_name.text.preferredWidth
    local bgWith = self.lab_name:GetSizeDelta()
    if textWidth > bgWith then
      local text = string.GetColorText(self.ShowItem.name, ItemQuality2ColorDic[self.ShowItem.colorShow])
      self.MyName.transform:GetComponent("AutoScrollText").text = text
      self.lab_name:SetActive(false)
      self.MyName:SetActive(true)
    else
      self.lab_name:SetActive(true)
      self.MyName:SetActive(false)
    end
  else
    self:btn_closeOnClick()
  end
end

function ShopSkill_TIpsUI:PushStackData()
  TipData.CoverItemData(TipShowSort.ShopSkill, {
    self.ShowItem
  })
  self:btn_closeOnClick()
end
