Shop_ExpUpUI = class(BaseUI)
Shop_ExpUpUI.layer = UILayer.Panel
Shop_ExpUpUI.orderInLayer = 0
Shop_ExpUpUI.hideType = UIHideType.WaitDestroy
Shop_ExpUpUI.hideFunc = UIHideFunc.MoveOutOfScreen
Shop_ExpUpUI.escClose = UIEscClose.DontClose

function Shop_ExpUpUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_shop/btn_close")
  self.Tog_expUp = self:GetControl("bg_shop/go_efficiencyGroup/Tog_expUp")
  self.Tog_autoPickup = self:GetControl("bg_shop/go_efficiencyGroup/Tog_autoPickup")
  self.Tog_autoRecovery = self:GetControl("bg_shop/go_efficiencyGroup/Tog_autoRecovery")
  self.Tog_dropRate = self:GetControl("bg_shop/go_efficiencyGroup/Tog_dropRate")
  self.Tog_moneyRecovery = self:GetControl("bg_shop/go_efficiencyGroup/Tog_moneyRecovery")
  self.go_ExpUpItemGroup = self:GetControl("bg_shop/go_ExpUpItemGroup")
  self.btn_buy = self:GetControl("bg_shop/go_ExpUpItemGroup/go_ExpUpItem/btn_buy")
  self.exp_left = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left")
  self.exp_left_img = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/exp_left_img")
  self.txt_time_tip = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/txt_time_tip")
  self.txt_time = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/txt_time_tip/txt_time")
  self.btn_content = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/btn_content")
  self.btn_open_serves = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/btn_content/btn_open_serves")
  self.btn_buy_gift = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/btn_content/btn_buy_gift")
  self.btn_buy_now = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/btn_content/btn_buy_now")
  self.btn_3DItem = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_left/btn_3DItem")
  self.exp_right = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_right")
  self.exp_right_img_right = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_right/exp_right_img/exp_right_img_right")
  self.btn_vip_level = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_right/btn_vip_level")
  self.txt = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_right/btn_vip_level/txt")
  self.img_ico = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_right/img_ico")
  self.img_title = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_right/img_title_bg/img_title")
  self.txt_vip_level = self:GetControl("bg_shop/go_ExpUpItemGroup/exp_right/txt_vip_level")
  self.go_AutoPickup = self:GetControl("bg_shop/go_AutoPickup")
  self.btn_activeAutoPickup = self:GetControl("bg_shop/go_AutoPickup/go_btnGroup/btn_activeAutoPickup")
  self.lab_activeAutoPickup = self:GetControl("bg_shop/go_AutoPickup/go_btnGroup/btn_activeAutoPickup/lab_activeAutoPickup")
  self.btn_rechargeActiveAutoPickup = self:GetControl("bg_shop/go_AutoPickup/go_btnGroup/btn_rechargeActiveAutoPickup")
  self.lab_rechargeActiveAutoPickup = self:GetControl("bg_shop/go_AutoPickup/go_btnGroup/btn_rechargeActiveAutoPickup/lab_rechargeActiveAutoPickup")
  self.btn_buyActiveAutoPickup = self:GetControl("bg_shop/go_AutoPickup/go_btnGroup/btn_buyActiveAutoPickup")
  self.lab_buyActiveAutoPickup = self:GetControl("bg_shop/go_AutoPickup/go_btnGroup/btn_buyActiveAutoPickup/lab_buyActiveAutoPickup")
  self.go_AutoRecovery = self:GetControl("bg_shop/go_AutoRecovery")
  self.btn_rechargeActiveAutoRecovery = self:GetControl("bg_shop/go_AutoRecovery/go_btnGroup/btn_rechargeActiveAutoRecovery")
  self.lab_rechargeActiveAutoRecovery = self:GetControl("bg_shop/go_AutoRecovery/go_btnGroup/btn_rechargeActiveAutoRecovery/lab_rechargeActiveAutoRecovery")
  self.btn_activeAutoRecovery = self:GetControl("bg_shop/go_AutoRecovery/go_btnGroup/btn_activeAutoRecovery")
  self.lab_activeAutoRecovery = self:GetControl("bg_shop/go_AutoRecovery/go_btnGroup/btn_activeAutoRecovery/lab_activeAutoRecovery")
  self.btn_buyActiveAutoRecovery = self:GetControl("bg_shop/go_AutoRecovery/go_btnGroup/btn_buyActiveAutoRecovery")
  self.lab_buyActiveAutoRecovery = self:GetControl("bg_shop/go_AutoRecovery/go_btnGroup/btn_buyActiveAutoRecovery/lab_buyActiveAutoRecovery")
  self.go_DropRate = self:GetControl("bg_shop/go_DropRate")
  self.btn_activeDropRate = self:GetControl("bg_shop/go_DropRate/btn_activeDropRate")
  self.lab_activeDropRate = self:GetControl("bg_shop/go_DropRate/btn_activeDropRate/lab_activeDropRate")
  self.lab_activeDropRateDes = self:GetControl("bg_shop/go_DropRate/lab_activeDropRateDes")
  self.txt_activeDropRate = self:GetControl("bg_shop/go_DropRate/txt_activeDropRate")
  self.go_MoneyRecovery = self:GetControl("bg_shop/go_MoneyRecovery")
  self.btn_activeMoneyRecovery = self:GetControl("bg_shop/go_MoneyRecovery/btn_activeMoneyRecovery")
  self.lab_activeMoneyRecovery = self:GetControl("bg_shop/go_MoneyRecovery/btn_activeMoneyRecovery/lab_activeMoneyRecovery")
  self.lab_activeMoneyRecoveryDes = self:GetControl("bg_shop/go_MoneyRecovery/lab_activeMoneyRecoveryDes")
  self.go_levelGift = self:GetControl("bg_shop/go_levelGift")
  self.lab_finish = self:GetControl("bg_shop/go_levelGift/lab_finish")
  self.unfinished_Panel = self:GetControl("bg_shop/go_levelGift/unfinished_Panel")
  self.level_Item = self:GetControl("bg_shop/go_levelGift/unfinished_Panel/level_Item")
  self.txt_level = self:GetControl("bg_shop/go_levelGift/unfinished_Panel/txt_Tips/txt_level")
  self.btn_getGift = self:GetControl("bg_shop/go_levelGift/unfinished_Panel/btn_getGift")
  self.Tog_pointGain = self:GetControl("bg_shop/go_efficiencyGroup/Tog_pointGain")
  self.go_PointGain = self:GetControl("bg_shop/go_PointGain")
  self.descBtn = self:GetControl("bg_shop/go_PointGain/descBtn")
