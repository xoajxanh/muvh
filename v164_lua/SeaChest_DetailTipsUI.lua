SeaChest_DetailTipsUI = class(BaseUI)
SeaChest_DetailTipsUI.layer = UILayer.Tip
SeaChest_DetailTipsUI.orderInLayer = 0
SeaChest_DetailTipsUI.hideType = UIHideType.WaitDestroy
SeaChest_DetailTipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
SeaChest_DetailTipsUI.escClose = UIEscClose.DontClose

function SeaChest_DetailTipsUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Items = self:GetControl("Panel_Items")
  self.Image_TipBg = self:GetControl("Panel_Items/Image_TipBg")
  self.img_TipTitle = self:GetControl("Panel_Items/Image_TipBg/img_TipTitle")
  self.Text_TipTitle = self:GetControl("Panel_Items/Image_TipBg/img_TipTitle/Text_TipTitle")
  self.btn_3DItem = self:GetControl("Panel_Items/Grid_Items/Viewport/Content/btn_3DItem")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Img_TipBg = self:GetControl("Panel_Tip/Img_TipBg")
end

function SeaChest_DetailTipsUI:Init()
  self.listgameObject = {}
end

function SeaChest_DetailTipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function SeaChest_DetailTipsUI:InitUI()
end

function SeaChest_DetailTipsUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
  self:OnInitList()
end

local function OnSubMenuCreate(ctr)
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.img_icon = UIControl(ctr.transform, "img_icon/icon")
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr.grid_leftIcon = UIControl(ctr.transform, "grid_leftIcon")
  ctr.lab_pro = UIControl(ctr.transform, "pro_icon/lab_pro")
  ctr.img_elementQuality = UIControl(ctr.transform, "img_icon/rarity")
end

local function OnSubMenuShow(ctr, index, data, ui)
  if data == nil then
    return
  end
  table.insert(ui.listgameObject, ctr.gameObject)
  ctr.grid_leftIcon:SetActive(false)
  ctr.lab_pro:SetText(tostring(data.weight * 100) .. "%")
  local item = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(data.itemId))
  if item and item.type == 29 then
    if ctr.img_icon then
      ctr.img_icon:SetActive(true)
      local scale = tonumber(item.pngSize) / 100
      ui:SetSprite("Atlas_Common", item.icon, ctr.img_icon, true)
      ctr.img_icon.transform.localScale = Vector3(scale, scale, scale)
      ctr.item = item
      ctr:SetOnClick(ui, ui.ShowDescTxt)
    end
    if ctr.img_elementQuality then
      ctr.img_elementQuality:SetActive(true)
      ui:SetSprite("Atlas_Common", "ty_puzzle_" .. item.quality, ctr.img_elementQuality, true)
    end
    ctr.lab_num:SetActive(false)
  else
    if ctr.img_icon then
      ctr.img_icon:SetActive(false)
    end
    if ctr.itemcelldata == nil then
      ctr.itemcelldata = ItemCellData()
    end
    local itemData = ItemUtility.GenerateItemData(data.itemId)
    ctr.itemcelldata:RefreshData(itemData)
    ItemUtility.ShowItemCell(ctr, ctr.itemcelldata, ui, true)
    ctr.lab_num:SetActive(true)
    ctr.lab_num:SetText(data.count)
  end
end

function SeaChest_DetailTipsUI:OnInitList()
  self.combineItemContainer = UIContainer(self.btn_3DItem, self, OnSubMenuCreate, OnSubMenuShow)
end

function SeaChest_DetailTipsUI:Bg_CloseOnClick(control)
  UIManager.Hide(UIID.SeaChest_DetailTipsUI)
end

function SeaChest_DetailTipsUI:btn_3DItemOnClick(control)
end

function SeaChest_DetailTipsUI:ShowDescTxt(control)
  UIManager.Show(UIID.Tip_PuzzleJieShaoUI, {
    data = control.item,
    type = 1
  })
end

function SeaChest_DetailTipsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function SeaChest_DetailTipsUI:RegistEvents()
end

function SeaChest_DetailTipsUI:Refresh()
  if self.args and self.args.data then
    local alltotal = 0
    local weight = 1
    for i, v in ipairs(self.args.data) do
      alltotal = alltotal + v.weight
    end
    for i, v in ipairs(self.args.data) do
      if i == #self.args.data then
        v.weight = weight
      else
        v.weight = string.format("%.4f", v.weight / alltotal)
        weight = weight - v.weight
      end
    end
    self.Text_TipTitle:SetText(self.args.titlename)
    self.combineItemContainer:SetData(self.args.data, true)
  end
end

function SeaChest_DetailTipsUI:OnHide()
  for i = 1, #self.listgameObject do
    UnityEngineLua.GameObject.Destroy(table.remove(self.listgameObject, 1))
  end
  self.combineItemContainer:DesToryTable()
end

function SeaChest_DetailTipsUI:OnDestroy()
end
