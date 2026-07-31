RoleEquip = class()
require("Utility/RoleEquipUtility")
local AttachmentEquipPosition = {
  [ERoleEquipPosition.right_weapon] = true,
  [ERoleEquipPosition.left_weapon] = true,
  [ERoleEquipPosition.wing] = true,
  [ERoleEquipPosition.pet] = true,
  [ERoleEquipPosition.cloak] = true
}
local RedFortAttachmentEquipPosition = {
  [ERoleEquipPosition.pet] = true
}
local RoleModelBlack = {
  [7] = 7,
  [11] = 11,
  [12] = 12,
  [13] = 13,
  [14] = 14,
  [5001] = 5001,
  [2201] = 2201,
  [2202] = 2202,
  [2203] = 2203,
  [2204] = 2204,
  [2205] = 2205,
  [2206] = 2206,
  [2207] = 2207,
  [2208] = 2208,
  [8021] = 8021,
  [8022] = 8022,
  [8023] = 8023,
  [8024] = 8024,
  [8025] = 8025,
  [3421] = 3421,
  [3422] = 3422,
  [3423] = 3423,
  [3424] = 3424,
  [4531] = 4531
}
local showRoleEffectCount = 0

function RoleEquip:ctor(role)
  self.avatar = role
  self.BodyAttachment = {}
  self.BodySkinnedMesh = {}
  self.equipPosObj = {}
  self.loadingPath = {}
  self.loadedDestroyPath = {}
  self.positionLoadDic = {}
  self.Data = {
    AttachmentEquipModelData = {},
    SkinnedEquipModelData = {}
  }
  self.nudeModelData = {}
  self:InitLayer()
  self:InitData()
  self:InitWeaponAnim()
  self:InitWeaponParent()
  self:InitTentacleParent()
  self.CurrentPutOnEquipData = {}
  self.EffectLightModel = {}
  self.equipLoad = {}
  self.clothesSuitEffectInfo = {}
  local effectStr = GlobalConfig.GetGlobalConfig(2010003)
  effectStr = string.split(effectStr, "&")
  for i = 1, #effectStr do
    local levelInfor = {}
    local infoStr = string.split(effectStr[i], "#")
    levelInfor.level = tonumber(infoStr[1])
    levelInfor.EffectName = infoStr[2]
    table.insert(self.clothesSuitEffectInfo, levelInfor)
  end
  self.roleEquipOutEffect = RoleEquipOutEffect(role, self)
end

function RoleEquip:InitLayer()
  self.layer = self.avatar:GetModelLayer()
end

function RoleEquip:InitWeaponParent()
  self.RoleWeaponParentMap = {
    [ERoleEquipPosition.right_weapon] = self.avatar.RoleWeaponRightParent,
    [ERoleEquipPosition.left_weapon] = self.avatar.RoleWeaponLeftParent
  }
  self.RoleSpineParentMap = {
    [ERoleEquipPosition.right_weapon] = self.avatar.RoleWeaponRSpineParent,
    [ERoleEquipPosition.left_weapon] = self.avatar.RoleWeaponLSpineParent,
    [ERoleEquipPosition.wing] = self.avatar.RoleWingSpineParent,
    [ERoleEquipPosition.armband] = self.avatar.RoleArmbandParent,
    [ERoleEquipPosition.transcript_weapon] = self.avatar.RoleWeaponRSpineParent,
    [ERoleEquipPosition.cloak] = self.avatar.RoleCloakParent
  }
end

function RoleEquip:InitOutEffectParent()
  self.OutEffectParentDic = {
    [ERoleEquipPosition.helm] = {
      self.avatar.RoleAvatarHead
    },
    [ERoleEquipPosition.right_weapon] = {
      self.avatar.RoleWeaponRSpineParent
    },
    [ERoleEquipPosition.armor] = {
      self.avatar.RoleAvatarSpine1
    },
    [ERoleEquipPosition.glove] = {
      self.avatar.RoleAvatarLeftForearm,
      self.avatar.RoleAvatarRightForearm
    },
    [ERoleEquipPosition.pant] = {
      self.avatar.RoleAvatarRoot
    },
    [ERoleEquipPosition.boot] = {
      self.avatar.RoleAvatarLeftCalf,
      self.avatar.RoleAvatarRightCalf
    },
    [ERoleEquipPosition.footPrintIndex] = {
      self.avatar.model.transform
    }
  }
end

function RoleEquip:InitWeaponAnim()
  self.roleWeaponAnimMap = {
    [ERoleEquipPosition.right_weapon] = AnimatorCtrl(),
    [ERoleEquipPosition.left_weapon] = AnimatorCtrl()
  }
end

function RoleEquip:InitData()
  local normalTable = ClientTable.cfg_Character_modelManager:TryGetValue(self.avatar.data.career)
  if not normalTable then
    local basicCareer = RoleUtility.GetBasicCareer(self.avatar.data.career)
    normalTable = ClientTable.cfg_Character_modelManager:TryGetValue(basicCareer)
  end
  for k, v in pairs(normalTable) do
    if k ~= "id" then
      local kk = RoleEquipUtility.GetEquipIndexByName(tostring(k))
      self.nudeModelData[kk] = string.format("%s/%s", k, v)
    end
  end
end

function RoleEquip:InitEquip(isNeedRefreshSuitEffect)
  if not self.avatar.isShowModel then
    return
  end
  self.isHaveInit = true
  self:UpdateEquip(isNeedRefreshSuitEffect)
  self:PutOnEquip(ERoleEquipPosition.shadow, "shadow/Shadow01")
end

function RoleEquip:InitEquipInRedFort()
  self:UpdateEquipInRedFort()
end

function RoleEquip:UpdateEquipInRedFort()
  local curPlayerAttachData = {}
  local curPlayerSkinnedData = {}
  local equipAppearData = RoleEquipUtility.DefaultShowAppearEquip(self.avatar.data.id, self.avatar.data.equipsData.Data)
  local career = self.avatar.data.career
  career = RoleUtility.GetBasicCareer(career)
  local equipData = RoleEquipUtility.GetCareerModelData(career)
  local realEquipData = self.avatar.data.equipsData.Data
  self.EquipData = RoleEquipData(equipData)
  for k, v in pairs(self.EquipData.Data) do
    if not AttachmentEquipPosition[k] then
      if RoleEquipUtility.IsEquipAppearData(k) then
        k = k % 100
      end
      curPlayerSkinnedData[k] = v.modelPath
      if v.isHaveHead == false then
        curPlayerSkinnedData[-1] = nil
      end
    else
      curPlayerAttachData[v.bagGridIndex] = v.modelPath
    end
  end
  local unloadSkinData = table.clone(self.Data.SkinnedEquipModelData)
  for k, v in pairs(curPlayerSkinnedData) do
    if self.Data.SkinnedEquipModelData[k] then
      if v ~= self.Data.SkinnedEquipModelData[k] then
        self:PutOnEquip(k, v)
      end
      unloadSkinData[k] = nil
    else
      self:PutOnEquip(k, v)
    end
  end
  for k, v in pairs(unloadSkinData) do
    self:UnloadEquip(k)
  end
  local unloadAttachData = table.clone(self.Data.AttachmentEquipModelData)
  for k, v in pairs(curPlayerAttachData) do
    if self.Data.AttachmentEquipModelData[k] then
      if v ~= self.Data.AttachmentEquipModelData[k] then
        self:PutOnEquip(k, v)
      end
      unloadAttachData[k] = nil
    else
      self:PutOnEquip(k, v)
    end
  end
  for k, v in pairs(unloadAttachData) do
    self:UnloadEquip(k)
  end
  self:UnloadEquip(ERoleEquipPosition.shadow)
  self:CheckAndLoadCapeDisplay()
end

