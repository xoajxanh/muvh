Commercial_ReturnActivityUI = class(BaseUI)
Commercial_ReturnActivityUI.layer = UILayer.Panel
Commercial_ReturnActivityUI.orderInLayer = 0
Commercial_ReturnActivityUI.hideType = UIHideType.WaitDestroy
Commercial_ReturnActivityUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_ReturnActivityUI.escClose = UIEscClose.DontClose

function Commercial_ReturnActivityUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.sw_combineActivityList = self:GetControl("sw_combineActivityList")
  self.Btn_Return = self:GetControl("sw_combineActivityList/Viewport/Content/Btn_Return")
  self.go_returnReward = self:GetControl("go_returnReward")
  self.FireworksfireTime = self:GetControl("go_returnReward/FireworksfireTime")
  self.go_returnPack = self:GetControl("go_returnPack")
  self.sw_returnPack = self:GetControl("go_returnPack/sw_returnPack")
  self.returnPack_Content = self:GetControl("go_returnPack/sw_returnPack/Viewport/returnPack_Content")
  self.bg_returnPackGist = self:GetControl("go_returnPack/sw_returnPack/Viewport/returnPack_Content/bg_returnPackGist")
  self.Img_rechangeArrow = self:GetControl("go_returnPack/sw_returnPack/Img_rechangeArrow")
  self.Img_rechangeArrow2 = self:GetControl("go_returnPack/sw_returnPack/Img_rechangeArrow2")
  self.go_returnShop = self:GetControl("go_returnShop")
  self.go_Shopitem = self:GetControl("go_returnShop/Viewport/Content/go_Shopitem")
  self.lab_buy = self:GetControl("go_returnShop/Viewport/Content/go_Shopitem/btn_buy/lab_buy")
  self.img_redPoint = self:GetControl("go_returnShop/Viewport/Content/go_Shopitem/btn_buy/img_redPoint")
  self.holidayShopcoin = self:GetControl("go_returnShop/bg/holidayShopcoin")
  self.lab_Shopcoin = self:GetControl("go_returnShop/lab_Shopcoin")
  self.go_returnTask = self:GetControl("go_returnTask")
  self.ReturnTask = self:GetControl("go_returnTask/go_Task/Viewport/Content/bg_returnTaskGist")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.txt_lastTime = self:GetControl("txt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lastTime/lab_lastTime")
end

RETURNTYPE = {
  landing = enum(1),
  gift = enum(),
  shopping = enum(),
  task = enum()
}

function Commercial_ReturnActivityUI:Init()
end

function Commercial_ReturnActivityUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnShopCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "btn_3DItem"))
  ctr.itemCtr.img_grrow.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = false
  ctr.itemModelData = ItemCellData()
  ctr.moneyCtr = UIControl(ctr.transform, "btn_money")
  ctr.txt_buylimit = UIControl(ctr.transform, "txt_buylimit")
  ctr.buyCtr = UIControl(ctr.transform, "Img_bg")
  ctr.costModelData = ItemCellData()
  ctr.Img_bg = UIControl(ctr.transform, "Img_bg")
  ctr.bgBlack = UIControl(ctr.transform, "bgBlack")
  ctr.lab_buylimit = UIControl(ctr.transform, "lab_buylimit")
  ctr.img_money_ground = UIControl(ctr.transform, "btn_money/img_money_ground")
  ctr.lab_num = UIControl(ctr.transform, "btn_money/lab_num")
end

