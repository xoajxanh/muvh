MuCallBackUtility = {}
local this = MuCallBackUtility
MuCallBackUtility.isNeedJumpScene = true

function MuCallBackUtility.Leave()
  if MuCallBackUtility.isNeedJumpScene then
    EventManager.Dispatch(Event.GamePlay_Leave)
    NetManager.Close()
  else
    local v = UIManager.GetUiByName(UIID.LoginUI)
    if v then
      v:SetState(1)
    end
  end
  LoginData.InGame = false
  LoginData.isSdkLogging = false
end