function RoleEquip:UpdateEquip(isNeedRefreshSuitEffect)
  local equipAppearData = RoleEquipUtility.DefaultShowAppearEquip(self.avatar.data.id, self.avatar.data.equipsData.Data)
  self.EquipData = self.avatar.data.equipsData
  local curPlayerAttachData = {}
  local curPlayerSkinnedData = table.metatableCopy(nil, self.nudeModelData)
  for k, v in pairs(self.EquipData.Data) do
    local tempPosition = v.bagGridIndex
    if RoleEquipUtility.IsEquipAppearData(tempPosition) then
      tempPosition = tempPosition % 100
    end
    if not RoleModelBlack[tempPosition] then
      if not AttachmentEquipPosition[tempPosition] then
        if RoleEquipUtility.IsEquipAppearData(v.bagGridIndex) and table.count(equipAppearData) > 0 then
          if table.contains(equipAppearData, v.bagGridIndex) then
            if v.isHaveHead then
              curPlayerSkinnedData[-1] = nil
            end
            if tempPosition ~= v.bagGridIndex and curPlayerSkinnedData[tempPosition] then
              curPlayerSkinnedData[tempPosition] = nil
            end
            curPlayerSkinnedData[v.bagGridIndex] = v.modelPath
          end
        else
          curPlayerSkinnedData[v.bagGridIndex] = v.modelPath
          if v.isHaveHead == false then
            curPlayerSkinnedData[-1] = nil
          end
        end
      elseif RoleEquipUtility.IsEquipAppearData(v.bagGridIndex) and table.count(equipAppearData) > 0 then
        if table.contains(equipAppearData, v.bagGridIndex) then
          curPlayerAttachData[v.bagGridIndex] = v.modelPath
        end
      else
        curPlayerAttachData[v.bagGridIndex] = v.modelPath
      end
    end
  end
  local unloadSkinData = table.clone(self.Data.SkinnedEquipModelData)
  for k, v in pairs(curPlayerSkinnedData) do
    if self.Data.SkinnedEquipModelData[k] then
      if v ~= self.Data.SkinnedEquipModelData[k] then
        self:PutOnEquip(k, v, isNeedRefreshSuitEffect)
      end
      unloadSkinData[k] = nil
    else
      self:PutOnEquip(k, v, isNeedRefreshSuitEffect)
    end
  end
  for k, v in pairs(unloadSkinData) do
    self:UnloadEquip(k)
  end
  local unloadAttachData = table.clone(self.Data.AttachmentEquipModelData)
  for k, v in pairs(curPlayerAttachData) do
    if self.Data.AttachmentEquipModelData[k] then
      if v ~= self.Data.AttachmentEquipModelData[k] then
        self:PutOnEquip(k, v)
      end
      unloadAttachData[k] = nil
    else
      self:PutOnEquip(k, v)
    end
  end
  for k, v in pairs(unloadAttachData) do
    self:UnloadEquip(k)
  end
  self:CheckAndLoadCapeDisplay()
end

function RoleEquip:DestroyZhaoHuanWuQITouEff(position)
  local tempPosition = position
  if tonumber(tempPosition) and tonumber(tempPosition) > 0 and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  if self.EffectShou and tempPosition == 5 then
    self.EffectShou:Destroy()
    self.EffectTou:Destroy()
  end
end

function RoleEquip:PutOnEquip(position, equipPath, isNeedRefreshSuitEffect)
  if not self.avatar.isShowModel then
    return
  end
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    local isPet = tonumber(position) and position % 100 == ERoleEquipPosition.pet
    local isFoot = tonumber(position) and position % 100 == ERoleEquipPosition.footPrintIndex
    if not isPet and not isFoot then
      return
    end
  end
  if self.avatar.playerEquipType == ERoleInitEquipType.datianshibianshen then
    local isweapon = tonumber(position) and (position % 100 == ERoleEquipPosition.right_weapon or position % 100 == ERoleEquipPosition.left_weapon)
    local iswing = tonumber(position) and position == ERoleEquipPosition.wing
    if not isweapon or iswing then
      return
    end
  end
  self:SetEquipDataRefresh()
  local tempPosition = position
  if tonumber(tempPosition) and tonumber(tempPosition) > 0 and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  if isNeedRefreshSuitEffect == nil or isNeedRefreshSuitEffect == true then
    self:CurrentPutOnEquipSet(self.EquipData.Data)
  end
  if tempPosition == ERoleEquipPosition.right_weapon or tempPosition == ERoleEquipPosition.left_weapon then
    local curEquipData = self.EquipData:GetEquipByIndex(position)
    if not curEquipData then
      return
    end
    local parent = self.RoleWeaponParentMap[tempPosition]
    if curEquipData.tblItem.subType == EItemSubtype.Shield then
      parent = self.avatar.RoleShieldLFingerParent
    elseif curEquipData.tblItem.subType == EItemSubtype.BowBag or curEquipData.tblItem.subType == EItemSubtype.CrossBowBag then
      parent = self.avatar.RoleWeaponLSpineParent
    end
    self.Data.AttachmentEquipModelData[position] = equipPath
    if parent and not IsNil(parent) then
      if QuickFind.LuaMainPlayerViewAttrData():GetBaseCareerByValue(self.avatar.data.career) == 16 and tempPosition == 5 then
        parent = self.RoleWeaponParentMap[tempPosition]
        if parent and not parent.transform:Find("Eff_zhaohuan_wuqi_shou") then
          local effectData = {
            modelType = EEffectModelType.Scene,
            model = "Eff_zhaohuan_wuqi_shou"
          }
          self.EffectShou = EffectModel(parent.transform, "Eff_zhaohuan_wuqi_shou", effectData)
          self.EffectShou:Init()
          self.EffectShou:SetLayer(ROLE_LAYER)
          self.EffectShou:SetModel(1)
          effectData = {
            modelType = EEffectModelType.Scene,
            model = "Eff_zhaohuan_wuqi_tou"
          }
          self.EffectTou = EffectModel(self.avatar.transform, "Eff_zhaohuan_wuqi_tou", effectData)
          self.EffectTou:Init()
          self.EffectTou:SetLayer(ROLE_LAYER)
          self.EffectTou:SetModel(1)
        end
      else
        self:SetWeapon(position, equipPath, parent)
      end
    end
  elseif position == ERoleEquipPosition.wing then
    self.Data.AttachmentEquipModelData[position] = equipPath
    self:SetWing(position, equipPath)
  elseif tempPosition == ERoleEquipPosition.pet then
    self.Data.AttachmentEquipModelData[position] = equipPath
    self:SetPet()
  elseif position == ERoleEquipPosition.armband then
    self.Data.AttachmentEquipModelData[position] = equipPath
    self:SetArmband(position, equipPath)
  elseif position == ERoleEquipPosition.transcript_weapon then
    self.Data.AttachmentEquipModelData[position] = equipPath
    self:SetTranscriptWeapon(position, equipPath)
  elseif position == ERoleEquipPosition.footPrintIndex or position == 4531 then
    self:SetFoot(position, equipPath)
  elseif tempPosition == ERoleEquipPosition.cloak then
    self.Data.AttachmentEquipModelData[tempPosition] = equipPath
    self:SetCloak(tempPosition, equipPath)
  else
    self.Data.SkinnedEquipModelData[position] = equipPath
    self:SetSkinnedMesh(position, equipPath)
  end
end

function RoleEquip:SetSkinnedMesh(position, path)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  self:SetEquipDataRefresh()
  local tempPosition = position
  if tonumber(tempPosition) and tonumber(tempPosition) > 0 then
    if RoleEquipUtility.IsEquipAppearData(tempPosition) then
      tempPosition = tempPosition % 100
    elseif tempPosition ~= ERoleEquipPosition.shadow then
      return
    end
  end
  local equipData = self.EquipData:GetEquipByIndex(position)
  if tempPosition == ERoleEquipPosition.helm then
    local part = RoleEquipUtility.GetEquipNameByIndex(-1)
    if equipData and equipData.isHaveHead then
      self.Data.SkinnedEquipModelData[-1] = nil
      if not IsNil(self.BodySkinnedMesh[part]) then
        local obj = self.BodySkinnedMesh[part]
        self.BodySkinnedMesh[part] = nil
        self:RecycleModel(EModelType.Equip, obj.name, obj)
      end
    elseif equipData and not equipData.isHaveHead then
      self.Data.SkinnedEquipModelData[-1] = self.nudeModelData[-1]
      if not self.BodySkinnedMesh[part] then
        self:LoadSkinnedMeshModel(part, -1, self.nudeModelData[-1])
      end
    end
  elseif tempPosition == -1 then
    for i, v in pairs(self.EquipData.Data) do
      if RoleEquipUtility.IsEquipAppearData(v.bagGridIndex) and v.bagGridIndex % 100 == ERoleEquipPosition.helm then
        return
      end
    end
  end
  local part = RoleEquipUtility.GetEquipNameByIndex(position)
  self.positionLoadDic[part] = nil
  if not IsNil(self.BodySkinnedMesh[part]) then
    local obj = self.BodySkinnedMesh[part]
    self:RecycleModel(EModelType.Equip, obj.name, obj)
    self.BodySkinnedMesh[part] = nil
  end
  self:LoadSkinnedMeshModel(part, position, path)
end

function RoleEquip:SetWeapon(position, path, parent)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  local tempPosition = position
  if tonumber(tempPosition) and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  if parent == nil then
    return
  end
  self.positionLoadDic[parent] = nil
  if not IsNil(self.BodyAttachment[tempPosition]) then
    local obj = self.BodyAttachment[tempPosition]
    if self.roleWeaponAnimMap[tempPosition] then
      self.roleWeaponAnimMap[tempPosition]:Play("none")
      self.roleWeaponAnimMap[tempPosition]:Init()
    end
    self:RecycleModel(EModelType.Equip, obj.name, obj)
    self.BodyAttachment[tempPosition] = nil
    self.equipPosObj[position] = nil
  end
  self:LoadAttachmentModel(parent, position, path)
end

function RoleEquip:SetWing(position, path)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  local parent = self.RoleSpineParentMap[position]
  if not IsNil(self.wingObj) then
    local obj = self.wingObj
    if self.wingAnimator then
      self.wingAnimator:PlayTest("none")
    end
    self:RecycleModel(EModelType.Equip, obj.name, obj)
    self.equipPosObj[position] = nil
  end
  self:LoadAttachmentModel(parent, position, path)
end

function RoleEquip:SetPet()
  if self.avatar.RolePet then
    self.avatar:DestroyPet()
  end
  self.avatar:InitPet()
