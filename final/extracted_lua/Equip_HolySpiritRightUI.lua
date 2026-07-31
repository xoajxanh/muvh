Equip_HolySpiritRightUI = class(BaseUI)
Equip_HolySpiritRightUI.layer = UILayer.Panel
Equip_HolySpiritRightUI.orderInLayer = 0
Equip_HolySpiritRightUI.hideType = UIHideType.Hide
Equip_HolySpiritRightUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySpiritRightUI.escClose = UIEscClose.DontClose

function Equip_HolySpiritRightUI:InitControls()
  self.descBtn = self:GetControl("descBtn")
  self.lab_AllAttribut = self:GetControl("bg_Attribute/lab_AllAttribut")
  self.lab_AllAttributlParent = self:GetControl("bg_Attribute/lab_AllAttribut/lab_AllAttributlParent")
  self.allAttributContent = self:GetControl("bg_Attribute/lab_AllAttribut/lab_AllAttributlParent/allAttributContent")
  self.allLab = self:GetControl("bg_Attribute/lab_AllAttribut/lab_AllAttributlParent/allAttributContent/Content/allLab")
  self.lab_CurrentAttribut = self:GetControl("bg_Attribute/lab_CurrentAttribut")
  self.lab_CurrentAttributeParent = self:GetControl("bg_Attribute/lab_CurrentAttribut/lab_CurrentAttributeParent")
  self.curAttributContent = self:GetControl("bg_Attribute/lab_CurrentAttribut/lab_CurrentAttributeParent/curAttributContent")
  self.curLab = self:GetControl("bg_Attribute/lab_CurrentAttribut/lab_CurrentAttributeParent/curAttributContent/Content/curLab")
  self.lab_material = self:GetControl("Up_Parent/lab_material")
  self.frame_item = self:GetControl("Up_Parent/lab_material/materialParent/frame_item")
  self.btn_Upgrade = self:GetControl("Up_Parent/btn_Upgrade")
  self.text_Upgrade = self:GetControl("Up_Parent/btn_Upgrade/text_Upgrade")
  self.lab_failuretips = self:GetControl("lab_failuretips")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
  self.text_Stage_num = self:GetControl("Up_Parent/img_CurStage/text_Stage_num")
  self.Up_Parent = self:GetControl("Up_Parent")
  self.img_FullLevel = self:GetControl("BelowStateParent/img_FullLevel")
  self.img_NotUnlocked = self:GetControl("BelowStateParent/img_NotUnlocked")
  self.img_Activated = self:GetControl("BelowStateParent/img_Activated")
  self.text_AllAttribute = self:GetControl("bg_Attribute/lab_AllAttribut/bg_AllAttribut/text_AllAttribute")
  self.bg_CurrentAttribut = self:GetControl("bg_Attribute/lab_CurrentAttribut")
  self.text_Order = self:GetControl("Up_Parent/img_CurStage/text_Order")
end

function Equip_HolySpiritRightUI:Init()
end

function Equip_HolySpiritRightUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolySpiritRightUI:InitUI()
  self.allHolySpiritAttributeTemplate = UIUtility.BindUIContainerTemp(self.allLab, LuaComponentTemplates.AllHolySpiritAttributeTemplate, self)
  self.curHolySpiritAttributeTemplate = UIUtility.BindUIContainerTemp(self.curLab, LuaComponentTemplates.CurHolySpiritAttributeTemplates, self)
  self.expenditureTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
  self.nameTab = {
    [1] = "Michael",
    [2] = "Gabriel",
    [3] = "Uriel",
    [4] = "Raphael",
    [5] = "Raphael",
    [6] = "Sariel",
    [7] = "Giophiel"
  }
end

function Equip_HolySpiritRightUI:RegistUIEvents()
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_Upgrade:SetOnClick(self, self.btn_UpgradeOnClick)
end

function Equip_HolySpiritRightUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_HolySpiritRightUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_HolySpiritRightUI:btn_UpgradeOnClick(control)
  local holySpiritPointId = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritPointId()
  local expendTab = HolySpiritPointData.GetPointExpendById(holySpiritPointId)
  if table.count(expendTab) > 0 then
    for i, expendItem in pairs(expendTab) do
      if BagInfoData.GetItemTotalCountByItemId(expendItem.itemId) < expendItem.count then
        TipUtility.ShowQuickGetTipPanel(expendItem.itemId)
        return
      end
    end
  end
  local nowStage, totalStage = HolySpiritPointData.GetPointStageById(holySpiritPointId)
  if totalStage - 1 == nowStage then
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {index = 18, time = 1})
    else
      UIManager.Show(UIID.EffectTipUI, {effectIndex = 18, effectTime = 1})
    end
  end
  networkRequest.ReqHolySpiritLevelUp(gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType(), gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritPointId())
end

function Equip_HolySpiritRightUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolySpiritRightUI:RegistEvents()
  self:RegistEvent(Event.RefreshHolySpiritPage, self.RefreshHolySpiritPage, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.BagChangeRefreshExpend, self)
end

function Equip_HolySpiritRightUI:Refresh()
  self:InitScrollView()
  self:RefreshHolySpiritPage(_, {
    CurHolySpiritType = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType(),
    CurHolySpiritPointId = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritPointId()
  })
