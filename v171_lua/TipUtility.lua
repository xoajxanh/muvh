TipUtility = {}
local this = TipUtility
this.IsOpenCombineUI = true

function TipUtility.QuickShowPrompt(commonData)
  if commonData == nil or type(commonData.id) ~= "number" then
    return false
  end
  local tblData = ClientTable.cfg_Ui_promptwordManager:TryGetValue(commonData.id)
  if tblData == nil then
    return false
  end
  local tipTbl = {}
  tipTbl.title = tblData.title
  if commonData.id == 65 then
    local jobColors = {
      ItemQuality2ColorDic[12],
      ItemQuality2ColorDic[26],
      ItemQuality2ColorDic[25],
      ItemQuality2ColorDic[0],
      ItemQuality2ColorDic[12]
    }
    local nowJob, changeJob
    if commonData.contentFormatArgs[4] and commonData.contentFormatArgs[5] then
      nowJob = jobColors[commonData.contentFormatArgs[4] - 1]
      nowJob = string.format("<color=%s>%s</color>", nowJob, "%s")
      changeJob = jobColors[commonData.contentFormatArgs[5] - 1]
      changeJob = string.format("<color=%s>%s</color>", changeJob, "%s")
    end
    nowJob = string.format(nowJob, commonData.contentFormatArgs[2])
    changeJob = string.format(changeJob, commonData.contentFormatArgs[3])
    tipTbl.textContent = string.format(tblData.content, commonData.contentFormatArgs[1], nowJob, changeJob)
  elseif commonData.id == 97 and commonData.itemId then
    local des = ZoomSecretRealmManager:GetUseItemTransferDefenseDes(commonData.itemId)
    tipTbl.textContent = string.isNullOrEmpty(des) and tblData.content or string.format(tblData.content, des)
  else
    tipTbl.textContent = commonData.contentFormatArgs and string.format(tblData.content, commonData.contentFormatArgs) or tblData.content
  end
  tipTbl.cancelText = tblData.leftButton
  tipTbl.okText = tblData.rightButton
  tipTbl.okDecs = tblData.rightButtonTips
  tipTbl.cancel = commonData.cancelAction or TipUtility.GetSingleFuncByParamsByButtonType(tblData, PromptWordButtonType.LeftButton, tipTbl.cancelArgs)
  tipTbl.ok = commonData.okAction or TipUtility.GetSingleFuncByParamsByButtonType(tblData, PromptWordButtonType.RightButton, commonData.okArgs)
  tipTbl.okArgs = commonData.okArgs
  tipTbl.cancelArgs = commonData.cancelArgs
  tipTbl.cancelBtnColor = tblData.leftButtonSprite
  tipTbl.okBtnColor = tblData.rightButtonSprite
  tipTbl.onlyOnce = commonData.onlyOnce
  tipTbl.onlyOnceArgs = commonData.onlyOnceArgs
  tipTbl.onlyOnceAction = commonData.onlyOnceAction
  tipTbl.closeArgs = commonData.closeArgs
  tipTbl.closeCallBack = commonData.closeCallBack
  tipTbl.showTimeType = commonData.showTimeType
  tipTbl.isLinkText = commonData.isLinkText
  tipTbl.link = commonData.link
  tipTbl.autoClose = commonData.autoClose
  tipTbl.listenEventID = commonData.listenEventID
  tipTbl.refreshCallBack = commonData.refreshCallBack
  tipTbl.tblData = tblData
  tipTbl.isframe = commonData.isframe
  if UIManager.IsVisible(UIID.PromptTipUI) then
    EventManager.Dispatch(Event.PromptOnRefresh, tipTbl)
  else
    UIManager.Show(UIID.PromptTipUI, tipTbl)
  end
end

