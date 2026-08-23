local UISkillPreViewTemplate = {}

function UISkillPreViewTemplate:Init(data)
  self:InitParams(data)
  self:InitControls()
  self:BindUIEvent()
end

function UISkillPreViewTemplate:InitParams(data)
  self.parentTbl = nil
  self.isInitialized = false
  self.yOffset = 10000
  self.lookRole = nil
  self.targetRole = nil
  self.viewRoleData = nil
  self.playConfig = {}
  self.playConfig.isLoop = data and data.isLoop or false
  self.playConfig.loopGap = data and data.loopGap or 1
  self.skill_struct = nil
end

function UISkillPreViewTemplate:InitViewRoleData()
  self.viewRoleData = {}
  self.viewRoleData.career = ViewData.meData.career
  self.viewRoleData.modelType = EModelType.Charactor
  self.viewRoleData.roleName = ViewData.meData.name
  self.viewRoleData.serverCoord = Vector2Int()
  self.viewRoleData.roleType = ERoleType.Player
  self.viewRoleData.parent = self.go_model.transform
  self.viewRoleData.animationName = "idle"
  self.viewRoleData.modelScale = 0.35
end

function UISkillPreViewTemplate:InitControls()
  self.go_model = self:GetControl("ShowInfo/My/go_model")
  self.go_targetModel = self:GetControl("ShowInfo/Enemy/go_model")
end

function UISkillPreViewTemplate:BindUIEvent()
end

function UISkillPreViewTemplate:ApperaChangeCallBack()
  self:RefreshViewRoleData()
  self:RefreshRoleView()
end

function UISkillPreViewTemplate:RefreshData(data)
  if not self.isInitialized then
    self:InitRole()
    self:InitSkill()
    self.isInitialized = true
  end
  self:RefreshSkillStruct(data)
end

function UISkillPreViewTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self:RefreshData(data)
  self:TryPlaySkill()
end

function UISkillPreViewTemplate:InitRole()
  self:InitViewRoleData()
  self:RefreshViewRoleData()
  self:RefreshRoleView()
end

function UISkillPreViewTemplate:RefreshViewRoleData()
  local equip = table.DeepCopy(ViewData.meData.equipsData.Data)
  self.viewRoleData.equipsData = RoleEquipData(equip)
  self.viewRoleData.model = RoleEquipUtility.GetCurPlayerModelName(ForgeData.appearData[ViewData.meData.id], self.viewRoleData.equipsData.Data)
  self.viewRoleData.id = tonumber(self.viewRoleData.model)
  ForgeData.appearData[self.viewRoleData.id] = ForgeData.appearData[ViewData.meData.id]
end

function UISkillPreViewTemplate:RefreshRoleView()
  if self.lookRole then
    self.lookRole:RefreshModel(self.viewRoleData)
  else
    self.lookRole = ViewRole(self.viewRoleData)
    self.lookRole:SetPosition(0, self.yOffset, 0)
    self.lookRole.transform.localEulerAngles = Vector3(0, 80, 0)
  end
  self.viewRoleData.parent = self.go_targetModel.transform
  if self.targetRole then
    self.targetRole:RefreshModel(self.viewRoleData)
  else
    self.targetRole = ViewRole(self.viewRoleData)
    self.targetRole:SetPosition(0, self.yOffset, 0)
    self.targetRole.transform.localEulerAngles = Vector3(0, -90, 0)
  end
end

function UISkillPreViewTemplate:DestroyRoleModel()
  if self.lookRole then
    self.lookRole:Destroy()
    self.lookRole = nil
  end
  if self.targetRole then
    self.targetRole:Destroy()
    self.targetRole = nil
  end
end

function UISkillPreViewTemplate:InitSkill()
  if self.skill_struct == nil then
    self.skill_struct = self:NewSkillStruct()
  end
end

function UISkillPreViewTemplate:RefreshSkillStruct(data)
  if data.skillId == self.skill_struct.skillId and data.actionId == self.skill_struct.actionId then
    return
  end
  self.skill_struct.skillId = data.skillId
  self.skill_struct.actionId = data.actionId
  self.skill_struct.tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(data.skillId)
  self.skill_struct.groupId = self.skill_struct.tblSkill.groupId
  self.skill_struct.skillConfig = ConfigManager.GetConfig("cfg_actionLogic", data.actionId, "groupId")
  if self.skill_struct.tblSkill.effectArea == 1 then
    self.skill_struct.skillRangeConfig = ConfigManager.GetConfig("cfg_skillRange", self.skill_struct.tblSkill.path, "groupId")
  end
  SkillData.SetSkillStructActionConfig(self.skill_struct)
  self.skill_struct.position = ClientTable.cfg_Skill_SkillPreviewManager:GetSkillPosConfigTblBySkillId(data.preViewid)
end

function UISkillPreViewTemplate:TryPlaySkill()
  if self.skill_struct == nil then
    return
  end
  self:RemoveCurSkill()
  self:PlaySkill()
  if self.playSkillTimer ~= nil then
    Timer.Stop(self.playSkillTimer)
  end
  if self.playConfig.isLoop then
    self.playSkillTimer = Timer.StartLoopForever(self.playConfig.loopGap, function()
      self:PlaySkill()
    end)
  end
end

function UISkillPreViewTemplate:PlaySkill()
  if self.skill_struct == nil then
    return
  end
  ActionManager.PlayClientActions(self.skill_struct)
  BaseSkill.DisposeAni(self.skill_struct)
  BaseSkill.DisposeUIEffect(self.skill_struct)
  BaseSkill.AddSkill(self.skill_struct)
  ActionManager.PlayServerActions(self.skill_struct)
end

function UISkillPreViewTemplate:RemoveCurSkill()
end

function UISkillPreViewTemplate:NewSkillStruct()
  local skill_struct = {}
  skill_struct.chooseRangeIndex = 0
  skill_struct.attackerX = self.lookRole.transform.position.x
  skill_struct.attackerY = self.lookRole.transform.position.y
  skill_struct.attackSpeed = 1.2
  skill_struct.state = SkillState.None
  skill_struct.attacker = self.lookRole
  skill_struct.attackerId = ViewData.meData.id
  skill_struct.target = self.targetRole
  skill_struct.isUI = true
  if skill_struct.target then
    skill_struct.targetPos = skill_struct.target.transform.position
  end
  skill_struct.preserved = 0
  return skill_struct
end

function UISkillPreViewTemplate:ChangeViewState(state)
  if self:UIControl() and not IsNil(self:UIControl().gameObject) then
    self:UIControl():SetActive(state)
  end
  if not state then
    self.isInitialized = false
  end
end

function UISkillPreViewTemplate:SetLoopInfo(isLoop, loopGap)
  self.playConfig.isLoop = isLoop ~= nil and isLoop or self.playConfig.isLoop
  self.playConfig.loopGap = loopGap or self.playConfig.loopGap
  self:TryPlaySkill()
end

function UISkillPreViewTemplate:OnDisable()
  if self.playSkillTimer ~= nil then
    Timer.Stop(self.playSkillTimer)
  end
  if self.skill_struct then
    self.skill_struct.skillId = 0
  end
  self:DestroyRoleModel()
end

function UISkillPreViewTemplate:OnDestroy()
  if self.playSkillTimer ~= nil then
    Timer.Stop(self.playSkillTimer)
  end
  if self.skill_struct then
    self.skill_struct.skillId = 0
  end
  self:DestroyRoleModel()
end

return UISkillPreViewTemplate