local function OnShopRefresh(ctr, _, data, ui)
  local shopInfo = ParseUtility.ParseSingleCost(data.reward)
  local itemData = ItemUtility.GenerateItemData(shopInfo.itemId)
  itemData.count = shopInfo.count
  ctr.itemModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.itemModelData, ui, true)
  local tbl = ReturnActivityData.GetItemInfoFun(shopInfo.itemId)
  local itemName = tbl.name
  if tbl.colorShow > 0 then
    itemName = string.format("<color=%s>%s</color>", ItemQuality2ColorDic[tbl.colorShow], itemName)
  end
  ctr.itemCtr.nameCtr:SetText(itemName)
  local RefreshCount = data.RefreshCount
  if RefreshCount then
    ctr.lab_buylimit:SetText(RefreshCount .. "A")
  else
    local countTbl = ReturnActivityData.GetCountInfoFun(data.countKey)
    if countTbl and countTbl.refreshCountLimit then
      RefreshCount = countTbl.refreshCountLimit
      ctr.lab_buylimit:SetActive(true)
      ctr.lab_buylimit:SetText(RefreshCount .. "A")
    elseif not countTbl then
      ctr.lab_buylimit:SetActive(false)
    end
  end
  if not RefreshCount then
    ctr.bgBlack:SetActive(false)
  else
    ctr.bgBlack:SetActive(RefreshCount <= 0)
  end
  local Gift = {}
  local cost = string.split(data.cost, "#")
  Gift.cost = tonumber(cost[1])
  Gift.count = tonumber(cost[2])
  local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(Gift.cost)
  local numStr = Gift.count
  if bagCoinCount < Gift.count then
    numStr = string.format("<color=red>%s</color>", numStr)
  end
  ctr.lab_num:SetText(numStr)
  local img = ReturnActivityData.GetItemInfoFun(Gift.cost).icon
  ui:SetSprite("Atlas_Common", img, ctr.img_money_ground, false)
  ctr.Img_bg.data = data
  ctr.Img_bg.itemData = itemData
  ctr.Img_bg:SetOnClick(ui, ui.btn_ShopBuyOnClick)
end

function Commercial_ReturnActivityUI:btn_ShopBuyOnClick(control)
  local data = control.data
  local itemData = control.itemData
  ShopData.CreatBuyItemInfo(data.id)
  local posy = -85
  if itemData.itemId == 7200000 then
    posy = 0
  end
  itemData.tipsPosition = Vector3(0, posy, 0)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    openType = TipsOpenType.ShopOpen,
    showType = itemData.showPos
  })
end

local function OnHolidayGistCreat(ctr)
  ctr.lab_holidayGistName = UIControl(ctr.transform, "lab_returnPackGistName")
  ctr.lab_limitNum = UIControl(ctr.transform, "lab_limit/lab_limitNum")
  ctr.btn_Item = UIControl(ctr.transform, "go_returnPackGistItem/sw_ItemSecondary/Viewport/Content/btn_Item")
  ctr.btn_freePrize = UIControl(ctr.transform, "btn_freePrize")
  ctr.lab_buy = UIControl(ctr.transform, "btn_freePrize/lab_buy")
  ctr.img_sellOut = UIControl(ctr.transform, "img_sellOut")
end

local function OnTaskGistCreat(ctr)
  ctr.lab_returnTaskGistName = UIControl(ctr.transform, "lab_returnTaskGistName")
  ctr.btn_allGet = UIControl(ctr.transform, "btn_allGet")
  ctr.btn_canGet = UIControl(ctr.transform, "btn_canGet")
  ctr.btn_noGet = UIControl(ctr.transform, "btn_noGet")
  ctr.btn_notgetText = UIControl(ctr.transform, "btn_noGet/Text")
  ctr.ReturnPointslab_text = UIControl(ctr.transform, "lab_text")
  ctr.icon = UIControl(ctr.transform, "lab_text/icon")
end

