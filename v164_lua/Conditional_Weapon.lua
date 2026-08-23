Conditional_Weapon = class(BaseConditional)
Conditional_Weapon.name = "weaponCondition"

function Conditional_Weapon:Calc(tblSkill, tblAction)
  if tblSkill.needWeapon == "" then
    return true
  end
  if RoleManager.me == nil then
    return false
  end
  local needWeapons = string.split(tblSkill.needWeapon, "#")
  local leftWeapon = RoleManager.me.equipsData.Data[ERoleEquipPosition.left_weapon]
  local rightWeapon = RoleManager.me.equipsData.Data[ERoleEquipPosition.right_weapon]
  for i, v in ipairs(needWeapons) do
    if leftWeapon and leftWeapon.tblItem.subType == tonumber(v) then
      return true
    end
    if rightWeapon and rightWeapon.tblItem.subType == tonumber(v) then
      return true
    end
  end
  return false
end

function Conditional_Weapon:CalcTips(tblSkill, tblAction)
  if tblSkill.needWeapon == "" then
    return true
  end
  local needWeapons = string.split(tblSkill.needWeapon, "#")
  local leftWeapon = RoleManager.me.equipsData.Data[ERoleEquipPosition.left_weapon]
  local rightWeapon = RoleManager.me.equipsData.Data[ERoleEquipPosition.right_weapon]
  for i, v in ipairs(needWeapons) do
    if leftWeapon and leftWeapon.tblItem.subType == tonumber(v) then
      return true
    end
    if rightWeapon and rightWeapon.tblItem.subType == tonumber(v) then
      return true
    end
  end
  FloatingTipUtility.QuickMsg("K\225\187\185 n\196\131ng n\195\160y c\225\186\167n v\197\169 kh\195\173 m\225\187\155i c\195\179 th\225\187\131 d\195\185ng")
  return false
end
