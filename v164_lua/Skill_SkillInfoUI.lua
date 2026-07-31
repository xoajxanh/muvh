Skill_SkillInfoUI = class(BaseUI)
Skill_SkillInfoUI.layer = UILayer.Panel
Skill_SkillInfoUI.orderInLayer = 0
Skill_SkillInfoUI.hideType = UIHideType.Hide
Skill_SkillInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Skill_SkillInfoUI.escClose = UIEscClose.DontClose

function Skill_SkillInfoUI:InitControls()
  self.img_skillIcon = self:GetControl("img_bg/img_skillIcon")
  self.lab_skill = self:GetControl("img_bg/lab_skill")
  self.btn_getSkill = self:GetControl("img_bg/btn_getSkill")
  self.btn_skillUp = self:GetControl("img_bg/btn_skillUp")
  self.img_needItem = self:GetControl("img_bg/btn_skillUp/lab_btnName/img_needItem")
  self.lab_btnNameNum = self:GetControl("img_bg/btn_skillUp/lab_btnName/img_needItem/lab_btnNameNum")
  self.lab_level = self:GetControl("img_bg/lab_level")
  self.sl_exp = self:GetControl("img_bg/lab_level/sl_exp")
  self.scrocview = self:GetControl("img_bg/Scroll")
  self.scrocviewContent = self:GetControl("img_bg/Scroll/Viewport/Content")
  self.LabTop = self:GetControl("img_bg/Scroll/Viewport/Content/LabTop")
  self.lab_describe = self:GetControl("img_bg/Scroll/Viewport/Content/LabTop/lab_describe")
  self.img_noskill = self:GetControl("img_bg/Scroll/Viewport/Content/LabTop/img_noskill")
  self.lab_needEquip = self:GetControl("img_bg/lab_needEquip")
  self.img_describe = self:GetControl("img_bg/Scroll/Viewport/Content/LabTop/img_describe")
  self.img_describeNext = self:GetControl("img_bg/Scroll/Viewport/Content/LabDown/img_describeNext")
  self.lab_skillLevelNext = self:GetControl("img_bg/Scroll/Viewport/Content/LabDown/img_describeNext/lab_skillLevelNext")
  self.lab_describeNext = self:GetControl("img_bg/Scroll/Viewport/Content/LabDown/lab_describeNext/Text")
  self.img_manskill = self:GetControl("img_bg/img_manskill")
  self.lab_exp = self:GetControl("img_bg/lab_level/sl_exp/lab_exp")
  self.btn_addExp = self:GetControl("img_bg/lab_level/sl_exp/btn_addExp")
  self.img_getBg = self:GetControl("img_bg/img_getBg")
  self.lab_item = self:GetControl("img_bg/lab_item")
  self.btn_3DItem = self:GetControl("img_bg/lab_item/btn_3DItem")
  self.img_btn_get = self:GetControl("img_bg/lab_item/img_btn_get")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.panel_require = self:GetControl("img_bg/img_start_skill/panel_require")
  self.Eff_UI_xuexijinneg = self:GetControl("img_bg/Eff_UI_xuexijinneg")
  self.Eff_UI_jinnengshengji = self:GetControl("img_bg/Eff_UI_jinnengshengji")
  self.lab_skillStrengthenDes = self:GetControl("img_bg/lab_skillStrengthenDes")
  self.Scroll = self:GetControl("img_bg/Scroll")
end

function Skill_SkillInfoUI:Init()
end

function Skill_SkillInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function SkillNeedCreate(control)
  control.img_open = UIControl(control.transform, "img_open")
  control.lab_require = UIControl(control.transform, "lab_require")
end

local function SkillNeedRefresh(ctr, _, skillNeedItem, ui)
  ctr.img_open:SetActive(skillNeedItem.isFit)
  ctr.lab_require:SetText(skillNeedItem.text)
end

function Skill_SkillInfoUI:RefreshComponent()
  local ctrParentChildCount = self.panel_require.transform.parent.childCount
  if not ctrParentChildCount then
    return
  end
  if ctrParentChildCount <= 3 then
    self.panel_require.transform.parent:GetComponent("HorizontalLayoutGroup").padding.right = 0
  else
    local fourthChild = self.panel_require.transform.parent:GetChild(3)
    if fourthChild and fourthChild.transform.gameObject.activeSelf then
      self.panel_require.transform.parent:GetComponent("HorizontalLayoutGroup").padding.right = -40
    else
      self.panel_require.transform.parent:GetComponent("HorizontalLayoutGroup").padding.right = 0
    end
  end
