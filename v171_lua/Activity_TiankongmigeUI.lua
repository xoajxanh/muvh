Activity_TiankongmigeUI = class(BaseUI)
Activity_TiankongmigeUI.layer = UILayer.Panel
Activity_TiankongmigeUI.orderInLayer = 2
Activity_TiankongmigeUI.hideType = UIHideType.WaitDestroy
Activity_TiankongmigeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_TiankongmigeUI.escClose = UIEscClose.DontClose

function Activity_TiankongmigeUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.lab_levelValue = self:GetControl("personalMessage/level/lab_levelValue")
  self.lab_scoreValue = self:GetControl("personalMessage/score/lab_scoreValue")
  self.BuyPointsBtn = self:GetControl("personalMessage/score/BuyPointsBtn")
  self.rewardPanel = self:GetControl("rewardPanel")
  self.Scrollreward = self:GetControl("rewardPanel/Scrollreward")
  self.reward = self:GetControl("rewardPanel/reward")
  self.normalReward = self:GetControl("rewardPanel/phase_bigRewardDisplay/normalReward")
  self.normal_tips = self:GetControl("rewardPanel/phase_bigRewardDisplay/normal_tips")
  self.VIPReward = self:GetControl("rewardPanel/phase_bigRewardDisplay/VIPReward")
  self.VIP_tips = self:GetControl("rewardPanel/phase_bigRewardDisplay/VIP_tips")
  self.rewardleft = self:GetControl("rewardPanel/rewardleft")
  self.rewardright = self:GetControl("rewardPanel/rewardright")
  self.btn_getAll = self:GetControl("rewardPanel/btn_getAll")
  self.missionPanel = self:GetControl("missionPanel")
  self.DailyMission_scroll = self:GetControl("missionPanel/DailyMission_scroll")
  self.Daymission = self:GetControl("missionPanel/Daymission")
  self.Dailyright = self:GetControl("missionPanel/Dailyright")
  self.Dailyleft = self:GetControl("missionPanel/Dailyleft")
  self.WeekMission_scroll = self:GetControl("missionPanel/WeekMission_scroll")
  self.Weekmission = self:GetControl("missionPanel/Weekmission")
  self.Weekright = self:GetControl("missionPanel/Weekright")
  self.Weekleft = self:GetControl("missionPanel/Weekleft")
  self.btn_reward = self:GetControl("tab/btn_reward")
  self.btn_rewardbg = self:GetControl("tab/btn_reward/btn_rewardbg")
  self.btn_mission = self:GetControl("tab/btn_mission")
  self.btn_missionbg = self:GetControl("tab/btn_mission/btn_missionbg")
  self.unlockVipPanel = self:GetControl("unlockVipPanel")
  self.unlockbtn_close = self:GetControl("unlockVipPanel/unlockbtn_close")
  self.unlock_Item = self:GetControl("unlockVipPanel/unlock_Item")
  self.unlocktips = self:GetControl("unlockVipPanel/unlocktips")
  self.btn_buy = self:GetControl("unlockVipPanel/btn_buy")
  self.unlockprice = self:GetControl("unlockVipPanel/unlockprice")
  self.BuyContractvaluePanel = self:GetControl("BuyContractvaluePanel")
  self.BuyContractclose = self:GetControl("BuyContractvaluePanel/BuyContractclose")
  self.BuyContracttips = self:GetControl("BuyContractvaluePanel/BuyContracttips")
  self.BuyContractView = self:GetControl("BuyContractvaluePanel/BuyContractView")
  self.BuyContractbtn_Item = self:GetControl("BuyContractvaluePanel/BuyContractbtn_Item")
  self.mun = self:GetControl("BuyContractvaluePanel/BuyContract/mun")
  self.LessBut = self:GetControl("BuyContractvaluePanel/BuyContract/LessBut")
  self.PlusButton = self:GetControl("BuyContractvaluePanel/BuyContract/PlusButton")
  self.btn_moneyName = self:GetControl("BuyContractvaluePanel/btn_moneyName")
  self.btn_money = self:GetControl("BuyContractvaluePanel/btn_money")
  self.btn_moneyText = self:GetControl("BuyContractvaluePanel/btn_moneyText")
  self.BuyContractbtn_buy = self:GetControl("BuyContractvaluePanel/BuyContractbtn_buy")
end

function Activity_TiankongmigeUI:OnPreLoad()
end

local cell

