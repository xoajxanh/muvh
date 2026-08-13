local HolidayLuckyTurntableTemplate = {}

function HolidayLuckyTurntableTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitData()
end

function HolidayLuckyTurntableTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.PerLogs = self:GetControl("giftLog/PersonalLogs/scroll_logs")
  self.PersonalLogs = self:GetControl("giftLog/PersonalLogs/scroll_logs/Viewport/Content/lab_Event")
  self.FullLogs = self:GetControl("giftLog/FullServerLogs/scroll_logs")
  self.FullServerLogs = self:GetControl("giftLog/FullServerLogs/scroll_logs/Viewport/Content/lab_Event")
  self.Content = self:GetControl("TurntableShow/sw_Turntable/Viewport/Content")
  self.txt_lt_lastTime = self:GetControl("txt_lt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lt_lastTime/lab_lastTime")
  self.img_chooes = self:GetControl("TurntableShow/sw_Turntable/Viewport/Content/img_chooes")
  self.lab_luckyValue = self:GetControl("txt_luckyValue/lab_luckyValue")
  self.lab_luckyDes = self:GetControl("lab_luckyDes")
  self.Fill_ValueEnergy = self:GetControl("LuckyValue/Fill_Area/Fill_ValueEnergy")
  self.btn_100 = self:GetControl("TurntableShow/btn_100")
  self.img_100 = self:GetControl("TurntableShow/btn_100/img_100")
  self.lab_100 = self:GetControl("TurntableShow/btn_100/lab_100")
  self.btn_1000 = self:GetControl("TurntableShow/btn_1000")
  self.img_1000 = self:GetControl("TurntableShow/btn_1000/img_1000")
  self.lab_1000 = self:GetControl("TurntableShow/btn_1000/lab_1000")
  self.des_100 = self:GetControl("TurntableShow/des_100")
  self.des_1000 = self:GetControl("TurntableShow/des_1000")
  self.tog_overAni = self:GetControl("tog_overAni")
  self.lab_myCount = self:GetControl("TurntableCount/slider_count/lab_myCount")
  self.TurntableGiftProp = self:GetControl("TurntableCount/slider_count/btn_reward/sw_TurntableRward/Viewport/TurntableRward_Content/TurntableGiftProp")
  self.turntableGiftPropContainer = UIUtility.BindUIContainerTemp(self.TurntableGiftProp, LuaComponentTemplates.TurntableGiftPropTemplate, self.rootUI)
  self.plane_left = self:GetControl("plane_left")
  self.turntableItemList = {}
  for i = 1, self.Content.transform.childCount - 1 do
    local itemCtr = self.Content:GetChild("Item_" .. i)
    itemCtr.img_bigReward = UIControl(itemCtr.transform, "img_bigReward")
    itemCtr.itemCellData = ItemCellData()
    table.insert(self.turntableItemList, itemCtr)
  end
  self.btn_100.costType = 1
  self.btn_1000.costType = 10
  self.btn_100:SetOnClick(self, self.LuckyDrawOnClick)
  self.btn_1000:SetOnClick(self, self.LuckyDrawOnClick)
end

function HolidayLuckyTurntableTemplate:InitData()
  self.startSpeed = 0.25
  self.minSpeed = 0.001
  self.maxSpeed = 0.2
  self.changeSpeed = 0.05
  self.length = #self.turntableItemList
end

function HolidayLuckyTurntableTemplate:Refresh()
  self.img_chooes:SetActive(false)
  self.rootUI.plane_left:SetActive(false)
  self:RefreshCostImgAndLab()
  self:RefreshTurntableItem()
  self:RefreshLucky()
  self:RefreshLuckyTimes()
end