function TipUtility.GetSingleFuncByParamsByButtonType(promptWordTbl, buttonType, args)
  if promptWordTbl == nil or type(buttonType) ~= "number" then
    return
  end
  local condition, buttonParams
  condition = buttonType == PromptWordButtonType.LeftButton and promptWordTbl.condition1 or buttonType == PromptWordButtonType.RightButton and promptWordTbl.condition2
  if string.isNullOrEmpty(condition) then
    condition = ""
  end
  local conditionResult = ConditionManager.Check4D(condition)
  if buttonType == PromptWordButtonType.LeftButton then
    buttonParams = conditionResult and promptWordTbl.leftButtonEvent2 or promptWordTbl.leftButtonEvent1
  elseif buttonType == PromptWordButtonType.RightButton then
    buttonParams = conditionResult and promptWordTbl.rightButtonEvent2 or promptWordTbl.rightButtonEvent1
  end
  if string.isNullOrEmpty(buttonParams) then
    return
  end
  return TipUtility.GetSingleFuncByParams(buttonParams, args)
end

function TipUtility.GetSingleFuncByParams(params, args)
  if string.isNullOrEmpty(params) then
    return
  end
  local paramsTbl = string.split(params, "#")
  if type(paramsTbl) ~= "table" or table.count(paramsTbl) < 2 then
    return
  end
  local curType = tonumber(paramsTbl[1])
  local curParam = tonumber(paramsTbl[2])
  local callBack
  if curType == PromptButtonFuncType.Transfer then
    function callBack()
      PathFinderManager.FlyTransferScene(curParam)
    end
  elseif curType == PromptButtonFuncType.Navigation then
    function callBack()
      local navigation_BarTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(curParam)
      
      if type(navigation_BarTbl) == "table" then
        NavigationUtility.ClickNavigation(navigation_BarTbl)
      end
    end
  elseif curType == PromptButtonFuncType.ShowFloatTips then
    function callBack()
      local str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(paramsTbl[2])
      
      FloatingTipUtility.QuickMsg(str)
    end
  elseif curType == PromptButtonFuncType.FindNpc and args and table.count(args) > 0 then
    function callBack()
      PathFinderManager.FlyTransferScene(args.transferId, nil, {
        npcId = args.npcId,
        
        itemId = args.itemId
      }, args.npcId ~= nil and args.npcId ~= 0 and Purpose.ClickNpc or Purpose.None)
    end
  end
  return callBack
end

function TipUtility.ShowPrompt(titleKey, contentKey, contentCfgName, cancelTextKey, okTextKey, cancelAction, okAction, okArgs, cancelArgs, okDecs, cancelBtnColor, okBtnColor)
  local tipTbl = {}
  tipTbl.title = LocalizationUtility.GetContentByKey(titleKey)
  tipTbl.textContent = LocalizationUtility.GetContentByKey(contentKey, contentCfgName)
  tipTbl.cancelText = LocalizationUtility.GetContentByKey(cancelTextKey)
  tipTbl.okText = LocalizationUtility.GetContentByKey(okTextKey)
  tipTbl.okDecs = LocalizationUtility.GetContentByKey(okDecs)
  tipTbl.cancel = cancelAction
  tipTbl.ok = okAction
  tipTbl.okArgs = okArgs
  tipTbl.cancelArgs = cancelArgs
  tipTbl.cancelBtnColor = cancelBtnColor
  tipTbl.okBtnColor = okBtnColor
  if UIManager.IsVisible(UIID.PromptTipUI) then
    EventManager.Dispatch(Event.PromptOnRefresh, tipTbl)
  else
    UIManager.Show(UIID.PromptTipUI, tipTbl)
  end
end

function TipUtility.ShowPP(str)
  UIManager.Show(UIID.PromptTipUI, {
    tile = "Nh\225\186\175c nh\225\187\159",
    textContent = str
  })
end

function TipUtility.CloseOnClick()
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.NewBagInfoUI)
end