end

function RoleEquip:SetArmband(position, path)
  local parent = self.RoleSpineParentMap[position]
  if not IsNil(self.ArmbandObj) then
    local obj = self.ArmbandObj
    self:RecycleModel(EModelType.Equip, obj.name, obj)
    self.equipPosObj[position] = nil
  end
  self:LoadAttachmentModel(parent, position, path)
end

function RoleEquip:SetTranscriptWeapon(position, path)
  local parent = self.RoleSpineParentMap[position]
  if not IsNil(self.transcriptWeaponObj) then
    local obj = self.transcriptWeaponObj
    self:RecycleModel(EModelType.Equip, obj.name, obj)
    self.equipPosObj[position] = nil
  end
  self:LoadAttachmentModel(parent, position, path)
end

function RoleEquip:SetFoot(position, path)
  if not IsNil(self.footPrintObj) then
    local obj = self.footPrintObj
    self:RecycleModel(EModelType.Equip, obj.name, obj)
    self.equipPosObj[position] = nil
  end
  if self.avatar.model and self.avatar.model.transform then
    local parent = self.avatar.model.transform
    self:LoadAttachmentModel(parent, position, path)
  end
end

function RoleEquip:SetCloak(position, path)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  if not IsNil(self.cloakObj) then
    if self.cloakObj then
      self:RecycleModel(EModelType.Equip, self.cloakObj.name, self.cloakObj)
    end
    self.equipPosObj[position] = nil
  end
  self:LoadAttachmentModel(self.RoleSpineParentMap[position], position, path)
end

function RoleEquip:UnloadEquip(position)
  if not self.avatar.isShowModel then
    return
  end
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    local isPet = tonumber(position) and position % 100 == ERoleEquipPosition.pet
    local isFoot = tonumber(position) and position % 100 == ERoleEquipPosition.footPrintIndex
    local isTranscript_weapon = tonumber(position) and position == ERoleEquipPosition.transcript_weapon
    if not isPet and not isFoot and not isTranscript_weapon then
      return
    end
  end
  self:SetEquipDataRefresh()
  local tempPosition = position
  if tonumber(tempPosition) and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  if RoleModelBlack[tempPosition] then
    return
  end
  if position ~= ERoleEquipPosition.shadow then
    self:RemoveEquipData(position)
  end
  self:RemoveEquipModel(position)
  self:CurrentPutOnEquipSet(self.EquipData.Data)
end

function RoleEquip:RemoveEquipData(strIndex)
  local tempPosition = strIndex
  if tonumber(tempPosition) and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  self.Data.SkinnedEquipModelData[strIndex] = nil
  self.Data.AttachmentEquipModelData[strIndex] = nil
  if tempPosition == ERoleEquipPosition.right_weapon or tempPosition == ERoleEquipPosition.left_weapon then
    self:ChangeWeaponByCell()
  end
  if strIndex == ERoleEquipPosition.wing then
    self.avatar:SetAnimationPrefix("Wing", nil)
  end
end

function RoleEquip:RemoveEquipModel(strIndex)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    local isPet = tonumber(strIndex) and strIndex % 100 == ERoleEquipPosition.pet
    local isFoot = tonumber(strIndex) and strIndex % 100 == ERoleEquipPosition.footPrintIndex
    local isTranscript_weapon = tonumber(strIndex) and strIndex == ERoleEquipPosition.transcript_weapon
    if not isPet and not isFoot and not isTranscript_weapon then
      return
    end
  end
  if IsNil(self.equipPosObj[strIndex]) then
    if strIndex == ERoleEquipPosition.pet then
      self.avatar:DestroyPet()
    end
    return
  end
  self:SetEquipDataRefresh()
  local tempPosition = strIndex
  if RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  if not IsNil(self.equipPosObj[strIndex]) then
    local a = self.equipPosObj[strIndex]
    BuffEffectMgr.ChangeColorByRoleId(self.avatar.data.id, false, strIndex)
    self:RecycleModel(EModelType.Equip, self.equipPosObj[strIndex].name, a)
    self.equipPosObj[strIndex] = nil
    if self.equipLoad[strIndex] then
      self.equipLoad[strIndex]:Destroy()
      self.equipLoad[strIndex] = nil
    end
  end
  if tempPosition == ERoleEquipPosition.right_weapon or tempPosition == ERoleEquipPosition.left_weapon then
    self.BodyAttachment[tempPosition] = nil
  elseif strIndex == ERoleEquipPosition.wing then
    self.wingObj = nil
    self.wingAnimator = nil
  elseif strIndex == ERoleEquipPosition.pet then
    self.avatar:DestroyPet()
  elseif strIndex == ERoleEquipPosition.armband then
    self.ArmbandObj = nil
  elseif strIndex == ERoleEquipPosition.transcript_weapon then
    self.transcriptWeaponObj = nil
  elseif tempPosition == ERoleEquipPosition.cloak then
    self.cloakObj = nil
  elseif tempPosition == ERoleEquipPosition.footPrintIndex then
    self.footPrintObj = nil
  else
    local part = RoleEquipUtility.GetEquipNameByIndex(strIndex)
    if self.BodySkinnedMesh[part] then
      self.BodySkinnedMesh[part] = nil
      self.EffectLightModel[part] = nil
    end
    if RedFortData.InRedFortActivity then
      return
    end
    if strIndex == ERoleEquipPosition.shadow then
      return
    end
    if tempPosition == ERoleEquipPosition.helm then
      if not RoleEquipUtility.IsHaveRelativePositionData(strIndex) then
        strIndex = -1
        self:PutOnEquip(strIndex, self.nudeModelData[strIndex])
      end
    elseif not RoleEquipUtility.IsHaveRelativePositionData(strIndex) then
      self:PutOnEquip(strIndex, self.nudeModelData[tempPosition])
    end
  end
end

function RoleEquip:InitWingAni(go)
  self.wingAnimator = AnimatorCtrl()
  self.wingAnimator:Init(go, true, true)
end

function RoleEquip:SetWingAni(RoleMoveType, isCurIsSafeZone)
  if self.wingAnimator and self.wingAnimator.animator and not IsNil(self.wingAnimator.animator) then
    local speed
    if RoleMoveType == ERoleMoveType.Stand then
      speed = GameInitData.wingWalkSpeed
    else
      speed = isCurIsSafeZone and GameInitData.wingWalkSpeed or GameInitData.wingRunSpeed
    end
    self.wingAnimator:PlayTest("idle")
    self.wingAnimator.animator.speed = speed
  end
end

