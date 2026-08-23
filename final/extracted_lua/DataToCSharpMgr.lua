DataToCSharpMgr = {}
local this = DataToCSharpMgr

function DataToCSharpMgr.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistMessages()
end

function DataToCSharpMgr:OnEnterGame()
end

function DataToCSharpMgr:OnLeaveGame()
  this.UnRegistMessages()
end

function DataToCSharpMgr.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLoginUser, this.OnResLoginUser, nil, 2)
  this.messageContainer:Regist(RoleMessage.ResPlayerLevelChange, this.OnPlayerLevelChange, nil, 2)
  this.eventContainer:Regist(Event.Login_CreateRole, this.OnResCreateRole)
end

function DataToCSharpMgr.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function DataToCSharpMgr.OnResLoginUser()
  this.SubmitGameData(ESubmitDataType.TYPE_SELECT_SERVER)
end

function DataToCSharpMgr.OnResLoginMap(id, msg)
  this.SubmitGameData(ESubmitDataType.TYPE_ENTER_GAME)
end

function DataToCSharpMgr.OnResCreateRole()
  this.SubmitGameData(ESubmitDataType.TYPE_CREATE_ROLE)
  this.SubmitGameData(ESubmitDataType.TYPE_LEVEL_UP)
end

function DataToCSharpMgr.OnPlayerLevelChange()
  this.SubmitGameData(ESubmitDataType.TYPE_LEVEL_UP)
end

function DataToCSharpMgr.GetExtraGameData(submitType)
  local gameData = CS.ExtraGameData()
  gameData.dataType = submitType
  gameData.userID = tostring(LoginData.sdkUserId)
  gameData.roleName = LoginData.roleName
  gameData.monyNum = BagInfoData.CoinInfos[ECoinsType.gold]
  gameData.roleID = LoginData.roleId
  gameData.serverID = LoginData.serverId
  gameData.serverName = LoginData.GetServerName()
  if ViewData.meData and LoginData.InGame then
    gameData.professionID = ViewData.meData.career
    gameData.gangID = ViewData.meData.unionId
    gameData.roleLevel = ViewData.meData.level
    gameData.gangName = ViewData.meData.unionName
  else
    gameData.roleLevel = LoginData.roleLevel
  end
  gameData.gender = "Nam"
  gameData.loginTime = LoginData.time
  gameData.createRoleTime = LoginData.createTime
  return gameData
end

function DataToCSharpMgr.SubmitGameData(submitType)
  local gameData = DataToCSharpMgr.GetExtraGameData(submitType)
  CS.MuInterface.Instance:SubmitGameData(gameData)
end

function DataToCSharpMgr.HelpServer()
  local gameData = DataToCSharpMgr.GetExtraGameData(ESubmitDataType.TYPE_CREATE_ROLE)
  CS.MuInterface.Instance:HelpService(gameData)
end

function DataToCSharpMgr.AccountCancellation(submitType)
  local gameData = DataToCSharpMgr.GetExtraGameData(submitType)
  CS.MuInterface.Instance:AccountCancellation(gameData)
end

function DataToCSharpMgr.ChangeAmountToExchangeCount(amount)
  if type(amount) ~= "number" then
    return
  end
  return math.ceil(amount)
end

function DataToCSharpMgr.ChangeAmountToSec(amount)
  if type(amount) ~= "number" then
    return amount
  end
  return MathUtility.FormatNum(amount)
end

function DataToCSharpMgr.ChangeTotalRechargeToShow(amount)
  if type(amount) ~= "number" then
    return amount
  end
  return MathUtility.FormatNum(amount)
end

function DataToCSharpMgr.Iswebpy(rmb)
  local data = ClientTable.cfg_Global_globalManager:TryGetValue(78000001)
  if data then
    local datastr = data.effect
    if datastr then
      local datastr = string.split(datastr, "#")
      if ViewData.meData.level >= tonumber(datastr[1]) and tonumber(rmb) >= tonumber(datastr[2]) then
        return true
      end
      return false
    else
      return false
    end
  else
    return false
  end
end

