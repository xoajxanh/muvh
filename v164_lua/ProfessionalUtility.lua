ProfessionalUtility = {}
local this = ProfessionalUtility
CareerChange = {
  BeforeCareer = enum(0),
  CurrentCareer = enum(1),
  AfterCareer = enum(2)
}

function ProfessionalUtility.GetCareerTbl(type)
  return this.GetTblType(type)
end

function ProfessionalUtility.GetCanCareer(type)
  local carBle = this.GetTblType(type)
  if carBle then
    return carBle.transferId
  end
end

function ProfessionalUtility.GetCanCost(type)
  local carBle = this.GetTblType(type)
  if carBle then
    return carBle.cost
  end
end

function ProfessionalUtility.GetTblType(type, career, afterCareer)
  if ViewData.meData then
    career = career and career or ViewData.meData.career
    afterCareer = afterCareer and afterCareer or CareerChange.CurrentCareer
    local carBbl
    if type ~= ERoleSchema.DoubleHit and type ~= ERoleSchema.DivineBounds then
      if afterCareer == CareerChange.BeforeCareer then
        carBbl = ClientTable.cfg_Career_transferManager:BaseGetTabListByType(career, "previewId")
      end
      if afterCareer == CareerChange.CurrentCareer then
        carBbl = ClientTable.cfg_Career_transferManager:BaseGetTabListByType(career, "id")
      end
      if afterCareer == CareerChange.AfterCareer then
        carBbl = ClientTable.cfg_Career_transferManager:BaseGetTabListByType(career, "id")
      end
      for k, v in pairs(carBbl) do
        if v.type == type then
          return v
        end
      end
    else
      carBbl = ClientTable.cfg_Career_transferManager:BaseGetTabListByType(type, "type")
      for k, v in pairs(carBbl) do
        if RoleUtility.CareerJudge(career, v.id) then
          return v
        end
      end
    end
  end
  return nil
end

function ProfessionalUtility.GetCurSkill(carbal, career)
  if carbal == nil and string.isNullOrEmpty(carbal.unlockSkill) then
    return
  end
  local careerSkill = string.split(carbal.unlockSkill, "&")
  local skill
  career = career and career or ViewData.meData.career
  for k, v in pairs(careerSkill) do
    if v then
      skill = string.splitToNumbers(v)
      if RoleUtility.GetBasicCareer(career) == skill[1] then
        table.remove(skill, 1)
        return skill
      end
    end
  end
end

function ProfessionalUtility.GetCurEquip(carbal, career)
  if carbal == nil and string.isNullOrEmpty(carbal.unlockEquip) then
    return
  end
  local careerEquip = string.split(carbal.unlockEquip, "&")
  local equip
  career = career and career or ViewData.meData.career
  for k, v in pairs(careerEquip) do
    if v then
      equip = string.splitToNumbers(v)
      if RoleUtility.GetBasicCareer(career) == equip[1] then
        table.remove(equip, 1)
        return equip
      end
    end
  end
end

function ProfessionalUtility.GetSkillTips(carbal)
  if carbal == nil and string.isNullOrEmpty(carbal.tips) then
    return
  end
  local skillTips = ClientTable.cfg_Ui_wordManager:TryGetValue(carbal.tips)
  if skillTips then
    return skillTips.content
  end
end

function ProfessionalUtility.GetReinArrt(carbal)
end
