Equip_SignetUI = class(BaseUI)
Equip_SignetUI.layer = UILayer.Panel
Equip_SignetUI.orderInLayer = 0
Equip_SignetUI.hideType = UIHideType.WaitDestroy
Equip_SignetUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_SignetUI.escClose = UIEscClose.DontClose

function Equip_SignetUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.img_Signetlevel = self:GetControl("bg_equip/img_equipbg/LevelUp/img_Signetlevel")
  self.img_Signetlevelnext = self:GetControl("bg_equip/img_equipbg/LevelUp/img_Signetlevelnext")
  self.img_attributeArrow = self:GetControl("bg_equip/img_equipbg/LevelUp/img_attributeArrow")
  self.go_model = self:GetControl("bg_equip/go_model")
  self.lab_attributegrow = self:GetControl("bg_equip/lab_attributegrow")
  self.lab = self:GetControl("bg_equip/lab_attributegrow/img_titleico/lab_attributegrow/lab")
  self.text_atk = self:GetControl("bg_equip/lab_attributegrow/img_titleico/lab_attributegrow/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/lab_attributegrow/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/lab_attributegrow/lab/lab_atk/text_atknext")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.text_gold = self:GetControl("bg_equip/lab_material/lab_gold/text_gold")
  self.frame_item = self:GetControl("bg_equip/lab_material/materialParent/frame_item")
  self.Model = self:GetControl("bg_equip/lab_material/materialParent/frame_item/Model")
  self.text_successRate = self:GetControl("bg_equip/lab_material/text_successRate")
  self.btn_intensify = self:GetControl("bg_equip/btn_intensify")
  self.text_intensify = self:GetControl("bg_equip/btn_intensify/text_intensify")
  self.lb_name = self:GetControl("bg_equip/lb_name")
  self.Equip_level = self:GetControl("bg_equip/Equip_level")
  self.left_arrow = self:GetControl("bg_equip/Equip_level/left_arrow")
  self.right_arrow = self:GetControl("bg_equip/Equip_level/right_arrow")
  self.level = self:GetControl("bg_equip/Equip_level/level")
  self.grid_LevelContent = self:GetControl("bg_equip/Equip_level/level/Viewport/grid_LevelContent")
  self.go_level = self:GetControl("bg_equip/Equip_level/level/Viewport/grid_LevelContent/go_level")
  self.img_lvArrow = self:GetControl("bg_equip/Equip_level/level/Viewport/grid_LevelContent/go_level/img_lvArrow")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.tog_sword = self:GetControl("go_signetNavGroup/tog_sword")
  self.tog_shield = self:GetControl("go_signetNavGroup/tog_shield")
  self.tog_cross = self:GetControl("go_signetNavGroup/tog_cross")
  self.AttributeTips = self:GetControl("AttributeTips")
end

function Equip_SignetUI:Init()
end

function Equip_SignetUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_SignetUI:InitUI()
  self:InitParam()
  self:InitContainer()
end

function Equip_SignetUI:RegistUIEvents()
  self.btn_intensify:SetOnClick(self, self.btn_intensifyOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_sword:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_shield:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_cross:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Equip_SignetUI:btn_intensifyOnClick(control)
  if self.upCode == EHolySealUpgradeCode.NotMeetCondition then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Equip_Signet_limit"))
  elseif self.upCode == EHolySealUpgradeCode.NotMeetConsumable then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Equip_Signet_Resources"))
  elseif self.upCode == EHolySealUpgradeCode.MeetAll then
    networkRequest.ReqHolySealLevelUp(self.signetType)
  end
end

function Equip_SignetUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_SignetUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_SignetUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_SignetUI)
end

function Equip_SignetUI:OnToggleChanged()
  local type
  if self.tog_sword.toggle.isOn then
    type = EHolySealType.HolySword
  elseif self.tog_shield.toggle.isOn then
    type = EHolySealType.HolyShield
  elseif self.tog_cross.toggle.isOn then
    type = EHolySealType.HolyCross
  end
  if self.signetType ~= type then
    self.lastType = self.signetType
    self.signetType = type
    self:Refresh()
  end
end

function Equip_SignetUI:LevelUnitClickCallBack(levelData)
  if self.tipsTemplate then
    self.tipsTemplate:Refresh(levelData)
  end
