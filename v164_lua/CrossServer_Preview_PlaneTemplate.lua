local CrossServer_Preview_PlaneTemplate = {}

function CrossServer_Preview_PlaneTemplate:Init(msg)
  self:InitControls(msg)
  self:InitData()
  self:BindUIEvent()
end

function CrossServer_Preview_PlaneTemplate:InitControls(msg)
  self.rootUI = msg.rootUI
  self.data = msg.data
  self.nowControl = self:GetControl()
  self.btn_go = self:GetControl("btn_goCs")
  self.tips = self:GetControl("tips")
  self.go_model = self:GetControl("go_Model")
  local text = string.split(self.data.previewRoute, "_")[2]
  self.descBtn = self:GetControl("descBtn" .. text)
  self.btn_goUp = self:GetControl("btn_goUp")
  self.btn_goDown = self:GetControl("btn_goDown")
  self.img_BoneName = self:GetControl("img_BoneName")
end

function CrossServer_Preview_PlaneTemplate:InitContainer()
end

function CrossServer_Preview_PlaneTemplate:InitData()
  self.modelInfoList = {}
  self.curModelIndex = 1
  self.buffList = {}
  self.modelNameList = {}
  if CrossServerPreviewType.GodOn == self.data.id then
    local temp = ClientTable.cfg_Global_globalManager:TryGetValue(6030031)
    if temp and temp.effect then
      local modelInfo = string.split(temp.effect, "#")
      table.insert(self.modelInfoList, modelInfo)
    end
  elseif CrossServerPreviewType.HolyBone == self.data.id then
    local temp = ClientTable.cfg_Global_globalManager:TryGetValue(28)
    if temp and temp.effect then
      local effects = string.split(temp.effect, "&")
      for i, effect in ipairs(effects) do
        local modelInfo = string.split(effect, "#")
        table.insert(self.buffList, tonumber(modelInfo[1]))
        modelInfo[1] = 1003
        table.insert(self.modelInfoList, modelInfo)
      end
    end
    local temp = ClientTable.cfg_Global_globalManager:TryGetValue(29)
    if temp and temp.effect then
      self.modelNameList = string.split(temp.effect, "&")
    end
  end
end

function CrossServer_Preview_PlaneTemplate:BindUIEvent()
  self.btn_go:SetOnClick(self, self.btn_goOnClick)
  if not IsNil(self.descBtn.transform) then
    self.descBtn:SetOnClick(self, self.btn_descOnClick)
  end
  if self.btn_goUp.transform then
    self.btn_goUp:SetOnClick(self, self.btn_goUpOnClick)
  end
  if self.btn_goDown.transform then
    self.btn_goDown:SetOnClick(self, self.btn_goDownOnClick)
  end
end

function CrossServer_Preview_PlaneTemplate:btn_goUpOnClick()
  self.curModelIndex = self.curModelIndex - 1
  if self.curModelIndex <= 0 then
    self.curModelIndex = #self.buffList
  end
  self:RefreshPlane()
end

function CrossServer_Preview_PlaneTemplate:btn_goDownOnClick()
  self.curModelIndex = self.curModelIndex + 1
  if self.curModelIndex > #self.buffList then
    self.curModelIndex = 1
  end
  self:RefreshPlane()
end

function CrossServer_Preview_PlaneTemplate:btn_descOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "CrossServer_IntoUI")
  for i = 1, #lvCfg do
    if lvCfg[i].iconName == control:GetName() then
      UIManager.Show(UIID.System_DescUI, {
        id = lvCfg[i].id
      })
      break
    end
  end
end

