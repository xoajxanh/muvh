WarAlliance_Armband = class(BaseUI)
WarAlliance_Armband.layer = UILayer.Panel
WarAlliance_Armband.orderInLayer = 2
WarAlliance_Armband.hideType = UIHideType.Destroy
WarAlliance_Armband.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Armband.escClose = UIEscClose.DontClose

function WarAlliance_Armband:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.TwoTierCloseBtn = self:GetControl("img_bg/TwoTierCloseBtn")
  self.ArmbandsDescBtn = self:GetControl("ArmbandsDescBtn")
  self.GradArmbandsItem = self:GetControl("Bg/GradArmbandsShow/Viewport/Content/GradArmbandsItem")
  self.lab_ArmbandName = self:GetControl("value/lab_ArmbandName")
  self.star1 = self:GetControl("value/lab_ArmbandName/starAn1/star1")
  self.star2 = self:GetControl("value/lab_ArmbandName/starAn2/star2")
  self.star3 = self:GetControl("value/lab_ArmbandName/starAn3/star3")
  self.star4 = self:GetControl("value/lab_ArmbandName/starAn4/star4")
  self.star5 = self:GetControl("value/lab_ArmbandName/starAn5/star5")
  self.btn_upgrade = self:GetControl("value/btn_upgrade")
  self.lab_upLevel = self:GetControl("value/btn_upgrade/lab_upLevel")
  self.img_redPoint = self:GetControl("value/btn_upgrade/img_redPoint")
  self.item_armband1 = self:GetControl("value/sw_armband/Viewport/Content/item_armband1")
  self.item_armband2 = self:GetControl("value/sw_armband/Viewport/Content/item_armband2")
  self.item_armband3 = self:GetControl("value/sw_armband/Viewport/Content/item_armband3")
  self.item_armband4 = self:GetControl("value/sw_armband/Viewport/Content/item_armband4")
  self.item_armband5 = self:GetControl("value/sw_armband/Viewport/Content/item_armband5")
  self.ContributionLevel = self:GetControl("value/img_Material/ContributionLevel")
  self.Grid = self:GetControl("value/img_Material/sw_armbandMaterial/Viewport/Grid")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
end

function WarAlliance_Armband:Init()
end

function WarAlliance_Armband:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Armband:InitUI()
  self:InitContent()
end

function WarAlliance_Armband:OnShow()
  self:RegistEvents()
  self:SetFistPage()
  self.isInit = true
  self:Refresh()
end

function WarAlliance_Armband:OnHide()
end

function WarAlliance_Armband:OnDestroy()
end

function WarAlliance_Armband:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.ArmbandsDescBtn:SetOnClick(self, self.ArmbandsDescBtnOnClick)
  self.TwoTierCloseBtn:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_upgrade:SetOnClick(self, self.btn_upgradeOnClick)
end

function WarAlliance_Armband:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Armband)
end

function WarAlliance_Armband:ArmbandsDescBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "WarAlliance_Armband")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function WarAlliance_Armband:btn_upgradeOnClick(uiControl)
  if self.isMaxByLevel then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("WarAlliance_Armband_limit"))
    return
  end
  if not self.canUp then
    if self.armBandData and self.armBandData.notMeetconsum then
      local itemData = ItemUtility.GenerateItemData(self.armBandData.notMeetconsum.itemId)
      UIManager.Show(UIID.ItemTipUI, {
        item = itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = uiControl,
        ShowObtain = true,
        OpenWay = EOpenTipsType.FastBuy
      })
    else
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("WarAlliance_Resources"))
    end
    return
  end
  networkRequest.ReqRoleBadgeLevelUp(self.armBandType)
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {
      name = "Eff_UI_zhanmenshengji",
      time = 1
    })
  else
    UIManager.Show(UIID.EffectTipUI, {
      name = "Eff_UI_zhanmenshengji",
      effectTime = 1
    })
  end
end

function WarAlliance_Armband:RegistEvents()
  self:RegistEvent(Event.Mu2_WarAlliance_MyArmbandData, self.ArmbandInfoChangedCallBack, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshCostView, self)
end

function WarAlliance_Armband:ShowNeedData()
  if WarAllianceData.IsHaveUnion then
    NetManager.Send(UnionMessage.ReqBadgeInfo)
  end
end

function WarAlliance_Armband:ArmbandInfoChangedCallBack()
  self:Refresh()
end

function WarAlliance_Armband:Refresh()
  self:RefreshArmbandData()
  self:RefreshView()
end

function WarAlliance_Armband:InitContent()
  self.GradArmbandsItemTemp = UIContainer(self.GradArmbandsItem)
  self.starTab = {
    [1] = self.star1,
    [2] = self.star2,
    [3] = self.star3,
    [4] = self.star4,
    [5] = self.star5
  }
  self.maxStarCount = 5