end

function Skill_SkillInfoUI:InitUI()
  self.btn_skillNeedTemp = UIContainer(self.panel_require, self, SkillNeedCreate, SkillNeedRefresh)
end

function Skill_SkillInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Skill_SkillInfoUI:OnHide()
  EventManager.Dispatch(Event.TipEffectHide)
end

function Skill_SkillInfoUI:OnDestroy()
end

function Skill_SkillInfoUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.Button_CloseOnClick)
  self.btn_getSkill:SetOnClick(self, self.Button_GetSkillOnClick)
  self.btn_skillUp:SetOnClick(self, self.Button_UpSkillOnClick)
  self.img_btn_get:SetOnClick(self, self.Btn_GetSkillGoodsOnClick)
end

function Skill_SkillInfoUI:Button_GetSkillOnClick(control)
  self.skillGet = true
  self.skillUp = false
  EventManager.Dispatch(Event.Skill_Upgrade, control.skillId)
end

function Skill_SkillInfoUI:Button_UpSkillOnClick(control)
  self.skillGet = false
  self.skillUp = true
  EventManager.Dispatch(Event.Skill_Upgrade, control.skillId)
end

function Skill_SkillInfoUI:Button_CloseOnClick(control)
  UIManager.Hide(UIID.Skill_SkillInfoUI)
end

function Skill_SkillInfoUI:Btn_GetSkillGoodsOnClick()
  if not self.args then
    return
  end
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(self.args.sid)
  if RoleManager.me.skills[cfg_skill.groupId] then
    local nextSkillLevel = RoleManager.me.skills[cfg_skill.groupId].level + 1
    if nextSkillLevel <= 6 then
      UIManager.JumpShow(UIPanelType.NormalAndHide, UIID.Shop, {
        subtype = 4,
        openPanel = UIID.SkillUI
      })
    else
      local nextSkillLevelTab = ClientTable.cfg_Skill_skillManager:TryGetValue(self.args.sid + 1)
      if nextSkillLevelTab then
        UIManager.JumpShow(UIPanelType.NormalAndHide, UIID.Item_CombineUI, {
          npcConfigID = 1004005,
          combineId = tonumber(nextSkillLevelTab.Itemcombine),
          openPanel = UIID.SkillUI
        })
      end
    end
  else
    UIManager.JumpShow(UIPanelType.NormalAndHide, UIID.Shop, {
      subtype = 4,
      openPanel = UIID.SkillUI
    })
  end
end

function Skill_SkillInfoUI:RegistEvents()
  self:RegistEvent(Event.Skill_SkillInfo_Refresh, self.OnRefreshSkillInfo, self)
  self:RegistEvent(Event.Skill_UpgradeSuccess, self.SkillUpgradeSuccess, self)
  self:RegistEvent(Event.Skill_SkillInfoRedPoint, self.OnShowRedPoint, self)
end

function Skill_SkillInfoUI:OnShowRedPoint(_, msg)
  self.btn_getSkill:GetChild("img_redPoint"):SetActive(msg.learn)
  self.btn_skillUp:GetChild("img_redPoint"):SetActive(msg.breach)
end

function Skill_SkillInfoUI:OnRefreshSkillInfo(id, skillInfo)
  self.args = skillInfo
  self:Refresh()
  self:RefreshComponent()
end

function Skill_SkillInfoUI:SkillUpgradeSuccess(id)
  if UIManager.IsVisible(UIID.EffectTipUI) then
    if self.skillGet then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_xuexijinneg",
        time = 1
      })
    elseif self.skillUp then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_jinnengshengji",
        time = 1
      })
    end
  elseif self.skillGet then
    UIManager.Show(UIID.EffectTipUI, {
      name = "Eff_UI_xuexijinneg",
      effectTime = 1
    })
  elseif self.skillUp then
    UIManager.Show(UIID.EffectTipUI, {
      name = "Eff_UI_jinnengshengji",
      effectTime = 1
    })
  end
end

