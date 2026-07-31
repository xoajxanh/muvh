ShopRole = class(Player)
setgetters(ShopRole, {
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

function ShopRole:SetActive(isShow)
  self.gameObject:SetActive(isShow)
end

function ShopRole:GetModelScale()
  return self.data.modelScale and self.data.modelScale or 0.35
end

function ShopRole:GetModelLayer()
  return ROLE_LAYER
end

function ShopRole:SetAnimationPrefix(strIndex, name)
  if UIManager.IsVisible(UIID.AppearBagLookUI) then
    if strIndex == "Wing" then
      self.model.animator:SetWingPrefix(name)
    elseif strIndex == "Weapon" then
      self.model.animator:SetWeaponPrefix(name)
    end
  end
  self:RefreshAnimation()
end

function ShopRole:RefreshAnimation(fadeLength)
  if Scene.IsTileType(self.cellPos.x, self.cellPos.y, SceneTileType.Sit) then
    Scene.SetRoleSitState(self.cellPos, self)
    return
  end
  if Scene.IsTileType(self.cellPos.x, self.cellPos.y, SceneTileType.FlyUp) then
    Scene.SetRoleFlyUpState(self.cellPos, self)
    return
  end
  if Scene.IsTileType(self.cellPos.x, self.cellPos.y, SceneTileType.LeanOn) then
    Scene.SetRoleLeanOnState(self.cellPos, self)
    return
  end
  local name = self.defaultAnimName and self.defaultAnimName or "showstand"
  local basicSpeed = BasicMoveSpeedConfig[name]
  local speed = basicSpeed and self.tempMoveSpeed / basicSpeed
  self:PlayAnimation(name, speed, fadeLength, 1)
end

function ShopRole:RefreshModel(data)
  self:DestroyModel()
  self:DestroyEquip()
  self:InitAttribute(data)
  self:InitModel()
end

function ShopRole:SetPlayerDeadAnimator()
end

function ShopRole:GetParent()
  return Player.GetParent(self)
end

function ShopRole:InitRotation()
  if not self.model then
    return
  end
  self.model:SetRotation(0, 135, 0)
end

function ShopRole:GetMoveSpeed()
  return 0
end

function ShopRole:IsCurSafeZone(pos)
  return not UIManager.IsVisible(UIID.AppearBagLookUI)
end

local function CreatedOneLab(self, str, offsetY)
  local trans = Instantiate(self.Head.trans:GetChild(0), self.Head.hp.transform)
  trans.localPosition = Vector3.up * -0.05 + Vector3.forward * -0.05
  trans.gameObject:GetComponent(typeof(CS.UnityEngine.MeshFilter)).mesh = nil
  local titleLab = trans.gameObject:GetComponent(typeof(CS.CSLabel))
  titleLab.fontSize = 14
  titleLab.color = Color(1, 1, 1, 1)
  titleLab.text = str
  if offsetY then
    trans.localPosition = trans.localPosition + Vector3.up * -(0.2 * offsetY)
  end
  return titleLab.HalfWidth
end

local nameColor = Color()
nameColor:Set(0.9019607843137255, 0.9019607843137255, 0, 1)
local ShopColor = Color()
ShopColor:Set(0.9803921568627451, 0.5882352941176471, 0, 1)

function ShopRole:InitHeadUI()
  if not self.Head then
    self.Head = ShopRoleHead3DMesh(self)
  end
  self.Head:ShowBlood(true)
  if self.Head.hp.transform.childCount < 3 then
    local bgObje = self.Head.hp.transform:Find("SpriteMesh-hpbg")
    local collider = bgObje.gameObject:AddMissingComponent(typeof(CS.UnityEngine.BoxCollider))
    collider.enabled = true
    collider.size = Vector3.one * 0.2
    bgObje.gameObject.layer = ROLE_LAYER
    bgObje.name = self.id
    self.SpriteMesh = bgObje.gameObject:GetComponent(typeof(CS.CSSpriteMesh))
    self.SpriteMesh.SpriteName = "orangeBottom"
    bgObje.localScale = Vector3.right * 2 + Vector3.up * 4
    bgObje.localPosition = Vector3.up * -0.05
    local titles = string.split(self.data.title, "#")
    if #titles < 3 then
      CreatedOneLab(self, string.replace(self.data.title, "#", " "))
      bgObje.localScale = Vector3.right * 6.5 + Vector3.up * 2.3
      bgObje.localPosition = Vector3.up * 0.1 + Vector3.forward * 0.075
    elseif 2 < #titles and #titles < 5 then
      CreatedOneLab(self, titles[1] .. " " .. titles[2])
      local str = ""
      for i = 3, #titles do
        if i == #titles then
          str = str .. titles[i]
        else
          str = str .. titles[i] .. " "
        end
      end
      CreatedOneLab(self, str, 1)
      bgObje.localScale = Vector3.right * 6.5 + Vector3.up * 3.5
      bgObje.localPosition = Vector3.forward * 0.075
    else
      CreatedOneLab(self, titles[1] .. " " .. titles[2] .. " " .. titles[3])
      CreatedOneLab(self, titles[4] .. " " .. titles[5], 1)
      bgObje.localScale = Vector3.right * 9.5 + Vector3.up * 3.5
      bgObje.localPosition = Vector3.forward * 0.075
    end
  end
  self.Head.nameLabel:SetTwoColTex("[Shop]", self.data.name, ShopColor, nameColor)
end

function ShopRole:OnTouch()
  self.selectState = true
  if self.model and not IsNil(self.model.modelObject) then
    for i = 0, self.model.modelObject.transform.childCount - 1 do
      local tansItem = self.model.modelObject.transform:GetChild(i)
      if tansItem.name ~= "Shadow01" then
        CS.Framework.MaterialChange.AttachOutLine(tansItem.gameObject, Color(1, 0.3203125, 0.2851562, 1.0), 0.03, 3000, "FGQJ/Role/OutLine2")
      end
    end
  end
  RoleManager.me:SetTargetAvatar(self)
  UIManager.Show(UIID.Auction_StallUI, {
    position = self.data.position
  })
  Role.OnTouch(self)
end

function ShopRole:OnCancelTouch()
  if RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.id == self.data.id then
    if self.model and not IsNil(self.model.modelObject) then
      for i = 0, self.model.modelObject.transform.childCount - 1 do
        local tansItem = self.model.modelObject.transform:GetChild(i)
        if tansItem.name ~= "Shadow01" then
          CS.Framework.MaterialChange.DisAttachOutLine(tansItem.gameObject)
        end
      end
    end
    RoleManager.me:SetTargetAvatar(nil)
    self.selectState = false
  end
  Role.OnCancelTouch(self)
end

function ShopRole:DestroyHeadUI()
  self.Head:ShowBlood(false)
  local count = self.Head.hp.transform.childCount
  for i = count - 1, 2, -1 do
    CS.UnityEngine.Object.Destroy(self.Head.hp.transform:GetChild(i).gameObject)
  end
  local bgObje = self.Head.hp.transform:Find(tostring(self.id))
  if not self.SpriteMesh and bgObje then
    self.SpriteMesh = bgObje.gameObject:GetComponent(typeof(CS.CSSpriteMesh))
  else
  end
  if self.SpriteMesh then
    self.SpriteMesh.SpriteName = "black"
  end
  if bgObje then
    bgObje.name = "SpriteMesh-hpbg"
    bgObje.localScale = Vector3.right * 1.08 + Vector3.up * 1.1
    bgObje.localPosition = Vector3.zero
  end
  Role.DestroyHeadUI(self)
end

ShopRoleHead3DMesh = class(RoleHead3DMesh)

function ShopRoleHead3DMesh:ctor(role)
  self.hideTime = nil
  self.showBlood = false
  self.base.ctor(self, role)
  self:ShowBlood(false)
end

function ShopRoleHead3DMesh:RefreshData(role)
  self.HudStyle = self:GetHudStyle()
  self.base.RefreshData(self, role)
end

function ShopRoleHead3DMesh:ShowBlood(isShow)
  if self.hp ~= nil then
    self.showBlood = isShow
    self:RefreshData(self.avatar)
  end
end

function ShopRoleHead3DMesh:SetActorName()
end

function ShopRoleHead3DMesh:InitHP()
  self.hp.gameObject:SetActive(true)
end
