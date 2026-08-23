Equip_RunesInlayUI = class(BaseUI)
Equip_RunesInlayUI.layer = UILayer.Panel
Equip_RunesInlayUI.orderInLayer = 0
Equip_RunesInlayUI.hideType = UIHideType.WaitDestroy
Equip_RunesInlayUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesInlayUI.escClose = UIEscClose.DontClose

function Equip_RunesInlayUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.btn_Item = self:GetControl("bg_equip/btn_Item")
  self.Runes_Item = self:GetControl("bg_equip/Runes/Runes_Item")
  self.btn_del = self:GetControl("bg_equip/Runes/btn_del")
  self.lab = self:GetControl("bg_equip/RunesAttribute/sw_attributegrow/img_titleico/content/lab")
  self.text_atk = self:GetControl("bg_equip/RunesAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/RunesAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/RunesAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/RunesAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atkimg")
  self.sw_RunesItem = self:GetControl("bg_equip/RunesBag/sw_RunesItem")
  self.btn_3DItem = self:GetControl("bg_equip/RunesBag/sw_RunesItem/Viewport/Content/btn_3DItem")
  self.btn_Inlay = self:GetControl("bg_equip/btn_Inlay")
  self.text_Inlay = self:GetControl("bg_equip/btn_Inlay/text_Inlay")
  self.btn_runesMaster = self:GetControl("bg_equip/btn_runesMaster")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.lb_name = self:GetControl("bg_equip/lb_name")
  self.Runes = self:GetControl("bg_equip/Runes")
  self.effect_runes = self:GetControl("bg_equip/Runes/Effect_runes")
end

function Equip_RunesInlayUI:Init()
end

function Equip_RunesInlayUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RunesInlayUI:InitUI()
  self.runeTempList = {
    [EquipRuneTypeEnum.Left] = luaTemplateManager.GetNewTemplate(self.Runes, LuaComponentTemplates.EquipRuneTemplate)
  }
  self.btn_3DItemTemp = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.EquipBagRuneTemplate, self)
  self.attributeTemp = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.EquipRuneAttributeTemplate, self)
  self.effect = {}
end

function Equip_RunesInlayUI:RegistUIEvents()
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_Inlay:SetOnClick(self, self.btn_InlayOnClick)
  self.btn_runesMaster:SetOnClick(self, self.btn_runesMasterOnClick)
end

function Equip_RunesInlayUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_RunesInlayUI")
  if lvCfg and table.count(lvCfg) > 0 then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_RunesInlayUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_RunesInlayUI)
end

function Equip_RunesInlayUI:btn_InlayOnClick()
  local equipIndex = MeRunneController:GetSelectEquipIndex()
  local selectRune = MeRunneController:GetSelectRuneData()
  local holeType = MeRunneController:GetSelectRuneHoleType()
  if selectRune and equipIndex and holeType then
    networkRequest.ReqInlayReplaceRune(selectRune.id, equipIndex, holeType)
  else
    FloatingTipUtility.QuickMsg("H\195\163y ch\225\187\141n Ph\195\185 V\196\131n")
  end
end

function Equip_RunesInlayUI:btn_runesMasterOnClick()
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.Rune
  })
  local actionLogicId = MeRunneController:GetFirstSuitSkillId()
  local skillId
  if actionLogicId then
    local tbl = ClientTable.cfg_Skill_SkillPreviewManager:TryGetValue(actionLogicId, "actionLogicId")
    if tbl then
      skillId = tbl.id
    end
  end
  UIManager.Show(UIID.Skill_SkillPreviewUI, {
    openFirstTab = ESkillPreviewUIType.Rune,
    skillId = skillId
  })
end

function Equip_RunesInlayUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_RunesInlayUI:RegistEvents()
  self:RegistEvent(Event.SelectedRuneEquip, self.SelectedRuneEquip, self)
  self:RegistEvent(Event.SelectedRune, self.RefreshRightUI, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChange, self)
end

function Equip_RunesInlayUI:Refresh()
  MeRunneController:ClearRuneData()
  EventManager.Dispatch(Event.EquipForgeUIChange)
end

function Equip_RunesInlayUI:SelectedRuneEquip()
  local selectedItemCellRuneEquip = MeRunneController:GetSelectRuneEquip()
  self:RefreshEquipModel(selectedItemCellRuneEquip)
  self:RefreshEquipName(selectedItemCellRuneEquip)
  self:RefreshEquipRene()
  self:RefreshReneBag()
  self:RefreshTextInlayShow()
  self:RefreshAttribute()
  self:RefreshEffect()
end