function Skill_SkillInfoUI:Refresh()
  if not self.args then
    return
  end
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(self.args.sid)
  if cfg_skill ~= nil then
    self:SetSkillHeadSp(cfg_skill)
    self:SetSkillExp(cfg_skill)
    self:UpdateSkillLevel(cfg_skill)
    self:SetRequireTxt(cfg_skill)
    self:SetDescribe(cfg_skill)
    self:RefreshDescWindow()
    self:SetNeedItem(cfg_skill)
    self:SetUpBtn(cfg_skill)
    self:SKillFakeShow(cfg_skill)
  end
  self:RefreshSkillSpecialEffect(cfg_skill)
end

function Skill_SkillInfoUI:UpdateSkillLevel(cfg_skill)
  local skillLevel
  if RoleManager.me.skills[cfg_skill.groupId] then
    skillLevel = string.format("%s<color=#E6E600> Lv.%s</color>", cfg_skill.name, cfg_skill.level)
  else
    skillLevel = string.format("%s", cfg_skill.name)
  end
  self.lab_skill:SetText(skillLevel)
end

function Skill_SkillInfoUI:SetSkillHeadSp(cfg_skill)
  self:SetSprite("Atlas_Skill", cfg_skill.icon, self.img_skillIcon)
end

function Skill_SkillInfoUI:SetUpBtn(cfg_skill)
  local get = cfg_skill.get
  if get == ESkillGetType.Self then
    if RoleManager.me.skills[cfg_skill.groupId] then
      self.btn_getSkill:SetActive(false)
      local skillId = cfg_skill.id + 1
      local nextSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
      if nextSkill then
        self.btn_skillUp:SetActive(true)
        self.btn_skillUp.skillId = skillId
      else
        self.btn_skillUp:SetActive(false)
      end
    else
      self.btn_skillUp:SetActive(false)
      self.btn_getSkill.skillId = cfg_skill.id
      self.btn_getSkill:SetActive(true)
    end
  else
    self.btn_getSkill:SetActive(false)
    self.btn_skillUp:SetActive(false)
  end
end

function Skill_SkillInfoUI:GetNeedItemCountStr(needItemId, needItemCount)
  local itemCount = BagInfoData.GetItemCountByItemConfigId(needItemId)
  local bindEqualItem = ClientTable.cfg_Item_itemManager:TryGetValue(needItemId).bindEqualItem
  local bindItemCount = BagInfoData.GetItemCountByItemConfigId(bindEqualItem)
  local needItemStr = ""
  if needItemCount <= itemCount or needItemCount <= bindItemCount then
    needItemStr = string.format("<color=#5AB542>%d/%d</color>", bindItemCount + itemCount, needItemCount)
    self.img_btn_get:SetActive(false)
  else
    needItemStr = string.format("<color=#FF0000>%d/%d</color>", bindItemCount + itemCount, needItemCount)
    self.img_btn_get:SetActive(true)
  end
  return needItemStr
end

function Skill_SkillInfoUI:SetNeedItem(cfg_skill)
  local get = cfg_skill.get
  if get == ESkillGetType.Self then
    self.lab_item:SetActive(true)
    if RoleManager.me.skills[cfg_skill.groupId] then
      local skillId = cfg_skill.id + 1
      local nextSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
      if nextSkill and nextSkill.needItem ~= 0 then
        local itemCellData
        if not self.btn_3DItem.itemCellData then
          itemCellData = ItemCellData()
          self.btn_3DItem.itemCellData = itemCellData
        end
        local needStr = string.split(nextSkill.needItem, "#")
        local itemData = ItemUtility.GenerateItemData(tonumber(needStr[1]))
        local needItemStr = self:GetNeedItemCountStr(tonumber(needStr[1]), tonumber(needStr[2]))
        itemData.count = needItemStr
        self.btn_3DItem.itemCellData:RefreshData(itemData)
        ItemUtility.ShowItemCell(self.btn_3DItem, self.btn_3DItem.itemCellData, self, true)
        self.img_btn_get.itemData = itemData
      else
        self.lab_item:SetActive(false)
      end
    else
      local itemCellData
      if not self.btn_3DItem.itemCellData then
        itemCellData = ItemCellData()
        self.btn_3DItem.itemCellData = itemCellData
      end
      local needStr = string.split(cfg_skill.needItem, "#")
      local itemData = ItemUtility.GenerateItemData(tonumber(needStr[1]))
      local needItemStr = self:GetNeedItemCountStr(tonumber(needStr[1]), tonumber(needStr[2]))
      itemData.count = needItemStr
      self.btn_3DItem.itemCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(self.btn_3DItem, self.btn_3DItem.itemCellData, self, true)
      self.lab_item:SetActive(true)
      self.img_btn_get.itemData = itemData
    end
  else
    self.lab_item:SetActive(false)
  end
