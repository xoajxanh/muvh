Activity_RedfortTaskUI = class(BaseUI)
Activity_RedfortTaskUI.layer = UILayer.Background
Activity_RedfortTaskUI.orderInLayer = 1
Activity_RedfortTaskUI.hideType = UIHideType.WaitDestroy
Activity_RedfortTaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_RedfortTaskUI.escClose = UIEscClose.DontClose

function Activity_RedfortTaskUI:InitControls()
  self.subPanel = self:GetControl("panel/subPanel")
  self.tog_Task = self:GetControl("panel/subPanel/TaskTeamBar/tog_Task")
  self.tog_Team = self:GetControl("panel/subPanel/TaskTeamBar/tog_Team")
  self.TaskPanel = self:GetControl("panel/subPanel/TaskPanel")
  self.lab_fightState = self:GetControl("panel/subPanel/TaskPanel/lab_fightState")
  self.lab_target = self:GetControl("panel/subPanel/TaskPanel/lab_target")
  self.lab_curNums = self:GetControl("panel/subPanel/TaskPanel/lab_curNums")
  self.lab_nums = self:GetControl("panel/subPanel/TaskPanel/lab_curNums/lab_nums")
  self.lab_surplusPeople = self:GetControl("panel/subPanel/TaskPanel/lab_surplusPeople")
  self.lab_realive = self:GetControl("panel/subPanel/TaskPanel/lab_realive")
  self.lab_countTime = self:GetControl("panel/subPanel/TaskPanel/lab_countTime")
  self.lab_Time = self:GetControl("panel/subPanel/TaskPanel/lab_countTime/lab_Time")
  self.lab_fightTime = self:GetControl("panel/subPanel/TaskPanel/lab_fightTime")
  self.quitRoot = self:GetControl("panel/quitRoot")
  self.btn_quit = self:GetControl("panel/quitRoot/btn_quit")
end

function Activity_RedfortTaskUI:OnPreLoad()
end

function Activity_RedfortTaskUI:Init()
end

function Activity_RedfortTaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_RedfortTaskUI:InitUI()
  self.taskStateUI = {
    [RedFortFightState.Prepare] = {
      self.lab_curNums
    },
    [RedFortFightState.Fight] = {
      self.lab_target,
      self.lab_surplusPeople,
      self.lab_realive
    }
  }
end

function Activity_RedfortTaskUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_RedfortTaskUI:OnHide()
  if self.countDownPrepareTimer then
    Timer.Stop(self.countDownPrepareTimer)
    self.countDownPrepareTimer = nil
  end
  if self.countDownEndTimer then
    Timer.Stop(self.countDownEndTimer)
    self.countDownEndTimer = nil
  end
end

function Activity_RedfortTaskUI:OnDestroy()
end

function Activity_RedfortTaskUI:RegistUIEvents()
  self.tog_Task:SetOnClick(self, self.tog_TaskOnClick)
  self.tog_Team:SetOnClick(self, self.tog_TeamOnClick)
  self.btn_quit:SetOnClick(self, self.btn_quitOnClick)
end

function Activity_RedfortTaskUI:tog_TaskOnClick(control)
end

function Activity_RedfortTaskUI:tog_TeamOnClick(control)
  FloatingWordUtility.QuickMsg("Trong Ph\195\161o \196\144\195\160i \196\144\225\187\143, kh\195\180ng th\225\187\131 l\225\186\173p \196\145\225\187\153i")
end

