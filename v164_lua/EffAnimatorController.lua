require("GameModel/BuffEffAnimatorData")
EffAnimatorController = {}
local this = EffAnimatorController

function EffAnimatorController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function EffAnimatorController.RegistEvent()
  this.messageContainer:Regist(MapMessage.ResMove, this.ResRoleMoveSetEffect)
  this.eventContainer:Regist(Event.RoleStandNoticeEff, this.ResRoleMoveSetEffect)
end

local EffRoot = {
  BuffAnchor = "BuffAnchor",
  SkillAnchor = "SkillAnchor"
}
EffAnimatorController.EffAni = {}

function EffAnimatorController.AddEff(parentRoot, data)
  if parentRoot and parentRoot.name == EffRoot.BuffAnchor and table.count(data) > 0 then
    EffAnimatorController.AddBuffEffAni(parentRoot, data)
  elseif not parentRoot or parentRoot.name ~= EffRoot.SkillAnchor or table.count(data) > 0 then
  end
end

function EffAnimatorController.AddBuffEffAni(parentRoot, data)
  if not this.EffAni[data.beffect.buffOwnerId] then
    this.EffAni[data.beffect.buffOwnerId] = {}
  end
  if parentRoot and parentRoot.name == EffRoot.BuffAnchor then
    BuffEffAnimatorData:AddObj(this.EffAni[data.beffect.buffOwnerId], data.beffect.buffCId, data.buffEffect)
  elseif not parentRoot or parentRoot.name == EffRoot.SkillAnchor then
  end
end

function EffAnimatorController.RemoveBuffEffAni(lid, buffId)
  if this.EffAni[lid] then
    EffAnimatorController.RemoveObj(this.EffAni[lid], buffId)
  end
end

function EffAnimatorController.RemoveObj(roleDic, buffCid)
  if buffCid and roleDic[buffCid] then
    roleDic[buffCid] = nil
  end
end

function EffAnimatorController.GetRoleEffectAni(lid, skillId)
  if this.EffAni[lid] then
    local buffConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
    if buffConfig and buffConfig.SkillBuffAni and not string.isNullOrEmpty(buffConfig.SkillBuffAni) then
      local obj = BuffEffAnimatorData:GetObj(this.EffAni[lid], buffConfig.SkillBuffAni)
      if obj and obj.transform and obj.transform.childCount > 0 then
        return obj.transform:GetChild(0):GetComponent("Animator")
      end
    end
  end
  return nil
end

function EffAnimatorController.UseSkillGetEffAniAndPlay(lid, skillId)
  local obj = EffAnimatorController.GetRoleEffectAni(lid, skillId)
  if obj and ClientTable.cfg_Skill_skillManager:TryGetValue(skillId).groupId == 16080100 then
    local attack = BuffEffAnimatorData.GetAttack(1, 4)
    obj:Play(attack)
  end
end

function EffAnimatorController.ResRoleMoveSetEffect(_, msg)
  local playerEff = this.EffAni[msg.lid]
  if playerEff then
    for i, v in pairs(playerEff) do
      if v.gameObject.activeSelf then
        local moveState = msg.action
        if v.transform.childCount == 0 then
          return
        end
        local obj = v.transform:GetChild(0):GetComponent("Animator")
        if not IsNil(obj) then
          local animatiorName = ""
          if moveState == ERoleMoveType.Run and obj then
            animatiorName = "run"
          elseif moveState == ERoleMoveType.Walk and obj then
            animatiorName = "walk"
          elseif moveState == ERoleMoveType.Stand and obj then
            animatiorName = "idle"
          end
          if animatiorName ~= "" then
            obj:Play(animatiorName)
          end
        end
      end
    end
  end
end
