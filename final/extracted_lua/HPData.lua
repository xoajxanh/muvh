HPData = {}
local this = HPData
HPData.mapName = ""
HPData.killName = ""
HPData.unionName = ""
HPData.comboValue = 0
HPData.maxComboValue = 0
HPData.hpDic = {}

function HPData.Init()
  this.comboValue = 0
  local comboSkillMaxValue = ClientTable.cfg_Global_globalManager:TryGetValue(2110001)
  this.maxComboValue = tonumber(comboSkillMaxValue.effect)
end

function HPData.SetComboValue(value)
  this.comboValue = value
  EventManager.Dispatch(Event.Skill_UpdateComboSkill)
end

function HPData.GetComboPercent()
  return this.comboValue / this.maxComboValue
end

function HPData.IsComboValeMax()
  return this.comboValue == this.maxComboValue
end

local function JudgeShowHUDType(hpStruct, hurtTarget)
  hurtTarget = hurtTarget or {
    isDouble = false,
    isExcellentHit = false,
    isCritical = false
  }
  local hType = HUDNumberRenderType.HUD_SHOW_HP_HURT
  if hpStruct.backHurt > 0 then
    hType = HUDNumberRenderType.HUD_BACK_HURT
  elseif 0 < hpStruct.deltaHp then
    hType = HUDNumberRenderType.HUD_SHOW_RECOVER_HP
  elseif hpStruct.deltaHp == 0 then
    if hurtTarget.isSkillDodge then
      hType = HUDNumberRenderType.HUD_SHOW_SkILLDODGE
    elseif hpStruct.lid == ViewData.meData.id then
      hType = HUDNumberRenderType.HUB_SHOW_DODGE_Role
    else
      hType = HUDNumberRenderType.HUB_SHOW_DODGE
    end
  elseif hurtTarget.isPunch then
    hType = HUDNumberRenderType.HUD_SHOW_MENGJI
  elseif hurtTarget.disability then
    hType = HUDNumberRenderType.HUD_SHOW_DISABLE
  elseif hurtTarget.isDouble then
    hType = HUDNumberRenderType.HUD_SHOW_CT_ATTACK
  elseif hurtTarget.isExcellentHit then
    hType = HUDNumberRenderType.HUD_SHOW_EXCELLENCE
  elseif hurtTarget.isCritical then
    hType = HUDNumberRenderType.HUD_SHOW_LUCKY
  elseif hurtTarget.ignoreDefense then
    hType = HUDNumberRenderType.HUD_IGNORE_DEFENSE
  elseif hpStruct.lid == ViewData.meData.id then
    hType = HUDNumberRenderType.HUD_SHOW_HP_HURT_Role
  else
    hType = HUDNumberRenderType.HUD_SHOW_HP_HURT
  end
  hpStruct.deltaHp = math.abs(hpStruct.deltaHp)
  hpStruct.hudType = hType
end

function HPData.SetData(hpStruct, hurtTarget)
  JudgeShowHUDType(hpStruct, hurtTarget)
  if this.hpDic[hpStruct.lid] == nil then
    this.hpDic[hpStruct.lid] = {
      hpInfos = {},
      curIndex = 0,
      totalCount = 0
    }
  end
  local roleHpInfos = this.hpDic[hpStruct.lid]
  roleHpInfos.totalCount = roleHpInfos.totalCount + 1
  roleHpInfos.hpInfos[roleHpInfos.totalCount] = hpStruct
end

function HPData.RemoveAllData(lid)
  this.hpDic[lid] = {
    hpInfos = {},
    curIndex = 0,
    totalCount = 0
  }
end
