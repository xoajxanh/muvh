ActivityNoticeManager = {}
local this = ActivityNoticeManager
this.activityList = {}
this.timeInterval = 0

function ActivityNoticeManager.OnEnterGame()
  this.RegistEvents()
  ActivityListData.InitData()
  this.activityList = {}
  for i = 1, #ActivityListData.allActivityList do
    local activityNotice = ActivityListData.allActivityList[i]
    this.activityList[activityNotice.id] = {isShow = false}
  end
end

function ActivityNoticeManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_OnMeCreated, this.Role_OnMeCreated)
  this.eventContainer:Regist(Event.Role_OnMeDestroy, this.Role_OnMeDestroy)
end

function ActivityNoticeManager.Role_OnMeCreated()
  this.meCreate = true
end

function ActivityNoticeManager.Role_OnMeDestroy()
  this.meCreate = false
end

function ActivityNoticeManager.Update()
  if not this.meCreate then
    return
  end
  if Time.GetServerTime() - this.timeInterval <= 1000 then
    return
  end
  this.timeInterval = Time.GetServerTime()
  for i = 1, #ActivityListData.allActivityList do
    local activityNotice = ActivityListData.allActivityList[i]
    if ConditionManager.Check4D(activityNotice.timeCondition) and ConditionManager.Check4D(activityNotice.enterCondition) then
      if UIManager.IsVisible(UIID.MainMenuUI) and not this.activityList[activityNotice.id].isShow then
        this.activityList[activityNotice.id].isShow = true
        if UIManager.IsVisible(UIID.War_ActiveListUI) then
          EventManager.Dispatch(Event.RefreshActivityNotice)
        else
          EventManager.Dispatch(Event.OpenActivityListUI)
        end
      end
    else
      if this.activityList[activityNotice.id].isShow and UIManager.IsVisible(UIID.War_ActiveListUI) then
        EventManager.Dispatch(Event.RefreshActivityNotice)
      end
      this.activityList[activityNotice.id].isShow = false
    end
  end
  EventManager.Dispatch(Event.UnionActiIsOpenCheck)
  EventManager.Dispatch(Event.CheckSiFangZhengBaOpen)
end

function ActivityNoticeManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
end

function ActivityNoticeManager.UnRegistAll()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
end