end

function Skill_SkillInfoUI:SetDescribe(cfg_skill)
  local skillLearn = false
  if RoleManager.me.skills[cfg_skill.groupId] then
    skillLearn = true
    local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("SkillInfo_5").content
    self.img_describe:GetChild("lab_skillLevel"):SetText(string.format(uiWord, cfg_skill.level))
    local itemTip = ClientTable.cfg_Item_tipsManager:TryGetValue(cfg_skill.description).content
    itemTip = SkillUtility.ParseSkillDesc(cfg_skill.description)
    self.lab_describe:SetText(itemTip)
    self.lab_describe:SetActive(true)
    self.img_describe:SetActive(true)
    self.img_noskill:SetActive(false)
  else
    self.lab_describe:SetActive(false)
    self.img_describe:SetActive(false)
    self.img_noskill:SetActive(true)
  end
  local skillId = cfg_skill.id + 1
  local nextSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if not nextSkill and skillLearn then
    self.lab_describeNext:SetActive(false)
    self.img_describeNext:SetActive(false)
    self.img_manskill:SetActive(true)
  elseif not nextSkill and not skillLearn then
    local itemTip = SkillUtility.ParseSkillDesc(cfg_skill.description)
    self.lab_describeNext:SetText(itemTip)
    self.lab_describeNext:SetActive(true)
    self.img_describeNext:SetActive(true)
    self.img_manskill:SetActive(false)
  elseif nextSkill and not skillLearn then
    local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("SkillInfo_7").content
    self.img_describeNext:GetChild("lab_skillLevelNext"):SetText(string.format(uiWord, cfg_skill.level))
    local itemTip = SkillUtility.ParseSkillDesc(cfg_skill.description)
    self.lab_describeNext:SetText(itemTip)
    self.lab_describeNext:SetActive(true)
    self.img_describeNext:SetActive(true)
    self.img_manskill:SetActive(false)
  elseif nextSkill then
    local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("SkillInfo_7").content
    self.img_describeNext:GetChild("lab_skillLevelNext"):SetText(string.format(uiWord, nextSkill.level))
    local itemTip = SkillUtility.ParseSkillDesc(cfg_skill.nextDescription)
    self.lab_describeNext:SetText(itemTip)
    self.lab_describeNext:SetActive(true)
    self.img_describeNext:SetActive(true)
    self.img_manskill:SetActive(false)
  end
end

function Skill_SkillInfoUI:RefreshDescWindow(cfg_skill)
  local height = self.LabTop.rectTransform.sizeDelta.y + self.lab_describeNext.text.preferredHeight + self.lab_skillLevelNext.text.preferredHeight + 60
  self.scrocviewContent.rectTransform.sizeDelta = Vector2(self.scrocviewContent.rectTransform.sizeDelta.x, height)
  self.scrocviewContent.rectTransform.anchoredPosition = Vector3(0, 0, 0)
end

function Skill_SkillInfoUI:SKillFakeShow(cfg_skill)
  if SkillData.CheckFakeSkill(cfg_skill.groupId, cfg_skill.level) then
    self.lab_describeNext:SetActive(false)
    self.img_describeNext:SetActive(false)
    self.lab_item:SetActive(false)
    self.btn_skillUp:SetActive(false)
    self.img_manskill:SetActive(true)
  end
end

function Skill_SkillInfoUI:RefreshSkillSpecialEffect(skillTbl)
  local specialDes = skillTbl ~= nil and gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSkillSpecialEffectDes(skillTbl.groupId)
  local isShowDes = string.isNullOrEmpty(specialDes) == false
  self.lab_skillStrengthenDes:SetActive(isShowDes)
  if isShowDes then
    specialDes = string.format("C\198\176\225\187\157ng h\195\179a K\225\187\185 N\196\131ng:\n%s", specialDes)
    self.lab_skillStrengthenDes:SetText(specialDes)
  end
end