function Activity_RedfortTaskUI:btn_quitOnClick(control)
  local tipsStr
  if RedFortData.prepareCountDown > Time.GetServerSecondTime() then
    tipsStr = "B\225\186\161n c\195\179 ch\225\186\175c ch\225\186\175n mu\225\187\145n tho\195\161t kh\195\180ng?"
  else
    tipsStr = "Sau khi tho\195\161t s\225\186\189 kh\195\180ng th\225\187\131 v\195\160o l\225\186\161i s\225\187\177 ki\225\187\135n l\225\186\167n n\195\160y, b\225\186\161n c\195\179 ch\225\186\175c ch\225\186\175n mu\225\187\145n tho\195\161t kh\195\180ng?"
  end
  local prompTipArgs = {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = tipsStr,
    ok = function()
      TranScriptController.ReqExitInstance()
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Activity_RedfortTaskUI:RegistEvents()
  self:RegistEvent(Event.RedFortUpdatePlayerNum, self.UpdatePlayersNum, self)
  self:RegistEvent(Event.Buff_RefreshRoleBuff, self.UpdateReAliveBuff, self)
  self:RegistEvent(Event.RedFortCountDown, self.UpdateTime, self)
end

function Activity_RedfortTaskUI:UpdatePlayersNum()
  self.lab_nums:SetText(string.format("%s", RedFortData.currentCount))
  self.lab_surplusPeople:GetChild("lab_surplusNum"):SetText(string.format("%s", RedFortData.currentCount))
end

function Activity_RedfortTaskUI:Refresh()
  self:UpdateTime()
  self:UpdatePlayersNum()
end

function Activity_RedfortTaskUI:UpdateTime()
  if RedFortData.GetFightState() == RedFortFightState.Prepare then
    self:UpdateRedFortInfoInPrepare()
  elseif RedFortData.GetFightState() == RedFortFightState.Fight then
    self:UpdateRedFortInfoInFight()
  end
end

function Activity_RedfortTaskUI:UpdateUIVisible(state)
  for k, v in pairs(self.taskStateUI) do
    if k == state then
      for i = 1, #self.taskStateUI[k] do
        self.taskStateUI[k][i]:SetActive(true)
      end
    else
      for i = 1, #self.taskStateUI[k] do
        self.taskStateUI[k][i]:SetActive(false)
      end
    end
  end
end

function Activity_RedfortTaskUI:UpdateRedFortInfoInPrepare()
  if self.countDownPrepareTimer then
    return
  end
  self:UpdateUIVisible(RedFortFightState.Prepare)
  self.lab_fightState:SetActive(true)
  self.lab_countTime:SetActive(true)
  self.lab_fightTime:SetActive(false)
  self.lab_fightState:SetText("Giai \196\145o\225\186\161n chu\225\186\169n b\225\187\139")
  self.lab_countTime:SetText("Chu\225\186\169n b\225\187\139 sau: ")
  local timeCounter = RedFortData.prepareCountDown - Time.GetServerSecondTime()
  
  local function StartTimer()
    local minutes = Mathf.Floor(timeCounter / 60)
    local seconds = Mathf.Floor(timeCounter % 60)
    self.lab_Time:SetText(string.format("%02d: %02d", minutes, seconds))
    if timeCounter <= 0 then
      self.lab_Time:SetText("00: 00")
      self:UpdateRedFortInfoInFight()
      if self.countDownPrepareTimer then
        Timer.Stop(self.countDownPrepareTimer)
        self.countDownPrepareTimer = nil
      end
    end
    timeCounter = RedFortData.prepareCountDown - Time.GetServerSecondTime()
  end
  
  StartTimer()
  self.countDownPrepareTimer = Timer.StartLoopForever(1, StartTimer)
end

function Activity_RedfortTaskUI:UpdateRedFortInfoInFight()
  if self.countDownEndTimer then
    return
  end
  self:UpdateUIVisible(RedFortFightState.Fight)
  local timeCounter = RedFortData.endingCountDown - Time.GetServerSecondTime()
  self.lab_fightState:SetActive(false)
  self.lab_countTime:SetActive(false)
  self.lab_fightTime:SetActive(true)
  local reliveBuff = BuffData.GetBuff(RoleManager.me.id, 90000902)
  if reliveBuff then
    self.lab_realive:GetChild("lab_realiveNum"):SetText(reliveBuff.count)
    self.lab_realive:GetChild("lab_realiveNum"):SetColor(reliveBuff.count > 0 and EUIColor.Green or EUIColor.Red)
  else
    self.lab_realive:GetChild("lab_realiveNum"):SetText(0)
    self.lab_realive:GetChild("lab_realiveNum"):SetColor(EUIColor.Red)
  end
  
  local function StartTimer()
    local minutes = Mathf.Floor(timeCounter / 60)
    local seconds = Mathf.Floor(timeCounter % 60)
    self.lab_fightTime:SetText(string.format("%02d: %02d", minutes, seconds))
    if timeCounter <= 0 then
      self.lab_fightTime:SetText("00: 00")
      if self.countDownEndTimer then
        Timer.Stop(self.countDownEndTimer)
        self.countDownEndTimer = nil
      end
    end
    timeCounter = RedFortData.endingCountDown - Time.GetServerSecondTime()
  end
  
  StartTimer()
  self.countDownEndTimer = Timer.StartLoopForever(1, StartTimer)
end

function Activity_RedfortTaskUI:UpdateReAliveBuff()
  local reliveBuff = BuffData.GetBuff(RoleManager.me.id, 90000902)
  if reliveBuff then
    self.lab_realive:GetChild("lab_realiveNum"):SetText(reliveBuff.count)
    self.lab_realive:GetChild("lab_realiveNum"):SetColor(reliveBuff.count > 0 and EUIColor.Green or EUIColor.Red)
  else
    self.lab_realive:GetChild("lab_realiveNum"):SetText(0)
    self.lab_realive:GetChild("lab_realiveNum"):SetColor(EUIColor.Red)
  end
end