end

function Shop_ExpUpUI:OnPreLoad()
end

function Shop_ExpUpUI:Init()
  self.maxVipLevel = 50
  self.goLevelCountKeyTbl = {}
  self.MinGoLevelCountKey = 0
  self.MaxGoLevelCountKey = 0
  self.goLevelCountKey = 0
end

function Shop_ExpUpUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Shop_ExpUpUI:InitUI()
  self:InitContent()
end

function Shop_ExpUpUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Shop_ExpUpUI:OnHide()
end

function Shop_ExpUpUI:OnDestroy()
  self:ClearEff()
end

function Shop_ExpUpUI:RegistUIEvents()
  self.Tog_expUp:SetOnToggleChanged(self, self.Tog_expUpOnChanged)
  self.Tog_autoPickup:SetOnToggleChanged(self, self.Tog_autoPickupOnChanged)
  self.Tog_autoRecovery:SetOnToggleChanged(self, self.Tog_autoRecoveryOnChanged)
  self.Tog_dropRate:SetOnToggleChanged(self, self.Tog_dropRateOnChanged)
  self.Tog_moneyRecovery:SetOnToggleChanged(self, self.Tog_moneyRecoveryOnChanged)
  self.Tog_pointGain:SetOnToggleChanged(self, self.Tog_pointGainOnChanged)
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
  self.btn_buy:SetOnClick(self, self.btn_buyOnClick)
  self.btn_activeAutoPickup:SetOnClick(self, self.btn_activeAutoPickupOnClick)
  self.btn_activeAutoRecovery:SetOnClick(self, self.btn_activeAutoRecoveryOnClick)
  self.btn_activeDropRate:SetOnClick(self, self.btn_activeDropRateOnClick)
  self.btn_activeMoneyRecovery:SetOnClick(self, self.btn_activeMoneyRecoveryOnClick)
  self.btn_getGift:SetOnClick(self, self.btn_getGiftOnClick)
  self.btn_open_serves:SetOnClick(self, self.Tog_expOpenPackage)
  self.btn_buy_gift:SetOnClick(self, self.Tog_expBuyPackage)
  self.btn_buy_now:SetOnClick(self, self.btn_buy_nowOnClick)
  self.exp_left_img.itemData = ItemUtility.GenerateItemData(3000405)
  self.exp_left_img:SetOnClick(ItemUtility, ItemUtility.ClickItemBtn)
  self.btn_vip_level:SetOnClick(self, self.Tog_expVvip)
  self.btn_rechargeActiveAutoPickup:SetOnClick(self, self.btn_rechargeActiveAutoPickupOnClick)
  self.btn_buyActiveAutoPickup:SetOnClick(self, self.btn_buyActiveAutoPickupOnClick)
  self.btn_buyActiveAutoRecovery:SetOnClick(self, self.btn_buyActiveAutoRecoveryOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Shop_ExpUpUI:InitContent()
  local txt
  txt = self.btn_open_serves:GetChild("txt1")
  if txt then
    txt:SetText("G\195\179i Qu\195\160")
  end
  txt = self.btn_buy_gift:GetChild("txt2")
  if txt then
    txt:SetText("Mua ngay m\225\187\151i ng\195\160y")
  end
end

function Shop_ExpUpUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Shop_ExpUpUI)
end

