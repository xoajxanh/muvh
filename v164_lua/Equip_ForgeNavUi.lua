Equip_ForgeNavUi = class(BaseUI)
Equip_ForgeNavUi.layer = UILayer.Panel
Equip_ForgeNavUi.orderInLayer = 0
Equip_ForgeNavUi.hideType = UIHideType.Destroy
Equip_ForgeNavUi.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_ForgeNavUi.escClose = UIEscClose.DontClose

function Equip_ForgeNavUi:InitControls()
  self.tog_intensify = self:GetControl("go_forgeNavGroup/tog_intensify")
  self.tog_zhuijia = self:GetControl("go_forgeNavGroup/tog_zhuijia")
  self.tog_stone = self:GetControl("go_forgeNavGroup/tog_stone")
  self.tog_decompose = self:GetControl("go_forgeNavGroup/tog_decompose")
  self.tog_overlap = self:GetControl("go_forgeNavGroup/tog_overlap")
  self.tog_zhuanyi = self:GetControl("go_forgeNavGroup/tog_zhuanyi")
  self.tog_lucky = self:GetControl("go_forgeNavGroup/tog_lucky")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.SubPanelRootTwo = self:GetControl("SubPanelRootTwo")
  self.tog_gem = self:GetControl("go_forgeNavGroup/tog_gem")
  self.tog_xilian = self:GetControl("go_forgeNavGroup/tog_xilian")
  self.tog_regene = self:GetControl("go_forgeNavGroup/tog_regene")
end

function Equip_ForgeNavUi:Init()
  self.UIId = {
    UIID.Equip_IntensifyUI,
    UIID.Equip_ZhuijiaUI,
    UIID.Equip_OrnamentsUI,
    UIID.Equip_StoneUI,
    UIID.Equip_Decompose,
    UIID.Equip_OverlapUI,
    UIID.Equip_Transfer,
    UIID.Equip_Lucky,
    UIID.Equip_GemUI,
    UIID.Equip_XiLianUI,
    UIID.Equip_RegenerateUI
  }
  self.curUIId = UIID.Equip_IntensifyUI
end

function Equip_ForgeNavUi:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_ForgeNavUi:InitUI()
  self.togObj = {
    [UIID.Equip_IntensifyUI] = self.tog_intensify,
    [UIID.Equip_ZhuijiaUI] = self.tog_zhuijia,
    [UIID.Equip_StoneUI] = self.tog_stone,
    [UIID.Equip_Decompose] = self.tog_decompose,
    [UIID.Equip_OverlapUI] = self.tog_overlap,
    [UIID.Equip_Transfer] = self.tog_zhuanyi,
    [UIID.Equip_Lucky] = self.tog_lucky,
    [UIID.Equip_GemUI] = self.tog_gem,
    [UIID.Equip_XiLianUI] = self.tog_xilian,
    [UIID.Equip_RegenerateUI] = self.tog_regene
  }
  self.togRuler = {
    UIID.Equip_IntensifyUI,
    UIID.Equip_ZhuijiaUI,
    UIID.Equip_StoneUI,
    UIID.Equip_Decompose,
    UIID.Equip_OverlapUI,
    UIID.Equip_Transfer,
    UIID.Equip_Lucky,
    UIID.Equip_GemUI,
    UIID.Equip_XiLianUI,
    UIID.Equip_RegenerateUI
  }
end

function Equip_ForgeNavUi:OnShow()
  self.toggleInited = true
  if self.SubPanelRoot ~= nil then
  end
  self:RegistEvents()
  self:Refresh()
  if self.args then
    if self.args.uiID then
      self.curUIId = self.args.uiID
      EquipeInfoData.curView = self.args.uiID
      if self.args.openType then
        UIManager.Show(self.args.uiID, {
          resetLogic = 1,
          openType = self.args.openType,
          itemData = self.args.itemData
        })
      else
        UIManager.Show(self.args.uiID, {resetLogic = 1})
      end
    end
    if self.args.openFirstTab and self.args.openSecondTab then
      EquipeInfoData.curView = self.UIId[self.args.openFirstTab]
      self.curUIId = self.UIId[self.args.openFirstTab]
      UIManager.Show(EquipeInfoData.curView, {
        openSecondTab = self.args.openSecondTab,
        resetLogic = 1
      })
    end
  else
    self:SetFirstUIID()
  end
  self:ToggleInit()
end

function Equip_ForgeNavUi:OnHide()
end