end

function WarAlliance_Armband:GetUnionArmbandMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr()
  end
end

function WarAlliance_Armband:SelectType(type)
  if type == self.armBandType then
    return
  end
  self:SetFistPage(type)
  self:Refresh()
end

function WarAlliance_Armband:SetFistPage(type)
  if type and type ~= self.armBandType then
    self.armBandType = type
    return
  end
  self.armBandType = self.armBandType or WarAllianceBadgeTag.HP
  if self.args ~= nil and self.args.type ~= nil then
    self.armBandType = self.args.type
  end
end

function WarAlliance_Armband:RefreshArmbandData()
  self.armBandData = self:GetUnionArmbandMgr():GetArmbandDataByType(self.armBandType)
  if self.armBandData == nil then
    return
  end
  self.logData = self:GetUnionArmbandMgr():GetArmbandLogoInfo()
  self.unionLevel = self:GetUnionArmbandMgr():GetUnionLevel()
  self.maxTbl = ClientTable.cfg_union_badgeManager:TryGetValue(self.armBandData.maxId)
  self.curTbl = ClientTable.cfg_union_badgeManager:TryGetValue(self.armBandData.id)
  self.nextTbl = ClientTable.cfg_union_badgeManager:TryGetValue(self.armBandData.nextId)
  self.isMaxByLevel = self.armBandData.id >= self.armBandData.maxId
  self.isMax = self.nextTbl == nil
  self.consumableTbl = self.armBandData.consumable
  self.canUp = self:GetUnionArmbandMgr():GetArmbandStateByType(self.armBandData.type)
end

function WarAlliance_Armband:RefreshView()
  if self.armBandData == nil then
    return
  end
  self:RefreshArmbandView()
  self:RefreshStarView()
  self:RefreshAttributeView()
  self:RefreshCostView()
  self:RefreshBtnView()
  self:RefreshMaxlevelView()
  if self.isInit then
    self.isInit = false
    self:RefreshLogoView()
  end
end

function WarAlliance_Armband:RefreshLogoView()
  local data = WarAllianceData.MyWarAllianceData
  if data == nil or data.logo == nil then
    return
  end
  local isNeedRender = false
  self.GradArmbandsItemTemp:SetActiveTable()
  for i = 1, WarAllianceData.ArmbandsDesignGridNum do
    local obj = self.GradArmbandsItemTemp:GetOrCreateItem(i)
    obj:SetActive(true)
    isNeedRender = data.logo[i] ~= 0
    if data.logo[i] ~= 0 then
      obj:SetColor(data.logo[i])
    end
    obj.image.enabled = isNeedRender
  end
end

function WarAlliance_Armband:RefreshArmbandView()
  self.lab_ArmbandName:SetText(self:GetArmbandName(self.curTbl))
  if not self.isMax then
    local unionLevelStr = string.GetColorText(table.concat({
      "C\225\186\165p Guild",
      self.unionLevel
    }), ItemQuality2ColorDic[5])
    local maxArmbandStr = string.GetColorText(self:GetArmbandName(self.maxTbl), ItemQuality2ColorDic[24])
    self.ContributionLevel:SetText(string.format("Hi\225\187\135n t\225\186\161i %s, gi\225\187\155i h\225\186\161n Ph\195\185 Hi\225\187\135u %s", unionLevelStr, maxArmbandStr))
  else
    self.ContributionLevel:SetText("")
  end
end

function WarAlliance_Armband:RefreshStarView()
  for i = 1, self.maxStarCount do
    self.starTab[i]:SetActive(i <= self.armBandData.startNum)
  end
end

function WarAlliance_Armband:RefreshAttributeView()
  local attributeTbl = self:GetArmbandAttributeTbl()
  local count = table.count(attributeTbl)
  for i = 1, 5 do
    if i > count then
      self:SetAttributeItem(i, nil, nil, nil, false, nil, nil)
    else
      self:SetAttributeItem(i, attributeTbl[i].name, attributeTbl[i].curValue, attributeTbl[i].nextValue, true, not self.isMax, attributeTbl[i].isUp)
    end
  end
end

function WarAlliance_Armband:RefreshCostView()
  if self.consumableTbl == nil then
    self.Grid:SetTopGridMaxCount(0)
    return
  end
  self.Grid:SetTopGridMaxCount(table.count(self.consumableTbl))
  for i, v in pairs(self.consumableTbl) do
    local object = self.Grid:GetTopGridObjectList()[i - 1]
    if self.costTemplateDic == nil then
      self.costTemplateDic = {}
    end
    if self.costTemplateDic[object] == nil then
      self.costTemplateDic[object] = luaTemplateManager.GetNewTemplate(object, LuaComponentTemplates.ConsumableUnitTemplate)
    end
    self.costTemplateDic[object]:Refresh(v, self)
  end
