Instance_BloodCastleUI = class(BaseUI)
Instance_BloodCastleUI.layer = UILayer.Panel
Instance_BloodCastleUI.orderInLayer = 0
Instance_BloodCastleUI.hideType = UIHideType.WaitDestroy
Instance_BloodCastleUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_BloodCastleUI.escClose = UIEscClose.DontClose

function Instance_BloodCastleUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_level = self:GetControl("Middel/level/lab_level")
  self.lab_def = self:GetControl("Middel/def/lab_def")
  self.lab_condition = self:GetControl("Middel/tx_condition/lab_condition")
  self.grid = self:GetControl("Middel/lab_rewards/grid")
  self.btn_3DItem = self:GetControl("Middel/lab_rewards/grid/btn_3DItem")
  self.numberPeople = self:GetControl("Middel/numberPeople")
  self.lab_count1 = self:GetControl("Middel/lab_leftcount/lab_count1")
  self.btn_get1 = self:GetControl("Middel/lab_leftcount/btn_get1")
  self.lab_already = self:GetControl("Middel/lab_requirements/lab_already")
  self.img_itemicon = self:GetControl("Middel/lab_requirements/img_itemicon")
  self.btn_get2 = self:GetControl("Middel/lab_requirements/btn_get2")
  self.btn_enter = self:GetControl("Middel/btn_enter")
  self.btn_team = self:GetControl("Middel/btn_team")
  self.BLevelContent = self:GetControl("ScrollviewLevel/Viewport/BLevelContent")
  self.levelBtnItem = self:GetControl("ScrollviewLevel/Viewport/BLevelContent/levelBtnItem")
  self.descBtn = self:GetControl("descBtn")
  self.explain_btn = self:GetControl("explain_btn")
end

function Instance_BloodCastleUI:OnPreLoad()
end

function Instance_BloodCastleUI:Init()
  self.enterConditionData = {}
  self.ContentData = {}
  self.LevelAndNumber = {}
  self.MyLevelTab = {obj = nil, level = nil}
end

function Instance_BloodCastleUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_BloodCastleUI:InitUI()
  self:InitContent()
end

function Instance_BloodCastleUI:OnShow()
  if TeamUpQuicklyData.TeamInfor then
    FloatingWordUtility.QuickMsg("\196\144ang ch\225\187\157 \196\145\225\187\153i")
    UIManager.Hide(self.name)
    return
  end
  self:RegistEvents()
  self:Refresh()
end

function Instance_BloodCastleUI:OnHide()
  if self.normalTimer then
    Timer.Stop(self.normalTimer)
    self.normalTimer = nil
  end
  for i = 1, #self.btn_ItemTemp.items do
    local obj = self.btn_ItemTemp.items[i]
    obj.itemCellData:RecycleRes()
  end
end

function Instance_BloodCastleUI:OnDestroy()
end

function Instance_BloodCastleUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
  self.btn_team:SetOnClick(self, self.btn_teamOnClick)
  self.explain_btn:SetOnClick(self, self.btn_explainOnClick)
  self:SetBtn_get2Click()
end

function Instance_BloodCastleUI:SetBtn_get2Click()
  local itemData = ItemUtility.GenerateItemData(8000050)
  self.btn_get2.itemData = itemData
  self.btn_get2.countDownTime = self.intervalTime
  self.btn_get2.itemData.isHide = true
  self.btn_get2.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_get2:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Instance_BloodCastleUI:btn_closeOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  for i = 1, #self.btn_ItemTemp.items do
    local obj = self.btn_ItemTemp.items[i]
    obj.itemCellData:RecycleRes()
  end
  UIManager.Hide(UIID.Instance_BloodCastleUI)
end

local instanceCount = 0
local itemID

local function InterfaceInforCheck()
  if not (0 < instanceCount) then
    TipUtility.ShowPrompt("tishi", "InstanceCountInsufficient")
    return false
  end
  local temp = {}
  if 0 >= BagInfoData.GetItemTotalCountByItemId(itemID) then
    temp.itemData = ItemUtility.GenerateItemData(itemID)
    temp.itemData.isHide = true
    UIManager.Show(UIID.ItemTipUI, {
      item = temp.itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = temp,
      ShowObtain = true
    })
    return false
  end
  return true
