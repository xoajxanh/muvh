local RoleHolyCircleEffectProcessor = {}
setmetatable(RoleHolyCircleEffectProcessor, LuaClass.RoleCircleEffectProcessorBase)

function RoleHolyCircleEffectProcessor:GetAvatar()
  if self.rid then
    if self.rid == RoleManager.me.id then
      return gameMgr:GetAvatarManager():GetMainPlayer()
    else
      return gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Player, self.rid)
    end
  end
  return nil
end

function RoleHolyCircleEffectProcessor:GetType()
  return ERoleCircleEffectType.HolyRing
end

function RoleHolyCircleEffectProcessor:InitParams()
  self.holyEffectNamePR = "Eff_hunhuan_0"
end

function RoleHolyCircleEffectProcessor:RefreshLoadEffectData()
  if self:GetAvatar() == nil or self:GetAvatar():GetHolyRingDataMgr() == nil then
    return
  end
  local holyDataTbl
  if self.rid == RoleManager.me.id then
    local state
    state, holyDataTbl = self:GetAvatar():GetHolyRingDataMgr():GetWearStateAndMap()
    if not state then
      return
    end
  else
    holyDataTbl = self:GetAvatar():GetHolyRingDataMgr():GetOtherWearHolyRingTab()
  end
  local count = table.count(holyDataTbl)
  for i = 1, count do
    if holyDataTbl[i] and holyDataTbl[i].itemId then
      table.insert(self.needLoadEffectDataTbl, {
        name = self.holyEffectNamePR .. i,
        itemId = holyDataTbl[i].itemId
      })
    end
  end
end

function RoleHolyCircleEffectProcessor:SetEffectObj(obj, param)
  local skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
  if not skinnedMesh then
    skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.MeshRenderer))
    if not skinnedMesh then
      return
    end
  end
  EquipEffectSet:SetHolyRingEffectTintColor(param.itemId, skinnedMesh)
  local animation = obj.transform:GetComponent(typeof(CS.UnityEngine.Animation))
  if animation and not IsNil(animation) then
    animation.enabled = true
  end
end

return RoleHolyCircleEffectProcessor