function TipUtility.ShowSellOpenPrompt()
  TipUtility.ShowPrompt("tishi", "sellNoVip", "cfg_ui_word", "SellNoVip_1", "SellNoVip_2", function()
    UIManager.UICloseType(UIPanelType.SortAndHide, true)
    PathFinderManager.FlyTransferScene(PlayerControlForceData.sellJumpParam[1], nil, {
      npcId = PlayerControlForceData.sellJumpParam[2]
    }, Purpose.ClickNpc)
  end, function()
    UIManager.JumpShow(UIPanelType.SortAndHide, PlayerControlForceData.sellVipOpenParam[1], {
      type = PlayerControlForceData.sellVipOpenParam[2]
    })
  end)
end

function TipUtility.OpenAutoSellOk()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  this.CloseOnClick()
  ItemUtility.JumpRechargeOrShop(UIPanelType.SortAndHide, PlayerControlForceData.autoRecycleOpenParam[1], {
    type = tonumber(PlayerControlForceData.autoRecycleOpenParam[2]),
    buyid = tonumber(PlayerControlForceData.autoRecycleOpenParam[3])
  }, BusinessPayType.Recycle_Gold)
end

function TipUtility.ShowAutoSellOpenPrompt()
  local contentKey = ItemUtility.IsJumpRecharge() and "SellAuto" or "SellAuto_2"
  TipUtility.ShowPrompt("tishi", contentKey, "cfg_ui_word", "", "", nil, this.OpenAutoSellOk)
end

function TipUtility.OpenAutoPickupOk()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  this.CloseOnClick()
  ItemUtility.JumpRechargeUIIntercept(UIPanelType.SortAndHide, PlayerControlForceData.autoPickupOpenParam[1], {
    type = tonumber(PlayerControlForceData.autoPickupOpenParam[2]),
    buyid = tonumber(PlayerControlForceData.autoPickupOpenParam[3])
  }, BusinessPayType.Recycle_Gold)
end

function TipUtility.ShowAutoPickupOpenPrompt()
  local ShowUITxt = RechargeData:NeedGotoFirstChargeUI(BusinessPayType.Shop_Silver, false)
  local contentKey = ShowUITxt and "SellAuto_5" or ItemUtility.IsJumpRecharge() and "SellAuto_3" or "SellAuto_4"
  TipUtility.ShowPrompt("tishi", contentKey, "cfg_ui_word", "", "", nil, this.OpenAutoPickupOk)
end

function TipUtility.OpenStorageCancel()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  PathFinderManager.FlyTransferScene(PlayerControlForceData.storageJumpParam[1], nil, {
    npcId = PlayerControlForceData.storageJumpParam[2]
  }, Purpose.ClickNpc)
end

function TipUtility.OpenStorageOk()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  this.CloseOnClick()
  ItemUtility.JumpRechargeOrShop(UIPanelType.SortAndHide, PlayerControlForceData.storageVipOpenParam[1], {
    type = tonumber(PlayerControlForceData.storageVipOpenParam[2]),
    buyid = tonumber(PlayerControlForceData.storageVipOpenParam[3])
  }, BusinessPayType.Depot_Gold)
end

function TipUtility.ShowStorageOpenPrompt()
  local contentKey = ItemUtility.IsJumpRecharge() and "WarehouseNoVip_mini" or "WarehouseNoVip_mini2"
  TipUtility.ShowPrompt("tishi", "WarehouseNoVip", "cfg_ui_word", "SellNoVip_white", "SellNoVip_4", this.OpenStorageCancel, this.OpenStorageOk, nil, nil, contentKey, "ty_btn_short3_new", "ty_btn_short3_new")
end

function TipUtility.OpenComposeCancel()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  PathFinderManager.FlyTransferScene(PlayerControlForceData.composeJumpParam[1], nil, {
    npcId = PlayerControlForceData.composeJumpParam[2]
  }, Purpose.ClickNpc)
end

function TipUtility.OpenComposeOk()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  this.CloseOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, PlayerControlForceData.composeOpenParam[1], {
    type = PlayerControlForceData.composeOpenParam[2]
  })
end

