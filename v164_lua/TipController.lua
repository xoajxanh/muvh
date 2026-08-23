require("GameConst/TipEnum")
TipController = {}
local this = TipController

function TipController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.OpenTip()
end

function TipController.OpenTip()
  this.RegistMessages()
end

function TipController.CloseTip()
  this.messageContainer:UnRegistAll()
end

local timerCol

function TipController.RegistMessages()
  this.messageContainer:Regist(TipMessage.ResPrompt, this.OnResPrompt)
  this.messageContainer:Regist(TipMessage.ResUIBubble, this.OnResUIBubble)
  this.messageContainer:Regist(TipMessage.ResLoginError, this.OnResLoginError)
end

function TipController.OnResPrompt(id, data)
  local code = data.code
  local wordConfig = ClientTable.cfg_Ui_word_serverManager:TryGetValue(code, "code")
  if wordConfig and wordConfig.displayType == 2 then
    logPurple(data.msg)
    return
  end
  if code == 2340031 then
    EventManager.Dispatch(Event.Commer_SetOpenserReqinfo)
  end
  if wordConfig == nil or wordConfig.tipsType == TipSerType.TipFloatText then
    if not string.isNullOrEmpty(data.msg) then
      FloatingWordUtility.QuickMsg(data.msg)
    end
  elseif wordConfig.tipsType == TipSerType.TipWindow then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = data.msg,
      cancelText = "",
      okText = "",
      cancel = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      ok = function()
        UIManager.Hide(UIID.PromptTipUI)
      end
    })
  elseif wordConfig.tipsType == TipSerType.TipBubbles then
    local worddata = {
      uiName = wordConfig.uiName,
      uiAddress = wordConfig.uiAddress
    }
    FloatingWordUtility.GetParentBtnMsg(data.msg, worddata)
  elseif wordConfig.tipsType == TipSerType.TipBreathing then
    UIManager.Show(UIID.TipBreathing, {
      text = data.msg
    })
  elseif wordConfig.tipsType == TipSerType.TipCentered then
    FloatingTipUtility.QuickMsg(data.msg)
  elseif wordConfig.tipsType == TipSerType.TipRadioButton then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = data.msg,
      cancelText = "",
      okText = "",
      isframe = true,
      cancel = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      ok = function()
        UIManager.Hide(UIID.PromptTipUI)
      end
    })
  end
  if data.type == TipType.Reward then
    if data.actionCode == RewardTipServerActionType.Combine or data.actionCode == RewardTipServerActionType.Recycle and not UIManager.IsVisible(UIID.BagSellInfoUI) then
      return
    end
    local allRewards = {}
    for k, v in pairs(data.items) do
      local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(v.itemId)
      if itemConfig and itemConfig.subType ~= 301 then
        local itemData = ItemUtility.GenerateItemData(v.itemId)
        itemData.count = v.count
        table.insert(allRewards, itemData)
      end
    end
    UIManager.Show(UIID.Tip_RewardTipUI, {
      rewards = allRewards,
      type = data.actionCode
    })
  elseif data.type == TipType.RechargeBuySuccessTip then
    local allRewards = {}
    for k, v in pairs(data.items) do
      local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(v.itemId)
      if itemConfig and itemConfig.subType ~= 301 then
        local itemData = ItemUtility.GenerateItemData(v.itemId)
        itemData.count = v.count
        table.insert(allRewards, itemData)
      end
    end
    if table.count(allRewards) > 0 then
      UIManager.Show(UIID.Tip_KoreaBuyItemTipUI, {
        rewards = allRewards,
        code = data.actionCode or 0
      })
    end
  end
  if data.timeout and data then
    if timerCol then
      Timer.Stop(timerCol)
      timerCol = nil
    end
    local global = ClientTable.cfg_Global_globalManager:TryGetValue(66001001, "id")
    if global then
      local nums = string.splitToNumbers(global.effect)
      if nums[1] == data.timeout then
        this.ShowTipPrompt(128)
      elseif nums[2] == data.timeout then
        this.ShowTipPrompt(129)
      end
    end
  end
end

function TipController.ShowTipPrompt(id)
  if id == 129 then
    timerCol = Timer.Start(10, function()
      networkRequest.ReqLogout(ELogoutType.LogOut)
    end)
  end
  local tempCfg = ClientTable.cfg_Ui_promptwordManager:TryGetValue(id)
  if tempCfg == nil or tempCfg.title == nil or tempCfg.content == nil or tempCfg.rightButton == nil then
    return
  end
  UIManager.Show(UIID.PromptTipUI, {
    title = tempCfg.title,
    textContent = tempCfg.content,
    okText = tempCfg.rightButton,
    isframe = true,
    ok = function()
      if id == 129 then
        networkRequest.ReqLogout(ELogoutType.LogOut)
      end
    end
  })
end

function TipController.OnResUIBubble(id, msg)
  logPurple("Hi\225\187\131n th\225\187\139 Bong B\195\179ng", msg)
end

function TipController.OnResLoginError(id, msg)
  logPurple("L\225\187\151i \196\145\196\131ng nh\225\186\173p", msg)
end

TipController.Init()
