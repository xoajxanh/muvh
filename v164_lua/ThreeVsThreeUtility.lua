ThreeVsThreeUtility = {}

function ThreeVsThreeUtility.TryOpen3V3ExpandPanel()
  local inActivity = ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity()
  local panelIsOpen = UIManager.IsVisible(UIID.Activity_Sport3V3Map)
  if inActivity == false and panelIsOpen == false then
    return
  end
  if inActivity == false and panelIsOpen then
    UIManager.Hide(UIID.Activity_Sport3V3Map)
  elseif not panelIsOpen then
    UIManager.Show(UIID.Activity_Sport3V3Map, QuickFind:GetThreeVsThreeDataMgr())
  else
    local expandPanel = UIManager.GetUiByName(UIID.Activity_Sport3V3Map)
    if expandPanel ~= nil then
      EventManager.Dispatch(Event.ThreeVSThreeCampInfoChange, QuickFind:GetThreeVsThreeDataMgr())
    end
  end
end

function ThreeVsThreeUtility.ThreeVSThreeIsClose()
  UIManager.Hide(UIID.Activity_Sport3V3Map)
end

ThreeVsThreeUtility.ChooseEnemyLid = nil
ThreeVsThreeUtility.FilterChoose = 0

function ThreeVsThreeUtility.SetChooseEnemyLid(lid, sendEvent)
  if sendEvent and ThreeVsThreeUtility.ChooseEnemyLid ~= nil and lid ~= nil and ThreeVsThreeUtility.ChooseEnemyLid ~= lid then
    ThreeVsThreeUtility.FilterChoose = 2
  end
  ThreeVsThreeUtility.ChooseEnemyLid = lid
  if sendEvent then
    EventManager.Dispatch(Event.ThreeVsThreeChooseTarget)
  end
end

function ThreeVsThreeUtility.GetChooseEnemyLid()
  return ThreeVsThreeUtility.ChooseEnemyLid
end

function ThreeVsThreeUtility.IsChooseLid(lid)
  if lid == nil then
    return false
  end
  return ThreeVsThreeUtility.ChooseEnemyLid == lid
end

function ThreeVsThreeUtility.IsFilterChoose()
  if ThreeVsThreeUtility.FilterChoose <= 0 then
    return false
  end
  ThreeVsThreeUtility.FilterChoose = ThreeVsThreeUtility.FilterChoose - 1
  return true
end

function ThreeVsThreeUtility.CheckIsInThreeVSThreeActivityTime()
  local endRemainTime = TimeUtility.GetRemainSecTime(QuickFind:GetThreeVsThreeDataMgr():GetEndTime())
  if endRemainTime <= 0 then
    return false
  end
  return true
end

function ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity()
  local endRemainTime = TimeUtility.GetRemainSecTime(QuickFind:GetThreeVsThreeDataMgr():GetEndTime())
  if endRemainTime <= 0 then
    return false
  end
  if SceneData.mapId ~= MapIDType.THREEVSTHREE then
    return false
  end
  return true
end
