RoleClickEffect = {}
local RoleTouchEffect, attachId

function RoleClickEffect.InitEffect(role)
  if role == nil then
    return
  end
  if CS.Framework.ObjectEx.IsNull(RoleTouchEffect) then
    local effectModel = CS.Framework.GameModel("monsterTouch", SkillMgr.ROOT, nil)
    effectModel:LoadAsync("Effect/Scene/guaiwuguang.prefab")
    RoleTouchEffect = effectModel.gameObject
  elseif RoleTouchEffect then
    RoleTouchEffect.gameObject:SetActive(false)
  end
  attachId = role.id
  if RoleTouchEffect then
    RoleTouchEffect.transform:SetParent(role.transform)
    RoleTouchEffect.transform.localPosition = Vector3(0, 0, 0)
    if role.boxCollider then
      local scaleSize = (role.boxCollider.size.x > role.boxCollider.size.z and role.boxCollider.size.x or role.boxCollider.size.z) * role:GetModelScale()
      RoleTouchEffect.transform.localScale = Vector3(scaleSize, scaleSize, scaleSize)
    end
    RoleTouchEffect:SetActive(true)
  end
end

function RoleClickEffect.CancelEffect(role)
  if IsNil(RoleTouchEffect) then
    logError("Khi CancelEffect, RoleTouchEffect.gameObject tr\225\187\145ng")
    return
  end
  if attachId and role and attachId == role.id then
    RoleTouchEffect.transform:SetParent(SkillMgr.ROOT)
    RoleTouchEffect:SetActive(false)
  end
end

function RoleClickEffect.RoleExit(mid)
  if mid ~= attachId then
    return
  end
  if IsNil(RoleTouchEffect) then
    logError("Khi CancelEffect, RoleTouchEffect.gameObject tr\225\187\145ng")
    return
  end
  if RoleTouchEffect then
    RoleTouchEffect.transform:SetParent(SkillMgr.ROOT)
    RoleTouchEffect:SetActive(false)
  end
end

function RoleClickEffect.BoosOpenHpUI(role)
  if role == nil then
    return
  end
  local BossidInfo = MonsterData.GetBossidInfo()
  if BossidInfo[role.data.configId] then
    UIManager.Show(UIID.BossHpInfoUI, role.data)
  end
end

function RoleClickEffect.BoosCloseHpUI(role)
  local BossidInfo = MonsterData.GetBossidInfo()
  if BossidInfo[role.data.configId] then
    UIManager.Hide(UIID.BossHpInfoUI)
  end
end