function RoleEquip:LoadSkinnedMeshModel(part, position, path)
  if string.isNullOrEmpty(path) then
    return
  end
  local parent = self.avatar.model.modelObject.transform
  local paths = string.split(path, "/")
  local nameKey = paths[#paths]
  local obj = PoolManagerTest.Spawn(EModelType.Equip, nameKey)
  self:SetEquipDataRefresh()
  if self.equipLoad[position] then
    self.equipLoad[position]:Destroy()
    self.equipLoad[position] = nil
  end
  if obj then
    self:OnLoadComplete(obj, position, true, part, parent)
  else
    self.positionLoadDic[part] = path
    self.equipLoad[position] = CS.Framework.SkinnedMeshModel(part, parent, function(go, name)
      if not (self.avatar and self.avatar.model) or self.Data.SkinnedEquipModelData[position] ~= path or self.positionLoadDic[part] ~= path then
        self:RecycleModel(EModelType.Equip, nameKey, go)
      else
        self:OnLoadComplete(go, position, true, part, parent)
      end
    end)
    self.equipLoad[position]:LoadAsync(ModelConfig.GetCommentModelPath(position, path))
  end
end

function RoleEquip:LoadAttachmentModel(parent, position, path)
  self:SetEquipDataRefresh()
  local tempPosition = position
  if tonumber(tempPosition) and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  local paths = string.split(path, "/")
  local nameKey = paths[#paths]
  local obj = PoolManagerTest.Spawn(EModelType.Equip, nameKey)
  if self.equipLoad[position] then
    self.equipLoad[position]:Destroy()
    self.equipLoad[position] = nil
  end
  self:SetLoadingModel(tempPosition, nameKey)
  if obj then
    if self:CheckModelIsDestroy(tempPosition, obj) and path ~= "book/Eff_zhaohuan_wuqi_shou" then
      return
    end
    if self.roleWeaponAnimMap[tempPosition] then
      self.roleWeaponAnimMap[tempPosition]:Init(obj, true, true)
    end
    self:OnLoadComplete(obj, position)
    if self.EquipData and self.EquipData:GetEquipByIndex(position) then
      EquipEffectSet:SetModelEffecByIntensify(self.EquipData:GetEquipByIndex(position), obj, self.avatar)
    end
  elseif self.positionLoadDic and parent then
    self.positionLoadDic[parent] = path
    self.equipLoad[position] = CS.Framework.AttachmentModel(parent, function(go, name)
      if not (self.avatar and self.avatar.model) or self.Data.AttachmentEquipModelData[position] and self.Data.AttachmentEquipModelData[position] ~= path or self.avatar.data and self.avatar.data.model == ERoleModelName.datianshibianshen and position == ERoleEquipPosition.wing or self.positionLoadDic[parent] == nil or parent == nil and true or parent.gameObject.activeInHierarchy == false then
        self:RecycleModel(EModelType.Equip, nameKey, go)
      else
        if self:CheckModelIsDestroy(tempPosition, go) then
          return
        end
        if self.roleWeaponAnimMap[tempPosition] then
          self.roleWeaponAnimMap[tempPosition]:Init(go, true, true)
        end
        self:OnLoadComplete(go, position)
        if self.EquipData and self.EquipData:GetEquipByIndex(position) then
          EquipEffectSet:SetModelEffecByIntensify(self.EquipData:GetEquipByIndex(position), go, self.avatar)
        end
      end
    end)
    self.equipLoad[position]:LoadAsync(ModelConfig.GetCommentModelPath(position, path))
  end
end

function RoleEquip:OnLoadComplete(go, position, isSkinMesh, part, parent)
  local tempPosition = position
  if tonumber(tempPosition) and tonumber(tempPosition) > 0 and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  self:SetEquipDataRefresh()
  self.equipPosObj[position] = go
  if self.avatar.graphicQuality ~= nil then
    local quality = go:GetComponent(typeof(CS.ModelGraphicQuality))
    if quality ~= nil then
      quality:SetQuality(self.avatar.graphicQuality - 1)
    end
  end
  local goTransform = go.transform
  if isSkinMesh then
    self.BodySkinnedMesh[part] = go
    goTransform:SetParent(parent, false)
    go:SetLayer(self.layer)
    CS.Framework.SkinnedMeshModel.ChangeSkinnedBones(goTransform, parent)
    if part == "shadow" then
      local skinned = goTransform:GetComponentInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
      skinned.rootBone = parent
    end
    local dataItem = self.EquipData:GetEquipByIndex(position)
    if dataItem then
      EquipEffectSet:SetModelEffecByIntensify(dataItem, go, self.avatar)
      self.EffectLightModel[part] = go
    else
      EquipEffectSet:SetModelEffecByIntensify(dataItem, go, self.avatar)
    end
  end
  BuffEffectMgr.ChangeColorByRoleId(self.avatar.data.id, true, position)
  if self.roleEquipOutEffect ~= nil and self.OutEffectParentDic ~= nil then
    local parList = self.OutEffectParentDic[tempPosition]
    self.roleEquipOutEffect:LoadEffect(go, self.EquipData:GetEquipByIndex(position), parList, self.layer)
  end
  if isSkinMesh then
    return
  end
  local dataItem = self.EquipData:GetEquipByIndex(position)
  if dataItem then
    EquipEffectSet:SetModelEffecByIntensify(dataItem, go, self.avatar)
  end
  if tempPosition == ERoleEquipPosition.right_weapon or tempPosition == ERoleEquipPosition.left_weapon then
    self.BodyAttachment[tempPosition] = go
    self:ChangeWeaponByCell()
  elseif position == ERoleEquipPosition.wing then
    self.wingObj = go
    goTransform:SetParent(self.avatar.RoleWingSpineParent, false)
    self.avatar:SetAnimationPrefix("Wing", not self.avatar:IsCurSafeZone(nil) and "Wing" or nil)
    self:InitWingAni(go)
    self.wingObj:SetLayer(self.layer)
    self:ChangeWeaponByCell()
    self:SetEquipWingShowOrHide(GameSettingsController.ShouldShowEquipModel(position, self.avatar))
  elseif position == ERoleEquipPosition.armband then
    self.ArmbandObj = go
    goTransform:SetParent(self.avatar.RoleArmbandParent, false)
    local texture = Texture2D(8, 8)
    local num = 0
    for i = 1, 8 do
      for j = 1, 8 do
        num = num + 1
        texture:SetPixel(i - 1, j - 1, WarAllianceData.MyArmbandColorData[num])
      end
    end
    num = 0
    texture:Apply()
    local m = MaterialUtility.GetDiffuseUnLitMat()
    if m ~= nil then
      m:SetTexture("_MainTex", texture)
      local skinned = goTransform:GetComponentInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
      local mater = {m}
      skinned.materials = mater
    end
  elseif position == ERoleEquipPosition.transcript_weapon then
    self.BodyAttachment[position] = go
    self:SetWeaponParent(true)
    self.transcriptWeaponObj = go
    goTransform:SetParent(self.avatar.RoleWeaponRSpineParent, false)
  elseif position == ERoleEquipPosition.shadow then
    self:SetEquipShowOrHideByIndex(position, GameSettingsController.ShouldShowEquipModel(position, self.avatar))
  elseif tempPosition == ERoleEquipPosition.cloak then
    self.cloakObj = go
    goTransform:SetParent(self.avatar.RoleCloakParent, false)
    self.cloakObj:SetLayer(self.layer)
    self:ChangeWeaponByCell()
  elseif tempPosition == ERoleEquipPosition.footPrintIndex then
    self.footPrintObj = go
    goTransform:SetParent(self.avatar.model.transform, false)
    self.footPrintObj:SetLayer(self.layer)
    if self.avatar and self.avatar.CloakingState then
      self.footPrintObj:SetActive(false)
    end
  end
end

function RoleEquip:ChangeWeaponByCell()
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  self:SetEquipDataRefresh()
  if not self.EquipData then
    return
  end
  local EquipData = self.EquipData.Data
  local animationName, wing, cloak
  local normalCell = self.avatar.cellPos
  local left_weapon, right_weapon = ERoleEquipPosition.left_weapon, ERoleEquipPosition.right_weapon
  if SceneData.mapId ~= 1019001 then
    local bagIndexTab = RoleEquipUtility.DefaultShowAppearEquip(self.avatar.data.id, self.EquipData.Data)
    for i = 1, #bagIndexTab do
      if bagIndexTab[i] % 100 == 5 then
        left_weapon = bagIndexTab[i]
      elseif bagIndexTab[i] % 100 == 4 then
        right_weapon = bagIndexTab[i]
      end
    end
  end
  if self.avatar:IsCurSafeZone(normalCell) then
    animationName = nil
    self:ChangeWeaponAnim("none")
    self:SetWeaponParent(true)
    if self.Data.AttachmentEquipModelData[ERoleEquipPosition.wing] then
      wing = nil
      self:SetWingAni(self.RoleMoveType, not wing)
    end
  else
    self:ChangeWeaponAnim("idle")
    self:SetWeaponParent(false)
    local equipData = EquipData[left_weapon]
    local equipDataShield = EquipData[right_weapon]
    if equipData and equipDataShield then
      if equipDataShield.tblItem.subType == EItemSubtype.Shield or equipDataShield.tblItem.subType == EItemSubtype.mShield or equipDataShield.tblItem.subType == EItemSubtype.RedShield or equipDataShield.tblItem.subType == EItemSubtype.RedmShield or equipDataShield.tblItem.subType == EItemSubtype.Suit_Shield then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.Shield)
      elseif equipDataShield.tblItem.subType == EItemSubtype.Suit_CrossBow then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.CrossBow)
      elseif equipDataShield.tblItem.subType == EItemSubtype.RedArch or equipDataShield.tblItem.subType == EItemSubtype.Couture_Arch or equipDataShield.tblItem.subType == EItemSubtype.Suit_Arch then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.Arch)
      else
        animationName = RoleEquipUtility.GetWeaponSubtype(equipDataShield.tblItem.subType)
      end
      if animationName == nil then
        animationName = "Dweapon"
      end
    elseif equipData then
      if equipData.tblItem.subType == EItemSubtype.Suit_OneHandedSword_Other then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.OneHandedSword)
      else
        animationName = RoleEquipUtility.GetWeaponSubtype(equipData.tblItem.subType)
      end
    elseif equipDataShield then
      if equipDataShield.tblItem.subType == EItemSubtype.HongZhuang_OneHandedSword or equipDataShield.tblItem.subType == EItemSubtype.Suit_OneHandedSword or equipDataShield.tblItem.subType == EItemSubtype.Couture_OneHandedSword then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.OneHandedSword)
      elseif equipDataShield.tblItem.subType == EItemSubtype.RedOneHandedStick or equipDataShield.tblItem.subType == EItemSubtype.Suit_OneHandedStick then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.OneHandedStick)
      elseif equipDataShield.tblItem.subType == EItemSubtype.RedArch or equipDataShield.tblItem.subType == EItemSubtype.Couture_Arch or equipDataShield.tblItem.subType == EItemSubtype.Suit_Arch then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.Arch)
      elseif equipDataShield.tblItem.subType == EItemSubtype.Suit_CrossBow or equipDataShield.tblItem.subType == EItemSubtype.Couture_CrossBow then
        animationName = RoleEquipUtility.GetWeaponSubtype(EItemSubtype.CrossBow)
      else
        animationName = RoleEquipUtility.GetWeaponSubtype(equipDataShield.tblItem.subType)
      end
    end
    if self.Data.AttachmentEquipModelData[ERoleEquipPosition.wing] then
      wing = "Wing"
      self:SetWingAni(self.RoleMoveType, not wing)
    end
  end
  self.avatar:SetAnimationPrefix("Weapon", animationName)
  self.avatar:SetAnimationPrefix("Wing", wing)