function Shop_ExpUpUI:RegistEvents()
  self:RegistEvent(Event.Commer_goLevelReward, self.Commer_goLevelReward, self)
  self:RegistEvent(Event.Role_MyLvChanged, self.Role_MyLvChanged, self)
end

function Shop_ExpUpUI:Refresh()
  self:RefreshData()
  self.Tog_expUp.toggle.isOn = true
  self:Tog_expUpOnChanged(self.Tog_expUp, true)
  self:RefreshUI()
end

function Shop_ExpUpUI:RefreshUI()
  self.Tog_expUp:SetActive(true)
  local act = self:GetStoneData()[4001]
  self.Tog_autoPickup:SetActive(self:GetOpenByConditton(2210006))
  self.btn_activeAutoPickup:SetActive(self:GetOpenByConditton(2210012))
  self.btn_activeAutoRecovery:SetActive(self:GetOpenByConditton(2210015))
  self.btn_rechargeActiveAutoPickup:SetActive(self:GetOpenByConditton(2210013))
  self.btn_buyActiveAutoPickup:SetActive(self:GetOpenByConditton(2210014))
  self.btn_buyActiveAutoRecovery:SetActive(self:GetOpenByConditton(2210016))
  act = self:GetStoneData()[4002]
  self.Tog_autoRecovery:SetActive(self:GetOpenByConditton(2210007) and not act)
  self.Tog_dropRate:SetActive(self:GetOpenByConditton(2210008) and (self.mySelfVipLevel == nil or self.mySelfVipLevel < self.maxVipLevel))
end

function Shop_ExpUpUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Shop_ExpUpUI.GetTimeReserveText(sec)
  local seconds = math.fmod(sec, 60)
  local min = math.floor(sec / 60)
  local hour = math.floor(min / 60)
  local day = math.floor(hour / 24)
  if 0 < day then
    return string.format("%s ng\195\160y", day)
  end
  return TimeUtility.ShowTimeReserveWithColon(sec)
end

function Shop_ExpUpUI:RefreshTime()
  local now = Time.GetServerSecondTime()
  local limitTime = ExpAddData.MultipleTimeStamp == nil and 0 or ExpAddData.MultipleTimeStamp
  local offset = math.floor(limitTime - now)
  self:SetDestroyTime()
  self.txt_time_tip:SetActive(false)
  self.txt_time:SetText(string.GetColorText("00:00:00", "#ff2323"))
  if 0 < offset then
    self.txt_time_tip:SetActive(true)
    local text = Shop_ExpUpUI.GetTimeReserveText(offset)
    self.txt_time:SetText(string.GetColorText(text, "#1add1f"))
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime2, self, self.txt_time)
  end
end

function Shop_ExpUpUI:RefreshTime2(lab_lastTime)
  local now = Time.GetServerSecondTime()
  local limitTime = ExpAddData.MultipleTimeStamp == nil and 0 or ExpAddData.MultipleTimeStamp
  local offset = math.floor(limitTime - now)
  if 0 < offset then
    local timeshow = Shop_ExpUpUI.GetTimeReserveText(offset)
    lab_lastTime:SetText(string.GetColorText(timeshow, "#1add1f"))
  else
    self:SetDestroyTime()
    lab_lastTime:SetText(string.GetColorText("00:00:00", "#ff2323"))
  end
