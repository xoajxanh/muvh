Task_EarlyGoldGameplay = class(BaseUI)
Task_EarlyGoldGameplay.layer = UILayer.Panel
Task_EarlyGoldGameplay.orderInLayer = 2
Task_EarlyGoldGameplay.hideType = UIHideType.WaitDestroy
Task_EarlyGoldGameplay.hideFunc = UIHideFunc.MoveOutOfScreen
Task_EarlyGoldGameplay.escClose = UIEscClose.DontClose

function Task_EarlyGoldGameplay:InitControls()
  self.tog_goldDragon = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent/tog_goldDragon")
  self.tog_InvAte = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent/tog_invate")
  self.tog_level = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent/tog_level")
  self.btn_close = self:GetControl("bg/btn_close")
  self.panel_goldDragon = self:GetControl("panel_goldDragon")
  self.Content = self:GetControl("panel_goldDragon/scroll_shop/Viewport/Content")
  self.go_item = self:GetControl("panel_goldDragon/scroll_shop/Viewport/Content/go_item")
  self.lab_lastTimeBossPre = self:GetControl("panel_goldDragon/lab_lastTimeBossPre")
  self.goldenTicket = self:GetControl("panel_goldDragon/goldenTicket_system/goldenTicket")
  self.panel_invite = self:GetControl("panel_invite")
  self.generateCode = self:GetControl("panel_invite/generateCode")
  self.lab_generateCode = self:GetControl("panel_invite/generateCode/code")
  self.lab_generateCodeNum = self:GetControl("panel_invite/generateCode/code/lab_exchangeNum")
  self.btn_generate = self:GetControl("panel_invite/generateCode/btn_generate")
  self.btn_generateCopy = self:GetControl("panel_invite/generateCode/btn_copy")
  self.inputCode = self:GetControl("panel_invite/inputCode")
  self.lab_inputCode = self:GetControl("panel_invite/inputCode/code")
  self.lab_inputCodeNum = self:GetControl("panel_invite/inputCode/code/lab_exchangeNum")
  self.btn_inputCopy = self:GetControl("panel_invite/inputCode/btn_copy")
  self.text_num = self:GetControl("panel_invite/inviteReward/text_num")
  self.inviteReward_Item = self:GetControl("panel_invite/inviteReward/ActualRewards/inviteReward_Item")
  self.txt_attention = self:GetControl("panel_invite/generateCode/txt_attention")
  self.panel_levelReward = self:GetControl("panel_levelReward")
  self.sw_SpiRtsRankList = self:GetControl("panel_levelReward/sw_spirtsrankList")
  self.sw_firstGift = self:GetControl("panel_levelReward/sw_firstGift")
  self.lab_server = self:GetControl("panel_levelReward/sw_firstGift/Viewport/Content/bg_firstGist/lab_server")
  self.lab_player = self:GetControl("panel_levelReward/sw_firstGift/Viewport/Content/bg_firstGist/lab_server/lab_player")
  self.lab_serverM = self:GetControl("panel_levelReward/sw_firstGift/Viewport/Content/bg_firstGist (1)/lab_server")
  self.lab_playerM = self:GetControl("panel_levelReward/sw_firstGift/Viewport/Content/bg_firstGist (1)/lab_server/lab_player")
  self.sw_welfareList = self:GetControl("panel_levelReward/sw_welfareList")
  self.tog_rechargeReward = self:GetControl("panel_levelReward/sw_welfareList/Viewport/Content/tog_rechargeReward")
  self.tog_prizeList = self:GetControl("panel_levelReward/sw_welfareList/Viewport/Content/tog_prizeList")
  self.img_daTaranKBg = self:GetControl("panel_levelReward/sw_spirtsrankList/Viewport/Content/img_datarankBg")
  self.lab_lastTimeLevelRank = self:GetControl("panel_levelReward/lab_lastTimeLevelrank")
  self.img_redPoint1 = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent/tog_goldDragon/img_redPoint")
  self.img_redPoint2 = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent/tog_invate/img_redPoint")
  self.img_redPoint3 = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent/tog_level/img_redPoint")
  self.btn_left = self:GetControl("btn_left")
  self.btn_right = self:GetControl("btn_right")
  self.image_title = self:GetControl("image_title")
  self.descBtnB = self:GetControl("descBtnB")
  self.btn_generateCopy:SetActive(false)
  self.sw_SpiRtsRankList:SetActive(true)
  self.sw_firstGift:SetActive(false)
