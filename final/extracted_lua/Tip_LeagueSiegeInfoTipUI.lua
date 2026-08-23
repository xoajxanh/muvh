Tip_LeagueSiegeInfoTipUI = class(BaseUI)
Tip_LeagueSiegeInfoTipUI.layer = UILayer.Panel
Tip_LeagueSiegeInfoTipUI.orderInLayer = 20
Tip_LeagueSiegeInfoTipUI.hideType = UIHideType.WaitDestroy
Tip_LeagueSiegeInfoTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_LeagueSiegeInfoTipUI.escClose = UIEscClose.DontClose

function Tip_LeagueSiegeInfoTipUI:InitControls()
  self.icon_league = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/icon_league")
  self.Bg_Close = self:GetControl("Bg_Close")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.lab_name = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/lab_name")
  self.lab_playerNum = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/lab_playerNum")
  self.lab_txt = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/Notice/lab_txt")
  self.Btn_join = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/LeagueList/Btn_join")
  self.Text_join = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/LeagueList/Btn_join/Text_join")
  self.lab_name_c = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/LeagueList/LeagueCopyLeader/sw_copyLeader/Viewport/Content/lab_name_c")
  self.Content = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/LeagueList/UnionList/sw_Union/Viewport/Content")
  self.coalitionLeaderLab_name = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/LeagueList/LeagueLeader/lab_name")
  self.Union = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/LeagueList/UnionList/sw_Union/Viewport/Content/Union")
  self.notice_change = self:GetControl("Panel_Tip/Image_TipBg/LeagueInfo/Notice/notice_change")
end

function Tip_LeagueSiegeInfoTipUI:Init()
end

function Tip_LeagueSiegeInfoTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_LeagueSiegeInfoTipUI:InitUI()
  self.DeputyLeaderTemplate = UIContainer(self.lab_name_c, self, nil, self.DeputyLeaderOnRefresh)
  self.UnionTemplate = UIUtility.BindUIContainerTemp(self.Union, LuaComponentTemplates.SingleUnionTemplate, self)
end

function Tip_LeagueSiegeInfoTipUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Btn_join:SetOnClick(self, self.Btn_joinOnClick)
  self.notice_change:SetOnClick(self, self.notice_changeOnClick)
end

function Tip_LeagueSiegeInfoTipUI:Bg_CloseOnClick(control)
  UIManager.Hide(UIID.Tip_LeagueSiegeInfoTipUI)
end

function Tip_LeagueSiegeInfoTipUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Tip_LeagueSiegeInfoTipUI)
end

function Tip_LeagueSiegeInfoTipUI:Btn_joinOnClick(control)
  local btnType = self:GetBtnType()
  if btnType == CoalitionInfoBtnType.JOIN then
    networkRequest.ReqJoinUnionKuaFu(self.args.coalitionId)
  else
    TipUtility.QuickShowPrompt({
      id = PromptWordType.ExitCoalition,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
        networkRequest.ReqQuitUnionKuaFu()
      end
    })
  end
end

function Tip_LeagueSiegeInfoTipUI:notice_changeOnClick()
  TipUtility.ShowTextInputPanel({
    reportTblId = 1001,
    confirmCallBack = function(panel)
      local curPanel = panel
      networkRequest.ReqUpdateUnionKuaFuAnnouncement(curPanel.inputData)
    end
  })
end

function Tip_LeagueSiegeInfoTipUI.DeputyLeaderOnRefresh(control, index, data)
  control:SetText(data)
end

function Tip_LeagueSiegeInfoTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_LeagueSiegeInfoTipUI:RegistEvents()
  self:RegistEvent(Event.MainPlayerCoalitionChange, self.OnMainPlayerCoalitionChange, self)
  self:RegistEvent(Event.CoalitionOnLienPeopleNumChange, self.OnCoalitionOnLienPeopleNumChange, self)
  self:RegistEvent(Event.CoalitionDataChange, self.OnCoalitionDataChange, self)
end

function Tip_LeagueSiegeInfoTipUI:OnMainPlayerCoalitionChange()
  self:RefreshCoalitionData()
end

function Tip_LeagueSiegeInfoTipUI:OnCoalitionOnLienPeopleNumChange(id, coalitionId)
  if self.coalitionInfo.id == coalitionId then
    self:RefreshPeopleNum()
  end
end

function Tip_LeagueSiegeInfoTipUI:OnCoalitionDataChange(id, coalitionId)
  if coalitionId == nil or self.coalitionInfo.id == coalitionId then
    self:RefreshCoalitionData()
  end
end

function Tip_LeagueSiegeInfoTipUI:Refresh()
  if self:AnalysisParams(self.args) == false then
    return
  end
  self:RefreshFlagPicture()
  self:RefreshCoalitionName()
  self:RefreshPeopleNum()
  self:RefreshAnnouncement()
  self:RefreshCoalitionLeaderName()
  self:RefreshDeputyLeader()
  self:RefreshUnionList()
  self:RefreshBtn()
  self:RefreshNoticeBtn()