end

function Shop_ExpUpUI:GetStoneData()
  return RoleManager.me.data.equipsData.StoneData
end

function Shop_ExpUpUI:RefreshData()
  self.mySelfVipLevel = CommercializeData.GetVvipRechargeLevel()
  self.VipData = RoleManager.me.data.equipsData.Data[CommercializeEquipCell.Vvip]
  self.autoPick = {}
  self.autoPickState = 1
  self.autoPickItemId = {2290015, 2290016}
  for i = 1, table.count(self.autoPickItemId) do
    local itemConfig = ClientTable.cfg_Item_equipManager:TryGetValue(self.autoPickItemId[i])
    table.insert(self.autoPick, itemConfig)
  end
  self.autoRecycle = {}
  self.autoRecycleState = 1
  self.autoRecycleGlobalTab = {}
  local autoRecycleGlobal = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2140002), "/")
  for k, v in pairs(autoRecycleGlobal) do
    table.insert(self.autoRecycleGlobalTab, tonumber(string.split(v, "#")[2]))
  end
  for i = 1, table.count(self.autoRecycleGlobalTab) do
    local itemConfig = ClientTable.cfg_Item_equipManager:TryGetValue(self.autoPickItemId[i])
    table.insert(self.autoRecycle, itemConfig)
  end
  self.goUpExplode = {}
  self.goUpExplodeState = 1
  self.goUpExplodeItemId = {
    2290010,
    2290011,
    2290012,
    2290013,
    2290014,
    2290015,
    2290016
  }
  for i = 1, table.count(self.goUpExplodeItemId) do
    local itemConfig = ClientTable.cfg_Item_equipManager:TryGetValue(self.goUpExplodeItemId[i])
    table.insert(self.goUpExplode, itemConfig)
  end
  self.goldRatio = {}
  self.goldRatioState = 1
  self.goldRatioItemId = {
    2290010,
    2290011,
    2290012,
    2290013,
    2290014,
    2290015,
    2290016
  }
  for i = 1, table.count(self.goldRatioItemId) do
    local itemConfig = ClientTable.cfg_Item_equipManager:TryGetValue(self.goldRatioItemId[i])
    table.insert(self.goldRatio, itemConfig)
  end
  self.MinGoLevelCountKey, self.MaxGoLevelCountKey = CommercializeData:GetgoLevelMaxandMinCountKey()
  self.goLevelCountKeyTbl = CommercializeData:GetgoLevelCountKey()
  self:RefreshGoLevelReward()
  self:Role_MyLvChanged()
end

function Shop_ExpUpUI:Tog_expUpOnChanged(control, eventData)
  self:RefreshTime()
  self.btn_open_serves:SetActive(self:GetOpenByConditton(2210002) and self:GetOpenActivePackage(4010501))
  self.btn_buy_gift:SetActive(self:GetOpenByConditton(2210003) and self:GetOpenActivePackage(4010301))
  self.btn_buy_now:SetActive(self:GetOpenByConditton(2210004))
  self.exp_right:SetActive(self:GetOpenByConditton(2210005))
  local showVipLevel, showVipGroup
  local isMax = false
  showVipLevel = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetNextMemberLevel()
  showVipGroup = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetNextLevelMemberGroup()
  if showVipLevel == 0 then
    showVipLevel = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberLevle()
    showVipGroup = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetCurMemberGroup()
  end
  local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(showVipLevel)
  self:SetSprite("Atlas_Language", memberTbl.showname, self.img_title)
  local exUp = math.floor(tonumber(memberTbl.monsterDropRate) / 100)
  local text = exUp .. "A"
  self.exp_right_img_right:SetText(text)
  if isMax then
    self.txt:SetText("\196\144\195\163 \196\145\225\186\167y c\225\186\165p")
  else
    self.txt:SetText("N\195\162ng c\225\186\165p")
  end
  self.btn_vip_level.showVipLevel = showVipLevel
  self.btn_vip_level.showVipGroup = showVipGroup
  self.go_ExpUpItemGroup:SetActive(eventData)
end

function Shop_ExpUpUI:GetOpenByConditton(id)
  local Tab = ClientTable.cfg_Function_functionManager:TryGetValue(id, "id").condition
  return ConditionManager.Check4D(Tab)
end

function Shop_ExpUpUI:Tog_expOpenPackage()
  UIManager.Show(UIID.CommercializationActivityUI, {openFirstTab = 100})
