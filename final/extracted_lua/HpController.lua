HpController = {}
require("GameModel/HPData")
local this = HpController

function HpController.Init()
  HpController.RegistEvent()
end

function HpController.RegistEvent()
  this.eventContainer = EventContainer(EventManager)
end

local function BuffHurtLogic()
  local meBuffs = BuffData.GetBuffs(QuickFind.LuaMainPlayerViewAttrData().id)
  for _, buff_struct in pairs(meBuffs) do
    if buff_struct.buffConfig.subType == 402 then
      return true
    end
  end
  return false
end

function HpController.ResHpChange(data)
  local beinduj = BuffHurtLogic()
  if data.value then
    local target = RoleManager.GetRoleById(data.lid)
    if (data.lid == QuickFind.LuaMainPlayerViewAttrData().id or data.addId and data.addId == QuickFind.LuaMainPlayerViewAttrData().id or target and target.data.master == QuickFind.LuaMainPlayerViewAttrData().id or beinduj or Activity_LangHunYaoSaiData.RoleIsLangHunYongBing(data.addId)) and data.reason ~= AttributeEnum.SYN_HP_MP then
      this.ChangeHPEffectByRId(data.lid, data.value)
    end
    ViewData.ChangeRoleHp(data.lid, data.value)
  end
end

function HpController.ResHpReflectionChange(data)
  local beinduj = BuffHurtLogic()
  if data.value then
    local target = RoleManager.GetRoleById(data.lid)
    if data.lid == ViewData.meData.id or data.addId and data.addId == ViewData.meData.id or target and target.data.master == ViewData.meData.id or beinduj or Activity_LangHunYaoSaiData.RoleIsLangHunYongBing(data.addId) then
      this.ChangeHPBackHurtFromResSkill(data.lid, data.value)
    end
    ViewData.ChangeRoleHp(data.lid, data.value)
  end
end

function HpController.ResMpChange(data)
  if data.value then
    ViewData.ChangeRoleMp(data.lid, data.value)
  end
end

function HpController.ResShieldChange(data)
  if data.value then
    ViewData.ChangeRoleShield(data.lid, data.value)
  end
end

function HpController.ChangeHpBySkillEffect(data)
  for i = 1, #data.hurtList do
    local hurt = data.hurtList[i]
    if hurt.hp then
      local target = RoleManager.GetRoleById(hurt.targetId)
      local attacker = RoleManager.GetRoleById(data.attackerId)
      if (hurt.targetId == ViewData.meData.id or data.attackerId == ViewData.meData.id or target and target.data.master == ViewData.meData.id or attacker and attacker.data.master == ViewData.meData.id) and (hurt.isDodge or hurt.showHurt ~= 0) then
        this.ChangeHPFromResSkill(hurt.targetId, hurt.hp, hurt, -hurt.showHurt)
      end
      ViewData.ChangeRoleHp(hurt.targetId, hurt.hp)
    end
  end
  if data.attackerId and data.mp then
    ViewData.ChangeRoleMp(data.attackerId, data.mp)
  end
end

function HpController.ResComboChange(data)
  if data.lid == ViewData.meData.id and data.value then
    HPData.SetComboValue(data.value)
  end
end

function HpController.ChangeHPEffectByRId(rid, hp, hurtTarget)
  local role = RoleManager.GetRoleById(rid)
  if role ~= nil then
    local hpStruct = {}
    hpStruct.lid = role.id
    hpStruct.hp = hp
    hpStruct.maxHp = role.maxHp
    hpStruct.deltaHp = hp - role.hp
    hpStruct.backHurt = 0
    HPData.SetData(hpStruct, hurtTarget)
  end
end

function HpController.ChangeHPFromResSkill(rid, hp, hurtTarget, showHurt)
  local role = RoleManager.GetRoleById(rid)
  if role ~= nil then
    local hpStruct = {}
    hpStruct.lid = role.id
    hpStruct.hp = hp
    hpStruct.maxHp = role.maxHp
    hpStruct.deltaHp = showHurt
    hpStruct.backHurt = 0
    HPData.SetData(hpStruct, hurtTarget)
  end
end

function HpController.ChangeHPBackHurtFromResSkill(rid, hp, hurtTarget)
  local role = RoleManager.GetRoleById(rid)
  if role ~= nil then
    local hpStruct = {}
    hpStruct.lid = role.id
    hpStruct.hp = hp
    hpStruct.maxHp = role.maxHp
    hpStruct.deltaHp = hp - role.hp
    hpStruct.backHurt = Mathf.Abs(hp - role.hp)
    HPData.SetData(hpStruct, hurtTarget)
  end
end

function HpController.ChangeHPFromComboSkill(rid, hp, hurtTarget, showHurt)
  local role = RoleManager.GetRoleById(rid)
  if role ~= nil then
    local hpStruct = {}
    hpStruct.lid = role.id
    hpStruct.hp = hp
    hpStruct.maxHp = role.maxHp
    hpStruct.deltaHp = showHurt
    hpStruct.backHurt = 0
    hpStruct.combo = true
    HPData.SetData(hpStruct, hurtTarget)
  end
end

HpController.Init()
