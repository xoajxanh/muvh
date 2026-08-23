require("GamePlay/FightFramework/Buff/BuffMgr")
require("GamePlay/FightFramework/Conditional/ConditionalMgr")
require("GamePlay/FightFramework/Skill/BaseSkill")
require("GamePlay/FightFramework/Action/ActionManager")
require("GamePlay/FightFramework/Bullet/BulletMgr")
require("GamePlay/FightFramework/Skill/SkillEffectMgr")
require("GamePlay/FightFramework/Skill/SkillEffectDataMgr")
require("GamePlay/FightFramework/Skill/RoleAnimationMgr")
require("GamePlay/FightFramework/Skill/WeaponEffectMgr")
require("GamePlay/FightFramework/Camera/CameraEffectMgr")
require("GamePlay/FightFramework/Skill/HitEffectMgr")
require("GamePlay/FightFramework/Skill/PlayerSoundManager")
require("GamePlay/FightFramework/WeaponSkill/WeaponSkillMgr")
SkillMgr = {}
SkillMgr.ROOT = CS.UnityEngine.GameObject("SkillPool").transform
CS.UnityEngine.Object.DontDestroyOnLoad(SkillMgr.ROOT)
local this = SkillMgr
this.spawnPool = nil

function SkillMgr.OnEnterGame()
  ActionManager.Init()
end

function SkillMgr.OnLeaveGame()
  BulletMgr.LeaveGame()
end

function SkillMgr.Update()
  Profiler.BeginSample("SkillEffectMgr.Update")
  SkillEffectMgr.Update()
  Profiler.EndSample()
  Profiler.BeginSample("BulletMgr.Update")
  BulletMgr.Update()
  Profiler.EndSample()
  Profiler.BeginSample("HitEffectMgr.Update")
  HitEffectMgr.Update()
  Profiler.EndSample()
  Profiler.BeginSample("WeaponEffectMgr.Update")
  WeaponEffectMgr.Update()
  Profiler.EndSample()
  Profiler.BeginSample("CameraEffectMgr.Update")
  CameraEffectMgr.Update()
  Profiler.EndSample()
  Profiler.BeginSample("ActionManager.Update")
  ActionManager.Update()
  Profiler.EndSample()
end

function SkillMgr.RequestPreviousSkill(sid)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if tblaction and tblaction.previousSkill and tblaction.previousSkill ~= 0 then
    tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblaction.previousSkill, "groupId")
  end
  if ConditionalMgr:CanReleaseSkill(tblSkill, tblaction) then
    this.ReleaseSkillNeedCoord(tblSkill, tblaction, RoleManager.me.serverCoord:Clone())
  end
end

function SkillMgr.RequestSkillTest(sid)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblaction) then
    if tblaction.needTarget and tblaction.needTarget == 0 then
      if SkillUtility.IsDontNeedTargetSkill(tblSkill.id) then
        local res = RoleUtility.TargetIsFitMyPkMode(RoleManager.me.TargetAvatar)
        if not res and RoleManager.me.TargetAvatar then
          local targetId = RoleManager.me.TargetAvatar.id
          local targetCell = RoleManager.me.TargetAvatar.serverCoord:Clone()
          this.ReleaseSkillNeedTargetTest(tblSkill, tblaction, targetId, targetCell)
        else
          local targetCell = RoleManager.me.serverCoord:Clone()
          this.ReleaseSkillNeedTargetTest(tblSkill, tblaction, RoleManager.me.id, targetCell)
        end
      else
        local targetId = RoleManager.me.TargetAvatar.id
        local targetCell = RoleManager.me.TargetAvatar.serverCoord:Clone()
        this.ReleaseSkillNeedTargetTest(tblSkill, tblaction, targetId, targetCell)
      end
    else
      this.ReleaseSkillNeedCoord(tblSkill, tblaction, RoleManager.me.serverCoord)
    end
  end
end

function SkillMgr.RequestSkillToOthersRole(sid, roleId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblaction) and tblaction.needTarget and tblaction.needTarget == 0 then
    local targetRole = RoleManager.GetRoleById(roleId)
    if not targetRole then
      return
    end
    if SkillUtility.IsDontNeedTargetSkill(tblSkill.id) then
      local res = RoleUtility.TargetIsFitMyPkMode(targetRole)
      if not res then
        local targetId = targetRole.id
        local targetCell = targetRole.serverCoord:Clone()
        this.ReleaseSkillNeedTargetTest(tblSkill, tblaction, targetId, targetCell)
      end
    else
      local targetId = targetRole.id
      local targetCell = targetRole.serverCoord:Clone()
      this.ReleaseSkillNeedTargetTest(tblSkill, tblaction, targetId, targetCell)
    end
  end