function HolidayLuckyTurntableTemplate:RefreshCostImgAndLab()
  local onceNeedDiamondCount = 100
  local onceNeedExchangeCertificateCount = 1
  local bagExchangeCertificateCount = 0
  local strFomat = "%d"
  local costTbl = self:GetHolidayLuckyTurntableMgr():GetCostTbl()
  if 1 < table.count(costTbl) then
    onceNeedDiamondCount = costTbl[2].costCount
    onceNeedExchangeCertificateCount = costTbl[1].costCount
    bagExchangeCertificateCount = BagInfoData.GetItemTotalCountByItemId(costTbl[1].costId)
  end
  local isMeetLeftBtn = bagExchangeCertificateCount >= onceNeedExchangeCertificateCount * self.btn_100.costType
  self.rootUI:SetSprite("Atlas_Common", isMeetLeftBtn and "1000180" or "img_luckyturntable_1000030", self.img_100)
  self.lab_100:SetText(string.format(strFomat, (isMeetLeftBtn and onceNeedExchangeCertificateCount or onceNeedDiamondCount) * self.btn_100.costType))
  local isMeetRightBtn = bagExchangeCertificateCount >= onceNeedExchangeCertificateCount * self.btn_1000.costType
  self.rootUI:SetSprite("Atlas_Common", isMeetRightBtn and "1000180" or "img_luckyturntable_1000030", self.img_1000)
  self.lab_1000:SetText(string.format(strFomat, (isMeetRightBtn and onceNeedExchangeCertificateCount or onceNeedDiamondCount) * self.btn_1000.costType))
end

function HolidayLuckyTurntableTemplate:LuckyDrawOnClick(control)
  local state = self:GetHolidayLuckyTurntableMgr():GetLuckyDrawState()
  if state == nil or state == true then
    return
  end
  local costTbl = self:GetHolidayLuckyTurntableMgr():GetCostTbl()
  local costTblCount = table.count(costTbl)
  local finalCostItemId, finalCostItemCount = 0, 0
  for i = 1, costTblCount do
    local costId = costTbl[i].costId
    local count = costTbl[i].costCount * control.costType
    if count > BagInfoData.GetItemTotalCountByItemId(costId) then
      if i == costTblCount then
        local tipStr = LocalizationUtility.GetContentByKey("huobibuzu")
        FloatingWordUtility.QuickMsg(tipStr)
        UIManager.Hide(UIID.Commercial_HolidayActivityUI)
        RechargeData.BuyDiamond()
        return
      end
    else
      finalCostItemId = costId
      finalCostItemCount = count
      break
    end
  end
  local info = {
    msgid = CommerceMessage.ReqTreasureHunt,
    message = {
      type = control.costType
    }
  }
  self:DiamondPopUpTwice(info)
end

function HolidayLuckyTurntableTemplate:DiamondPopUpTwice(data)
  local playerPrefs = string.format("%s_Commercial_HolidayActivityUI_go_holidayLuckyTurntable", ViewData.meData.id, data.message.type)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    self:GetHolidayLuckyTurntableMgr():SetLuckyDrawState(true)
    NetManager.Send(data.msgid, data.message)
  else
    self:GetHolidayLuckyTurntableMgr():SetLuckyDrawState(true)
    NetManager.Send(data.msgid, data.message)
  end
end

function HolidayLuckyTurntableTemplate:RefreshLuckyDrawDes()
  if self.singleRewardCount == nil then
    self.singleRewardCount = ClientTable.cfg_Commerce_globalManager:GetLuckyTurntableSingleRewardCount()
    if self.singleRewardCount == nil then
      return
    end
    local luckyDrawDes
    local content = ClientTable.cfg_Ui_wordManager:GetLuckyTurntableLuckyDrawDes()
    if content then
      luckyDrawDes = string.format(content, self.singleRewardCount, tostring(self.btn_100.costType))
      if luckyDrawDes then
        self.des_100:SetText(luckyDrawDes)
      end
      local count = tostring(self.btn_1000.costType * tonumber(self.singleRewardCount))
      luckyDrawDes = nil
      luckyDrawDes = string.format(content, count, tostring(self.btn_1000.costType))
      if luckyDrawDes then
        self.des_1000:SetText(luckyDrawDes)
      end
    end
  end
end