end

function RoleEquip:ChangeWeaponAnim(name)
  for i, v in pairs(self.roleWeaponAnimMap) do
    v:Play(name)
  end
end

function RoleEquip:GetAttackWeaponData(tempPosition)
  if ForgeData.appearData[self.avatar.data.id] and ForgeData.appearData[self.avatar.data.id] then
    local tempTab = json.decode(ForgeData.appearData[self.avatar.data.id])
    if tempTab then
      for i, v in pairs(tempTab) do
        if v % 100 == tempPosition then
          return self.EquipData:GetEquipByIndex(v)
        end
      end
    end
  end
  return self.EquipData:GetEquipByIndex(tempPosition)
end

local weaponPos = Vector3.zero
local weaponRota = Vector3.zero

function RoleEquip:SetWeaponParent(IssafeZone)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  self:SetEquipDataRefresh()
  local weapon = self:GetRoleWeapon()
  if weapon == nil or table.count(weapon) <= 0 then
    return
  end
  if not self.avatar.model:GetModelObject() then
    return
  end
  local RoleWeaponLSpineParent = self.avatar.RoleWeaponLSpineParent
  IssafeZone = IssafeZone or self.avatar:IsSwimState()
  for k, v in pairs(weapon) do
    if v ~= nil then
      local parentTrans
      local curEquipData = self:GetAttackWeaponData(k)
      if curEquipData == nil then
        return
      end
      local normalSubType = curEquipData.tblItem.subType
      if normalSubType == EItemSubtype.mShield then
        normalSubType = EItemSubtype.Shield
      end
      if normalSubType == EItemSubtype.RedmShield then
        normalSubType = EItemSubtype.Shield
      end
      local CouturSubtypeDic = ClientTable.cfg_Global_globalManager:GetCouturSubtypeDic()
      if CouturSubtypeDic ~= nil and CouturSubtypeDic[normalSubType] ~= nil then
        normalSubType = CouturSubtypeDic[normalSubType]
      end
      if IssafeZone then
        if RoleEquipUtility.equipObj2BodyPos[normalSubType] == nil then
          logError(curEquipData.tblItem.id, curEquipData.tblItem.name, normalSubType)
        end
        local posbodyvec = RoleEquipUtility.equipObj2BodyPos[normalSubType].posbody
        local rotabodyvec = RoleEquipUtility.equipObj2BodyPos[normalSubType].rotabody
        weaponPos:Set(posbodyvec.x, posbodyvec.y, posbodyvec.z)
        weaponRota:Set(rotabodyvec.x, rotabodyvec.y, rotabodyvec.z)
        if k == ERoleEquipPosition.left_weapon and (normalSubType == EItemSubtype.OneHandedSword or normalSubType == EItemSubtype.OneHandedAxe or normalSubType == EItemSubtype.HongZhuang_OneHandedSword or normalSubType == EItemSubtype.Suit_OneHandedSword or normalSubType == EItemSubtype.Suit_OneHandedSword_Other) then
          weaponRota.z = weaponRota.z + 180
        end
        if normalSubType == EItemSubtype.Shield or normalSubType == EItemSubtype.RedShield or normalSubType == EItemSubtype.Suit_Shield then
          parentTrans = self.avatar.RoleShieldspineParent
        elseif normalSubType == EItemSubtype.SummonerRightHandAtk or normalSubType == EItemSubtype.SummonerRightHandDef or normalSubType == EItemSubtype.SummonerRightHandAtk_Red or normalSubType == EItemSubtype.SummonerRightHandDef_Red then
          parentTrans = self.RoleWeaponParentMap[k]
        else
          parentTrans = self.RoleSpineParentMap[k]
        end
      else
        if k == ERoleEquipPosition.transcript_weapon then
          return
        end
        local posbodyvec = RoleEquipUtility.equipObj2BodyPos[normalSubType].pos
        local rotabodyvec = RoleEquipUtility.equipObj2BodyPos[normalSubType].rota
        weaponPos:Set(posbodyvec.x, posbodyvec.y, posbodyvec.z)
        weaponRota:Set(rotabodyvec.x, rotabodyvec.y, rotabodyvec.z)
        if k == ERoleEquipPosition.left_weapon and (normalSubType == EItemSubtype.OneHandedSword or normalSubType == EItemSubtype.OneHandedAxe or normalSubType == EItemSubtype.HongZhuang_OneHandedSword or normalSubType == EItemSubtype.Suit_OneHandedSword or normalSubType == EItemSubtype.Suit_OneHandedSword_Other) then
          weaponRota.x = weaponRota.x + 180
        end
        if normalSubType == EItemSubtype.BowBag or normalSubType == EItemSubtype.CrossBowBag or normalSubType == EItemSubtype.RedBowBag or normalSubType == EItemSubtype.Suit_CrossBowBag or normalSubType == EItemSubtype.Suit_BowBag then
          parentTrans = RoleWeaponLSpineParent
        elseif normalSubType == EItemSubtype.Arch or normalSubType == EItemSubtype.RedArch or normalSubType == EItemSubtype.Suit_Arch then
          parentTrans = self.RoleWeaponParentMap[ERoleEquipPosition.left_weapon]
        else
          parentTrans = self.RoleWeaponParentMap[k]
        end
      end
      if string.contains(curEquipData.tblItem.model, "Staff11") and not IssafeZone then
        weaponRota.x = 180
      end
      if k == ERoleEquipPosition.left_weapon and (normalSubType == EItemSubtype.OneHandedStick or normalSubType == EItemSubtype.RedOneHandedStick or normalSubType == EItemSubtype.Suit_OneHandedStick) then
        weaponRota.x = 180
      end
      local vTransform = v.transform
      vTransform:SetParent(parentTrans, false)
      vTransform:SetLocalEulerAngles(weaponRota.x, weaponRota.y, weaponRota.z)
      vTransform:SetLocalPosition(weaponPos.x, weaponPos.y, weaponPos.z)
      v:SetLayer(self.layer)
    end
  end
end

function RoleEquip:GetRoleWeapon()
  return self.BodyAttachment
end

function RoleEquip:FindAttachment(parent)
  local Equip_Item = self.avatar.model:FindAttachment(parent)
  return Equip_Item
end

function RoleEquip:Destroy()
  if self.avatar.isShowEffect and not self.avatar.isMe then
    self.avatar.isShowEffect = false
    showRoleEffectCount = showRoleEffectCount - 1
    if showRoleEffectCount < 0 then
      showRoleEffectCount = 0
    end
  end
  self:DestroyAllObjAddPool()
  self:ResetSkeletonEffect()
  self.Data = {
    SkinnedEquipModelData = {},
    AttachmentEquipModelData = {}
  }
  if self.roleEquipOutEffect ~= nil then
    self.roleEquipOutEffect:DestroyAll()
  end
end

function RoleEquip:DestroyAllObjAddPool()
  for i, v in pairs(self.equipPosObj) do
    if not IsNil(v) then
      self:RecycleModel(EModelType.Equip, v.name, v)
      self.equipPosObj[i] = nil
      if self.equipLoad[i] then
        self.equipLoad[i]:Destroy()
        self.equipLoad[i] = nil
      end
    end
  end
  for k, v in pairs(self.BodyAttachment) do
    self.BodyAttachment[k] = nil
  end
  for k, v in pairs(self.BodySkinnedMesh) do
    self.BodySkinnedMesh[k] = nil
  end
  if self.wingObj then
    self.wingObj = nil
  end
  if self.ArmbandObj then
    self.ArmbandObj = nil
  end
  if self.roleEquipOutEffect ~= nil then
    self.roleEquipOutEffect:DestroyAll()
  end
  if self.cloakObj then
    self.cloakObj = nil
  end
  if self.capeDisplayObj then
    self._capeLoadCookie = nil
    CS.Framework.ObjectEx.Destroy(self.capeDisplayObj)
    self.capeDisplayObj = nil
  end
  if self.footPrintObj then
    self.footPrintObj = nil
  end
end

local function LoadOtherSuitEffect(self, state, name, parent, func, parm)
  local modelPath = string.format("Effect/Scene/%s.prefab", name)
  self[name] = CS.Framework.ResourceManager.InstantiateAsync(modelPath, self.avatar.model.transform, false)
  Coroutine.Yield(self[name])
  if not self[name] or self[name].isError then
    Coroutine.Break()
  end
  self[name] = self[name].gameObject
  self[name].name = name
  self[name]:SetActive(state)
end

local function SetSuitEffectState(self, state, name, parent, func)
  self[name] = self.avatar.model.transform:Find(name)
  if self[name] then
    if not self[name].name then
      return
    end
    self[name].gameObject:SetActive(state)
  elseif state then
    Coroutine.Start(LoadOtherSuitEffect, self, state, name, parent, func)
  end
end

