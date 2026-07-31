function networkRequest.ReqLoginRemote(host)
  local reqTable = {}
  
  if host ~= nil then
    reqTable.host = host
  end
  NetManager.Send(RemoteMessage.ReqLoginRemote, reqTable)
end

function networkRequest.ResLoginRemote(host)
  local reqTable = {}
  if host ~= nil then
    reqTable.host = host
  end
  NetManager.Send(RemoteMessage.ResLoginRemote, reqTable)
end

function networkRequest.ReqFetchRemoteMaps(host)
  local reqTable = {}
  if host ~= nil then
    reqTable.host = host
  end
  NetManager.Send(RemoteMessage.ReqFetchRemoteMaps, reqTable)
end

function networkRequest.ResFetchRemoteMaps(map, hostId)
  local reqTable = {}
  if map ~= nil then
    reqTable.map = map
  else
    reqTable.map = {}
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(RemoteMessage.ResFetchRemoteMaps, reqTable)
end

function networkRequest.RemoteMapServerLinkLink(remoteMapServerHostId, remoteMapServerIp, remoteMapServerPort, remoteMapServerHttpPort, remoteMapServerServerType, remoteMapServerServerId, remoteMapServerOperationId, linkedLogicServers)
  local reqTable = {}
  if remoteMapServerHostId ~= nil then
    reqTable.remoteMapServerHostId = remoteMapServerHostId
  end
  if remoteMapServerIp ~= nil then
    reqTable.remoteMapServerIp = remoteMapServerIp
  end
  if remoteMapServerPort ~= nil then
    reqTable.remoteMapServerPort = remoteMapServerPort
  end
  if remoteMapServerHttpPort ~= nil then
    reqTable.remoteMapServerHttpPort = remoteMapServerHttpPort
  end
  if remoteMapServerServerType ~= nil then
    reqTable.remoteMapServerServerType = remoteMapServerServerType
  end
  if remoteMapServerServerId ~= nil then
    reqTable.remoteMapServerServerId = remoteMapServerServerId
  end
  if remoteMapServerOperationId ~= nil then
    reqTable.remoteMapServerOperationId = remoteMapServerOperationId
  end
  if linkedLogicServers ~= nil then
    reqTable.linkedLogicServers = linkedLogicServers
  else
    reqTable.linkedLogicServers = {}
  end
  NetManager.Send(RemoteMessage.RemoteMapServerLinkLink, reqTable)
end
