Team_TeamNearbyInfoUI = class(BaseUI)
Team_TeamNearbyInfoUI.layer = UILayer.Panel
Team_TeamNearbyInfoUI.orderInLayer = 0
Team_TeamNearbyInfoUI.hideType = UIHideType.WaitDestroy
Team_TeamNearbyInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team_TeamNearbyInfoUI.escClose = UIEscClose.DontClose

function Team_TeamNearbyInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.Content = self:GetControl("img_bg/img_list/sw_data/Viewport/Content")
  self.sp_teamInfo = self:GetControl("img_bg/img_list/sw_data/Viewport/Content/sp_teamInfo")
  self.lab_name = self:GetControl("img_bg/img_list/sw_data/Viewport/Content/sp_teamInfo/lab_name")
  self.lab_guildName = self:GetControl("img_bg/img_list/sw_data/Viewport/Content/sp_teamInfo/lab_guildName")
  self.lab_number = self:GetControl("img_bg/img_list/sw_data/Viewport/Content/sp_teamInfo/lab_number")
  self.btn_apply = self:GetControl("img_bg/img_list/sw_data/Viewport/Content/sp_teamInfo/btn_apply")
end

function Team_TeamNearbyInfoUI:Init()
  self.teamContainer = nil
end

function Team_TeamNearbyInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnCreate(ctr)
  ctr.leaderName = UIControl(ctr.transform, "lab_name")
  ctr.guildName = UIControl(ctr.transform, "lab_guildName")
  ctr.teamNum = UIControl(ctr.transform, "lab_number")
  ctr.applyStateLab = UIControl(ctr.transform, "btn_apply/Text")
  ctr.applyBtn = UIControl(ctr.transform, "btn_apply")
end

local function OnRefresh(ctr, _, data, ui)
  local memberInfo = TeamData.GetTeamLeaderInfoByTeamInfo(data)
  ctr.leaderName:SetText(memberInfo.info.name)
  local unionName = string.isNullOrEmpty(memberInfo.info.unionName) and ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_3") or memberInfo.info.unionName
  ctr.guildName:SetText(unionName)
  ctr.teamNum:SetText(tostring(TeamData.GetTeamMemberCountByTeamInfo(data)))
  local inviteData = data.asks
  local invited = false
  for k, v in pairs(inviteData) do
    if ViewData.meData.id == v.rid then
      invited = true
    end
  end
  if TeamData.GetTeamId() == data.teamId then
    ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("YiJiaRu"))
  elseif invited then
    ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_7"))
  else
    ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_8"))
  end
  ctr.applyBtn:SetOnClick(ui, function()
    if not TeamData.IsInTeamState() and TeamData.GetAskTeamCondition() and not invited then
      ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_7"))
      ctr.applyBtn.button.onClick:RemoveListener(ctr.applyBtn.onClick)
    end
    EventManager.Dispatch(Event.Team_AskEnterTeam, data.teamId)
  end)
end

function Team_TeamNearbyInfoUI:InitUI()
  self.teamContainer = UIContainer(self.sp_teamInfo, self, OnCreate, OnRefresh)
end

function Team_TeamNearbyInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team_TeamNearbyInfoUI:OnHide()
end

function Team_TeamNearbyInfoUI:OnDestroy()
  self.teamContainer = nil
end

function Team_TeamNearbyInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Team_TeamNearbyInfoUI:btn_closeOnClick(control)
  UIManager.Hide(self.name)
end

function Team_TeamNearbyInfoUI:RegistEvents()
  self:RegistEvent(Event.Team_ResTeamInfo, self.Refresh, self)
end

function Team_TeamNearbyInfoUI:Refresh()
  self.teamContainer:SetData(TeamData.nearbyTeams)
end