local TentaclePrefabNameBylevel = {}
TentaclePrefabNameBylevel[30] = "taozhuang_liudong"
TentaclePrefabNameBylevel[81] = "taozhuang_liudong_02"
TentaclePrefabNameBylevel[153] = "taozhuang_liudong_03"
TentaclePrefabNameBylevel[369] = "taozhuang_liudong_04"
local CirclePrefabNameBylevel = {}
CirclePrefabNameBylevel[45] = "Eff_zhuangbei_tuowei01"
CirclePrefabNameBylevel[60] = "Eff_taozhuang_siseguangquan"
CirclePrefabNameBylevel[297] = "taozhuang_quan02"
local LiziPrefabNameBylevel = {}
LiziPrefabNameBylevel[441] = "_lizi_bai"
LiziPrefabNameBylevel[513] = "_lizi_bai02"
LiziPrefabNameBylevel[585] = "_lizi_jin"
LiziPrefabNameBylevel[657] = "_lizi_jin02"
LiziPrefabNameBylevel[729] = "_fuwen_bai"
LiziPrefabNameBylevel[801] = "_fuwen_jin"

local function NormalEquip(self, data, state, changeType)
  if changeType then
    if data.intensify < 30 then
      state = false
    else
      state = true
    end
  elseif data.intensify < 30 then
    return
  end
  local opreateData = self.TentacleAvatarMap[data.tblItem.subType]
  if not opreateData then
    return
  end
  local tentacleName = TentaclePrefabNameBylevel[30]
  for i = data.intensify, 30, -1 do
    tentacleName = TentaclePrefabNameBylevel[i]
    if tentacleName then
      break
    end
  end
  local circleName = ""
  if data.tblItem.subType == 14 then
    for i = data.intensify, 45, -1 do
      circleName = CirclePrefabNameBylevel[i]
      if circleName then
        break
      end
    end
  end
  local liziName = ""
  for i = data.intensify, 441, -1 do
    liziName = LiziPrefabNameBylevel[i]
    if liziName then
      break
    end
  end
  for i = 1, #opreateData do
    local item = opreateData[i]
    item.EffectName = tentacleName
    item.LEffectName = liziName
    if i == 3 then
      item.CEffectName = circleName
      item.EffectName = ""
      item.LEffectName = ""
    end
    if item.AngelState then
      state = false
    end
    self:TentacleActive(item, false, 1)
    self:TentacleActive(item, state, 1)
  end
end

local function AngelSuitEquip(self, data, state, name)
  local opreateData = self.AngelSuitParticle[data.tblItem.subType]
  if not opreateData then
    return
  end
  local item
  local normalEquip = self.TentacleAvatarMap[data.tblItem.subType]
  if state then
    for i = 1, #normalEquip do
      item = normalEquip[i]
      item.StateSign = false
      item.AngelState = true
      self:TentacleActive(item, false, 1)
    end
  else
    for i = 1, #normalEquip do
      item = normalEquip[i]
      item.AngelState = false
    end
  end
  for i = 1, #opreateData do
    item = opreateData[i]
    item.EffectName = name
    self:TentacleActive(item, state, 2)
  end
end

local function LoadTentaclePrefab(data, pool, completeCallback)
  local nameStr = data.EffectName
  local assetsStr = string.format("Effect/Scene/%s.prefab", nameStr)
  data.loading = CS.Framework.ResourceManager.InstantiateAsync(assetsStr)
  Coroutine.Yield(data.loading)
  if not data.loading or data.loading.isError then
    Coroutine.Break()
  end
  data.loading = data.loading.gameObject
  if not data.loading then
    return
  end
  table.insert(pool, data.loading)
  if completeCallback then
    completeCallback(data.loading.gameObject, data)
  end
  data.loading = nil
end

local function LoadTentacle2Prefab(data, type, pool, completeCallback)
  local nameStr = data.EffectName
  if type == 2 then
    nameStr = data.CEffectName
  elseif type == 3 then
    nameStr = data.FLEffectName .. data.LEffectName
  end
  local assetsStr = string.format("Effect/Scene/%s.prefab", nameStr)
  if data.loading == nil then
    data.loading = {}
  end
  if data.loading[type] ~= nil then
    return
  end
  data.loading[type] = CS.Framework.ResourceManager.InstantiateAsync(assetsStr)
  Coroutine.Yield(data.loading[type])
  if not data.loading[type] or data.loading[type].isError then
    Coroutine.Break()
  end
  data.loading[type] = data.loading[type].gameObject
  if not data.loading[type] then
    return
  end
  table.insert(pool, data.loading[type])
  if completeCallback then
    completeCallback(data.loading[type].gameObject, data)
  end
  data.loading[type] = nil
end

local TentacleEffectPool = {}

local function TentacleLoadComplete(obj, data)
  local objTransform = obj.transform
  if not data.StateSign then
    objTransform:SetParent(PoolManagerTest.root)
  else
    objTransform:SetParent(data.parentObj)
    objTransform.localPosition = data.pos
    objTransform.localRotation = data.rotation
    objTransform.localScale = data.scale
    local childTrans = objTransform:GetComponentsInChildren(typeof(UnityEngineLua.Transform))
    for i = 0, childTrans.Length - 1 do
      childTrans[i].gameObject.layer = data.parentObj.gameObject.layer
    end
  end
  obj:SetActive(data.StateSign)
end

local function RecycleTentacle(obj)
  obj:SetActive(false)
  obj.transform:SetParent(PoolManagerTest.root)
end

local function SetTentacleEffect(data, type, id)
  local nameStr = data.EffectName
  if type == 2 then
    nameStr = data.CEffectName
  elseif type == 3 then
    nameStr = data.FLEffectName .. data.LEffectName
  end
  if not TentacleEffectPool[nameStr .. data.parent .. id] then
    TentacleEffectPool[nameStr .. data.parent .. id] = {}
  end
  local itemPool = TentacleEffectPool[nameStr .. data.parent .. id]
  local obj
  for i = 1, #itemPool do
    if not IsNil(itemPool[i]) then
      obj = itemPool[i]
      break
    end
  end
  if not obj then
    Coroutine.Start(LoadTentacle2Prefab, data, type, itemPool, TentacleLoadComplete)
    return
  end
  TentacleLoadComplete(obj, data)
end

local function SuitEffectComplete(obj, data)
  local objTransform = obj.transform
  objTransform:SetParent(data.parent)
  obj:SetActive(data.state)
  if not data.state then
    obj.transform:SetParent(PoolManagerTest.root)
    data.object = nil
    data.objectEffect = nil
  else
    data.object = obj
    data.objectEffect = obj
    objTransform:SetLocalPosition(0, 0, 0)
    objTransform:SetLocalEulerAngles(0, 0, 0)
    objTransform:SetLocalScale(1)
    objTransform.gameObject.name = "zhuangbei_glow"
    objTransform.gameObject:SetActive(true)
    local mainModul = objTransform:GetComponentInChildren(typeof(UnityEngineLua.ParticleSystem)).main
    local startColor = mainModul.startColor
    startColor.color = data.infor.lightColor
    mainModul.startColor = startColor
  end
end

local function SuitIntensifyEffectComplete(obj, data)
  local objTransform = obj.transform
  objTransform:SetParent(data.parent)
  obj:SetActive(data.state)
  if not data.state then
    obj.transform:SetParent(PoolManagerTest.root)
    data.object = nil
    data.objectEffect = nil
  else
    data.object = obj
    data.objectEffect = obj
    objTransform:SetLocalPosition(0, 0, 0)
    objTransform:SetLocalEulerAngles(0, 0, 0)
    objTransform:SetLocalScale(1)
    objTransform.gameObject.name = data.EffectName
    objTransform.gameObject:SetActive(true)
  end
end

local function SetSuitEffect(data, completeCallback)
  if data == nil then
    return
  end
  if not data.state and data.objectEffect and data.object.name then
    RecycleTentacle(data.objectEffect)
    data.objectEffect = nil
    data.object = nil
    return
  end
  if not TentacleEffectPool[data.EffectName] then
    TentacleEffectPool[data.EffectName] = {}
  end
  local itemPool = TentacleEffectPool[data.EffectName]
  local obj
  for i = 1, #itemPool do
    if not IsNil(itemPool[i]) and not itemPool[i].activeSelf then
      obj = itemPool[i]
      break
    end
  end
  if not obj then
    data.object = Coroutine.Start(LoadTentaclePrefab, data, itemPool, completeCallback)
    return
  end
  if completeCallback then
    completeCallback(obj, data)
  end
end

