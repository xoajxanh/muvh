netMsgPreprocessing[300001] = function(msgID, tblData)
end
netMsgPreprocessing[300002] = function(msgID, tblData)
end
netMsgPreprocessing[300003] = function(msgID, tblData)
end
netMsgPreprocessing[300004] = function(msgID, tblData)
  local isShow = false
  if LoginData.loginType == KoreaPlatformEnum.Google then
    local check = ConditionManager.Check4D(ClientTable.cfg_Function_functionManager:TryGetValue(4000006).condition)
    isShow = check
  elseif LoginData.loginType == KoreaPlatformEnum.APPLE then
    local check = ConditionManager.Check4D(ClientTable.cfg_Function_functionManager:TryGetValue(4000007).condition)
    isShow = check
  end
  if not isShow then
    return
  end
  TipUtility.QuickShowPrompt({
    id = PromptWordType.RatingPopUp,
    cancelAction = function()
      UIManager.Hide(UIID.PromptTipUI)
      networkRequest.ReqNextPushEvaluate()
    end,
    okAction = function()
      UIManager.Hide(UIID.PromptTipUI)
      if LoginData.loginType == KoreaPlatformEnum.Google then
        local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000006)
        if name then
          CS.MuInterface.Instance:OnStoreReview(name)
        end
      elseif LoginData.loginType == KoreaPlatformEnum.APPLE then
        local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000007)
        if name then
          CS.MuInterface.Instance:OnStoreReview(name)
        end
      end
    end
  })
end
