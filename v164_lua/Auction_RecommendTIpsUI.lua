Auction_RecommendTIpsUI = class(BaseUI)
Auction_RecommendTIpsUI.layer = UILayer.Background
Auction_RecommendTIpsUI.orderInLayer = 2
Auction_RecommendTIpsUI.hideType = UIHideType.Hide
Auction_RecommendTIpsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Auction_RecommendTIpsUI.escClose = UIEscClose.DontClose

function Auction_RecommendTIpsUI:InitControls()
  self.BG = self:GetControl("BG")
  self.btn_3DItem = self:GetControl("BG/img_Bg/btn_3DItem")
  self.lab_name = self:GetControl("BG/img_Bg/btn_3DItem/lab_name")
  self.MyName = self:GetControl("BG/img_Bg/btn_3DItem/MyName")
  self.lab_equiptips = self:GetControl("BG/lab_equiptips")
  self.btn_quickequip = self:GetControl("BG/btn_quickequip")
  self.lab_countdown = self:GetControl("BG/btn_quickequip/lab_countdown")
  self.btn_close = self:GetControl("BG/btn_close")
  self.lab_TipsName = self:GetControl("BG/lab_TipsName")
end

function Auction_RecommendTIpsUI:OnPreLoad()
end

function Auction_RecommendTIpsUI:Init()
  self.showCellData = ItemCellData()
end

function Auction_RecommendTIpsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Auction_RecommendTIpsUI:InitUI()
  self.BG_pos = self.BG.transform.localPosition
end

function Auction_RecommendTIpsUI:OnShow()
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
  self:Refresh()
end

function Auction_RecommendTIpsUI:OnHide()
  self.showCellData:RecycleRes()
  self.ShowItem = nil
end

function Auction_RecommendTIpsUI:OnDestroy()
  if self.showCellData then
    self.showCellData:RecycleRes()
    self.showCellData = nil
  end
end

function Auction_RecommendTIpsUI:Update()
  if self.showCellData and self.showCellData.model then
    local obj = self.showCellData.model.modelObject
    RoleEquipUtility.EquipModelRotation(obj, self.showCellData.itemData.tblItem.SpinAxis, 2)
  end
end

function Auction_RecommendTIpsUI:RegistUIEvents()
  self.btn_quickequip:SetOnClick(self, self.btn_quickequipOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Auction_RecommendTIpsUI:btn_quickequipOnClick(control)
  UIManager.Hide(UIID.AuctionRecommendTIpsUI)
  UIManager.Show(UIID.Auction_AuctionUI, {
    index = self.args.ItemInfo.index
  })
end

function Auction_RecommendTIpsUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.AuctionRecommendTIpsUI)
end

function Auction_RecommendTIpsUI:RegistEvents()
  self:RegistEvent(Event.TipsMainUIPosChange, self.TipsMainUIPosChange, self)
end

function Auction_RecommendTIpsUI:TipsMainUIPosChange(_, state)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  if state then
    self.BG.transform:DOLocalMove(self.BG_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.BG.transform:DOLocalMove(self.BG_pos + Vector3.New(0, -distance - 500, 0), animalTime):SetEase(Ease.OutQuad)
  end
end

function Auction_RecommendTIpsUI:Refresh()
  self.ShowItem = self.args.ItemInfo
  local itemData = ItemUtility.GenerateItemData(self.ShowItem.items.item.itemId)
  self.showCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.showCellData, self, true)
  local textWidth = self.lab_name.text.preferredWidth
  local bgWith = self.lab_name:GetSizeDelta()
  if textWidth > bgWith then
    local text = string.GetColorText(self.showCellData.itemData.tblItem.name, ItemQuality2ColorDic[self.showCellData.itemData.tblItem.colorShow])
    self.MyName.transform:GetComponent("AutoScrollText").text = text
    self.lab_name:SetActive(false)
    self.MyName:SetActive(true)
  else
    self.lab_name:SetActive(true)
    self.MyName:SetActive(false)
  end
end