end

function Instance_BloodCastleUI:btn_get2OnClick(control)
  local temp = {}
  temp.itemData = ItemUtility.GenerateItemData(itemID)
  UIManager.Show(UIID.ItemTipUI, {
    item = temp.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = temp,
    ShowObtain = true
  })
end

function Instance_BloodCastleUI:btn_enterOnClick(control)
  if not InterfaceInforCheck() then
    return
  end
  local drugItemId = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1100004), "|")
  local drugMpItemId = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1100005), "|")
  local minNum = 140
  local number = 0
  local MpNumber = 0
  local state = false
  for k, v in pairs(drugItemId) do
    number = number + BagInfoData.GetItemCountByItemConfigId(tonumber(v))
  end
  for k, v in pairs(drugMpItemId) do
    MpNumber = MpNumber + BagInfoData.GetItemCountByItemConfigId(tonumber(v))
  end
  state = not (minNum <= number) or not (minNum <= MpNumber)
  if state then
    local prompTipArgs = {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "B\225\186\161n mang theo qu\195\161 \195\173t thu\225\187\145c, c\195\179 v\195\160o kh\195\180ng?",
      cancelText = "V\195\160o",
      okText = "Mua",
      autoClose = true,
      ok = function()
        local openDir = PlayerControlForceData.BagShopIsOpen()
        if openDir then
          UIManager.Show(UIID.BagShopInfoUI)
        else
          TipUtility.ShowShopOpenPrompt()
        end
      end,
      cancel = function()
        self:enterBloodCastle()
        UIManager.Hide(UIID.PromptTipUI)
      end
    }
    UIManager.Show(UIID.PromptTipUI, prompTipArgs)
  else
    self:enterBloodCastle()
  end
end

function Instance_BloodCastleUI:enterBloodCastle()
  local mapData = {
    mapId = self.enterConditionData.id
  }
  if TeamData.isInTeam and #TeamData.membersList > 1 then
    if TeamData.isLeader then
      local allLine = true
      for i = 1, #TeamData.membersList do
        if not TeamData.membersList[i].online then
          allLine = false
          break
        end
      end
      if allLine then
        TeamUpQuicklyData.SetInstanceUI(self.name)
        UIManager.Hide(UIID.Instance_BloodCastleUI)
        NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCreateTeam, {
          instanceId = self.ContentData.mapId
        })
      else
        FloatingTipUtility.QuickMsg("Trong \196\145\225\187\153i c\195\179 \196\145\225\187\153i vi\195\170n kh\195\180ng online, kh\195\180ng th\225\187\131 m\225\187\159 ph\195\179 b\225\186\163n")
      end
    else
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("instance_teamready"))
    end
  else
    UIManager.Hide(UIID.Instance_BloodCastleUI)
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  end
  EventManager.Dispatch(Event.CancelClickNpc)
end

function Instance_BloodCastleUI:btn_explainOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_BloodCastleUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Instance_BloodCastleUI:btn_teamOnClick(control)
  if not InterfaceInforCheck() then
    return
  end
  local prompTipArgs = {
    title = LocalizationUtility.GetContentByKey("tishi"),
    textContent = LocalizationUtility.GetContentByKey("TeamUpQuicklyTip"),
    ok = function()
      UIManager.Hide(UIID.PromptTipUI)
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCreateTeam, {
        instanceId = self.ContentData.mapId
      })
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Instance_BloodCastleUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResSaleChange, self)
end

