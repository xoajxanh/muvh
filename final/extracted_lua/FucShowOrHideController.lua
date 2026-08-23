require("GameConst/FunctionSystemEnum")
FucShowOrHideController = {}
local this = FucShowOrHideController
local uiFucShowTab = {}
local npcFucShowTab = {}
local uiNameTab = {}
local npcNameTab = {}
local uiFristFucShow = {}

function FucShowOrHideController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.FucDataInit()
end

function FucShowOrHideController.RegistMessages()
end

function FucShowOrHideController.RegistEvent()
  this.eventContainer:Regist(Event.Fuc_Refresh, this.FucAllRefresh)
  this.eventContainer:Regist(Event.Fuc_SingleRefresh, this.FucSingleRefresh)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnGamePlay_Leave)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnGamePlay_Leave)
end

function FucShowOrHideController.ResUnionInfoChange(id, msg)
end

function FucShowOrHideController.FucDataInit()
  local tempTab = ClientTable.cfg_Function_functionManager:GetDic()
  for k, v in pairs(tempTab) do
    if v.type == 1 then
      table.insert(uiFucShowTab, v)
      uiNameTab[v.route] = v.condition
    elseif v.type == 3 then
      npcNameTab[v.route] = v.condition
    end
  end
end

function FucShowOrHideController.FuncSystemIsOpen(funcId, useDissatisfyFunc)
  if type(funcId) ~= "number" then
    return false
  end
  local funcTbl = ClientTable.cfg_Function_functionManager:TryGetValue(funcId)
  if funcTbl == nil then
    return false
  end
  local stage = FucShowOrHideController.IsOpenJudge(funcTbl.condition, funcTbl.id, funcTbl.route)
  if stage == false and useDissatisfyFunc == true then
    ClientTable.cfg_Function_functionManager:UseDissatisfyFunc(funcId)
  end
  return stage
end

function FucShowOrHideController.IsOpenJudge(condition, id, route)
  local isShow = ConditionManager.Check4D(condition)
  if not isShow and table.count(ForgeData.equipFunction) > 0 and (id == EForgeDataEnum.Ornaments or id == EForgeDataEnum.Forge) and table.contains(ForgeData.equipFunction, EForgeDataEnum.Ornaments) then
    isShow = true
  end
  if not isShow and table.count(ForgeData.equipFunction) > 0 and (id == EForgeDataEnum.Forge or id == EForgeDataEnum.Transfer or id == EForgeDataEnum.Intensify) and table.contains(ForgeData.equipFunction, EForgeDataEnum.Intensify) then
    isShow = true
  end
  if id == FunctionSystemEnumId.BingJian then
    isShow = isShow and false
  end
  if route == "Main_MainMenuUI#btn_firstCharge" and isShow then
    this.FucFirstShow(route, id)
    isShow = this.IsFirstChargeGetAllGift()
  elseif route == "Main_MainMenuUI#btn_TianKong" and isShow then
    isShow = CommercializeData.SkyPaviMainBtn
  elseif route == "Recharge_WelfareUI#tog_everyDayRechang" and isShow then
    this.FucFirstShow(route, id)
  elseif route == "Recharge_WelfareUI#tog_prizeList" and isShow then
    this.FucFirstShow(route, id)
  elseif route == "Main_MainMenuUI#btn_TaskSchool" then
    if isShow then
      local Schoolinfo = TaskData.instituteMiracleTasks
      if #Schoolinfo == 0 then
        isShow = false
      else
        this.FucFirstShow(route, id)
      end
    end
    local uiTab = string.split(route, "#")
    local parentUI = UIManager.GetUiByName(uiTab[1])
    if parentUI and parentUI[uiTab[2]] and parentUI[uiTab[2]].gameObject.activeSelf ~= isShow then
      EventManager.Dispatch(Event.TaskBtn_indentation, {TaskSchool = isShow})
    end
  elseif route == "Main_MainMenuUI#btn_auctoin" and isShow then
    this.FucFirstShow(route, id)
  elseif route == "Main_MainMenuUI#btn_onHook" and isShow then
    return OnHookData.IsHasOffLineData()
  elseif id == 2210009 and isShow then
    this.FucFirstShow(route, id)
  elseif id == 4010107 and isShow then
    return CommercializeData:CheckLimitBuyFunc()
  elseif id == 8000004 and isShow then
    return not RefreshData.GetRefreshByKey(2444001)
  elseif id == 8000005 and isShow then
    return not RefreshData.GetRefreshByKey(2444002)
  elseif id == 3000001 and isShow then
    this.FucFirstShow(route, id)
  elseif id == 3000101 and isShow then
    this.FucFirstShow(route, id)
  elseif id == 3000103 and isShow then
    this.FucFirstShow(route, id)
  elseif id == 3000201 and isShow then
    this.FucFirstShow(route, id)
  elseif id == 4180005 and isShow then
    return SmallGameData.IsSupportedWebView()
  elseif id == 4010601 and isShow then
    networkRequest.ReqLuckTurntable(0)
    return isShow
  elseif id == 3000401 and isShow then
    this.FucFirstShow(route, id)
  elseif id == 4010111 and isShow then
    return RechargeData.GoldDiamondRechargeData.IsReceivedAwardAlready()
  end
  return isShow