local function OnTaskGistRefresh(ctr, _, data, ui)
  if not (data and data.Msg and data.Msg.giftInfo) or not data.Msg.giftInfo[1] then
    return
  end
  local taskInfo = data.Msg.giftInfo[1]
  local taskName = ClientTable.cfg_Task_goalManager:TryGetValue(taskInfo.giftId)
  local taskNowNum = string.format(taskName.goalTips, data.Msg.current)
  ctr.lab_returnTaskGistName:SetText(taskNowNum)
  local num = taskInfo.roleCount > 0 and "1" or string.GetColorText(0, ItemQuality2ColorDic[12])
  ctr.btn_notgetText:SetText(string.format(num .. "/1"))
  local giftInfo = ClientTable.cfg_Gift_giftManager:TryGetValue(taskInfo.giftId).reward
  local boxInfo = ClientTable.cfg_Box_boxManager:TryGetValue(giftInfo, "boxId")
  ctr.ReturnPointslab_text:SetText(tostring(boxInfo.count))
  ctr.icon:SetOnClick(ui, ui.holidayShopcoinOnClick)
  ctr.btn_canGet.giftId = taskInfo.giftId
  ctr.btn_canGet:SetOnClick(ui, ui.btn_canGetOnClick)
  if taskInfo.roleCount == 0 and taskInfo.canGet then
    ctr.btn_canGet:SetActive(true)
    ctr.btn_allGet:SetActive(false)
    ctr.btn_noGet:SetActive(false)
  elseif taskInfo.roleCount > 0 and taskInfo.canGet then
    ctr.btn_canGet:SetActive(false)
    ctr.btn_allGet:SetActive(true)
    ctr.btn_noGet:SetActive(false)
  else
    ctr.btn_canGet:SetActive(false)
    ctr.btn_allGet:SetActive(false)
    ctr.btn_noGet:SetActive(true)
  end
end

function Commercial_ReturnActivityUI:btn_canGetOnClick(ctr)
  if ctr.giftId then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        ctr.giftId
      }
    })
  end
end

local function GetUIText(title)
  return LocalizationUtility.GetContentByKey(title)
end

local function OnBtnItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnBtnItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function OnHolidayGistRefresh(ctr, _, data, ui)
  local Title = GetUIText(data.title)
  if Title then
    ctr.lab_holidayGistName:SetText(Title)
  end
  ctr.btn_freePrize:SetActive(data.Received)
  ctr.img_sellOut:SetActive(not data.Received)
  if data.RefreshCount then
    ctr.lab_limitNum:SetText("L\198\176\225\187\163t mua c\195\178n: " .. data.RefreshCount)
  else
    local countTbl = ReturnActivityData.GetCountInfoFun(data.countKey)
    ctr.lab_limitNum:SetText("L\198\176\225\187\163t mua c\195\178n: " .. countTbl.refreshCountLimit)
  end
  if ctr.GistBtnItemContainer == nil then
    ctr.GistBtnItemContainer = UIContainer(ctr.btn_Item, ui, OnBtnItemCreat, OnBtnItemRefresh)
  end
  local Gift
  if data.rmb then
    local rmb = math.floor(data.rmb / 100)
    ctr.lab_buy:SetText("" .. rmb .. "VND")
    local BoxItem = ReturnActivityData.GetBoxinfoFun(data.reward)
    ctr.GistBtnItemContainer:SetData(BoxItem)
    if data.title and data.title ~= "" then
      local Title = string.format(GetUIText(data.title), rmb)
      ctr.lab_holidayGistName:SetText(Title)
    end
  else
    Gift = {}
    local cost = string.split(data.cost, "#")
    local costlab = ReturnActivityData.GetItemInfoFun(EBindCoinsType[tonumber(cost[1])]).name
    Gift.cost = tonumber(cost[1])
    Gift.count = tonumber(cost[2])
    ctr.lab_buy:SetText(cost[2] .. costlab)
    local reward = string.split(data.reward, "#")
    local ItemuseParam = ReturnActivityData.GetItemInfoFun(tonumber(reward[1])).useParam
    local ItemBox = string.split(ItemuseParam, "#")
    local BoxItem = ReturnActivityData.GetBoxinfoFun(tonumber(ItemBox[2]))
    ctr.GistBtnItemContainer:SetData(BoxItem)
    if data.title and data.title ~= "" then
      local Title = string.format(GetUIText(data.title), cost[1])
      ctr.lab_holidayGistName:SetText(Title)
    end
  end
  ctr.btn_freePrize.data = data
  ctr.btn_freePrize.Gift = Gift
  ctr.btn_freePrize:SetOnClick(ui, ui.btn_PrizeBuyOnClick)
end

