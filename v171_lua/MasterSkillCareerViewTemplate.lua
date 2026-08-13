local MasterSkillCareerViewTemplate = {}

function MasterSkillCareerViewTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
  self:BindInitTemplate()
end

function MasterSkillCareerViewTemplate:InitParams()
  self.parentTbl = nil
  self.carrerData = nil
  self.carrerType = 0
  self.groupIdAndGo = {}
  self.goAndTemplate = {}
end

function MasterSkillCareerViewTemplate:InitControls()
  self.labName = self:GetControl("tab_talent_new/labName")
  self.btns = self:GetControl("tab_talent_new/btns")
  self.btn_goInput = self:GetControl("tab_talent_new/btns/btn_goInput")
  self.lab_Received = self:GetControl("tab_talent_new/btns/lab_Received")
  self.skillContainer = self:GetControl("panel_talent_tab_new/Viewport/panel/panel_skilldetail_new")
  self.panel_line_new = self:GetControl("panel_talent_tab_new/Viewport/panel/panel_line_new")
end

function MasterSkillCareerViewTemplate:BindUIEvent()
  self.btn_goInput:SetOnClick(self, self.ClickGoInputCallBack)
end

function MasterSkillCareerViewTemplate:BindInitTemplate()
  self.LineViewTemplate = luaTemplateManager.GetNewTemplate(self.panel_line_new, LuaComponentTemplates.MasterSkillLineViewTemplate)
end

function MasterSkillCareerViewTemplate:ClickGoInputCallBack()
  if QiJiHelperData.isAutoFight then
    FloatingWordUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiAutoFightTips())
    return
  end
  if self.carrerData then
    if QuickFind.MasterDataMgr():CheckReqSwitch() then
      networkRequest.ReqEnableGrandMasterTalent(self.carrerData.subType)
    else
      UIManager.Show(UIID.MasterSkill_CareerSwitchUI, {
        type = self.carrerData.subType
      })
    end
  end
end

function MasterSkillCareerViewTemplate:Refresh(data, ui)
  self.parentTbl = ui
  if data then
    self:RefreshData(data)
    self:RefreshView()
  end
end

function MasterSkillCareerViewTemplate:RefreshData(data)
  self.carrerData = data
  self.carrerType = data.subType
  self.daShiEnableTips = string.format(ClientTable.cfg_Ui_wordManager:GetDaShiEnableTips(), data.str)
  self.skillGroupTbl = QuickFind.MasterDataMgr():GetSkillGroupTblByCareerType(self.carrerData.subType)
end

function MasterSkillCareerViewTemplate:RefreshView()
  self.labName:SetText(self.carrerData.str)
  self:RefreshSkillItemContainerView()
  self:RefreshBtnView()
  self:RefreshLineView()
end

function MasterSkillCareerViewTemplate:RefreshBtnView()
  self.btns:SetActive(self.carrerData.type == MasterSkillTalentTypeEnum.PS)
  self.btn_goInput:SetActive(QuickFind.MasterDataMgr():GetCurEnableSubType() ~= self.carrerData.subType)
end

function MasterSkillCareerViewTemplate:RefreshSelectState()
  if self.carrerData == nil or self.carrerData.type == MasterSkillTalentTypeEnum.US then
    return
  end
  local isSelect = QuickFind.MasterDataMgr():GetCurEnableSubType() == self.carrerData.subType
  self.btn_goInput:SetActive(not isSelect)
  if isSelect then
    FloatingTipUtility.QuickMsg(self.daShiEnableTips)
  end
  self:TryRefreshAllLineState()
end

function MasterSkillCareerViewTemplate:RefreshSkillItemContainerView()
  local count = table.count(self.skillGroupTbl)
  self.skillContainer:SetTopGridMaxCount(count)
  local groupId, go
  for i = 1, count do
    groupId = self.skillGroupTbl[i].skillGroup
    go = self.skillContainer:GetTopGridObjectList()[i - 1].transform
    if go and groupId then
      if self.goAndTemplate[go] == nil then
        self.goAndTemplate[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.MasterSkillItemTemplate)
      end
      if self.groupIdAndGo[groupId] == nil then
        self.groupIdAndGo[groupId] = go
      end
      self.goAndTemplate[go]:Refresh(groupId, self.parentTbl)
    end
  end
end

function MasterSkillCareerViewTemplate:TryRefreshSkillView(data)
  if self.carrerData == nil or self.carrerData.subType ~= data.talent then
    return
  end
  for i, v in pairs(data.groupIds) do
    self:RefreshTargetSkillBySkillGroup(v)
  end
end

function MasterSkillCareerViewTemplate:RefreshTargetSkillBySkillGroup(groupId)
  local go = self.groupIdAndGo[groupId]
  if go == nil then
    return
  end
  local template = self.goAndTemplate[go]
  if template == nil then
    return
  end
  template:TryChangeItem()
end

function MasterSkillCareerViewTemplate:RefreshAllSkillView()
  for i, v in pairs(self.goAndTemplate) do
    v:TryChangeItem()
  end
  self:TryRefreshAllLineState()
end

function MasterSkillCareerViewTemplate:RefreshSkillIconState()
  if self.carrerData == nil or self.carrerData.type == MasterSkillTalentTypeEnum.US then
    return
  end
  local groupIds = QuickFind.MasterDataMgr():GetSkillGroupTblByCareerType(self.carrerData.subType)
  for i, v in pairs(groupIds) do
    local go = self.groupIdAndGo[v.skillGroup]
    if go == nil then
      return
    end
    local template = self.goAndTemplate[go]
    if template == nil then
      return
    end
    template:ChangeItemcdBgState(QuickFind.MasterDataMgr():GetCurEnableSubTypeIsMatchSelf(self.carrerData.subType))
  end
end

function MasterSkillCareerViewTemplate:TryRefreshSkillSelect(data, state)
  if data == nil or self.carrerData == nil or self.carrerData.subType ~= data.type then
    return
  end
  local go = self.groupIdAndGo[data.groupId]
  if go == nil then
    return
  end
  local template = self.goAndTemplate[go]
  if template == nil then
    return
  end
  template:ChangeItemSelectState(state)
end

function MasterSkillCareerViewTemplate:RefreshUpgradeView()
  for i, v in pairs(self.goAndTemplate) do
    v:RefreshUpgradeView()
  end
  self:TryRefreshAllLineState()
end

function MasterSkillCareerViewTemplate:RefreshLineView()
  if self.LineViewTemplate then
    self.LineViewTemplate:Refresh(self.skillGroupTbl, self.parentTbl)
  end
end

function MasterSkillCareerViewTemplate:TryRefreshAllLineState()
  if self.LineViewTemplate then
    self.LineViewTemplate:TryRefreshAllLineState()
  end
end

function MasterSkillCareerViewTemplate:TryRefreshLineStateByGroup(group)
  if self.LineViewTemplate then
    self.LineViewTemplate:TryRefreshLineStateByGroup(group)
  end
end

return MasterSkillCareerViewTemplate
