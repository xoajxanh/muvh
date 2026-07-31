Tip_CommonTipsUI = class(BaseUI)
Tip_CommonTipsUI.layer = UILayer.Tip
Tip_CommonTipsUI.orderInLayer = 0
Tip_CommonTipsUI.hideType = UIHideType.WaitDestroy
Tip_CommonTipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_CommonTipsUI.escClose = UIEscClose.DontClose

function Tip_CommonTipsUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Intensify = self:GetControl("Intensify")
  self.IntensifyScroll_Master = self:GetControl("Intensify/IntensifyScroll_Master")
  self.btn_IntensifyMasterClose = self:GetControl("Intensify/IntensifyScroll_Master/btn_IntensifyMasterClose")
  self.item_IntensifyMaster = self:GetControl("Intensify/IntensifyScroll_Master/Viewport/Content/item_IntensifyMaster")
  self.Zhuijia = self:GetControl("Zhuijia")
  self.ZhuijiaScroll_Master = self:GetControl("Zhuijia/ZhuijiaScroll_Master")
  self.btn_ZhuijiaMasterClose = self:GetControl("Zhuijia/ZhuijiaScroll_Master/btn_ZhuijiaMasterClose")
  self.item_ZhuijiaMaster = self:GetControl("Zhuijia/ZhuijiaScroll_Master/Viewport/Content/item_ZhuijiaMaster")
  self.Gem = self:GetControl("Gem")
  self.Scroll_Gem = self:GetControl("Gem/Scroll_Gem")
  self.btn_masterClose = self:GetControl("Gem/Scroll_Gem/btn_masterClose")
  self.lab_stone = self:GetControl("Gem/Scroll_Gem/Viewport/Content/three_stone/three_content/lab_stone")
  self.all_content = self:GetControl("Gem/Scroll_Gem/Viewport/Content/all_stone/all_content")
  self.lab_stoneAdd = self:GetControl("Gem/Scroll_Gem/Viewport/Content/all_stone/all_content/lab_stoneAdd")
  self.RedIntensify = self:GetControl("RedIntensify")
  self.RedIntensifyScroll_Master = self:GetControl("RedIntensify/RedIntensifyScroll_Master")
  self.item_RedIntensifyMaster = self:GetControl("RedIntensify/RedIntensifyScroll_Master/Viewport/Content/item_RedIntensifyMaster")
  self.Runes = self:GetControl("Runes")
  self.Couture = self:GetControl("Couture")
  self.RedIntensifyScroll_Master = self:GetControl("RedIntensify/RedIntensifyScroll_Master")
  self.item_RuneMaster = self:GetControl("Runes/RunesScroll_Master/Scroll_Runes/Viewport/Content/lab_runesAdd")
  self.item_Couture = self:GetControl("Couture/CoutureScroll/Scroll_Couture/Viewport/Content/lab_coutureAdd")
  self.content_Intensify = self:GetControl("Intensify/IntensifyScroll_Master/Viewport/Content")
  self.content_Zhuijia = self:GetControl("Zhuijia/ZhuijiaScroll_Master/Viewport/Content")
  self.content_RedIntensify = self:GetControl("RedIntensify/RedIntensifyScroll_Master/Viewport/Content")
  self.img_obj = self:GetControl("Intensify/img_obj")
  self.HolySkeleton = self:GetControl("HolySkeleton")
  self.lab_skeletonAdd = self:GetControl("HolySkeleton/SkeletonScroll_Master/Scroll_HolySkeleton/Viewport/Content/lab_skeletonAdd")
  self.crystalNucleusAttribute = self:GetControl("crystalNucleusAttribute")
  self.item_AttributeMaster = self:GetControl("crystalNucleusAttribute/attributeScroll_Master/Viewport/Content/item_AttributeMaster")
  self.crystalNucleusSkill = self:GetControl("crystalNucleusSkill")
  self.lab_crystalSkillTip = self:GetControl("crystalNucleusSkill/attributeScroll_Master/tip")
  self.Tip_ModelShow = self:GetControl("crystalNucleusSkill/Img_TipBg/sv_center/Viewport/Content/Tip_ModelShow")
end

function Tip_CommonTipsUI:Init()
end

function Tip_CommonTipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:InitData()
  self:RegistUIEvents()
end

local function OnItemMaterInit(control)
end

