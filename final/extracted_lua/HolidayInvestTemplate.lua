local HolidayInvestTemplate = {}

function HolidayInvestTemplate:Init(baseUI)
  if baseUI then
    self.baseUI = baseUI
  end
  self:InitControls()
  self:BindUIEvent()
  self:InitContainer()
  self:InitData()
end

function HolidayInvestTemplate:InitControls()
  self.btn_ItemPage = self:GetControl("sw_rechangeNum/Viewport/Content/Btn_rechangeGet")
  self.img_ItemInvestTask = self:GetControl("sw_AccumulativeGift/Viewport/Content/img_dataBgAccumulative")
  self.btn_Buy = self:GetControl("btn_Buy")
  self.txt_Buy = self:GetControl("btn_Buy/txt_Buy")
  self.txt_lastTime_Invest = self:GetControl("txt_lastTime_Invest")
end

function HolidayInvestTemplate:BindUIEvent()
  self.btn_Buy:SetOnClick(self, self.btn_BuyOnClick)
end

function HolidayInvestTemplate:btn_BuyOnClick()
  if self.selectInvestPositionData and not self.selectInvestPositionData.active then
    if self.selectPositionPriceData.type == RechargeSurpriseType.RMB then
      local rechargeConfig = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(self.selectPositionPriceData.param)
      local itemPrice = math.ceil(rechargeConfig.rmb / 100)
      DataToCSharpMgr.Pay({
        amount = itemPrice,
        product_Id = rechargeConfig.id,
        product_name = rechargeConfig.name,
        BusinessPayType = BusinessPayType.None
      })
      NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
    elseif self.selectPositionPriceData.type == RechargeSurpriseType.Diamond then
      local bagCount = BagInfoData.GetItemTotalCountByItemId(1000030)
      if bagCount < self.selectPositionPriceData.param then
        FloatingTipUtility.QuickMsg("KC kh\195\180ng \196\145\225\187\167")
      else
        networkRequest.ReqActiveInvest(self.selectInvestPositionData.position)
      end
    end
  end
end

function HolidayInvestTemplate:InitContainer()
  function self.ClickCallBack(data)
    self:ClickPageCallBackFunc(data)
  end
  
  self.btn_ItemPageTemplate = UIUtility.BindUIContainerTemp(self.btn_ItemPage, LuaComponentTemplates.HolidayInvestPageTemplate, self.baseUI, {
    goCallBack = self.ClickCallBack
  })
  self.img_ItemInvestTaskTemplate = UIUtility.BindUIContainerTemp(self.img_ItemInvestTask, LuaComponentTemplates.HolidayInvestTaskTemplate, self.baseUI)
end

function HolidayInvestTemplate:InitData()
  self.positionPriceDataList = {}
  local positionPriceGlobal = CommercialHolidayData.GetCommerce_globalFun(317001)
  if not string.isNullOrEmpty(positionPriceGlobal) then
    local positionPriceGlobalTab = string.split(positionPriceGlobal, "&")
    for i, itemPositionGlobal in pairs(positionPriceGlobalTab) do
      local itemPositionGlobalTab = string.split(itemPositionGlobal, "#")
      self.positionPriceDataList[tonumber(itemPositionGlobalTab[1])] = {
        type = tonumber(itemPositionGlobalTab[2]),
        param = tonumber(itemPositionGlobalTab[3]),
        describeText = itemPositionGlobalTab[4]
      }
    end
  end
end

function HolidayInvestTemplate:Refresh(data, ui)
  self.parent = ui
  self:RefreshPageView()
end

function HolidayInvestTemplate:RefreshPageView()
  self.holidayInvestDataList = QuickFind:GetHolidayInvestData():GetHolidayInvestDataList()
  self.selectInvestPositionData = QuickFind:GetHolidayInvestData():GetFirstPositionData()
  if table.count(self.holidayInvestDataList) > 0 and self.selectInvestPositionData ~= nil then
    self.btn_ItemPageTemplate:SetData(self.holidayInvestDataList)
    local btn_ItemPageContainerItems = self.btn_ItemPageTemplate.items
    if table.count(btn_ItemPageContainerItems) > 0 then
      for i, v in pairs(btn_ItemPageContainerItems) do
        if v.itemTemp and v.itemTemp.data and v.itemTemp.data.position == self.selectInvestPositionData.position then
          v.itemTemp:ClickGoCallBack()
        end
      end
    end
  end
