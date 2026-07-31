Puzzle_JH_JieshaoShapeUI = class(BaseUI)
Puzzle_JH_JieshaoShapeUI.layer = UILayer.Panel
Puzzle_JH_JieshaoShapeUI.orderInLayer = 0
Puzzle_JH_JieshaoShapeUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_JieshaoShapeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_JieshaoShapeUI.escClose = UIEscClose.DontClose

function Puzzle_JH_JieshaoShapeUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("btn_close")
  self.sw_JhItem = self:GetControl("sw_JhItem")
  self.Content = self:GetControl("sw_JhItem/Viewport/Content")
  self.JhItem = self:GetControl("sw_JhItem/Viewport/Content/JhItem")
  self.Runes_Item = self:GetControl("sw_JhItem/Viewport/Content/JhItem/Runes/Runes_Item")
  self.btn_del = self:GetControl("sw_JhItem/Viewport/Content/JhItem/Runes/btn_del")
  self.Img_TipBg = self:GetControl("Img_TipBg")
end

function Puzzle_JH_JieshaoShapeUI:Init()
end

function Puzzle_JH_JieshaoShapeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnRunesItemCreate(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.btn_item = UIControl(ctr.transform, "Runes/btn_item")
  ctr.img_item = UIControl(ctr.transform, "Runes/btn_item/img_item")
end

local function OnRunesItemRefresh(ctr, _, data, ui)
  local cfgData = ClientTable.cfg_Item_itemManager:TryGetValue(data.contentItemID)
  local ssStr = string.GetColorText(cfgData.name, ItemQuality2ColorDic[cfgData.titleColor])
  ctr.lab_name:SetText(ssStr)
  ctr.btn_item.itemData = cfgData
  ctr.btn_item:SetOnClick(ui, ui.img_itemOnClick)
  ui:SetSprite("Atlas_Common", tostring(cfgData.icon), ctr.img_item, true)
  if ui.itemSize == nil then
    ui.itemSize = ctr.img_item.transform.localScale
  end
  ctr.img_item.transform.localScale = ui.itemSize * data.size
end

function Puzzle_JH_JieshaoShapeUI:img_itemOnClick(control)
  UIManager.Show(UIID.Tip_PuzzleJieShaoUI, {
    data = control.itemData,
    type = 1
  })
end

function Puzzle_JH_JieshaoShapeUI:InitUI()
  self.cfgTbl = ClientTable.cfg_Puzzle_jieshaoManager:GetJieShaoDisplayeList(1)
  self.RuneContainer = UIContainer(self.JhItem, self, OnRunesItemCreate, OnRunesItemRefresh)
end

function Puzzle_JH_JieshaoShapeUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Runes_Item:SetOnClick(self, self.Runes_ItemOnClick)
  self.btn_del:SetOnClick(self, self.btn_delOnClick)
end

function Puzzle_JH_JieshaoShapeUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Puzzle_JH_NavUI)
end

function Puzzle_JH_JieshaoShapeUI:Runes_ItemOnClick(control)
end

function Puzzle_JH_JieshaoShapeUI:btn_delOnClick(control)
end

function Puzzle_JH_JieshaoShapeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_JieshaoShapeUI:RegistEvents()
end

function Puzzle_JH_JieshaoShapeUI:Refresh()
  self.RuneContainer:SetData(self.cfgTbl)
  self.Content.transform:GetComponent("ContentSizeFitter").enabled = false
  local w, h = self.Content:GetSizeDelta()
  self.Content:SetSizeDelta(w, math.ceil(#self.cfgTbl / 2) * 66)
end

function Puzzle_JH_JieshaoShapeUI:OnHide()
end

function Puzzle_JH_JieshaoShapeUI:OnDestroy()
end
