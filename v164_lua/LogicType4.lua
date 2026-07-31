LogicType4 = class()

function LogicType4:LogicShow(ui, _)
  EventManager.Dispatch(Event.Logic_ActiveMainUI, false)
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v ~= ui and v.visible then
      UIManager.UILogicClose(v, true)
    end
  end
end

function LogicType4:LogicHide()
  if UIManager.logicUIStack:Count() >= 1 then
    for _ = 1, UIManager.logicUIStack:Count() do
      local saveUI = UIManager.logicUIStack:Pop()
      saveUI:Show()
    end
  else
    EventManager.Dispatch(Event.Logic_ActiveMainUI, true)
  end
end

return LogicType4