end

function HolidayInvestTemplate:ClickPageCallBackFunc(data)
  self.selectInvestPositionData = QuickFind:GetHolidayInvestData():GetPositionHolidayInvestData(data.position)
  if self.selectInvestPositionData then
    self.selectPositionPriceData = self.positionPriceDataList[data.position]
    self:SetSelectFrameDisplay()
    self:RefreshTaskView()
    self:RefreshBuyButton()
  end
end

function HolidayInvestTemplate:RefreshPositionView()
  self.selectInvestPositionData = QuickFind:GetHolidayInvestData():GetPositionHolidayInvestData(self.selectInvestPositionData.position)
  if self.selectInvestPositionData then
    self:SetSelectFrameDisplay()
    self:RefreshTaskView()
    self:RefreshBuyButton()
  end
end

function HolidayInvestTemplate:SetSelectFrameDisplay()
  local btn_ItemPageContainerItems = self.btn_ItemPageTemplate.items
  if table.count(btn_ItemPageContainerItems) > 0 then
    for i, v in pairs(btn_ItemPageContainerItems) do
      v.itemTemp:SetSelectFrameDisplayAndRedPoint(v.itemTemp and v.itemTemp.data and v.itemTemp.data.position == self.selectInvestPositionData.position and true or false)
    end
  end
end

local function SortInvestTaskData(a, b)
  local taskIdA = ClientTable.cfg_Commerce_holidayinvestManager:TryGetValue(a.id).mission
  local targetCountA = ClientTable.cfg_Task_goalManager:TryGetValue(taskIdA).goalCount
  local taskIdB = ClientTable.cfg_Commerce_holidayinvestManager:TryGetValue(b.id).mission
  local targetCountB = ClientTable.cfg_Task_goalManager:TryGetValue(taskIdB).goalCount
  local aFinishState = targetCountA <= a.finishCount
  local bFinishState = targetCountB <= b.finishCount
  if a.hasReward ~= b.hasReward then
    return a.hasReward == false and true or false
  elseif aFinishState ~= bFinishState then
    return aFinishState == true and true or false
  else
    return a.id < b.id
  end
end

function HolidayInvestTemplate:RefreshTaskView()
  if self.selectInvestPositionData ~= nil then
    local taskList = table.clone(self.selectInvestPositionData.reward)
    table.sort(taskList, SortInvestTaskData)
    self.img_ItemInvestTaskTemplate:SetData(taskList)
  end
end

function HolidayInvestTemplate:RefreshBuyButton()
  if self.selectInvestPositionData ~= nil then
    self.btn_Buy:SetActive(not self.selectInvestPositionData.active)
    self.txt_Buy:SetText(self.selectPositionPriceData.describeText)
  end
end

function HolidayInvestTemplate:SetDestroyTime()
  if self.investTimeLoopForever then
    Timer.Stop(self.investTimeLoopForever)
    self.investTimeLoopForever = nil
  end
end

local countDown = 0

function HolidayInvestTemplate:RefreshTime(txt_lastTime_Invest)
  if 0 < countDown then
    countDown = countDown - 1
    local countDownStr = TimeUtility.ShowDayHourMin(countDown)
    txt_lastTime_Invest:SetText(string.format("Th\225\187\157i gian c\195\178n: %s", countDownStr))
  else
    txt_lastTime_Invest:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function HolidayInvestTemplate:RefreshCountdownTime(difference)
  self:SetDestroyTime()
  local timeTextStr = ""
  if difference <= 0 then
    timeTextStr = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.txt_lastTime_Invest:SetText(timeTextStr)
  else
    timeTextStr = TimeUtility.ShowDayHourMin(difference)
    self.txt_lastTime_Invest:SetText(string.format("Th\225\187\157i gian c\195\178n: %s", timeTextStr))
    countDown = difference
    self.investTimeLoopForever = Timer.StartLoopForever(1, self.RefreshTime, self, self.txt_lastTime_Invest)
  end
end

return HolidayInvestTemplate