function Instance_BloodCastleUI:Refresh()
  self.meData = ViewData.meData
  self:SetLevelPanel()
  self.enterConditionData, self.LevelAndNumber = TranScriptData.GetEnterConditionData(TranScriptData.TranScriptSubType.BloodCastle, 100414, 100404)
  self.ContentData = TranScriptData.GetContentData()
  TranScriptData.RefreshOpenTime(self.ContentData.mapId)
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(self.ContentData.mapId, "id")
  local openCondition = string.split(mapTbl.openCondition, "#")
  local taskID = tonumber(openCondition[table.count(openCondition)])
  self.intervalTime = TranScriptData.startTime - Time.GetServerSecondTime()
  if self.intervalTime <= 0 or RefreshData:CheckIsFirstEnter(3020402) or TaskData.GetTaskById(taskID) and TaskData.GetTaskById(taskID):GetState() == TaskStateType.Accept then
    self.isSatisfy = true
    self.lab_condition:SetText(string.GetColorText("\196\144\195\163 m\225\187\159", "#1ADD1F"))
  else
    self.isSatisfy = false
    self:ShowTimer(self.intervalTime, self.lab_condition)
  end
  self:lab_levelOnClick(self.MyLevelTab.obj, self.MyLevelTab.level)
  self:SetBtn_get2Click()
end

function Instance_BloodCastleUI:ShowTimer(surplusTime, lab_countdown)
  local function UpdateTimer()
    local timeStr = TimeUtility.ShowTime(surplusTime)
    
    surplusTime = surplusTime - 1
    lab_countdown:SetText(string.GetColorText(tostring(timeStr), "#FF2323"))
    if surplusTime == 0 and self.normalTimer then
      Timer.Stop(self.normalTimer)
      self.normalTimer = nil
      self.isSatisfy = true
      lab_countdown:SetText(string.GetColorText("\196\144\195\163 m\225\187\159", "#1ADD1F"))
    end
  end
  
  self.normalTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

local function levelBtnItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
end

function Instance_BloodCastleUI:InitContent()
  self.btn_ItemTemp = UIContainer(self.btn_3DItem)
  self.levelComID = 101002
  self.LevelTab = {}
  self.levelBtnItemTemp = UIContainer(self.levelBtnItem, self, levelBtnItemCreate)
end

local str = "L\195\162u \196\145\195\160i th\225\187\169 %d\n %s"

function Instance_BloodCastleUI:SetLevelPanel()
  local num = 0
  self.levelTab = TranScriptData.GetLevelTblData(100414)
  local posIndex
  local totalCount = 0
  for i = 1, table.count(self.levelTab) do
    local strLevel = string.split(self.levelTab[i], "#")
    local level = strLevel[3]
    local levelNum = string.split(level, "_")
    local transTable = ClientTable.cfg_Map_instanceManager:TryGetValue(tonumber(strLevel[1]), "mapId")
    if transTable.type == TranScriptData.TranScriptSubType.BloodCastle then
      num = num + 1
      do
        local obj = self.levelBtnItemTemp:GetOrCreateItem(i)
        local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(tonumber(levelNum[1]))
        local lvLeft = tbl ~= nil and tbl.name or levelNum[1]
        tbl = ClientTable.cfg_Character_levelManager:TryGetValue(tonumber(levelNum[2]))
        local lvRight = tbl ~= nil and tbl.name or levelNum[2]
        obj.lab_level:SetText(string.format(str, num, lvLeft .. "~" .. lvRight))
        totalCount = totalCount + 1
        if QuickFind.LuaMainPlayerViewAttrData().level >= tonumber(levelNum[1]) and QuickFind.LuaMainPlayerViewAttrData().level <= tonumber(levelNum[2]) then
          posIndex = i
          self.MyLevelTab.obj = obj
          self.MyLevelTab.level = levelNum
          obj.button.enabled = true
        else
          obj.button.enabled = false
        end
        obj:SetOnClick(self, function()
          self:lab_levelOnClick(obj, levelNum)
        end)
        self.LevelTab[i] = obj
      end
    end
  end
  self:SetButtonState()
  local _, height = self.levelBtnItem:GetSizeDelta()
  self.BLevelContent:SetSizeDelta(0, height * totalCount + 400)
  if posIndex then
    self.BLevelContent.transform.anchoredPosition = Vector2(0, height * (posIndex - 2))
  end
end