local function OnItemIntensifyMaterRefresh(ctr, _, data, ui)
  local lab_name = ctr:GetChild("lab_equipcount")
  local lab_attribute = ctr:GetChild("lab_activeattribute")
  local name, attribute
  local value = data.extraIntensifyAttributeIncrease / 100
  local percent = math.floor(value * 10 + 0.5) / 10
  if ui:IsCompleteIntensify(data.index, data.goalCount) then
    name = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster1"), ItemQuality2ColorDic[EItemColorEnum.white])
    name = string.format(name, string.GetColorText(data.goalCount, ItemQuality2ColorDic[EItemColorEnum.green]))
    attribute = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster2"), ItemQuality2ColorDic[EItemColorEnum.white])
    attribute = string.format(attribute, string.GetColorText(percent, ItemQuality2ColorDic[EItemColorEnum.yellow]), string.GetColorText("%", ItemQuality2ColorDic[EItemColorEnum.yellow]))
  else
    name = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster1"), data.goalCount), ItemQuality2ColorDic[EItemColorEnum.dark])
    attribute = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster2"), percent, "%"), ItemQuality2ColorDic[EItemColorEnum.dark])
  end
  ctr:GetChild("lab_bg"):SetActive(_ % 2 == 1)
  lab_name:SetText(name)
  lab_attribute:SetText(attribute)
end

local function OnItemZhuijiaMaterRefresh(ctr, _, data, ui)
  local lab_name = ctr:GetChild("lab_equipcount")
  local lab_attribute = ctr:GetChild("lab_activeattribute")
  local name, attribute
  local value = data.extraAdditionalAttributeIncrease / 100
  local percent = math.floor(value * 10 + 0.5) / 10
  if ui:IsCompleteIntensify(data.index, data.goalCount) then
    name = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster3"), ItemQuality2ColorDic[EItemColorEnum.white])
    name = string.format(name, string.GetColorText(data.goalCount, ItemQuality2ColorDic[EItemColorEnum.green]))
    attribute = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster4"), ItemQuality2ColorDic[EItemColorEnum.white])
    attribute = string.format(attribute, string.GetColorText(percent, ItemQuality2ColorDic[EItemColorEnum.yellow]), string.GetColorText("%", ItemQuality2ColorDic[EItemColorEnum.yellow]))
  else
    name = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster3"), data.goalCount), ItemQuality2ColorDic[EItemColorEnum.dark])
    attribute = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster4"), percent, "%"), ItemQuality2ColorDic[EItemColorEnum.dark])
  end
  ctr:GetChild("lab_bg"):SetActive(_ % 2 == 1)
  lab_name:SetText(name)
  lab_attribute:SetText(attribute)
end

local function OnItemIntensifySuitMaterRefresh(ctr, _, data, ui)
  local lab_name = ctr:GetChild("lab_equipcount")
  local lab_attribute = ctr:GetChild("lab_activeattribute")
  local name, attribute
  local value = data.extraRedAttributeIncrease / 100
  local percent = math.floor(value * 10 + 0.5) / 10
  if ui:IsCompleteIntensify(data.index, data.goalCount) then
    name = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster41"), ItemQuality2ColorDic[EItemColorEnum.white])
    name = string.format(name, string.GetColorText(data.goalCount, ItemQuality2ColorDic[EItemColorEnum.green]))
    attribute = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster42"), ItemQuality2ColorDic[EItemColorEnum.white])
    attribute = string.format(attribute, string.GetColorText(percent, ItemQuality2ColorDic[EItemColorEnum.yellow]), string.GetColorText("%", ItemQuality2ColorDic[EItemColorEnum.yellow]))
  else
    name = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster41"), data.goalCount), ItemQuality2ColorDic[EItemColorEnum.dark])
    attribute = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster42"), percent, "%"), ItemQuality2ColorDic[EItemColorEnum.dark])
  end
  ctr:GetChild("lab_bg"):SetActive(_ % 2 == 1)
  lab_name:SetText(name)
  lab_attribute:SetText(attribute)
end

local function OnItemRuneSuitMaterInit(control)
  control.lab_name_water = UIControl(control.transform, "lab_name_water")
  control.txt_tip = UIControl(control.transform, "txt_tip")
  control.lab_des_water = UIControl(control.transform, "lab_des_water")
  control.btn_Breach = UIControl(control.transform, "btn_Breach")
end

