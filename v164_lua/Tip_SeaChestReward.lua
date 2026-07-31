Tip_SeaChestReward = class(BaseUI)
Tip_SeaChestReward.layer = UILayer.Tip
Tip_SeaChestReward.orderInLayer = 0
Tip_SeaChestReward.hideType = UIHideType.WaitDestroy
Tip_SeaChestReward.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_SeaChestReward.escClose = UIEscClose.DontClose

function Tip_SeaChestReward:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Img_TipBg = self:GetControl("Panel_Tip/Img_TipBg")
  self.btn_ok = self:GetControl("Panel_Tip/Img_TipBg/btn_ok")
  self.img_title = self:GetControl("Panel_Tip/Img_TipBg/img_title")
  self.sw_item = self:GetControl("Panel_Tip/Img_TipBg/sw_item")
  self.sw_item_Viewport = self:GetControl("Panel_Tip/Img_TipBg/sw_item")
  self.Content = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content")
  self.btn_3DItem = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem")
  self.lab_text2 = self:GetControl("Panel_Tip/Img_TipBg/lab_text2")
end

function Tip_SeaChestReward:Init()
  self.listgameObject = {}
end

function Tip_SeaChestReward:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_SeaChestReward:InitUI()
end

function Tip_SeaChestReward:RegistUIEvents()
  self.Panel_Tip:SetOnClick(self, self.Panel_TipOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
  self.btn_ok:SetOnClick(self, self.btn_OkOnClick)
end

function Tip_SeaChestReward:btn_OkOnClick(control)
  if self.args then
    networkRequest.ReqDeepSeaTreasureAward(self.args.type)
    UIManager.Hide(UIID.Tip_SeaChestReward)
  end
end

function Tip_SeaChestReward:Panel_TipOnClick(control)
end

function Tip_SeaChestReward:btn_3DItemOnClick(control)
end

function Tip_SeaChestReward:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_SeaChestReward:RegistEvents()
  self:OnInitList()
end

local function OnSubMenuCreate(ctr)
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.img_icon = UIControl(ctr.transform, "img_icon/icon")
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr.grid_leftIcon = UIControl(ctr.transform, "grid_leftIcon")
  ctr.img_elementQuality = UIControl(ctr.transform, "img_icon/rarity")
end

local function OnSubMenuShow(ctr, index, data, ui)
  if data == nil then
    return
  end
  table.insert(ui.listgameObject, ctr.gameObject)
  if data.setp == 2 then
    ui.lab_text2:SetActive(true)
  else
    ui.lab_text2:SetActive(false)
  end
  ctr.grid_leftIcon:SetActive(false)
  local item = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(data.itemId))
  if item and item.type == 29 then
    if ctr.img_icon then
      ctr.img_icon:SetActive(true)
      local scale = tonumber(item.pngSize) / 100
      ui:SetSprite("Atlas_Common", item.icon, ctr.img_icon, true)
      ctr.img_icon.transform.localScale = Vector3(scale, scale, scale)
    end
    if ctr.img_elementQuality then
      ctr.img_elementQuality:SetActive(true)
      ui:SetSprite("Atlas_Common", "ty_puzzle_" .. item.quality, ctr.img_elementQuality, true)
    end
    ctr.lab_num:SetActive(false)
    ctr:SetOnClick(ui, function()
      local itemData = {}
      itemData.m_ItemConfig = item
      itemData.m_ServerInfo = data
      UIManager.Show(UIID.Tip_CrystalNucleusUI, {data = itemData, type = 1})
    end)
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

function Tip_SeaChestReward:OnInitList()
  self.combineItemContainer = UIContainer(self.btn_3DItem, self, OnSubMenuCreate, OnSubMenuShow)
end

function Tip_SeaChestReward:Refresh()
  self.root.transform.localPosition = Vector3(0, 0, -3000)
  if self.args and self.args.itemInfos then
    self.args.itemInfos[1].setp = self.args.setp
    self.combineItemContainer:SetData(self.args.itemInfos, true)
  end
end

function Tip_SeaChestReward:UpdateWildCellCallBack(index)
end

function Tip_SeaChestReward:OnHide()
  for i = 1, #self.listgameObject do
    UnityEngineLua.GameObject.Destroy(table.remove(self.listgameObject, 1))
  end
end

function Tip_SeaChestReward:OnDestroy()
end