function RoleEquip:EquipSuitCheck()
  self:SetEquipDataRefresh()
  if not self.avatar.RoleArmbandParent then
    return
  end
  if not self.suitInfor then
    self.suitInfor = {}
  end
  local suitEffectInfor = EquipEffectSet:SuitCompletenessCheck(self.EquipData.Data, self.suitInfor)
  if not self.avatar.model then
    return
  end
  if suitEffectInfor then
    if not self.suitEffect then
      self.suitEffect = {
        EffectName = "zhuangbei_glow",
        parent = self.avatar.RoleAvatarSpine1,
        state = true,
        infor = suitEffectInfor
      }
      SetSuitEffect(self.suitEffect, SuitEffectComplete)
    elseif not self.suitEffect.object then
      self.suitEffect.state = true
      self.suitEffect.infor = suitEffectInfor
      SetSuitEffect(self.suitEffect, SuitEffectComplete)
    end
  elseif self.suitEffect and self.suitEffect.object then
    self.suitEffect.state = false
    SetSuitEffect(self.suitEffect, SuitEffectComplete)
  end
  if self.suitInfor.equipCount == 5 then
    local effName = ""
    for i = #self.clothesSuitEffectInfo, 1, -1 do
      local item = self.clothesSuitEffectInfo[i]
      if self.suitInfor.minLevel >= item.level then
        effName = item.EffectName
        break
      end
    end
    if not string.isNullOrEmpty(effName) then
      if not self.suitIntensify then
        self.suitIntensify = {
          EffectName = effName,
          parent = self.avatar.RoleAvatarSpine1,
          state = true
        }
        SetSuitEffect(self.suitIntensify, SuitIntensifyEffectComplete)
      else
        if self.suitIntensify.object and self.suitIntensify.object.name and self.suitIntensify.name ~= effName then
          self.suitIntensify.state = false
          SetSuitEffect(self.suitIntensify, SuitIntensifyEffectComplete)
        end
        if not self.suitIntensify.object then
          self.suitIntensify.EffectName = effName
          self.suitIntensify.state = true
          SetSuitEffect(self.suitIntensify, SuitIntensifyEffectComplete)
        end
      end
    elseif self.suitIntensify then
      self.suitIntensify.state = false
      SetSuitEffect(self.suitIntensify, SuitIntensifyEffectComplete)
    end
  elseif self.suitIntensify then
    self.suitIntensify.state = false
    SetSuitEffect(self.suitIntensify, SuitIntensifyEffectComplete)
  end
end

local tempAvatarData = {}

function RoleEquip:CurrentPutOnEquipSet(avatarData)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  local appearItemData
  local appearsData = {}
  for i = 1, #EquipEffectSet.SuitIndex do
    appearItemData = RoleEquipUtility.GetCurEquipShowData(ForgeData.appearData[self.avatar.id], avatarData, EquipEffectSet.SuitIndex[i])
    if appearItemData then
      table.insert(appearsData, appearItemData)
    end
  end
  for k, v in pairs(appearsData) do
    tempAvatarData[v] = true
  end
  for i = #self.CurrentPutOnEquipData, 1, -1 do
    local data = self.CurrentPutOnEquipData[i]
    if tempAvatarData[data] then
      tempAvatarData[data] = nil
    else
      self:SetTentacle(data, false)
      table.remove(self.CurrentPutOnEquipData, i)
    end
  end
  for k, v in pairs(tempAvatarData) do
    table.insert(self.CurrentPutOnEquipData, k)
    tempAvatarData[k] = nil
  end
  for k, v in pairs(appearsData) do
    self:SetTentacle(v, true, true)
  end
  self:EquipSuitCheck()
end

function RoleEquip:SetMoreLevelSweepLight()
  if self.DucshaderCS then
    self.DucshaderCS.rotate = false
  end
end

function RoleEquip:IntensifyChangeSetTentacle(equipItem)
  self:SetEquipDataRefresh()
  local item = self.EquipData[equipItem.bagGridIndex]
  if item then
    for i = 1, #EquipEffectSet.SuitIndex do
      if item == self.EquipData[EquipEffectSet.SuitIndex[i]] then
        self:SetTentacle(item, true, true)
      end
    end
  end
end

function RoleEquip:SetTentacle(data, state, changeType)
  local effecName = EquipEffectSet.AngelSuitEffecData[data.tblItem.id]
  if effecName then
    AngelSuitEquip(self, data, state, effecName)
  else
    NormalEquip(self, data, state, changeType)
  end
end

function RoleEquip:TentacleActive(data, state, equipType)
  if type(data.parent) == "string" then
    data.parentObj = self.avatar[data.parent]
  end
  if not data.parentObj then
    return
  end
  if string.isNullOrEmpty(data.EffectName) and string.isNullOrEmpty(data.CEffectName) then
    return
  end
  if state then
    if (showRoleEffectCount < RoleEquipConstantConfig.MaxShowEffectRoleCount or self.avatar.isMe) and (not data.loading or data.loading and (not (data.loading[1] and data.loading[2]) or not data.loading[3])) then
      data.StateSign = true
      if not data.loading or data.loading and not data.loading[1] then
        SetTentacleEffect(data, 1, self.avatar.id)
      end
      if not string.isNullOrEmpty(data.CEffectName) and (not data.loading or data.loading and not data.loading[2]) then
        SetTentacleEffect(data, 2, self.avatar.id)
      end
      if not string.isNullOrEmpty(data.LEffectName) and (not data.loading or data.loading and not data.loading[3]) then
        SetTentacleEffect(data, 3, self.avatar.id)
      end
      if not self.avatar.isShowEffect then
        self.avatar.isShowEffect = true
        showRoleEffectCount = showRoleEffectCount + 1
      end
    end
  elseif data.parentObj.RecycleContainsByName then
    if equipType and equipType == 1 then
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.TaoZhuangStrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.LiziStrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.FuWentrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.CircleStrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.Circle2StrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.Circle3StrID)
    end
    if equipType and equipType == 2 then
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.DaTianShiStrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.ShengDan)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.LiziStrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.FuWentrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.CircleStrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.Circle2StrID)
      data.parentObj:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.Circle3StrID)
    end
  else
    local effectObjs = {}
    for i = 0, data.parentObj.childCount - 1 do
      local child = data.parentObj:GetChild(i)
      local childname = child.name
      if string.contains(childname, "taozhuang_liudong") or string.contains(childname, "datianshi") or string.contains(childname, "Eff_zhuangbei_tuowei01") or string.contains(childname, "Eff_taozhuang_siseguangquan") or string.contains(childname, "taozhuang_quan02") or string.contains(childname, "_lizi_") or string.contains(childname, "_fuwen_") then
        table.insert(effectObjs, child)
      end
    end
    for i = 1, #effectObjs do
      RecycleTentacle(effectObjs[i].gameObject)
    end
  end
end

function RoleEquip:InitTentacleParent()
  self.TentacleAvatarMap = {}
  self.TentacleAvatarMap[13] = {
    {
      parentObj = nil,
      parent = "RoleAvatarHead",
      pos = Vector3(-0.6980605, 0.4624226, -4.364466E-5),
      rotation = Quaternion.Euler(0, -180, -160),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_HelmMale"
    }
  }
  self.TentacleAvatarMap[14] = {
    {
      parentObj = nil,
      parent = "RoleAvatarLeftUpperArm",
      pos = Vector3(-0.494, -0.409, 0.271),
      rotation = Quaternion.Euler(29.144, 95.60101, -9.104),
      scale = Vector3(3.545757, 2.374222, 2.023622),
      instantiateRequest = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_ArmorMale"
    },
    {
      parentObj = nil,
      parent = "RoleAvatarRightUpperArm",
      pos = Vector3(-0.5976771, -0.4738752, -0.3188729),
      rotation = Quaternion.Euler(-36.219, -101.453, -14.393),
      scale = Vector3(3.545757, 2.374222, 2.023622),
      instantiateRequest = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_ArmorMale"
    },
    {
      parentObj = nil,
      parent = "RoleAvatarSpine1",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = "",
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_ArmorMale"
    }
  }
  self.TentacleAvatarMap[15] = {
    {
      parentObj = nil,
      parent = "RoleAvatarLeftCalf",
      pos = Vector3(0.396, 0.028, -0.255),
      rotation = Quaternion.Euler(0, 90, 147.8),
      scale = Vector3(3, 2, 2),
      instantiateRequest = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_PantMale"
    },
    {
      parentObj = nil,
      parent = "RoleAvatarRightCalf",
      pos = Vector3(0.473, -0.059, 0.314),
      rotation = Quaternion.Euler(-16.698, -97.007, 156.328),
      scale = Vector3(3, 2, 2),
      instantiateRequest = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_PantMale"
    }
  }
  self.TentacleAvatarMap[16] = {
    {
      parentObj = nil,
      parent = "RoleAvatarLeftForearm",
      pos = Vector3(-1.022, 0.196, 0.558),
      rotation = Quaternion.Euler(117.985, -187.419, -301.116),
      scale = Vector3(3.5, 3, 3),
      instantiateRequest = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_GloveMale"
    },
    {
      parentObj = nil,
      parent = "RoleAvatarRightForearm",
      pos = Vector3(-1.11, 0.14, -0.51),
      rotation = Quaternion.Euler(-90, 135.421, -240.133),
      scale = Vector3(3.5, 3, 3),
      instantiateRequest = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_GloveMale"
    }
  }
  self.TentacleAvatarMap[17] = {
    {
      parentObj = nil,
      parent = "RoleAvatarLeftCalf",
      pos = Vector3(0.437, 0.472, -0.111),
      rotation = Quaternion.Euler(-123.28, -105.554, 11.58199),
      scale = Vector3(3.5, 2, 2.5),
      gameObject = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_BootMale"
    },
    {
      parentObj = nil,
      parent = "RoleAvatarRightCalf",
      pos = Vector3(0.455, 0.667, 0.067),
      rotation = Quaternion.Euler(-235.811, -245.204, 23.60199),
      scale = Vector3(3.5, 2, 2.5),
      gameObject = nil,
      StateSign = false,
      EffectName = TentaclePrefabNameBylevel[30],
      CEffectName = "",
      LEffectName = "",
      FLEffectName = "Eff_BootMale"
    }
  }
  self.AngelSuitParticle = {}
  self.AngelSuitParticle[13] = {
    {
      parentObj = nil,
      parent = "RoleAvatarHead",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = ""
    }
  }
  self.AngelSuitParticle[16] = {
    {
      parentObj = nil,
      parent = "RoleAvatarLeftForearm",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = ""
    },
    {
      parentObj = nil,
      parent = "RoleAvatarRightForearm",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = ""
    }
  }
  self.AngelSuitParticle[15] = {
    {
      parentObj = nil,
      parent = "RoleAvatarRoot",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = ""
    }
  }
  self.AngelSuitParticle[14] = {
    {
      parentObj = nil,
      parent = "RoleAvatarSpine1",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = ""
    }
  }
  self.AngelSuitParticle[17] = {
    {
      parentObj = nil,
      parent = "RoleAvatarLeftCalf",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = ""
    },
    {
      parentObj = nil,
      parent = "RoleAvatarRightCalf",
      pos = Vector3(0, 0, 0),
      rotation = Quaternion.Euler(0, 0, 0),
      scale = Vector3.one,
      instantiateRequest = nil,
      StateSign = false,
      EffectName = ""
    }
  }