function Instance_BloodCastleUI:SetButtonState()
  for k, v in pairs(self.LevelTab) do
    if v.button.enabled == false then
      self:SetSprite("Atlas_Common", "ty_btn_click_L_N_grey", v)
    end
  end
end

function Instance_BloodCastleUI:lab_levelOnClick(Obj, level)
  if tonumber(self.meData.level) < tonumber(level[1]) then
    FloatingWordUtility.QuickMsg("Kh\195\180ng \196\145\225\187\167 c\225\186\165p")
    return
  end
  self.enterConditionData, self.LevelAndNumber = TranScriptData.GetEnterConditionData(TranScriptData.TranScriptSubType.BloodCastle, 100414, 100404, level[1])
  self.ContentData = TranScriptData.GetContentData()
  self:SetPanel()
  self:SetButtonPitchOn(self.LevelTab, Obj)
end

function Instance_BloodCastleUI:SetButtonPitchOn(ObjTab, Control)
  for k, v in pairs(ObjTab) do
    if v == Control then
      v:GetChild("img_clickeffect"):SetActive(true)
    else
      v:GetChild("img_clickeffect"):SetActive(false)
    end
  end
end

function Instance_BloodCastleUI:SetPanel()
  local item = string.split(self.enterConditionData.cost, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(item[1]))
  itemData.count = tonumber(item[2])
  itemID = itemData.itemId
  self.img_itemicon.itemCellData = self.img_itemicon.itemCellData or ItemCellData()
  self.img_itemicon.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.img_itemicon, self.img_itemicon.itemCellData, self, true)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(item[1]))
  local strColor = string.format("%d/1", bagCount)
  if 0 < bagCount then
    self.btn_get2:SetActive(false)
    self.lab_already:SetText(string.GetColorText(strColor, ItemQuality2ColorDic[5]))
  else
    self.btn_get2:SetActive(true)
    self.lab_already:SetText(string.GetColorText(strColor, ItemQuality2ColorDic[7]))
  end
  local lvLeft = ClientTable.cfg_Character_levelManager:GetLevelDes(tonumber(self.LevelAndNumber[2]))
  local lvRight = ClientTable.cfg_Character_levelManager:GetLevelDes(tonumber(self.LevelAndNumber[3]))
  self.lab_level:SetText(string.format("Lv.%s(%s-%s)", self.LevelAndNumber[1], lvLeft, lvRight))
  self.numberPeople:SetText(string.format("#N/A", self.LevelAndNumber[4]))
  local globalId = ClientTable.cfg_Global_globalManager:TryGetValue(60000001).effect
  instanceCount = RefreshData.GetInstanceCount(tonumber(globalId))
  if instanceCount == nil or instanceCount == 0 then
    instanceCount = 0
  end
  local str = string.format("%d l\225\186\167n", instanceCount)
  local color = 0 < instanceCount and ItemQuality2ColorDic[EItemColorEnum.green] or ItemQuality2ColorDic[EItemColorEnum.red]
  self.lab_count1:SetText(string.GetColorText(str, color))
  local AwardTab = string.split(self.ContentData.dropItem, "&")
  for i = 1, table.count(AwardTab) do
    local Award = string.split(AwardTab[i], "#")
    local obj = self.btn_ItemTemp:GetOrCreateItem(i)
    local AwardData = ItemUtility.GenerateItemData(tonumber(Award[1]))
    AwardData.count = tonumber(Award[2])
    obj.itemCellData = obj.itemCellData or ItemCellData()
    obj.itemCellData:RefreshData(AwardData)
    ItemUtility.ShowItemCell(obj, obj.itemCellData, self, true)
  end
  local isDef, needDef = TranScriptData.GetDefIsSatisfy(self.enterConditionData.groupId, TranScriptData.TranScriptSubType.BloodCastle)
  if isDef then
    self.lab_def:SetText(string.GetColorText(needDef, ItemQuality2ColorDic[5]))
  else
    self.lab_def:SetText(string.GetColorText(needDef, ItemQuality2ColorDic[7]))
  end
end

function Instance_BloodCastleUI:OnResSaleChange()
  self:SetPanel()
end
