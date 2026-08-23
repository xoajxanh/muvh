Item_ExpTreblingCard = class(BaseUI)
Item_ExpTreblingCard.layer = UILayer.Tip
Item_ExpTreblingCard.orderInLayer = 1
Item_ExpTreblingCard.hideType = UIHideType.WaitDestroy
Item_ExpTreblingCard.hideFunc = UIHideFunc.MoveOutOfScreen
Item_ExpTreblingCard.escClose = UIEscClose.DontClose

function Item_ExpTreblingCard:InitControls()
  self.btn_bg = self:GetControl("btn_bg")
  self.bg_ornamentsBreach = self:GetControl("bg_ornamentsBreach")
  self.btn_close = self:GetControl("bg_ornamentsBreach/btn_close")
  self.btn_use = self:GetControl("Panel_ExpMedicine/btn_use")
  self.btn_3DItem = self:GetControl("Panel_ExpMedicine/btn_3DItem")
  self.input_number = self:GetControl("Panel_ExpMedicine/input_number")
  self.btn_plus = self:GetControl("Panel_ExpMedicine/input_number/btn_plus")
  self.btn_minus = self:GetControl("Panel_ExpMedicine/input_number/btn_minus")
  self.txt_detail = self:GetControl("Panel_ExpMedicine/txt_time/txt_detail")
end

function Item_ExpTreblingCard:OnPreLoad()
end

function Item_ExpTreblingCard:Init()
end

function Item_ExpTreblingCard:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Item_ExpTreblingCard:InitUI()
end

function Item_ExpTreblingCard:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Item_ExpTreblingCard:OnHide()
end

function Item_ExpTreblingCard:OnDestroy()
end

function Item_ExpTreblingCard:RegistUIEvents()
  self.btn_bg:SetOnClick(self, self.btn_bgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_use:SetOnClick(self, self.btn_useOnClick)
  self.btn_plus:SetOnClick(self, self.btn_plusOnClick)
  self.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  self.input_number:SetOnEndEdit(self, self.ChangeTextWhenEditEnd)
end

function Item_ExpTreblingCard:btn_bgOnClick(control)
  UIManager.Hide(UIID.Item_ExpTreblingCard)
end

function Item_ExpTreblingCard:btn_closeOnClick(control)
  UIManager.Hide(UIID.Item_ExpTreblingCard)
end

function Item_ExpTreblingCard:btn_useOnClick(control)
  if BagInfoData.GetItemCountByItemConfigId(3000400) > 0 then
    local id = BagInfoData.GetFirstItemTblByConfigId(3000400).id
    local useItemTbl = {
      useCount = tonumber(self.input_number:GetInputText()),
      useItemId = id,
      configId = 3000400
    }
    ItemUtility.UseItem(useItemTbl)
    UIManager.Hide(UIID.Item_ExpTreblingCard)
  else
    FloatingWordUtility.QuickMsg("S\225\187\145 l\198\176\225\187\163ng Th\225\186\187 EXP x3 kh\195\180ng \196\145\225\187\167")
  end
end

function Item_ExpTreblingCard:btn_plusOnClick(control)
  local nums = tonumber(self.input_number:GetInputText())
  local count = BagInfoData.GetItemCountByItemConfigId(3000400)
  nums = count >= nums + 1 and nums + 1 or count
  self.input_number:SetInputText(nums)
end

function Item_ExpTreblingCard:btn_minusOnClick(control)
  local nums = tonumber(self.input_number:GetInputText())
  nums = nums - 1 > 0 and nums - 1 or 0
  self.input_number:SetInputText(nums)
end

function Item_ExpTreblingCard:ChangeTextWhenEditEnd(control)
  local text = control:GetInputText()
  if text == "" then
    control:SetInputText(1)
  else
    local count = BagInfoData.GetItemCountByItemConfigId(3000400)
    local num = tonumber(text)
    num = num <= 0 and 1 or num
    num = count < num and count or num
    control:SetInputText(num)
  end
end

function Item_ExpTreblingCard:RegistEvents()
end

function Item_ExpTreblingCard:Refresh()
  local itemData = ItemUtility.GenerateItemData(3000400)
  itemData.count = BagInfoData.GetItemCountByItemConfigId(3000400)
  local itemCellData = ItemCellData()
  itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, itemCellData, self, true)
  local globalCof = ClientTable.cfg_Global_globalManager:TryGetValue(2210101, "id").effect / 1000
  self.txt_detail:SetText(string.format("<color=#1add1f>%s</color>/%s", TimeUtility.ShowTimeWithColon(0), TimeUtility.ShowTimeWithColon(globalCof)))
end
