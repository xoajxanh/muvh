function networkRequest.ResNewMail(mailInfo)
  local reqTable = {}
  
  if mailInfo ~= nil then
    reqTable.mailInfo = mailInfo
  end
  NetManager.Send(MailMessage.ResNewMail, reqTable)
end

function networkRequest.ReqGetMailList()
  local reqTable = {}
  NetManager.Send(MailMessage.ReqGetMailList, reqTable)
end

function networkRequest.ResGetMailList(mailInfo)
  local reqTable = {}
  if mailInfo ~= nil then
    reqTable.mailInfo = mailInfo
  else
    reqTable.mailInfo = {}
  end
  NetManager.Send(MailMessage.ResGetMailList, reqTable)
end

function networkRequest.ReqReadMail(mailId)
  local reqTable = {}
  if mailId ~= nil then
    reqTable.mailId = mailId
  else
    reqTable.mailId = {}
  end
  NetManager.Send(MailMessage.ReqReadMail, reqTable)
end

function networkRequest.ResReadMail(mailInfo)
  local reqTable = {}
  if mailInfo ~= nil then
    reqTable.mailInfo = mailInfo
  else
    reqTable.mailInfo = {}
  end
  NetManager.Send(MailMessage.ResReadMail, reqTable)
end

function networkRequest.ReqGetMailItems(mailIds, delete)
  local reqTable = {}
  if mailIds ~= nil then
    reqTable.mailIds = mailIds
  else
    reqTable.mailIds = {}
  end
  if delete ~= nil then
    reqTable.delete = delete
  end
  NetManager.Send(MailMessage.ReqGetMailItems, reqTable)
end

function networkRequest.ResGetMailItems(mailInfo)
  local reqTable = {}
  if mailInfo ~= nil then
    reqTable.mailInfo = mailInfo
  else
    reqTable.mailInfo = {}
  end
  NetManager.Send(MailMessage.ResGetMailItems, reqTable)
end

function networkRequest.ReqDeleteMail(mailIds)
  local reqTable = {}
  if mailIds ~= nil then
    reqTable.mailIds = mailIds
  else
    reqTable.mailIds = {}
  end
  NetManager.Send(MailMessage.ReqDeleteMail, reqTable)
end
