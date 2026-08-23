Tip_BubbleUI = class(BaseUI)
Tip_BubbleUI.layer = UILayer.Background
Tip_BubbleUI.orderInLayer = 2
Tip_BubbleUI.hideType = UIHideType.Hide
Tip_BubbleUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_BubbleUI.escClose = UIEscClose.DontClose

function Tip_BubbleUI:InitControls()
  self.go_bubble = self:GetControl("Mask_view/Content/go_bubble")
end

function Tip_BubbleUI:OnPreLoad()
end

function Tip_BubbleUI:Init()
  self.bubbleContainer = {}
end

function Tip_BubbleUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_BubbleUI:InitUI()
  self:InitBubble()
end

local function BubbleOnCreate(ctr)
  ctr.btn_bubble = UIControl(ctr.transform, "btn_bubble")
  ctr.btn_bubble.transform:DOKill()
  ctr.btn_bubble.transform:DOScale(Vector3.New(1.2, 1.2, 1.2), 0.2):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
end

local function BubbleRefresh(ctr, _, info, ui)
  ctr.btn_bubble.bubbleInfo = info
  ctr.btn_bubble:SetOnClick(ui, ui.OpenUI)
end

function Tip_BubbleUI:InitBubble()
  self.bubbleContainer = UIContainer(self.go_bubble, self, BubbleOnCreate, BubbleRefresh)
end

function Tip_BubbleUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_BubbleUI:OnHide()
  self.bubbleContainer:SetData({})
end

function Tip_BubbleUI:OnDestroy()
end

function Tip_BubbleUI:RegistUIEvents()
end

function Tip_BubbleUI:OpenUI(ctr)
  if ctr.bubbleInfo.args then
    UIManager.Show(ctr.bubbleInfo.uiName, ctr.bubbleInfo.args)
  else
    UIManager.Show(ctr.bubbleInfo.uiName)
  end
  if ctr.bubbleInfo.type == BubbleTypeEnum.ItemOverdue then
    BubbleData.RemoveBubbleById(ctr.bubbleInfo.id)
  end
  self.bubbleContainer:SetData(BubbleData.BubbleList)
end

function Tip_BubbleUI:RegistEvents()
  self:RegistEvent(Event.Bubble_BubbleRefresh, self.OnBubbleRefresh, self)
  self:RegistEvent(Event.GamePlay_Back2Choose, self.OnBubbleReset, self)
  self:RegistEvent(Event.GamePlay_Leave, self.OnBubbleReset, self)
  self:RegistEvent(Event.Role_OnChangeMap, self.OnMapChange, self)
end

function Tip_BubbleUI:OnBubbleRefresh()
  local data = {}
  for i, v in pairs(BubbleData.BubbleList) do
    if v.subType then
      if v.subType ~= BubbleArticlesType.Pet then
        table.insert(data, v)
      end
    else
      table.insert(data, v)
    end
  end
  self.bubbleContainer:SetData(data)
end

function Tip_BubbleUI:OnBubbleReset()
  BubbleData.RemoveAllBubble()
  self:OnBubbleRefresh()
end

function Tip_BubbleUI:OnMapChange()
  BubbleData.RemoveMapBubble()
  self:OnBubbleRefresh()
end

function Tip_BubbleUI:Refresh()
  self:OnBubbleRefresh()
end
