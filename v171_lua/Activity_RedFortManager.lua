Activity_RedFortManager = {}
local this = Activity_RedFortManager
this.shirkCircleTimer = nil
this.shirkCircleTime = 5

function Activity_RedFortManager.OnEnterGame()
  this.RegistEvents()
end

function Activity_RedFortManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.RedFortUpdateCircle, this.RedPortUpdateCircle)
  this.eventContainer:Regist(Event.Map_ChangeMap, this.StopTimer)
end

function Activity_RedFortManager.StopTimer()
  if this.shirkCircleTimer then
    Timer.Stop(this.shirkCircleTimer)
    this.shirkCircleTimer = nil
  end
end

function Activity_RedFortManager.RedPortUpdateCircle(_, circle)
  this.StartTimerWhitShirkCircle(circle)
end

function Activity_RedFortManager.StartTimerWhitShirkCircle(circle)
  if not CS.DynamicScene.SceneObjectGroupManager.Instance then
    return
  end
  local group = CS.DynamicScene.SceneObjectGroupManager.Instance:FindGroup("round" .. circle)
  if not group then
    return
  end
  local warnBreath = group:GetGameObjects()
  for i = 0, warnBreath.Length - 1 do
    if warnBreath[i] then
      warnBreath[i]:GetComponent("WarningBreath"):BreathWarning()
    end
  end
  this.StopTimer()
  this.shirkCircleTimer = Timer.Start(this.shirkCircleTime, function()
    local hidePrefabs = group.sceneObjectList
    for i = 0, hidePrefabs.Count - 1 do
      if hidePrefabs[i] then
        hidePrefabs[i]:SetActive(false)
      end
    end
  end)
end

function Activity_RedFortManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.StopTimer()
end

function Activity_RedFortManager.UnRegistAll()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.StopTimer()
end
