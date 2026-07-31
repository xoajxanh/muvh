EquipEffectSet = {
  EquipPool = {},
  AngelSuitEffecData = {
    [31001301] = "",
    [31001401] = "",
    [31001501] = "",
    [31001601] = "",
    [31001701] = "",
    [31001302] = "Eff_datianshi_trunkmale02",
    [31001402] = "Eff_datianshi_headmale02",
    [31001502] = "Eff_datianshi_legmale02",
    [31001602] = "Eff_datianshi_handmale02",
    [31001702] = "Eff_datianshi_footmale02",
    [31001303] = "Eff_datianshi_trunkmale03",
    [31001403] = "Eff_datianshi_headmale03",
    [31001503] = "Eff_datianshi_legmale03",
    [31001603] = "Eff_datianshi_handmale03",
    [31001703] = "Eff_datianshi_footmale03",
    [31001304] = "Eff_datianshi_trunkmale04",
    [31001404] = "Eff_datianshi_headmale04",
    [31001504] = "Eff_datianshi_legmale04",
    [31001604] = "Eff_datianshi_handmale04",
    [31001704] = "Eff_datianshi_footmale04",
    [31001305] = "Eff_datianshi_trunkmale05",
    [31001405] = "Eff_datianshi_headmale05",
    [31001505] = "Eff_datianshi_legmale05",
    [31001605] = "Eff_datianshi_handmale05",
    [31001705] = "Eff_datianshi_footmale05",
    [31002201] = "",
    [31002301] = "",
    [31002401] = "",
    [31002501] = "",
    [31002601] = "",
    [31002202] = "Eff_datianshi_trunkmale02",
    [31002302] = "Eff_datianshi_headmale02",
    [31002402] = "Eff_datianshi_legmale02",
    [31002502] = "Eff_datianshi_handmale02",
    [31002602] = "Eff_datianshi_footmale02",
    [31002203] = "Eff_datianshi_trunkmale03",
    [31002303] = "Eff_datianshi_headmale03",
    [31002403] = "Eff_datianshi_legmale03",
    [31002503] = "Eff_datianshi_handmale03",
    [31002603] = "Eff_datianshi_footmale03",
    [31002204] = "Eff_datianshi_trunkmale04",
    [31002304] = "Eff_datianshi_headmale04",
    [31002404] = "Eff_datianshi_legmale04",
    [31002504] = "Eff_datianshi_handmale04",
    [31002604] = "Eff_datianshi_footmale04",
    [31002205] = "Eff_datianshi_trunkmale05",
    [31002305] = "Eff_datianshi_headmale05",
    [31002405] = "Eff_datianshi_legmale05",
    [31002505] = "Eff_datianshi_handmale05",
    [31002605] = "Eff_datianshi_footmale05",
    [31002701] = "",
    [31002801] = "",
    [31002901] = "",
    [31003001] = "",
    [31003101] = "",
    [31002702] = "Eff_datianshi_trunkmale02",
    [31002802] = "Eff_datianshi_headmale02",
    [31002902] = "Eff_datianshi_legmale02",
    [31003002] = "Eff_datianshi_handmale02",
    [31003102] = "Eff_datianshi_footmale02",
    [31002703] = "Eff_datianshi_trunkmale03",
    [31002803] = "Eff_datianshi_headmale03",
    [31002903] = "Eff_datianshi_legmale03",
    [31003003] = "Eff_datianshi_handmale03",
    [31003103] = "Eff_datianshi_footmale03",
    [31002704] = "Eff_datianshi_trunkmale04",
    [31002804] = "Eff_datianshi_headmale04",
    [31002904] = "Eff_datianshi_legmale04",
    [31003004] = "Eff_datianshi_handmale04",
    [31003104] = "Eff_datianshi_footmale04",
    [31002705] = "Eff_datianshi_trunkmale05",
    [31002805] = "Eff_datianshi_headmale05",
    [31002905] = "Eff_datianshi_legmale05",
    [31003005] = "Eff_datianshi_handmale05",
    [31003105] = "Eff_datianshi_footmale05",
    [7000000] = "Eff_shengdan_maozi",
    [7000001] = "Eff_shengdan_maozi",
    [7000002] = "Eff_shengdan_maozi"
  },
  wingParticleConfig = {
    {
      level = 25,
      effectName = "Eff_chibang_lizi02"
    },
    {
      level = 29,
      effectName = "Eff_chibang_glow"
    },
    {
      level = 33,
      effectName = "Eff_chibang_luoxuan"
    }
  }
}
local wingEffectPool = {}
RoleEquipConstantConfig.ShengDan = StringPool.ToID("Eff_shengdan_maozi")
RoleEquipConstantConfig.wingEffect25 = StringPool.ToID("Eff_chibang_lizi02")
RoleEquipConstantConfig.wingEffect29 = StringPool.ToID("Eff_chibang_glow")
RoleEquipConstantConfig.wingEffect33 = StringPool.ToID("Eff_chibang_luoxuan")
local this = EquipEffectSet
local Material = UnityEngineLua.Material