end

function Task_EarlyGoldGameplay:Init()
end

function Task_EarlyGoldGameplay:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Task_EarlyGoldGameplay:InitUI()
  self.activeTable = {}
  self.activeTable[GoldenDragonRewardEnum.panel_goldDragon] = self.panel_goldDragon
  self.activeTable[GoldenDragonRewardEnum.panel_invite] = self.panel_invite
  self.activeTable[GoldenDragonRewardEnum.panel_levelReward] = self.panel_levelReward
  self.go_itemTemplate = UIUtility.BindUIContainerTemp(self.go_item, LuaComponentTemplates.Go_itemTemplate, self)
  self.goldenTicketTemplate = UIUtility.BindUIContainerTemp(self.goldenTicket, LuaComponentTemplates.GoldenTicketTemplate, self)
  self.inviteReward_ItemTemplate = UIUtility.BindUIContainerTemp(self.inviteReward_Item, LuaComponentTemplates.InviteReward_ItemTemplate, self)
  self.img_daTaranKBgTemplate = UIUtility.BindUIContainerTemp(self.img_daTaranKBg, LuaComponentTemplates.img_daTaranKBgTemplate, self)
end

function Task_EarlyGoldGameplay:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_goldDragon:SetOnToggleChanged(self, self.tog_goldDragOnClick)
  self.tog_InvAte:SetOnToggleChanged(self, self.tog_InvAteOnClick)
  self.tog_level:SetOnToggleChanged(self, self.tog_levelOnClick)
  self.btn_generate:SetOnClick(self, self.btn_generateOnClick)
  self.btn_generateCopy:SetOnClick(self, self.btn_generateCopyOnClick)
  self.btn_inputCopy:SetOnClick(self, self.btn_inputCopyOnClick)
  self.descBtnB:SetOnClick(self, self.descBtnBOnClick)
  self.tog_rechargeReward:SetOnToggleChanged(self, self.tog_rechargeRewardOnClick)
  self.tog_prizeList:SetOnToggleChanged(self, self.tog_prizeListOnClick)
end

function Task_EarlyGoldGameplay:tog_rechargeRewardOnClick(control, isOn)
  if isOn then
    self:SetLevelUpUI(true)
  end
end

function Task_EarlyGoldGameplay:tog_prizeListOnClick(control, isOn)
  if isOn then
    self:SetLevelUpUI(false)
  end
end

function Task_EarlyGoldGameplay:SetLevelUpUI(state)
  self.sw_SpiRtsRankList:SetActive(state)
  self.sw_firstGift:SetActive(not state)
end

function Task_EarlyGoldGameplay:descBtnBOnClick(control)
  if self.descriptionID ~= nil then
    UIManager.Show(UIID.System_DescUI, {
      id = self.descriptionID
    })
  end
end

function Task_EarlyGoldGameplay:btn_closeOnClick(control)
  UIManager.Hide(UIID.Task_EarlyGoldGameplay)
end

function Task_EarlyGoldGameplay:tog_goldDragOnClick(control, isOn)
  if isOn then
    self.descriptionID = 1146
    self:RefreshPanel(GoldenDragonRewardEnum.panel_goldDragon)
    local GoldenDragonReward = QuickFind:GetTask_EarlyGoldManager():GetGoldenDragonReward()
    local RewardingTickets = QuickFind:GetTask_EarlyGoldManager():GetRewardingTickets()
    table.sort(GoldenDragonReward, function(a, b)
      return a.taskId < b.taskId
    end)
    table.sort(RewardingTickets, function(a, b)
      return a.taskId < b.taskId
    end)
    if self.GoldenDragonReward and self.RewardingTickets then
      self.go_itemTemplate:SetData(GoldenDragonReward)
      self.goldenTicketTemplate:SetData(RewardingTickets)
    end
    self:RefreshRedPoint()
  end
