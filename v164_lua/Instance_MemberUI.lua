Instance_MemberUI = class(BaseUI)
Instance_MemberUI.layer = UILayer.Panel
Instance_MemberUI.orderInLayer = 0
Instance_MemberUI.hideType = UIHideType.WaitDestroy
Instance_MemberUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_MemberUI.escClose = UIEscClose.DontClose

function Instance_MemberUI:InitControls()
  self.bg_btnClose = self:GetControl("bg_btnClose")
  self.panelScrollView = self:GetControl("Scroll View_Floor/Viewport/panelScrollView")
  self.ContentContainer = self:GetControl("Scroll View_Floor/Viewport/panelScrollView/Viewport/ContentContainer")
  self.lab_floor = self:GetControl("Scroll View_Floor/Viewport/panelScrollView/Viewport/ContentContainer/img_instanceTemp/lab_floor")
  self.lab_level = self:GetControl("Scroll View_Floor/Viewport/panelScrollView/Viewport/ContentContainer/img_instanceTemp/lab_level")
  self.lab_condition = self:GetControl("Scroll View_Floor/Viewport/panelScrollView/Viewport/ContentContainer/img_instanceTemp/lab_condition")
  self.checkmark = self:GetControl("Scroll View_Floor/Viewport/panelScrollView/Viewport/ContentContainer/img_instanceTemp/checkmark")
  self.ToggleGroupContainer = self:GetControl("ToggleGroupContainer")
  self.btn_close = self:GetControl("btn_close")
  self.lab_titleName = self:GetControl("reinLevel/lab_titleName")
  self.btn_leftArrow = self:GetControl("reinLevel/btn_leftArrow")
  self.btn_rightArrow = self:GetControl("reinLevel/btn_rightArrow")
  self.btn_enter = self:GetControl("btn_enter")
  self.btn_member = self:GetControl("btn_member")
  self.descBtn = self:GetControl("descBtn")
end

function Instance_MemberUI:Init()
end

function Instance_MemberUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_MemberUI:InitUI()
end