function TipUtility.ShowComposeOpenPrompt()
  TipUtility.ShowPrompt("tishi", "CombineNoVip", "cfg_ui_word", "SellNoVip_1", "SellNoVip_2", this.OpenComposeCancel, this.OpenComposeOk)
end

function TipUtility.OpenShopCancel()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  PathFinderManager.FlyTransferScene(PlayerControlForceData.shopJumpParam[1], nil, {
    npcId = PlayerControlForceData.shopJumpParam[2]
  }, Purpose.ClickNpc)
end

function TipUtility.OpenShopOk()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  this.CloseOnClick()
  ItemUtility.JumpRechargeUIIntercept(UIPanelType.SortAndHide, PlayerControlForceData.shopVipOpenParam[1], {
    type = tonumber(PlayerControlForceData.shopVipOpenParam[2]),
    buyid = tonumber(PlayerControlForceData.shopVipOpenParam[3])
  }, BusinessPayType.Shop_Silver)
end

function TipUtility.ShowShopOpenPrompt()
  local ShowUITxt = RechargeData:NeedGotoFirstChargeUI(BusinessPayType.Shop_Silver, false)
  local Text = ShowUITxt and "shopNoVip_mini" or "shopNoVip_mini2"
  TipUtility.ShowPrompt("tishi", "ShopNoVip", "cfg_ui_word", "SellNoVip_white", "SellNoVip_3", this.OpenShopCancel, this.OpenShopOk, nil, nil, Text, "ty_btn_short3_new", "ty_btn_short3_new")
end

function TipUtility.OpenCombineCancel()
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  PathFinderManager.FlyTransferScene(PlayerControlForceData.composeJumpParam[1], nil, {
    npcId = PlayerControlForceData.composeJumpParam[2]
  }, Purpose.ClickNpc)
end

function TipUtility.ShowCombineOpenPrompt()
  TipUtility.ShowPrompt("tishi", "sellNoVip", "cfg_ui_word", "quxiao", "SellNoVip_1", nil, this.OpenCombineCancel)
end

function TipUtility.GetSessionTips()
  if CS.MuInterface.Instance ~= nil and CS.MuInterface.Instance.GetSession ~= nil then
    CS.MuInterface.Instance:GetSession()
  end
end

function TipUtility.ShowQuickGetTipPanel(itemId)
  local temp = {}
  temp.itemData = ItemUtility.GenerateItemData(itemId)
  UIManager.Show(UIID.ItemTipUI, {
    item = temp.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = temp,
    ShowObtain = true
  })
end

function TipUtility.ShowTipEffect(tipEffectParam)
  if type(tipEffectParam) ~= "table" then
    return
  end
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, tipEffectParam)
  else
    UIManager.Show(UIID.EffectTipUI, tipEffectParam)
  end
end

function TipUtility.ShowTextInputPanel(inputPanelParams)
  UIManager.Show(UIID.Tip_LeagueSiegeReportTipUI, inputPanelParams)
end

function TipUtility.ShowReviveCountDown(param)
  if UIManager.IsVisible(UIID.CountDown) then
    local ui = UIManager.GetUiByName(UIID.CountDown)
    ui.args = param
    ui:OnShow()
  else
    UIManager.Show(UIID.CountDown, param)
  end
end

function TipUtility.ShowTextCountDown(param)
  if UIManager.IsVisible(UIID.TextCountDown) then
    local ui = UIManager.GetUiByName(UIID.TextCountDown)
    ui.args = param
    ui:OnShow()
  else
    UIManager.Show(UIID.TextCountDown, param)
  end
end

function TipUtility.ShowActivityExchangeTip(id, playerPrefs, okCallBack)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    TipUtility.QuickShowPrompt({
      id = id,
      onlyOnce = true,
      onlyOnceArgs = nil,
      onlyOnceAction = function(args, isOn)
        PlayerPrefs.SetInt(playerPrefs, isOn and Time.GetServerSecondTime() or 0)
      end,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
        if okCallBack then
          okCallBack()
        end
      end
    })
  elseif okCallBack then
    okCallBack()
  end
end
