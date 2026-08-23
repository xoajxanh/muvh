Team_TeamApplyInfoUI = class(BaseUI)
Team_TeamApplyInfoUI.layer = UILayer.Panel
Team_TeamApplyInfoUI.orderInLayer = 0
Team_TeamApplyInfoUI.hideType = UIHideType.WaitDestroy
Team_TeamApplyInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team_TeamApplyInfoUI.escClose = UIEscClose.DontClose

function Team_TeamApplyInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_Bg/btn_close")
  self.Content = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content")
  self.sp_dataBg = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/sp_dataBg")
  self.lab_name = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/sp_dataBg/lab_name")
  self.lab_level = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/sp_dataBg/lab_level")
  self.lab_career = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/sp_dataBg/lab_career")
  self.lab_guildName = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/sp_dataBg/lab_guildName")
  self.btn_allRefuse = self:GetControl("img_Bg/btn_allRefuse")
  self.btn_allAgree = self:GetControl("img_Bg/btn_allAgree")
end

function Team_TeamApplyInfoUI:Init()
  self.teamInfoContainer = nil
end

function Team_TeamApplyInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnCreate(ctr)
  ctr.nameLabel = UIControl(ctr.transform, "lab_name")
  ctr.levelLabel = UIControl(ctr.transform, "lab_level")
  ctr.careerLabel = UIControl(ctr.transform, "lab_career")
  ctr.guildLabel = UIControl(ctr.transform, "lab_guildName")
  ctr.agreeBtn = UIControl(ctr.transform, "btn_agree")
  ctr.refuseBtn = UIControl(ctr.transform, "btn_refuse")
end

local function OnRefresh(ctr, _, data, ui)
  ctr.nameLabel:SetText(data.info.name)
  ctr.levelLabel:SetText(string.format("lv.%d", data.info.level))
  ctr.careerLabel:SetText(RoleUtility.GteCareerNameByType(data.info.career))
  local unionName = string.isNullOrEmpty(data.info.unionName) and "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i" or data.info.unionName
  ctr.guildLabel:SetText(unionName)
  ctr.agreeBtn:SetOnClick(self, function()
    local tt = {
      data.rid
    }
    EventManager.Dispatch(Event.Team_AgreeInMyTeam, tt)
  end)
  ctr.refuseBtn:SetOnClick(self, function()
    local tt = {
      data.rid
    }
    EventManager.Dispatch(Event.Team_RefuseInMyTeam, tt)
  end)
end

function Team_TeamApplyInfoUI:InitUI()
  self.teamInfoContainer = UIContainer(self.sp_dataBg, self, OnCreate, OnRefresh)
end

function Team_TeamApplyInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team_TeamApplyInfoUI:OnHide()
end

function Team_TeamApplyInfoUI:OnDestroy()
  self.teamInfoContainer = nil
end

function Team_TeamApplyInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_allAgree:SetOnClick(self, self.btn_allAgreeOnClick)
  self.btn_allRefuse:SetOnClick(self, self.btn_allRefuseOnClick)
end

function Team_TeamApplyInfoUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team_TeamApplyInfoUI)
end

function Team_TeamApplyInfoUI:btn_allRefuseOnClick(control)
  local data = {}
  for i, v in pairs(TeamData.GetAskInList()) do
    table.insert(data, v.rid)
  end
  EventManager.Dispatch(Event.Team_AllRefuseInTeam, data)
end

function Team_TeamApplyInfoUI:btn_allAgreeOnClick(control)
  local data = {}
  for i, v in pairs(TeamData.GetAskInList()) do
    table.insert(data, v.rid)
  end
  EventManager.Dispatch(Event.Team_AllAgreeInTeam, data)
end

function Team_TeamApplyInfoUI:RegistEvents()
  self:RegistEvent(Event.Team_RefreshTeamInfo, self.UpdateApplyInfo, self)
end

function Team_TeamApplyInfoUI:Refresh()
  self.teamInfoContainer:SetData(TeamData.GetAskInList())
end

function Team_TeamApplyInfoUI:UpdateApplyInfo(id, data)
  self:Refresh()
end
