Skill_SkillUI = class(BaseUI)
Skill_SkillUI.layer = UILayer.Panel
Skill_SkillUI.orderInLayer = 4
Skill_SkillUI.hideType = UIHideType.WaitDestroy
Skill_SkillUI.hideFunc = UIHideFunc.MoveOutOfScreen
Skill_SkillUI.escClose = UIEscClose.DontClose

function Skill_SkillUI:InitControls()
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.btn_config = self:GetControl("img_bg/btn_config")
  self.bg_frame = self:GetControl("img_bg/img_insideFrame")
  self.Content = self:GetControl("img_bg/img_insideFrame/Viewport/Content")
  self.img_selection = self:GetControl("img_bg/img_insideFrame/Viewport/img_selection")
  self.temp_skillFrame = self:GetControl("img_bg/img_insideFrame/Viewport/Content/temp_skillFrame")
  self.tog_baseSkill = self:GetControl("img_bg/img_insideFrame/tog_baseSkill")
  self.tog_specialSkill = self:GetControl("img_bg/img_insideFrame/tog_specialSkill")
  self.tog_comboSkill = self:GetControl("img_bg/img_insideFrame/tog_comboSkill")
  self.ToggleGroup = self:GetControl("img_bg/ToggleGroup")
  self.Toggle_Page1 = self:GetControl("img_bg/ToggleGroup/Toggle_Page1")
  self.img_drag = self:GetControl("img_bg/img_drag")
  self.descBtn = self:GetControl("img_bg/descBtn")
  self.btn_closeBg = self:GetControl("btn_closeBg")
end

Skill_SkillUI.CurPage = 1

function Skill_SkillUI:Init()
  self.curPageSkillControlList = {}
  self.toggleList = {}
end

function Skill_SkillUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Skill_SkillUI:InitUI()
  self.Skill_Page_Count = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2110010))
  self.togId = 1
  self.img_drag:SetActive(false)
  self.CurPage = 1
  local ScrollConfigTbl = {
    content = self.Content,
    curPage = self.CurPage,
    totalPage = 1,
    endDragCall = self.ShowPageSign,
    dragCall = self.ShowSkills,
    scrollTimeRatio = 0.3,
    ui = self
  }
  self.scorllLua = UIScroll(ScrollConfigTbl)
  self.temp_skillFrame.gameObject:SetActive(false)
  self.bg_frame:SetOnDrag(self.scorllLua, self.scorllLua.OnDrag)
  self.bg_frame:SetOnEndDrag(self.scorllLua, self.scorllLua.OnEndDrag)
  for index, content in pairs(self.scorllLua:GetContentTbl()) do
    content = self:InitContent(content)
    self.scorllLua:SetContentTbl(index, content)
  end
  self:RefreshSkill()
end

function Skill_SkillUI:InitContent(content)
  local btn = UIControl(content.transform, "temp_skillFrame")
  content.curPageSkillControlList = {}
  btn:SetActive(false)
  for i = 1, self.Skill_Page_Count do
    local obj = btn:Instantiate(nil, i)
    obj:SetActive(true)
    local objControl = UIControl(obj.transform)
    objControl:SetOnDrag(self, self.Button_ScrollDrag)
    objControl:SetOnEndDrag(self, self.Button_ScrollEndDrag)
    table.insert(content.curPageSkillControlList, objControl)
  end
  return content
end

