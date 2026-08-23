local MasterSkillItemTemplate = {}

function MasterSkillItemTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function MasterSkillItemTemplate:InitParams()
  self.parentTbl = nil
  self.isInitalized = false
  self.skillData = nil
  self.isRefresh = true
  self.curBasicCareer = nil
end

function MasterSkillItemTemplate:InitControls()
  self.iconBtn = self:GetControl("icon_skill")
  self.icon = self:GetControl("icon_skill/skillIco")
  self.level = self:GetControl("icon_skill/skillLevel")
  self.cdBg = self:GetControl("icon_skill/cdBg")
  self.select = self:GetControl("icon_skill/skillSelect")
  self.select = self:GetControl("icon_skill/skillSelect")
  self.upgradeEffect = self:GetControl("icon_skill/kuangEffect")
end

function MasterSkillItemTemplate:BindUIEvent()
  self.iconBtn:SetOnClick(self, self.ClickGoCallBack)
end

function MasterSkillItemTemplate:ClickGoCallBack()
  if self.skillData then
    EventManager.Dispatch(Event.NewMasterSelectChanged, {
      type = self.skillData.subType,
      groupId = self.groupId
    })
    UIManager.Show(UIID.Tip_MasterSkillUI, {
      data = self.skillData
    })
  end
end

function MasterSkillItemTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self.groupId = data
  self:RefreshData()
  self:RefreshView()
  self:RefreshUpgradeView()
end

function MasterSkillItemTemplate:RefreshData()
  local curData = QuickFind.MasterDataMgr():GetSkillDataBySkillGroup(self.groupId)
  if self.skillData and curData.lid == self.skillData.lid then
    self.isRefresh = false
  else
    self.skillData = curData
    self.isRefresh = true
  end
end

function MasterSkillItemTemplate:RefreshView()
  if self.skillData == nil or not self.isRefresh then
    return
  end
  self.parentTbl:SetSprite("Atlas_Skill", self.skillData.skillIcon, self.icon)
  self.level:SetText(self.skillData.level .. "/" .. self.skillData.maxlevel)
  if self.skillData.type == MasterSkillTalentTypeEnum.PS then
    self:ChangeItemcdBgState(QuickFind.MasterDataMgr():GetCurEnableSubTypeIsMatchSelf(self.skillData.subType))
  else
    self.cdBg:SetActive(self.skillData.level == 0)
  end
  if RoleUtility.GetBasicCareer(RoleManager.me.career) ~= self.curBasicCareer then
    self.curBasicCareer = RoleUtility.GetBasicCareer(RoleManager.me.career)
    self.isInitalized = false
  end
  if self.skillData.type == MasterSkillTalentTypeEnum.PS and not self.isInitalized then
    self.isInitalized = true
    self:UIControl():SetAnchoredPosition(self.skillData.x, self.skillData.y)
  end
end

function MasterSkillItemTemplate:TryChangeItem()
  self:RefreshData()
  self:RefreshView()
  self:RefreshUpgradeView()
end

function MasterSkillItemTemplate:ChangeItemSelectState(state)
  self.select:SetActive(state)
end

function MasterSkillItemTemplate:ChangeItemcdBgState(isMatchSelfSubtype)
  if isMatchSelfSubtype then
    self.cdBg:SetActive(self.skillData.level == 0)
  else
    self.cdBg:SetActive(true)
  end
end

function MasterSkillItemTemplate:RefreshUpgradeView()
  if self.upgradeEffect and not IsNil(self.upgradeEffect.gameObject) then
    self.upgradeEffect:SetActive(self.skillData.type == MasterSkillTalentTypeEnum.PS and self.skillData and QuickFind.MasterDataMgr():GetUpcodeByGroupId(self.skillData.skillGroup) == MasterSkillUpcode.CanUpgrade)
  end
end

return MasterSkillItemTemplate
