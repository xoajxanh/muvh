Equip_RegenerateUI = class(BaseUI)
Equip_RegenerateUI.layer = UILayer.Panel
Equip_RegenerateUI.orderInLayer = 0
Equip_RegenerateUI.hideType = UIHideType.WaitDestroy
Equip_RegenerateUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RegenerateUI.escClose = UIEscClose.DontClose
local evolutionBol

function Equip_RegenerateUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.go_regenerate = self:GetControl("regeneratePanel/go_regenerate")
  self.lab_reOldItem = self:GetControl("regeneratePanel/go_regenerate/lab_attributeOld/Verwport/content/lab_reOldItem")
  self.lab_reNewItem = self:GetControl("regeneratePanel/go_regenerate/lab_attributeNew/Verwport/content/lab_reNewItem")
  self.btn_masterattribute = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute")
  self.Scroll_Master = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master")
  self.btn_closeBg2 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/btn_closeBg2")
  self.item_master1 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master1")
  self.item_master2 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master2")
  self.item_master3 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master3")
  self.item_master4 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master4")
  self.item_master5 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master5")
  self.item_master6 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master6")
  self.item_master7 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master7")
  self.item_master8 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master8")
  self.item_master9 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master9")
  self.item_master91 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master91")
  self.item_master10 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master10")
  self.item_master11 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master11")
  self.item_master12 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master12")
  self.item_master13 = self:GetControl("regeneratePanel/go_regenerate/btn_masterattribute/Scroll_Master/Viewport/Content/Content1/item_master13")
  self.go_evolution = self:GetControl("evolutionPanel/go_evolution")
  self.img_successrate = self:GetControl("evolutionPanel/go_evolution/img_successrate")
  self.img_successratetxt = self:GetControl("evolutionPanel/go_evolution/img_successrate/img_successratetxt")
  self.img_intensifylevel = self:GetControl("evolutionPanel/go_evolution/img_equipbg/img_intensifylevel")
  self.img_intensifylevelnext = self:GetControl("evolutionPanel/go_evolution/img_equipbg/img_intensifylevelnext")
  self.img_arrow = self:GetControl("evolutionPanel/go_evolution/img_equipbg/img_arrow")
  self.lab_evolutionAtt = self:GetControl("evolutionPanel/go_evolution/lab_evolutionAtt")
  self.lab_EvolutionItem = self:GetControl("evolutionPanel/go_evolution/lab_attributeEvolution/Verwport/content/lab_EvolutionItem")
  self.frame_equip = self:GetControl("regeneratePanel/bg_regenerate/frame_equip")
  self.frame_evoluequip = self:GetControl("evolutionPanel/bg_evolution/frame_equip")
  self.regenerateBtn_3DItem = self:GetControl("regeneratePanel/btn_3DItem")
  self.evolutionBtn_3DItem = self:GetControl("evolutionPanel/btn_3DItem")
  self.lab_material = self:GetControl("regeneratePanel/bg_regenerate/lab_material")
  self.lab_evolmaterial = self:GetControl("evolutionPanel/bg_evolution/lab_material")
  self.frame_item = self:GetControl("regeneratePanel/bg_regenerate/lab_material/materialParent/frame_item")
  self.frame_evoluitem = self:GetControl("evolutionPanel/bg_evolution/lab_material/materialParent/frame_item")
  self.bg_regenerate = self:GetControl("regeneratePanel/bg_regenerate")
  self.btn_regenerate = self:GetControl("regeneratePanel/bg_regenerate/btn_regenerate")
  self.lab_item = self:GetControl("bg_item/lab_item")
  self.btn_replace = self:GetControl("regeneratePanel/bg_regenerate/btn_replace")
  self.btn_evolution = self:GetControl("evolutionPanel/bg_evolution/btn_evolution")
  self.bg_evolution = self:GetControl("evolutionPanel/bg_evolution")
  self.noRegenerate = self:GetControl("regeneratePanel/noRegenerate")
  self.descBtn = self:GetControl("descBtn")
  self.btn_role = self:GetControl("panel_regenerate/btn_role")
  self.btn_bag = self:GetControl("panel_evolution/btn_bag")
  self.Img_noequip = self:GetControl("Img_noequip")
  self.plane_top = self:GetControl("Img_noequip/plane_top")
  self.Img_noequip1 = self:GetControl("Img_noequip/Img_noequip1")
  self.btn_close = self:GetControl("btn_close")
  self.regeneratePanel = self:GetControl("regeneratePanel")
  self.evolutionPanel = self:GetControl("evolutionPanel")