function Skill_SkillUI:RefreshSkill()
  self.skillGroupIdDict = {}
  local skillInfos
  skillInfos = SkillData.SkillList[self.togId]
  local pageCount, delta = math.modf(#skillInfos / self.Skill_Page_Count)
  if 0 < delta then
    pageCount = pageCount + 1
  end
  local childCount = self.ToggleGroup.transform.childCount
  for i = 1, pageCount do
    local obj
    if i <= childCount then
      obj = self.ToggleGroup.transform:GetChild(i - 1).gameObject
    else
      obj = self.Toggle_Page1:Instantiate()
    end
    local objControl = UIControl(obj.transform)
    table.insert(self.toggleList, i, objControl)
  end
  if pageCount <= 1 then
    self.ToggleGroup:SetActive(false)
  else
    self.ToggleGroup:SetActive(true)
  end
  self.CurPage = 1
  self.scorllLua:SetCurPage(self.CurPage)
  self.scorllLua:SetTotalPage(pageCount)
end

function Skill_SkillUI:OnShow()
  self:RegistEvents()
  self:RefreshSkill()
  self:Refresh()
end

function Skill_SkillUI:OnHide()
end

function Skill_SkillUI:OnDestroy()
end

function Skill_SkillUI:RegistUIEvents()
  self.btn_config:SetOnClick(self, self.Button_ConfigOnClick)
  self.btn_close:SetOnClick(self, self.Button_CloseOnClick)
  self.descBtn:SetOnClick(self, self.Button_descBtnOnClick)
  self:SetRegisterTogClickEvent()
  self.btn_closeBg:SetOnClick(self, self.Button_CloseOnClick)
end

function Skill_SkillUI:SetRegisterTogClickEvent()
  local togList = {}
  table.insert(togList, self.tog_baseSkill)
  table.insert(togList, self.tog_specialSkill)
  table.insert(togList, self.tog_comboSkill)
  for i, v in ipairs(togList) do
    v.id = i
    v:SetOnToggleChanged(self, self.Button_SkillTogClick)
  end
end

function Skill_SkillUI:Button_ConfigOnClick()
  if UIManager.IsVisible(UIID.Skill_SetSkillUI) then
    UIManager.Show(UIID.Skill_SkillInfoUI)
    local skillTable = {
      sid = self.selectSkillBtn.id
    }
    EventManager.Dispatch(Event.Skill_SkillInfo_Refresh, skillTable)
  else
    UIManager.Show(UIID.Skill_SetSkillUI)
  end
end

function Skill_SkillUI:Button_CloseOnClick(control)
  UIManager.Hide(UIID.SkillUI)
end

function Skill_SkillUI:Button_descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Skill_SkillUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Skill_SkillUI:Button_BaseSkillOnClick()
  self:RefreshSkill()
end

function Skill_SkillUI:Button_SpecialSkillOnClick()
  self:RefreshSkill()
end

function Skill_SkillUI:Button_SkillTogClick(control)
  self.togId = control.id
  self:RefreshSkill()
end

function Skill_SkillUI:SetImgSelection()
  self.img_selection.transform:SetParent(self.selectSkillBtn.transform)
  self.img_selection.transform.localPosition = Vector3.zero
  self.img_selection:SetActive(true)
  self.img_selection.transform:SetAsFirstSibling()
end

function Skill_SkillUI:IsComboSkill(skillId)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if cfg_skill.skillType == ESKillCastType.Combo then
    return true
  end
  return false
end

function Skill_SkillUI:TipsWithComboSkill(control)
  FloatingWordUtility.QuickMsg("Li\195\170n K\195\173ch K\225\187\185 kh\195\180ng th\225\187\131 c\195\160i \196\145\225\186\183t")
end

function Skill_SkillUI:Button_ShowUseOperation(control, eventData)
  if self.ScrollDraged == true then
    self.ScrollDraged = false
    return
  end
  if control.id == 0 then
    return
  end
  self.redPointCtrl = control
  EventManager.Dispatch(Event.Skill_SkillInfoRedPoint, {
    learn = control.learn,
    breach = control.breach
  })
  local skillTable = {
    sid = control.id,
    isLeaned = false
  }
  self:GetSkillStatus(skillTable.sid, skillTable)
  if UIManager.IsVisible(UIID.Skill_SetSkillUI) then
    if control.skillConfig and control.skillConfig.skillPan == 1 then
      FloatingTipUtility.QuickMsg("\196\144\195\162y l\195\160 k\225\187\185 n\196\131ng b\225\187\139 \196\145\225\187\153ng, kh\195\180ng th\225\187\131 t\225\187\177 k\195\173ch ho\225\186\161t")
      return
    end
    if self:IsComboSkill(control.id) then
      self:TipsWithComboSkill()
      return
    end
    if skillTable.isLeaned then
      EventManager.Dispatch(Event.Skill_Pan_SetSkill, skillTable.sid)
    else
      local uiWorld = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("SkillSetTips_1")
      FloatingWordUtility.QuickMsg(uiWorld)
    end
  else
    if UIManager.IsVisible(UIID.Skill_SkillInfoUI) then
      EventManager.Dispatch(Event.Skill_SkillInfo_Refresh, skillTable)
    else
    end
  end
  self.selectSkillBtn = control
  self:SetImgSelection()
end

function Skill_SkillUI:IsSameSkill(skillId)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if RoleManager.me.skills[cfg_skill.groupId] and RoleManager.me.skills[cfg_skill.groupId].sid == skillId then
    return true
  end
  return false
end

function Skill_SkillUI:GetSkillStatus(skillId, skillTable)
  if self:IsSameSkill(skillId) then
    local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
    skillTable.isLeaned = true
    skillTable.level = RoleManager.me.skills[cfg_skill.groupId].level
    skillTable.exp = RoleManager.me.skills[cfg_skill.groupId].exp
  end
end

function Skill_SkillUI:Button_ScrollDrag(control, eventData)
  self.ScrollDraged = true
  self.scorllLua:OnDrag(control, eventData)
end

function Skill_SkillUI:Button_ScrollEndDrag(control, eventData)
  self.ScrollDraged = false
  self.scorllLua:OnEndDrag(control, eventData)
end

function Skill_SkillUI:ShowPageSign()
  self.CurPage = self.scorllLua.curPage
  self.toggleList[self.CurPage].toggle.isOn = true
end

function Skill_SkillUI:OnLongPress(control, eventData)
  self:OnSkillDragBegin(control, eventData)
end

function Skill_SkillUI:OnSkillDragBegin(control, eventData)
  if not UIManager.IsVisible(UIID.Skill_SetSkillUI) then
    return
  end
  if control.useable == false then
    return
  end
  self.scorllLua:SetEnable(false)
  self.img_drag.transform.position = control.transform.position
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(control.id)
  self.img_drag.id = control.id
  self:SetSprite("Atlas_Skill", cfg_skill.icon, self.img_drag)
  self.img_drag:SetActive(true)
end

function Skill_SkillUI:OnSkillDrag(control, eventData)
  if not UIManager.IsVisible(UIID.Skill_SetSkillUI) then
    return
  end
  if control.useable == false then
    return
  end
  local pos = self.img_drag.transform.localPosition
  pos.x = pos.x + eventData.delta.x
  pos.y = pos.y + eventData.delta.y
  self.img_drag.transform.localPosition = pos
end

function Skill_SkillUI:OnSkillDragEnd(control, eventData)
  if not UIManager.IsVisible(UIID.Skill_SetSkillUI) then
    return
  end
  if control.useable == false then
    return
  end
  local tpos = self.img_drag.transform.position
  self.img_drag:SetActive(false)
  if UIManager.IsVisible(UIID.Skill_SetSkillUI) then
    EventManager.Dispatch(Event.Skill_Pan_DragSkillEnd, {
      id = self.img_drag.id,
      pos = tpos
    })
  end
  self.scorllLua:SetEnable(true)
end

function Skill_SkillUI:ShowSkills(content, notSelectBnt)
  content = content or self.scorllLua:GetCurContent()
  local skillInfos
  skillInfos = SkillData.SkillList[self.togId]
  local skillInfoCount = #skillInfos
  for i = 1, self.Skill_Page_Count do
    local control
    if i <= #content.curPageSkillControlList then
      control = content.curPageSkillControlList[i]
      control.id = 0
      control.skillConfig = nil
      control.useable = true
      GuideUtility.AddCreatObj("Skill_SkillUI", control)
    end
    local curIndex = (content.page - 1) * self.Skill_Page_Count + i
    if skillInfoCount < curIndex then
      control.gameObject:SetActive(false)
    else
      control.gameObject:SetActive(true)
      local cfg_skill = skillInfos[curIndex]
      local sprite
      if cfg_skill ~= nil then
        control:SetOnClick(self, self.Button_ShowUseOperation)
        local skillNameText = UIControl(control.transform, "lab_skillName")
        local skillLevel = UIControl(control.transform, "lab_skillLevel")
        local skillImg_lockLock = UIControl(control.transform, "img_lock")
        skillNameText:SetText(cfg_skill.name)
        local skillIcon = UIControl(control.transform, "img_skillIcon")
        self:SetSprite("Atlas_Skill", cfg_skill.icon, skillIcon)
        control.id = cfg_skill.id
        control.skillConfig = cfg_skill
        local level
        local isLeaned = false
        if self:IsSameSkill(cfg_skill.id) then
          isLeaned = true
          level = ClientTable.cfg_Skill_skillManager:TryGetValue(cfg_skill.id).level
        end
        local breach, learn = self:SkillRedPoint(isLeaned, cfg_skill.id, control)
        control.learn = learn
        control.breach = breach
        if isLeaned == false then
          if self.tog_specialSkill.toggle.isOn == true then
            control.gameObject:SetActive(false)
          else
            control.useable = false
            if i == 1 and not UIManager.IsVisible(UIID.Skill_SetSkillUI) and not notSelectBnt then
              self:Button_ShowUseOperation(control)
            end
          end
          skillLevel:SetActive(false)
          skillImg_lockLock:SetActive(true)
        else
          skillIcon:SetMaterial(nil)
          if i == 1 and not UIManager.IsVisible(UIID.Skill_SetSkillUI) and not notSelectBnt then
            self:Button_ShowUseOperation(control)
          end
          skillLevel:SetActive(true)
          skillImg_lockLock:SetActive(false)
          skillLevel:SetText("Lv " .. level)
        end
      else
        control.gameObject:SetActive(false)
      end
    end
  end
end

function Skill_SkillUI:UpdateSkillBtn(id, skillInfo)
  self:ShowSkills(nil, true)
  self:SetImgSelection()
  EventManager.Dispatch(Event.Skill_Id_Changed, skillInfo.sid)
end

function Skill_SkillUI:UpdateSkillData()
end

function Skill_SkillUI:RegistEvents()
  self:RegistEvent(Event.Skill_RefreshSkillUI, self.UpdateSkillBtn, self)
  self:RegistEvent(Event.Skill_UpgradeSuccess, self.OnRefresh, self)
  self:RegistEvent(Event.Skill_SkillRedPoint, self.OnRefresh, self)
end

function Skill_SkillUI:Refresh()
  self.redPointCtrl = nil
  if UIManager.IsVisible(UIID.Task_EarlyGoldGameplay) then
    self:Button_CloseOnClick()
  end
end

function Skill_SkillUI:OnRefresh()
  if self.redPointCtrl == nil then
    return
  end
  self:SkillRedPoint(true, self.redPointCtrl.id, self.redPointCtrl)
  self:Button_ShowUseOperation(self.redPointCtrl)
end

function Skill_SkillUI:SkillRedPoint(isLeaned, id, control)
  local isLearnShow = false
  local isBreachShow = false
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
  local cfg_skillNext = ClientTable.cfg_Skill_skillManager:TryGetValue(id + 1)
  local skillRedPoint = UIControl(control.transform, "img_redPoint")
  if not cfg_skillNext and isLeaned then
    skillRedPoint:SetActive(false)
    return isBreachShow, isLearnShow
  end
  if cfg_skill.get == ESkillGetType.Self then
    if isLeaned then
      local conditionTab = cfg_skillNext.condition
      local isCon = true
      for i = 1, table.count(conditionTab) do
        if not ConditionManager.GenerateSingleCondition(conditionTab[i]):Check() then
          isCon = false
          break
        end
      end
      if isCon then
        local needStr = string.split(cfg_skillNext.needItem, "#")
        local itemCount = BagInfoData.GetItemCountByItemConfigId(tonumber(needStr[1]))
        local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(needStr[1]))
        if itemTab ~= nil then
          if itemTab.bindEqualItem == 0 then
            if itemCount >= tonumber(needStr[2]) then
              isBreachShow = true
            end
          else
            local tempCount = BagInfoData.GetItemCountByItemConfigId(itemTab.bindEqualItem)
            itemCount = tempCount + itemCount
            if itemCount >= tonumber(needStr[2]) then
              isBreachShow = true
            end
          end
        end
      end
    else
      local conditionTab = cfg_skill.condition
      local isCon = true
      for i = 1, table.count(conditionTab) do
        if not ConditionManager.GenerateSingleCondition(conditionTab[i]):Check() then
          isCon = false
          break
        end
      end
      if isCon then
        local needStr = string.split(cfg_skill.needItem, "#")
        local itemCount = BagInfoData.GetItemCountByItemConfigId(tonumber(needStr[1]))
        local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(needStr[1]))
        if itemTab.bindEqualItem == 0 then
          if itemCount >= tonumber(needStr[2]) then
            isLearnShow = true
          end
        else
          local tempCount = BagInfoData.GetItemCountByItemConfigId(itemTab.bindEqualItem)
          itemCount = tempCount + itemCount
          if itemCount >= tonumber(needStr[2]) then
            isLearnShow = true
          end
        end
      end
    end
  end
  if isBreachShow or isLearnShow then
    skillRedPoint:SetActive(true)
  else
    skillRedPoint:SetActive(false)
  end
  return isBreachShow, isLearnShow
end