end

function Equip_HolySpiritRightUI:InitScrollView()
  self.lab_AllAttributlParent:SetNormalizedPosition(1, 1)
  self.lab_CurrentAttributeParent:SetNormalizedPosition(1, 1)
end

function Equip_HolySpiritRightUI:RefreshHolySpiritPage(_, data)
  self:RefreshHaveHolySpiritAttribute(data.CurHolySpiritType)
  self:RefreshCurHolySpiritAttribute(data.CurHolySpiritType, data.CurHolySpiritPointId)
  self:RefreshNameTitle(data.CurHolySpiritType)
  self:RefreshExpend(data.CurHolySpiritPointId)
  self:RefreshStageUI(data.CurHolySpiritType, data.CurHolySpiritPointId)
  self:RefreshBelowUI(data.CurHolySpiritType, data.CurHolySpiritPointId)
end

function Equip_HolySpiritRightUI:RefreshHaveHolySpiritAttribute(type)
  if self.allHolySpiritAttributeTemplate then
    self.allHolySpiritAttributeTemplate:RemoveKTable()
  end
  local everyTypeAttributeDataTab = HolySpiritAttributeData.GetCurEveryTypeAttributeData(type)
  if everyTypeAttributeDataTab ~= nil and table.count(everyTypeAttributeDataTab) > 0 then
    self.allHolySpiritAttributeTemplate:SetDataKTable(everyTypeAttributeDataTab)
  end
end

function Equip_HolySpiritRightUI:RefreshCurHolySpiritAttribute(type, id)
  if self.curHolySpiritAttributeTemplate then
    self.curHolySpiritAttributeTemplate:RemoveKTable()
  end
  local attributeTab = HolySpiritAttributeData.GetAttributeDataById(type, id)
  if attributeTab ~= nil and table.count(attributeTab) > 0 then
    self.curHolySpiritAttributeTemplate:SetData(attributeTab)
  end
end

function Equip_HolySpiritRightUI:RefreshNameTitle(type)
  if self.nameTab[type] then
    self.text_AllAttribute:SetText(string.format("T\225\187\149ng thu\225\187\153c t\195\173nh %s", self.nameTab[type]))
  end
end

function Equip_HolySpiritRightUI:RefreshExpend(id)
  if self.expenditureTemplate then
    self.expenditureTemplate:RemoveKTable()
  end
  local pointExpendTab = HolySpiritPointData.GetPointExpendById(id)
  if pointExpendTab ~= nil and table.count(pointExpendTab) > 0 then
    self.expenditureTemplate:SetData(pointExpendTab)
  end
end

function Equip_HolySpiritRightUI:RefreshStageUI(type, id)
  local nowStage, totalStage = HolySpiritPointData.GetPointStageById(id)
  self.text_Stage_num:SetText(string.format("%d/%d", nowStage, totalStage))
  if totalStage - 1 == nowStage then
    self.text_Upgrade:SetText("K\195\173ch ho\225\186\161t")
  else
    self.text_Upgrade:SetText("N\195\162ng c\225\186\165p")
  end
  local grade = 0
  local typeHolySpiritDataTab = HolySpiritPointData.GetCurTypeHolySpiritData(type)
  if typeHolySpiritDataTab ~= nil and 0 < table.count(typeHolySpiritDataTab) then
    local curHolySpiritDataTab = {}
    for i, v in pairs(typeHolySpiritDataTab) do
      if v.CfgInfo.subType == gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritSubType() then
        table.insert(curHolySpiritDataTab, v)
      end
    end
    table.sort(curHolySpiritDataTab, function(a, b)
      if a.CfgInfo and b.CfgInfo then
        return a.CfgInfo.order < b.CfgInfo.order
      end
    end)
    for i, v in ipairs(curHolySpiritDataTab) do
      if v.CfgInfo.id == id then
        grade = i
        break
      end
    end
    self.text_Order:SetText(string.format("B\225\186\173c %d c\225\186\165p %d", type, grade))
  end
end

function Equip_HolySpiritRightUI:RefreshBelowUI(type, id)
  self.img_FullLevel:SetActive(false)
  self.img_NotUnlocked:SetActive(false)
  self.img_Activated:SetActive(false)
  self.Up_Parent:SetActive(true)
  local nowTypeIsActive = HolySpiritPointData.GetNowTypeIsActive(type)
  local nowPointState = HolySpiritPointData.GetNowPointStateById(id)
  local lastPointState = HolySpiritPointData.GetLastPointState(id)
  if nowTypeIsActive then
    self.Up_Parent:SetActive(false)
    self.img_FullLevel:SetActive(true)
    return
  end
  if nowPointState then
    self.Up_Parent:SetActive(false)
    self.img_Activated:SetActive(true)
    return
  end
  if not lastPointState then
    self.Up_Parent:SetActive(false)
    self.img_NotUnlocked:SetActive(true)
    return
  end
end

function Equip_HolySpiritRightUI:BagChangeRefreshExpend()
  self:RefreshExpend(gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurShowHolySpiritPointId())
end

function Equip_HolySpiritRightUI:OnHide()
end

function Equip_HolySpiritRightUI:OnDestroy()
end