function Skill_SkillInfoUI:SetRequireTxt(cfg_skill)
  local tmpAttr
  local requireTxtTab = {}
  local skillNeed
  local isHasSkill = false
  if RoleManager.me.skills[cfg_skill.groupId] then
    local nextSkillId = cfg_skill.id + 1
    local nextSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(nextSkillId)
    if nextSkill then
      skillNeed = nextSkill
    else
      skillNeed = cfg_skill
    end
    isHasSkill = true
  else
    skillNeed = cfg_skill
  end
  if skillNeed.get == ESkillGetType.Weapon then
    local re_color = ""
    if isHasSkill then
      re_color = "<color=#5AB542>"
    else
      re_color = "<color=#FFFFFF>"
    end
    local require_txt = re_color .. "K\225\187\185 n\196\131ng v\197\169 kh\195\173" .. "</color> "
    local requireTab = {text = require_txt, isFit = isHasSkill}
    table.insert(requireTxtTab, requireTab)
  end
  if skillNeed.career then
    local re_color = ""
    local inCareer, canLearnCareer = ParseUtility:IsSameCareerType(skillNeed.career, RoleManager.me.career)
    local uiWord = RoleUtility.GteCareerNameByType(canLearnCareer)
    local isFit = inCareer and canLearnCareer <= RoleManager.me.career
    if isFit then
      re_color = "<color=#5AB542>"
    else
      re_color = "<color=#FFFFFF>"
    end
    local require_txt = re_color .. uiWord .. "</color> "
    local requireTab = {text = require_txt, isFit = isFit}
    table.insert(requireTxtTab, requireTab)
  end
  if skillNeed.needLevel > 0 then
    local uiWord = "NV"
    local re_color = ""
    tmpAttr = ViewData.meData:GetAttribute(EAttributeType.level)
    if tmpAttr >= skillNeed.needLevel then
      re_color = "<color=#5AB542>"
    else
      re_color = "<color=#FFFFFF>"
    end
    local needLevel = ClientTable.cfg_Character_levelManager:GetLevelDes(tonumber(skillNeed.needLevel))
    local require_txt = re_color .. uiWord .. " " .. tostring(needLevel) .. "</color> "
    local requireTab = {
      text = require_txt,
      isFit = tmpAttr >= skillNeed.needLevel
    }
    table.insert(requireTxtTab, requireTab)
  end
  if 0 < skillNeed.needEnergy then
    local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("zhili").content
    local re_color = ""
    tmpAttr = ViewData.meData:GetAttribute(EAttributeType.energy)
    if tmpAttr >= skillNeed.needEnergy then
      re_color = "<color=#5AB542>"
    else
      re_color = "<color=#FFFFFF>"
    end
    local require_txt = re_color .. uiWord .. " " .. tostring(skillNeed.needEnergy) .. "</color> "
    local requireTab = {
      text = require_txt,
      isFit = tmpAttr >= skillNeed.needEnergy
    }
    table.insert(requireTxtTab, requireTab)
  end
  if 0 < skillNeed.needStrength then
    local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("liliang").content
    local re_color = ""
    tmpAttr = ViewData.meData:GetAttribute(EAttributeType.strength)
    if tmpAttr >= skillNeed.needStrength then
      re_color = "<color=#5AB542>"
    else
      re_color = "<color=#FFFFFF>"
    end
    local require_txt = re_color .. uiWord .. " " .. tostring(skillNeed.needStrength) .. "</color> "
    local requireTab = {
      text = require_txt,
      isFit = tmpAttr >= skillNeed.needStrength
    }
    table.insert(requireTxtTab, requireTab)
  end
  if 0 < skillNeed.needAgility then
    local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("minjie").content
    local re_color = ""
    tmpAttr = ViewData.meData:GetAttribute(EAttributeType.agility)
    if tmpAttr >= skillNeed.needAgility then
      re_color = "<color=#5AB542>"
    else
      re_color = "<color=#FFFFFF>"
    end
    local require_txt = re_color .. uiWord .. " " .. tostring(skillNeed.needAgility) .. "</color> "
    local requireTab = {
      text = require_txt,
      isFit = tmpAttr >= skillNeed.needAgility
    }
    table.insert(requireTxtTab, requireTab)
  end
  self.btn_skillNeedTemp:SetData(requireTxtTab)
end