end

function Shop_ExpUpUI:GlobalTblBack()
  local globalTbl = ClientTable.cfg_Global_globalManager:TryGetValue(6030029)
  local index = tonumber(globalTbl.effect)
  return index
end

function Shop_ExpUpUI:Tog_expBuyPackage()
  if self.index == nil then
    self.index = self.GlobalTblBack()
  end
  UIManager.Show(UIID.RechargeWelfareUI, {
    openFirstTab = self.index
  })
end

function Shop_ExpUpUI:Tog_expVvip(control)
  gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():JumpMemberUIByGroup(control.showVipGroup)
end

function Shop_ExpUpUI:Tog_autoPickupOnChanged(control, eventData)
  for k, v in pairs(self.autoPick) do
    local vipCfg = ConfigManager.FindConfigs("cfg_Recharge_vvip", "id", v.id)
    if self.mySelfVipLevel == vipCfg[1].level then
      self.autoPickState = ActivatedState.activated
      break
    end
    self.autoPickState = ActivatedState.nonactivated
  end
  if self.mySelfVipLevel == self.maxVipLevel then
    self.autoPickState = ActivatedState.maxLevel
  end
  if self.autoPickState == ActivatedState.nonactivated then
  elseif self.autoPickState == ActivatedState.activated then
  elseif self.autoPickState == ActivatedState.maxLevel then
    self.btn_activeAutoPickup:SetActive(false)
  end
  self.go_AutoPickup:SetActive(eventData)
end

function Shop_ExpUpUI:Tog_autoRecoveryOnChanged(control, eventData)
  for k, v in pairs(self.autoRecycle) do
    local vipCfg = ConfigManager.FindConfigs("cfg_Recharge_vvip", "id", v.id)
    if self.mySelfVipLevel == vipCfg[1].level then
      self.autoRecycleState = ActivatedState.activated
      break
    end
    self.autoRecycleState = ActivatedState.nonactivated
  end
  if self.mySelfVipLevel == self.maxVipLevel then
    self.autoRecycleState = ActivatedState.maxLevel
  end
  if self.autoRecycleState == ActivatedState.nonactivated then
  elseif self.autoRecycleState == ActivatedState.activated then
  elseif self.autoRecycleState == ActivatedState.maxLevel then
    self.btn_activeAutoRecovery:SetActive(false)
  end
  self.go_AutoRecovery:SetActive(eventData)
end

function Shop_ExpUpUI:Tog_dropRateOnChanged(control, eventData)
  for k, v in pairs(self.goUpExplode) do
    local vipCfg = ConfigManager.FindConfigs("cfg_Recharge_vvip", "id", v.id)
    if self.mySelfVipLevel == vipCfg[1].level then
      self.goUpExplodeState = ActivatedState.activated
      break
    end
    self.goUpExplodeState = ActivatedState.nonactivated
  end
  if self.mySelfVipLevel == self.maxVipLevel then
    self.goUpExplodeState = ActivatedState.maxLevel
  end
  local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(6)
  local exUp = math.floor(memberTbl.monsterAttackPlayerDamageAbsorption / 100)
  local text = string.format(LocalizationUtility.GetUIWord("efficiency_go_DropRate"), exUp .. "%")
  if self.goUpExplodeState == ActivatedState.nonactivated then
    self.lab_activeDropRate:SetText("\196\144\225\186\191n k\195\173ch ho\225\186\161t")
  elseif self.goUpExplodeState == ActivatedState.activated then
    self.lab_activeDropRate:SetText("\196\144\225\186\191n k\195\173ch ho\225\186\161t")
  elseif self.goUpExplodeState == ActivatedState.maxLevel then
    self.btn_activeDropRate:SetActive(false)
  end
  self.lab_activeDropRateDes:SetText(text)
  self.go_DropRate:SetActive(eventData)
end

function Shop_ExpUpUI:Tog_pointGainOnChanged(control, eventData)
  self.go_PointGain:SetActive(eventData)
end