end

function Equip_SignetUI:OnShow()
  self:RegistEvents()
  self:InitializeSealType()
  self:InitializeToggleView()
  self:Refresh()
end

function Equip_SignetUI:RegistEvents()
  self:RegistEvent(Event.HolySealIdChanged, self.HolySealIdChangedCallBack, self)
  self:RegistEvent(Event.HolySealStateCodeChanged, self.HolySealStateCodeChangedCallBack, self)
end

function Equip_SignetUI:HolySealIdChangedCallBack(msgId, data)
  if data == nil or data.type ~= self.signetType then
    return
  end
  self:Refresh()
end

function Equip_SignetUI:HolySealStateCodeChangedCallBack(msgId, data)
  if data == nil or data.type ~= self.signetType then
    return
  end
  self:RefreshUpgradeCode()
end

function Equip_SignetUI:Refresh()
  self:RefreshData()
  self:RefreshView()
  if self.tipsTemplate then
    self.tipsTemplate:HideView()
  end
end

function Equip_SignetUI:OnHide()
end

function Equip_SignetUI:OnDestroy()
end

function Equip_SignetUI:GetSealDataMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetHolySealDataMgr()
  end
  return nil
end

function Equip_SignetUI:InitParam()
  self.curModel = nil
  self.modelPathFormat = "Model/Signet/HolySeal_%d.prefab"
  self.levelPos = {
    [true] = {x = 29, y = 2},
    [false] = {x = -7, y = 2}
  }
  self.togObj = {
    [EHolySealType.HolySword] = self.tog_sword,
    [EHolySealType.HolyShield] = self.tog_shield,
    [EHolySealType.HolyCross] = self.tog_cross
  }
  self.mModelDic = {}
end

function Equip_SignetUI:InitContainer()
  self.levelContainer = UIUtility.BindUIContainerTemp(self.go_level, LuaComponentTemplates.Equip_SignetLevelUnitTemplate, self, {
    clickCallBack = self.LevelUnitClickCallBack
  })
  self.attributeContainer = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.consumableContainer = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
  self.tipsTemplate = luaTemplateManager.GetNewTemplate(self.AttributeTips, LuaComponentTemplates.Equip_SignetLevelTipsTemplate)
end

function Equip_SignetUI:InitializeSealType()
  if self.args ~= nil and self.args.openFirstTab ~= nil then
    self.signetType = self.args.openFirstTab
    return
  end
  local type = self:GetSealDataMgr():GetCanUpgradeType()
  if type then
    self.signetType = type
  else
    self.signetType = EHolySealType.HolySword
  end
end

function Equip_SignetUI:RefreshData()
  if self:GetSealDataMgr() == nil then
    return
  end
  self.curSealInfo = self:GetSealDataMgr():GetCurSealDataByType(self.signetType)
  self.isMin = self.curSealInfo == nil
  self.maxId = ClientTable.cfg_Seal_SealManager:TryGetMaxIdByType(self.signetType)
  self.isMax = not self.isMin and self.curSealInfo.id == self.maxId
  if self.isMin then
    local minId = ClientTable.cfg_Seal_SealManager:TryGetMinIdByType(self.signetType)
    self.nextSealInfo = self:GetSealDataMgr():TryGetSealInfoById(minId)
    self.attributeList = ClientTable.cfg_Seal_SealManager:TryGetSealAttributeTbl(0, self.signetType)
  else
    self.nextSealInfo = self:GetSealDataMgr():TryGetSealInfoById(self.isMax and 0 or self.curSealInfo.id + 1)
    self.attributeList = ClientTable.cfg_Seal_SealManager:TryGetSealAttributeTbl(self.curSealInfo.id)
  end
  self:RefreshUpgradeCode()
  self.levelList = self:GetSealDataMgr():GetNeedShowSealLevelListByType(self.signetType)
  self.consumableList = {}
  if self.nextSealInfo then
    if self.nextSealInfo.consumable then
      for i, v in pairs(self.nextSealInfo.consumable) do
        table.insert(self.consumableList, v)
      end
    end
    if self.nextSealInfo.coinItem then
      for i, v in pairs(self.nextSealInfo.coinItem) do
        table.insert(self.consumableList, v)
      end
    end
  end
