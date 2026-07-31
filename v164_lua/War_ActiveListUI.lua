War_ActiveListUI = class(BaseUI)
War_ActiveListUI.layer = UILayer.Background
War_ActiveListUI.orderInLayer = 1
War_ActiveListUI.hideType = UIHideType.WaitDestroy
War_ActiveListUI.hideFunc = UIHideFunc.MoveOutOfScreen
War_ActiveListUI.escClose = UIEscClose.DontClose

function War_ActiveListUI:InitControls()
  self.img_bg = self:GetControl("war_activy_list/img_bg")
  self.btn_list = self:GetControl("war_activy_list/img_bg/btn_list")
  self.list_content = self:GetControl("war_activy_list/img_bg/list_content")
  self.img_war_bg = self:GetControl("war_activy_list/img_bg/list_content/Viewport/Content/img_war_bg")
  self.btn_close = self:GetControl("war_activy_list/btn_close")
  self.btn_showList = self:GetControl("war_activy_list/btn_showList")
end

function War_ActiveListUI:OnPreLoad()
end

function War_ActiveListUI:Init()
end

function War_ActiveListUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function War_ActiveListUI:InitUI()
  self.showAll = false
  self.countDownTimer = {}
  self:InitContent()
  self.imgSizeX, self.imgSizeY = self.img_bg:GetSizeDelta()
end

local function ActivityItemCreate(ctr)
  ctr.war_ico = UIControl(ctr.transform, "war_ico")
  ctr.avtive_name = UIControl(ctr.transform, "avtive_name")
  ctr.avtive_time = UIControl(ctr.transform, "avtive_time")
  ctr.avtive_time_count = UIControl(ctr.transform, "avtive_time/avtive_time_count")
  ctr.war_tip_ico = UIControl(ctr.transform, "war_tip_ico")
end

local function GetTodayTime(timeOffset)
  timeOffset = timeOffset or 0
  local curTime = Time.GetServerSecondTime()
  curTime = TimeUtility.GetDayTimeStamp(curTime)
  local timeTbl = os.date("*t", curTime)
  local limitTimeUnix = os.time({
    year = timeTbl.year,
    month = timeTbl.month,
    day = timeTbl.day,
    hour = 0,
    min = 0
  })
  return curTime + timeOffset
end

local function ActivityItemRefresh(ctr, _, data, ui)
  ctr.avtive_name:SetText(data.activityName)
  local openTime = data.openTime
  local endTime, middleTime
  local activityId = data.id
  local limitTimeUnix = TimeUtility.GetCurTimeZoneSecondTime()
  for i = 1, #openTime do
    if ConditionManager.Check(openTime[i].condition) then
      endTime = openTime[i].endLimitTimeUnix + GetTodayTime()
      if openTime[i].middleLimitTimeUnix and limitTimeUnix < openTime[i].middleLimitTimeUnix + GetTodayTime() then
        middleTime = openTime[i].middleLimitTimeUnix + GetTodayTime()
      end
      break
    end
  end
  local activityOverview = ClientTable.cfg_Activity_overviewManager:TryGetValue(activityId, "activityId")
  ui:SetSprite("Atlas_Common", activityOverview.activityIcon, ctr.war_ico)
  if endTime then
    ctr.avtive_time:SetActive(true)
    local interval = middleTime and middleTime - TimeUtility.GetCurTimeZoneSecondTime() or endTime - TimeUtility.GetCurTimeZoneSecondTime()
    local interval1 = endTime * 1000 - Time.GetServerTime()
    local _, secondInterval = math.modf(interval1 / 1000)
    ctr.avtive_time_count:SetText(TimeUtility.ShowTimeWithColon(interval))
    
    local function countDownActivity()
      interval = middleTime and middleTime - TimeUtility.GetCurTimeZoneSecondTime() or endTime - TimeUtility.GetCurTimeZoneSecondTime()
      if interval < 0 then
        Timer.Stop(ui.countDownTimer[activityId])
        ui.countDownTimer[activityId] = nil
        ui:UpdateActivityUI()
        return
      end
      ctr.avtive_time_count:SetText(TimeUtility.ShowTimeWithColon(interval))
      if ConditionManager.Check4D(data.openCondition) then
        ui:SetSprite("Atlas_Common", "img_warAct_yesOpen", ctr.war_tip_ico)
      else
        ui:SetSprite("Atlas_Common", "img_warAct_onOpen", ctr.war_tip_ico)
      end
    end
    
    local function StartCountDownActivity()
      countDownActivity()
      ui.countDownTimer[activityId] = Timer.StartLoopForever(1, countDownActivity)
    end
    
    ui.countDownTimer[activityId] = Timer.Start(secondInterval, StartCountDownActivity)
    if ConditionManager.Check4D(data.openCondition) then
      ctr.avtive_time:SetText("Th\225\187\157i gian c\195\178n: ")
      ui:SetSprite("Atlas_Common", "img_warAct_yesOpen", ctr.war_tip_ico)
    else
      ctr.avtive_time:SetText("\196\144\225\186\191m ng\198\176\225\187\163c m\225\187\159: ")
      ui:SetSprite("Atlas_Common", "img_warAct_onOpen", ctr.war_tip_ico)
    end
    ctr.avtive_time_count:SetActive(true)
  else
    ctr.avtive_time:SetText("C\195\179 th\225\187\131 v\195\160o")
    ctr.avtive_time_count:SetActive(false)
    ui:SetSprite("Atlas_Common", "img_warAct_yesOpen", ctr.war_tip_ico)
  end
  ctr.activityId = data.id
  ctr:SetOnClick(ui, ui.ShowActivityUI)
