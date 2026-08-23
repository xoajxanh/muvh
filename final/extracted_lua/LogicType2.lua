LogicType2 = class(LogicBase)

function LogicType2:SwitchERank(ui)
  local isSwitch = false
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v ~= ui and v.visible and v.logicTbl.type == UIPanelType.SortAndHide and v.logicTbl.rank == ui.logicTbl.rank then
      UIManager.UILogicClose(v)
      if v.logicTbl.isLabel ~= ui.logicTbl.isLabel then
        local labelUITbl = ClientTable.cfg_Ui_logicManager:TryGetValue(v.logicTbl.isLabel, "id")
        local labelUI = UIManager.GetUiByName(labelUITbl.mainUI)
        if labelUI then
          labelUI:Hide()
        end
      end
      self:SetPanelPos(ui, v.logicTbl.sortPos)
      v.logicTbl.sortPos = nil
      isSwitch = true
    end
  end
  return isSwitch
end

function LogicType2:ResetPanelPos(ui)
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v ~= ui and v.visible and v.logicTbl.sortPos then
      self:SetPanelPos(v, self:CalPos(v.logicTbl.sortPos))
      v:ResetSortPos()
    end
  end
end

function LogicType2:FindCorrelationPanel(name)
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v.logicTbl.mainUI == name then
      return v
    end
  end
  return nil
end

Logic2ShowType = {
  NormallyOpen = enum(1),
  CorrelationOpen = enum(2),
  MovePanelOpen = enum(3)
}

function LogicType2:LogicShow(ui, args)
  local resetLogic = args and args.resetLogic
  EventManager.Dispatch(Event.Logic_ActiveMainUI, false)
  if not resetLogic then
    local temp = Logic2ShowType.NormallyOpen
    for _, v in pairs(UIManager.sortedUIs) do
      if v.logicTbl ~= nil and v ~= ui and v.visible and v.logicTbl.type == UIPanelType.SortAndHide then
        temp = temp + 1
      end
    end
    resetLogic = temp == Logic2ShowType.NormallyOpen and Logic2ShowType.NormallyOpen or Logic2ShowType.MovePanelOpen
  end
  if resetLogic == Logic2ShowType.NormallyOpen then
    local function noClose(mainUI)
      local noClose = ui.logicTbl.noClose
      
      local noClosetable = string.split(noClose, "#")
      for i, v in ipairs(noClosetable) do
        if mainUI == v then
          return false
        end
      end
      return true
    end
    
    for _, v in ipairs(UIManager.sortedUIs) do
      if v.logicTbl ~= nil and v ~= ui and v.visible and v.logicTbl.type ~= UIPanelType.SortAndHide and noClose(v.logicTbl.mainUI) then
        UIManager.UILogicClose(v, true)
      end
    end
    local isSwitch = self:SwitchERank(ui)
    if not isSwitch then
      self:SetPanelPos(ui, self:CalPos(ui.logicTbl.secondPosition))
    end
    if not string.isNullOrEmpty(ui.logicTbl.secondUi) then
      UIManager.Show(ui.logicTbl.secondUi, {
        resetLogic = Logic2ShowType.CorrelationOpen,
        correlationName = ui.logicTbl.mainUI
      })
    elseif not string.isNullOrEmpty(ui.logicTbl.superiorUi) and not UIManager.IsVisible(ui.logicTbl.superiorUi) then
      UIManager.Show(ui.logicTbl.superiorUi, {
        resetLogic = Logic2ShowType.CorrelationOpen,
        correlationName = ui.logicTbl.mainUI
      })
    end
  elseif resetLogic == Logic2ShowType.CorrelationOpen then
    local isSwitch = self:SwitchERank(ui)
    if not isSwitch then
      local correlationPanel = self:FindCorrelationPanel(args.correlationName)
      if correlationPanel then
        self:SetPanelPos(ui, correlationPanel.logicTbl.secondPosition)
      else
        self:SetPanelPos(ui, self:CalPos(ui.logicTbl.secondPosition))
      end
    end
  else
    local isSwitch = self:SwitchERank(ui)
    if not isSwitch then
      for _, v in ipairs(UIManager.sortedUIs) do
        if v.logicTbl ~= nil and v ~= ui and v.visible and v.logicTbl.sortPos then
          local pos = v.logicTbl.sortPos + 1
          if pos == 3 then
            v.logicTbl.sortPos = 3
            UIManager.UILogicClose(v, true)
          elseif pos == 2 then
            self:SetPanelPos(v, ui.logicTbl.secondPosition)
            self:SetPanelPos(ui, self:CalPos(ui.logicTbl.secondPosition))
            v:ResetSortPos()
          end
        end
      end
    end
  end
end