function EquipEffectSet.Init()
  this.SuitInfoCfgBuild()
  Coroutine.Start(this.LoadAsyncPublicAssets)
end

local materialFuncChar = {
  "#",
  "@",
  "^",
  "*"
}

local function RunningMaterialLogic(mat, logicItem)
  if logicItem.funcChar == "#" then
    local colorParam = string.split(logicItem[2], ":")
    mat:SetColor(logicItem[1], Color(colorParam[1], colorParam[2], colorParam[3], colorParam[4]))
  elseif logicItem.funcChar == "@" then
    mat:SetFloat(logicItem[1], tonumber(logicItem[2]))
  elseif logicItem.funChar == "^" then
    local vectorParam = string.split(logicItem[2], ":")
    mat:SetVector(logicItem[1], Vector4(vectorParam[1], vectorParam[2], vectorParam[3], vectorParam[4]))
  elseif logicItem.funcChar == "*" then
    local offsetScale = string.split(logicItem[2], ":")
    local offset = Vector2.right * tonumber(offsetScale[1]) + Vector2.up * tonumber(offsetScale[2])
    local scale = Vector2.right * tonumber(offsetScale[3]) + Vector2.up * tonumber(offsetScale[4])
    mat:SetTextureOffset(logicItem[1], offset)
    mat:SetTextureScale(logicItem[1], scale)
  end
  if mat:HasProperty("_SrcBlend") and mat:GetFloat("_SrcBlend") == 5 then
    mat.renderQueue = 3000
  end
end

local function RunningMaterialLogic2(mat, logicItem)
  if logicItem[1] == 1 then
    mat:SetColor(logicItem[2], Color(logicItem[3], logicItem[4], logicItem[5], logicItem[6]))
  elseif logicItem[1] == 2 then
    mat:SetFloat(logicItem[2], tonumber(logicItem[3]))
  elseif logicItem[1] == 3 then
    mat:SetVector(logicItem[2], Vector4(logicItem[3], logicItem[4], logicItem[5], logicItem[6]))
  elseif logicItem[1] == 4 then
    local offset = Vector2.GetTemp(logicItem[3], logicItem[4])
    mat:SetTextureOffset(logicItem[2], offset)
    local scale = Vector2.GetTemp(logicItem[5], logicItem[6])
    mat:SetTextureScale(logicItem[2], scale)
  end
  if mat:HasProperty("_SrcBlend") and mat:GetFloat("_SrcBlend") == 5 then
    mat.renderQueue = 3000
  end
end

local function GetLogicParamNameAndValue(nameValue)
  for i = 1, #materialFuncChar do
    local NV = string.split(nameValue, materialFuncChar[i])
    if 1 < #NV then
      NV.funcChar = materialFuncChar[i]
      return NV
    end
  end
end

local function GetMaterialFuncArray(str)
  local setArray = string.split(str, "&")
  local funcArray = {}
  for i = 1, #setArray do
    funcArray[i] = GetLogicParamNameAndValue(setArray[i])
  end
  return funcArray
end

local shaderAssets = {}
local effecInforById = {}
local logicItem0 = {
  "_MoreLevelSweep",
  "0",
  funcChar = "@"
}
local logicItem1 = {
  "_MoreLevelSweep",
  "1",
  funcChar = "@"
}
local IntensifyMaxValue = 10000

