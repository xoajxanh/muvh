WarAlliance_MemberApplyUI = class(BaseUI)
WarAlliance_MemberApplyUI.layer = UILayer.Panel
WarAlliance_MemberApplyUI.orderInLayer = 5
WarAlliance_MemberApplyUI.hideType = UIHideType.Destroy
WarAlliance_MemberApplyUI.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_MemberApplyUI.escClose = UIEscClose.DontClose

function WarAlliance_MemberApplyUI:InitControls()
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
end

function WarAlliance_MemberApplyUI:OnPreLoad()
end

function WarAlliance_MemberApplyUI:Init()
  self.GradVerifyIDTab = {}
  self.isAutoJoin = false
end

function WarAlliance_MemberApplyUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_MemberApplyUI:InitUI()
  self:InitContent()
end

function WarAlliance_MemberApplyUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_MemberApplyUI:OnHide()
end

function WarAlliance_MemberApplyUI:OnDestroy()
end

function WarAlliance_MemberApplyUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_allRefuse:SetOnClick(self, self.btn_allAgreeOnClick)
  self.btn_allAgree:SetOnClick(self, self.btn_allRefuseOnClick)
  self.InputField_level:SetOnEndEdit(self, self.InputField_levelOnChanged)
  self.InputField_mark:SetOnEndEdit(self, self.InputField_markOnChanged)
  self.AutoPass:SetOnToggleChanged(self, self.AutoPassOnValueChanged)
end

function WarAlliance_MemberApplyUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.WarAlliance_MemberApplyUI)
end

function WarAlliance_MemberApplyUI:btn_allRefuseOnClick(control)
  NetManager.Send(UnionMessage.ReqApprovalApply, {
    id = self.GradVerifyIDTab,
    join = true
  })
end

function WarAlliance_MemberApplyUI:btn_allAgreeOnClick(control)
  NetManager.Send(UnionMessage.ReqApprovalApply, {
    id = self.GradVerifyIDTab,
    join = false
  })
end

local function MemberItemCreate(control)
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_career = UIControl(control.transform, "lab_career")
  control.lab_equippoint = UIControl(control.transform, "lab_equippoint")
  control.btn_agree = UIControl(control.transform, "btn_agree")
  control.btn_refuse = UIControl(control.transform, "btn_refuse")
end

local function MemberItemRefresh(control, _, data, this)
  control.lab_name:SetText(data.info.name)
  control.lab_career:SetText(RoleUtility.GteCareerNameByType(data.info.career))
  control.lab_level:SetText(data.info.level)
  control.lab_equippoint:SetText(data.info.fight)
  control.btn_agree:SetOnClick(this, function()
    this:btn_agreeOnClick(data.info.roleId)
  end)
  control.btn_refuse:SetOnClick(this, function()
    this:btn_refuseOnClick(data.info.roleId)
  end)
end

function WarAlliance_MemberApplyUI:InitContent()
  self.MemberItemTemp = UIContainer(self.MemberItem, self, MemberItemCreate, MemberItemRefresh)
end

function WarAlliance_MemberApplyUI:RegistEvents()
  self:RegistEvent(Event.WarAlliance_Manager, self.InitWarAllianceManage, self)
end

function WarAlliance_MemberApplyUI:Refresh()
  self:InitMemberList()
end

function WarAlliance_MemberApplyUI:InitMemberList()
  NetManager.Send(UnionMessage.ReqUnionAdminInfo)
end

function WarAlliance_MemberApplyUI:InitWarAllianceManage()
  self:ShowWarAllianceManage()
end

function WarAlliance_MemberApplyUI:ShowWarAllianceManage()
  local data = WarAllianceData.MyAuditListData
  if data ~= nil then
    local dataInfo = data.info
    self.MemberItemTemp:SetData(dataInfo)
    self.GradVerifyIDTab = {}
    if 0 < #dataInfo then
      for i = 1, #dataInfo do
        table.insert(self.GradVerifyIDTab, dataInfo[i].info.roleId)
      end
    end
    self:SetApplyCondition(data)
  end
end

function WarAlliance_MemberApplyUI:btn_agreeOnClick(roleId)
  NetManager.Send(UnionMessage.ReqApprovalApply, {
    id = {roleId},
    join = true
  })
end

function WarAlliance_MemberApplyUI:btn_refuseOnClick(roleId)
  NetManager.Send(UnionMessage.ReqApprovalApply, {
    id = {roleId},
    join = false
  })
end

function WarAlliance_MemberApplyUI:SetApplyCondition(data)
  if data ~= nil then
    self.InputField_level:SetInputText(data.limitLevel)
    self.InputField_mark:SetInputText(data.limitFight)
    self.isAutoJoin = data.autoJoin
    self.AutoPass.toggle.isOn = self.isAutoJoin
  end
end

function WarAlliance_MemberApplyUI:getLevel()
  local levelLimit = tonumber(self.InputField_level:GetInputText())
  if not levelLimit then
    levelLimit = 0
  elseif levelLimit < 0 then
    levelLimit = 0
  else
    levelLimit = self:GetInputLevelNumber(levelLimit)
  end
  self.InputField_level:SetInputText(tostring(levelLimit))
  return levelLimit
end

function WarAlliance_MemberApplyUI:GetInputLevelNumber(levelLimit)
  local levelGobleConfig = GlobalConfig.GetGlobalConfig(2800024)
  if not string.isNullOrEmpty(levelGobleConfig) then
    local levelTable = string.split(levelGobleConfig, "#")
    local closestNumber = tonumber(levelTable[1])
    if levelLimit <= closestNumber then
      return levelLimit
    end
    for index, v in ipairs(levelTable) do
      if levelLimit < tonumber(v) then
        return closestNumber
      end
      closestNumber = tonumber(v)
    end
    return levelTable[#levelTable]
  end
  return 0
end

function WarAlliance_MemberApplyUI:getMark()
  local markLimit = tonumber(self.InputField_mark:GetInputText())
  if not markLimit then
    markLimit = 0
  elseif markLimit < 0 then
    markLimit = 0
  end
  self.InputField_mark:SetInputText(tostring(markLimit))
  return markLimit
end

function WarAlliance_MemberApplyUI:InputField_levelOnChanged()
  NetManager.Send(UnionMessage.ReqModifyApplyCondition, {
    limitFight = self:getMark(),
    limitLevel = self:getLevel(),
    autoJoin = self.isAutoJoin
  })
end

function WarAlliance_MemberApplyUI:InputField_markOnChanged()
  NetManager.Send(UnionMessage.ReqModifyApplyCondition, {
    limitFight = self:getMark(),
    limitLevel = self:getLevel(),
    autoJoin = self.isAutoJoin
  })
end

function WarAlliance_MemberApplyUI:AutoPassOnValueChanged(control, isOn)
  self.isAutoJoin = isOn
  if isOn then
    NetManager.Send(UnionMessage.ReqModifyApplyCondition, {
      limitFight = self:getMark(),
      limitLevel = self:getLevel(),
      autoJoin = self.isAutoJoin
    })
  else
    NetManager.Send(UnionMessage.ReqModifyApplyCondition, {
      limitFight = self:getMark(),
      limitLevel = self:getLevel(),
      autoJoin = self.isAutoJoin
    })
  end
end