function Instance_MemberUI:RegistUIEvents()
  self.bg_btnClose:SetOnClick(self, self.bg_btnCloseOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_leftArrow:SetOnClick(self, self.btn_leftArrowOnClick)
  self.btn_rightArrow:SetOnClick(self, self.btn_rightArrowOnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
  self.btn_member:SetOnClick(self, self.btn_memberOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Instance_MemberUI:bg_btnCloseOnClick(control)
  UIManager.Hide(UIID.Instance_MemberUI)
end

function Instance_MemberUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Instance_MemberUI)
end

function Instance_MemberUI:btn_leftArrowOnClick(control)
  self.mapId = nil
  self.subIndex = 1
  local temp = self.mainIndex - 1
  self.mainIndex = temp <= 1 and 1 or temp
  self:Refresh()
end

function Instance_MemberUI:btn_rightArrowOnClick(control)
  self.mapId = nil
  self.subIndex = 1
  local temp = self.mainIndex
  local dicTypeTabs = ClientTable.cfg_Npc_instance_transferManager:GetAllTabsByNpcId(self.npcId)
  local maxValue = table.count(dicTypeTabs)
  if maxValue <= self.mainIndex + 1 then
    self.mainIndex = maxValue
  else
    self.mainIndex = self.mainIndex + 1
  end
  self:Refresh()
end

function Instance_MemberUI:btn_enterOnClick(control)
  if self.cfg_Npc_instance_transfer == nil then
    return
  end
  local cfg_map = ClientTable.cfg_Map_mapManager:TryGetValue(tonumber(self.cfg_Npc_instance_transfer.mapId))
  local isMeetCondition = ConditionManager.Check4D(cfg_map.enterCondition)
  if isMeetCondition then
    local MapTransferDataList = gameMgr:GetMapManager():GetMapTransferListData():GetMapTransferData({
      sourceType = MapTransferSourceType.Npc,
      id = self.npcId
    })
    for key, value in pairs(MapTransferDataList) do
      if cfg_map.id == value.MapData.mapTable.id then
        value.MapData:TransferMap()
        UIManager.Hide(UIID.Instance_MemberUI)
        break
      end
    end
  else
    FloatingTipUtility.QuickMsg("Kh\195\180ng \196\145\225\186\161t \196\145i\225\187\129u ki\225\187\135n v\195\160o")
  end
end

function Instance_MemberUI:btn_memberOnClick(control)
  gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():JumpMemberUIById(self.showVipLevel)
  UIManager.Hide(UIID.Instance_MemberUI)
end

function Instance_MemberUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_MemberUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Instance_MemberUI:panelScrollViewOnEndDrag()
  local rectTrans = self.ContentContainer.transform:GetComponent("RectTransform")
  local rectTransSV = self.panelScrollView.transform:GetComponent("RectTransform")
  local offset = math.floor(rectTransSV.sizeDelta.x / 3)
  if offset < rectTrans.localPosition.x then
    self:btn_leftArrowOnClick()
  elseif rectTrans.localPosition.x < -offset then
    self:btn_rightArrowOnClick()
  end
end

function Instance_MemberUI:JumpPanel()
  self.subIndex = self.args.subIndex
  self.mainIndex = self.args.page
end

function Instance_MemberUI:OnShow()
  self:RegistEvents()
  self:InitData()
  self:InitRefresh()
end

function Instance_MemberUI:RegistEvents()
  self.panelScrollView:SetOnEndDrag(self, self.panelScrollViewOnEndDrag)
end

function Instance_MemberUI:InitRefresh()
  if self.dicTypeTabs == nil then
    self.dicTypeTabs = ClientTable.cfg_Npc_instance_transferManager:GetAllTabsByNpcId(self.npcId)
  end
  self.mainIndex, self.subIndex = self.args.page, self.args.subIndex
  if self.args.param then
    self.mainIndex, self.subIndex = self:MapIdGetViewPos(self.args.param.groupId)
  end
  if self.mainIndex == nil and self.subIndex == nil then
    self.mainIndex, self.subIndex = self:GetRecommendPageAndSubIndex()
  end
  self.mainIndex, self.subIndex = self.mainIndex or 1, self.subIndex or 1
  self:Refresh()
end

function Instance_MemberUI:Refresh()
  local listTypeTabs = self.dicTypeTabs[self.mainIndex]
  local dicTypeTabsCount = table.count(self.dicTypeTabs)
  self:RefreshUI(listTypeTabs)
  self:RefreshCheckmark(dicTypeTabsCount)
  self:RefreshArrow(dicTypeTabsCount)
end

function Instance_MemberUI:GetRecommendPageAndSubIndex()
  local recommendPage, recommendSubIndex
  for k, v in pairs(self.dicTypeTabs) do
    for k1, npcInstanceTransferTbl in pairs(v) do
      local CanEnter = ClientTable.cfg_Map_mapManager:IsRecommendMemberMap(tonumber(npcInstanceTransferTbl.mapId))
      if CanEnter == false then
        return recommendPage, recommendSubIndex
      else
        recommendPage, recommendSubIndex = k, k1
      end
    end
  end
  return recommendPage, recommendSubIndex
end

function Instance_MemberUI:OnHide()
  EventManager.Dispatch(Event.CancelClickNpc)
end

function Instance_MemberUI:OnDestroy()
end

function Instance_MemberUI:InitData()
  self.mainIndex = 1
  self.subIndex = 1
  self.showVipLevel = 1
  if self.args then
    self.npcId = self.args.npcConfigID
    if self.args.param then
      self.mapId = self.args.param.groupId
    end
  end
end

function Instance_MemberUI:RefreshUI(_listTypeTabs)
  local count = table.count(_listTypeTabs)
  self.ContentContainer:SetTopGridMaxCount(count)
  local playerLevel = QuickFind.LuaMainPlayerViewAttrData().level
  local playerMemberLevel = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberLevle()
  local index = 1
  local defalutObj, recommendPage, recommendSubIndex
  if self.args.param and self.args.param.groupId then
    recommendPage, recommendSubIndex = self:MapIdGetViewPos(self.args.param.groupId)
  else
    recommendPage, recommendSubIndex = self:GetRecommendPageAndSubIndex()
  end
  for key, value in pairs(_listTypeTabs) do
    local go = self.ContentContainer:GetTopGridObjectList()[index - 1].transform
    local goTrans = UIControl(go)
    local lab_floor = UIControl(go, "lab_floor")
    local lab_level = UIControl(go, "lab_level")
    local lab_condition = UIControl(go, "lab_condition")
    local checkmark = UIControl(go, "checkmark")
    local img_recommon = UIControl(go, "img_recommon")
    checkmark:SetActive(false)
    img_recommon:SetActive(self.mainIndex == recommendPage and index == recommendSubIndex)
    local cfg_tab = value
    local cfg_map = ClientTable.cfg_Map_mapManager:TryGetValue(tonumber(cfg_tab.mapId))
    lab_floor:SetText(cfg_map.name)
    local conditionTab = self:GetConditionParam(cfg_map.enterCondition)
    local desArray = string.split(cfg_tab.des, "#")
    local isMeetPlayerLevel = conditionTab.paramLevelGEqual ~= 0 and playerLevel >= conditionTab.paramLevelGEqual or false
    local levelColorStr = isMeetPlayerLevel and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
    lab_level:SetText(string.format("<color=%s>%s</color>", levelColorStr, desArray[1]))
    if conditionTab.paramMemberLevelGreater == 0 and conditionTab.paramMemberLevelEqual == 0 then
      lab_condition:SetText("")
    else
      local isMeetMemberLvGreater = conditionTab.paramMemberLevelGreater ~= 0 and playerMemberLevel > conditionTab.paramMemberLevelGreater or false
      local isMeetMemberLvEqual = conditionTab.paramMemberLevelEqual ~= 0 and playerMemberLevel >= conditionTab.paramMemberLevelEqual or false
      local memberLevelColorStr = (isMeetMemberLvGreater or isMeetMemberLvEqual) and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
      lab_condition:SetText(string.format("<color=%s>%s</color>", memberLevelColorStr, desArray[2]))
    end
    local param = {
      cfg_Npc_instance_transfer = cfg_tab,
      clickIndex = index,
      conditionTab = conditionTab
    }
    goTrans:SetOnClickParam(self, self.btn_subMenuOnClick, param)
    if index == self.subIndex then
      goTrans.param = param
      defalutObj = goTrans
    end
    index = index + 1
  end
  self:btn_subMenuOnClick(defalutObj)
end

function Instance_MemberUI:RefreshCheckmark(_count)
  local tipName = ""
  if self.mainIndex > 1 then
    tipName = "B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n Sinh"
  else
    tipName = string.format("B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n %d", tonumber(self.mainIndex) - 1)
  end
  self.lab_titleName:SetText(tipName)
  self.ToggleGroupContainer:SetTopGridMaxCount(_count)
  for i = 1, _count do
    local go = self.ToggleGroupContainer:GetTopGridObjectList()[i - 1].transform
    local checkmark = UIControl(go, "Background/Checkmark")
    checkmark:SetActive(i == self.mainIndex)
  end
end

function Instance_MemberUI:RefreshArrow(_count)
  local maxValue = _count
  if self.mainIndex == maxValue then
    self.btn_rightArrow:SetActive(false)
  else
    self.btn_rightArrow:SetActive(true)
  end
  if self.mainIndex == 1 then
    self.btn_leftArrow:SetActive(false)
  else
    self.btn_leftArrow:SetActive(true)
  end
end

function Instance_MemberUI:btn_subMenuOnClick(control)
  local param = control.param
  self.subIndex = param.clickIndex
  self.cfg_Npc_instance_transfer = param.cfg_Npc_instance_transfer
  if param.conditionTab.paramMemberLevelGreater ~= 0 then
    self.showVipLevel = param.conditionTab.paramMemberLevelGreater
  elseif param.conditionTab.paramMemberLevelEqual ~= 0 then
    self.showVipLevel = param.conditionTab.paramMemberLevelEqual
  end
  if self.lastSub_clickeffect ~= nil then
    self.lastSub_clickeffect.gameObject:SetActive(false)
  end
  self.lastSub_clickeffect = UIControl(control.transform, "checkmark")
  self.lastSub_clickeffect:SetActive(true)
end

function Instance_MemberUI:GetConditionParam(conditionCfg)
  local conditionTab = {
    paramLevelGEqual = 0,
    paramMemberLevelGreater = 0,
    paramMemberLevelEqual = 0
  }
  if type(conditionCfg) == "table" then
    local groupStr = conditionCfg
    for i = 1, #groupStr do
      local singleStrs = groupStr[i]
      for j = 1, #singleStrs do
        local singleCondition = singleStrs[j]
        local stype = tonumber(singleCondition[1])
        local param = singleCondition[2]
        if stype == EConditionEnum.levelGEqual then
          conditionTab.paramLevelGEqual = param
        elseif stype == EConditionEnum.memberLevelGreater then
          conditionTab.paramMemberLevelGreater = param
        elseif stype == EConditionEnum.memberLevelGEqual then
          conditionTab.paramMemberLevelEqual = param
        end
      end
    end
  end
  return conditionTab
end

function Instance_MemberUI:MapIdGetViewPos(groupId)
  if groupId then
    for page = 1, #self.dicTypeTabs do
      local pageTab = self.dicTypeTabs[page]
      for subIndex = 1, #pageTab do
        if tonumber(pageTab[subIndex].mapId) == groupId then
          return page, subIndex
        end
      end
    end
  end
end
