function networkRequest.ReqBackLogin(loginName)
  local reqTable = {}
  
  if loginName ~= nil then
    reqTable.loginName = loginName
  end
  NetManager.Send(BackMessage.ReqBackLogin, reqTable)
end

function networkRequest.ReqBackPing()
  NetManager.Send(BackMessage.ReqBackPing)
end

function networkRequest.ReqCloseServer()
  NetManager.Send(BackMessage.ReqCloseServer)
end
