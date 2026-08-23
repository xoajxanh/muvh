SeaChest_TipsUI = class(BaseUI)
SeaChest_TipsUI.layer = UILayer.Tip
SeaChest_TipsUI.orderInLayer = 0
SeaChest_TipsUI.hideType = UIHideType.WaitDestroy
SeaChest_TipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
SeaChest_TipsUI.escClose = UIEscClose.DontClose

function SeaChest_TipsUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.Img_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Img_TipTitle")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/img_TipTitle/Text_TipTitle")
  self.lab_TipContent = self:GetControl("Panel_Tip/Image_TipBg/lab_TipContent")
  self.btn_3DItem = self:GetControl("Panel_Tip/Image_TipBg/Grid_Items/Viewport/Content/btn_3DItem")
  self.grid_Items = self:GetControl("Panel_Tip/Image_TipBg/Grid_Items")
  self.lab_TipContents = self:GetControl("Panel_Tip/Image_TipBg/img_bg/img_bgBg/lab_TipContent")
  self.img_icon = self:GetControl("Panel_Tip/Image_TipBg/img_icon")
  self.img_icon_title = self:GetControl("Panel_Tip/Image_TipBg/img_icon/lab_title")
end

function SeaChest_TipsUI:Init()
end

function SeaChest_TipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function SeaChest_TipsUI:InitUI()
end

function SeaChest_TipsUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
end

function SeaChest_TipsUI:Bg_CloseOnClick(control)
  UIManager.Hide(UIID.SeaChest_TipsUI)
end

function SeaChest_TipsUI:btn_3DItemOnClick(control)
end

function SeaChest_TipsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function SeaChest_TipsUI:RegistEvents()
  self:OnInitUIPanel()
end

local function OnSubMenuCreate(ctr)
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
end

local function OnSubMenuShow(ctr, index, data, ui)
  if data == nil then
    return
  end
  if ctr.itemcelldata == nil then
    ctr.itemcelldata = ItemCellData()
  end
  logError(data.itemId)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  ctr.itemcelldata:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemcelldata, ui, true)
end

function SeaChest_TipsUI:OnInitUIPanel()
end

function SeaChest_TipsUI:UpdateWildCellCallBack(index)
  if type(self.data) ~= "table" or next(self.data) == nil then
    return
  end
  if self.data[index] ~= nil then
    local cell = self.logsView:GetLoadedCell(index)
    self:RefreshLogView(self.data[index], cell, index)
  end
end

function SeaChest_TipsUI:Refresh()
  if self.args and self.args.data then
    local dataInfo = self.args.data
    if self.args.isreacher then
      if self.img_icon ~= nil then
        self:SetSprite("Atlas_Common", dataInfo.data.iconf, self.img_icon, true)
      end
      if self.lab_TipContents then
        self.lab_TipContents:SetText(dataInfo.data.chestDescf)
      end
      if self.img_icon_title then
        self.img_icon_title:SetText(dataInfo.data.chestNamef)
      end
      if self.Text_TipTitle then
        self.Text_TipTitle:SetText(dataInfo.data.freeName)
      end
    else
      if self.img_icon ~= nil then
        self:SetSprite("Atlas_Common", dataInfo.data.icond, self.img_icon, true)
      end
      if self.lab_TipContents then
        self.lab_TipContents:SetText(dataInfo.data.chestDescd)
      end
      if self.img_icon_title then
        self.img_icon_title:SetText(dataInfo.data.chestNamed)
      end
      if self.Text_TipTitle then
        self.Text_TipTitle:SetText(dataInfo.data.diamondName)
      end
    end
  end
end

function SeaChest_TipsUI:OnHide()
  if self.combineItemContainer then
    self.combineItemContainer:RemoveAll()
  end
end

function SeaChest_TipsUI:OnDestroy()
end