function Activity_TiankongmigeUI:Init()
  self.LevelGoropid = 0
  self.UpgradePoints = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(4011401))
  cell = CommercializeEquipCell.Sky
  self.addRewardcount = 0
end

function Activity_TiankongmigeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_TiankongmigeUI:InitUI()
  local rewScrx = self.Scrollreward:GetSizeDelta()
  local rewardx = self.reward:GetSizeDelta()
  self.RewardShowcount = math.floor(rewScrx / rewardx + 0.5)
  local Daymission = self.DailyMission_scroll:GetSizeDelta()
  local Dayx = self.Daymission:GetSizeDelta()
  self.DayShowcount = math.floor(Daymission / Dayx + 0.5)
  local Weekmission = self.DailyMission_scroll:GetSizeDelta()
  local Weekx = self.Weekmission:GetSizeDelta()
  self.WeekShowcount = math.floor(Weekmission / Weekx + 0.5)
end

function Activity_TiankongmigeUI:CreateTableView()
  self.rewardGiftTableView = UITableView()
  self.rewardGiftTableView:SetLowerMargin(0)
  self.rewardGiftTableView:SetScrollView(self.Scrollreward)
  self.rewardGiftTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.rewardGiftTableView:SetUpperMargin(0)
  self.rewardGiftTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.rewardGiftTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.rewardGiftTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
  self.rewardGiftTableView:ReloadData(self.ShowRewardindex)
end

function Activity_TiankongmigeUI:ScalarForCellInTableView()
  local sizeX, sizeY = self.reward:GetSizeDelta()
  return sizeX
end

function Activity_TiankongmigeUI:NumberOfCellsInTableView()
  self.RewardData = CommercializeData:TianKongMiGeReward()
  self.Rewardmaxcount = self.RewardData and table.count(self.RewardData) or 0
  return self.Rewardmaxcount
end

function Activity_TiankongmigeUI:CellAtIndexInTableView(index)
  return self.rewardGiftTableView:ReuseOrCreateCell(self.reward)
end

function Activity_TiankongmigeUI:CellAtIndexInTableViewWillAppear(index)
  local data = self.RewardData[index]
  local chatCell = self.rewardGiftTableView:GetLoadedCell(index)
  local lab_level = chatCell:GetChild("level/lab_level")
  lab_level:SetText(index)
  if index > self.RewardShowcount then
    self.rewardleft:SetActive(true)
  elseif index == 1 then
    self.rewardleft:SetActive(false)
  end
  if index < self.Rewardmaxcount then
    self.rewardright:SetActive(true)
  else
    self.rewardright:SetActive(false)
  end
  local btn_getord = chatCell:GetChild("img_normalItemIcon/btn_get")
  local lab_received = chatCell:GetChild("img_normalItemIcon/lab_received")
  if data.Ordinarydata.Received then
    btn_getord:SetActive(false)
    btn_getord:GetChild("img_redPoint"):SetActive(false)
    lab_received:SetActive(true)
  else
    if self.score < data.Ordinarydata.canbuy then
      btn_getord:SetActive(false)
      btn_getord:GetChild("img_redPoint"):SetActive(false)
    else
      btn_getord:SetActive(true)
      btn_getord:GetChild("img_redPoint"):SetActive(true)
    end
    lab_received:SetActive(false)
  end
  btn_getord.index = index
  btn_getord.giftid = data.Ordinarydata.id
  btn_getord:SetOnClick(self, self.BtnGetGift)
  chatCell.coinCtrord = ItemUtility.InitItem(UIControl(chatCell.transform, "img_normalItemIcon/btn_Item"))
  local coinDataord = ItemUtility.GenerateItemData(data.Ordinarydata.rewardBox.itemId)
  coinDataord.count = data.Ordinarydata.rewardBox.count
  ItemUtility.ShowItem(self, chatCell.coinCtrord, coinDataord, true)
  local btn_VIPgetadv = chatCell:GetChild("img_VIPItemIcon/btn_get")
  local lab_VIPreceived = chatCell:GetChild("img_VIPItemIcon/lab_received")
  if data.Advanceddata.Received then
    btn_VIPgetadv:SetActive(false)
    btn_VIPgetadv:GetChild("img_redPoint"):SetActive(false)
    lab_VIPreceived:SetActive(true)
  else
    if self.score < data.Advanceddata.canbuy then
      btn_VIPgetadv:SetActive(false)
      btn_VIPgetadv:GetChild("img_redPoint"):SetActive(false)
    else
      btn_VIPgetadv:SetActive(true)
      if 1 <= self.BuySecretorder then
        btn_VIPgetadv:GetChild("img_redPoint"):SetActive(true)
      end
    end
    lab_VIPreceived:SetActive(false)
  end
  btn_VIPgetadv.index = index
  btn_VIPgetadv.giftid = data.Advanceddata.id
  btn_VIPgetadv:SetOnClick(self, self.BtnGetVIPGift)
  chatCell.coinCtradv = ItemUtility.InitItem(UIControl(chatCell.transform, "img_VIPItemIcon/btn_Item"))
  local coinDataadv = ItemUtility.GenerateItemData(data.Advanceddata.rewardBox.itemId)
  coinDataadv.count = data.Advanceddata.rewardBox.count
  ItemUtility.ShowItem(self, chatCell.coinCtradv, coinDataadv, true)