function LogicType2:LogicHide(ui)
  UIManager.ClearSortPos(ui)
  if ui.logicTbl.rank == 1 then
    UIManager.logicUIStack = Stack:New()
    UIManager.UICloseRank(ui, 1)
  elseif ui.logicTbl.closeLogic == 1 then
    for _ = 1, UIManager.logicUIStack:Count() do
      local saveUI = UIManager.logicUIStack:Peek()
      if saveUI.logicTbl.rank >= ui.logicTbl.rank then
        UIManager.logicUIStack:Pop()
      else
        break
      end
    end
    UIManager.UICloseRank(ui, ui.logicTbl.rank)
  else
    UIManager.logicUIStack = Stack:New()
    UIManager.UICloseRank(ui, 1)
  end
  local needShowMainUI = true
  if 1 <= UIManager.logicUIStack:Count() then
    self:ResetPanelPos(ui)
    while 1 <= UIManager.logicUIStack:Count() do
      local saveUI = UIManager.logicUIStack:Pop()
      if UIManager.NeedHideMainUI(saveUI.logicTbl.type) then
        if saveUI.logicTbl.type == UIPanelType.SortAndHide then
          if saveUI.logicTbl.sortPos == 3 then
            self:SetPanelPos(saveUI, saveUI.logicTbl.sortPos - 1)
          else
            self:SetPanelPos(saveUI, ui.logicTbl.sortPos)
          end
        end
        saveUI:Show()
        needShowMainUI = false
        break
      end
    end
  elseif self:HasSortPanelOpen(ui) then
    self:RightMoveSortPanel()
    needShowMainUI = false
  end
  
  local function noClose()
    local noClose = ui.logicTbl.noClose
    local noClosetable = string.split(noClose, "#")
    for i, v in ipairs(noClosetable) do
      if not string.isNullOrEmpty(v) and UIManager.IsVisible(v) then
        return true
      end
    end
    return false
  end
  
  if noClose() then
    needShowMainUI = false
  end
  if needShowMainUI then
    EventManager.Dispatch(Event.Logic_ActiveMainUI, true)
  end
end

function LogicType2:HasSortPanelOpen(ui)
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v.name ~= ui.name and v.visible and v.logicTbl.type == UIPanelType.SortAndHide and v.logicTbl.sortPos then
      return true
    end
  end
  return false
end

function LogicType2:RightMoveSortPanel()
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v.visible and v.logicTbl.sortPos then
      local sortPos = v.logicTbl.sortPos
      if sortPos ~= 1 then
        UIManager.sortPanelPosAnchor[sortPos].ui = nil
        self:SetPanelPos(v, sortPos - 1)
        v:ResetSortPos()
      end
    end
  end
end

function LogicType2:CalPos(pos)
  return pos == 1 and 2 or 1
end

function LogicType2:SetPanelPos(ui, sortPos)
  if ui.logicTbl.isLabel == ui.logicTbl.id then
    return
  end
  ui.logicTbl.sortPos = sortPos
  UIManager.sortPanelPosAnchor[sortPos].ui = ui
  local screenHalf = UIManager.width / 2
  local width1 = 0
  local width2 = 0
  local labelWidth = 0
  local ui1 = UIManager.sortPanelPosAnchor[1].ui
  if ui1 and ui1.logicTbl.isLabel ~= 0 then
    local labelUITbl = ClientTable.cfg_Ui_logicManager:TryGetValue(ui1.logicTbl.isLabel, "id")
    if UIManager.IsVisible(labelUITbl.mainUI) then
      labelWidth = labelUITbl.width
    end
  end
  if sortPos == 1 then
    width1 = labelWidth
    width1 = width1 + ui.logicTbl.combineWidth / 2 + AdapterUtility.offsetX
    local ui2 = UIManager.sortPanelPosAnchor[2].ui
    if ui2 ~= nil then
      width2 = ui2.logicTbl.width / 2
    end
    UIManager.sortPanelPosAnchor[1].pos = screenHalf - width1
    width1 = ui.logicTbl.width + labelWidth + AdapterUtility.offsetX
    local originalPos2 = UIManager.sortPanelPosAnchor[2].pos
    UIManager.sortPanelPosAnchor[2].pos = screenHalf - width1 - width2
    if ui2 ~= nil and ui2.root ~= nil and originalPos2 ~= UIManager.sortPanelPosAnchor[2].pos then
      ui2:ResetSortPos()
    end
  elseif sortPos == 2 and ui1 ~= nil then
    width1 = labelWidth + ui1.logicTbl.combineWidth + AdapterUtility.offsetX
    width2 = ui.logicTbl.width / 2
    UIManager.sortPanelPosAnchor[2].pos = screenHalf - width1 - width2
  end
  EventManager.Dispatch(Event.Logic_OpenSortPanel)
end

return LogicType2
