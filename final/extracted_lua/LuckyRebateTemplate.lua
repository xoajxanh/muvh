local LuckyRebateTemplate = {}

function LuckyRebateTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitData()
  self:BindUIEvent()
  self:InitContainer()
end

function LuckyRebateTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.txt_lastTime_ConnectionGift = self:GetControl("txt_lastTime_ConnectionGift")
  self.btn_start = self:GetControl("btn_start")
  self.effect_btnStart = self:GetControl("btn_start/Eff_UI_anniutishi_qiji2")
  self.btn_goRecharge = self:GetControl("btn_goRecharge")
  self.tip_LuckyRebates = self:GetControl("tip_LuckyRebates")
  self.tip_AccumulatedRecharge = self:GetControl("tip_AccumulatedRecharge")
  self.TurntableNumber = self:GetControl("TurntableNumber")
  self.tog_btn = self:GetControl("sw_LuckyRebates_Btn/Viewport/Content/tog_btn")
  self.Content = self:GetControl("sw_LuckyRebates_Btn/Viewport/Content")
end

function LuckyRebateTemplate:InitContainer()
  self.turntableNumberContainer = {}
  for i = self.TurntableNumber.transform.childCount, 1, -1 do
    local itemCtr = self.TurntableNumber:GetChild("Number_" .. i)
    local temp = luaTemplateManager.GetNewTemplate(itemCtr, LuaComponentTemplates.LuckyRebateScrollTemplate, self.rootUI)
    table.insert(self.turntableNumberContainer, temp)
  end
  self.desToggleContainer = UIUtility.BindUIContainerTemp(self.tog_btn, LuaComponentTemplates.LuckyRebateDesTemplate, self.rootUI)
end

function LuckyRebateTemplate:InitData()
  self.chooseId = nil
  self.playAnimCount = 0
  self.basicCount = 100
  self.basicTime = 3
  self.addTime = 1
  self.addCount = 30
  self.singleSizeX = self.Content.layoutGroup.cellSize.x + self.Content.layoutGroup.spacing.x
  self.contentPosX, self.contentPoxY = self.Content:GetAnchoredPosition()
  self.tipText = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Chaojifanli_1")
  self.accumulatedRechargeText = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Chaojifanli_2")
end

function LuckyRebateTemplate:BindUIEvent()
  self.btn_start:SetOnClick(self, self.btn_goOnClick)
  self.btn_goRecharge:SetOnClick(self, self.btn_rechargeOnClick)
end

function LuckyRebateTemplate:btn_goOnClick()
  local gradeInfo = self:GetLuckyRebateData():GetGradeInfoById(self.chooseId)
  if type(gradeInfo) ~= "table" then
    return
  end
  if gradeInfo.state == GuardRewardStateEnum.CanGet then
    networkRequest.ReqLuckyRebateReward(gradeInfo.id)
    self.isPlayAnim = true
  end
end

function LuckyRebateTemplate:btn_rechargeOnClick()
  UIManager.Hide(UIID.Commercial_HolidayActivityUI)
  RechargeData.BuyDiamond()
end

function LuckyRebateTemplate:Refresh()
  self:RefreshTime()
  if not string.isNullOrEmpty(self.tipText) then
    self.tip_LuckyRebates:SetText(self.tipText)
  end
  if not string.isNullOrEmpty(self.accumulatedRechargeText) then
    local rechargeValue = tostring(self:GetLuckyRebateData():GetCurRechargeValue())
    local text = string.format(self.accumulatedRechargeText, rechargeValue)
    self.tip_AccumulatedRecharge:SetText(text)
  end
  local gradeInfoList = self:GetLuckyRebateData():GetGradeInfoList()
  self.desToggleContainer:SetData(gradeInfoList)
  if self.chooseId then
    local gradeInfo, index = self:GetLuckyRebateData():GetGradeInfoById(self.chooseId)
    self:RefreshGradePlane(gradeInfo)
    return
  end
  local index = self:GetLuckyRebateData():GetFirstIndexByNotGetOrCanGet()
  if 0 < index then
    local temp
    if self.desToggleContainer.items[index] then
      temp = self.desToggleContainer.items[index].itemTemp
    end
    if temp == nil then
      return
    end
    if temp:GetIsOn() then
      self:RefreshGradePlane(gradeInfoList[index])
    else
      temp:SetIsOn(true)
    end
    self:RefreshToggleContentPosX(index)
  end