function EquipEffectSet.SetEquipIntensifyEffect(skinned, typeId, level, equipLevel)
  local intensifyTab
  for i = equipLevel, 0, -1 do
    intensifyTab = effecInforById[typeId * IntensifyMaxValue + i]
    if intensifyTab and intensifyTab.lightParam ~= nil then
      break
    end
  end
  if not intensifyTab or intensifyTab.lightParam == nil then
    return
  end
  if 0 < #intensifyTab.lightParam then
    local materialInforItems = intensifyTab.lightParam
    local replaceMat = {}
    for i = 1, #materialInforItems do
      local infors = materialInforItems[i]
      local index = infors[1]
      local shName = infors[2]
      local pathAndParam = infors[3]
      local targetMat
      if index >= skinned.materials.Length then
        targetMat = Material(CS.Framework.ShaderEx.Find(tostring(shName)))
      else
        targetMat = skinned.materials[index]
      end
      if targetMat.shader.name ~= shName then
        local shader = CS.Framework.ShaderEx.Find(tostring(shName))
        if CS.Framework.ResourceManager.editorMode and not shader then
          shader = shaderAssets[intensifyTab.lightName]
          if not shader then
            shader = CS.Framework.AssetGroup():LoadAssetAsync("Shader/" .. intensifyTab.lightPath, typeof(UnityEngineLua.Shader)).res
            shaderAssets[shader.name] = shader
          end
        end
        if shader then
          targetMat.shader = shader
        else
          logError("Hi\225\187\135u \225\187\169ng trang b\225\187\139" .. typeId .. "C\225\186\165p \196\145\225\187\153 c\198\176\225\187\157ng h\195\179a" .. intensifyTab.level .. "Kh\195\180ng t\195\172m th\225\186\165y t\195\160i nguy\195\170n shader")
        end
      end
      for i = 1, #pathAndParam do
        RunningMaterialLogic2(targetMat, pathAndParam[i])
      end
      if shName == "FGQJ/Role/DiffuseFlowing11" then
        if equipLevel < 17 then
          RunningMaterialLogic(targetMat, logicItem0)
        else
          RunningMaterialLogic(targetMat, logicItem1)
        end
      end
      if targetMat:HasProperty("_ZWrite") and 1 > targetMat:GetFloat("_ZWrite") then
        targetMat.renderQueue = 3150
      end
      local streamerIndex = targetMat.shader:FindPropertyIndex("_Streamer")
      if 0 < streamerIndex and 0 < equipLevel then
        local texture = targetMat:GetTexture("_Streamer")
        if not texture and this.streamLightTexture.name then
          targetMat:SetTexture("_Streamer", this.streamLightTexture)
        end
      end
      if shName == "FGQJ/Role/DiffuseFlowing1" then
        if targetMat:HasProperty("_SpriteTex") and this.SepiteTex then
          targetMat:SetTexture("_SpriteTex", this.SepiteTex)
        end
        if targetMat:HasProperty("_DistortionTex") and this.DistortionTex then
          targetMat:SetTexture("_DistortionTex", this.DistortionTex)
        end
      end
      if shName == "FGQJ/UI/Alpha_X_UI" then
        if targetMat:GetFloat("_MainSpeedV") ~= 0 then
          targetMat:SetTexture("_MainTex", this.streamLightTexture)
        else
          targetMat:SetTexture("_MainTex", this.glowEffectTexture)
        end
        if skinned.materials[0]:HasProperty("_MainTex") then
          local mainTex = skinned.materials[0]:GetTexture("_MainTex")
          targetMat:SetTexture("_MaskTex", mainTex)
        end
      end
      local Mat = Material(targetMat)
      Mat.name = string.sub(Mat.name, 1, #Mat.name - 10)
      if typeId == 2200020 or typeId == 2200028 or typeId == 2200010 or typeId == 2200018 then
        Mat.renderQueue = 2450
      end
      table.insert(replaceMat, Mat)
    end
    skinned.materials = replaceMat
    local UIRenderer = skinned:GetComponent(typeof(CS.UIMeshOld))
    if UIRenderer then
      UIRenderer.materials = replaceMat
      if skinned.gameObject.layer == 5 and skinned.transform.parent.parent.name ~= "WingspineParent" then
        skinned.enabled = true
        UIRenderer.enabled = false
      else
        skinned.enabled = true
        UIRenderer.enabled = false
      end
    end
    return
  end
end

local suitTable = {}

local function GetTableByItem(equipItem)
  for i = 1, #suitTable do
    for n = 1, #suitTable[i].type do
      if suitTable[i].type[n] == equipItem.tblItem.id then
        return suitTable[i]
      end
    end
  end
end

function EquipEffectSet:SuitCompletenessCheck(roleEquipData, suitInfo)
  local itemToTab = {}
  local count = 0
  local minLevel = 50
  local item
  for i = 1, #EquipEffectSet.SuitIndex do
    local dataItem = roleEquipData[EquipEffectSet.SuitIndex[i]]
    if dataItem then
      if minLevel > dataItem.intensify then
        minLevel = dataItem.intensify
      end
      itemToTab[dataItem.tblItem.id] = GetTableByItem(dataItem)
      item = itemToTab[dataItem.tblItem.id]
      count = count + 1
    end
  end
  suitInfo.equipCount = count
  suitInfo.minLevel = minLevel
  if minLevel < 9 then
    return
  end
  if count == 0 then
    return
  end
  if not item then
    return
  end
  if count ~= #item.type / 2 and count ~= #item.type / 3 then
    return
  end
  local targetTab
  for k, v in pairs(itemToTab) do
    local IDEndSign = k % IntensifyMaxValue
    if type(item) ~= "number" or item == IDEndSign then
      item = IDEndSign
      targetTab = v
    else
      return
    end
  end
  local suitColor = Color.white
  if not string.isNullOrEmpty(targetTab.suitLight) then
    local colorStrs = string.split(targetTab.suitLight, ":")
    suitColor = Color(colorStrs[1], colorStrs[2], colorStrs[3], colorStrs[4])
  end
  if 9 <= minLevel and minLevel < 11 then
    return {lightColor = suitColor}
  elseif 11 <= minLevel and minLevel < 13 then
    return {lightColor = suitColor, sweepType = 1}
  elseif 13 <= minLevel then
    return {lightColor = suitColor, sweepType = 2}
  end
end

function EquipEffectSet:SuitInfoCfgBuild()
  local intensifyTab = ConfigManager.GetConfigTable("cfg_Item_equip_liuguang")
  local count = 1
  for i = 1, #intensifyTab do
    if intensifyTab[i].level == 9 and type(intensifyTab[i].type) == "table" then
      suitTable[count] = intensifyTab[i]
      count = count + 1
    end
    if type(intensifyTab[i].type) == "number" then
      effecInforById[intensifyTab[i].type * IntensifyMaxValue + intensifyTab[i].level] = intensifyTab[i]
    else
      for n = 1, #intensifyTab[i].type do
        effecInforById[intensifyTab[i].type[n] * IntensifyMaxValue + intensifyTab[i].level] = intensifyTab[i]
      end
    end
  end
end

function EquipEffectSet.LoadAsyncPublicAssets()
  this.streamLightTexture = CS.Framework.ResourceManager.LoadAssetAsync("Texture/TexEff_Chrome01.jpg", typeof(UnityEngineLua.Texture))
  Coroutine.Yield(this.streamLightTexture)
  if not this.streamLightTexture or this.streamLightTexture.isError then
    Coroutine.Break()
  end
  this.streamLightTexture = this.streamLightTexture.res
  this.glowEffectTexture = CS.Framework.ResourceManager.LoadAssetAsync("Texture/TexEff_T_glow_0077.tga", typeof(UnityEngineLua.Texture))
  Coroutine.Yield(this.glowEffectTexture)
  if not this.glowEffectTexture or this.glowEffectTexture.isError then
    Coroutine.Break()
  end
  this.glowEffectTexture = this.glowEffectTexture.res
  this.SepiteTex = CS.Framework.ResourceManager.LoadAssetAsync("Texture/TexEff_mask_0014.tga", typeof(UnityEngineLua.Texture))
  Coroutine.Yield(this.SepiteTex)
  if not this.SepiteTex or this.SepiteTex.isError then
    Coroutine.Break()
  end
  this.SepiteTex = this.SepiteTex.res
  this.DistortionTex = CS.Framework.ResourceManager.LoadAssetAsync("Texture/T_tex_0072.tga", typeof(UnityEngineLua.Texture))
  Coroutine.Yield(this.DistortionTex)
  if not this.DistortionTex or this.DistortionTex.isError then
    Coroutine.Break()
  end
  this.DistortionTex = this.DistortionTex.res
end

EquipEffectSet.SuitIndex = {
  2,
  6,
  8,
  9,
  10
}

function EquipEffectSet.IntensifyEffectRule(intensify)
  if intensify < 3 then
    return 0
  elseif 3 <= intensify and intensify < 5 then
    return 3
  elseif 5 <= intensify and intensify < 7 then
    return 5
  elseif 7 <= intensify and intensify < 9 then
    return 7
  elseif 9 <= intensify and intensify < 11 then
    return 9
  elseif 11 <= intensify then
    return 11
  end
end

function EquipEffectSet:SetModelEffecByIntensify(dataItem, obj, role)
  if role and not IsNil(obj) then
    self.MeshCloakingMaterialSet(obj, role)
    if role.CloakingState then
      return
    end
  end
  if dataItem == nil then
    return
  end
  local intensifyNum
  if obj == nil or IsNil(obj) then
    return
  end
  local skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
  if not skinnedMesh then
    skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.MeshRenderer))
    if not skinnedMesh then
      return
    end
  end
  if not dataItem.intensify then
    dataItem.intensify = 0
  end
  if dataItem.tblEquip then
    local targetId = dataItem.tblEquip.relationLiuguang
    targetId = 0 < targetId and targetId or dataItem.tblEquip.id
    self.SetEquipIntensifyEffect(skinnedMesh, targetId, intensifyNum, dataItem.intensify)
  end
  if dataItem.tblEquip and dataItem.tblEquip.subType == EItemSubtype.Wing then
    self:WingParticleEffectSet(dataItem.intensify, skinnedMesh)
  elseif dataItem.tblItem and dataItem.tblItem.type == EItemType.HolyRing then
    self:SetHolyRingEffectTintColor(dataItem.itemId, skinnedMesh)
  end
