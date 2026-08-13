local cfg_Function_functionManager = {}

function cfg_Function_functionManager:GetName()
  return "cfg_Function_functionManager"
end

function cfg_Function_functionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Function_function")
  end
  return self.dic
end

setmetatable(cfg_Function_functionManager, TableManagerBase)

function cfg_Function_functionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Function_functionManager:UseDissatisfyFunc(funcId)
  if type(funcId) ~= "number" then
    return
  end
  local funcTbl = self:TryGetValue(funcId)
  if funcTbl == nil then
    print("cfg_Function_function\230\178\161\230\156\137\229\175\185\229\186\148\233\133\141\231\189\174 id\239\188\154" .. tostring(funcId))
    return
  end
  local defaultType = FunctionSystemDissatisfyFuncType.QuickMsg
  local defaultParam = "CanNotBuy_3"
  if funcTbl.unmetType ~= nil and funcTbl.unmetParam ~= nil then
    defaultType = funcTbl.unmetType
    defaultParam = funcTbl.unmetParam
  end
  if defaultType == FunctionSystemDissatisfyFuncType.UIPromptUI then
    if defaultParam == nil then
      print("cfg_Function_function\232\161\168\228\184\186\230\187\161\232\182\179\230\157\161\228\187\182\230\156\170\229\161\171\229\134\153\228\186\140\230\172\161\231\161\174\232\174\164id \229\173\151\230\174\181unmetParam")
      return
    end
    TipUtility.QuickShowPrompt({
      id = tonumber(defaultParam)
    })
  elseif defaultType == FunctionSystemDissatisfyFuncType.QuickMsg then
    local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(defaultParam)
    if string.isNullOrEmpty(title) == false then
      FloatingTipUtility.QuickMsg(title)
    end
  end
end

function cfg_Function_functionManager:GetPreviewFuncListByPreviewType(previewType)
  if previewType == nil or previewType <= 0 then
    return {}
  end
  local previewFuncList = {}
  for i, v in pairs(self:GetDic()) do
    if v.previewType == previewType then
      table.insert(previewFuncList, v)
    end
  end
  table.sort(previewFuncList, function(a, b)
    return a.Rank < b.Rank
  end)
  return previewFuncList
end

function cfg_Function_functionManager:GetKoreaWebView(id)
  local data = self:TryGetValue(id)
  local isShow = true
  if data.condition then
    isShow = ConditionManager.Check4D(data.condition)
  end
  if data.koreaWebviewId and isShow then
    local name = ClientTable.cfg_Korea_systemConfigManager:TryGetValue(tonumber(data.koreaWebviewId))
    if PlatformData.PlatformCheck(PlatformNameEnum.UNITY_STANDALONE_WIN) then
      local str = ""
      local type = UIManager.GetMocaaServerMode()
      if type == MocaaServerModelType.live then
        str = name.pcLive
      else
        str = name.pc
      end
      return str
    elseif PlatformData.PlatformCheck(PlatformNameEnum.UNITY_IOS) then
      return name.ios
    elseif PlatformData.PlatformCheck(PlatformNameEnum.UNITY_ANDROID) then
      return name.android
    end
  end
  return ""
end

return cfg_Function_functionManager