local function OnItemRuneSuitMaterRefresh(ctr, _, data, ui)
  if data == nil and data.suitDes == nil then
    return
  end
  local desTab = {}
  if data.suitAttributeDes and table.count(data.suitAttributeDes) > 0 then
    for i, v in pairs(data.suitAttributeDes) do
      table.insert(desTab, v)
    end
  end
  if data.suitSkillDes and 0 < table.count(data.suitSkillDes) then
    for i, v in pairs(data.suitSkillDes) do
      table.insert(desTab, v)
    end
  end
  ctr.lab_des_water:SetText(table.concat(desTab, "\n"))
  ctr.lab_name_water:SetText(data.suitName .. string.format(" (%d/%d)", data.haveCount, data.haveCount))
  ctr.txt_tip:SetActive(true)
end

local function OnItemCoutureInit(control)
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_value = UIControl(control.transform, "lab_value")
end

local function OnItemCoutureRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local showvalue = data.min
  if data.max ~= 0 and data.max ~= nil then
    showvalue = data.min .. " - " .. data.max
  end
  ctr.lab_name:SetText(data.name)
  ctr.lab_value:SetText(showvalue)
end

local function OnItemHolySkeletonInit(control)
  control.Model = UIControl(control.transform, "Model")
  control.lab_name_water = UIControl(control.transform, "lab_name_water")
  control.lab_des_water = UIControl(control.transform, "lab_des_water")
  control.txt_tip = UIControl(control.transform, "txt_tip")
  control.btn_Breach = UIControl(control.transform, "btn_Breach")
  control.holySkeletonCellData = ItemCellData()
end

local function OnItemHolySkeletonRefresh(ctr, _, data, ui)
  local SacredBoneEquip = data.SacredBoneData[1].SacredBoneEquip
  if ctr.holySkeletonCellData then
    ItemUtility.HideItemCell(ctr.Model, ctr.holySkeletonCellData)
  end
  if SacredBoneEquip ~= nil then
    local itemData = ItemUtility.GenerateItemData(SacredBoneEquip.ItemId)
    if itemData then
      ctr.holySkeletonCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(ctr.Model, ctr.holySkeletonCellData, ui, false)
    end
    ctr.btn_Breach:SetActive(false)
    ctr.lab_des_water:SetText(SacredBoneEquip.SacredBoneAttribute)
  else
    ctr.lab_des_water:SetText("")
    ctr.btn_Breach:SetActive(true)
  end
  ctr.lab_name_water:SetText(data.SacredBoneName)
end

local function OnItemAttributeMasterOnInit(control)
  control.lab_leftattribute = UIControl(control.transform, "lab_attribute")
end

local function OnItemAttributeMasterOnRefresh(ctr, _, data, ui)
  if data == nil or not data.minValue then
    return
  end
  local color = ItemQuality2ColorDic[3]
  if data.excellType == 2 then
    color = ItemQuality2ColorDic[1]
  end
  if data.maxValue == 0 then
    ctr.lab_leftattribute:SetText(string.GetColorText(data.name .. " +" .. data.puzzleValue .. data.minValue .. data.type, color))
  else
    ctr.lab_leftattribute:SetText(string.GetColorText(data.name .. " +" .. data.puzzleValue .. data.minValue .. data.type .. "~" .. data.puzzleValue .. data.maxValue .. data.type, color))
  end
end

local function OnItemCrystalNucleusSkillInit(control)
  control.lab_skill = UIControl(control.transform, "img_skill_ground/lab_skill")
  control.lab_require = UIControl(control.transform, "img_skill_ground/lab_require")
  control.lab_skillDescription = UIControl(control.transform, "lab_skillDescription")
end

local function OnItemCrystalNucleusSkillOnRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local color = ItemQuality2ColorDic[10]
  local skill = ClientTable.cfg_Skill_skillManager:TryGetValue(data.skillid)
  if skill and skill.level <= ui.skillLevel then
    color = ItemQuality2ColorDic[5]
  end
  ctr.lab_skill:SetText(string.GetColorText(data.skillName, color))
  local typeRequire = ClientTable.cfg_Item_tipsManager:TryGetValue(data.requireDescription)
  if typeRequire then
    ctr.lab_require:SetText(string.GetColorText(typeRequire.content, color))
  end
  local skillDes = ClientTable.cfg_Item_tipsManager:TryGetValue(data.skillid)
  if skillDes then
    ctr.lab_skillDescription:SetText(string.GetColorText(skillDes.content, color))
  end
end

