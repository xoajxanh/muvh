local RoomPlayerTemplate = {}

function RoomPlayerTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
  self:BindEvent()
end

function RoomPlayerTemplate:InitControls()
  self.headBg = self:GetControl("headBg")
  self.levelBg = self:GetControl("headBg/levelBg")
  self.flagBg = self:GetControl("headBg/headBg")
  self.imgHead = self:GetControl("headBg/imgHead")
  self.captainTeam = self:GetControl("headBg/captainTeam")
  self.playerLevel = self:GetControl("headBg/playerLevel")
  self.playerName = self:GetControl("headBg/playerName")
  self.allready = self:GetControl("headBg/allready")
  self.imgRank = self:GetControl("headBg/imgRank")
  self.imgLevel = self:GetControl("headBg/imgRank/imgLevel")
  self.btn_close = self:GetControl("btn_close")
  self.playerInfo = self:GetControl("playerInfo")
  self.btn_closePlayerInfoBg = self:GetControl("playerInfo/btn_closePlayerInfoBg")
  self.btn_look = self:GetControl("playerInfo/btn_look")
  self.btn_out = self:GetControl("playerInfo/btn_out")
end

function RoomPlayerTemplate:BindUIEvent()
  self.headBg:SetOnClick(self, self.headBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closePlayerInfoBg:SetOnClick(self, self.btn_closePlayerInfoBgOnClick)
  self.btn_look:SetOnClick(self, self.btn_lookOnClick)
  self.btn_out:SetOnClick(self, self.btn_outOnClick)
end

function RoomPlayerTemplate:BindEvent()
  self.messageContainer = EventContainer(NetManager)
end

function RoomPlayerTemplate:headBgOnClick()
  if self.data and self.data.id and self.data.id ~= 0 and self.data.id ~= RoleManager.me.id then
    self.playerInfo:SetActive(true)
  end
end

function RoomPlayerTemplate:btn_closeOnClick()
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    networkRequest.ReqCancelMatchThreeVThree(1)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(0)
    return
  end
  networkRequest.ReqExitThreeVThreeTeam(1)
end

function RoomPlayerTemplate:btn_closePlayerInfoBgOnClick()
  self.playerInfo:SetActive(false)
end

function RoomPlayerTemplate:btn_lookOnClick()
  if self.data and self.data.id and self.data.id ~= 0 then
    RoleInteractData.roleId = self.data.id
    RoleInteractData.roleName = self.data.name
    RoleInteractData.unionId = nil
    RoleInteractData.career = self.data.career
    RoleInteractData.unionName = ""
    RoleInteractData.unionPosition = nil
    RoleInteractData.fight = self.data.fight
    RoleInteractData.level = self.data.level
    RoleInteractData.serverId = nil
    RoleInteractData.interactType = nil
    networkRequest.ReqTeamEquipsInfo(self.data.id)
  end
end

function RoomPlayerTemplate:btn_outOnClick()
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    FloatingTipUtility.QuickMsg("\196\144ang gh\195\169p tr\225\186\173n kh\195\180ng th\225\187\131 th\225\187\177c hi\225\187\135n thao t\195\161c n\195\160y, h\195\163y h\225\187\167y Gh\195\169p Tr\225\186\173n tr\198\176\225\187\155c")
    return
  end
  if self.data and self.data.id then
    networkRequest.ReqKickOutTeam(self.data.id, 1)
  end
end

function RoomPlayerTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    self:UIControl():SetActive(false)
    return
  end
  self:UIControl():SetActive(true)
  self.data = data
  self.root = ui
  self:RefreshUIView()
end

function RoomPlayerTemplate:RefreshUIView()
  self.flagBg:SetAlpha(self.data.isCaptain and 1 or 0.3)
  self.imgHead:SetActive(self.data.headIcon ~= nil)
  if self.data.headIcon then
    self.root:SetSprite("Atlas_headPortrait", self.data.headIcon, self.imgHead)
  end
  self.captainTeam:SetActive(self.data.isCaptain)
  self.playerLevel:SetText(self.data.level)
  self.levelBg:SetActive(self.data.headIcon ~= nil)
  self.playerName:SetText(self.data.name)
  self.allready:SetActive(self.data.prepare)
  if self.data.cfgData and not string.isNullOrEmpty(self.data.cfgData.stageNameSmallBg) then
    self.root:SetSprite("Atlas_Main", self.data.cfgData.stageNameSmallBg, self.imgRank)
    self.imgRank:SetActive(true)
  else
    self.imgRank:SetActive(false)
  end
  if self.data.cfgData and not string.isNullOrEmpty(self.data.cfgData.stageLevelSmallName) then
    self.root:SetSprite("Atlas_Language", self.data.cfgData.stageLevelSmallName, self.imgLevel)
    self.imgLevel:SetActive(true)
  else
    self.imgLevel:SetActive(false)
  end
  self.btn_close:SetActive(RoleManager.me.id == self.data.id)
  self.playerInfo:SetActive(false)
end

function RoomPlayerTemplate:OnHide()
end

return RoomPlayerTemplate