end

function LuckyRebateTemplate:RefreshToggleContentPosX(index)
  local contentWide = self.Content:GetSizeDelta()
  local moveIndex = 0 < index and index or 1
  local newX = self.contentPosX - (moveIndex - 1) * self.singleSizeX
  if contentWide < -newX and 0 < contentWide then
    newX = -contentWide
  end
  self.Content:SetAnchoredPosition(newX, self.contentPosY)
end

function LuckyRebateTemplate:RefreshGradePlane(data, isPlayAnim)
  if type(data) ~= "table" then
    return
  end
  if type(isPlayAnim) == "boolean" and isPlayAnim == false then
    self:FinishPlayAnim()
  end
  self.chooseId = data.id
  if self.isPlayAnim then
    self:StartPlayAnim()
  else
    for i, temp in ipairs(self.turntableNumberContainer) do
      temp:Refresh(data.rewardCountArr[i])
    end
  end
  if data.state == GuardRewardStateEnum.CanGet then
    self.btn_start:SetColor("0xFFFFFFFF")
    self.effect_btnStart:SetActive(true)
  else
    self.btn_start:SetColor("0x808080FF")
    self.effect_btnStart:SetActive(false)
  end
end

function LuckyRebateTemplate:RefreshTime()
  self:DestroyTime()
  self.txt_lastTime_ConnectionGift:SetText(self:GetLuckyRebateData():GetRemainTimeDes())
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_lastTime_ConnectionGift:SetText(self:GetLuckyRebateData():GetRemainTimeDes())
  end)
end

function LuckyRebateTemplate:StartPlayAnim()
  local gradeInfo = self:GetLuckyRebateData():GetGradeInfoById(self.chooseId)
  if type(gradeInfo) ~= "table" or type(gradeInfo.rewardCountArr) ~= "table" then
    return
  end
  local countArr = gradeInfo.rewardCountArr
  local count = self.basicCount
  local time = self.basicTime
  for i, temp in ipairs(self.turntableNumberContainer) do
    self.playAnimCount = self.playAnimCount + 1
    temp:RefreshScroll(count + countArr[i], time)
    count = count + self.addCount
    time = time + self.addTime
  end
end

function LuckyRebateTemplate:RefreshPlayAnimState(animState)
  if animState == LuckyRebateAnimState.OneFinish then
    self.playAnimCount = self.playAnimCount - 1
    if self.playAnimCount <= 0 then
      self:FinishPlayAnim()
    end
  elseif animState == LuckyRebateAnimState.AllFinish then
    self:FinishPlayAnim()
  end
end

function LuckyRebateTemplate:FinishPlayAnim()
  self.playAnimCount = 0
  if self.isPlayAnim == true then
    self.isPlayAnim = false
    local gradeInfo = self:GetLuckyRebateData():GetGradeInfoById(self.chooseId)
    local itemName = ClientTable.cfg_Item_itemManager:GetItemName(gradeInfo.rewardId)
    local text = string.format("nh\225\186\173n %s%s", itemName, gradeInfo.rewardCount)
    FloatingWordUtility.QuickMsg(text)
    local itemData = ItemUtility.GenerateItemData(gradeInfo.rewardId)
    itemData.count = gradeInfo.rewardCount
    UIManager.Show(UIID.Tip_RewardTipUI, {
      rewards = {itemData}
    })
    for i, temp in ipairs(self.turntableNumberContainer) do
      if temp.DestroyTime ~= nil then
        temp:DestroyTime()
      end
    end
  end
end

function LuckyRebateTemplate:Exit()
  self:FinishPlayAnim()
  self:DestroyTime()
  self:ResetData()
end

function LuckyRebateTemplate:DestroyTime()
  if self.RemainTimeLoop then
    Timer.Stop(self.RemainTimeLoop)
    self.RemainTimeLoop = nil
  end
end

function LuckyRebateTemplate:ResetData()
  self.chooseId = nil
  self.playAnimCount = 0
end

function LuckyRebateTemplate:GetLuckyRebateData()
  if gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity) and gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.LuckyRebate) then
    return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.LuckyRebate)
  end
end

return LuckyRebateTemplate
