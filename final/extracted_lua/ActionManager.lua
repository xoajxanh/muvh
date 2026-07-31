require("GamePlay/FightFramework/Action/ESkillActionStatus")
require("GamePlay/FightFramework/Action/ActionHelpers/SequenceSkillAnimationCounter")
require("GamePlay/FightFramework/Action/Action_Base")
require("GamePlay/FightFramework/Action/Action_RoleAnimation")
require("GamePlay/FightFramework/Action/Action_EquipeAnimation")
require("GamePlay/FightFramework/Action/Action_SkillOver")
require("GamePlay/FightFramework/Action/Action_ApplySkillEffect")
require("GamePlay/FightFramework/Action/Action_RoleMove")
require("GamePlay/FightFramework/Action/Action_Audio")
require("GamePlay/FightFramework/Action/Action_HitMove")
require("GamePlay/FightFramework/Action/Action_HitEffect")
require("GamePlay/FightFramework/Action/Action_LookAtTarget")
require("GamePlay/FightFramework/Action/Action_SyncServerPos")
require("GamePlay/FightFramework/Action/Action_RandomRangeEffect")
local MIN_SKILL_DURATION = 0.1
ActionManager = {}
local this = ActionManager
local m_actions = {}

function ActionManager.PlayServerActions(skillData, skillMsg)
  if not skillData.skillConfig then
    return
  end
  this.AddRoleSyncServerPosAction(skillData)
end

function ActionManager.OnLeaveGame()
  m_actions = {}
end

function ActionManager.PlayClientActions(skillData)
  if not skillData.skillConfig then
    return
  end
  this.AddRoleAnimationActions(skillData)
  this.AddEquipeAnimationActions(skillData)
  this.AddSkillOverAction(skillData)
  if skillData.attackerId == ViewData.meData.id then
    this.AddAudioAction(skillData)
  end
  this.AddRoleMoveAction(skillData)
  this.AddLookingAtTargetAction(skillData)
  if BaseSkill.IsEffectShow(skillData) then
    this.AddRandomRangeEffectAction(skillData)
  end
end

function ActionManager.PlayHitActions(skillData, data)
  if not skillData.skillConfig then
    return
  end
  this.AddApplySkillEffectAction(skillData, data)
  this.AddHitEffectActions(skillData, data)
end

function ActionManager.Init()
  RoleMoveActionMgr.Init()
end

function ActionManager.Update()
  for _, v in pairs(m_actions) do
    v:Process()
    if v.actionStatus == ESkillActionStatus.Destroyed then
      m_actions[v.tableAddress] = nil
      if m_actions[v.tableAddress] and m_actions[v.tableAddress].caster then
        RoleMoveActionMgr.RemoveAction(m_actions[v.tableAddress].caster.id)
      end
    end
  end
end

function ActionManager.AddRoleAnimationActions(skillData)
  if not skillData.attacker then
    return
  end
  local actions = skillData.skillConfig.actions
  if actions.ActionRoleAnimationData then
    for i = 1, #actions.ActionRoleAnimationData do
      local action = Action_RoleAnimation()
      action:Init(skillData.attacker, actions.ActionRoleAnimationData[i], skillData.attackSpeed, skillData.skillId)
      action.tableAddress = tostring(action)
      m_actions[action.tableAddress] = action
    end
  end
end

function ActionManager.AddEquipeAnimationActions(skillData)
  local actions = skillData.skillConfig.actions
  local caster = skillData.attacker
  local actionSpeed = skillData.attackSpeed
  if caster and actions.ActionEquipeAnimationData then
    for i = 1, #actions.ActionEquipeAnimationData do
      this.AddCommonAction(Action_EquipeAnimation, caster, actions.ActionEquipeAnimationData[i], actionSpeed)
    end
  end
end

function ActionManager.AddApplySkillEffectAction(skillData, skillMsg)
  local actions = skillData.skillConfig.actions
  local caster = skillData.attacker
  local applySkillEffectData = actions.ActionApplySkillEffectData and actions.ActionApplySkillEffectData[1]
  applySkillEffectData = applySkillEffectData or {startTime = 0, duration = 0}
  local action = Action_ApplySkillEffect()
  action:Init(caster, applySkillEffectData, skillData.attackSpeed, skillMsg, actions.ActionHitData)
  action.tableAddress = tostring(action)
  m_actions[action.tableAddress] = action
end

