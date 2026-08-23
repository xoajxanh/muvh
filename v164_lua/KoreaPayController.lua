KoreaPayController = {}
local this = KoreaPayController

function KoreaPayController.Init()
  this.RegistMessages()
end

function KoreaPayController.RegistMessages()
  EventManager.Regist(Event.SDK_KOREAPAY_CALLBACK, this.OnSdkKoreaCallBack)
  EventManager.Regist(Event.SDK_KOREAPAYREISSUE_CALLBACK, this.OnSdkKoreaPayresissueCALLBACK)
  EventManager.Regist(Event.Scene_SceneLoaded, this.SDK_KOREAPAYREISSUEMAP_CALLBACK)
end

function KoreaPayController.OnSdkKoreaCallBack(_, event)
  networkRequest.ReqReissue(LoginData.service_code, 1)
end

function KoreaPayController.OnSdkKoreaPayresissueCALLBACK(_, name)
  if name then
    local checkname = ClientTable.cfg_Global_globalManager:GetUINameCheckResisue(name)
    if checkname then
      networkRequest.ReqReissue(LoginData.service_code, 1)
    end
  end
end

function KoreaPayController.SDK_KOREAPAYREISSUEMAP_CALLBACK(_, mapname)
  if mapname then
    local chackmap = ClientTable.cfg_Global_globalManager:GetMapidCheckResisue(tostring(mapname))
    if chackmap then
      networkRequest.ReqReissue(LoginData.service_code, 1)
    end
  end
end

KoreaPayController.Init()
