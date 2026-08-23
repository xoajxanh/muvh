function networkRequest.ReqOpenFriendPanel(type)
  local reqTable = {}
  
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(FriendMessage.ReqOpenFriendPanel, reqTable)
end

function networkRequest.ReqAddFriend(id, type)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(FriendMessage.ReqAddFriend, reqTable)
end

function networkRequest.ReqDeleteFriend(id, type)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(FriendMessage.ReqDeleteFriend, reqTable)
end

function networkRequest.ReqCheckApply(id, flag)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if flag ~= nil then
    reqTable.flag = flag
  end
  NetManager.Send(FriendMessage.ReqCheckApply, reqTable)
end

function networkRequest.ReqEditRemark(id, remark)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if remark ~= nil then
    reqTable.remark = remark
  end
  NetManager.Send(FriendMessage.ReqEditRemark, reqTable)
end

function networkRequest.ReqSearchByName(name, accurate)
  local reqTable = {}
  if name ~= nil then
    reqTable.name = name
  end
  if accurate ~= nil then
    reqTable.accurate = accurate
  end
  NetManager.Send(FriendMessage.ReqSearchByName, reqTable)
end

function networkRequest.ReqFriendSelfPanelInfo(id, type)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(FriendMessage.ReqFriendSelfPanelInfo, reqTable)
end

function networkRequest.ReqGetFriendRecommend()
  NetManager.Send(FriendMessage.ReqGetFriendRecommend)
end