end

function Activity_TiankongmigeUI:BtnGetGift(control)
  self.ReceiveBtnIndex = control.index
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      control.giftid
    }
  })
end

function Activity_TiankongmigeUI:BtnGetVIPGift(control)
  if self.BuySecretorder >= 1 then
    self.ReceiveBtnIndex = control.index
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        control.giftid
      }
    })
  else
    local recharge = ConfigManager.FindConfigs("cfg_Recharge_recharge", "type", 10)[1]
    local rechitem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", recharge.diamond)[1].itemId
    self.btn_buy.id = recharge.id
    local rmb = math.modf(recharge.rmb / 100)
    self.btn_buy.rmb = rmb
    self.unlockprice:SetText(rmb .. " VN\196\144")
    self.unlock_Item.ctr = ItemUtility.InitItem(UIControl(self.unlock_Item.transform))
    local coinDataord = ItemUtility.GenerateItemData(rechitem)
    ItemUtility.ShowItem(self, self.unlock_Item.ctr, coinDataord, true)
    self.unlockVipPanel:SetActive(true)
  end
end

function Activity_TiankongmigeUI:CreateDayTableView()
  self.MissionDayTableView = UITableView()
  self.MissionDayTableView:SetLowerMargin(0)
  self.MissionDayTableView:SetScrollView(self.DailyMission_scroll)
  self.MissionDayTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableDayView)
  self.MissionDayTableView:SetUpperMargin(0)
  self.MissionDayTableView:SetTotalCellCount(self, self.NumberOfCellsInTableDayView)
  self.MissionDayTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableDayView)
  self.MissionDayTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableDayViewWillAppear)
  self.MissionDayTableView:ReloadData(1)
  self.MissionDayTableView:ScrollToCell(1, true)
end

function Activity_TiankongmigeUI:ScalarForCellInTableDayView()
  local sizeX, sizeY = self.Daymission:GetSizeDelta()
  return sizeX
end

function Activity_TiankongmigeUI:NumberOfCellsInTableDayView()
  self.MissionDayData = CommercializeData:TianKongMiGeMission(TianKongMiGeMissionType.day)
  self.Daymaxcount = self.MissionDayData and table.count(self.MissionDayData) or 0
  return self.Daymaxcount
end

function Activity_TiankongmigeUI:CellAtIndexInTableDayView(index)
  return self.MissionDayTableView:ReuseOrCreateCell(self.Daymission)
end

function Activity_TiankongmigeUI:GetLoadedCell()
  local MissionData = CommercializeData:TianKongMiGeMission()
  return MissionData.Day
end

function Activity_TiankongmigeUI:CellAtIndexInTableDayViewWillAppear(index)
  local data = self.MissionDayData[index]
  local chatCell = self.MissionDayTableView:GetLoadedCell(index)
  local lab_mission = chatCell:GetChild("lab_mission")
  local lab_missionCount = chatCell:GetChild("lab_missionCount")
  local lab_complete = chatCell:GetChild("lab_complete")
  if index > self.DayShowcount then
    self.Dailyleft:SetActive(true)
  elseif index == 1 then
    self.Dailyleft:SetActive(false)
  end
  if index < self.Daymaxcount then
    self.Dailyright:SetActive(true)
  else
    self.Dailyright:SetActive(false)
  end
  chatCell.coinCtr = ItemUtility.InitItem(UIControl(chatCell.transform, "btn_Item"))
  lab_mission:SetText(data.description)
  lab_missionCount:SetText(data.serCount .. "/" .. data.taskgoal.goalCount)
  local comp = data.serCount == data.taskgoal.goalCount and true or false
  lab_missionCount:SetActive(not comp)
  lab_complete:SetActive(comp)
  local coinData = ItemUtility.GenerateItemData(data.rewardbox.itemId)
  coinData.count = data.rewardbox.count
  ItemUtility.ShowItem(self, chatCell.coinCtr, coinData, true)
