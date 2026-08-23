Time = {}
local this = Time
local unity_time = CS.UnityEngine.Time
local inited = false
local systemTime = CS.System.DateTime

function Time.Update(time, unscaledTime)
  if not inited then
    rawset(this, "deltaTime", unity_time.deltaTime)
    rawset(this, "unscaledDeltaTime", unity_time.unscaledDeltaTime)
    rawset(this, "time", unity_time.time)
    rawset(this, "unscaledTime", unity_time.unscaledTime)
    rawset(this, "frameCount", unity_time.frameCount)
    inited = true
  else
    this.deltaTime = time - this.time
    this.unscaledDeltaTime = unscaledTime - this.unscaledTime
    this.time = time
    this.unscaledTime = unscaledTime
    this.frameCount = this.frameCount + 1
  end
end

local serverTime = 0
local recvServerTime = 0
local remoteTime = 0

function Time.SetServerTime(time)
  Time.CheckAcrossDay()
  serverTime = time
  recvServerTime = this.unscaledTime
end

function Time.GetServerTime()
  return serverTime + math.floor((this.unscaledTime - recvServerTime) * 1000)
end

function Time.CheckAcrossDay()
  local lastDay = os.date("%d", math.floor(serverTime * 0.001))
  local nowDay = os.date("%d", math.floor(Time.GetServerTime() * 0.001))
  if lastDay ~= nowDay then
    EventManager.Dispatch(Event.TimeAcrossDay)
    gameMgr:TimeAcrossDay()
  end
end

function Time.SetRemoteOpenTime(time)
  if time then
    remoteTime = time
  end
end

function Time.GetRemoteOpenTime()
  return remoteTime
end

local CommerceTime = 0
local CommerceCount = 0

function Time.SetCommerceTime(time)
  if time then
    CommerceTime = time
  end
end

function Time.GetCommerceTime()
  return CommerceTime
end

function Time.SetCommerceCount(Count)
  if Count then
    CommerceCount = Count
  end
end

function Time.GetCommerceCount()
  return CommerceCount
end

function Time.GetServerSecondTime()
  return math.floor(Time.GetServerTime() * 0.001)
end

function Time.GetServerDayTime()
  local TIMEZONES_SECONDS = TimeUtility.TIMEZONES_SECONDS * 1000
  return math.floor((Time.GetServerTime() + TIMEZONES_SECONDS) / TimeUtility.DayStamp) * TimeUtility.DayStamp
end

function Time.GetServerDayDayTime()
  return math.floor(Time.GetServerTime() / TimeUtility.DayStamp)
end

local m = {
  __index = function(t, k)
    return unity_time[k]
  end,
  __newindex = function(t, k, v)
    unity_time[k] = v
  end
}

function Time.LogTime(addTime)
  local serverTime = Time.GetServerTime()
  if addTime then
    local curAddServerTime = serverTime + addTime * 1000
    CS.UnityEngine.Debug.Log("\229\189\147\229\137\141\230\151\182\233\151\180\239\188\154" .. tostring(serverTime) .. "\r\n\229\162\158\229\138\160\229\144\142\231\154\132\230\151\182\233\151\180\239\188\154" .. tostring(curAddServerTime))
  else
    CS.UnityEngine.Debug.Log(tostring(serverTime))
  end
end

function Time.GetNowTickTime()
  return systemTime.Now.Ticks
end

setmetatable(Time, m)
CS.UnityEngine.Time = Time