end

local function LoadWingEffect(particleName, trans, loadComplete)
  local assetsStr = string.format("Effect/Skill/%s.prefab", particleName)
  local particlaReq = CS.Framework.ResourceManager.InstantiateAsync(assetsStr)
  Coroutine.Yield(particlaReq)
  if not particlaReq or particlaReq.isError then
    Coroutine.Break()
  end
  if not wingEffectPool[particleName] then
    wingEffectPool[particleName] = {}
  end
  table.insert(wingEffectPool[particleName], particlaReq.gameObject)
  particlaReq.gameObject.transform:SetParent(trans)
  particlaReq.gameObject.layer = trans.gameObject.layer
  if loadComplete then
    loadComplete(particlaReq.gameObject)
  end
end

local function EffectLoadComplete(obj)
  obj.transform:SetLocalPosition(0, 0, 0)
  obj.transform:SetLocalScale(1)
  obj.transform:SetLocalEulerAngles(0, 0, 0)
end

local function WingEffectItemLoad(effectName, skinnedObj)
  if not string.isNullOrEmpty(effectName) then
    local obj
    if wingEffectPool[effectName] then
      local pool = wingEffectPool[effectName]
      for i = 1, #pool do
        if not IsNil(pool[i]) and not pool[i].activeSelf then
          obj = pool[i]
          obj:SetActive(true)
          break
        end
      end
    end
    if not obj then
      Coroutine.Start(LoadWingEffect, effectName, skinnedObj.transform.parent, EffectLoadComplete)
      return
    end
    obj.transform:SetParent(skinnedObj.transform.parent)
    obj.layer = skinnedObj.transform.parent.gameObject.layer
    EffectLoadComplete(obj)
  end
