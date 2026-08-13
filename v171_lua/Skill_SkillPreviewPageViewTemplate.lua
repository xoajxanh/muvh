local Skill_SkillPreviewPageViewTemplate = {}

function Skill_SkillPreviewPageViewTemplate:Init(data)
  self:InitControls()
  self:InitParams(data)
end

function Skill_SkillPreviewPageViewTemplate:InitParams(data)
  self.parentUI = nil
  self.groupIdList = nil
  self.parentUI = data.ui
  self.PageChangeCallBack = data.pageChangeCallBack
  self.initMenuData = {
    ClickMenuCallBack = self.ClickMenuCallBack,
    UI = self.parentUI,
    pageViewTbl = self
  }
  self.mainMenuContainer = UIUtility.BindUIContainerTemp(self.menu, LuaComponentTemplates.Skill_SkillPreviewMenuTemplate, self, self.initMenuData)
end

function Skill_SkillPreviewPageViewTemplate:InitControls()
  self.menu = self:GetControl("sw_show/Viewport/ContentMain/combineMenu")
end

function Skill_SkillPreviewPageViewTemplate:ClickMenuCallBack(data)
  if data == nil or self.mainMenuContainer == nil then
    return
  end
  for i, v in pairs(self.mainMenuContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefreshMenuState(data)
    end
  end
  if data.skillId ~= nil and self.PageChangeCallBack then
    self.PageChangeCallBack(self.parentUI, data)
  end
end

function Skill_SkillPreviewPageViewTemplate:Refresh(type, skillId)
  self.openType = type
  self:RefreshData()
  self:RefreshView()
  self:RefreshInitializeNeedShowSkill(skillId)
end

function Skill_SkillPreviewPageViewTemplate:RefreshData()
  self.groupIdList = nil
  if self.openType == nil then
    return
  end
  self.groupIdList = ClientTable.cfg_Skill_SkillPreviewManager:GetGroupIdListByType(self.openType)
end

function Skill_SkillPreviewPageViewTemplate:RefreshView()
  if self.groupIdList == nil then
    return
  end
  if self.mainMenuContainer == nil then
    self.mainMenuContainer:SetData(nil)
  else
    self.mainMenuContainer:SetData(self.groupIdList)
  end
  for i, v in pairs(self.mainMenuContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefershMenuView(ClientTable.cfg_Skill_SkillPreviewManager:GetGroupInfoByGroupId(v.itemTemp.tempId))
    end
  end
end

function Skill_SkillPreviewPageViewTemplate:RefreshInitializeNeedShowSkill(skillId)
  if self.groupIdList == nil then
    return
  end
  local data = self:GetNeedShowSkillData(skillId)
  self:ClickMenuCallBack(data)
end

function Skill_SkillPreviewPageViewTemplate:GetNeedShowSkillData(skillId)
  if skillId then
    return ClientTable.cfg_Skill_SkillPreviewManager:GetSKillPreviewInfoBySkillId(skillId)
  end
  return ClientTable.cfg_Skill_SkillPreviewManager:GetFirstSkillData(self.openType)
end

function Skill_SkillPreviewPageViewTemplate:OnDisable()
  for i, v in pairs(self.mainMenuContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:ClearSubMenu()
    end
  end
  self.mainMenuContainer:RemoveAll()
end

return Skill_SkillPreviewPageViewTemplate