function Skill_SkillInfoUI:SetRequireWeaponAndMount(cfg_skill)
  local requireTxtTab = {}
  if cfg_skill.needWeapon ~= "" then
    local needWeapons = string.split(cfg_skill.needWeapon, "#")
    local leftWeapon = RoleManager.me.equipsData.Data[ERoleEquipPosition.left_weapon]
    local rightWeapon = RoleManager.me.equipsData.Data[ERoleEquipPosition.right_weapon]
    if #needWeapons < 3 then
      local requireWeapon = ClientTable.cfg_Ui_wordManager:TryGetValue("SkillInfo_2").content
      table.insert(requireTxtTab, requireWeapon)
      for i, v in ipairs(needWeapons) do
        local needWeapon
        if leftWeapon and leftWeapon.tblItem.subType == tonumber(v) then
          needWeapon = tonumber(v)
        end
        if rightWeapon and rightWeapon.tblItem.subType == tonumber(v) then
          needWeapon = tonumber(v)
        end
        if needWeapon then
          local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue(EWeaponSubtypeName[needWeapon]).content
          table.insert(requireTxtTab, uiWord)
        else
          local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue(EWeaponSubtypeName[tonumber(v)]).content
          uiWord = string.format("<color=#ff0000>%s</color>", uiWord)
          table.insert(requireTxtTab, uiWord)
        end
      end
    else
      local isEquipWeapon = false
      for i, v in ipairs(needWeapons) do
        if leftWeapon and leftWeapon.tblItem.subType == tonumber(v) then
          isEquipWeapon = true
          break
        end
        if rightWeapon and rightWeapon.tblItem.subType == tonumber(v) then
          isEquipWeapon = true
          break
        end
      end
      local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("SkillInfo_1").content
      if not isEquipWeapon then
        table.insert(requireTxtTab, string.format("<color=#ff0000>%s</color>", uiWord))
      else
        table.insert(requireTxtTab, string.format("<color=#ffffff>%s</color>", uiWord))
      end
    end
  end
  if cfg_skill.needRide ~= "" then
    local needRides = string.split(cfg_skill.needRide, "#")
    if #needRides < 3 then
      for i, v in ipairs(needRides) do
        local item = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(v))
        local mountName
        if RoleManager.me.data.rideMount == tonumber(v) then
          mountName = "<color=#ffffff>" .. item.name .. "</color>"
        else
          mountName = "<color=#ff0000>" .. item.name .. "</color>"
        end
        table.insert(requireTxtTab, mountName)
      end
    else
      local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("SkillInfo_3").content
      table.insert(requireTxtTab, uiWord)
    end
  end
  if 0 < #requireTxtTab then
    self.lab_needEquip:SetActive(true)
    local require = table.concat(requireTxtTab, " ")
    self.lab_needEquip:SetText(require)
  else
    self.lab_needEquip:SetActive(false)
  end
end

function Skill_SkillInfoUI:SetSkillExp(cfg_skill)
  if not cfg_skill.exp or cfg_skill.exp <= 0 or not RoleManager.me.skills[cfg_skill.groupId] then
    self.sl_exp:SetActive(false)
    return
  end
  local expValue = self:GetSkillExpValue(cfg_skill)
  self.sl_exp:SetActive(true)
  self.sl_exp:SetValue(expValue)
  if self.args.exp >= cfg_skill.exp then
    self.lab_exp:SetText("EXP \196\145\195\163 \196\145\225\186\161t gi\195\161 tr\225\187\139 l\225\187\155n nh\225\186\165t")
    self.btn_addExp:SetActive(false)
  else
    local strExp = string.format("%d/%d", self.args.exp, cfg_skill.exp)
    self.lab_exp:SetText(strExp)
    self.btn_addExp:SetActive(true)
  end
end

function Skill_SkillInfoUI:GetSkillExpValue(cfg_skill)
  local curSkillMaxExp = cfg_skill.exp
  local curSkillExp = self.args.exp
  return curSkillExp / curSkillMaxExp
end

function Skill_SkillInfoUI:IsSkillItemEnough(needItem)
  if type(needItem) == "number" then
    return true
  end
  local itemCount = BagInfoData.GetItemCountByItemConfigId(needItem[1])
  if itemCount < needItem[2] then
    return false
  end
  return true
end

function Skill_SkillInfoUI:Tips(tip)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = tip,
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      UIManager.Hide(UIID.PromptTipUI)
    end
  })
end