function CrossServer_Preview_PlaneTemplate:btn_goOnClick(control)
  if CrossServerPreviewType.GodOn == self.data.id then
    self:btn_goSLOnClick()
  elseif CrossServerPreviewType.LianjiOn == self.data.id then
    self:btn_goLianjiOnClick()
  elseif CrossServerPreviewType.KaLunTe == self.data.id then
    self:btn_gokalunteOnClick()
  elseif CrossServerPreviewType.Tilianzhita == self.data.id then
    self:btn_goTilianzhitaOnClick()
  elseif CrossServerPreviewType.Shenghun == self.data.id then
    self:btn_goShenghunOnClick()
  elseif CrossServerPreviewType.Master == self.data.id then
    self:btn_goCsMasterOnClick()
  elseif CrossServerPreviewType.Runes == self.data.id then
    self:btn_goRunesOnClick()
  elseif CrossServerPreviewType.HolyRing == self.data.id then
    self:btn_goHolyRingOnClick()
  elseif CrossServerPreviewType.HolyBone == self.data.id then
    self:btn_goHolyBoneOnClick()
  elseif CrossServerPreviewType.Kunshou == self.data.id then
    self:btn_goKunshouOnClick()
  elseif CrossServerPreviewType.ThreeVsThree == self.data.id then
    self:btn_go3V3OnClick()
  elseif CrossServerPreviewType.DuoQiCross == self.data.id then
    self:btn_goDuoQiCrossOnClick()
  elseif CrossServerPreviewType.NewRunes == self.data.id then
    self:btn_goNewRunesOnClick()
  elseif CrossServerPreviewType.CrystalNucleus == self.data.id then
    self:btn_goCrystalNucleusOnClick()
  elseif CrossServerPreviewType.Enchant == self.data.id then
    self:btn_goEnchantOnClick()
  elseif CrossServerPreviewType.SpaceCrack == self.data.id then
    self:btn_goSpaceCrackOnClick()
  elseif CrossServerPreviewType.SiFangZhengBa == self.data.id then
    self:btn_goSiFangOnClick()
  end
end

function CrossServer_Preview_PlaneTemplate:btn_goSLOnClick()
  local temp = ClientTable.cfg_Global_globalManager:TryGetValue(6030030)
  if temp == nil or temp.effect == nil then
    return
  end
  local navTable = ClientTable.cfg_Navigation_barManager:TryGetValue(tonumber(temp.effect))
  if navTable == nil then
    return
  end
  NavigationUtility.OpenPanel(navTable)
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
end

function CrossServer_Preview_PlaneTemplate:btn_goLianjiOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  EventManager.Dispatch(Event.Guide_CrossServerIntoUI)
end

function CrossServer_Preview_PlaneTemplate:btn_gokalunteOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.Kalunte
  })
end

function CrossServer_Preview_PlaneTemplate:btn_goTilianzhitaOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  PathFinderManager.JumpMapMoveToNpc({npcId = 1001026}, 104002, Purpose.ClickNpc)
end

function CrossServer_Preview_PlaneTemplate:btn_goShenghunOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  UIManager.Show(UIID.Equip_HolySpiritLeftUI)
end

function CrossServer_Preview_PlaneTemplate:btn_goCsMasterOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  UIManager.Show(UIID.MasterSkill_newMainUI)
end

function CrossServer_Preview_PlaneTemplate:btn_goRunesOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  UIManager.Show(UIID.Equip_RunesNavUI)
end

function CrossServer_Preview_PlaneTemplate:btn_goHolyRingOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  UIManager.Show(UIID.Equip_HolyRingNavUi)
end

function CrossServer_Preview_PlaneTemplate:btn_goHolyBoneOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  UIManager.Show(UIID.Equip_HolySkeletonNavUi)
end

function CrossServer_Preview_PlaneTemplate:btn_goKunshouOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.Kunshou
  })
end

function CrossServer_Preview_PlaneTemplate:btn_go3V3OnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.ThreeVsThree
  })
end

function CrossServer_Preview_PlaneTemplate:btn_goDuoQiCrossOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.DuoQiCross
  })
end

function CrossServer_Preview_PlaneTemplate:btn_goNewRunesOnClick()
  EventManager.Dispatch(Event.CrossServer_IntoUIClose)
  UIManager.Show(UIID.Equip_RunesNavNewUI)
end

function CrossServer_Preview_PlaneTemplate:btn_goCrystalNucleusOnClick()
  UIManager.Show(UIID.Puzzle_JH_NavUI)
end

function CrossServer_Preview_PlaneTemplate:btn_goEnchantOnClick()
  UIManager.Show(UIID.Enchant_NavUI)
end

