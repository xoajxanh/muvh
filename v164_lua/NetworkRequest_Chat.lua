function networkRequest.ReqGM(info)
  local reqTable = {}
  
  if info ~= nil then
    reqTable.info = info
  end
  NetManager.Send(ChatMessage.ReqGM, reqTable)
end

function networkRequest.ReqChat(chatType, chatMsg, toRoleId)
  local reqTable = {}
  if chatType ~= nil then
    reqTable.chatType = chatType
  end
  if chatMsg ~= nil then
    reqTable.chatMsg = chatMsg
  end
  if toRoleId ~= nil then
    reqTable.toRoleId = toRoleId
  end
  NetManager.Send(ChatMessage.ReqChat, reqTable)
end

function networkRequest.ReqSubmitFeedbackQuestion(submit)
  local reqTable = {}
  if submit ~= nil then
    reqTable.submit = submit
  else
    reqTable.submit = {}
  end
  NetManager.Send(ChatMessage.ReqSubmitFeedbackQuestion, reqTable)
end

function networkRequest.ReqFeedbacks()
  local reqTable = {}
  NetManager.Send(ChatMessage.ReqFeedbacks, reqTable)
end

function networkRequest.ReqSendFeedback(msg)
  local reqTable = {}
  if msg ~= nil then
    reqTable.msg = msg
  end
  NetManager.Send(ChatMessage.ReqSendFeedback, reqTable)
end

function networkRequest.ReqAnnounce(id, arg1, arg2)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if arg1 ~= nil then
    reqTable.arg1 = arg1
  else
    reqTable.arg1 = {}
  end
  if arg2 ~= nil then
    reqTable.arg2 = arg2
  else
    reqTable.arg2 = {}
  end
  NetManager.Send(ChatMessage.ReqAnnounce, reqTable)
end

function networkRequest.ReqSearchRoleId(name)
  local reqTable = {}
  if name ~= nil then
    reqTable.name = name
  end
  NetManager.Send(ChatMessage.ReqSearchRoleId, reqTable)
end