end

function Activity_TiankongmigeUI:CreateWeekTableView()
  self.MissionWeekTableView = UITableView()
  self.MissionWeekTableView:SetLowerMargin(0)
  self.MissionWeekTableView:SetScrollView(self.WeekMission_scroll)
  self.MissionWeekTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableWeekView)
  self.MissionWeekTableView:SetUpperMargin(0)
  self.MissionWeekTableView:SetTotalCellCount(self, self.NumberOfCellsInTableWeekView)
  self.MissionWeekTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableWeekView)
  self.MissionWeekTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableWeekViewWillAppear)
  self.MissionWeekTableView:ReloadData(1)
  self.MissionWeekTableView:ScrollToCell(1, true)
end

function Activity_TiankongmigeUI:ScalarForCellInTableWeekView()
  local sizeX, sizeY = self.Weekmission:GetSizeDelta()
  return sizeX
end

function Activity_TiankongmigeUI:NumberOfCellsInTableWeekView()
  self.MissionWeekData = CommercializeData:TianKongMiGeMission(TianKongMiGeMissionType.week)
  self.Weekmaxcount = self.MissionWeekData and table.count(self.MissionWeekData) or 0
  return self.Weekmaxcount
end

function Activity_TiankongmigeUI:CellAtIndexInTableWeekView(index)
  return self.MissionWeekTableView:ReuseOrCreateCell(self.Weekmission)
end

function Activity_TiankongmigeUI:CellAtIndexInTableWeekViewWillAppear(index)
  local data = self.MissionWeekData[index]
  local chatCell = self.MissionWeekTableView:GetLoadedCell(index)
  local lab_mission = chatCell:GetChild("lab_mission")
  local lab_missionCount = chatCell:GetChild("lab_missionCount")
  local lab_complete = chatCell:GetChild("lab_complete")
  if index > self.WeekShowcount then
    self.Weekleft:SetActive(true)
  elseif index == 1 then
    self.Weekleft:SetActive(false)
  end
  if index < self.Weekmaxcount then
    self.Weekright:SetActive(true)
  else
    self.Weekright:SetActive(false)
  end
  chatCell.coinCtr = ItemUtility.InitItem(UIControl(chatCell.transform, "btn_Item"))
  lab_mission:SetText(data.description)
  lab_missionCount:SetText(data.serCount .. "/" .. data.taskgoal.goalCount)
  local comp = data.serCount == data.taskgoal.goalCount and true or false
  lab_missionCount:SetActive(not comp)
  lab_complete:SetActive(comp)
  local coinData = ItemUtility.GenerateItemData(data.rewardbox.itemId)
  coinData.count = data.rewardbox.count
  ItemUtility.ShowItem(self, chatCell.coinCtr, coinData, true)
end

function Activity_TiankongmigeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_TiankongmigeUI:OnHide()
end

function Activity_TiankongmigeUI:OnDestroy()
end

function Activity_TiankongmigeUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_reward:SetOnClick(self, self.btn_rewardOnClick)
  self.btn_mission:SetOnClick(self, self.btn_missionOnClick)
  self.btn_buy:SetOnClick(self, self.btn_buyOnClick)
  self.unlockbtn_close:SetOnClick(self, self.unlockbtn_closeOnClick)
  self.btn_getAll:SetOnClick(self, self.btn_getAllOnClick)
  self.BuyPointsBtn:SetOnClick(self, self.BuyPointsBtnOnClick)
  self.BuyContractclose:SetOnClick(self, self.BuyContractcloseOnClick)
  self.LessBut:SetOnClick(self, self.LessPlusButOnclick)
  self.PlusButton:SetOnClick(self, self.LessPlusButOnclick)
  self.BuyContractbtn_buy:SetOnClick(self, self.BuyContractbtn_buyOnclick)
end

function Activity_TiankongmigeUI:btn_closeOnClick()
  if self.BuyContractvaluePanel.gameObject.activeSelf then
    self:BuyContractcloseOnClick()
  end
  UIManager.Hide(UIID.ActivityTiankongmigeUI)
end