end

function Equip_RegenerateUI:Init()
end

function Equip_RegenerateUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RegenerateUI:InitUI()
  self.oldEntrysTemplate = UIUtility.BindUIContainerTemp(self.lab_reOldItem, LuaComponentTemplates.RegenerateEntrysTemplate, self)
  self.newEntrysTemplate = UIUtility.BindUIContainerTemp(self.lab_reNewItem, LuaComponentTemplates.RegenerateNewEntrysTemplate, self)
  self.EvolEntrysTemplate = UIUtility.BindUIContainerTemp(self.lab_EvolutionItem, LuaComponentTemplates.RegenerateNewElouEntryTemplate, self)
  self.EvolutionEntrysTemplate = UIUtility.BindUIContainerTemp(self.lab_evolutionAtt, LuaComponentTemplates.RegenrateNewElouEntryTempateEvo, self)
  self.costTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
  self.costevoluTemplate = UIUtility.BindUIContainerTemp(self.frame_evoluitem, LuaComponentTemplates.ConsumableUnitTemplate, self)
end

function Equip_RegenerateUI:RegistUIEvents()
  self.btn_masterattribute:SetOnClick(self, self.btn_MasterattributeOnClick)
  self.btn_regenerate:SetOnClick(self, self.btn_regenerateOnClick)
  self.btn_replace:SetOnClick(self, self.btn_replaceOnClick)
  self.btn_evolution:SetOnClick(self, self.btn_evolutionOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_role:SetOnToggleChanged(self, self.RoleToggleChanged)
  self.btn_bag:SetOnToggleChanged(self, self.BagToggleChanged)
  self.btn_closeBg2:SetOnClick(self, self.btn_CloseMasterattributeOnClick)
end

function Equip_RegenerateUI:btn_MasterattributeOnClick(control)
  if not self.Scroll_Master:GetActive() then
    self.Scroll_Master:SetActive(true)
  end
end

function Equip_RegenerateUI:btn_CloseMasterattributeOnClick(control)
  if self.Scroll_Master:GetActive() then
    self.Scroll_Master:SetActive(false)
  end
end

function Equip_RegenerateUI:btn_regenerateOnClick(control)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData ~= nil then
    local lackCostItemInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateCost()
    if lackCostItemInfo ~= nil and BagInfoData.GetItemTotalCountByItemId(lackCostItemInfo[1].itemId) < lackCostItemInfo[1].count then
      TipUtility.ShowQuickGetTipPanel(lackCostItemInfo[1].itemId)
      return
    end
    self:SetIsCanReplaceUI(true)
    networkRequest.ReqEquipReGenerate(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData.id, gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetLockConfigId())
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.regene
  })
end

function Equip_RegenerateUI:btn_replaceOnClick(control)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData ~= nil then
    TipUtility.QuickShowPrompt({
      id = PromptWordType.RegenerateAttribute,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
        networkRequest.ReqreplaceEquipReGenerate(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData.id)
      end
    })
  end
end

function Equip_RegenerateUI:btn_evolutionOnClick(control)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData ~= nil then
    local lackCostItemInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateEvolutionCost()
    if lackCostItemInfo ~= nil and BagInfoData.GetItemTotalCountByItemId(lackCostItemInfo[1].itemId) < lackCostItemInfo[1].count then
      TipUtility.ShowQuickGetTipPanel(lackCostItemInfo[1].itemId)
      return
    end
    networkRequest.ReqEquipReEvolution(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData.id)
  end
end

function Equip_RegenerateUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_RegenerateUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_RegenerateUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_RegenerateUI)
end

function Equip_RegenerateUI:RoleToggleChanged()
  if self.btn_role:GetIsOn() then
    self.regeneratePanel:SetActive(true)
    self.evolutionPanel:SetActive(false)
    self:RefreshEquip(self.itemCellData)
  end
end

function Equip_RegenerateUI:BagToggleChanged()
  if self.btn_bag:GetIsOn() then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetNewAttributeList() > 0 then
      self.evolutionPanel:SetActive(true)
      self.regeneratePanel:SetActive(false)
      self:RefreshEquip(self.itemCellData)
    else
      self.btn_role:SetIsOn(true)
      FloatingTipUtility.QuickMsg("Trang B\225\187\139 n\195\160y kh\195\180ng c\195\179 thu\225\187\153c t\195\173nh T\195\161i Sinh kh\195\180ng th\225\187\131 ti\225\186\191n h\195\179a")
    end
  end
