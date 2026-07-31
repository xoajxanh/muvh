Drag_DragUI = class(BaseUI)
Drag_DragUI.layer = UILayer.Dialog
Drag_DragUI.orderInLayer = 0
Drag_DragUI.hideType = UIHideType.Hide
Drag_DragUI.hideFunc = UIHideFunc.MoveOutOfScreen
Drag_DragUI.escClose = UIEscClose.DontClose

function Drag_DragUI:InitControls()
  self.go_pos = self:GetControl("go_pos")
  self.go_DragCheck = self:GetControl("go_DragCheck")
  self.go_DragEdge = self:GetControl("go_DragCheck/go_DragEdge")
end

function Drag_DragUI:OnPreLoad()
end

function Drag_DragUI:Init()
  self.curDragObj = nil
  self.originalParent = nil
  self.isRotating = false
end

function Drag_DragUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Drag_DragUI:InitUI()
  self.dragTbl = UIBaseCellContainer(self, self.PutIn)
end

function Drag_DragUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Drag_DragUI:OnHide()
  self.curDragObj = nil
end

function Drag_DragUI:OnDestroy()
end

function Drag_DragUI:Update()
  if self.isRotating and self.curDragObj then
    RoleEquipUtility.EquipModelRotation(self.curDragObj, self.itemData.tblItem.SpinAxis)
  end
end

function Drag_DragUI:RegistUIEvents()
end

function Drag_DragUI:Btn_HideOnClick(control)
end

function Drag_DragUI:RegistEvents()
  self:RegistEvent(Event.Drag_DragStart, self.Drag_DragStart, self)
  self:RegistEvent(Event.Drag_DragUpdate, self.Drag_DragUpdate, self)
  self:RegistEvent(Event.Drag_DragEnd, self.Drag_DragEnd, self)
  self:RegistEvent(Event.Drag_Cancel, self.Drag_DragEnd, self)
  self:RegistEvent(Event.Logic_ActiveMainUI, self.OnActiveMainUI, self)
  self:RegistEvent(Event.Logic_OpenSortPanel, self.OnOpenSortPanel, self)
end

function Drag_DragUI:OnActiveMainUI(_, state)
  if state and LoginData.InGame then
    self.go_DragEdge:SetSizeDelta(UIManager.width, UIManager.height)
    self.dragTbl:ResetCheckRange()
  end
end

function Drag_DragUI:OnOpenSortPanel()
  if not LoginData.InGame then
    return
  end
  local panelSize = 0
  if UIManager.sortPanelPosAnchor[1].ui ~= nil then
    local ui = UIManager.sortPanelPosAnchor[1].ui
    local labelSize = 0
    if ui.logicTbl.isLabel ~= 0 then
      local labelUITbl = ClientTable.cfg_Ui_logicManager:TryGetValue(ui.logicTbl.isLabel, "id")
      if UIManager.IsVisible(labelUITbl.mainUI) then
        labelSize = labelUITbl.width
      end
    end
    panelSize = labelSize + ui.logicTbl.width
  end
  if UIManager.sortPanelPosAnchor[2].ui ~= nil then
    local ui = UIManager.sortPanelPosAnchor[2].ui
    panelSize = panelSize + ui.logicTbl.width
  end
  local size = UIManager.width - panelSize
  self.go_DragEdge:SetSizeDelta(size, UIManager.height)
  self.dragTbl:ResetCheckRange()
end

function Drag_DragUI:Drag_DragStart(_, data, eventData)
  if data and data.model.modelObject then
    self.itemData = data.itemData
    self.curDragObj = data.model.modelObject
    self.originalParent = self.curDragObj.transform.parent
    self.curDragObj.transform:SetParent(self.go_pos.transform, false)
    self.go_pos:SetScale(Vector3(1.3, 1.3, 1.3))
    self.go_pos:SetRotation(0, 0, 0)
    self.isRotating = true
  end
  if eventData then
    local _, localPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.go_pos:GetParent(), eventData.position, UIManager.uiCamera)
    self.go_pos:SetAnchoredPosition(localPos.x, localPos.y)
  end
end

function Drag_DragUI:Drag_DragUpdate(_, data, eventData)
  local _, localPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.go_pos:GetParent(), eventData.position, UIManager.uiCamera)
  local x, y = localPos.x, localPos.y
  self.go_pos:SetAnchoredPosition(x, y)
end

function Drag_DragUI:Drag_DragEnd(_, data, eventData)
  if data and data.model.modelObject then
    self.isRotating = false
    if not IsNil(self.curDragObj) then
      self.curDragObj.transform:SetParent(self.originalParent, true)
      self.curDragObj:SetActive(false)
    end
    self.curDragObj = nil
    self.itemData = nil
    self.originalParent = nil
    self.go_pos:SetAnchoredPosition(0, 0)
    self.go_pos:SetScale(Vector3.one)
  end
end

local function DoPutIn(itemData)
  NetManager.Send(BagMessage.ReqDestroyItem, {
    itemId = itemData.id
  })
end

local function CancelPutIn(putInData)
  local getOutContainer = ItemCellTblData.curCellTbls[putInData.fromUiName]
  getOutContainer:DragReset(putInData.data)
end

function Drag_DragUI:PutIn(putInData)
  if putInData.fromUiName == UIID.NewBagInfoUI then
    local tipTbl = {}
    tipTbl.title = LocalizationUtility.GetContentByKey("tishi")
    tipTbl.cancelText = LocalizationUtility.GetContentByKey("quxiao")
    tipTbl.okText = LocalizationUtility.GetContentByKey("queding")
    if putInData.itemData.tblItem.destroy == 0 then
      tipTbl.textContent = string.format(LocalizationUtility.GetContentByKey("Destroy_1"), putInData.itemData.tblItem.name)
      tipTbl.cancel = CancelPutIn
      tipTbl.ok = DoPutIn
      tipTbl.okArgs = putInData.itemData
      tipTbl.cancelArgs = putInData
    else
      tipTbl.textContent = string.format(LocalizationUtility.GetContentByKey("Destroy_2"), putInData.itemData.tblItem.name)
    end
    UIManager.Show(UIID.PromptTipUI, tipTbl)
    local getOutContainer = ItemCellTblData.curCellTbls[putInData.fromUiName]
    getOutContainer:DragReset(putInData.data)
  else
    local getOutContainer = ItemCellTblData.curCellTbls[putInData.fromUiName]
    getOutContainer:DragReset(putInData.data)
  end
end

function Drag_DragUI:Refresh()
end