function Commercial_ReturnActivityUI:InitUI()
  self.go_returnLandingRewardTemp = luaTemplateManager.GetNewTemplate(self.go_returnReward, LuaComponentTemplates.returnRewardTemplate, self)
  self.BtnReturnContainer = UIUtility.BindUIContainerTemp(self.Btn_Return, LuaComponentTemplates.Activity_CommercialReturn_Page, self)
  self.ShopContainer = UIContainer(self.go_Shopitem, self, OnShopCreate, OnShopRefresh)
  self.ReturnPackGist = UIContainer(self.bg_returnPackGist, self, OnHolidayGistCreat, OnHolidayGistRefresh)
  self.ReturnTask = UIContainer(self.ReturnTask, self, OnTaskGistCreat, OnTaskGistRefresh)
  self.rechangeArrowPos = self.Img_rechangeArrow.gameObject.transform.localPosition
  self.rechangeArrowPos2 = self.Img_rechangeArrow2.gameObject.transform.localPosition
  self.PlanType = {
    [CommercializeHolidayGrop.HolidayRetrunLoading] = self.go_returnReward,
    [CommercializeHolidayGrop.HolidayRetrunShop] = self.go_returnShop,
    [CommercializeHolidayGrop.HolidayRetrunPack] = self.go_returnPack,
    [CommercializeHolidayGrop.HolidayRetrunTask] = self.go_returnTask
  }
end

function Commercial_ReturnActivityUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.holidayShopcoin:SetOnClick(self, self.holidayShopcoinOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.sw_returnPack:SetOnEndDrag(self, self.sw_rechangeOnEndDragTeam)
end

function Commercial_ReturnActivityUI:RefreshShowBtn(data)
  local index = 1
  if self.args and self.args.openType then
    local group = tonumber(self.args.openType)
    for i = 1, #data do
      if data[i].group == group then
        index = i
        break
      end
    end
  end
  self:BtnReturnOnClick({
    data = data[index]
  })
end

function Commercial_ReturnActivityUI:RefreshShowPanel(data)
  for i, v in pairs(self.PlanType) do
    if data.group == i then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

function Commercial_ReturnActivityUI:Commer_ReturnTog(_)
  self.BtnGroup = ReturnActivityData.RefreshHolidayTogIdInfo(1)
  if table.count(self.BtnGroup) == 0 then
    self:btn_closeOnClick()
    return
  end
  self.BtnReturnContainer:SetData(self.BtnGroup)
  self:RefreshShowBtn(self.BtnGroup)
end

function Commercial_ReturnActivityUI:Commer_ReturnTogRedPoint(data)
  local groupId = data.group
  local index = 1
  for i, v in pairs(ReturnActivityData.HolidayTogId) do
    if v == groupId then
      index = i
      break
    end
  end
  self.BtnGroup = ReturnActivityData.RefreshHolidayTogIdInfo(index)
  self.BtnReturnContainer:SetData(self.BtnGroup)
end

function Commercial_ReturnActivityUI:BtnReturnOnClick(control)
  local data = control.data
  self.BtnReturnInfo = data
  if not data then
    return
  end
  if data.group == CommercializeHolidayGrop.HolidayRetrunLoading then
    self:ShowReturnReward()
  elseif data.group == CommercializeHolidayGrop.HolidayRetrunShop then
    self:ShowReturnShop()
  elseif data.group == CommercializeHolidayGrop.HolidayRetrunPack then
    self:ShowReturnPack()
  elseif data.group == CommercializeHolidayGrop.HolidayRetrunTask then
    self:ShowReturnTask()
  end
  for i, v in pairs(self.BtnGroup) do
    if v.group == data.group then
      local tog = self.BtnReturnContainer.items[i].itemTemp
      if tog then
        tog:SetClickEffect(true)
      end
    else
      local tog = self.BtnReturnContainer.items[i].itemTemp
      if tog then
        tog:SetClickEffect(false)
      end
    end
  end
end

function Commercial_ReturnActivityUI:ShowReturnReward()
  networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.Return_service, CommercializeHolidayGrop.HolidayRetrunLoading, 1)
end

function Commercial_ReturnActivityUI:ShowReturnPack()
  networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.Return_service, CommercializeHolidayGrop.HolidayRetrunPack, 1)
end

function Commercial_ReturnActivityUI:ShowReturnShop()
  networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.Return_service, CommercializeHolidayGrop.HolidayRetrunShop, 1)
end