end

function Tip_LeagueSiegeInfoTipUI:RefreshCoalitionData()
  self.mainPlayerStatus = self.coalitionInfo:GetMainPlayerStatus()
  self.isUnionLeader = gameMgr:GetAvatarManager():GetMainPlayer():GetWarAllianceData().IsLeader()
  self.canKickPlayer = gameMgr:GetCoalitionManager():CoalitionCanKickPlayer(self.coalitionInfo.id)
  self:RefreshPeopleNum()
  self:RefreshCoalitionLeaderName()
  self:RefreshDeputyLeader()
  self:RefreshUnionList()
  self:RefreshAnnouncement()
  self:RefreshBtn()
  self:RefreshNoticeBtn()
end

function Tip_LeagueSiegeInfoTipUI:AnalysisParams(params)
  if type(params.coalitionId) ~= "number" then
    return false
  end
  self.coalitionInfo = gameMgr:GetCoalitionManager():GetCoalitionInfo(params.coalitionId)
  gameMgr:GetCoalitionManager():SetLookCoalition(params.coalitionId)
  self.mainPlayerStatus = self.coalitionInfo:GetMainPlayerStatus()
  self.isUnionLeader = gameMgr:GetAvatarManager():GetMainPlayer():GetWarAllianceData().IsLeader()
  self.canKickPlayer = gameMgr:GetCoalitionManager():CoalitionCanKickPlayer(self.coalitionInfo.id)
  if self.coalitionInfo == nil then
    return false
  end
  return true
end

function Tip_LeagueSiegeInfoTipUI:RefreshFlagPicture()
  self:SetSprite("Atlas_Common", self.coalitionInfo:GetIconName(), self.icon_league)
end

function Tip_LeagueSiegeInfoTipUI:RefreshCoalitionName()
  self.lab_name:SetText(self.coalitionInfo:GetName())
end

function Tip_LeagueSiegeInfoTipUI:RefreshPeopleNum()
  self.lab_playerNum:SetText(self.coalitionInfo:GetPeopleNumDes())
end

function Tip_LeagueSiegeInfoTipUI:RefreshAnnouncement()
  self.lab_txt:SetText(self.coalitionInfo:GetAnnouncement())
end

function Tip_LeagueSiegeInfoTipUI:RefreshCoalitionLeaderName()
  self.coalitionLeaderLab_name:SetText(self.coalitionInfo:GetLeaderName())
end

function Tip_LeagueSiegeInfoTipUI:RefreshDeputyLeader()
  self.DeputyLeaderTemplate:SetData(self:AnalysisUnionLeaderNameList())
end

function Tip_LeagueSiegeInfoTipUI:RefreshUnionList()
  self.UnionTemplate:SetData(self:GetAddDataUnionList())
end

function Tip_LeagueSiegeInfoTipUI:RefreshBtn()
  local btnType = self:GetBtnType()
  local btnDes = ""
  if btnType == CoalitionInfoBtnType.JOIN then
    btnDes = "Xin gia nh\225\186\173p"
  elseif btnType == CoalitionInfoBtnType.EXIT then
    btnDes = "R\225\187\157i kh\225\187\143i li\195\170n minh"
  end
  self.Btn_join:SetActive(string.isNullOrEmpty(btnDes) == false)
  self.Text_join:SetText(btnDes)
end

function Tip_LeagueSiegeInfoTipUI:RefreshNoticeBtn()
  local isCoalitionLeader = self.coalitionInfo:IsLeader(RoleManager.me.name)
  self.notice_change:SetActive(isCoalitionLeader)
end

function Tip_LeagueSiegeInfoTipUI:AnalysisUnionLeaderNameList()
  local unionList = self.coalitionInfo:GetUnionList()
  local nameList = {}
  for k, v in pairs(unionList) do
    if self.coalitionInfo.serverData ~= nil and v.unionLeaderName ~= self.coalitionInfo.serverData.leaderUnionName then
      table.insert(nameList, v.unionLeaderName)
    end
  end
  return nameList
end

function Tip_LeagueSiegeInfoTipUI:GetAddDataUnionList()
  local unionList = self.coalitionInfo:GetUnionList()
  for k, v in pairs(unionList) do
    v.isCanKickPlayer = self.canKickPlayer
  end
  return unionList
end

function Tip_LeagueSiegeInfoTipUI:OnHide()
  gameMgr:GetCoalitionManager():RemoveLookCoalition()
end

function Tip_LeagueSiegeInfoTipUI:OnDestroy()
end

function Tip_LeagueSiegeInfoTipUI:GetBtnType()
  local mainPlayerCoalitionInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetCoalitionInfo()
  if self.isUnionLeader then
    if mainPlayerCoalitionInfo == nil then
      return CoalitionInfoBtnType.JOIN
    elseif mainPlayerCoalitionInfo ~= nil and mainPlayerCoalitionInfo.id == self.coalitionInfo.id then
      return CoalitionInfoBtnType.EXIT
    end
  end
  return CoalitionInfoBtnType.NONE
end