function Shop_ExpUpUI:Tog_moneyRecoveryOnChanged(control, eventData)
  for k, v in pairs(self.goldRatio) do
    local vipCfg = ConfigManager.FindConfigs("cfg_Recharge_vvip", "id", v.id)
    if self.mySelfVipLevel == vipCfg[1].level then
      self.goldRatioState = ActivatedState.activated
      break
    end
    self.goldRatioState = ActivatedState.nonactivated
  end
  if self.mySelfVipLevel == self.maxVipLevel then
    self.goldRatioState = ActivatedState.maxLevel
  end
  if self.goldRatioState == ActivatedState.nonactivated then
    self.lab_activeMoneyRecovery:SetText("\196\144\225\186\191n k\195\173ch ho\225\186\161t")
  elseif self.goldRatioState == ActivatedState.activated then
    self.lab_activeMoneyRecovery:SetText("\196\144\225\186\191n k\195\173ch ho\225\186\161t")
  elseif self.goldRatioState == ActivatedState.maxLevel then
    self.btn_activeMoneyRecovery:SetActive(false)
  end
  self.go_MoneyRecovery:SetActive(eventData)
end

function Shop_ExpUpUI:BuyItem(id)
  if id and id ~= 0 then
    NetManager.Send(ItemBuyMessage.ReqBuy, {goodId = id, buyCount = 1})
  else
    self:btn_closeBgOnClick()
    UIManager.Show(UIID.Recharge_VvipUI)
  end
end

function Shop_ExpUpUI:btn_activeAutoPickupOnClick(control)
  local global = ClientTable.cfg_Global_globalManager:TryGetValue(6030027)
  if global ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():JumpMemberUIByGroup(tonumber(global.effect))
  end
end

function Shop_ExpUpUI:btn_activeAutoRecoveryOnClick()
  local global = ClientTable.cfg_Global_globalManager:TryGetValue(6030027)
  if global ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():JumpMemberUIByGroup(tonumber(global.effect))
  end
end

function Shop_ExpUpUI:btn_activeDropRateOnClick()
end

function Shop_ExpUpUI:btn_activeMoneyRecoveryOnClick()
  local vipID
  if self.goldRatioState == ActivatedState.nonactivated then
    vipID = ClientTable.cfg_Recharge_vvipManager:TryGetValue(self.goldRatio[1].id)
  elseif self.goldRatioState == ActivatedState.maxLevel then
    vipID = self.mySelfVipLevel + 1
  end
  UIManager.Show(UIID.Recharge_VvipUI, {id = vipID})
  self:OpenVip(self.goldRatioState, self.goldRatio)
end

function Shop_ExpUpUI.IsFirstAllGift()
  local FirstChargeInfo = RechargeData.GetFirstChargeInfo()
  local giftCount = 0
  for i, v in pairs(RefreshData.TotalRefreshTbl) do
    if i >= FirstChargeInfo.FirstGetKey and i <= FirstChargeInfo.LastGetKey and 0 < v.count then
      giftCount = giftCount + 1
    end
  end
  if giftCount == 3 then
    return 3
  elseif giftCount == 2 then
    return 2
  elseif giftCount == 1 then
    return 1
  else
    return 0
  end
end

function Shop_ExpUpUI:btn_buyActiveAutoPickupOnClick()
  local config = ClientTable.cfg_Global_globalManager:TryGetValue(2520005)
  local id = tonumber(config.effect)
  UIManager.Show(UIID.Shop, {
    type = 3,
    subtype = 2,
    subPosition = id
  })
end

function Shop_ExpUpUI:btn_rechargeActiveAutoPickupOnClick()
  local config = ClientTable.cfg_Function_functionManager:TryGetValue(4010104, "id")
  local istrue = ConditionManager.Check4D(config.condition)
  if istrue or string.isNullOrEmpty(config.condition) then
    UIManager.Show(UIID.RechargeWelfareUI, {
      openFirstTab = 4,
      openSource = UIID.Shop_ExpUpUI,
      rechargeID = 100003
    })
  else
    FloatingTipUtility.QuickMsg("M\225\187\159 sau khi nh\225\186\173n th\198\176\225\187\159ng N\225\186\161p \196\144\225\186\167u")
  end
end

function Shop_ExpUpUI:btn_buyActiveAutoRecoveryOnClick()
  UIManager.Show(UIID.Shop, {
    type = 3,
    subtype = 2,
    subPosition = 30202
  })
end

function Shop_ExpUpUI:descBtnOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1111})
end

function Shop_ExpUpUI:btn_buy_nowOnClick(_, ctr)
  local config = ClientTable.cfg_Global_globalManager:TryGetValue(2520003)
  if not config then
    return
  end
  local configEffect = string.stringToNumberArray(config.effect, "#")
  local itemData = ItemUtility.GenerateItemData(configEffect[1])
  ShopData.CreatBuyItemInfo(configEffect[2])
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    openType = TipsOpenType.ShopOpen,
    rightOperate = EItemOperateType.Show
  })