end

function SkillMgr.RequestSkillToMe(sid)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblaction) then
    if tblaction.needTarget and tblaction.needTarget == 0 then
      if SkillUtility.IsDontNeedTargetSkill(tblSkill.id) then
        local targetCell = RoleManager.me.serverCoord:Clone()
        this.ReleaseSkillNeedTargetTest(tblSkill, tblaction, RoleManager.me.id, targetCell)
      end
    else
      this.ReleaseSkillNeedCoord(tblSkill, tblaction, RoleManager.me.serverCoord)
    end
  end
end

function SkillMgr.RequestComboSkill(sid, roleId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
  if ConditionalMgr:CanReleaseSkillNoCd(tblSkill, tblaction) then
    if roleId then
      local targetRole = RoleManager.GetRoleById(roleId)
      if not targetRole then
        return
      end
      local targetId = targetRole.id
      local targetCell = targetRole.serverCoord:Clone()
      this.ReleaseSkillNeedTargetTest(tblSkill, tblaction, targetId, targetCell)
    else
      this.ReleaseSkillNeedCoord(tblSkill, tblaction, RoleManager.me.serverCoord)
    end
  end
end

function SkillMgr.ReleaseSkillNeedTargetTest(tblSkill, tblaction, targetId, targetCoord)
  this.ReleaseSkill(tblSkill, tblaction, targetId, targetCoord)
end

function SkillMgr.ReleaseSkillNeedCoord(tblSkill, tblaction, coord)
  this.ReleaseSkill(tblSkill, tblaction, 0, coord)
end

function SkillMgr.ReleaseSkill(tblSkill, tblaction, targetId, coord)
  if RoleManager.me:IsStillState() then
    this.SendSkillMessage(tblSkill, tblaction, targetId, coord)
  elseif QiJiHelperData.isAutoFight then
    RoleManager.me:StopMove()
  else
    RoleManager.me:StopMove(function()
      if ConditionalMgr:CanReleaseSkill(tblSkill, tblaction) then
        this.SendSkillMessage(tblSkill, tblaction, targetId, coord)
      end
    end)
  end
end

function SkillMgr.SendSkillMessage(tblSkill, tblaction, mid, coord)
  local targetPos = Scene.GetPosByCell(coord)
  RoleManager.me:StopMoveImmediate()
  local tbl_skillrange = ConfigManager.GetConfig("cfg_skillRange", tblSkill.path, "groupId")
  local dir = 0
  if tbl_skillrange ~= nil then
    local deltaDir = 360 / #tbl_skillrange.paths
    local angle = Vector3.AngleBetween(targetPos, RoleManager.me.pos)
    if Mathf.Approximately(angle, 0) then
      angle = RoleManager.me.dir
    end
    dir = Mathf.Round(this.GetRightDir(angle) / deltaDir)
    if dir == #tbl_skillrange.paths then
      dir = 0
    end
    if tblSkill.startPointType == ESkillRangeStartPosType.Caster then
      coord = RoleManager.me.serverCoord
    end
  end
  local flashCoord = SkillUtility.GetFarestFlashPoint(tblSkill, ViewData.meData.id)
  if flashCoord then
    coord = flashCoord
  end
  local attackSpeed = ViewData.meData:GetAttribute(EAttributeType.attackSpeedCalculateValue)
  local skill_struct = SkillUtility.ConstructSkillFromClientData(tblSkill.id, RoleManager.me.id, RoleManager.me.serverCoord, mid, coord, dir, attackSpeed)
  SkillController.PerformClientSkill(skill_struct)
  MeController.UpdateClientSkillCd(tblSkill.id)
  this.ReqCastSkill(tblSkill.id, mid, coord, dir)
  DropItemManager.SetAutoDropActive()
end

function SkillMgr.GetRightDir(dir)
  while true do
    if dir < 0 then
      dir = dir + 360
    elseif 360 < dir then
      dir = dir - 360
    else
      return dir
    end
  end
end

function SkillMgr.ReqPrecastSkill(sid, targetid, targetCell, posAction)
  NetManager.Send(FightMessage.ReqBroadcastUseSkill, {
    skillId = sid,
    targetId = targetid,
    x = targetCell.x,
    y = targetCell.y,
    position = posAction
  })
end

function SkillMgr.ReqCastSkill(sid, targetid, targetCell, posAction)
  NetManager.Send(FightMessage.ReqPlayerUseSkill, {
    skillId = sid,
    targetId = targetid,
    x = targetCell.x,
    y = targetCell.y,
    position = posAction
  })
end