function Activity_TiankongmigeUI:IsOnPanel(PanelName)
  local TooleIsOn = {
    self.rewardPanel,
    self.missionPanel
  }
  for i = 1, #TooleIsOn do
    if TooleIsOn[i] == PanelName then
      TooleIsOn[i].gameObject:SetActive(true)
    else
      TooleIsOn[i].gameObject:SetActive(false)
    end
  end
end

function Activity_TiankongmigeUI:btn_rewardOnClick()
  self.Btn_RewardOn = true
  CommercializeController.ReqSkyPavilionInfo()
  self:IsOnPanel(self.rewardPanel)
end

function Activity_TiankongmigeUI:btn_missionOnClick()
  self.Btn_Mission = true
  CommercializeController.ReqSkyPavilionInfo()
  self:IsOnPanel(self.missionPanel)
end

function Activity_TiankongmigeUI:btn_buyOnClick(control)
  DataToCSharpMgr.Pay({
    amount = control.rmb,
    product_Id = control.id
  })
end

function Activity_TiankongmigeUI:unlockbtn_closeOnClick()
  self.unlockVipPanel:SetActive(false)
end

function Activity_TiankongmigeUI:btn_getAllOnClick()
  self.ReceiveBtnIndex = nil
  NetManager.Send(RechargeMessage.ReqGetAllSkyPavilionReward)
end

function Activity_TiankongmigeUI:CreateSearchFriendTableView()
  self.tableViewSearch = UITableView()
  self.tableViewSearch:SetLowerMargin(0)
  self.tableViewSearch:SetScrollView(self.BuyContractView)
  self.tableViewSearch:SetNumberOfCellsAtRowOrColumn(6)
  _, self.img_lookBgSizeY = self.BuyContractbtn_Item:GetSizeDelta()
  self.tableViewSearch:SetScalarForCellInTableView(self, self.GetSizeSearchCell)
  self.tableViewSearch:SetUpperMargin(0)
  self.tableViewSearch:SetTotalCellCount(self, self.GetSearchCountCount)
  self.tableViewSearch:SetCellAtIndexInTableView(self, self.GetSearchCell)
  self.tableViewSearch:SetCellAtIndexInTableViewWillAppear(self, self.UpdateSearchCell)
  self.tableViewSearch:ReloadData(1)
end

function Activity_TiankongmigeUI:GetSizeSearchCell()
  return self.img_lookBgSizeY
end

function Activity_TiankongmigeUI:GetSearchCountCount()
  return table.count(self.BuyPointsItemInfo)
end

function Activity_TiankongmigeUI:GetSearchCell(index)
  return self.tableViewSearch:ReuseOrCreateCell(self.BuyContractbtn_Item, UITableViewCellLifeCycleEnum.DestroyWhenDisappeared)
end

function Activity_TiankongmigeUI:UpdateSearchCell(index)
  local itemid = self.BuyPointsItemInfo[index].itemId
  local searchCell = self.tableViewSearch:GetLoadedCell(index)
  searchCell.ctr = ItemUtility.InitItem(UIControl(searchCell.transform, "btn_Item"))
  local coinDataord = ItemUtility.GenerateItemData(itemid)
  coinDataord.count = self.BuyPointsItemInfo[index].count
  ItemUtility.ShowItem(self, searchCell.ctr, coinDataord, true)
end

function Activity_TiankongmigeUI:BuyPointsInitData()
  local up = self.level + 1
  if 1 <= self.BuySecretorder then
    local Orditem = {
      itemId = self.RewardData[up].Ordinarydata.rewardBox.itemId,
      count = self.RewardData[up].Ordinarydata.rewardBox.count
    }
    table.insert(self.BuyPointsItemInfo, Orditem)
    local Advitem = {
      itemId = self.RewardData[up].Advanceddata.rewardBox.itemId,
      count = self.RewardData[up].Advanceddata.rewardBox.count
    }
    table.insert(self.BuyPointsItemInfo, Advitem)
  else
    local Orditem = {
      itemId = self.RewardData[up].Ordinarydata.rewardBox.itemId,
      count = self.RewardData[up].Ordinarydata.rewardBox.count
    }
    table.insert(self.BuyPointsItemInfo, Orditem)
  end
end