function Equip_ForgeNavUi:OnDestroy()
end

function Equip_ForgeNavUi:RegistUIEvents()
  self.tog_intensify:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_zhuijia:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_stone:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_decompose:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_overlap:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_zhuanyi:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_lucky:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_gem:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_xilian:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_regene:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Equip_ForgeNavUi:OnToggleChanged()
  if self.toggleInited then
    return
  end
  if self.tog_intensify.toggle.isOn then
    self:btn_intensifyOnClick()
  end
  if self.tog_zhuijia.toggle.isOn then
    self:btn_zhuijiaOnClick()
  end
  if self.tog_stone.toggle.isOn then
    self:btn_StoneOnClick()
  end
  if self.tog_decompose.toggle.isOn then
    self:btn_decomposeOnClick()
  end
  if self.tog_overlap.toggle.isOn then
    self:btn_overlapOnClick()
  end
  if self.tog_zhuanyi.toggle.isOn then
    self:btn_zhuanyiOnClick()
  end
  if self.tog_lucky.toggle.isOn then
    self:btn_luckyOnClick()
  end
  if self.tog_gem.toggle.isOn then
    self:btn_gemOnClick()
  end
  if self.tog_xilian.toggle.isOn then
    self:btn_xilianOnClick()
  end
  if self.tog_regene.toggle.isOn then
    self:tog_regeneOnClick()
  end
end

function Equip_ForgeNavUi:btn_intensifyOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_IntensifyUI) then
    UIManager.Show(UIID.Equip_IntensifyUI, {resetLogic = 1})
    EventManager.Dispatch(Event.SuitEquipChange, {
      cellType = EquipCellType.NORMAL,
      from = UIID.Equip_IntensifyUI
    })
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_IntensifyUI)
  end
end

function Equip_ForgeNavUi:btn_zhuijiaOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_ZhuijiaUI) then
    UIManager.Show(UIID.Equip_ZhuijiaUI, {resetLogic = 1})
    EventManager.Dispatch(Event.SuitEquipChange, {
      cellType = EquipCellType.NORMAL,
      from = UIID.Equip_ZhuijiaUI
    })
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_ZhuijiaUI)
  end
end

function Equip_ForgeNavUi:btn_StoneOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_StoneUI) then
    UIManager.Show(UIID.Equip_StoneUI, {resetLogic = 1})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_StoneUI)
  end
end

function Equip_ForgeNavUi:btn_OrnamentsOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_OrnamentsUI) then
    UIManager.Show(UIID.Equip_OrnamentsUI, {resetLogic = 1})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_OrnamentsUI)
  end
end

function Equip_ForgeNavUi:btn_decomposeOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_Decompose) then
    UIManager.Show(UIID.Equip_Decompose, {resetLogic = 1})
  end
end

function Equip_ForgeNavUi:btn_overlapOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_OverlapUI) then
    UIManager.Show(UIID.Equip_OverlapUI, {resetLogic = 1})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_OverlapUI)
  end
end

function Equip_ForgeNavUi:btn_zhuanyiOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_Transfer) then
    UIManager.Show(UIID.Equip_Transfer, {resetLogic = 1, OpenType = 3})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_Transfer)
  end
end

function Equip_ForgeNavUi:btn_luckyOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_Lucky) then
    UIManager.Show(UIID.Equip_Lucky, {resetLogic = 1})
  end
end

function Equip_ForgeNavUi:btn_gemOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_GemUI) then
    EventManager.Dispatch(Event.SuitEquipChange, {
      cellType = EquipCellType.NORMAL,
      from = UIID.Equip_GemUI
    })
    UIManager.Show(UIID.Equip_GemUI, {resetLogic = 1})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_GemUI)
  end
end

function Equip_ForgeNavUi:btn_xilianOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_XiLianUI) then
    UIManager.Show(UIID.Equip_XiLianUI, {resetLogic = 1})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_XiLianUI)
  end
end

function Equip_ForgeNavUi:tog_regeneOnClick(control)
  if not UIManager.IsVisible(UIID.Equip_RegenerateUI) then
    UIManager.Show(UIID.Equip_RegenerateUI, {resetLogic = 1})
    EventManager.Dispatch(Event.SuitEquipChange, {
      cellType = EquipCellType.NORMAL
    })
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_RegenerateUI)
  end
end

function Equip_ForgeNavUi:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedForgeEquip, self)
end