function Commercial_ReturnActivityUI:ShowReturnTask()
  networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.Return_service, CommercializeHolidayGrop.HolidayRetrunTask, 1)
end

function Commercial_ReturnActivityUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Commercial_ReturnActivityUI)
end

function Commercial_ReturnActivityUI:descBtnOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1097})
end

function Commercial_ReturnActivityUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_ReturnActivityUI)
end

function Commercial_ReturnActivityUI:btn_PrizeBuyOnClick(control)
  local data = control.data
  if data.rmb then
    DataToCSharpMgr.Pay({
      amount = math.floor(data.rmb / 100),
      product_Id = data.id,
      product_name = data.name,
      BusinessPayType = BusinessPayType.None
    })
  end
end

function Commercial_ReturnActivityUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.Return_service
  })
end

function Commercial_ReturnActivityUI:holidayShopcoinOnClick(control)
  local itemid = ClientTable.cfg_Commerce_globalManager:TryGetValue(309101, "id").effect
  local itemData = ItemUtility.GenerateItemData(tonumber(itemid))
  itemData.tipsPosition = Vector3(0, -85, 0)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Commercial_ReturnActivityUI:RegistEvents()
  self:RegistEvent(Event.Commer_Holidayinfo, self.CommerReturnInfo, self)
  self:RegistEvent(Event.Commer_HolidayTog, self.Commer_ReturnTog, self)
  self:RegistEvent(Event.Commer_RetrunActivityRedPoint, self.CommerReturnInfo, self)
end

function Commercial_ReturnActivityUI:CommerReturnInfo()
  local CurrentInfo = ReturnActivityData.HolidaytypeDistinguish()
  if not CurrentInfo or CurrentInfo and CurrentInfo.Msg ~= nil and CurrentInfo.Msg.closeTime == 0 then
    self:btn_closeBgOnClick()
  end
  if CurrentInfo.Msg ~= nil and CurrentInfo.Msg.changePage == 1 then
    self.curPageGroupId = CurrentInfo.group
    self:RefreshShowPanel(CurrentInfo)
  end
  if CurrentInfo.type == CommerceOverviewType.TaskType then
    if CurrentInfo.group == CommercializeHolidayGrop.HolidayRetrunLoading then
      self.go_returnLandingRewardTemp:Refresh(CurrentInfo)
    elseif CurrentInfo.group == CommercializeHolidayGrop.HolidayRetrunTask then
      local data = ReturnActivityData.RefreshHolidayTaskInfo(CurrentInfo)
      self.ReturnTask:SetData(data)
    end
  elseif CurrentInfo.type == CommerceOverviewType.GiftType then
    local ShowBuyInfo, ItemBuyInfo, RechargeInfo = ReturnActivityData.RefreshHolidayGiftTypeInfo(CurrentInfo)
    self:OnSortByCount(ShowBuyInfo)
    self:OnSortByCount(ItemBuyInfo)
    if CurrentInfo.group == CommercializeHolidayGrop.HolidayRetrunShop then
      self.ShopContainer:SetData(ItemBuyInfo)
      local ItemId = ClientTable.cfg_Commerce_globalManager:TryGetValue(309101, "id").effect
      local icon = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(ItemId)).icon
      self:SetSprite("Atlas_Common", icon, self.holidayShopcoin)
      local Shopcoin = BagInfoData.GetItemTotalCountByItemId(tonumber(ItemId))
      self.lab_Shopcoin:SetText(tostring(Shopcoin))
    elseif CurrentInfo.group == CommercializeHolidayGrop.HolidayRetrunPack then
      self.ReturnPackGist:SetData(RechargeInfo)
    end
  end
  self:RefreshCountdownTime(CurrentInfo)
  self:Commer_ReturnTogRedPoint(CurrentInfo)
end

function Commercial_ReturnActivityUI:OnSortByCount(data)
  local acc = 0
  for i = 1, #data do
    i = i + acc
    local Refresh, count = ReturnActivityData.GetRefreshCountFun(data[i].countKey)
    if Refresh then
      local item = data[i]
      item.Received = true
      item.RefreshCount = count
    else
      local item = data[i]
      item.Received = false
      item.RefreshCount = count
      table.remove(data, i)
      table.insert(data, item)
      acc = acc - 1
    end
  end
