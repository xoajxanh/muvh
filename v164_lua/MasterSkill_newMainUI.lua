MasterSkill_newMainUI = class(BaseUI)
MasterSkill_newMainUI.layer = UILayer.Panel
MasterSkill_newMainUI.orderInLayer = 0
MasterSkill_newMainUI.hideType = UIHideType.WaitDestroy
MasterSkill_newMainUI.hideFunc = UIHideFunc.MoveOutOfScreen
MasterSkill_newMainUI.escClose = UIEscClose.DontClose

function MasterSkill_newMainUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_MasterSkill/btn_close")
  self.sl_alpha = self:GetControl("panel_newMain/panel_down/addExp/go_alpha/sl_alpha")
  self.expCount = self:GetControl("panel_newMain/panel_down/addExp/go_alpha/expCount")
  self.levelCount = self:GetControl("panel_newMain/panel_down/addExp/masterLevel/levelCount")
  self.btn_addExp = self:GetControl("panel_newMain/panel_down/addExp/btn_addExp")
  self.btn_reset = self:GetControl("panel_newMain/panel_down/addExp/btn_reset")
  self.btn_level_addExp = self:GetControl("panel_newMain/panel_down/addExp/btn_level_addExp")
  self.panel_career1 = self:GetControl("panel_newMain/panel_career1")
  self.panel_career2 = self:GetControl("panel_newMain/panel_career2")
  self.panel_career3 = self:GetControl("panel_newMain/panel_career3")
  self.img_bg_PTlab = self:GetControl("panel_newMain/img_bg_careerPoint/img_bg_PTlab")
  self.img_bg_GTlab = self:GetControl("panel_newMain/img_bg_allPoint/img_bg_GTlab")
end

function MasterSkill_newMainUI:Init()
end

function MasterSkill_newMainUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function MasterSkill_newMainUI:InitUI()
  self:InitParam()
  self:InitTemplates()
  self:HideAddExpButton()
end

function MasterSkill_newMainUI:InitParam()
  self.selectItemData = nil
  self.pointLabelInfoTbl = {
    {
      label = self.img_bg_PTlab,
      format = "\196\144i\225\187\131m Thi\195\170n Ph\195\186 Ngh\225\187\129 %d"
    },
    {
      label = self.img_bg_PTlab,
      format = "\196\144i\225\187\131m Thi\195\170n Ph\195\186 Ngh\225\187\129 %d"
    },
    {
      label = self.img_bg_GTlab,
      format = "\196\144i\225\187\131m Thi\195\170n Ph\195\186 Th\198\176\225\187\157ng %d"
    }
  }
end

function MasterSkill_newMainUI:InitTemplates()
  self.viewTemplates = {}
  table.insert(self.viewTemplates, luaTemplateManager.GetNewTemplate(self.panel_career1, LuaComponentTemplates.MasterSkillCareerViewTemplate))
  table.insert(self.viewTemplates, luaTemplateManager.GetNewTemplate(self.panel_career2, LuaComponentTemplates.MasterSkillCareerViewTemplate))
  table.insert(self.viewTemplates, luaTemplateManager.GetNewTemplate(self.panel_career3, LuaComponentTemplates.MasterSkillCareerViewTemplate))
end

function MasterSkill_newMainUI:HideAddExpButton()
  self.btn_addExp:SetActive(false)
end

function MasterSkill_newMainUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_addExp:SetOnClick(self, self.btn_addExpOnClick)
  self.btn_reset:SetOnClick(self, self.btn_resetOnClick)
  self.btn_level_addExp:SetOnClick(self, self.btn_level_addExpOnClick)
end

function MasterSkill_newMainUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.MasterSkill_newMainUI)
end

function MasterSkill_newMainUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.MasterSkill_newMainUI)
end

function MasterSkill_newMainUI:btn_addExpOnClick(control)
  if not QuickFind.MasterDataMgr():CheckEnabelSubType() then
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiNotEnableStr())
    return
  end
  UIManager.Show(UIID.MasterSkill_ExpExchangeUI)
end

function MasterSkill_newMainUI:btn_resetOnClick(control)
  UIManager.Show(UIID.MasterSkill_ResetlUI)
end

function MasterSkill_newMainUI:btn_level_addExpOnClick(control)
  local masterExpPillItemId = ClientTable.cfg_Global_globalManager:GetMasterExpPillItemID()
  local bagMasterExpPillCount = BagInfoData.GetItemTotalCountByItemId(masterExpPillItemId or 3003001)
  local isMasterExpPillEnough = 0 < bagMasterExpPillCount
  if isMasterExpPillEnough then
    UIManager.Show(UIID.MasterSkill_ExpExchangeUI)
  else
    self:ShowItemTipUI(masterExpPillItemId or 3003001, control)
  end
end

function MasterSkill_newMainUI:ShowItemTipUI(itemId, control)
  if itemId == nil or control == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  control.itemData = itemData
  control.OpenTipsType = EOpenTipsType.FastBuy
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    ShowObtain = true,
    BusinessPay = control.BusinessPay,
    OpenWay = control.OpenTipsType,
    countDownTime = control.countDownTime
  })
end