function HolidayLuckyTurntableTemplate:RefreshTurntableItem()
  local turntableItemInfoList = self:GetHolidayLuckyTurntableMgr():GetTurntableItemInfoList()
  for i, v in ipairs(self.turntableItemList) do
    if v.itemCellData == nil then
      v.itemCellData = ItemCellData()
    end
    if turntableItemInfoList[i] == nil then
      ItemUtility.ReleaseItemCell(v, v.itemCellData)
    else
      local itemData = ItemUtility.GenerateItemData(turntableItemInfoList[i].itemId)
      itemData.count = turntableItemInfoList[i].count
      v.itemCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(v, v.itemCellData, self.rootUI, true)
      local imageName = ClientTable.cfg_Commerce_globalManager:GetLuckyTurntableBgByType(turntableItemInfoList[i].type)
      if imageName then
        self.rootUI:SetSprite("Atlas_Common", imageName, v)
      end
      v.img_bigReward:SetActive(turntableItemInfoList[i].type == TurntableItemTypeEnum.Rare)
    end
  end
end

function HolidayLuckyTurntableTemplate:RefreshLuckyTimes()
  local count = self:GetHolidayLuckyTurntableMgr():GetLuckyTimes()
  self.lab_myCount:SetText(tostring(count))
  local turntableGiftProp = self:GetHolidayLuckyTurntableMgr():GetGiftPropInfoList()
  self.turntableGiftPropContainer:SetData(turntableGiftProp)
end

function HolidayLuckyTurntableTemplate:RefreshLucky()
  local luckyValue = self:GetHolidayLuckyTurntableMgr():GetLuckyValue()
  self.lab_luckyValue:SetText(tostring(luckyValue))
  local maxLuckyValue = ClientTable.cfg_Commerce_treasureManager:GetMaxLuckyValue()
  if maxLuckyValue then
    self.Fill_ValueEnergy:SetFillAmount(luckyValue / maxLuckyValue)
  end
  local content = ClientTable.cfg_Ui_wordManager:GetLuckyTurntableLuckyDes()
  if content and maxLuckyValue then
    local luckyDesText = string.format(content, maxLuckyValue)
    self.lab_luckyDes:SetText(luckyDesText)
  end
end

local waitTime = 0.25

function HolidayLuckyTurntableTemplate:ShowLuckyDrawMoveEffect()
  if self.tog_overAni:GetIsOn() then
    self:LuckyDrawFinish()
    return
  end
  self.rewardIndexList = self:GetHolidayLuckyTurntableMgr():GetLuckyDrawRewardIndexList()
  if self.rewardIndexList == nil or #self.rewardIndexList == 0 then
    return
  end
  if #self.rewardIndexList > 1 then
    Coroutine.Start(self.MultipleMoveFunc, self)
  else
    waitTime = self.startSpeed
    Coroutine.Start(self.OneMoveFunc, self)
  end
end

function HolidayLuckyTurntableTemplate:OneMoveFunc()
  self.img_chooes:SetActive(true)
  self.moveTimes = self.length + self.rewardIndexList[1]
  for i = 1, self.moveTimes do
    if i < self.length / 2 then
      waitTime = waitTime - self.changeSpeed
      if waitTime < self.minSpeed then
        waitTime = self.minSpeed
      end
    elseif i >= self.moveTimes - 2 then
      waitTime = waitTime + self.changeSpeed
      if waitTime > self.maxSpeed then
        waitTime = self.maxSpeed
      end
    end
    Coroutine.Wait(waitTime)
    local index = i % self.length
    if index == 0 then
      index = self.length
    end
    self.img_chooes.transform.localPosition = self.turntableItemList[index].transform.localPosition
  end
  self:LuckyDrawFinish()
end

function HolidayLuckyTurntableTemplate:MultipleMoveFunc()
  self.img_chooes:SetActive(true)
  for i = 1, #self.rewardIndexList do
    self.moveTimes = self.length + self.rewardIndexList[i]
    for j = 1, self.moveTimes do
      Coroutine.Wait(self.minSpeed)
      local index = j % self.length
      if index == 0 then
        index = self.length
      end
      self.img_chooes.transform.localPosition = self.turntableItemList[index].transform.localPosition
    end
    Coroutine.Wait(0.12)
  end
  self:LuckyDrawFinish()
end

