function networkRequest.ReqJoinUnionKuaFu(camp)
  local reqTable = {}
  
  if camp ~= nil then
    reqTable.camp = camp
  end
  NetManager.Send(UnionKuafuMessage.ReqJoinUnionKuaFu, reqTable)
end

function networkRequest.ReqQuitUnionKuaFu()
  local reqTable = {}
  NetManager.Send(UnionKuafuMessage.ReqQuitUnionKuaFu, reqTable)
end

function networkRequest.ReqUnionKuaFuInfo(camp)
  local reqTable = {}
  if camp ~= nil then
    reqTable.camp = camp
  end
  NetManager.Send(UnionKuafuMessage.ReqUnionKuaFuInfo, reqTable)
end

function networkRequest.ReqKickUnionKuaFuMember(unionId)
  local reqTable = {}
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  NetManager.Send(UnionKuafuMessage.ReqKickUnionKuaFuMember, reqTable)
end

function networkRequest.ReqAllUnionKuaFuInfo()
  local reqTable = {}
  NetManager.Send(UnionKuafuMessage.ReqAllUnionKuaFuInfo, reqTable)
end

function networkRequest.ReqRoleUnionKuaFuInfo()
  local reqTable = {}
  NetManager.Send(UnionKuafuMessage.ReqRoleUnionKuaFuInfo, reqTable)
end

function networkRequest.ReqUpdateUnionKuaFuAnnouncement(text)
  local reqTable = {}
  if text ~= nil then
    reqTable.text = text
  end
  NetManager.Send(UnionKuafuMessage.ReqUpdateUnionKuaFuAnnouncement, reqTable)
end

function networkRequest.ReqUnionKuaFuOnlineNum(camp)
  local reqTable = {}
  if camp ~= nil then
    reqTable.camp = camp
  end
  NetManager.Send(UnionKuafuMessage.ReqUnionKuaFuOnlineNum, reqTable)
end

function networkRequest.ReqAddWatchOnlineList()
  local reqTable = {}
  NetManager.Send(UnionKuafuMessage.ReqAddWatchOnlineList, reqTable)
end

function networkRequest.ReqExitWatchOnlineList()
  local reqTable = {}
  NetManager.Send(UnionKuafuMessage.ReqExitWatchOnlineList, reqTable)
end