function Tip_CommonTipsUI:InitUI()
  self.itemIntensifyMasterContain = UIContainer(self.item_IntensifyMaster, self, OnItemMaterInit, OnItemIntensifyMaterRefresh)
  self.itemZhuijiaMasterContain = UIContainer(self.item_ZhuijiaMaster, self, OnItemMaterInit, OnItemZhuijiaMaterRefresh)
  self.gemCombinesTemplate = UIUtility.BindUIContainerTemp(self.lab_stoneAdd, LuaComponentTemplates.GemCombineEffectTemplate, self)
  self.itemIntensifySuitMasterContain = UIContainer(self.item_RedIntensifyMaster, self, OnItemMaterInit, OnItemIntensifySuitMaterRefresh)
  self.itemRuneSuitMasterContain = UIContainer(self.item_RuneMaster, self, OnItemRuneSuitMaterInit, OnItemRuneSuitMaterRefresh)
  self.itemCoutureMasterContain = UIContainer(self.item_Couture, self, OnItemCoutureInit, OnItemCoutureRefresh)
  self.itemHolySkeletonMasterContain = UIContainer(self.lab_skeletonAdd, self, OnItemHolySkeletonInit, OnItemHolySkeletonRefresh)
  self.itemAttributeMaster = UIContainer(self.item_AttributeMaster, self, OnItemAttributeMasterOnInit, OnItemAttributeMasterOnRefresh)
  self.itemCrystalNucleusSkill = UIContainer(self.Tip_ModelShow, self, OnItemCrystalNucleusSkillInit, OnItemCrystalNucleusSkillOnRefresh)
end

function Tip_CommonTipsUI:InitData()
  local w, h = self.img_obj:GetSizeDelta()
  self.maxHigh = h
  self.cellSizeHighGroup = {
    [CommonTipsEnum.Intensify] = self.content_Intensify.layoutGroup.cellSize.y,
    [CommonTipsEnum.Zhuijia] = self.content_Zhuijia.layoutGroup.cellSize.y,
    [CommonTipsEnum.Intensify_Suit] = self.content_RedIntensify.layoutGroup.cellSize.y
  }
end

function Tip_CommonTipsUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
end

function Tip_CommonTipsUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Tip_CommonTipsUI)
end

function Tip_CommonTipsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_CommonTipsUI:RegistEvents()
end

function Tip_CommonTipsUI:Refresh()
  self.showType = self.args.showType
  if self.showType == CommonTipsEnum.Intensify then
    self:RefreshIntensifyMasterPanel()
  elseif self.showType == CommonTipsEnum.Zhuijia then
    self:RefreshZhuaijiaMasterPanel()
  elseif self.showType == CommonTipsEnum.Gem then
    self:RefreshGemInfoPanel()
  elseif self.showType == CommonTipsEnum.Intensify_Suit then
    self:RefreshIntensifySuitPanel()
  elseif self.showType == CommonTipsEnum.Rune then
    self:RefreshRuneSuitPanel()
  elseif self.showType == CommonTipsEnum.Couture then
    self:RefreshCouturePanel()
  elseif self.showType == CommonTipsEnum.HolySkeleton then
    self:RefreshHolySkeletonMaster()
  elseif self.showType == CommonTipsEnum.CrystalNucleusAttribute then
    self:RefreshAttributeMaster()
  elseif self.showType == CommonTipsEnum.CrystalNucleusSkill then
    self:RefreshCrystalNucleusSkill()
  end
end

function Tip_CommonTipsUI:OnHide()
  self.Intensify:SetActive(false)
  self.Zhuijia:SetActive(false)
  self.Gem:SetActive(false)
  self.RedIntensify:SetActive(false)
  self.Runes:SetActive(false)
  self.Couture:SetActive(false)
  self.HolySkeleton:SetActive(false)
  self.crystalNucleusAttribute:SetActive(false)
  self.crystalNucleusSkill:SetActive(false)
  self:TryCloseSkill_SkillPreviewUI()
  self.skillLevel = 0
end

function Tip_CommonTipsUI:TryCloseSkill_SkillPreviewUI()
  if self.showType == CommonTipsEnum.Rune then
    if UIManager.IsVisible(UIID.Skill_SkillPreviewUI) then
      UIManager.Hide(UIID.Skill_SkillPreviewUI)
    end
  elseif self.showType == CommonTipsEnum.HolySkeleton and UIManager.IsVisible(UIID.Skill_SkillPreviewUI) then
    UIManager.Hide(UIID.Skill_SkillPreviewUI)
  end