end

function Equip_RegenerateUI:OnShow()
  EquipeInfoData.curView = UIID.Equip_RegenerateUI
  self.nowSelectEquipSubType = 0
  self:RegistEvents()
  EventManager.Dispatch(Event.EquipForgeUIChange)
  self.btn_role:SetIsOn(true)
end

function Equip_RegenerateUI:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedregeneEquip, self)
  self:RegistEvent(Event.Equip_RegenerateChange, self.Equip_RegenerateChange, self)
  self:RegistEvent(Event.Equip_RegenerateNewAttributeChange, self.OnEquip_RegenerateNewAttributeChange, self)
  self:RegistEvent(Event.Equip_RegenerateLockStateChange, self.RefreshCost, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshCost, self)
end

function Equip_RegenerateUI:SelectedregeneEquip(id, Data)
  if Data then
    self.Img_noequip:SetActive(false)
    gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():SetRegenerateEquip(Data.equipData)
  else
    self.Img_noequip:SetActive(true)
    if self.newEntrysTemplate then
      self.newEntrysTemplate:SetActiveTable()
    end
    if self.oldEntrysTemplate then
      self.oldEntrysTemplate:SetActiveTable()
    end
  end
end

function Equip_RegenerateUI:Equip_RegenerateChange(id, itemCellData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():ClearAttributeData()
  self:RefreshNewAttributeList()
  self:SetIsCanIsCanRegeneraUI(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():EquipPositionCanRegenerate())
  self:SetIsCanReplaceUI(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetClearAttributeList() > 0)
  self:RefreshEquip(itemCellData)
  self:RefreshEquipName(itemCellData)
  self:SetEquipBasics(itemCellData.itemData)
  self:RefreshTog(itemCellData)
  self:RefreshCost()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.regene
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
end

function Equip_RegenerateUI:RefreshNewAttributeList()
  if self.oldEffectCoroutine then
    Coroutine.Stop(self.oldEffectCoroutine)
  end
  local attributeCount = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetNewAttributeList()
  if 0 < attributeCount then
    self.oldEntrysTemplate:SetData(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetRegenerateNewAttributeTemplateDesList())
    self.oldEntrysTemplate:SetActiveTable()
    
    local function OldRankShowObj()
      for i = 1, attributeCount do
        Coroutine.Wait(0.15)
        local obj = self.oldEntrysTemplate:GetOrCreateItem(i)
        obj:SetActive(true)
      end
    end
    
    self.oldEffectCoroutine = Coroutine.Start(OldRankShowObj, self)
  else
    self.oldEntrysTemplate:SetData(nil)
  end
end

function Equip_RegenerateUI:SetIsCanIsCanRegeneraUI(isCanRegenera)
  self.bg_regenerate:SetActive(isCanRegenera)
  self.noRegenerate:SetActive(not isCanRegenera)
end

function Equip_RegenerateUI:SetIsCanReplaceUI(isCanReplace)
  self.btn_regenerate:SetActive(true)
  self.btn_replace:SetActive(isCanReplace)
  local regenerateUIPos = isCanReplace == true and Vector3(84, -327) or Vector3(0, -327)
  self.btn_regenerate.transform.localPosition = regenerateUIPos
end

function Equip_RegenerateUI:RefreshEquip(itemCellData)
  local itemparent = self.btn_role:GetIsOn() and self.regenerateBtn_3DItem or self.evolutionBtn_3DItem
  if itemparent then
    if self.itemCellData ~= nil then
      ItemUtility.HideItemCell(itemparent, self.itemCellData)
    end
    self.itemCellData = itemCellData
    if self.itemCellData ~= nil then
      ItemUtility.ShowItemCell(itemparent, self.itemCellData, self, true)
    end
  end
end

function Equip_RegenerateUI:RefreshEquipName(itemCellData)
  local strName = itemCellData.itemData.tblEquip.name
  if itemCellData.itemData.intensify and itemCellData.itemData.intensify > 0 then
    strName = string.format("%s +%d", itemCellData.itemData.tblEquip.name, itemCellData.itemData.intensify)
  end
  local titleStr = RoleEquipUtility.GetEquipNameColor(strName, itemCellData.itemData)
  self.lab_item:SetText(titleStr)
end

function Equip_RegenerateUI:RefreshTog(itemCellData)
  if self.nowSelectEquipBagGridIndex ~= itemCellData.itemData.bagGridIndex then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetNewAttributeList() == 0 then
      self.btn_role:SetIsOn(true)
    end
    self.nowSelectEquipBagGridIndex = itemCellData.itemData.bagGridIndex
  end
end

function Equip_RegenerateUI:OnEquip_RegenerateNewAttributeChange()
  if self.newEffectCoroutine then
    Coroutine.Stop(self.newEffectCoroutine)
  end
  local attributeCount = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetClearAttributeList()
  if 0 < attributeCount then
    self.newEntrysTemplate:SetData(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetSortOrNotSortRegenerateClearAttribute())
    self.newEntrysTemplate:SetActiveTable()
    
    local function NewRankShowObj()
      for i = 1, attributeCount do
        Coroutine.Wait(0.15)
        local obj = self.newEntrysTemplate:GetOrCreateItem(i)
        obj:SetActive(true)
      end
    end
    
    self.newEffectCoroutine = Coroutine.Start(NewRankShowObj, self)
  else
    self.newEntrysTemplate:SetData(nil)
  end
end

function Equip_RegenerateUI:SetEquipBasics(EquipData)
  if EquipData.serverInfo == nil then
    return
  end
  self.IntensifyTable = MeEquipController.GetEquipregenerate(EquipData.serverInfo.itemId, EquipData.serverInfo.regenerateLevel or 0)
  if not self.IntensifyTable then
    self.IntensifyTable = MeEquipController.GetEquipregenerate(EquipData.tblItem.subType, EquipData.serverInfo.regenerateLevel or 0)
  end
  self.LastIntensifyTable = MeEquipController.GetEquipregenerate(EquipData.serverInfo.itemId, EquipData.serverInfo.regenerateLevel + 1 or 0)
  if not self.LastIntensifyTable then
    self.LastIntensifyTable = MeEquipController.GetEquipregenerate(EquipData.tblItem.subType, EquipData.serverInfo.regenerateLevel + 1 or 0)
  end
  self.img_intensifylevel:SetText("+" .. EquipData.serverInfo.regenerateLevel)
  self.img_intensifylevelnext:SetActive(self.LastIntensifyTable)
  self.img_arrow:SetActive(self.LastIntensifyTable)
  local EvolutionTable = {1}
  local excellenceListEvol = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetNewAttributeList()
  if 0 < excellenceListEvol then
    self.EvolutionEntrysTemplate:SetData(EvolutionTable)
    self.EvolEntrysTemplate:SetData(gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData:GetRegenerateNewAttributeTemplateDesList())
  end
  local level = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateLevelList(EquipData.tblItem.subType)
  if level > EquipData.serverInfo.regenerateLevel then
    self:SetAttributeInfo()
    self.img_intensifylevelnext:SetText("+" .. EquipData.serverInfo.regenerateLevel + 1)
    self.img_successratetxt:SetActive(true)
    self.img_successrate:SetActive(true)
  else
    self.img_successratetxt:SetActive(false)
    self.img_intensifylevelnext:SetText("")
    self.img_successrate:SetActive(false)
  end
end

function Equip_RegenerateUI:SetAttributeInfo()
  if self.IntensifyTable then
    local rateClient = self.IntensifyTable.rateClient
    if rateClient then
      rateClient = string.format("%d%s", rateClient / 100, "A")
      self.img_successratetxt:SetText(rateClient)
    end
  end
end

function Equip_RegenerateUI:RefreshCost()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData ~= nil then
    local costList = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateEvolutionCost()
    if table.count(costList) == 0 then
      self.lab_evolmaterial:SetActive(false)
      self.btn_evolution:SetActive(false)
    else
      self.lab_evolmaterial:SetActive(true)
      self.btn_evolution:SetActive(true)
      if type(costList) == "table" then
        self.costevoluTemplate:SetData(costList)
      end
    end
    local costList = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateCost()
    if type(costList) == "table" then
      self.costTemplate:SetData(costList)
    end
  end
end

function Equip_RegenerateUI:OnHide()
  gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():ClearAttributeData()
  EquipeInfoData.curView = nil
end