end

function RoleEquip:ResetSkeletonEffect()
  for k, v in pairs(self.TentacleAvatarMap) do
    for i = 1, #v do
      self:TentacleActive(v[i], false, 1)
    end
  end
  for k, v in pairs(self.AngelSuitParticle) do
    for i = 1, #v do
      self:TentacleActive(v[i], false, 2)
    end
  end
  if self.suitEffect and self.suitEffect.object then
    self.suitEffect.state = false
    SetSuitEffect(self.suitEffect)
  end
  if self.suitIntensify then
    self.suitIntensify.state = false
    SetSuitEffect(self.suitIntensify, SuitIntensifyEffectComplete)
  end
end

function RoleEquip:GetEquipeGoByIndedx(equipeIndex)
  return self.BodyAttachment[equipeIndex]
end

function RoleEquip:SetEquipEffect(data)
  if self.equipPosObj[data.bagGridIndex] then
    EquipEffectSet:SetModelEffecByIntensify(data, self.equipPosObj[data.bagGridIndex], self.avatar)
  end
end

function RoleEquip:SetEquipWingShowOrHide(isShow)
  if self.equipPosObj[ERoleEquipPosition.wing] then
    if not isShow then
      self.wingAnimator:PlayTest("none")
    end
    self.equipPosObj[ERoleEquipPosition.wing].gameObject:SetActive(isShow)
    if isShow then
      self:SetWingAni(self.RoleMoveType, self.avatar:IsCurSafeZone())
    end
  end
end

function RoleEquip:SetEquipDataRefresh()
  if SceneData.mapId ~= 1019001 then
    self.EquipData = self.avatar.data.equipsData
  end
end

function RoleEquip:SetEquipShowOrHideByIndex(equipIndex, isShow)
  if self.avatar.playerEquipType == ERoleInitEquipType.snowMan then
    return
  end
  local tempPosition = equipIndex
  if tonumber(tempPosition) and RoleEquipUtility.IsEquipAppearData(tempPosition) then
    tempPosition = tempPosition % 100
  end
  if equipIndex == ERoleEquipPosition.wing then
    self:SetEquipWingShowOrHide(isShow)
  elseif tempPosition == ERoleEquipPosition.right_weapon or tempPosition == ERoleEquipPosition.left_weapon then
    if self.BodyAttachment[tempPosition] then
      if not isShow then
        self.roleWeaponAnimMap[tempPosition]:Play("none")
      end
      self.equipPosObj[ERoleEquipPosition.wing].gameObject:SetActive(isShow)
      if isShow then
        self:ChangeWeaponByCell()
      end
    end
  elseif tempPosition == ERoleEquipPosition.footPrintIndex then
    for i, v in pairs(self.equipPosObj) do
      if i % 100 == ERoleEquipPosition.footPrintIndex then
        v.gameObject:SetActive(isShow)
        break
      end
    end
  elseif self.equipPosObj[equipIndex] then
    self.equipPosObj[equipIndex].gameObject:SetActive(isShow)
  end
end

function RoleEquip:SetLoadingModel(position, path)
  local lastLoadingPath = self.loadingPath[position]
  if lastLoadingPath ~= nil then
    if self.loadedDestroyPath[position] == nil then
      self.loadedDestroyPath[position] = {}
    end
    self.loadedDestroyPath[position][lastLoadingPath] = true
  end
  self.loadingPath[position] = path
end

function RoleEquip:CheckIsDestroyPath(position, path)
  local state = self.loadedDestroyPath[position] ~= nil and self.loadedDestroyPath[position][path]
  if state == true then
    self.loadedDestroyPath[position][path] = nil
  end
  return state == true
end

function RoleEquip:CheckIsLoadingPath(position, path)
  local state = self.loadingPath[position] == path
  if state == true then
    self.loadingPath[position] = nil
  end
  return state
end

function RoleEquip:CheckModelIsDestroy(position, go)
  if self:CheckIsDestroyPath(position, go.name) then
    self:RecycleModel(EModelType.Equip, go.name, go)
    return true
  end
  self:CheckIsLoadingPath(position, go.name)
end

function RoleEquip:CheckAndLoadCapeDisplay()
  local basicCareer = RoleUtility.GetBasicCareer(self.avatar.data.career)
  if basicCareer == ERoleCareer.SpellSword then
    self:UnloadCapeDisplay()
    return
  end
  if SceneData.mapId == 1019001 or TranScriptData.IsInRefineKSBattle() then
    self:UnloadCapeDisplay()
    return
  end
  local configStr = GlobalConfig.GetGlobalConfig(81000001)
  if string.isNullOrEmpty(configStr) then
    self:UnloadCapeDisplay()
    return
  end
  local matchedModelName
  local pos = "0#0#0"
  local rat = "0#0#45"
  local configEntries = string.split(configStr, "&")
  for _, entry in ipairs(configEntries) do
    local parts = string.split(entry, "#")
    if 3 <= #parts then
      local cfgCareer = tonumber(parts[1])
      local cfgEquipPos = parts[2]
      local cfgModelName = parts[3]
      pos = string.split(parts[4], "/")
      rat = string.split(parts[5], "/")
      if cfgCareer == basicCareer then
        local appear = ForgeData.appearData[self.avatar.data.id]
        local appearTbl
        if not string.isNullOrEmpty(appear) then
          appearTbl = json.decode(appear)
        end
        for _, equipData in pairs(appearTbl) do
          if tostring(equipData) == cfgEquipPos then
            matchedModelName = cfgModelName
            break
          end
        end
      end
    end
    if matchedModelName then
      break
    end
  end
  if matchedModelName then
    self:LoadCapeDisplay(matchedModelName, pos, rat)
  else
    self:UnloadCapeDisplay()
  end
end

function RoleEquip:LoadCapeDisplay(modelName, pos, rat)
  local path = string.format("Model/Charactor/PiFeng/%s.prefab", modelName)
  if self.capeDisplayObj and self.capeDisplayObj.name == modelName then
    return
  end
  self:UnloadCapeDisplay()
  local parent = self.avatar.RoleCloakParent
  if not parent then
    return
  end
  local loadCookie = {}
  self._capeLoadCookie = loadCookie
  Coroutine.Start(function()
    local req = CS.Framework.ResourceManager.InstantiateAsync(path, parent, false)
    Coroutine.Yield(req)
    if self._capeLoadCookie ~= loadCookie then
      if req and not req.isError then
        CS.Framework.ObjectEx.Destroy(req.gameObject)
      end
      return
    end
    if not req or req.isError then
      return
    end
    if not self.avatar or not self.avatar.RoleCloakParent then
      CS.Framework.ObjectEx.Destroy(req.gameObject)
      return
    end
    self.capeDisplayObj = req.gameObject
    self.capeDisplayObj.name = modelName
    local posX, posY, posZ = tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3])
    local ratX, ratY, ratZ = tonumber(rat[1]), tonumber(rat[2]), tonumber(rat[3])
    req.gameObject.transform:SetLocalPosition(posX, posY, posZ)
    req.gameObject.transform:SetLocalEulerAngles(ratX, ratY, ratZ)
    req.gameObject:SetLayer(self.layer)
  end)
end

function RoleEquip:UnloadCapeDisplay()
  self._capeLoadCookie = nil
  if self.capeDisplayObj then
    CS.Framework.ObjectEx.Destroy(self.capeDisplayObj)
    self.capeDisplayObj = nil
  end
end

function RoleEquip:RecycleModel(ModelType, name, go)
  self.roleEquipOutEffect:DestroyEffect(name)
  EquipEffectSet.RvertSkinnedMeshmaterials(go, self.avatar)
  PoolManagerTest.Recycle(ModelType, name, go)
end
