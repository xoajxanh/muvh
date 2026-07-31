Tip_TaskUI = class(BaseUI)
Tip_TaskUI.layer = UILayer.MessageBox
Tip_TaskUI.orderInLayer = 0
Tip_TaskUI.hideType = UIHideType.WaitDestroy
Tip_TaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_TaskUI.escClose = UIEscClose.DontClose

function Tip_TaskUI:InitControls()
  self.Panel_Desc = self:GetControl("Panel_Desc")
  self.CloseBtn = self:GetControl("Img_DescBg/CloseBtn")
  self.lab_DescTitle = self:GetControl("Img_DescBg/lab_DescTitle")
  self.Content = self:GetControl("sw_TaskPreview/Viewport/Content")
  self.grid_TaskRewardPreview = self:GetControl("sw_TaskPreview/Viewport/Content/grid_TaskRewardPreview")
  self.btn_TaskItem = self:GetControl("sw_TaskPreview/Viewport/Content/grid_TaskRewardPreview/sw_preview/Viewport/Content/btn_TaskItem")
  self.plane_top = self:GetControl("plane_top")
  self.plane_down = self:GetControl("plane_down")
end

function Tip_TaskUI:Init()
end

function Tip_TaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function ItemCreate(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemRefresh(ctr, _, data, ui)
  ItemUtility.ShowItemCellByItemId(tonumber(data), 1, ctr, ui, true)
end

local function RewardPreviewCreate(ctr)
  ctr.lab_desTitle = UIControl(ctr.transform, "lab_desTitle")
  ctr.btn_TaskItem = UIControl(ctr.transform, "sw_preview/Viewport/Content/btn_TaskItem")
end

local function RewardPreviewRefresh(ctr, _, data, ui)
  if ctr.btn_TaskItemContainer == nil then
    ctr.btn_TaskItemContainer = UIContainer(ctr.btn_TaskItem, ui, ItemCreate, ItemRefresh)
  end
  ctr.lab_desTitle:SetText(data.titile)
  ctr.btn_TaskItemContainer:Refresh()
  ctr.btn_TaskItemContainer:SetData(data.items)
end

function Tip_TaskUI:InitUI()
  self.grid_TaskRewardPreviewContainer = UIContainer(self.grid_TaskRewardPreview, self, RewardPreviewCreate, RewardPreviewRefresh)
end

function Tip_TaskUI:RegistUIEvents()
  self.Panel_Desc:SetOnClick(self, self.Panel_DescOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.btn_TaskItem:SetOnClick(self, self.btn_TaskItemOnClick)
end

function Tip_TaskUI:Panel_DescOnClick(control)
end

function Tip_TaskUI:CloseBtnOnClick(control)
  UIManager.Hide(UIID.Tip_TaskUI)
end

function Tip_TaskUI:btn_TaskItemOnClick(control)
end

function Tip_TaskUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_TaskUI:RegistEvents()
end

function Tip_TaskUI:Refresh()
  if self.args == nil then
    return
  end
  local data = self.args
  if data.type == "Task_SchoolUI" then
    self.lab_DescTitle:SetText("Xem tr\198\176\225\187\155c \196\144\225\186\161i Thi\195\170n S\225\187\169")
    local setDatas = {}
    for ei, ev in ipairs(data.context) do
      local temp = {}
      temp.items = {}
      for ii, iv in ipairs(ev) do
        if ii == 1 then
          temp.titile = iv
        else
          table.insert(temp.items, iv)
        end
      end
      table.insert(setDatas, temp)
    end
    self.grid_TaskRewardPreviewContainer:SetData(setDatas)
  end
end

function Tip_TaskUI:OnHide()
end

function Tip_TaskUI:OnDestroy()
end
