Commercial_AnniversaryCelebrationNpcUI = class(BaseUI)
Commercial_AnniversaryCelebrationNpcUI.layer = UILayer.Panel
Commercial_AnniversaryCelebrationNpcUI.orderInLayer = 0
Commercial_AnniversaryCelebrationNpcUI.hideType = UIHideType.WaitDestroy
Commercial_AnniversaryCelebrationNpcUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_AnniversaryCelebrationNpcUI.escClose = UIEscClose.DontClose

function Commercial_AnniversaryCelebrationNpcUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.CelebrationNpc_Reward = self:GetControl("go_CelebrationNpc/CelebrationNpc_Reward")
  self.reward_item = self:GetControl("go_CelebrationNpc/CelebrationNpc_Reward/intimacyReward/Content/go_Shopitem")
  self.CelebrationNpc_Task = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task")
  self.dailyTask_item = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/DailyTask/Viewport/Content/go_Shopitem")
  self.activityTask_item = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/ActivityTask/Viewport/Content/go_Shopitem")
  self.btn_dailytask = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/Btn_Group/btn_dailytask")
  self.btn_dailytask_click = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/Btn_Group/btn_dailytask/img_click")
  self.btn_activitytask = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/Btn_Group/btn_activitytask")
  self.btn_activitytask_click = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/Btn_Group/btn_activitytask/img_click")
  self.DailyTask = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/DailyTask")
  self.ActivityTask = self:GetControl("go_CelebrationNpc/CelebrationNpc_Task/ActivityTask")
  self.line_progress = self:GetControl("go_CelebrationNpc/CelebrationNpc_IntimacyLv/line_back/line_progress")
  self.lab_currentexp = self:GetControl("go_CelebrationNpc/CelebrationNpc_IntimacyLv/line_back/lab_currentexp")
  self.lab_intimacyLv = self:GetControl("go_CelebrationNpc/CelebrationNpc_IntimacyLv/lab_intimacyLv")
  self.btn_IntimacyLv = self:GetControl("go_CelebrationNpc/MainBtnsGroup/btn_IntimacyLv")
  self.IntimacyLvCheckmark = self:GetControl("go_CelebrationNpc/MainBtnsGroup/btn_IntimacyLv/IntimacyLvCheckmark")
  self.btn_Task = self:GetControl("go_CelebrationNpc/MainBtnsGroup/btn_Task")
  self.TaskCheckmark = self:GetControl("go_CelebrationNpc/MainBtnsGroup/btn_Task/TaskCheckmark")
  self.descBtn = self:GetControl("descBtn")
  self.txt_lastTime = self:GetControl("txt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lastTime/lab_lastTime")
end

function Commercial_AnniversaryCelebrationNpcUI:Init()
end

function Commercial_AnniversaryCelebrationNpcUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Commercial_AnniversaryCelebrationNpcUI:InitUI()
  self.rewardContainer = UIUtility.BindUIContainerTemp(self.reward_item, LuaComponentTemplates.AnniversaryActivityNpcTemplate, self)
  self.dailyTaskContainer = UIUtility.BindUIContainerTemp(self.dailyTask_item, LuaComponentTemplates.AnniversaryActivityNpcDailyTaskTemplate, self)
  self.activityTaskContainer = UIUtility.BindUIContainerTemp(self.activityTask_item, LuaComponentTemplates.AnniversaryActivityNpcActivityTaskTemplate, self)
  self.descBtn:SetActive(true)
end

function Commercial_AnniversaryCelebrationNpcUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_IntimacyLv:SetOnClick(self, self.btn_IntimacyLvOnClick)
  self.btn_Task:SetOnClick(self, self.btn_TaskOnClick)
  self.btn_dailytask:SetOnClick(self, self.btn_dailytaskOnClick)
  self.btn_activitytask:SetOnClick(self, self.btn_activitytaskOnClick)
end

function Commercial_AnniversaryCelebrationNpcUI:btn_dailytaskOnClick(control)
  self.btn_dailytask_click:SetActive(true)
  self.btn_activitytask_click:SetActive(false)
  self.DailyTask:SetActive(true)
  self.ActivityTask:SetActive(false)
end

