Puzzle_JH_JinjieUI = class(BaseUI)
Puzzle_JH_JinjieUI.layer = UILayer.Panel
Puzzle_JH_JinjieUI.orderInLayer = 0
Puzzle_JH_JinjieUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_JinjieUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_JinjieUI.escClose = UIEscClose.DontClose

function Puzzle_JH_JinjieUI:InitControls()
  self.img_AdvancedLevel = self:GetControl("bg_equip/img_equipbg/img_intensifylevel")
  self.img_arrow = self:GetControl("bg_equip/img_equipbg/img_arrow")
  self.img_AdvancedLevelNext = self:GetControl("bg_equip/img_equipbg/img_intensifylevelnext")
  self.btn_Advanced = self:GetControl("bg_equip/RunesIntensify/btn_intensify")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.frame_item = self:GetControl("bg_equip/RunesIntensify/needMaterial/materialParent/frame_item")
  self.RunesIntensify = self:GetControl("bg_equip/RunesIntensify")
  self.img_equipbg = self:GetControl("bg_equip/img_equipbg")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
end

function Puzzle_JH_JinjieUI:Init()
end

function Puzzle_JH_JinjieUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Puzzle_JH_JinjieUI:InitUI()
  self:InitControlList()
  self.costContainer = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.Puzzle_JH_CostTemplate, self)
end

function Puzzle_JH_JinjieUI:InitControlList()
  self.pedestalPointTemplateTab = {}
  local pedestalPointTab = CrystalNucleusManager:GetPedestalPointTab()
  if pedestalPointTab == nil or next(pedestalPointTab) == nil then
    return
  end
  for i = 1, #pedestalPointTab do
    for j = 1, #pedestalPointTab[i] do
      local point, pointIndex = pedestalPointTab[i][j], pedestalPointTab[i][j].m_Index
      if point == nil then
        return
      end
      local control, template = (self:GetControl(string.format("bg_equip/CrystalNucleus/crystalNucleus_%s", pointIndex)))
      if control then
        template = luaTemplateManager.GetNewTemplate(control, LuaComponentTemplates.CrystalNucleusPedestalAdvancedItemPointTemplate, self)
      end
      self.pedestalPointTemplateTab[pointIndex] = template
    end
  end
end

function Puzzle_JH_JinjieUI:RegistUIEvents()
  self.btn_Advanced:SetOnClick(self, self.btn_AdvancedOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Puzzle_JH_JinjieUI:btn_AdvancedOnClick()
  if self.puzzleHoleConfig == nil then
    return
  end
  local costInfo = ParseUtility.ParsShopSingleCost(self.puzzleHoleConfig.cost)
  if costInfo == nil or table.count(costInfo) == 0 then
    return
  end
  local isCan, itemId = true
  for i, v in pairs(costInfo) do
    if v and v.itemId and v.count then
      local bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
      if bagCount < v.count then
        itemId = v.itemId
        isCan = false
        break
      end
    end
  end
  if isCan then
    CrystalNucleusPointController.ReqUnLockDisk()
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_kongweijiesuo",
        effectTime = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_kongweijiesuo",
        effectTime = 1
      })
    end
  else
    if itemId == nil then
      return
    end
    local temp = {}
    temp.itemData = ItemUtility.GenerateItemData(itemId)
    UIManager.Show(UIID.ItemTipUI, {
      item = temp.itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = temp,
      ShowObtain = true
    })
  end
end

function Puzzle_JH_JinjieUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Puzzle_JH_JinjieUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Puzzle_JH_JinjieUI:btn_closeOnClick()
  UIManager.Hide(UIID.Puzzle_JH_JinjieUI)
end

function Puzzle_JH_JinjieUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_JinjieUI:RegistEvents()
  self:RegistEvent(Event.CrystalNucleusPedestalChange, self.Refresh, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Refresh, self)
end

function Puzzle_JH_JinjieUI:Refresh()
  self:RefreshData()
  self:RefreshView()
  self:RefreshCrystalNucleusPedestal()
  self:RefreshAdvancedLevel()
  self:RefreshCost()
end

function Puzzle_JH_JinjieUI:RefreshData()
  self.currentLevel = CrystalNucleusManager:GetPedestalLevel()
  self.maxLevel = true
  self.puzzleHoleConfig = nil
  local puzzleHoleConfig = ClientTable.cfg_puzzle_holeManager:TryGetValue(self.currentLevel + 1)
  if puzzleHoleConfig == nil or string.isNullOrEmpty(puzzleHoleConfig.cost) then
    return
  end
  self.puzzleHoleConfig = puzzleHoleConfig
  self.maxLevel = false
end

function Puzzle_JH_JinjieUI:RefreshCrystalNucleusPedestal()
  if self.pedestalPointTemplateTab == nil then
    return
  end
  for index, v in ipairs(self.pedestalPointTemplateTab) do
    v:Refresh(CrystalNucleusManager:GetPedestalPointByIndex(index), self)
  end
end

function Puzzle_JH_JinjieUI:RefreshAdvancedLevel()
  self.img_AdvancedLevel:SetText(self.currentLevel)
  self.img_AdvancedLevelNext:SetText(self.maxLevel and self.currentLevel or self.currentLevel + 1)
end

function Puzzle_JH_JinjieUI:RefreshCost()
  if self.puzzleHoleConfig == nil then
    return
  end
  local costInfo = ParseUtility.ParsShopSingleCost(self.puzzleHoleConfig.cost)
  self.costContainer:SetData(costInfo)
end

function Puzzle_JH_JinjieUI:RefreshView()
  self.img_AdvancedLevel:SetActive(not self.maxLevel)
  self.img_arrow:SetActive(not self.maxLevel)
  self.RunesIntensify:SetActive(not self.maxLevel)
  self.Img_maxlevel:SetActive(self.maxLevel)
end

function Puzzle_JH_JinjieUI:OnHide()
end

function Puzzle_JH_JinjieUI:OnDestroy()
end
