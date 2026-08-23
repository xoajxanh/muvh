function networkRequest.ReqRemoteMaps()
  NetManager.Send(RpcMessage.ReqRemoteMaps)
end

function networkRequest.ResRemoteMaps()
  NetManager.Send(RpcMessage.ResRemoteMaps)
end
