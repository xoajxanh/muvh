local Activity_GoodFiftsEveryDay_MainTemplates = {}

function Activity_GoodFiftsEveryDay_MainTemplates:Init(ParPanel)
  self.ParPanel = ParPanel
  self:InitControls()
  self:InitTemplate()
end

function Activity_GoodFiftsEveryDay_MainTemplates:InitControls()
  self.btn_3DItem = self:GetControl("sw_GoodReward/Viewport/Content/btn_3DItem")
  self.btn_get = self:GetControl("btn_get")
  self.img_redPoint = self:GetControl("btn_get/img_redPoint")
  self.txt_btnGet = self:GetControl("btn_get/txt")
  self.txt_lastTimeGift = self:GetControl("txt_lastTimeGift")
end

function Activity_GoodFiftsEveryDay_MainTemplates:InitTemplate()
  self.ItemRechargeContainer = UIContainer(self.btn_3DItem, self, self.On3DItemCreate, self.On3DItemRefresh)
  self.goodgift = nil
end

function Activity_GoodFiftsEveryDay_MainTemplates:Refresh()
  if self.RemainTimeLoop ~= nil then
    Timer.Stop(self.RemainTimeLoop)
  end
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_lastTimeGift:SetText(QuickFind:GetGoodFiftsEveryDayData():GetRemainTimeDes())
  end)
  local goodFiftsEveryDayData = gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.GoodFiftsEveryDay)
  if goodFiftsEveryDayData == nil then
    return
  end
  self.goodgift = goodFiftsEveryDayData:GetDataOnTheDay()
  self.ItemRechargeContainer:SetData(goodFiftsEveryDayData:GetBoxDatas(self.goodgift))
  local IsBeenGet = goodFiftsEveryDayData:IsBeenGet(self.goodgift)
  if not IsBeenGet then
    self.btn_get:SetInteractable(true)
    self.txt_btnGet:SetText("Nh\225\186\173n")
    self.btn_get:SetOnClick(self, self.OnGetClick)
  else
    self.txt_btnGet:SetText("\196\144\195\163 nh\225\186\173n")
    self.btn_get:SetInteractable(false)
  end
  self.img_redPoint:SetActive(goodFiftsEveryDayData:RedPointCheck())
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.combineActivity_GoodFiftsEveryDay
  })
end

function Activity_GoodFiftsEveryDay_MainTemplates:Exit()
  Timer.Stop(self.RemainTimeLoop)
  self.RemainTimeLoop = nil
end

function Activity_GoodFiftsEveryDay_MainTemplates:OnGetClick()
  gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.GoodFiftsEveryDay):GetFiftsEveryData(self.goodgift)
end

function Activity_GoodFiftsEveryDay_MainTemplates.On3DItemCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

function Activity_GoodFiftsEveryDay_MainTemplates.On3DItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  itemData.overlying = -1
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui.ParPanel, true, true)
end

return Activity_GoodFiftsEveryDay_MainTemplates
