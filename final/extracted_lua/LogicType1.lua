LogicType1 = class()

function LogicType1:LogicShow(ui, _)
  EventManager.Dispatch(Event.Logic_ActiveMainUI, false)
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v ~= ui and v.visible then
      UIManager.UILogicClose(v, true)
    end
  end
end

function LogicType1:LogicHide()
  local needShowMainUi = true
  if UIManager.logicUIStack:Count() >= 1 then
    while UIManager.logicUIStack:Count() >= 1 do
      local saveUI = UIManager.logicUIStack:Pop()
      saveUI:Show()
      if UIManager.NeedHideMainUI(saveUI.logicTbl.type) then
        needShowMainUi = false
        break
      end
    end
  end
  if needShowMainUi then
    EventManager.Dispatch(Event.Logic_ActiveMainUI, true)
  end
end

return LogicType1