function CrossServer_Preview_PlaneTemplate:btn_goSpaceCrackOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.SpaceCrack
  })
end

function CrossServer_Preview_PlaneTemplate:btn_goSiFangOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.SiFangZhengBa
  })
end

function CrossServer_Preview_PlaneTemplate:Refresh()
  self:RefreshBtn_go()
  self:RefreshPlane()
end

function CrossServer_Preview_PlaneTemplate:RefreshBtn_go()
  local tbl = ClientTable.cfg_Function_functionManager:TryGetValue(self.data.functionId)
  local isOpen = false
  if tbl and tbl.condition then
    isOpen = ConditionManager.Check4D(tbl.condition)
  end
  self.btn_go:SetActive(isOpen)
end

function CrossServer_Preview_PlaneTemplate:RefreshPlane()
  if CrossServerPreviewType.GodOn == self.data.id then
    local content_SL = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("kuafu_03")
    self.tips:SetText(content_SL)
  end
  self:RefreshModel()
  if self.img_BoneName.transform and type(self.modelInfoList) == "table" and self.modelNameList[self.curModelIndex] then
    self.rootUI:SetSprite("Atlas_Language", self.modelNameList[self.curModelIndex], self.img_BoneName)
  end
end

function CrossServer_Preview_PlaneTemplate:RefreshModel()
  if type(self.modelInfoList) ~= "table" then
    return
  end
  local modelInfo = self.modelInfoList[1]
  if #self.modelInfoList > 1 then
    modelInfo = self.modelInfoList[self.curModelIndex]
  end
  if type(modelInfo) ~= "table" or #modelInfo < 1 then
    return
  end
  local modelId = modelInfo[1]
  local position = modelInfo[2] and string.split(modelInfo[2], "|") or nil
  local scale = modelInfo[3] and tonumber(modelInfo[3]) or nil
  local rotation = modelInfo[4] and string.split(modelInfo[4], "|") or nil
  local animationSpeed = modelInfo[5]
  local buffs = type(self.buffList) == "table" and {
    self.buffList[self.curModelIndex]
  } or nil
  local viewRoleData = {}
  local equip = {}
  if tonumber(modelId) == 1003 then
    equip = table.DeepCopy(ViewData.meData.equipsData.Data)
  end
  viewRoleData.equipsData = RoleEquipData(equip)
  viewRoleData.career = ViewData.meData.career
  viewRoleData.modelType = EModelType.Charactor
  viewRoleData.model = modelId
  viewRoleData.id = tonumber(viewRoleData.model)
  viewRoleData.roleName = ViewData.meData.name
  viewRoleData.serverCoord = Vector2Int()
  viewRoleData.roleType = ERoleType.Player
  viewRoleData.parent = self.go_model.transform
  viewRoleData.animationName = "idle"
  if self.lookRole then
    self.lookRole:Destroy()
    if type(self.buffEffectLids) then
      gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
    end
    self.lookRole = ViewRole(viewRoleData)
  else
    self.lookRole = ViewRole(viewRoleData)
  end
  if self.lookRole then
    if position and 3 <= #position then
      self.lookRole:SetPosition(position[1], position[2], position[3])
    end
    if rotation and 3 <= #rotation then
      self.lookRole:SetRotation(rotation[1], rotation[2], rotation[3])
    end
    if scale then
      self.lookRole.transform.localScale = Vector3(scale, scale, scale)
    end
    self.lookRole:SetBuffAnchorDepth(-2)
    if type(buffs) == "table" and table.count(buffs) > 0 then
      self.buffEffectLids = gameMgr:GetEffectManager():GetBuffEffectProcessor():AddEffects(buffs, self.lookRole.model.BuffAnchor)
    end
  end
end

function CrossServer_Preview_PlaneTemplate:Exit()
  self:ReleaseModel()
end

function CrossServer_Preview_PlaneTemplate:ReleaseModel()
  if self.lookRole ~= nil then
    self.lookRole:Destroy()
    if type(self.buffEffectLids) == "table" and table.count(self.buffEffectLids) > 0 then
      gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
    end
    self.lookRole = nil
  end
end

return CrossServer_Preview_PlaneTemplate
