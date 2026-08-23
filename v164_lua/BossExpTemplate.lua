local BossExpTemplate = {}
BossExpTemplate.PrivilegeObj = nil

function BossExpTemplate:Init()
  self:InitComponent()
  self:BindEvent()
end

function BossExpTemplate:InitComponent()
  self.Fill = self:GetControl("sl_progress_BossExp/Fill")
  self.lab_progress = self:GetControl("sl_progress_BossExp/lab_progress")
  self.btn_Stop = self:GetControl("sl_progress_BossExp/btn_Stop")
  self.btn_Start = self:GetControl("sl_progress_BossExp/btn_Start")
  self.EffectRoot = self:GetControl("sl_progress_BossExp/EffectRoot")
  self.btn_Add = self:GetControl("sl_progress_BossExp/btn_Add")
end

function BossExpTemplate:BindEvent()
  self.btn_Stop:SetOnClick(self, self.btn_StopOnClick)
  self.btn_Start:SetOnClick(self, self.btn_StartOnClick)
  self.btn_Add:SetOnClick(self, self.btn_AddOnClick)
end

function BossExpTemplate:btn_StopOnClick()
  networkRequest.ReqSwitchUnitBuffhUnitBuff(2, UnitType.BossExp)
end

function BossExpTemplate:btn_StartOnClick()
  networkRequest.ReqSwitchUnitBuffhUnitBuff(1, UnitType.BossExp)
end

function BossExpTemplate:btn_AddOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1083})
end

function BossExpTemplate:Refresh(data, ui)
end

function BossExpTemplate:AnalysisParams(data)
  self.PrivilegeObj = gameMgr:GetAvatarManager():GetMainPlayer():GetPrivilegeMgr():GetPrivilegeObj(data)
  return self.PrivilegeObj ~= nil
end

function BossExpTemplate:RefreshStage()
  if self.PrivilegeObj ~= nil then
    local stage = self.PrivilegeObj:GetStage()
    self.btn_Start:SetActive(not stage)
    self.btn_Stop:SetActive(stage)
  end
end

function BossExpTemplate:TryRefreshScheduleDes()
  if self.timeLoop ~= nil then
    Timer.Stop(self.timeLoop)
  end
  if self.PrivilegeObj:GetStage() then
    self.timeLoop = Timer.StartLoopForever(0.5, self.RefreshScheduleDes, self)
  else
    self:RefreshScheduleDes()
  end
end

function BossExpTemplate:RefreshScheduleDes()
end

function BossExpTemplate:RefreshSchedule()
  if self.PrivilegeObj ~= nil then
    self.Fill:SetFillAmount(self.PrivilegeObj:GetTimeSchedule(ClientTable.cfg_Global_globalManager:GetBossExpTotalTime()))
  end
end

function BossExpTemplate:Destroy()
  if self.timeLoop ~= nil then
    Timer.Stop(self.timeLoop)
  end
end

return BossExpTemplate