end

function Tip_CommonTipsUI:OnDestroy()
end

function Tip_CommonTipsUI:RefreshIntensifyMasterPanel()
  local intensifyMasterData = self:GetMasterData()
  self.itemIntensifyMasterContain:SetData(intensifyMasterData)
  local w, h = self.IntensifyScroll_Master:GetSizeDelta()
  local _, offset = self.IntensifyScroll_Master:GetChild("txt_title"):GetSizeDelta()
  local high = self.cellSizeHighGroup[self.showType] * table.count(intensifyMasterData) + offset
  if high > self.maxHigh then
    high = self.maxHigh
  end
  self.IntensifyScroll_Master:SetSizeDelta(w, high)
  self.Intensify:SetActive(true)
end

function Tip_CommonTipsUI:RefreshZhuaijiaMasterPanel()
  local zhuijiaMasterData = self:GetMasterData()
  self.itemZhuijiaMasterContain:SetData(zhuijiaMasterData)
  local w, h = self.ZhuijiaScroll_Master:GetSizeDelta()
  local _, offset = self.ZhuijiaScroll_Master:GetChild("txt_title"):GetSizeDelta()
  local high = self.cellSizeHighGroup[self.showType] * table.count(zhuijiaMasterData) + offset
  if high > self.maxHigh then
    high = self.maxHigh
  end
  self.ZhuijiaScroll_Master:SetSizeDelta(w, high)
  self.Zhuijia:SetActive(true)
end

function Tip_CommonTipsUI:RefreshGemInfoPanel()
  local gemCombineEffectData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetGemCombineTblList()
  self.gemCombinesTemplate:SetData(gemCombineEffectData)
  self.Gem:SetActive(true)
end

function Tip_CommonTipsUI:RefreshIntensifySuitPanel()
  local intensifySuitMasterData = self:GetMasterData()
  self.itemIntensifySuitMasterContain:SetData(intensifySuitMasterData)
  local w, h = self.RedIntensifyScroll_Master:GetSizeDelta()
  local _, offset = self.RedIntensifyScroll_Master:GetChild("txt_title"):GetSizeDelta()
  local high = self.cellSizeHighGroup[self.showType] * table.count(intensifySuitMasterData) + offset
  if high > self.maxHigh then
    high = self.maxHigh
  end
  self.RedIntensifyScroll_Master:SetSizeDelta(w, high)
  self.RedIntensify:SetActive(true)
end

function Tip_CommonTipsUI:RefreshRuneSuitPanel()
  self.itemRuneSuitMasterContain:SetData(self:GetRuneMasterData())
  self.Runes:SetActive(true)
end

function Tip_CommonTipsUI:RefreshCouturePanel()
  local data = gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():GetAllAttributeInfo()
  self.itemCoutureMasterContain:SetData(data)
  self.Couture:SetActive(true)
end

function Tip_CommonTipsUI:RefreshHolySkeletonMaster()
  local sacredBoneSpecialData = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetSacredBone()
  self.HolySkeleton:SetActive(true)
  self.itemHolySkeletonMasterContain:SetData(sacredBoneSpecialData)
end

function Tip_CommonTipsUI:RefreshAttributeMaster()
  local data = {}
  local EquipTab = CrystalNucleusManager:GetCrystalNucleusEquipTab()
  if EquipTab then
    for i, v in pairs(EquipTab) do
      table.insert(data, v)
    end
  end
  if table.count(data) <= 0 then
    self.crystalNucleusAttribute:SetActive(true)
    self.itemAttributeMaster:SetData()
    return
  end
  self.puzzleData = nil
  for i, v in ipairs(data) do
    for j, k in pairs(v.m_ServerInfo.nucleusAttr) do
      local puzzle_entry = ClientTable.cfg_puzzle_entry_levelupManager:GetGrowUpLevel(k, v.m_ServerInfo.nucleusLevel)
      self:SetAttributeName(puzzle_entry)
    end
  end
  self.crystalNucleusAttribute:SetActive(true)
  local puzzleAttributeData = {}
  for k, v in pairs(self.puzzleData) do
    table.insert(puzzleAttributeData, v)
  end
  table.sort(puzzleAttributeData, function(a, b)
    return a.excellType < b.excellType
  end)
  self.itemAttributeMaster:SetData(puzzleAttributeData)
