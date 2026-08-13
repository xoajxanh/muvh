local KillNoticeTemplate = {}

function KillNoticeTemplate:Init(data)
  self:InitParams(data)
  self:InitControls()
end

function KillNoticeTemplate:InitParams(data)
  self.parentTbl = data.baseUI
  self.animationName = "kunshouKillName"
  self.kunShouBgFormat = "KunShouBg_%d_%d"
end

function KillNoticeTemplate:InitControls()
  self.bg_killNotice = self:GetControl("bg_killNotice")
  self.lab_Name = self:GetControl("lab_Type/lab_Name")
  self.lab_Pic = self:GetControl("lab_Type/lab_Pic")
  self.left_Frame = self:GetControl("friend_Frame")
  self.left_Icon = self:GetControl("friend_Frame/bg_FrameIcon")
  self.right_Frame = self:GetControl("enemy_Frame")
  self.right_Icon = self:GetControl("enemy_Frame/bg_FrameIcon")
  self.noticeAnimator = self:UIControl().gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
end

function KillNoticeTemplate:BindUIEvent()
end

function KillNoticeTemplate:Refresh(data, ui)
  self:RefreshKillTips(data)
end

function KillNoticeTemplate:RefreshKillTips(data)
  if data == nil or self.parentTbl == nil then
    return
  end
  self.lab_Pic:SetText(data.param)
  if data.killer then
    if data.noticeLeve and data.killer.group then
      self.parentTbl:SetSprite("Atlas_Common", string.format(self.kunShouBgFormat, data.noticeLevel, data.killer.group), self.bg_killNotice)
    end
    self.lab_Name:SetText(data.killer.name)
    self.parentTbl:SetSprite("Atlas_headPortrait", tostring(data.killer.career), self.left_Icon)
  end
  if data.dead then
    self.parentTbl:SetSprite("Atlas_headPortrait", tostring(data.dead.career), self.right_Icon)
  end
  if not self:UIControl():GetActive() then
    self:UIControl():SetActive(true)
  elseif self.noticeAnimator then
    self.noticeAnimator:Play(self.animationName, 0, 0)
  end
  if data.audioId then
    self.audio = AudioManager.PlayMusicClipById(data.audioId)
  end
end

function KillNoticeTemplate:OnDisable()
  if self.audio then
    AudioManager.Stop(self.audio)
  end
end

return KillNoticeTemplate