function ActionManager.AddHitEffectActions(skillData, skillMsg)
  local action, actionHitData
  local actions = skillData.skillConfig.actions
  for i = 1, #skillMsg.hurtList do
    local hurt = skillMsg.hurtList[i]
    local target = RoleManager.GetRoleById(hurt.targetId)
    if actions.ActionHitData then
      if actions.ActionHitData[1] then
        local hitMoveData = actions.ActionHitData[1].hitMoveHandler
        if not string.isNullOrEmpty(hitMoveData) then
          action = Action_HitMove()
          action:Init(target, actions.ActionHitData[1], skillData.attackSpeed)
          action.tableAddress = tostring(action)
          m_actions[action.tableAddress] = action
        end
      end
      local targetCell = Vector2Int(hurt.x, hurt.y)
      if skillData.skillConfig.actionNum and skillData.skillConfig.actionNum > 0 then
        if not (i <= skillData.skillConfig.actionNum) then
          goto lbl_173
        end
        for j = 1, #actions.ActionHitData do
          local hitData = actions.ActionHitData[j]
          if hitData.hits and hitData.hits.hitStruct then
            for k = 1, #hitData.hits.hitStruct do
              local effectActive = EffectDisplayController.AddSkillEffect(skillData.attackerId)
              if not effectActive then
                break
              end
              action = Action_HitEffect()
              actionHitData = table.clone(hitData.hits.hitStruct[k])
              actionHitData.synchronizationStart = hitData.synchronizationStart
              actionHitData.synchronizationDuration = hitData.synchronizationDuration
              action:Init(skillData.attackerId, actionHitData, skillData.attackSpeed, hurt.targetId, targetCell)
              action.tableAddress = tostring(action)
              m_actions[action.tableAddress] = action
            end
          end
        end
      else
        for j = 1, #actions.ActionHitData do
          local hitData = actions.ActionHitData[j]
          if hitData.hits and hitData.hits.hitStruct then
            for k = 1, #hitData.hits.hitStruct do
              local effectActive = EffectDisplayController.AddSkillEffect(skillData.attackerId)
              if not effectActive then
                break
              end
              action = Action_HitEffect()
              actionHitData = table.clone(hitData.hits.hitStruct[k])
              actionHitData.synchronizationStart = hitData.synchronizationStart
              actionHitData.synchronizationDuration = hitData.synchronizationDuration
              action:Init(skillData.attackerId, actionHitData, skillData.attackSpeed, hurt.targetId, targetCell)
              action.tableAddress = tostring(action)
              m_actions[action.tableAddress] = action
            end
          end
        end
      end
    end
    ::lbl_173::
  end
end

function ActionManager.AddSkillOverAction(skillData)
  if SkillUtility.IsComboSkill(skillData.skillId) then
    return
  end
  local actions = skillData.skillConfig.actions
  local skillOverData = actions.ActionSkillOverData and actions.ActionSkillOverData[#actions.ActionSkillOverData]
  if not skillOverData then
    local skillOverTime = SkillUtility.GetActionDefaultEndTime(skillData.skillConfig)
    skillOverData = {
      startTime = skillOverTime,
      duration = 0,
      synchronizationStart = true
    }
  end
  local action = Action_SkillOver()
  action:Init(skillData.attacker, skillOverData, skillData.attackSpeed, skillData.skillId)
  action.tableAddress = tostring(action)
  m_actions[action.tableAddress] = action
end

function ActionManager.AddRoleMoveAction(skillData)
  local actions = skillData.skillConfig.actions
  local roleMoveData = actions.ActionRoleMoveData and actions.ActionRoleMoveData[1]
  if roleMoveData then
    local action = Action_RoleMove()
    local targetCell
    if skillData.attackerId == ViewData.meData.id and skillData.target and SkillUtility.CanJumpHitToTargetRoleCell(skillData.tblSkill, skillData.attacker, skillData.target) then
      targetCell = skillData.target.serverCoord
    else
      targetCell = Vector2Int(skillData.attackerX, skillData.attackerY)
      if skillData.attacker then
        skillData.attacker:StopMoveImmediate()
      end
    end
    action:Init(skillData.attacker, roleMoveData, skillData.attackSpeed, targetCell)
    action.tableAddress = tostring(action)
    m_actions[action.tableAddress] = action
    RoleMoveActionMgr.AddAction(skillData.attackerId, action)
  end
end

function ActionManager.AddRoleSyncServerPosAction(skillData)
  local actions = skillData.skillConfig.actions
  local syncServerPosData = actions.ActionSyncServerPosData and actions.ActionSyncServerPosData[1]
  if syncServerPosData then
    local action = Action_SyncServerPos()
    action:Init(skillData.attacker, syncServerPosData, skillData.attackSpeed)
    action.tableAddress = tostring(action)
    m_actions[action.tableAddress] = action
  end
end

function ActionManager.AddAudioAction(skillData)
  local actions = skillData.skillConfig.actions
  local caster = skillData.attacker
  local actionSpeed = skillData.attackSpeed
  if caster and actions.ActionAudioData then
    for i = 1, #actions.ActionAudioData do
      this.AddCommonAction(Action_Audio, caster, actions.ActionAudioData[i], actionSpeed)
    end
  end
end

function ActionManager.AddLookingAtTargetAction(skillData)
  local actions = skillData.skillConfig.actions
  if not actions.ActionLookTargetData then
    return
  end
  for i = 1, #actions.ActionLookTargetData do
    local action = Action_LookAtTarget()
    action:Init(skillData.attacker, skillData.targetId, actions.ActionLookTargetData[i], skillData.attackSpeed)
    action.tableAddress = tostring(action)
    m_actions[action.tableAddress] = action
  end
end

function ActionManager.AddCommonAction(actionType, caster, equipeAnimActData, actionSpeed)
  local action = actionType()
  action:Init(caster, equipeAnimActData, actionSpeed)
  action.tableAddress = tostring(action)
  m_actions[action.tableAddress] = action
end

function ActionManager.AddRandomRangeEffectAction(skillData)
  if skillData == nil or skillData.skillConfig == nil or skillData.skillConfig.actions == nil then
    return
  end
  local actions = skillData.skillConfig.actions
  if not actions.ActionRandomRangeEffectData then
    return
  end
  local attackerPos = Vector3.zero
  if skillData.isUI == true and skillData.attacker ~= nil then
    attackerPos = skillData.attacker.transform.position
  else
    Scene.GetPosByCellNonAlloc(skillData.attackerX, skillData.attackerY, attackerPos)
  end
  for i = 1, #actions.ActionRandomRangeEffectData do
    local action = Action_RandomRangeEffect()
    action:Init(skillData.attacker, actions.ActionRandomRangeEffectData[i], skillData.attackSpeed, attackerPos, skillData.targetPos)
    action.tableAddress = tostring(action)
    m_actions[action.tableAddress] = action
  end
end