end

function Task_EarlyGoldGameplay:tog_InvAteOnClick(control, isOn)
  if isOn then
    self.descriptionID = 1147
    self:RefreshPanel(GoldenDragonRewardEnum.panel_invite)
    local Invitation = QuickFind:GetTask_EarlyGoldManager():GetInvitationReward()
    self.inviteReward_ItemTemplate:SetData(Invitation)
    self:RefreshRedPoint()
  end
end

function Task_EarlyGoldGameplay:tog_levelOnClick(control, isOn)
  if isOn then
    self.descriptionID = 1148
    self:RefreshPanel(GoldenDragonRewardEnum.panel_levelReward)
    local LevelUp = QuickFind:GetTask_EarlyGoldManager():GetFullNameLevelUpData()
    self.img_daTaranKBgTemplate:SetData(LevelUp)
  end
end

function Task_EarlyGoldGameplay:btn_generateOnClick(control)
  networkRequest.ReqRoleCode()
end

function Task_EarlyGoldGameplay:btn_generateCopyOnClick(control)
  local data = QuickFind:GetTask_EarlyGoldManager():GetVerifyData()
  if data and data.code then
    CS.UnityEngine.GUIUtility.systemCopyBuffer = data.code
    FloatingTipUtility.QuickMsg("Sao ch\195\169p th\195\160nh c\195\180ng ")
  else
    FloatingTipUtility.QuickMsg("Sao ch\195\169p th\225\186\165t b\225\186\161i kh\195\180ng c\195\179 m\195\163 x\195\161c minh")
  end
end

function Task_EarlyGoldGameplay:btn_inputCopyOnClick(control)
  local txt = self.lab_inputCode:GetInputText()
  networkRequest.ReqRoleVerifyCode(txt)
end

function Task_EarlyGoldGameplay:RefreshPanel(index)
  for k, v in pairs(self.activeTable) do
    v:SetActive(false)
  end
  if self.activeTable[index] then
    self.activeTable[index]:SetActive(true)
  end
end

function Task_EarlyGoldGameplay:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Task_EarlyGoldGameplay:RegistEvents()
  self:RegistEvent(Event.RefreshFriendCode, self.RefreshFriendCode, self)
  self:RegistEvent(Event.GoldFarmingActivityRedDot, self.RefreshRedPoint, self)
  self:RegistEvent(Event.FullNameLevelUpRefresh, self.FullNameLevelUpRefresh, self)
end

function Task_EarlyGoldGameplay:Refresh()
  self.tog_goldDragon:SetIsOn(true)
  self:SetTog_levelBtn()
  self:tog_goldDragOnClick(nil, true)
  self:RefreshView()
  self:RefreshRedPoint()
  self:RefreshCountdown()
  self:RefreshLottery()
end

function Task_EarlyGoldGameplay:FullNameLevelUpRefresh()
  self:RefreshLottery()
end

function Task_EarlyGoldGameplay:SetTog_levelBtn()
  local func = ClientTable.cfg_Function_functionManager:TryGetValue(5100002).condition
  if func then
    self.tog_level:SetActive(ConditionManager.Check4D(func))
  end
  local time = LoginData.openServerDay
  local createTime = TimeUtility.GetCommercePlayerDay()
  if time and createTime and tonumber(time) - tonumber(createTime) >= 15 then
    self.tog_level:SetActive(false)
  end
  local create = LoginData.createTime
  self.global = string.split(ClientTable.cfg_Global_globalManager:TryGetValue(69000004).effect, "#")
  if create and self.global and create > tonumber(self.global[2]) then
    self.tog_level:SetActive(false)
  end
end

