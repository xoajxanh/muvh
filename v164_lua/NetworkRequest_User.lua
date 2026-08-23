function networkRequest.ReqLogin(loginName, version, time, sign, reconnect, serverId, token)
  local reqTable = {}
  
  if loginName ~= nil then
    reqTable.loginName = loginName
  end
  if version ~= nil then
    reqTable.version = version
  end
  if time ~= nil then
    reqTable.time = time
  end
  if sign ~= nil then
    reqTable.sign = sign
  end
  if reconnect ~= nil then
    reqTable.reconnect = reconnect
  end
  if serverId ~= nil then
    reqTable.serverId = serverId
  end
  if token ~= nil then
    reqTable.token = token
  end
  NetManager.Send(UserMessage.ReqLogin, reqTable)
end

function networkRequest.ReqGetRoleList()
  local reqTable = {}
  NetManager.Send(UserMessage.ReqGetRoleList, reqTable)
end

function networkRequest.ReqCreateRole(roleName, sex, career)
  local reqTable = {}
  if roleName ~= nil then
    reqTable.roleName = roleName
  end
  if sex ~= nil then
    reqTable.sex = sex
  end
  if career ~= nil then
    reqTable.career = career
  end
  NetManager.Send(UserMessage.ReqCreateRole, reqTable)
end

function networkRequest.ReqChooseRole(roleId)
  local reqTable = {}
  if roleId ~= nil then
    reqTable.roleId = roleId
  end
  NetManager.Send(UserMessage.ReqChooseRole, reqTable)
end

function networkRequest.ReqRandomName(sex)
  local reqTable = {}
  if sex ~= nil then
    reqTable.sex = sex
  end
  NetManager.Send(UserMessage.ReqRandomName, reqTable)
end

function networkRequest.ReqHeart(clientTime)
  local reqTable = {}
  if clientTime ~= nil then
    reqTable.clientTime = clientTime
  end
  NetManager.Send(UserMessage.ReqHeart, reqTable)
end

function networkRequest.ReqLogout(reason)
  local reqTable = {}
  if reason ~= nil then
    reqTable.reason = reason
  end
  NetManager.Send(UserMessage.ReqLogout, reqTable)
end

function networkRequest.ReqDeleteRole(rid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(UserMessage.ReqDeleteRole, reqTable)
end

function networkRequest.ReqInviteCodeView()
  NetManager.Send(UserMessage.ReqInviteCodeView)
end

function networkRequest.ReqInputInviteCode(code)
  local reqTable = {}
  if code ~= nil then
    reqTable.code = code
  end
  NetManager.Send(UserMessage.ReqInputInviteCode, reqTable)
end

function networkRequest.ReqGenInviteCode()
  NetManager.Send(UserMessage.ReqGenInviteCode)
end

function networkRequest.ReqCancelDelRole(rid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(UserMessage.ReqCancelDelRole, reqTable)
end

function networkRequest.ReqRoleCode()
  NetManager.Send(UserMessage.ReqRoleCode)
end

function networkRequest.ReqRoleVerifyCode(code)
  local reqTable = {}
  if code ~= nil then
    reqTable.code = code
  end
  NetManager.Send(UserMessage.ReqRoleVerifyCode, reqTable)
end