end

function FucShowOrHideController.FucAllRefresh()
  for i = 1, table.count(uiFucShowTab) do
    local isShow = this.IsOpenJudge(uiFucShowTab[i].condition, uiFucShowTab[i].id, uiFucShowTab[i].route)
    this.ShowOrHideFucUI(uiFucShowTab[i].route, isShow)
  end
  EventManager.Dispatch(Event.MainBtnPosRefresh)
end

function FucShowOrHideController.FucFirstShow(uiName, id)
  if not uiFristFucShow[id] then
    uiFristFucShow[id] = uiName
    EventManager.Dispatch(Event.Fuc_FirstShow, id)
  end
end

function FucShowOrHideController.FucSingleRefresh(_, data)
  if not data then
    return
  end
  local isContain = false
  for _, id in pairs(data) do
    local cfg = ConfigManager.FindConfigs("cfg_Function_function", "id", id)
    if not cfg or not cfg[1] then
      logError("L\225\187\151i id l\195\160m m\225\187\155i fuc")
      return
    end
    local isShow = this.IsOpenJudge(cfg[1].condition, cfg[1].id, cfg[1].route)
    this.ShowOrHideFucUI(cfg[1].route, isShow)
    if not isContain and string.contains(cfg[1].route, "Main_MainMenuUI") then
      isContain = true
    end
  end
  if isContain then
    EventManager.Dispatch(Event.MainBtnPosRefresh)
  end
end

function FucShowOrHideController.ShowOrHideFucUI(uiName, isShow)
  local uiTab = string.split(uiName, "#")
  local parentUI = UIManager.GetUiByName(uiTab[1])
  if parentUI and parentUI[uiTab[2]] then
    parentUI[uiTab[2]]:SetActive(isShow)
  elseif parentUI and parentUI.SetCloneTransActive then
    parentUI.SetCloneTransActive(uiTab[2], isShow)
  end
end

function FucShowOrHideController.IsShowFucUI(uiName)
  if npcNameTab[uiName] ~= nil then
    return ConditionManager.Check4D(npcNameTab[uiName])
  end
  return true
end

function FucShowOrHideController.IsFuncButtonShow(uiName)
  if uiNameTab[uiName] ~= nil then
    local isShow = ConditionManager.Check4D(uiNameTab[uiName])
    if not isShow and table.count(ForgeData.equipFunction) > 0 and (uiName == "Equip_ForgeNavUi#tog_ornaments" or uiName == "Main_MainMenuUI#btn_forgeNav") and table.contains(ForgeData.equipFunction, EForgeDataEnum.Ornaments) then
      isShow = true
    end
    if not isShow and table.count(ForgeData.equipFunction) > 0 and (uiName == "Equip_ForgeNavUi#tog_intensify" or uiName == "Equip_ForgeNavUi#tog_zhuanyi" or uiName == "Main_MainMenuUI#btn_forgeNav") and table.contains(ForgeData.equipFunction, EForgeDataEnum.Intensify) then
      isShow = true
    end
    return isShow
  end
  return true
end

function FucShowOrHideController.IsFirstChargeGetAllGift()
  local FirstChargeInfo = RechargeData.GetFirstChargeInfo()
  local giftCount = 0
  for i, v in pairs(RefreshData.TotalRefreshTbl) do
    if i >= FirstChargeInfo.FirstGetKey and i <= FirstChargeInfo.LastGetKey and 0 < v.count then
      giftCount = giftCount + 1
    end
  end
  if giftCount == 3 then
    return false
  else
    return true
  end
end

function FucShowOrHideController.IsZeroRefreshFun()
  local function redDelayFun()
    Coroutine.Wait(1)
    
    for i, v in pairs(uiFucShowTab) do
      if v.update == 1 then
        this.FucSingleRefresh(_, {
          v.id
        })
      end
    end
  end
  
  Coroutine.Start(redDelayFun, this)
end

function FucShowOrHideController.OnGamePlay_Leave()
  uiFristFucShow = {}
end
