local Team3v3InvitablePlayerTemplate = {}

function Team3v3InvitablePlayerTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function Team3v3InvitablePlayerTemplate:InitControls()
  self.imgHead = self:GetControl("headBg/imgHead")
  self.playerLevel = self:GetControl("headBg/playerLevel")
  self.playerName = self:GetControl("headBg/playerName")
  self.playerOccupation = self:GetControl("headBg/playerOccupation")
  self.btn_invite = self:GetControl("headBg/btn_invite")
end

function Team3v3InvitablePlayerTemplate:BindUIEvent()
  self.btn_invite:SetOnClick(self, self.btn_inviteOnClick)
end

function Team3v3InvitablePlayerTemplate:btn_inviteOnClick()
  local GreaterLv = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(80000001)
  local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  local meIsCaptain = QuickFind:GetTeam3V3DataMgr():GetInvite()
  if teamInfo.leaderId ~= RoleManager.me.id and not teamInfo.otherInvite then
    FloatingTipUtility.QuickMsg("Xin vui l\195\178ng li\195\170n h\225\187\135 \196\144\225\187\153i Tr\198\176\225\187\159ng \196\145\225\187\131 m\225\187\159 quy\225\187\129n m\225\187\157i")
    return
  end
  if self.data.level < tonumber(GreaterLv) then
    FloatingTipUtility.QuickMsg("Ng\198\176\225\187\157i \196\145\198\176\225\187\163c m\225\187\157i kh\195\180ng th\225\187\143a m\195\163n c\225\186\165p \196\145\225\187\153 y\195\170u c\225\186\167u")
    return
  end
  if not QuickFind:GetTeam3V3DataMgr():CheckMenberDontHasTeam(self.data.id) then
    FloatingTipUtility.QuickMsg("Ng\198\176\225\187\157i \196\145\198\176\225\187\163c m\225\187\157i \196\145\195\163 tham gia Chi\225\186\191n \196\144\225\187\153i kh\195\161c")
    return
  end
  if teamInfo.status == 1 then
    FloatingTipUtility.QuickMsg("Chi\225\186\191n \196\144\225\187\153i \196\145\195\163 b\195\161o danh, vui l\195\178ng h\225\187\167y b\195\161o danh")
    return
  end
  if self.data.id and teamInfo.teamId then
    if RoleManager.me.id == teamInfo.leaderId then
      networkRequest.ReqInviteMember(self.data.id, teamInfo.teamId)
    elseif teamInfo.otherInvite then
      networkRequest.ReqInviteMember(self.data.id, teamInfo.teamId)
    end
  end
end

function Team3v3InvitablePlayerTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    self:UIControl():SetActive(false)
    return
  end
  self:UIControl():SetActive(true)
  self.data = data
  self.root = ui
  self:RefreshUIView()
end

function Team3v3InvitablePlayerTemplate:RefreshUIView()
  local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  self.root:SetSprite("Atlas_headPortrait", self.data.headIcon, self.imgHead)
  self.playerLevel:SetText(self.data.level)
  self.playerName:SetText(self.data.name)
  self.playerOccupation:SetText(RoleUtility.GteCareerNameByType(self.data.career))
  self.btn_invite:SetActive(true)
end

function Team3v3InvitablePlayerTemplate:OnHide()
end

return Team3v3InvitablePlayerTemplate