end

function EquipEffectSet:WingParticleEffectSet(intensify, skinnedObj)
  local item
  skinnedObj.transform.parent:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.wingEffect25, RoleEquipConstantConfig.wingEffect29)
  skinnedObj.transform.parent:RecycleContainsByName(PoolManagerTest.root, RoleEquipConstantConfig.wingEffect33)
  for i = #self.wingParticleConfig, 1, -1 do
    item = self.wingParticleConfig[i]
    if intensify >= item.level then
      WingEffectItemLoad(item.effectName, skinnedObj)
    end
  end
end

local cloackingMaterial, bilocationMaterial

local function CloakingAssetsLoad()
  cloackingMaterial = CS.Framework.ResourceManager.LoadAssetAsync("Material/CloakingEffect.mat", typeof(UnityEngineLua.Material))
  Coroutine.Yield(cloackingMaterial)
  if not cloackingMaterial or cloackingMaterial.isError then
    Coroutine.Break()
  end
  cloackingMaterial = cloackingMaterial.res
  bilocationMaterial = cloackingMaterial.res
end

local function InitAsyncLoad()
  Coroutine.Start(CloakingAssetsLoad)
end

InitAsyncLoad()

local function ParticleEffectDealWith(obj, role)
  local meshs = obj:GetComponentsInChildren(typeof(UnityEngineLua.MeshRenderer))
  for i = 0, meshs.Length - 1 do
    if meshs[i].material.shader.name == "FGQJ/Effect/LookAtCamera/Quad" or meshs[i].material.shader.name == "FGQJ/UI/Alpha_X_UI" and meshs[i].material.name ~= cloackingMaterial.name .. " (Instance)" then
      meshs[i].enabled = not role.CloakingState
    end
  end
  meshs = obj:GetComponentsInChildren(typeof(UnityEngineLua.ParticleSystem))
  local renderer
  for i = 0, meshs.Length - 1 do
    renderer = meshs[i].gameObject:GetComponent(typeof(UnityEngineLua.Renderer))
    renderer.enabled = not role.CloakingState
  end
  meshs = obj:GetComponentsInChildren(typeof(UnityEngineLua.TrailRenderer))
  for i = 0, meshs.Length - 1 do
    meshs[i].enabled = not role.CloakingState
  end