function Task_EarlyGoldGameplay:RefreshLottery()
  self.lab_server:SetText("")
  self.lab_player:SetText("")
  self.lab_serverM:SetText("")
  self.lab_playerM:SetText("")
  local lottery = QuickFind:GetTask_EarlyGoldManager():GetLotteryData()
  if lottery ~= nil and not string.isNullOrEmpty(lottery.result) then
    self.sw_welfareList:SetActive(true)
    local json = json.decode(lottery.result)
    for i, v in pairs(json) do
      if tonumber(v.giftType) == 46 then
        self.lab_server:SetText("S" .. v.serverId .. ":")
        self.lab_player:SetText(v.roleName)
      else
        self.lab_serverM:SetText("S" .. v.serverId .. ":")
        self.lab_playerM:SetText(v.roleName)
      end
    end
  else
    self.sw_welfareList:SetActive(false)
  end
end

function Task_EarlyGoldGameplay:RefreshCountdown()
  if self.matchTimeLoop then
    TimerBase.Stop(self.matchTimeLoop)
    self.matchTimeLoop = nil
  end
  local ONE_DAY_SEC = 86400
  local ONE_HOUR_SEC = 3600
  local TOTAL_DAYS = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(69000001).effect)
  local TOTAL_SEC = ONE_DAY_SEC * TOTAL_DAYS
  local createRoleSec = math.floor(LoginData.openServerTime / 1000)
  if not createRoleSec or createRoleSec <= 0 then
    self.lab_lastTimeLevelRank:SetText("Th\225\187\157i gian L\225\186\165y th\225\186\165t b\225\186\161i")
    return
  end
  local endSec
  if self.global then
    if createRoleSec < tonumber(self.global[1]) then
      endSec = createRoleSec + TOTAL_SEC
    else
      endSec = tonumber(self.global[2])
    end
  else
    endSec = createRoleSec + TOTAL_SEC
  end
  
  local function updateCountdown()
    local currentSec = Time.GetServerSecondTime()
    local remainingSec
    if currentSec < endSec then
      remainingSec = math.max(endSec - currentSec, 0)
    else
      return
    end
    local days = math.floor(remainingSec / ONE_DAY_SEC)
    local hours = math.floor(remainingSec % ONE_DAY_SEC / ONE_HOUR_SEC)
    hours = remainingSec <= 0 and 0 or hours
    local showText
    if remainingSec <= 0 then
      showText = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
      if self.matchTimeLoop then
        TimerBase.Stop(self.matchTimeLoop)
        self.matchTimeLoop = nil
      end
    elseif 0 < days then
      showText = string.format("C\195\178n:%sng\195\160y%sgi\225\187\157", days, hours)
    else
      showText = string.format("C\195\178n:%sgi\225\187\157", hours)
    end
    self.lab_lastTimeLevelRank:SetText(showText)
  end
  
  updateCountdown()
  self.matchTimeLoop = Timer.StartLoopForever(3600, updateCountdown)
end