end

function Commercial_ReturnActivityUI:Bag_ResBagChange(_, msg)
  if self.holidayLuckyTurntableTemplate then
    self.holidayLuckyTurntableTemplate:RefreshCostImgAndLab()
  end
  local showItemTbl = msg.showItemTbl
  if self.BtnHolidayInfo then
    for i, v in pairs(self.coinRefreshPlan) do
      if i == self.BtnHolidayInfo.group then
        if showItemTbl[v.id] or v.bin and showItemTbl[v.bin] then
          self:Commer_Holidayinfo(nil, nil, true)
          return
        end
        if self.BtnHolidayInfo.group == CommercializeHolidayGrop.Fireworks and (showItemTbl[v.bin] or showItemTbl[v.item1] or showItemTbl[v.item2]) then
          self:Commer_Holidayinfo(nil, nil, true)
          return
        end
      end
    end
  end
end

function Commercial_ReturnActivityUI:sw_rechangeOnEndDragTeam()
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.returnPack_Content.rectTransform)
  local endPos = -math.modf(self.returnPack_Content.transform.sizeDelta.x)
  local curPos = math.modf(self.returnPack_Content.transform.anchoredPosition.x)
  if endPos > curPos then
    self.Img_rechangeArrow:SetActive(false)
    self.Img_rechangeArrow.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_rechangeArrow, self.rechangeArrowPos, "X")
    self.Img_rechangeArrow:SetActive(true)
  end
  if -100 < curPos then
    self.Img_rechangeArrow2:SetActive(false)
    self.Img_rechangeArrow2.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_rechangeArrow2, self.rechangeArrowPos2, "X")
    self.Img_rechangeArrow2:SetActive(true)
  end
end

function Commercial_ReturnActivityUI:SetAnimation(btn, pos, Axles)
  btn.gameObject.transform:DOKill()
  if Axles == "X" then
    local left = false
    
    local function MoveLeftX()
      btn.gameObject.transform:DOLocalMoveX(left and pos.x - 10 or pos.x + 10, 1):OnComplete(function()
        left = not left
        btn.gameObject.transform:DOLocalMoveX(left and pos.x - 10 or pos.x + 10, 1):OnComplete(function()
          left = not left
          MoveLeftX()
        end)
      end)
    end
    
    MoveLeftX()
  else
    local function MoveLeftY()
      local top = false
      
      btn.gameObject.transform:DOLocalMoveY(top and pos.y - 10 or pos.y + 10, 1):OnComplete(function()
        top = not top
        btn.gameObject.transform:DOLocalMoveY(top and pos.y - 10 or pos.y + 10, 1):OnComplete(function()
          top = not top
          MoveLeftY()
        end)
      end)
    end
    
    MoveLeftY()
  end
end

function Commercial_ReturnActivityUI:PageExit()
  local pageTemplate
  if type(self.BtnReturnContainer) == "table" and type(self.BtnReturnContainer.items) == "table" then
    for k, v in pairs(self.BtnReturnContainer.items) do
      pageTemplate = v.itemTemp
      if pageTemplate.Exit ~= nil then
        pageTemplate:Exit()
      end
    end
  end
end

local DaojiTime = 0

function Commercial_ReturnActivityUI:RefreshTime(lab_lastTime, txt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    txt_lastTime:SetActive(false)
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercial_ReturnActivityUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Commercial_ReturnActivityUI:RefreshCountdownTime(data)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = 0
  if data and data.deadline and 0 < #data.deadline and data.Msg.closeTime then
    Difference = TimeUtility.RefreshSec(data.Msg.closeTime / 1000)
  end
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTime:SetText("")
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTime:SetText(DaoJiShi)
  else
    self.txt_lastTime:SetText("Th\225\187\157i gian c\195\178n: ")
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTime:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTime, self.txt_lastTime)
  end
end

function Commercial_ReturnActivityUI:Refresh()
end

function Commercial_ReturnActivityUI:OnHide()
  self:RefreshShowPanel({})
  self:SetDestroyTime()
end

function Commercial_ReturnActivityUI:OnDestroy()
end