end

function WarAlliance_Armband:RefreshBtnView()
  if self.isMax then
    self.lab_upLevel:SetText("\196\144\195\163 \196\145\225\186\167y c\225\186\165p")
  else
    self.lab_upLevel:SetText("N\195\162ng c\225\186\165p")
  end
  self.btn_upgrade:SetActive(not self.isMax)
  self.img_redPoint:SetActive(self.canUp and not self.isMaxByLevel)
end

function WarAlliance_Armband:RefreshMaxlevelView()
  self.Img_maxlevel:SetActive(self.isMax)
end

function WarAlliance_Armband:GetArmbandName(tbl)
  if tbl == nil then
    return ""
  end
  return tbl.badgeLord
end

function WarAlliance_Armband:GetArmbandAttributeTbl()
  local attrebuteTbl = {}
  local curValue = ""
  local nextValue = ""
  local curMaxValue = ""
  local nextMaxValue = ""
  curValue = self.curTbl.maximumHealth
  nextValue = self.nextTbl ~= nil and self.nextTbl.maximumHealth or 0
  if curValue ~= 0 or nextValue ~= 0 then
    local temp = {}
    temp.name = "HP"
    temp.curValue = tostring(curValue) or ""
    temp.nextValue = tostring(nextValue) or ""
    temp.isUp = curValue < nextValue
    table.insert(attrebuteTbl, temp)
  end
  curValue = self.curTbl.minimumPhysBaseDmg
  curMaxValue = self.curTbl.maximumPhysBaseDmg
  nextValue = self.nextTbl ~= nil and self.nextTbl.minimumPhysBaseDmg or 0
  nextMaxValue = self.nextTbl ~= nil and self.nextTbl.maximumPhysBaseDmg or 0
  if curValue ~= 0 and curMaxValue ~= 0 or nextValue ~= 0 and nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "T\225\186\165n c\195\180ng"
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    table.insert(attrebuteTbl, temp)
  end
  curValue = self.curTbl.minimumWizBaseDmg
  curMaxValue = self.curTbl.maximumWizBaseDmg
  nextValue = self.nextTbl ~= nil and self.nextTbl.minimumWizBaseDmg or 0
  nextMaxValue = self.nextTbl ~= nil and self.nextTbl.maximumWizBaseDmg or 0
  if curValue ~= 0 and curMaxValue ~= 0 or nextValue ~= 0 and nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "C\195\180ng ph\195\169p"
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    table.insert(attrebuteTbl, temp)
  end
  curValue = self.curTbl ~= nil and self.curTbl.minimumCurseBaseDmg or 0
  curMaxValue = self.curTbl ~= nil and self.curTbl.maximumCurseBaseDmg or 0
  nextValue = self.nextTbl ~= nil and self.nextTbl.minimumCurseBaseDmg or 0
  nextMaxValue = self.nextTbl ~= nil and self.nextTbl.maximumCurseBaseDmg or 0
  if curValue ~= 0 or curMaxValue ~= 0 or nextValue ~= 0 or nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "T\225\186\165n C\195\180ng Nguy\225\187\129n R\225\187\167a "
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    table.insert(attrebuteTbl, temp)
  end
  curValue = self.curTbl.defenseBase
  nextValue = self.nextTbl ~= nil and self.nextTbl.defenseBase or 0
  if curValue ~= 0 or nextValue ~= 0 then
    local temp = {}
    temp.name = "Ph\195\178ng Th\225\187\167"
    temp.curValue = tostring(curValue) or ""
    temp.nextValue = tostring(nextValue) or ""
    temp.isUp = curValue < nextValue
    table.insert(attrebuteTbl, temp)
  end
  return attrebuteTbl
end

function WarAlliance_Armband:SetAttributeItem(index, name, currentValue, nextValue, isShow, isNext, isUp)
  local node = self[string.format("item_armband%s", index)]
  if isShow then
    local currentNode = UIControl(node.transform, "node_current")
    local currentNameLab = UIControl(node.transform, "node_current/labName")
    local currentValueLab = UIControl(node.transform, "node_current/lab_count")
    local nextNode = UIControl(node.transform, "node_next")
    local nextValueLab = UIControl(node.transform, "node_next/lab_count_next")
    local arrowNode = UIControl(node.transform, "node_next/Image2")
    currentNameLab:SetText(name)
    currentValueLab:SetText(currentValue)
    nextValueLab:SetText(string.GetColorText(nextValue, isUp and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[0]))
    nextNode:SetActive(isNext)
    arrowNode:SetActive(isUp)
    if isNext then
      currentNode.transform.localPosition = Vector3(-80, 0, 0)
    else
      currentNode.transform.localPosition = Vector3(0, 0, 0)
    end
  end
  node:SetActive(isShow)
end