function Activity_TiankongmigeUI:BuyPointsBtnOnClick(control)
  local buyinfo = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(4011405)
  local buydata = string.split(buyinfo, "#")
  self.addbuyid = tonumber(buydata[1])
  self.addprice = tonumber(buydata[2])
  self.addlevel = 1
  self.mun:SetText(self.addlevel)
  self.LessBut.add = false
  self.PlusButton.add = true
  self.LessBut:SetInteractable(false)
  local mun = self.addlevel + self.level
  self.BuyContracttips:SetText(string.format("T\196\131ng \196\145\225\186\191n c\225\186\165p %s, s\225\186\189 nh\225\186\173n th\198\176\225\187\159ng sau", mun))
  local dagcount = BagInfoData.GetItemCountByItemConfigId(self.addbuyid)
  local Color = dagcount < self.addprice and "<color=#ED2E2E>" or "<color=#3CD937>"
  local money = string.format("%s%s%s%s</color>", Color, self.addprice, "/", dagcount)
  self.btn_moneyText:SetText(money)
  self.btn_money.ctr = ItemUtility.InitItem(UIControl(self.btn_money.transform))
  local coinDataord = ItemUtility.GenerateItemData(self.addbuyid)
  ItemUtility.ShowItem(self, self.btn_money.ctr, coinDataord, true)
  if self.level >= self.addRewardcount then
    self.PlusButton:SetInteractable(false)
  else
    self.PlusButton:SetInteractable(true)
    self.BuyPointsItemInfo = {}
    self:BuyPointsInitData()
    if not self.tableViewSearch then
      self:CreateSearchFriendTableView()
    else
      self.tableViewSearch:ReloadData(1)
    end
  end
  self.BuyContractvaluePanel:SetActive(true)
end

function Activity_TiankongmigeUI:LessPlusButOnclick(control)
  local mun
  if control.add then
    if self.addlevel == 1 then
      self.LessBut:SetInteractable(true)
    end
    self.addlevel = self.addlevel + 1
    mun = self.addlevel + self.level
    if mun >= self.addRewardcount then
      self.PlusButton:SetInteractable(false)
    end
    if 1 <= self.BuySecretorder then
      local Orditem = {
        itemId = self.RewardData[mun].Ordinarydata.rewardBox.itemId,
        count = self.RewardData[mun].Ordinarydata.rewardBox.count
      }
      table.insert(self.BuyPointsItemInfo, Orditem)
      local Advitem = {
        itemId = self.RewardData[mun].Advanceddata.rewardBox.itemId,
        count = self.RewardData[mun].Advanceddata.rewardBox.count
      }
      table.insert(self.BuyPointsItemInfo, Advitem)
    else
      local Orditem = {
        itemId = self.RewardData[mun].Ordinarydata.rewardBox.itemId,
        count = self.RewardData[mun].Ordinarydata.rewardBox.count
      }
      table.insert(self.BuyPointsItemInfo, Orditem)
    end
    self.tableViewSearch:AppendData()
  else
    self.PlusButton:SetInteractable(true)
    self.addlevel = self.addlevel - 1
    if self.addlevel == 1 then
      self.LessBut:SetInteractable(false)
    end
    mun = self.addlevel + self.level
    if 1 <= self.BuySecretorder then
      table.remove(self.BuyPointsItemInfo)
      table.remove(self.BuyPointsItemInfo)
    else
      table.remove(self.BuyPointsItemInfo)
    end
    self.tableViewSearch:RemovedData()
  end
  self.mun:SetText(self.addlevel)
  local price = self.addprice * self.addlevel
  local dagcount = BagInfoData.GetItemCountByItemConfigId(self.addbuyid)
  local Color = dagcount < self.addprice * self.addlevel and "<color=#ED2E2E>" or "<color=#3CD937>"
  local money = string.format("%s%s%s%s</color>", Color, price, "/", dagcount)
  self.btn_moneyText:SetText(money)
  self.BuyContracttips:SetText(string.format("T\196\131ng \196\145\225\186\191n c\225\186\165p %s, s\225\186\189 nh\225\186\173n th\198\176\225\187\159ng sau", mun))
end

function Activity_TiankongmigeUI:BuyContractcloseOnClick()
  self.addbuyid = nil
  self.addprice = nil
  self.addlevel = nil
  self.BuyPointsItemInfo = {}
  local Content = self.BuyContractView:GetChild("Viewport/Content")
  self.BuyContractvaluePanel:SetActive(false)
  for i, v in pairs(Content.transform) do
    UnityEngineLua.GameObject.Destroy(v.gameObject)
  end
end