function Equip_ForgeNavUi:SelectedForgeEquip(id, args)
  if args ~= nil then
    self.curSelectEquipIndex = args[2]
  end
end

function Equip_ForgeNavUi:Refresh()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    2020001,
    2010001,
    2040001,
    2400001,
    2410001,
    2420001,
    2500001,
    2090002,
    2090003,
    2090004
  })
end

function Equip_ForgeNavUi:InitShowModel(itemdata)
  if itemdata == nil then
    return
  end
  local go
  if self.equipPool[itemdata.itemId] then
    go = self.equipPool[itemdata.itemId]
    go:SetActive(true)
  else
    local subType = itemdata.tblItem.subType
    local modelName = RoleEquipUtility.GetEquipUIModelName(itemdata)
    local path = ModelConfig.GetCommentModelPath(subType, modelName)
    local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
    Coroutine.Yield(request)
    if request.isError then
      logError(request.error)
      Coroutine.Break()
    end
    go = Instantiate(request.res)
    self.equipPool[itemdata.itemId] = go
  end
  EquipEffectSet:SetModelEffecByIntensify(itemdata, go)
  self.LoadEquipObject = go
  return ItemUtility.SetModelTransform(go, self.frame_equip.transform, itemdata, 1, 400)
end

function Equip_ForgeNavUi:InitShowModelInTransfer(itemdata)
  if ForgeData.SelectEquipPos == TransferEquipType.firstEquip then
    if self.LoadEquipObjectFirst then
      self.LoadEquipObjectFirst:SetActive(false)
    end
  elseif ForgeData.SelectEquipPos == TransferEquipType.secondEquip and self.LoadEquipObjectSecondE then
    self.LoadEquipObjectSecondE:SetActive(false)
  end
  if itemdata == nil then
    return
  end
  local go
  if self.equipPool[itemdata.id] then
    go = self.equipPool[itemdata.id]
    go:SetActive(true)
  else
    local subType = itemdata.tblItem.subType
    local modelName = RoleEquipUtility.GetEquipUIModelName(itemdata)
    local path = ModelConfig.GetCommentModelPath(subType, modelName)
    local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
    Coroutine.Yield(request)
    if request.isError then
      logError(request.error)
      Coroutine.Break()
    end
    go = Instantiate(request.res)
    self.equipPool[itemdata.id] = go
  end
  if ForgeData.SelectEquipPos == TransferEquipType.firstEquip then
    self.LoadEquipObjectFirst = go
    return ItemUtility.SetModelTransform(go, self.fisrtframe.transform, itemdata, 1, 400)
  elseif ForgeData.SelectEquipPos == TransferEquipType.secondEquip then
    self.LoadEquipObjectSecondE = go
    return ItemUtility.SetModelTransform(go, self.fisrtframe.transform, itemdata, 1, 400)
  end
end

function Equip_ForgeNavUi:SetItemIcon(itemId, obj, count)
  local cfgItem = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  local itemData = ItemUtility.GenerateItemData(itemId)
  itemData.count = count
  local itemCtr = ItemUtility.ShowItem(self, obj, itemData, true)
  if not cfgItem then
    return
  end
  local bagCount = BagInfoData.GetItemCountByItemConfigId(cfgItem.id)
  local strColor = bagCount >= tonumber(count) and "#00FF00" or "#FF0000"
  local countStr = string.format("%d/%d", bagCount, count)
  itemCtr.countCtr:SetText(string.GetColorText(countStr, strColor))
end

function Equip_ForgeNavUi:ToggleInit()
  for i, v in pairs(self.togObj) do
    if i == self.curUIId then
      v.toggle.isOn = true
    else
      v.toggle.isOn = false
    end
  end
  self.toggleInited = false
end

function Equip_ForgeNavUi:SetFirstUIID()
  local toggleControl, targetUIID
  local isFirst = true
  for i, v in pairs(self.togRuler) do
    toggleControl = self.togObj[v]
    if toggleControl:GetActive() and not IsNil(toggleControl.gameObject) then
      if isFirst then
        targetUIID = v
        isFirst = false
      end
      if RedPointManager:GetCacheStateByPath("Equip_ForgeNavUi#" .. toggleControl.transform.name) then
        targetUIID = v
        break
      end
    end
  end
  EquipeInfoData.curView = targetUIID
  self.curUIId = targetUIID
  UIManager.Show(targetUIID, {resetLogic = 1})
end
