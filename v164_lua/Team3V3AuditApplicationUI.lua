Team3V3AuditApplicationUI = class(BaseUI)
Team3V3AuditApplicationUI.layer = UILayer.Panel
Team3V3AuditApplicationUI.orderInLayer = 10
Team3V3AuditApplicationUI.hideType = UIHideType.WaitDestroy
Team3V3AuditApplicationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3AuditApplicationUI.escClose = UIEscClose.DontClose

function Team3V3AuditApplicationUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_Bg/btn_close")
  self.Content = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content")
  self.MemberItem = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/MemberItem")
  self.lab_name = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/MemberItem/lab_name")
  self.lab_level = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/MemberItem/lab_level")
  self.lab_career = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/MemberItem/lab_career")
  self.lab_equippoint = self:GetControl("img_Bg/img_list/sv_InfoList  /Viewport/Content/MemberItem/lab_equippoint")
  self.btn_allRefuse = self:GetControl("img_Bg/btn_allRefuse")
  self.btn_allAgree = self:GetControl("img_Bg/btn_allAgree")
  self.AutoPass = self:GetControl("img_Bg/AutoPass")
  self.InputField_level = self:GetControl("img_Bg/lab_levelEquire/InputField_level")
  self.InputField_mark = self:GetControl("img_Bg/lab_mark/InputField_mark")
  self.memberAutoPass = self:GetControl("img_Bg/memberAutoPass")
end

function Team3V3AuditApplicationUI:Init()
end

local function MemberItemOnCreate(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.lab_level = UIControl(ctr.transform, "lab_level")
  ctr.lab_career = UIControl(ctr.transform, "lab_career")
  ctr.btn_agree = UIControl(ctr.transform, "btn_agree")
  ctr.btn_refuse = UIControl(ctr.transform, "btn_refuse")
end

local function MemberItemOnRefresh(ctr, index, data, ui)
  ctr.lab_name:SetText(data.name)
  ctr.lab_level:SetText(data.level)
  ctr.lab_career:SetText(RoleUtility.GteCareerNameByType(data.career))
  ctr.btn_agree:SetOnClick(ui, function()
    networkRequest.ReqApproval({
      data.rid
    }, true)
  end)
  ctr.btn_refuse:SetOnClick(ui, function()
    networkRequest.ReqApproval({
      data.rid
    }, false)
  end)
end

function Team3V3AuditApplicationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Team3V3AuditApplicationUI:InitUI()
  self.MemberItemList = UIContainer(self.MemberItem, self, MemberItemOnCreate, MemberItemOnRefresh)
end

function Team3V3AuditApplicationUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_allRefuse:SetOnClick(self, self.btn_allRefuseOnClick)
  self.btn_allAgree:SetOnClick(self, self.btn_allAgreeOnClick)
  self.AutoPass:SetOnToggleChanged(self, self.AutoPassChange)
  self.InputField_level:SetOnEndEdit(self, self.FilterChanges)
  self.memberAutoPass:SetOnToggleChanged(self, self.MemberAutoPassChange)
end

function Team3V3AuditApplicationUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team3V3AuditApplicationUI)
end

function Team3V3AuditApplicationUI:btn_allRefuseOnClick(control)
  if not table.isNullOrEmpty(self.TeamApplyInfo) then
    local targetRids = {}
    for _, v in pairs(self.TeamApplyInfo) do
      table.insert(targetRids, v.rid)
    end
    networkRequest.ReqApproval(targetRids, false)
  end
end

function Team3V3AuditApplicationUI:btn_allAgreeOnClick(control)
  if not table.isNullOrEmpty(self.TeamApplyInfo) then
    local targetRids = {}
    local AgreeCount = 4 - table.count(self.TeamApplyInfo)
    for i = 1, table.count(self.TeamApplyInfo) do
      if self.TeamApplyInfo[i] and AgreeCount >= table.count(targetRids) then
        table.insert(targetRids, self.TeamApplyInfo[i].rid)
      end
    end
    networkRequest.ReqApproval(targetRids, true)
  end
end

function Team3V3AuditApplicationUI:FilterChanges(control)
  local AutoPassChange = self.AutoPass.toggle.isOn
  local levelEquireChange = self.InputField_level:GetInputText()
  local MemberAutoPassChange = self.memberAutoPass.toggle.isOn
  if not string.isNullOrEmpty(levelEquireChange) and tonumber(levelEquireChange) < tonumber(self.GreaterLv) then
    levelEquireChange = self.GreaterLv
    FloatingTipUtility.QuickMsg(string.format("Y\195\170u c\225\186\167u t\225\187\145i thi\225\187\131u Lv.%s", self.GreaterLv))
  end
  if not string.isNullOrEmpty(levelEquireChange) and tonumber(levelEquireChange) > 0 and tonumber(levelEquireChange) ~= self.TeamInfo.levelLimit then
    networkRequest.ReqChangeTeamSetting(AutoPassChange, tonumber(levelEquireChange), MemberAutoPassChange)
  end
end

function Team3V3AuditApplicationUI:AutoPassChange()
  local AutoPassChange = self.AutoPass.toggle.isOn
  local levelEquireChange = self.InputField_level:GetInputText()
  local MemberAutoPassChange = self.memberAutoPass.toggle.isOn
  if AutoPassChange ~= self.TeamInfo.autoAgreeJoin then
    networkRequest.ReqChangeTeamSetting(AutoPassChange, tonumber(levelEquireChange), MemberAutoPassChange)
  end
end

function Team3V3AuditApplicationUI:MemberAutoPassChange()
  local AutoPassChange = self.AutoPass.toggle.isOn
  local levelEquireChange = self.InputField_level:GetInputText()
  local MemberAutoPassChange = self.memberAutoPass.toggle.isOn
  if MemberAutoPassChange ~= self.TeamInfo.otherInvite then
    networkRequest.ReqChangeTeamSetting(AutoPassChange, tonumber(levelEquireChange), MemberAutoPassChange)
  end
end

function Team3V3AuditApplicationUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  networkRequest.ReqTeamApplyInfo()
end

function Team3V3AuditApplicationUI:RegistEvents()
  self:RegistEvent(Event.RefreshTeam3V3Info, self.Refresh, self)
  self:RegistEvent(Event.Team3v3ApplyInfoChange, self.RefreshMemberList, self)
end

function Team3V3AuditApplicationUI:Refresh()
  self.TeamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  if table.isNullOrEmpty(self.TeamInfo) then
    return
  end
  self.GreaterLv = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(80000001)
  self.AutoPass.toggle.isOn = self.TeamInfo.autoAgreeJoin
  local levelRequire = self.TeamInfo.levelLimit and self.TeamInfo.levelLimit or tonumber(self.GreaterLv)
  self.InputField_level:SetInputText(levelRequire > tonumber(self.GreaterLv) and tostring(self.TeamInfo.levelLimit) or self.GreaterLv)
  self.memberAutoPass.toggle.isOn = self.TeamInfo.otherInvite
end

function Team3V3AuditApplicationUI:RefreshMemberList()
  self.TeamApplyInfo = QuickFind:GetTeam3V3DataMgr():GetTeamApplyInfo()
  self.MemberItemList:SetData(self.TeamApplyInfo)
end

function Team3V3AuditApplicationUI:OnHide()
end

function Team3V3AuditApplicationUI:OnDestroy()
end