end

function Tip_CommonTipsUI:SetAttributeName(puzzle)
  local puzzleType, puzzleValue = "", ""
  local minValue, maxValue, name
  minValue, maxValue, name, puzzleType, puzzleValue = CrystalNucleusUtility:CheckEntryTableHaveValue(puzzle)
  maxValue = maxValue or 0
  if not self.puzzleData then
    self.puzzleData = {}
  end
  if not self.puzzleData[tonumber(puzzle.contentExcel_ID)] then
    self.puzzleData[tonumber(puzzle.contentExcel_ID)] = {}
  end
  if 0 < table.count(self.puzzleData[tonumber(puzzle.contentExcel_ID)]) then
    self.puzzleData[tonumber(puzzle.contentExcel_ID)] = {
      minValue = self.puzzleData[tonumber(puzzle.contentExcel_ID)].minValue + minValue,
      maxValue = self.puzzleData[tonumber(puzzle.contentExcel_ID)].maxValue + maxValue,
      excellType = puzzle.excellType,
      type = puzzleType,
      puzzleValue = puzzleValue,
      name = name
    }
  else
    self.puzzleData[tonumber(puzzle.contentExcel_ID)] = {
      minValue = minValue,
      maxValue = maxValue,
      excellType = puzzle.excellType,
      type = puzzleType,
      puzzleValue = puzzleValue,
      name = name
    }
  end
end

function Tip_CommonTipsUI:RefreshCrystalNucleusSkill()
  self.skillLevel = 0
  local skillData = ClientTable.cfg_puzzle_skillManager:GetDic()
  if skillData then
    for i, v in ipairs(skillData) do
      local isSkill = false
      for j, k in ipairs(ViewData.meData.allSkills) do
        if k.sid == v.skillid then
          self.skillLevel = k.level
          isSkill = true
          break
        end
      end
      if isSkill then
        break
      end
    end
  end
  local data = {}
  local count = 0
  if self.skillLevel + 5 >= table.count(skillData) then
    count = table.count(skillData)
  else
    count = self.skillLevel + 5
  end
  for i = self.skillLevel, count do
    table.insert(data, skillData[i])
  end
  self.crystalNucleusSkill:SetActive(true)
  self.itemCrystalNucleusSkill:SetData(data)
  self.lab_crystalSkillTip:SetText("\229\189\147\229\137\141\230\138\128\232\131\189\239\188\154Lv" .. self.skillLevel)
end

function Tip_CommonTipsUI:GetMasterData()
  local Tab = ClientTable.cfg_Equip_masterManager:GetDic()
  local dataTab = {}
  for k, v in ipairs(Tab) do
    if string.contains(v.career, RoleUtility.GetBasicCareer(RoleManager.me.career)) and v.type == self.showType then
      table.insert(dataTab, v)
      if not self:IsCompleteIntensify(v.index, v.goalCount) then
        return dataTab
      end
    end
  end
  return dataTab
end

function Tip_CommonTipsUI:IsCompleteIntensify(bagIndex, level)
  local strTab = string.split(bagIndex, "#")
  local totalLevel = 0
  local equipData = ViewData.meData.equipsData.Data
  for i = 1, table.count(strTab) do
    if (self.showType == CommonTipsEnum.Intensify or self.showType == CommonTipsEnum.Intensify_Suit) and equipData[tonumber(strTab[i])] and equipData[tonumber(strTab[i])].intensify then
      totalLevel = totalLevel + equipData[tonumber(strTab[i])].intensify
    elseif self.showType == CommonTipsEnum.Zhuijia and equipData[tonumber(strTab[i])] and equipData[tonumber(strTab[i])].additional then
      totalLevel = totalLevel + equipData[tonumber(strTab[i])].additional
    end
  end
  return level <= totalLevel
end

function Tip_CommonTipsUI:GetRuneMasterData()
  local Tab = ClientTable.cfg_Item_equip_runesSuitManager:GetDic()
  local dataTab = {}
  for id, itemCfg in ipairs(Tab) do
    if MeRunneController:GetSuitActiveState(id, true) then
      itemCfg.haveCount = itemCfg.actNum
      itemCfg.suitAttributeDes = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetSuitAttributeDes(itemCfg)
      itemCfg.suitSkillDes = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetSuitSkillDes(itemCfg)
      table.insert(dataTab, itemCfg)
    end
  end
  return dataTab
end