end

function Equip_SignetUI:RefreshUpgradeCode()
  self.upCode = self:GetSealDataMgr():GetCurUpgradeStateCodeByType(self.signetType)
end

function Equip_SignetUI:InitializeToggleView()
  for i, v in pairs(self.togObj) do
    if i == self.type then
      v.toggle.isOn = true
    else
      v.toggle.isOn = false
    end
  end
end

function Equip_SignetUI:RefreshView()
  self:RefreshTopView()
  self:RefreshlevelListView()
  self:RefreshAttributeView()
  self:RefreshConsumableView()
end

function Equip_SignetUI:RefreshTopView()
  if self.isMin and self.nextSealInfo then
    local str = string.gsub(self.nextSealInfo.name, "1", "0")
    self.lb_name:SetText(str)
  else
    self.lb_name:SetText(self.curSealInfo.name)
  end
  self.img_Signetlevel:SetText(self.isMin and "0" or tostring(self.curSealInfo.level))
  if not self.isMax then
    self.img_Signetlevelnext:SetText(self.nextSealInfo.level)
  end
  self.img_Signetlevel:SetAnchoredPosition(self.levelPos[self.isMax].x, self.levelPos[self.isMax].y)
  self.img_Signetlevelnext:SetActive(not self.isMax)
  self.img_attributeArrow:SetActive(not self.isMax)
  self:RefreshModleView()
end

function Equip_SignetUI:RefreshModleView()
  if self.mModelDic[self.signetType] ~= nil then
    if self.curModel ~= nil then
      self.curModel:SetActive(false)
    end
    self.curModel = self.mModelDic[self.signetType]
    self.curModel:SetActive(true)
  else
    if self.curModel ~= nil then
      self.curModel:SetActive(false)
    end
    Coroutine.Start(self.LoadModel, self)
  end
end

function Equip_SignetUI:RefreshlevelListView()
  if self.levelList == nil then
    return
  end
  self.levelContainer:SetData(self.levelList)
  self:MoveLevelScrollView()
end

function Equip_SignetUI:MoveLevelScrollView()
  if self.grid_LevelContent == nil or IsNil(self.grid_LevelContent.gameObject) or self.levelList == nil then
    return
  end
  local curLevel = self.curSealInfo == nil and 0 or self.curSealInfo.level
  local iconWidth, viewMaxCount = 70, 4
  local x = 0
  for i, v in pairs(self.levelList) do
    if v.level == curLevel then
      if i >= viewMaxCount then
        x = 0 - (i - 3) * iconWidth
      end
      break
    end
  end
  self.grid_LevelContent.transform.localPosition = Vector3(x, 0, 0)
end

function Equip_SignetUI:RefreshAttributeView()
  self.attributeContainer:SetData(self.attributeList)
end

function Equip_SignetUI:RefreshConsumableView()
  self.consumableContainer:SetData(self.consumableList)
end

function Equip_SignetUI:RefreshBtnView()
end

function Equip_SignetUI:LoadModel()
  local path = string.format(self.modelPathFormat, self.signetType)
  local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
  Coroutine.Yield(request)
  if request.isError then
    logError(request.error)
    Coroutine.Break()
  end
  local go = Instantiate(request.res)
  if go then
    self:SetModel(go)
    self.curModel = go
    self.mModelDic[self.signetType] = go
    go:SetActive(true)
  end
end

function Equip_SignetUI:SetModel(go)
  if go == nil or IsNil(go) then
    return
  end
  local orderLayer = self.root.canvas.sortingOrder
  go:SetLayer(UI_LAYER)
  go.transform:SetParent(self.go_model.transform, false)
  local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renders.Length - 1 do
    local rend = renders[i]
    rend.sortingOrder = orderLayer + 100
  end
  local particles = go:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if particles then
    for i = 0, particles.Length - 1 do
      particles[i].gameObject.layer = 5
      local renderer = particles[i].gameObject:GetComponent(typeof(CS.UnityEngine.Renderer))
      if renderer then
        renderer.sortingOrder = orderLayer + 100
      end
      particles[i]:Play()
    end
  end
end