end

function Shop_ExpUpUI:OpenVip(type, data)
  local vipLevel
  if type == ActivatedState.nonactivated then
    local id = data[1].id
    vipLevel = ConfigManager.FindConfigs("cfg_Recharge_vvip", "id", id)[1].level
  elseif type == ActivatedState.maxLevel then
    vipLevel = self.mySelfVipLevel + 1
  end
  UIManager.Hide(UIID.Shop_ExpUpUI)
  UIManager.Show(UIID.Recharge_VvipUI, {level = vipLevel})
end

function Shop_ExpUpUI:btn_getGiftOnClick()
  local actTab = self:GetGift(self.goLevelCountKey)
  if actTab == nil then
    print("cfg_Gift_gift\232\161\168\230\178\161\230\156\137G\195\179i Qu\195\160Key: " .. self.goLevelCountKey)
    return
  end
  local id = actTab.id
  local levelApart = math.floor(self:GetGiftApartLevel(self.goLevelCountKey))
  if levelApart <= 0 then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {id}
    })
  end
end

function Shop_ExpUpUI:Commer_goLevelReward(_, msg)
  self:RefreshGoLevelReward()
end

function Shop_ExpUpUI:Role_MyLvChanged(_, msg)
  local flag
  flag = self:GetOpenByConditton(2210010)
  self.btn_vip_level:SetActive(flag)
  self.txt_vip_level:SetActive(not flag)
  flag = self:GetOpenByConditton(2210011)
  self.btn_activeDropRate:SetActive(flag)
  self.lab_activeDropRateDes:SetActive(flag)
  self.txt_activeDropRate:SetActive(not flag)
end

function Shop_ExpUpUI:ClearEff()
  if self.effect ~= nil then
    self.effect:Destroy()
    self.effect = nil
  end
end

function Shop_ExpUpUI:RefreshGoLevelReward()
  local isOver = true
  for i = 1, table.count(self.goLevelCountKeyTbl) do
    local count = RechargeData.GetCount(self.goLevelCountKeyTbl[i])
    if count <= 0 then
      self.goLevelCountKey = self.goLevelCountKeyTbl[i]
      isOver = false
      break
    end
  end
  if not isOver then
    local itemCfg = CommercializeData:GetCountKeyItemCfg(self.goLevelCountKey)
    local itemId = itemCfg.itemId
    local itemCount = itemCfg.count
    local itemData = ItemUtility.GenerateItemData(itemId)
    itemData.count = itemCount
    self.itemCellData = ItemCellData()
    self.itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.level_Item, self.itemCellData, self, true)
    local levelApart = math.floor(self:GetGiftApartLevel(self.goLevelCountKey))
    if levelApart <= 0 then
      self.btn_getGift:SetActive(true)
      self.txt_level:SetText(0)
      if self.effect == nil then
        local effectInfo = GlobalConfig.GetGlobalConfig(2490006)
        if effectInfo ~= nil and effectInfo ~= "" then
          local effectList = string.split(effectInfo, "&")
          local scaleList = string.split(effectList[2], "#")
          self.effect = UIEffectUtility.SetUIEffect(effectList[1], self.level_Item, true, Vector3(scaleList[1], scaleList[2], scaleList[3]))
        end
      end
    else
      self.btn_getGift:SetActive(false)
      self.txt_level:SetText(levelApart)
      self:ClearEff()
    end
  end
  self.unfinished_Panel:SetActive(not isOver)
  self.lab_finish:SetActive(isOver)
end

function Shop_ExpUpUI:GetGift(countKey)
  return ConfigManager.FindConfigs("cfg_Gift_gift", "countKey", countKey)[1]
end

function Shop_ExpUpUI:GetGiftApartLevel(countKey)
  local Condition = ConfigManager.FindConfigs("cfg_Gift_gift", "countKey", countKey)[1].buyCondition
  local level = string.split(string.split(Condition, "&")[1], "#")[2]
  local ApartLevel = level - ViewData.meData.level
  return ApartLevel
end

function Shop_ExpUpUI:GetOpenActivePackage(id)
  local Total = RefreshData.TotalRefreshTbl
  if Total[id] and Total[id].count > 0 then
    return false
  end
  return true
end
