Tip_SmeltUI = class(BaseUI)
Tip_SmeltUI.layer = UILayer.Panel
Tip_SmeltUI.orderInLayer = 100
Tip_SmeltUI.hideType = UIHideType.WaitDestroy
Tip_SmeltUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_SmeltUI.escClose = UIEscClose.DontClose

local function rewardListCreate(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function rewardListOnRefresh(ctr, _, data, ui)
  if data then
    local itemData = ItemUtility.GenerateItemData(data.itemId)
    ctr.itemCellData:RefreshData(itemData)
    ctr.itemCellData.itemData.count = data.count
    ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
  end
end

function Tip_SmeltUI:InitControls()
  self.Bg_btn = self:GetControl("Bg_btn")
  self.lab_successTipTitle = self:GetControl("Results/lab_successTipTitle")
  self.lab_failTipTitle = self:GetControl("Results/lab_failTipTitle")
  self.btn_3DItem = self:GetControl("Results/ScrollRectView/Viewport/Content/btn_3DItem")
  self.Button_confirm = self:GetControl("Button_confirm")
  self.rewardList = UIContainer(self.btn_3DItem, self, rewardListCreate, rewardListOnRefresh)
end

function Tip_SmeltUI:Init()
end

function Tip_SmeltUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_SmeltUI:InitUI()
end

function Tip_SmeltUI:RegistUIEvents()
  self.Bg_btn:SetOnClick(self, self.Bg_btnOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemFOnClick)
  self.Button_confirm:SetOnClick(self, self.Bg_btnOnClick)
end

function Tip_SmeltUI:Bg_btnOnClick(control)
  UIManager.Hide(UIID.Tip_SmeltUI)
end

function Tip_SmeltUI:btn_3DItemFOnClick(control)
end

function Tip_SmeltUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_SmeltUI:RegistEvents()
end

function Tip_SmeltUI:Refresh()
  if self.args and self.args.rewards then
    local info = {}
    for i, v in pairs(self.args.rewards) do
      table.insert(info, v)
    end
    self.rewardList:SetData(info)
  end
end

function Tip_SmeltUI:OnHide()
end

function Tip_SmeltUI:OnDestroy()
end
