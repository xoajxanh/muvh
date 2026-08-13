Http = {}
local this = Http

function Http.Request(url, callback)
  Coroutine.Start(this.DoRequest, url, callback)
  EventManager.Dispatch(Event.HttpOutReport, "start----" .. (url or "\231\169\186\229\128\188\231\154\132url"))
end

function Http.DoRequest(url, callback)
  local request = CS.UnityEngine.Networking.UnityWebRequest.Get(url)
  Coroutine.Yield(request:SendWebRequest())
  if not string.isNullOrEmpty(request.error) and callback then
    callback(nil)
    EventManager.Dispatch(Event.HttpOutReport, url .. ":" .. "failed")
  elseif callback then
    callback(request.downloadHandler.text)
    EventManager.Dispatch(Event.HttpOutReport, url .. " :sceucce_content" .. request.downloadHandler.text)
  end
  request:Dispose()
end

function Http.RequestHaveArg(url, form, callback)
  Coroutine.Start(this.DoRequestArg, url, form, callback)
  EventManager.Dispatch(Event.HttpOutReport, "start----" .. (url or "\231\169\186\229\128\188\231\154\132url"))
end

function Http.DoRequestArg(url, form, callback)
  local request = CS.UnityEngine.Networking.UnityWebRequest.Post(url, form)
  Coroutine.Yield(request:SendWebRequest())
  if not string.isNullOrEmpty(request.error) and callback then
    callback(nil)
    EventManager.Dispatch(Event.HttpOutReport, url .. ":" .. "failed")
  elseif callback then
    callback(request.downloadHandler.text)
    EventManager.Dispatch(Event.HttpOutReport, url .. " :sceucce_content" .. request.downloadHandler.text)
  end
  request:Dispose()
end

function Http.RequestHaveHandleArg(url, form, handle, callback)
  Coroutine.Start(this.DoRequestHandleArg, url, form, handle, callback)
  EventManager.Dispatch(Event.HttpOutReport, "start----" .. (url or "\231\169\186\229\128\188\231\154\132url"))
end

function Http.DoRequestHandleArg(url, form, handle, callback)
  local request = CS.UnityEngine.Networking.UnityWebRequest.Post(url, form)
  for i, v in pairs(handle) do
    request:SetRequestHeader(tostring(i), tostring(v))
  end
  Coroutine.Yield(request:SendWebRequest())
  if not string.isNullOrEmpty(request.error) and callback then
    callback(nil)
    EventManager.Dispatch(Event.HttpOutReport, url .. ":" .. "failed")
  elseif callback then
    callback(request.downloadHandler.text)
    EventManager.Dispatch(Event.HttpOutReport, url .. " :content" .. request.downloadHandler.text)
  end
  request:Dispose()
end