end

function War_ActiveListUI:InitContent()
  self.ActivityItemTemp = UIContainer(self.img_war_bg, self, ActivityItemCreate, ActivityItemRefresh)
end

function War_ActiveListUI:ShowActivityUI(control)
  ActivityUtility.ShowActivity(control.activityId)
end

function War_ActiveListUI:OnShow()
  self:RegistEvents()
  EventManager.Dispatch(Event.Scene_SmallBossListShow)
  self:Refresh()
end

function War_ActiveListUI:DestroyTimer()
  for i, v in pairs(self.countDownTimer) do
    Timer.Stop(v)
  end
  self.countDownTimer = {}
end

function War_ActiveListUI:OnHide()
  self.img_bg:SetSizeDelta(self.imgSizeX, self.imgSizeY)
  self:DestroyTimer()
  self.showAll = false
end

function War_ActiveListUI:OnDestroy()
end

function War_ActiveListUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_list:SetOnClick(self, self.btn_listOnClick)
  self.btn_showList:SetOnClick(self, self.btn_showListOnClick)
end

function War_ActiveListUI:btn_showListOnClick()
  self.showAll = true
  local length = 310
  if self.activityCount == 2 then
    length = 250
  end
  self.img_bg.rectTransform:DOSizeDelta(Vector2(264, length), 0.3):OnComplete(function()
    self.btn_list:SetActive(true)
  end)
  self.list_content:SetRaycastTarget(true)
  self.list_content:GetChild("Viewport"):SetRaycastTarget(true)
  self.btn_showList:SetActive(false)
end

function War_ActiveListUI:btn_closeOnClick()
  UIManager.Hide(UIID.War_ActiveListUI)
end

function War_ActiveListUI:btn_listOnClick()
  UIManager.Show(UIID.Activity_IndexUI)
  EventManager.Dispatch(Event.ShowActivityIndex, "active")
end

function War_ActiveListUI:RegistEvents()
  self:RegistEvent(Event.RefreshActivityNotice, self.RefreshActivityNotice, self)
end

function War_ActiveListUI:RefreshActivityNotice()
  self:UpdateActivityUI()
end

function War_ActiveListUI:Refresh()
  self:UpdateActivityUI()
end

function War_ActiveListUI:UpdateActivityUI()
  local activityData = ActivityListData.GetCurOpenActivityData()
  self.activityCount = #activityData
  if self.activityCount == 0 then
    UIManager.Hide(UIID.War_ActiveListUI)
    return
  end
  table.sort(activityData, function(a, b)
    local isNeedTimeA = 100
    local isNeedTimeB = 100
    local orCondition = a.timeCondition
    for i = 1, #orCondition do
      local has908 = false
      for j = 1, #orCondition[i] do
        if orCondition[i][j][1] == 908 then
          has908 = true
          break
        end
      end
      if not has908 and ConditionManager.Check(orCondition[i]) then
        isNeedTimeA = 0
      end
    end
    orCondition = b.timeCondition
    for i = 1, #orCondition do
      local has908 = false
      for j = 1, #orCondition[i] do
        if orCondition[i][j][1] == 908 then
          has908 = true
          break
        end
      end
      if not has908 and ConditionManager.Check(orCondition[i]) then
        isNeedTimeB = 0
      end
    end
    return isNeedTimeA > isNeedTimeB
  end)
  self:DestroyTimer()
  self.ActivityItemTemp:SetData(activityData)
  if self.showAll then
    self.btn_list:SetActive(self.activityCount ~= 1)
    local imgSizeX, imgSizeY
    self.btn_showList:SetActive(false)
    if self.activityCount == 1 then
      imgSizeX = self.imgSizeX
      imgSizeY = self.imgSizeY
    elseif self.activityCount == 2 then
      imgSizeX = self.imgSizeX
      imgSizeY = 250
    else
      imgSizeX = self.imgSizeX
      imgSizeY = 310
    end
    self.img_bg:SetSizeDelta(imgSizeX, imgSizeY)
  else
    self.btn_list:SetActive(false)
    if self.activityCount == 1 then
      self.btn_showList:SetActive(false)
    else
      self.btn_showList:SetActive(true)
    end
  end
end
