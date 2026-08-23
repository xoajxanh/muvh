ViewRole = class(Player)
ViewRole.isViewRole = true
setgetters(ViewRole, {
  career = function(self)
    return self.data.career
  end,
  parent = function(self)
    return self.data.parent
  end,
  defaultAnimName = function(self)
    return self.data.animationName
  end
})

function ViewRole:SetActive(isShow)
  self.gameObject:SetActive(isShow)
end

function ViewRole:GetModelScale()
  return self.data.modelScale and self.data.modelScale or 0.7
end

function ViewRole:GetModelLayer()
  return UI_LAYER
end

function ViewRole:SetAnimationPrefix(strIndex, name)
  if UIManager.IsVisible(UIID.AppearBagLookUI) then
    if strIndex == "Wing" then
      self.model.animator:SetWingPrefix(name)
    elseif strIndex == "Weapon" then
      self.model.animator:SetWeaponPrefix(name)
    end
  end
  self:RefreshAnimation()
end

function ViewRole:RefreshAnimation(fadeLength)
  local name = self.defaultAnimName and self.defaultAnimName or "showstand"
  local basicSpeed = BasicMoveSpeedConfig[name]
  local speed = basicSpeed and self.tempMoveSpeed / basicSpeed
  self:PlayAnimation(name, speed, fadeLength, 1)
end

function ViewRole:RefreshModel(data)
  self:DestroyModel()
  self:DestroyEquip()
  self:InitAttribute(data)
  self:InitModel()
end

function ViewRole:SetPlayerDeadAnimator()
end

function ViewRole:GetParent()
  return self.parent
end

function ViewRole:InitRotation()
  self:SetRotation(0, 0, 0)
end

function ViewRole:SetRotation(x, y, z)
  self.dir = y
  self:StopRotate()
  self.model:SetRotation(x, y, z)
end

function ViewRole:GetMoveSpeed()
  return GameInitData.personWalkSpeed
end

function ViewRole:GetRotation()
  return self.dir
end

function ViewRole:InitEffect()
end

function ViewRole:IsCurSafeZone(pos)
  return not UIManager.IsVisible(UIID.AppearBagLookUI) and not UIManager.IsVisible(UIID.Skill_SkillPreviewUI)
end

function ViewRole:InitHeadUI()
end

function ViewRole:DestroyData()
end

function ViewRole:Destroy()
  self:DestroyModel()
  self:DestroyEquip()
  self:DestroyEffect()
  self:DestroyPet()
  if self.graphicType ~= nil then
    GameGraphicData.SubCount(self.graphicType, self.graphicQuality)
    self.graphicType = nil
    self.graphicQuality = nil
  end
  self:DestroyUI()
  self:DestroyGameObject()
  self:DestroyMoveContext()
end