function MasterSkill_newMainUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function MasterSkill_newMainUI:RegistEvents()
  self:RegistEvent(Event.NewMasterSkillLevelChanged, self.NewMasterSkillLevelChangedCallBack, self)
  self:RegistEvent(Event.NewMasterPointChanged, self.NewMasterPointChangedCallBack, self)
  self:RegistEvent(Event.NewMasterSkillDataChanged, self.NewMasterSkillDataChangedCallBack, self)
  self:RegistEvent(Event.NewMasterSkillAllDataChanged, self.NewMasterSkillAllDataChangedCallBack, self)
  self:RegistEvent(Event.NewSwitchMasterCarrerChanged, self.NewSwitchMasterCarrerChangedCallBack, self)
  self:RegistEvent(Event.NewMasterSelectChanged, self.NewMasterSelectChangedCallBack, self)
  self:RegistEvent(Event.NewMasterSkillUpStateChanged, self.NewMasterSkillUpcodeChangedCallBack, self)
end

function MasterSkill_newMainUI:NewMasterSkillLevelChangedCallBack(id, data)
  self:RefreshDownView()
end

function MasterSkill_newMainUI:NewMasterPointChangedCallBack(id, data)
  self:RefreshTopView()
end

function MasterSkill_newMainUI:NewMasterSkillDataChangedCallBack(id, data)
  if self.viewTemplates then
    for i, v in pairs(self.viewTemplates) do
      if v then
        v:TryRefreshSkillView(data)
      end
    end
  end
end

function MasterSkill_newMainUI:NewMasterSkillAllDataChangedCallBack()
  if self.viewTemplates then
    for i, v in pairs(self.viewTemplates) do
      if v then
        v:RefreshAllSkillView()
      end
    end
  end
end

function MasterSkill_newMainUI:NewSwitchMasterCarrerChangedCallBack(id, data)
  if self.viewTemplates then
    for i, v in pairs(self.viewTemplates) do
      if v then
        v:RefreshSelectState()
        v:RefreshSkillIconState()
      end
    end
  end
  self:ReSetTopView()
  self:RefreshTopView()
end

function MasterSkill_newMainUI:NewMasterSelectChangedCallBack(id, data)
  if data == nil then
    return
  end
  if self.selectItemData and data.groupId == self.selectItemData.groupId then
    return
  end
  if self.viewTemplates then
    for i, v in pairs(self.viewTemplates) do
      if v then
        v:TryRefreshSkillSelect(data, true)
        v:TryRefreshSkillSelect(self.selectItemData, false)
      end
    end
  end
  self.selectItemData = data
end

function MasterSkill_newMainUI:NewMasterSkillUpcodeChangedCallBack()
  if self.viewTemplates then
    for i, v in pairs(self.viewTemplates) do
      if v then
        v:RefreshUpgradeView()
      end
    end
  end
end

function MasterSkill_newMainUI:Refresh()
  if QuickFind.MasterDataMgr() == nil then
    return
  end
  self:RefreshData()
  self:RefreshView()
end

function MasterSkill_newMainUI:RefreshView()
  self:ReSetTopView()
  self:RefreshTopView()
  self:RefreshCenterView()
  self:RefreshDownView()
  self:RefreshExChangeView()
end

function MasterSkill_newMainUI:RefreshData()
  self.curCareerData = QuickFind.MasterDataMgr():GetCurTypeTbl()
end

function MasterSkill_newMainUI:RefreshTopView()
  if self.curCareerData == nil then
    return
  end
  local careerData
  for i, v in pairs(self.pointLabelInfoTbl) do
    careerData = v and v.label and self.curCareerData[i] or nil
    if careerData and (careerData.type ~= MasterSkillTalentTypeEnum.PS or careerData.subType == QuickFind.MasterDataMgr():GetCurEnableSubType()) then
      v.label:SetText(string.format(v.format, QuickFind.MasterDataMgr():GetPointByMasterTalentType(careerData.subType)))
    end
  end
end

function MasterSkill_newMainUI:ReSetTopView()
  for i, v in pairs(self.pointLabelInfoTbl) do
    if v and v.label then
      self.pointLabelInfoTbl[i].label:SetText(string.format(self.pointLabelInfoTbl[i].format, 0))
    end
  end
end

function MasterSkill_newMainUI:RefreshCenterView()
  if self.curCareerData == nil or self.viewTemplates == nil then
    return
  end
  for i, v in pairs(self.curCareerData) do
    if self.viewTemplates[i] then
      self.viewTemplates[i]:Refresh(v, self)
    end
  end
end

function MasterSkill_newMainUI:RefreshDownView()
  local expInfo = QuickFind.MasterDataMgr():GetExpInfo()
  self.levelCount:SetText(QuickFind.MasterDataMgr():GetLevel())
  if expInfo and expInfo.maxValue then
    if expInfo.value > expInfo.maxValue then
      self.sl_alpha:SetValue(1)
      self.expCount:SetText(expInfo.maxValue .. "/" .. expInfo.maxValue)
    else
      self.sl_alpha:SetValue(expInfo.value / expInfo.maxValue)
      self.expCount:SetText(expInfo.value .. "/" .. expInfo.maxValue)
    end
  end
end

function MasterSkill_newMainUI:RefreshExChangeView()
end

function MasterSkill_newMainUI:OnHide()
  self:ResetSelect()
  UIManager.Hide(UIID.MasterSkill_ExpExchangeUI)
  UIManager.Hide(UIID.MasterSkill_ResetlUI)
  UIManager.Hide(UIID.MasterSkill_CareerSwitchUI)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.MasterSkill
  })
end

function MasterSkill_newMainUI:ResetSelect()
  if self.selectItemData and self.viewTemplates then
    for i, v in pairs(self.viewTemplates) do
      if v then
        v:TryRefreshSkillSelect(self.selectItemData, false)
      end
    end
    self.selectItemData = nil
  end
end

function MasterSkill_newMainUI:OnDestroy()
end