end

function EquipEffectSet.MeshCloakingMaterialSet(obj, role, name)
  local skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
  if not skinnedMesh then
    skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.MeshRenderer))
    if not skinnedMesh then
      return
    end
  end
  local mapName = obj.name
  if name then
    mapName = name
  end
  if role.CloakingState then
    role:BadyMaterialsLog(mapName, skinnedMesh.materials)
    local cloackMats = {}
    for i = 0, skinnedMesh.materials.Length - 1 do
      if RoleManager.me and RoleManager.me.name == role.name and role.id ~= RoleManager.me.id then
        table.insert(cloackMats, bilocationMaterial)
      else
        table.insert(cloackMats, cloackingMaterial)
      end
    end
    skinnedMesh.materials = cloackMats
  else
    local mats = role:GetBodyMaterialsByName(mapName)
    if mats then
      skinnedMesh.materials = mats
    end
  end
end

function EquipEffectSet.RvertSkinnedMeshmaterials(obj, role)
  if role == nil or obj == nil then
    return
  end
  local mapName = obj.name
  local mats = role:GetBodyMaterialsByName(mapName)
  if mats then
    local skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
    if not skinnedMesh then
      skinnedMesh = obj:GetComponentInChildren(typeof(UnityEngineLua.MeshRenderer))
      if not skinnedMesh then
        return
      end
    end
    skinnedMesh.materials = mats
  end
end

function EquipEffectSet:ShapeshiftEquipCloacking(obj, role, name)
  if role and not IsNil(obj) then
    self.MeshCloakingMaterialSet(obj, role, name)
  end
end

function EquipEffectSet:SetHolyRingEffectTintColor(itemId, skinnedMesh)
  if skinnedMesh == nil or skinnedMesh.material == nil then
    return
  end
  local rgbTbl = ClientTable.cfg_Ring_rgbManager:TryGetValue(itemId)
  if rgbTbl == nil then
    return
  end
  if skinnedMesh.material:HasProperty("_TintColor") then
    skinnedMesh.material:SetColor("_TintColor", Color(rgbTbl.RedAsInteger / 255, rgbTbl.GreenAsInteger / 255, rgbTbl.BlueAsInteger / 255, rgbTbl.Alpha / 255))
  end
end

EquipEffectSet.Init()