function DataToCSharpMgr.Pay(pInfo)
  local function OpenRechargeSdk()
    local tokensId = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(63000011).effect)
    
    local ExchangeCount = 0
    local ExchangeId
    for i, v in pairs(BagInfoData.TotalItems) do
      if v.itemId == tokensId then
        ExchangeCount = v.count + ExchangeCount
        ExchangeId = v.id
        break
      end
    end
    local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(pInfo.product_Id)
    if rechargeCfg then
      pInfo.amount = rechargeCfg.rmb
    end
    local needSpecialHandle = false
    local condition = ClientTable.cfg_Global_globalManager:TryGetValue(63000013).effect
    needSpecialHandle = ConditionManager.Check4D(condition)
    local needExchangeCount = DataToCSharpMgr.ChangeAmountToExchangeCount(pInfo.amount)
    if needExchangeCount and ExchangeCount >= needExchangeCount then
      if needSpecialHandle then
        TipUtility.QuickShowPrompt({
          id = 131,
          cancelAction = function()
            UIManager.Hide(UIID.PromptTipUI)
          end,
          okAction = function()
            UIManager.Hide(UIID.PromptTipUI)
            BagInfoController.UseItemReq(pInfo.amount, ExchangeId, {
              tostring(pInfo.product_Id)
            }, tokensId)
            return
          end
        })
      else
        BagInfoController.UseItemReq(pInfo.amount, ExchangeId, {
          tostring(pInfo.product_Id)
        }, tokensId)
        return
      end
    elseif needSpecialHandle then
      TipUtility.QuickShowPrompt({
        id = 130,
        cancelAction = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        okAction = function()
          UIManager.Hide(UIID.PromptTipUI)
          if ClientConfigData.OpenRecharge then
            local rechargeUrl = ClientTable.cfg_Global_globalManager:TryGetValue(63000012).effect
            Application.OpenURL(rechargeUrl)
          else
            UIManager.Show(UIID.PromptTipUI, {
              tile = "Nh\225\186\175c nh\225\187\159",
              textContent = "L\225\187\145i v\195\160o n\225\186\161p t\225\186\161m \196\145\195\179ng"
            })
          end
          return
        end
      })
    else
      local PayType
      if not pInfo.BusinessPayType or pInfo.BusinessPayType == BusinessPayType.None then
        PayType = BusinessPayType.None
      else
        PayType = pInfo.BusinessPayType
      end
      if not LoginData.isSdk then
        NetManager.Send(ChatMessage.ReqGM, {
          info = string.format("@30 %d", pInfo.product_Id)
        })
      elseif ClientConfigData.OpenRecharge then
        local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(pInfo.product_Id)
        local pyParams = CS.PyParams()
        pyParams.amount = tostring(pInfo.amount)
        pyParams.product_Id = tostring(pInfo.product_Id)
        pyParams.product_name = tostring(pInfo.product_name)
        pyParams.app_User_Id = LoginData.sdkUserId
        pyParams.app_user_Name = LoginData.roleName
        pyParams.game_Role_Id = tostring(LoginData.roleId)
        pyParams.sid = tostring(LoginData.serverId)
        pyParams.app_order_Id = LoginData.roleId .. ":" .. pyParams.product_Id .. ":" .. Time.GetServerSecondTime() .. ":" .. PayType
        pyParams.notify_Uri = ""
        pyParams.app_Ext1 = LoginData.loginExt
        if this.platformName == nil then
          local configJson = ""
          if CS.MuInterface.Instance.GetVersionConfig then
            configJson = CS.MuInterface.Instance:GetVersionConfig()
          end
          if not string.isNullOrEmpty(configJson) then
            local config = json.decode(configJson)
            if not string.isNullOrEmpty(config.PlatformPay) then
              this.platformName = config.PlatformPay
            end
          end
        end
        if this.platformName and rechargeCfg and rechargeCfg[this.platformName] then
          pyParams.app_Ext2 = rechargeCfg[this.platformName]
        else
          pyParams.app_Ext2 = ""
        end
        pyParams.serverName = LoginData.server[1]
        local webdata = this.Iswebpy(rechargeCfg.rmb)
        local urlwenpay = PlatformData.GetCanPay()
        if not string.isNullOrEmpty(urlwenpay) and webdata then
          local fullURL = string.format("%s/sdkTDP/%s/%s?language=%s&appid=%s&user_id=%s&role_id=%s&role_name=%s&server_id=%s&server_name=%s&product_id=%s&product_describe=%s&app_order_id=%s&app_extra1=%s", urlwenpay, "HK", "200075", "VI", PlatformData.GetAppid(), pyParams.app_User_Id, pyParams.game_Role_Id, pyParams.app_user_Name, pyParams.sid, LoginData.GetServerName(), pyParams.app_Ext2, pyParams.product_name, pyParams.app_order_Id, pyParams.product_Id .. ":" .. LoginData.GetPid())
          if PlatformData.PlatformCheck(PlatformNameEnum.UNITY_IOS) and CS.MuInterface.Instance.OpenURL then
            CS.MuInterface.Instance:OpenURL(fullURL)
          else
            Application.OpenURL(fullURL)
          end
        else
          CS.MuInterface.Instance:Py(pyParams)
        end
      else
        UIManager.Show(UIID.PromptTipUI, {
          tile = "Nh\225\186\175c nh\225\187\159",
          textContent = "L\225\187\145i v\195\160o n\225\186\161p t\225\186\161m \196\145\195\179ng"
        })
      end
    end
  end
  
  OpenRechargeSdk()
end

DataToCSharpMgr:Init()
