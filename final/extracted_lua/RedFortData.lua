RedFortData = {}
local this = RedFortData
this.activityState = ActivityStatusEnum.INIT
this.runStep = 1
this.nextControlIndex = 1
this.currentCount = 1
this.InRedFortActivity = false
this.signedState = false
this.prepareCountDown = 0
this.endingCountDown = 0
this.rank = nil
this.totalNum = 0

function RedFortData.Init(data)
  this.Reset()
end

function RedFortData.GetFightState()
  local state = RedFortData.prepareCountDown > Time.GetServerSecondTime()
  if state then
    return RedFortFightState.Prepare
  else
    return RedFortFightState.Fight
  end
end

function RedFortData.ResChiSeSingNotice(prepareTime)
  this.prepareCountDown = prepareTime
end

function RedFortData.UpdateRankData(msg)
  this.rank = msg
  UIManager.Show(UIID.Activity_RedfortRankUI)
end

function RedFortData.ResChiSeYaoTotal(totalNum)
  this.totalNum = totalNum
end

function RedFortData.ResChiSeYaoCircle(circle)
  EventManager.Dispatch(Event.RedFortUpdateCircle, circle)
end

function RedFortData.UpdateActivityCountDown(data)
  this.prepareCountDown = data.prepare - 1
  this.endingCountDown = data.ending - 1
  EventManager.Dispatch(Event.RedFortCountDown, nil)
end

function RedFortData.UpdateSurviveNum(survival)
  this.currentCount = survival
  EventManager.Dispatch(Event.RedFortUpdatePlayerNum, survival)
end

function RedFortData.UpdateData(data)
  if this.activityState ~= data.activityState then
    this.activityState = data.activityState
  end
  if this.runStep ~= data.runStep then
    this.runStep = data.runStep
  end
  if this.nextControlIndex ~= data.next_control_index then
    this.nextControlIndex = data.next_control_index
  end
  if this.currentCount ~= data.currentCount then
    this.currentCount = data.currentCount
  end
  this.enterCount = data.enterCount
  if this.activityState == ActivityStatusEnum.RUNNING then
    if not this.InRedFortActivity then
      logError("B\225\186\163n \196\145\225\187\147 hi\225\187\135n t\225\186\161i kh\195\180ng ph\225\186\163i l\195\160 b\225\186\163n \196\145\225\187\147 Ph\195\161o \196\144\195\160i \196\144\225\187\143, m\195\161y ch\225\187\167 \196\145\195\163 g\225\187\173i tr\225\186\161ng th\195\161i ho\225\186\161t \196\145\225\187\153ng \196\145ang m\225\187\159")
    end
    EventManager.Dispatch(Event.RedFortEntered)
  end
end

function RedFortData.ActivitySigned()
  this.signedState = true
end

function RedFortData.InActivity(isInMap)
  this.InRedFortActivity = isInMap
end

function RedFortData.Reset()
  this.activityState = ActivityStatusEnum.INIT
  this.runStep = 1
  this.nextControlIndex = 1
  this.currentCount = 1
  this.InRedFortActivity = false
  this.signedState = false
  this.prepareCountDown = 0
  this.endingCountDown = 0
  this.rank = nil
  this.totalNum = 0
end