function Activity_TiankongmigeUI:BuyContractbtn_buyOnclick()
  if BagInfoData.GetItemCountByItemConfigId(self.addbuyid) < self.addprice * self.addlevel then
    LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughGold, self.BuyContractbtn_buy)
    return
  end
  local id = ConfigManager.FindConfigs("cfg_Item_buy", "type", 12)[1].id
  if self.addlevel + self.level >= self.addRewardcount and self.score % self.UpgradePoints > 0 then
    local prompTipArgs = {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "Mua Th\225\186\187 Kh\225\186\191 \198\175\225\187\155c s\225\187\145 l\198\176\225\187\163ng hi\225\187\135n t\225\186\161i s\225\186\189 d\198\176 ra m\225\187\153t s\225\187\145 \196\144i\225\187\131m, ti\225\186\191p t\225\187\165c mua?",
      ok = function()
        NetManager.Send(ItemBuyMessage.ReqBuy, {
          goodId = id,
          buyCount = self.addlevel
        })
        UIManager.Hide(UIID.PromptTipUI)
      end,
      canel = function()
        UIManager.Hide(UIID.PromptTipUI)
      end
    }
    UIManager.Show(UIID.PromptTipUI, prompTipArgs)
    return
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = id,
    buyCount = self.addlevel
  })
end

function Activity_TiankongmigeUI:RegistEvents()
  self:RegistEvent(Event.Commer_SkyPavilionInfo, self.RefreshSkyPavilionInfo, self)
  self:RegistEvent(Event.Commer_SkyPavilionRefresh, self.RefreshSkyPavilion, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
  self:RegistEvent(Event.EquipAttriUpdate, self.OnResEquipChange, self)
  self:RegistEvent(Event.TakeOffEquip, self.TakeOffEquipFunc, self)
end

function Activity_TiankongmigeUI:RefreshReward()
  self.Btn_RewardOn = false
  self.SkyPayData = CommercializeData.SkyPavilionInfo
  if self.LevelGoropid ~= self.SkyPayData.groupId then
    CommercializeData:TianKongMiGeRewardFun(self.SkyPayData.groupId)
    if self.addRewardcount == 0 then
      local data = CommercializeData:TianKongMiGeReward()
      self.addRewardcount = table.count(data)
    end
  end
  CommercializeData:SkyPavilionRefresh()
  self.ShowRewardindex = self:ShowCurrentItem()
  local showscore = self.score % self.UpgradePoints
  if self.level >= self.addRewardcount then
    self.lab_scoreValue:SetText("\196\144\195\163 \196\145\225\186\167y c\225\186\165p")
  else
    self.lab_scoreValue:SetText(showscore .. "/" .. self.UpgradePoints)
  end
  if self.level >= self.addRewardcount then
    self.BuyPointsBtn:SetActive(false)
  else
    self.BuyPointsBtn:SetActive(true)
  end
  self.LevelGoropid = self.SkyPayData.groupId
  self:SetRewardInfoIcon(self.level)
  if not self.rewardGiftTableView then
    self:CreateTableView()
  else
    self.rewardGiftTableView:ReloadData(self.ShowRewardindex)
  end
end

function Activity_TiankongmigeUI:RefreshMission()
  self.Btn_Mission = false
  self.SkyPayData = CommercializeData.SkyPavilionInfo
  CommercializeData:TianKongMiGeMissionFun(self.SkyPayData.tasks)
  if not self.MissionDayTableView then
    self:CreateDayTableView()
  else
    self.MissionDayTableView:ReloadData(1)
  end
  if not self.MissionWeekTableView then
    self:CreateWeekTableView()
  else
    self.MissionWeekTableView:ReloadData(1)
  end
end

function Activity_TiankongmigeUI:RefreshSkyPavilionInfo()
  self.btn_rewardbg:SetActive(self.Btn_RewardOn)
  self.btn_missionbg:SetActive(self.Btn_Mission)
  if self.Btn_RewardOn then
    self:RefreshReward()
    return
  end
  if self.Btn_Mission then
    self:RefreshMission()
  end
end

function Activity_TiankongmigeUI:ShowCurrentItem()
  local mixshowleve = math.ceil(self.RewardShowcount / 2)
  if self.level >= 0 and mixshowleve >= self.level then
    return 1
  else
    local data = CommercializeData:TianKongMiGeReward()
    local mun = self.level <= table.count(data) and self.level or table.count(data)
    for i = 1, mun do
      if data[i].Ordinarydata.Received == nil then
        if i <= mixshowleve then
          return 1
        else
          return i - mixshowleve + 1
        end
      end
    end
  end
end

local lastRewardindex

function Activity_TiankongmigeUI:RefreshSkyPavilion()
  CommercializeData:SkyPavilionRefresh()
  if self.ReceiveBtnIndex then
    self:CellAtIndexInTableViewWillAppear(self.ReceiveBtnIndex)
    return
  end
  self.ShowRewardindex = self:ShowCurrentItem()
  self:RefreshReward()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.school,
    state = true
  })