function Equip_RunesInlayUI:RefreshRightUI()
  self:RefreshEquipRene()
  self:RefreshReneBag()
  self:RefreshTextInlayShow()
  self:RefreshAttribute()
  self:RefreshEffect()
end

function Equip_RunesInlayUI:Bag_ResBagChange()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Runes_Inlay
  })
  self:RefreshReneBag()
end

function Equip_RunesInlayUI:RefreshEquipModel(itemCellRuneEquip)
  if self.equipModelCellData then
    ItemUtility.HideItemCell(self.btn_Item, self.equipModelCellData)
    if self.btn_Item.button then
      self.btn_Item.button.onClick:RemoveAllListeners()
    end
  end
  if itemCellRuneEquip.itemData then
    self.equipModelCellData = itemCellRuneEquip
    ItemUtility.ShowItemCell(self.btn_Item, self.equipModelCellData, self, true)
  end
end

function Equip_RunesInlayUI:RefreshEquipName(itemCellRuneEquip)
  self.lb_name:SetText("")
  if itemCellRuneEquip.itemData then
    local strName = itemCellRuneEquip.itemData.tblEquip.name
    if itemCellRuneEquip.itemData.additional and itemCellRuneEquip.itemData.additional > 0 then
      strName = string.format("%s +%d", itemCellRuneEquip.itemData.tblEquip.name, itemCellRuneEquip.itemData.additional)
    end
    local titleStr = RoleEquipUtility.GetEquipNameColor(strName, itemCellRuneEquip.itemData)
    self.lb_name:SetText(titleStr)
  end
end

function Equip_RunesInlayUI:RefreshEquipRene()
  local equipIndex = MeRunneController:GetSelectEquipIndex()
  local equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex) or {}
  for i, itemTemp in ipairs(self.runeTempList) do
    itemTemp:Refresh(equipRuneData[i] ~= nil and table.count(equipRuneData[i]) > 0 and equipRuneData[i] or {point = i})
  end
end

function Equip_RunesInlayUI:RefreshReneBag()
  local equipIndex = MeRunneController:GetSelectEquipIndex()
  local canSetRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetCanSetRuneByEquipInBag(equipIndex)
  self.btn_3DItemTemp:SetData(canSetRuneData)
end

function Equip_RunesInlayUI:RefreshTextInlayShow()
  local equipIndex = MeRunneController:GetSelectEquipIndex()
  local equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex)
  local runeHoleType = MeRunneController:GetSelectRuneHoleType()
  self.text_Inlay:SetText((equipRuneData == nil or table.count(equipRuneData[runeHoleType]) == 0) and "Kh\225\186\163m" or "Thay th\225\186\191")
end

function Equip_RunesInlayUI:RefreshAttribute()
  if self.attributeTemp then
    self.attributeTemp:SetData(nil)
  end
  local equipIndex = MeRunneController:GetSelectEquipIndex()
  local equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex)
  local runeHoleType = MeRunneController:GetSelectRuneHoleType()
  if equipRuneData and table.count(equipRuneData[runeHoleType]) > 0 then
    local attributeTab = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetRuneAttributeByItemId(equipRuneData[runeHoleType].itemId, equipRuneData[runeHoleType].level)
    self.attributeTemp:SetData(attributeTab)
  end
end

function Equip_RunesInlayUI:RefreshEffect()
  if self.effect and table.count(self.effect) > 0 then
    for i, v in pairs(self.effect) do
      v:SetActive(false)
    end
  end
  local equipIndex = MeRunneController:GetSelectEquipIndex()
  local equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex)
  local runeHoleType = MeRunneController:GetSelectRuneHoleType()
  local equipData = RoleManager.me.data.equipsData.Data
  if equipRuneData and equipRuneData[runeHoleType] and equipData[equipIndex] and table.count(equipRuneData[runeHoleType]) > 0 then
    local cfgTab = ClientTable.cfg_Runes_inlayManager:GetItemCfgData(equipRuneData[runeHoleType].itemId)
    if cfgTab then
      if self.effect[tostring(cfgTab.activeEffect)] == nil then
        self.effect[tostring(cfgTab.activeEffect)] = UIEffectUtility.SetUIEffect(tostring(cfgTab.activeEffect), self.effect_runes, true)
      end
      self.effect_runes:SetActive(true)
      self.effect[tostring(cfgTab.activeEffect)]:SetActive(true)
    end
  end
end

function Equip_RunesInlayUI:OnHide()
  MeRunneController:ClearRuneData()
end

function Equip_RunesInlayUI:OnDestroy()
end