function Task_EarlyGoldGameplay:RefreshRedPoint()
  self.GoldenDragonReward = QuickFind:GetTask_EarlyGoldManager():GetGoldenDragonReward()
  self.RewardingTickets = QuickFind:GetTask_EarlyGoldManager():GetRewardingTickets()
  local VerifyData = QuickFind:GetTask_EarlyGoldManager():GetVerifyData()
  self.LevelUp = QuickFind:GetTask_EarlyGoldManager():GetFullNameLevelUpData()
  local isOnGolden = false
  for i, v in pairs(self.GoldenDragonReward) do
    local a = false
    if tonumber(v.state) == 2 then
      a = true
    end
    if v.task ~= nil then
      if tonumber(v.task.state) == 2 then
        a = true
      else
        a = false
      end
    end
    isOnGolden = isOnGolden or a
  end
  for i, v in pairs(self.RewardingTickets) do
    local a = false
    if tonumber(v.state) == 2 then
      a = true
    end
    if v.task ~= nil then
      if tonumber(v.task.state) == 2 then
        a = true
      else
        a = false
      end
    end
    isOnGolden = isOnGolden or a
  end
  self.img_redPoint1:SetActive(isOnGolden)
  local isOnVerify = false
  if VerifyData and VerifyData.num ~= 0 then
    local a = false
    if tonumber(VerifyData.num) == 1 or tonumber(VerifyData.num) == 3 or tonumber(VerifyData.num) == 5 then
      a = true
    end
    isOnVerify = isOnVerify or a
  end
  self.img_redPoint2:SetActive(isOnVerify)
  local isOnLevelUp = false
  for i, v in pairs(self.LevelUp) do
    local a = false
    if v.ordinary and v.ordinary.buyCondition and ConditionManager.Check4D(v.ordinary.buyCondition) then
      local ordinaryState = QuickFind:GetTask_EarlyGoldManager():GetRefreshCountFun(v.ordinary)
      if ordinaryState then
        a = false
      else
        a = true
      end
    end
    isOnLevelUp = isOnLevelUp or a
    if v.advanced and v.advanced.buyCondition and ConditionManager.Check4D(v.advanced.buyCondition) then
      local advancedCount = QuickFind:GetTask_EarlyGoldManager():GetRefreshCountFun(v.advanced)
      local advancedServerCount = RefreshData.GetRefreshByKey(v.advanced.severCountKey)
      if advancedServerCount and advancedServerCount.total >= advancedServerCount.count then
        if advancedCount then
          a = false
        else
          a = true
        end
      else
        a = false
      end
    end
    isOnLevelUp = isOnLevelUp or a
  end
  self.img_redPoint3:SetActive(isOnLevelUp)
  self:ClearToggleTemplate()
end

function Task_EarlyGoldGameplay:ClearToggleTemplate()
  if type(self.img_daTaranKBgTemplate) == "table" and type(self.img_daTaranKBgTemplate.items) == "table" then
    local toggleTemplate
    for key, value in pairs(self.img_daTaranKBgTemplate.items) do
      toggleTemplate = value.itemTemp
      if toggleTemplate.RefreshCountKey ~= nil then
        toggleTemplate:RefreshCountKey()
      end
    end
  end
end

function Task_EarlyGoldGameplay:RefreshFriendCode(_, msg)
  if msg.VerifyData == nil then
    return
  end
  self.text_num:SetText(0)
  if msg.VerifyData and not string.isNullOrEmpty(msg.VerifyData.code) and msg.VerifyData.num ~= nil then
    self.lab_generateCodeNum:SetText(msg.VerifyData.code)
    self.text_num:SetText(msg.VerifyData.num)
    self.btn_generateCopy:SetActive(true)
  end
  if msg.VerifyData.isCode then
    FloatingTipUtility.QuickMsg("X\195\161c minh th\195\160nh c\195\180ng")
  end
  self:RefreshRedPoint()
end

function Task_EarlyGoldGameplay:RefreshView()
  self.btn_generate:SetInteractable(false)
  self.txt_attention:SetActive(true)
  local func = ClientTable.cfg_Function_functionManager:TryGetValue(5100001, "id")
  if ConditionManager.Check4D(func.condition) then
    self.btn_generate:SetInteractable(true)
    self.txt_attention:SetActive(false)
  end
  self.VerifyData = QuickFind:GetTask_EarlyGoldManager():GetVerifyData()
  self.text_num:SetText("")
  self.lab_generateCodeNum:SetText("")
  self.btn_generateCopy:SetActive(false)
  self.lab_inputCode:SetInputText("")
  if self.VerifyData and not string.isNullOrEmpty(self.VerifyData.code) and self.VerifyData.num ~= nil then
    self.lab_generateCodeNum:SetText(self.VerifyData.code)
    self.text_num:SetText(self.VerifyData.num)
    self.btn_generateCopy:SetActive(true)
  end
end

function Task_EarlyGoldGameplay:OnHide()
  if self.matchTimeLoop then
    Timer.Stop(self.matchTimeLoop)
    self.matchTimeLoop = nil
  end
end

function Task_EarlyGoldGameplay:OnDestroy()
end