end

function Activity_TiankongmigeUI:OnCoinChanged()
  local scorechange = BagInfoData.GetItemCountByItemConfigId(1000100)
  if scorechange ~= self.score then
    self:Refresh()
    if self.BuyContractvaluePanel.gameObject.activeSelf then
      self:BuyContractcloseOnClick()
    end
  end
  if self.BuyContractvaluePanel.gameObject.activeSelf then
    local dagcount = BagInfoData.GetItemCountByItemConfigId(self.addbuyid)
    local Color = dagcount < self.addprice and "<color=#ED2E2E>" or "<color=#3CD937>"
    local money = string.format("%s%s%s%s</color>", Color, self.addprice, "/", dagcount)
    self.btn_moneyText:SetText(money)
  end
end

function Activity_TiankongmigeUI:OnResEquipChange()
  local data = RoleManager.me.data.equipsData.StoneData
  local BuyMiLing = data[cell] and data[cell].count or 0
  if self.BuySecretorder ~= BuyMiLing and BuyMiLing ~= 0 then
    self.BuySecretorder = BuyMiLing
    self.unlockVipPanel:SetActive(false)
  end
end

function Activity_TiankongmigeUI:TakeOffEquipFunc()
  local data = RoleManager.me.data.equipsData.StoneData
  local BuyMiLing = data[cell] and data[cell].count or 0
  if self.BuySecretorder ~= BuyMiLing and BuyMiLing ~= 1 then
    self.BuySecretorder = BuyMiLing
  end
end

function Activity_TiankongmigeUI:Refresh()
  self:RefreshValue()
  self:btn_rewardOnClick()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.sky,
    state = true
  })
end

function Activity_TiankongmigeUI:RefreshValue()
  local data = RoleManager.me.data.equipsData.StoneData
  self.BuySecretorder = data[cell] and data[cell].count or 0
  self.score = BagInfoData.GetItemCountByItemConfigId(1000100)
  self.level = math.modf(self.score / self.UpgradePoints)
  self.lab_levelValue:SetText(self.level)
end

local function Stageaward(level, Data)
  for i, v in pairs(Data) do
    if level < v.TianKongreward.level then
      return v.TianKongreward.level
    elseif v.TianKongreward.level == level then
      local index = i + 1
      local level = Data[index] and Data[index].TianKongreward.level or Data[i].TianKongreward.level
      return level
    end
  end
  local index = #Data
  return Data[index].TianKongreward.level
end

function Activity_TiankongmigeUI:SetRewardInfoIcon(level)
  local RewData = CommercializeData:TianKongMiGeReward()
  local StageData = CommercializeData:GetTianKongmIGeStageAward()
  local Showleve = Stageaward(level, StageData.Advan)
  self.normalReward.coinCtr = ItemUtility.InitItem(UIControl(self.normalReward.transform))
  local coinData = ItemUtility.GenerateItemData(RewData[Showleve].Ordinarydata.rewardBox.itemId)
  coinData.count = RewData[Showleve].Ordinarydata.rewardBox.count
  ItemUtility.ShowItem(self, self.normalReward.coinCtr, coinData, true)
  if Showleve then
    self.normal_tips:SetText(string.format("C\225\186\165p M\225\186\173t C\195\161c\nC\225\186\165p %s nh\225\186\173n", Showleve))
  else
    self.normal_tips:SetText("\196\144\195\163 nh\225\186\173n xong")
  end
  local Showadvleve = Stageaward(level, StageData.Advan)
  self.VIPReward.coinCtr = ItemUtility.InitItem(UIControl(self.VIPReward.transform))
  local coinData = ItemUtility.GenerateItemData(RewData[Showadvleve].Advanceddata.rewardBox.itemId)
  coinData.count = RewData[Showadvleve].Advanceddata.rewardBox.count
  ItemUtility.ShowItem(self, self.VIPReward.coinCtr, coinData, true)
  if Showadvleve then
    self.VIP_tips:SetText(string.format("C\225\186\165p M\225\186\173t C\195\161c\nC\225\186\165p %s nh\225\186\173n", Showleve))
  else
    self.VIP_tips:SetText("\196\144\195\163 nh\225\186\173n xong")
  end
end