function Commercial_AnniversaryCelebrationNpcUI:btn_activitytaskOnClick(control)
  self.btn_dailytask_click:SetActive(false)
  self.btn_activitytask_click:SetActive(true)
  self.DailyTask:SetActive(false)
  self.ActivityTask:SetActive(true)
end

function Commercial_AnniversaryCelebrationNpcUI:btn_IntimacyLvOnClick(control)
  self.IntimacyLvCheckmark:SetActive(true)
  self.TaskCheckmark:SetActive(false)
  self.CelebrationNpc_Reward:SetActive(true)
  self.CelebrationNpc_Task:SetActive(false)
end

function Commercial_AnniversaryCelebrationNpcUI:btn_TaskOnClick(control)
  self.IntimacyLvCheckmark:SetActive(false)
  self.TaskCheckmark:SetActive(true)
  self.CelebrationNpc_Reward:SetActive(false)
  self.CelebrationNpc_Task:SetActive(true)
  self:btn_dailytaskOnClick()
end

function Commercial_AnniversaryCelebrationNpcUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Commercial_AnniversaryCelebrationNpcUI)
end

function Commercial_AnniversaryCelebrationNpcUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "id", 1142)
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Commercial_AnniversaryCelebrationNpcUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_AnniversaryCelebrationNpcUI)
end

function Commercial_AnniversaryCelebrationNpcUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Commercial_AnniversaryCelebrationNpcUI:RegistEvents()
  self:RegistEvent(Event.RefreshAnniversaryCelebrationNpcUI, self.Refresh, self)
end

function Commercial_AnniversaryCelebrationNpcUI:Refresh()
  self:btn_IntimacyLvOnClick()
  local rewardTbl = AnniversaryActivity_NPCActivityData.GetNpcActivityRewardData()
  self.rewardContainer:SetData(rewardTbl)
  self.lab_intimacyLv:SetText(AnniversaryActivity_NPCActivityData.GetNpcIntimacyLevel() or "")
  local nextLevelIntimacy, isMax = AnniversaryActivity_NPCActivityData.GetNextNpcIntimacyLevel()
  local nowLevelIntimacy = AnniversaryActivity_NPCActivityData.GetNpcIntimacy()
  if not isMax then
    self.lab_currentexp:SetText(nowLevelIntimacy .. "/" .. nextLevelIntimacy)
    self.line_progress:SetFillAmount(nowLevelIntimacy / nextLevelIntimacy)
  else
    self.lab_currentexp:SetText(isMax)
    self.line_progress:SetFillAmount(1)
  end
  local dailyTaskData, activityTaskData = AnniversaryActivity_NPCActivityData.GetNpcActivityAllTaskData()
  self.dailyTaskContainer:SetData(dailyTaskData)
  self.activityTaskContainer:SetData(activityTaskData)
  self:SetOpeningInfo()
end

local DaojiTime = 0

function Commercial_AnniversaryCelebrationNpcUI:RefreshTime(timeControl, titleControl)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    titleControl:SetText("Th\225\187\157i gian c\195\178n: ")
    timeControl:SetText(DaoJiShi)
    timeControl:SetActive(true)
  else
    titleControl:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
    timeControl:SetActive(false)
  end
end

function Commercial_AnniversaryCelebrationNpcUI:SetOpeningInfo()
  local commerceInfo = AnniversaryActivity_NPCActivityData.GetNpcActivityCommerceInfo()
  if next(commerceInfo) == nil then
    return
  end
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local down = TimeUtility.InTweenyearTimeTheEnd(commerceInfo.deadline[1][2])
  local Difference = TimeUtility.RefreshSec(down)
  local DaoJiShi
  if Difference <= 0 then
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.txt_lastTime:SetText(DaoJiShi)
    self.lab_lastTime:SetActive(false)
  else
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.txt_lastTime:SetText("Th\225\187\157i gian c\195\178n: ")
    self.lab_lastTime:SetText(DaoJiShi)
    self.lab_lastTime:SetActive(true)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTime, self.txt_lastTime)
  end
end

function Commercial_AnniversaryCelebrationNpcUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Commercial_AnniversaryCelebrationNpcUI:OnHide()
  self:SetDestroyTime()
end

function Commercial_AnniversaryCelebrationNpcUI:OnDestroy()
end
