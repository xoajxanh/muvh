function networkRequest.ReqOpenDay()
  NetManager.Send(CommonMessage.ReqOpenDay)
end

function networkRequest.ResOpenDay(openDay)
  local reqTable = {}
  if openDay ~= nil then
    reqTable.openDay = openDay
  end
  NetManager.Send(CommonMessage.ResOpenDay, reqTable)
end

function networkRequest.ReqOpenWeek()
  NetManager.Send(CommonMessage.ReqOpenWeek)
end

function networkRequest.ResOpenWeek(openWeek)
  local reqTable = {}
  if openWeek ~= nil then
    reqTable.openWeek = openWeek
  end
  NetManager.Send(CommonMessage.ResOpenWeek, reqTable)
end

function networkRequest.ReqReport(rid, reasons, content)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if reasons ~= nil then
    reqTable.reasons = reasons
  else
    reqTable.reasons = {}
  end
  if content ~= nil then
    reqTable.content = content
  end
  NetManager.Send(CommonMessage.ReqReport, reqTable)
end

function networkRequest.ReqResolution(resolution)
  local reqTable = {}
  if resolution ~= nil then
    reqTable.resolution = resolution
  end
  NetManager.Send(CommonMessage.ReqResolution, reqTable)
end

function networkRequest.ReqService(token, type)
  local reqTable = {}
  if token ~= nil then
    reqTable.token = token
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(CommonMessage.ReqService, reqTable)
end

function networkRequest.ReqCurrentClientVersion()
  NetManager.Send(CommonMessage.ReqCurrentClientVersion)
end

function networkRequest.ReqClientTimeCheck()
  NetManager.Send(CommonMessage.ReqClientTimeCheck)
end