function HolidayLuckyTurntableTemplate:LuckyDrawFinish()
  if self:GetHolidayLuckyTurntableMgr():GetLuckyDrawState() then
    local itemDataList = self:GetHolidayLuckyTurntableMgr():GetLuckyDrawItemDataIndexList()
    if itemDataList then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = itemDataList})
    end
    self:GetHolidayLuckyTurntableMgr():SetLuckyDrawState(false)
  end
end

function HolidayLuckyTurntableTemplate:RefreshShowGiftLog()
  local roleRewardInfo = self:GetHolidayLuckyTurntableMgr().roleRewardInfo
  local worldRewardInfo = self:GetHolidayLuckyTurntableMgr().worldRewardInfo
  self.PersonalLogs:SetText("")
  self.FullServerLogs:SetText("")
  if roleRewardInfo or roleRewardInfo ~= {} then
    local roleRewardInfoname = "<color=#FBD994>Quay th\198\176\225\187\159ng</color> nh\225\186\173n %s "
    local roleRewardInfotext
    for i = 1, table.count(roleRewardInfo.rewardId) do
      local itemIdName = ClientTable.cfg_Commerce_treasureManager:GetItemInfoName(roleRewardInfo.rewardId[i])
      if roleRewardInfotext == nil then
        roleRewardInfotext = string.format(roleRewardInfoname, itemIdName)
      else
        roleRewardInfotext = roleRewardInfotext .. "\n" .. string.format(roleRewardInfoname, itemIdName)
      end
    end
    self.PersonalLogs:SetText(roleRewardInfotext)
    self.PerLogs.scrollRect.normalizedPosition = Vector2(0, 0)
  end
  if worldRewardInfo or worldRewardInfo ~= {} then
    local FullServerLogstext
    for i = 1, table.count(worldRewardInfo) do
      local FullServerLogsname = "<color=#FBD994>" .. worldRewardInfo[i].name .. "</color>Qua r\195\186t th\198\176\225\187\159ng nh\225\186\173n %s "
      local itemIdName = ClientTable.cfg_Commerce_treasureManager:GetItemInfoName(worldRewardInfo[i].rewardId[1])
      if FullServerLogstext == nil then
        FullServerLogstext = string.format(FullServerLogsname, itemIdName)
      else
        FullServerLogstext = FullServerLogstext .. "\n" .. string.format(FullServerLogsname, itemIdName)
      end
    end
    self.FullServerLogs:SetText(FullServerLogstext)
    self.FullLogs.scrollRect.normalizedPosition = Vector2(0, 0)
  end
end

function HolidayLuckyTurntableTemplate:ClearMoveEffect()
  if self.moveEffect then
    Timer.Stop(self.moveEffect)
    self.moveEffect = nil
  end
  self:LuckyDrawFinish()
end

function HolidayLuckyTurntableTemplate:OnHide()
  self.turntableGiftPropContainer:SetData({})
  for i, v in ipairs(self.turntableItemList) do
    if v.itemCellData then
      v.itemCellData:RecycleRes()
      v.itemCellData = nil
    end
  end
  self:ClearMoveEffect()
  self:HideTime()
  if self.rootUI and self.rootUI.plane_left then
    self.rootUI.plane_left:SetActive(true)
  end
end

local DaojiTime = 0

function HolidayLuckyTurntableTemplate:RefreshTime(lab_lastTime, txt_lt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    txt_lt_lastTime:SetActive(false)
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function HolidayLuckyTurntableTemplate:RefreshCountdownTime(Difference)
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lt_lastTime:SetText("")
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTime:SetText(DaoJiShi)
  else
    self.txt_lt_lastTime:SetText("Th\225\187\157i gian c\195\178n: ")
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTime:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTime, self.txt_lt_lastTime)
  end
end

function HolidayLuckyTurntableTemplate:HideTime()
  self.txt_lt_lastTime:SetText("")
  self.lab_lastTime:SetText("")
  self:SetDestroyTime()
end

function HolidayLuckyTurntableTemplate:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function HolidayLuckyTurntableTemplate:GetHolidayLuckyTurntableMgr()
  if gameMgr:GetAvatarManager() ~= nil then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetHolidayLuckyTurntableManager()
  end
end

return HolidayLuckyTurntableTemplate
