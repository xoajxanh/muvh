local ScoreNoticeTemplate = {}

function ScoreNoticeTemplate:Init(data)
  self:InitParams(data)
  self:InitControls()
  self:BindUIEvent()
end

function ScoreNoticeTemplate:InitParams(data)
  self.parentTbl = data.baseUI
  self.parentTbl = nil
  self.mAnimName = "kunshouGold"
  self.mAudioId = nil
  self.scoreTimeCfg = ClientTable.cfg_Activity_globalManager:GetScoreShowTime()
end

function ScoreNoticeTemplate:InitControls()
  if self:UIControl() then
    self.scoreAnimator = self:UIControl().gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
  end
  self.lab_middleNotice = self:GetControl("lab_middleNotice")
  self.img_icon = self:GetControl("lab_bg")
end

function ScoreNoticeTemplate:BindUIEvent()
end

function ScoreNoticeTemplate:Refresh(data, ui)
  self:TryRefresh()
end

function ScoreNoticeTemplate:TryRefresh()
  if self.isRefresh then
    return
  end
  self.isRefresh = true
  self:PlayScoreNotice()
  if self.scoreTimer == nil then
    self.scoreTimer = Timer.StartLoopForever(self.scoreTimeCfg, self.PlayScoreNotice, self)
  end
end

function ScoreNoticeTemplate:PlayScoreNotice()
  if self:IsNeedStopNotice() then
    self.isRefresh = false
    self:StopScoreTimer()
    return
  end
  self.lab_middleNotice:SetText(tostring(KillNoticeMgr:PopScoreData()))
  self:PlayAnim()
  self:PlayAudio()
end

function ScoreNoticeTemplate:PlayAnim()
  if not self:UIControl():GetActive() then
    self:UIControl():SetActive(true)
  elseif self.scoreAnimator and not string.isNullOrEmpty(self.mAnimName) then
    self.scoreAnimator:Play(self.mAnimName, 0, 0)
  end
end

function ScoreNoticeTemplate:PlayAudio()
  if self.mAudioId then
    self.scoreAudio = AudioManager.PlayMusicClipById(self.mAudioId)
  end
end

function ScoreNoticeTemplate:StopScoreTimer()
  if self.scoreTimer then
    Timer.Stop(self.scoreTimer)
    self.scoreTimer = nil
  end
  if self.scoreAudio then
    AudioManager.Stop(self.scoreAudio)
  end
end

function ScoreNoticeTemplate:IsNeedStopNotice()
  return KillNoticeMgr == nil or not KillNoticeMgr:CheckHaveScoreData() or not TranScriptData.IsInRefineKSBattle()
end

function ScoreNoticeTemplate:OnDisable()
  self:StopScoreTimer()
end

return ScoreNoticeTemplate
