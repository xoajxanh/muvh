require("GameConst/TimeConst")
TimeUtility = {}
local this = TimeUtility
TimeUtility.nextDayStartTime = 0

function TimeUtility.AnalysisRefreshJudge(type, content, updateTime)
  local flag = false
  local refreshTime
  if type == EConditionEnum.timeMoreThan then
    local curRefreshState
    curRefreshState, refreshTime = this.RefreshACertainPointInTime(content, updateTime)
    flag = curRefreshState
  elseif type == EConditionEnum.timeWeekendMoreThanOrEqual then
    local day = tonumber(content)
    local curRefreshState
    curRefreshState, refreshTime = this.RefreshADayInWeek(day, updateTime)
    flag = curRefreshState
  elseif type == EConditionEnum.timeMonthMoreThanOrEqual then
    local day = tonumber(content)
    local curRefreshState
    curRefreshState, refreshTime = this.RefreshADayInMonth(day, updateTime)
    flag = curRefreshState
  elseif type == EConditionEnum.timeOpenserverDay then
    local day = tonumber(content)
    local curRefreshState
    curRefreshState, refreshTime = this.RefreshOpenServerDay(day)
    flag = curRefreshState
  end
  return flag, refreshTime
end

local DAY_SECONDS = 86400
local TIME_ZONE = os.time({
  year = 1970,
  month = 1,
  day = 2,
  hour = 0
})
local B0 = string.byte("0")
local bigMonthTab = {
  1,
  3,
  5,
  7,
  8,
  10,
  12
}

local function IsBigMonth(month)
  for i = 1, #bigMonthTab do
    if month == bigMonthTab[i] then
      return true
    end
  end
  return false
end

local wDayString = {
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
}

local function TimeToServerDate(format, serverTime)
  local localDate = os.date("*t", serverTime)
  local dayMoreSecond = localDate.hour * 3600 + localDate.min * 60 + localDate.sec
  local now = os.time()
  local utcNow = os.time(os.date("!*t", now))
  local localOffset = now - utcNow
  local adjustment = localOffset - this.TIMEZONES_SECONDS
  dayMoreSecond = dayMoreSecond - adjustment
  if dayMoreSecond > DAY_SECONDS then
    localDate.day = localDate.day + 1
    localDate.wday = localDate.wday + 1 > 7 and 1 or localDate.wday + 1
    dayMoreSecond = dayMoreSecond - DAY_SECONDS
  elseif dayMoreSecond < 0 then
    localDate.day = localDate.day - 1
    localDate.wday = 1 > localDate.wday - 1 and 7 or localDate.wday - 1
    dayMoreSecond = DAY_SECONDS + dayMoreSecond
  end
  localDate.hour = dayMoreSecond // 3600
  localDate.min = dayMoreSecond % 3600 // 60
  localDate.sec = dayMoreSecond % 3600 % 60
  if IsBigMonth(localDate.month) then
    if localDate.day > 31 then
      localDate.month = localDate.month + 1
      if localDate.month > 12 then
        localDate.month = 1
        localDate.year = localDate.year + 1
      end
      localDate.day = 1
    elseif localDate.day < 1 then
      localDate.month = localDate.month - 1
      if IsBigMonth(localDate.month) then
        localDate.day = 31
        if localDate.month == 12 then
          localDate.year = localDate.year - 1
        end
      elseif localDate.month ~= 2 then
        localDate.day = 30
      elseif localDate.year % 4 == 0 and localDate.year % 100 ~= 0 then
        localDate.day = 29
      else
        localDate.day = 28
      end
    end
  elseif localDate.day > 30 then
    localDate.month = localDate.month + 1
    localDate.day = 1
  elseif localDate.day < 1 then
    localDate.month = localDate.month - 1
    if IsBigMonth(localDate.month) then
      localDate.day = 31
    elseif localDate.month ~= 2 then
      localDate.day = 30
    elseif localDate.year % 4 == 0 and localDate.year % 100 ~= 0 then
      localDate.day = 29
    else
      localDate.day = 28
    end
  end
  if format == "*t" then
    return localDate
  elseif format == "%A" then
    return wDayString[localDate.wday]
  else
    logError("\230\156\170\229\174\154\228\185\137\230\160\188\229\188\143>>" .. format)
  end
end

local function DateToServerTime(serverDate)
  local localDateTime = os.time(serverDate)
  local now = os.time()
  local utcNow = os.time(os.date("!*t", now))
  local localOffset = now - utcNow
  local adjustment = localOffset - this.TIMEZONES_SECONDS
  return localDateTime + adjustment
end

local DateTable = {
  year = 0,
  month = 0,
  day = 0,
  hour = 0,
  min = 0,
  sec = 0
}
local indexToKey = {
  "year",
  "month",
  "day",
  "hour",
  "min",
  "sec"
}

function TimeUtility.GetServerTimeByDate(dateStr)
  local date = string.split(dateStr, "-")
  for i = 1, #indexToKey do
    if date[i] then
      DateTable[indexToKey[i]] = tonumber(date[i])
    else
      DateTable[indexToKey[i]] = 0
    end
  end
  return DateToServerTime(DateTable)
end

function TimeUtility.GetDayTimeStamp(time)
  return time - (time + TimeUtility.TIMEZONES_SECONDS) % DAY_SECONDS
end

function TimeUtility.GetSeconds(timeStr, index1, index2)
  local numbers = string.splitToNumbers(timeStr, index1, index2)
  if #numbers == 2 then
    return numbers[1] * 3600 + numbers[2] * 60
  end
  if #numbers == 3 then
    return numbers[1] * 3600 + numbers[2] * 60 + numbers[3]
  end
  logError("param timeStr error:" .. timeStr)
  return 0
end

function TimeUtility.GetyearSeconds(timeStr, index1, index2)
  local numbers = string.splitToNumbers(timeStr, index1, index2)
  if #numbers == 2 then
    return DateToServerTime({
      year = numbers[1],
      month = numbers[2],
      day = 0,
      hour = 0
    })
  end
  if #numbers == 3 then
    return DateToServerTime({
      year = numbers[1],
      month = numbers[2],
      day = numbers[3],
      hour = 0
    })
  end
  logError("param timeStr error:" .. timeStr)
  return 0
end

function TimeUtility.GetTimeStampByStr(str, customTime)
  return this.GetDayTimeStamp(customTime or Time.GetServerSecondTime()) + this.GetSeconds(str)
end

function TimeUtility.GetTimeStampBySubStr(str, index1, index2, customTime)
  return this.GetDayTimeStamp(customTime or Time.GetServerSecondTime()) + this.GetSeconds(str, index1, index2)
end

function TimeUtility.InTweenTimeSlot(timeSlot, stamp)
  local curTime = stamp or Time.GetServerSecondTime()
  local index = string.find(timeSlot, "-", 1, true)
  local stratTime = this.GetTimeStampBySubStr(timeSlot, 1, index - 1)
  if curTime < stratTime then
    return false
  end
  local endTime = this.GetTimeStampBySubStr(timeSlot, index + 1)
  if curTime > endTime then
    return false
  end
  return true
end

function TimeUtility.GetyearTimeStampBySubStr(str, index1, index2, customTime)
  return this.GetyearSeconds(str, index1, index2)
end

function TimeUtility.InTweenyearTimeSlot(timeSlot, stamp, isAdvance)
  local curTime = stamp or Time.GetServerSecondTime()
  local index = string.find(timeSlot, "-", 1, true)
  local serverTimeAdvance = 0
  if type(LoginData.ServerTimeAdvance) == "number" and isAdvance then
    serverTimeAdvance = LoginData.ServerTimeAdvance
  end
  local stratTime = this.GetyearTimeStampBySubStr(timeSlot, 1, index - 1) - serverTimeAdvance * ETimeSec.day
  if curTime < stratTime then
    return false
  end
  local endTime = this.GetyearTimeStampBySubStr(timeSlot, index + 1) + ETimeSec.day - serverTimeAdvance * ETimeSec.day
  if curTime > endTime then
    return false
  end
  return true
end

function TimeUtility.InTweenyearTimeRemoteOpen(timeSlot, stamp)
  local index = string.find(timeSlot, "^", 1, true)
  local DesignatesTime = this.GetyearTimeStampBySubStr(timeSlot, 1, index - 1)
  local TimeDifference = (DesignatesTime - Time.GetRemoteOpenTime() / 1000) / ETimeSec.day + 1
  if 0 < TimeDifference then
    local Range = string.split(timeSlot, "^")[2]
    local Rangetbl = string.split(Range, "_")
    local startTime = tonumber(Rangetbl[1])
    local endTime = tonumber(Rangetbl[2])
    if TimeDifference >= startTime and TimeDifference <= endTime then
      return true
    end
  end
  return false
end

function TimeUtility.InTweenyearTimeTheEnd(timeSlot)
  local serverTimeAdvance = 0
  if type(LoginData.ServerTimeAdvance) == "number" then
    serverTimeAdvance = LoginData.ServerTimeAdvance
  end
  local index = string.find(timeSlot, "-", 1, true)
  local endTime = this.GetyearTimeStampBySubStr(timeSlot, index + 1) + ETimeSec.day - serverTimeAdvance * ETimeSec.day
  return endTime
end

function TimeUtility.GetTweenTimeSlot(timeSlot)
  local index = string.find(timeSlot, "-", 1, true)
  local startTime = this.GetTimeStampBySubStr(timeSlot, 1, index - 1)
  local endTime = this.GetTimeStampBySubStr(timeSlot, index + 1)
  return startTime, endTime
end

function TimeUtility.OpenServerTimeDesignatesRange(timeSlot, stamp)
  local index = string.find(timeSlot, "^", 1, true)
  local DesignatesTime = this.GetyearTimeStampBySubStr(timeSlot, 1, index - 1)
  local TimeDifference = (DesignatesTime - LoginData.openServerTime / 1000) / ETimeSec.day + 1
  if 0 < TimeDifference then
    local Range = string.split(timeSlot, "^")[2]
    local Rangetbl = string.split(Range, "_")
    local startTime = tonumber(Rangetbl[1])
    local endTime = tonumber(Rangetbl[2])
    if TimeDifference >= startTime and TimeDifference <= endTime then
      return true
    end
  end
  return false
end

function TimeUtility.CheckServerOpenTimeLeOpen(content)
  local login = math.floor(LoginData.openServerTime / 1000)
  local y, m, d = string.match(content or "", "(%d+)_(%d+)_(%d+)")
  if not (y and m) or not d then
    return false
  end
  local year, month, day = tonumber(y), tonumber(m), tonumber(d)
  local local_utc_offset = os.time(os.date("*t")) - os.time(os.date("!*t"))
  local tz_diff = TimeUtility.TIMEZONES_SECONDS - local_utc_offset
  local timestamp_gmt7 = os.time({
    year = year,
    month = month,
    day = day
  }) + tz_diff
  local ret = login <= timestamp_gmt7
  return ret
end

function TimeUtility.ArriveACertainPointInTime(certainTimeStr, stamp)
  local curTime = stamp or Time.GetServerSecondTime()
  local certainTime = this.GetTimeStampByStr(certainTimeStr)
  local flag = curTime >= certainTime
  return flag
end

function TimeUtility.RefreshACertainPointInTime(certainTimeStr, updateTime)
  local updateTime = math.floor(updateTime / 1000)
  local refreshTime = this.GetTimeStampByStr(certainTimeStr)
  local nextRefreshTime = refreshTime
  if updateTime >= refreshTime then
    nextRefreshTime = refreshTime + 86400
  end
  local flag = false
  flag = nextRefreshTime <= Time.GetServerSecondTime()
  local refreshCountDown = math.abs(nextRefreshTime - Time.GetServerSecondTime())
  return flag, refreshCountDown
end

local weekDay

function TimeUtility.ArriveADayInWeek(wday, stamp)
  local curTime = Time.GetServerTime()
  if weekDay == nil or curTime > TimeUtility.nextDayStartTime then
    TimeUtility.nextDayStartTime = TimeUtility.GetDayTimeStamp(curTime + 86400)
    curTime = stamp or Time.GetServerTime()
    curTime = math.floor(curTime / 1000)
    local date = os.date("%A", curTime)
    weekDay = EWeekEnum[date]
  end
  local flag = weekDay == tonumber(wday)
  return flag
end

function TimeUtility.JudgeInWeek(wday, stamp)
  local curTime = stamp or Time.GetServerTime()
  curTime = math.floor(curTime / 1000)
  local weekDay = EWeekEnum[os.date("%A", curTime)]
  local flag
  if weekDay < tonumber(wday) then
    flag = 1
  elseif weekDay == tonumber(wday) then
    flag = 0
  else
    flag = -1
  end
  return flag, weekDay
end

function TimeUtility.RefreshADayInWeek(wday, updateTime)
  local flag = false
  local buyTime = math.floor(updateTime / 1000)
  local buyTimeTbl = os.date("*t", buyTime)
  local weekDay = EWeekEnum[os.date("%A", buyTime)]
  local refreshDay = 0
  refreshDay = wday - weekDay
  if wday <= weekDay then
    refreshDay = refreshDay + 7
  end
  buyTimeTbl.hour = 0
  buyTimeTbl.min = 0
  buyTimeTbl.sec = 0
  local nextRefreshTime = os.time(buyTimeTbl) + refreshDay * 86400
  flag = nextRefreshTime <= Time.GetServerSecondTime()
  local refreshCountDown = math.abs(nextRefreshTime - Time.GetServerSecondTime())
  return flag, refreshCountDown
end

local compareTbl

function TimeUtility.ArriveADayInMonth(day, stamp)
  local curTime = Time.GetServerTime()
  if compareTbl == nil or curTime > TimeUtility.nextDayStartTime then
    TimeUtility.nextDayStartTime = TimeUtility.GetDayTimeStamp(curTime + 86400)
    local compareTimeStamp = stamp or curTime
    compareTimeStamp = math.floor(compareTimeStamp / 1000)
    compareTbl = os.date("*t", compareTimeStamp)
  end
  local flag = day <= compareTbl.day
  return flag
end

function TimeUtility.RefreshADayInMonth(certainDay, updateTime)
  local updateTime = math.floor(updateTime / 1000)
  local updateTimeTbl = os.date("*t", updateTime)
  local refreshTime = os.time({
    year = updateTimeTbl.year,
    month = updateTimeTbl.month,
    day = certainDay,
    hour = 0
  })
  local nextRefreshTime = refreshTime
  if updateTime >= refreshTime then
    updateTimeTbl.month = updateTimeTbl.month + 1
    if updateTimeTbl.month > 12 then
      updateTimeTbl.month = 1
      updateTimeTbl.year = updateTimeTbl.year + 1
    end
    nextRefreshTime = os.time({
      year = updateTimeTbl.year,
      month = updateTimeTbl.month,
      day = certainDay,
      hour = 0
    })
  end
  local flag = false
  flag = nextRefreshTime <= Time.GetServerSecondTime()
  local refreshCountDown = math.abs(nextRefreshTime - Time.GetServerSecondTime())
  return flag, refreshCountDown
end

function TimeUtility.RefreshOpenServerDay(day)
  local currentLoginTime = RoleManager.me and Time.unscaledTime - RoleManager.me.data.roleLoginUnscaleTime or 0
  local RemainingDays = math.floor(LoginData.openServerTime / 1000 + currentLoginTime - day * ETimeSec.day)
  return RemainingDays == 0, RemainingDays
end

function TimeUtility.SecondApartFromTwoTime(sTime, eTime)
  local apartTime = eTime - sTime
  return apartTime
end

TimeUtility.TIMEZONES_SECONDS = 25200

function TimeUtility.SetTimeZones(value)
  if string.isNullOrEmpty(value) then
    return
  end
  local timeList = TableParse:SplitStringToIntList(value, ":")
  if table.count(timeList) < 2 then
    return
  end
  local hour = timeList[1]
  local min = timeList[2]
  local flag = 0 <= hour and 1 or -1
  TimeUtility.TIMEZONES_SECONDS = hour * ETimeSec.hour + flag * min * ETimeSec.min
end

function TimeUtility.DayApartFromTwoTime(sTime, eTime)
  sTime = math.floor(sTime / 1000)
  eTime = math.floor(eTime / 1000)
  local result = math.floor((sTime + this.TIMEZONES_SECONDS) / DAY_SECONDS) - math.floor((eTime + this.TIMEZONES_SECONDS) / DAY_SECONDS)
  return result
end

function TimeUtility.DayApartFromTwoTimeForSecond(sTime, eTime)
  local sTimeTbl = os.date("*t", sTime)
  local sTimeStamp = os.time({
    year = sTimeTbl.year,
    month = sTimeTbl.month,
    day = sTimeTbl.day,
    hour = 0,
    min = 0
  })
  local eTimeTbl = os.date("*t", eTime)
  local eTimeStamp = os.time({
    year = eTimeTbl.year,
    month = eTimeTbl.month,
    day = eTimeTbl.day,
    hour = 0,
    min = 0
  })
  local apartTime = Mathf.Abs(eTimeStamp - sTimeStamp)
  return apartTime / 86400
end

function TimeUtility.AddDay(stamp, days)
  stamp = math.floor(stamp / 1000) + days * ETimeSec.day
  return stamp
end

function TimeUtility.AddHour(stamp, hours)
  stamp = math.floor(stamp / 1000) + hours * ETimeSec.hour
  return stamp
end

function TimeUtility.AddMin(stamp, mins)
  stamp = math.floor(stamp / 1000) + mins * ETimeSec.min
  return stamp
end

function TimeUtility.RefreshSec(stamp)
  local refreshSec = stamp - Time.GetServerSecondTime()
  refreshSec = Mathf.Max(0, refreshSec)
  return refreshSec
end

function TimeUtility.RefreshSecToADay(stamp, days)
  stamp = math.floor(stamp / 1000) + days * ETimeSec.day
  local refreshSec = stamp - Time.GetServerSecondTime()
  refreshSec = Mathf.Max(0, refreshSec)
  return refreshSec
end

function TimeUtility.SwitchTimeStamp(stamp)
  stamp = math.floor(stamp / 1000)
  local sTimeTbl = os.date("*t", stamp)
  return string.format("%02d:%02d:%02d %d-%d-%d", sTimeTbl.hour, sTimeTbl.min, sTimeTbl.sec, sTimeTbl.day, sTimeTbl.month, sTimeTbl.year)
end

function TimeUtility.SwitchsecondStamp(stamp)
  if 2147483647 < stamp then
    stamp = 2147483647
  end
  local sTimeTbl = os.date("*t", stamp)
  return string.format("%d-%d-%d %02d:%02d:%02d", sTimeTbl.year, sTimeTbl.month, sTimeTbl.day, sTimeTbl.hour, sTimeTbl.min, sTimeTbl.sec)
end

function TimeUtility.SwitchHourStamp(stamp)
  if 2147483647 < stamp then
    stamp = 2147483647
  end
  local sTimeTbl = os.date("*t", stamp)
  return string.format("%02d:%02d:%02d", sTimeTbl.hour, sTimeTbl.min, sTimeTbl.sec)
end

function TimeUtility.SwitchMonthStamp(stamp)
  if 2147483647 < stamp then
    stamp = 2147483647
  end
  local sTimeTbl = os.date("*t", stamp)
  return string.format("%d-%d %02d:%02d:%02d", sTimeTbl.month, sTimeTbl.day, sTimeTbl.hour, sTimeTbl.min, sTimeTbl.sec)
end

function TimeUtility.SwitchMonthDayStamp(stamp)
  if 2147483647 < stamp then
    stamp = 2147483647
  end
  local sTimeTbl = os.date("*t", stamp)
  return string.format("%02d:%02d th\195\161ng %d ng\195\160y %d ", sTimeTbl.month, sTimeTbl.day, sTimeTbl.hour, sTimeTbl.min)
end

function TimeUtility.ShowTime(sec)
  local timeStr = ""
  if sec >= ETimeSec.day then
    local day = Mathf.Floor(sec / ETimeSec.day)
    local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Time_day"), day, hour)
  elseif sec >= ETimeSec.hour and sec < ETimeSec.day then
    local hour = Mathf.Floor(sec / ETimeSec.hour)
    local min = Mathf.Floor(sec % ETimeSec.hour / ETimeSec.min)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Time_hour"), hour, min)
  else
    local min = Mathf.Floor(sec / ETimeSec.min)
    local sec = Mathf.Floor(sec % ETimeSec.min)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Time_min"), min, sec)
  end
  return timeStr
end

function TimeUtility.ShowMinuteTime(minute)
  local timeStr = ""
  if minute >= ETimeMinute.day then
    local day = Mathf.Floor(minute / ETimeMinute.day)
    local hour = Mathf.Floor(minute % ETimeMinute.day / ETimeMinute.hour)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Time_day"), day, hour)
  elseif minute >= ETimeMinute.hour and minute < ETimeMinute.day then
    local hour = Mathf.Floor(minute / ETimeMinute.hour)
    local min = Mathf.Floor(minute % ETimeMinute.hour)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Time_hour"), hour, min)
  else
    timeStr = string.format("%d ph\195\186t ", minute)
  end
  return timeStr
end

function TimeUtility.ShowDayTime(sec)
  local timeStr = ""
  local day = Mathf.Floor(sec / ETimeSec.day)
  local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
  local min = Mathf.Floor(sec % ETimeSec.hour / ETimeSec.min)
  local sec = Mathf.Floor(sec % ETimeSec.min)
  timeStr = string.format(LocalizationUtility.GetContentByKey("Time_dhms"), day, hour, min, sec)
  return timeStr
end

function TimeUtility.ShowDayHourMin(sec)
  local timeStr = ""
  local day = Mathf.Floor(sec / ETimeSec.day)
  local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
  local min = Mathf.Ceil(sec % ETimeSec.hour / ETimeSec.min)
  timeStr = string.format(LocalizationUtility.GetContentByKey("Time_kfhd"), day, hour, min)
  return timeStr
end

function TimeUtility.ShowNewTime(sec)
  local timeStr = ""
  if sec >= ETimeSec.day then
    local day = Mathf.Floor(sec / ETimeSec.day)
    local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Preference_ExpUp_day"), day)
  elseif sec >= ETimeSec.hour and sec < ETimeSec.day then
    local hour = Mathf.Floor(sec / ETimeSec.hour)
    local min = Mathf.Floor(sec % ETimeSec.hour / ETimeSec.min)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Time_hour"), hour, min)
  else
    local min = Mathf.Floor(sec / ETimeSec.min)
    local sec = Mathf.Floor(sec % ETimeSec.min)
    timeStr = string.format(LocalizationUtility.GetContentByKey("Time_min"), min, sec)
  end
  return timeStr
end

function TimeUtility.ShowNewTimeMinuSec(sec)
  local timeStr = ""
  local min = Mathf.Floor(sec / ETimeSec.min)
  local sec = Mathf.Floor(sec % ETimeSec.min)
  timeStr = string.format("%02d:%02d", min, sec)
  return timeStr
end

function TimeUtility.ShowTimeWithColon(sec)
  local seconds = math.fmod(sec, 60)
  seconds = math.floor(seconds)
  local min = math.floor(sec / 60)
  local hour = math.floor(min / 60)
  local day = math.floor(hour / 24)
  local str = ""
  if tonumber(seconds) >= 0 and 60 > tonumber(seconds) then
    str = "" .. string.format("%02d", seconds)
  end
  if tonumber(min - hour * 60) >= 0 and 60 > tonumber(min - hour * 60) then
    str = "" .. string.format("%02d", min - hour * 60) .. ":" .. str
  end
  if tonumber(hour - day * 24) > 0 and 24 > tonumber(hour - day * 60) then
    str = string.format("%02d", hour - day * 24) .. ":" .. str
  end
  if tonumber(day) > 0 then
    str = day .. ":" .. str
  end
  return str
end

function TimeUtility.ShowTimeReserveWithColon(sec)
  local seconds = math.fmod(sec, 60)
  local min = math.floor(sec / 60)
  local hour = math.floor(min / 60)
  local day = math.floor(hour / 24)
  local str = ""
  if tonumber(seconds) >= 0 and 60 > tonumber(seconds) then
    str = "" .. string.format("%02d", seconds)
  end
  if tonumber(min - hour * 60) >= 0 and 60 > tonumber(min - hour * 60) then
    str = "" .. string.format("%02d", min - hour * 60) .. ":" .. str
  else
    str = "00:" .. str
  end
  if tonumber(hour - day * 24) >= 0 and 24 > tonumber(hour - day * 60) then
    str = string.format("%02d", hour - day * 24) .. ":" .. str
  else
    str = "00:" .. str
  end
  if tonumber(day) > 0 then
    str = day .. ":" .. str
  end
  return str
end

function TimeUtility.GetCurTimeZoneSecondTime()
  local curTime = Time.GetServerSecondTime()
  local timeTbl = os.date("*t", curTime)
  local limitTimeUnix = os.time({
    year = timeTbl.year,
    month = timeTbl.month,
    day = timeTbl.day,
    hour = timeTbl.hour,
    min = timeTbl.min,
    sec = timeTbl.sec
  })
  return limitTimeUnix
end

function TimeUtility.ShowTimeHour(sec)
  local seconds = math.floor(math.fmod(sec, 60))
  local min = math.floor(sec / 60)
  local hour = math.floor(min / 60)
  local str = ""
  if tonumber(seconds) >= 0 and 60 > tonumber(seconds) then
    str = "" .. string.format("%02d", seconds)
  end
  if tonumber(min - hour * 60) >= 0 and 60 > tonumber(min - hour * 60) then
    str = "" .. string.format("%02d", min - hour * 60) .. ":" .. str
  end
  if tonumber(hour) > 0 then
    str = string.format("%02d", hour) .. ":" .. str
  end
  return str
end

function TimeUtility.GetToNextDayTime()
  local serverTime = Time.GetServerSecondTime() + TimeUtility.TIMEZONES_SECONDS
  local surplusTime = Mathf.Floor(86400 - serverTime % 86400)
  return surplusTime
end

function TimeUtility.ShowHourTime(sec)
  local timeStr = ""
  local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
  local min = Mathf.Floor(sec % ETimeSec.hour / ETimeSec.min)
  local sec = Mathf.Floor(sec % ETimeSec.min)
  timeStr = string.format("%02d ti\225\186\191ng %02d ph\195\186t %02d gi\195\162y ", hour, min, sec)
  return timeStr
end

function TimeUtility.GetTimeByConture(utcTimestamp, timezoneOffset)
  if timezoneOffset == nil then
    timezoneOffset = 0
  end
  local localTimestamp = utcTimestamp + timezoneOffset + TimeUtility.TIMEZONES_SECONDS
  return os.date("!%H:%M", localTimestamp)
end

function TimeUtility.GetTimeByConture_YMDHM(utcTimestamp, timezoneOffset)
  if timezoneOffset == nil then
    timezoneOffset = 0
  end
  local localTimestamp = tonumber(utcTimestamp) + TimeUtility.TIMEZONES_SECONDS + timezoneOffset
  return os.date("!%Y-%m-%d %H:%M", localTimestamp)
end

function TimeUtility.GetTimeByConture_YMDHMS(utcTimestamp, timezoneOffset)
  if timezoneOffset == nil then
    timezoneOffset = 0
  end
  local localTimestamp = tonumber(utcTimestamp) + TimeUtility.TIMEZONES_SECONDS + timezoneOffset
  return os.date("!%Y-%m-%d %H:%M:%S", localTimestamp)
end

TimeUtility.MinTime = -1
TimeUtility.MaxTime = 9999999999999
TimeUtility.DayStamp = 86400000

function TimeUtility.CalcTimeStamp(config)
  local curTimeIndex = -1
  local isEnd = false
  for k = 1, #config do
    local curConfig = config[k]
    if curConfig ~= nil and 0 < #curConfig and curConfig[1] == EConditionEnum.timeBetween then
      curTimeIndex = k
      break
    end
  end
  local startTime, endTime
  if 0 < curTimeIndex and config[curTimeIndex] ~= nil and 1 < #config[curTimeIndex] then
    startTime, endTime = TimeUtility.GetSecondStamp(config[curTimeIndex][1], config[curTimeIndex][2])
    startTime = startTime - TimeUtility.TIMEZONES_SECONDS * 1000
    endTime = endTime - TimeUtility.TIMEZONES_SECONDS * 1000
  end
  local dayTime = TimeUtility.GetTodayTime(math.floor(Time.GetServerTime() * 0.001)) * 1000
  dayTime = dayTime - TimeUtility.TIMEZONES_SECONDS * 1000
  if endTime ~= nil and endTime < dayTime then
    isEnd = true
  end
  local startDay, endDay = TimeUtility.MinTime, TimeUtility.MaxTime
  local haveDayConfig = false
  for k = 1, #config do
    local curConfig = config[k]
    local result = TimeUtility.GetStartDayStamp(curConfig, isEnd)
    if result then
      haveDayConfig = true
      if result[TimeDayType.StartTime] == TimeUtility.MinTime then
        return TimeUtility.MinTime, TimeUtility.MinTime
      end
      if result[TimeDayType.StartTime] ~= TimeUtility.MinTime then
        if startDay < result[TimeDayType.StartTime] then
          startDay = result[TimeDayType.StartTime]
        end
        if endDay > result[TimeDayType.EndTime] then
          endDay = result[TimeDayType.EndTime]
        end
      end
    end
  end
  if haveDayConfig == false and startTime ~= nil then
    local addDayTime = isEnd and 1 or 0
    startDay = Time.GetServerDayTime() + addDayTime * TimeUtility.DayStamp
    endDay = startDay + addDayTime * TimeUtility.DayStamp
  end
  local curStartTime, curEndTime = startDay, endDay
  if 0 < curStartTime and startTime ~= nil and endTime ~= nil then
    curEndTime = curStartTime + endTime
    curStartTime = curStartTime + startTime
  end
  return curStartTime, curEndTime
end

function TimeUtility.GetStartDayStamp(timeConfig, isEnd)
  if type(isEnd) ~= "boolean" then
    isEnd = false
  end
  if #timeConfig < 2 then
    return
  end
  local typeId = timeConfig[1]
  local param = timeConfig[2]
  if typeId >= EConditionEnum.timeOpenServerMoreThan and typeId <= EConditionEnum.timeOpenServerMoreNoEqual then
    return TimeUtility.GetOpenServerTimeStartStamp(typeId, param, isEnd)
  elseif typeId == EConditionEnum.timeWeekendMoreThanOrEqual then
    return TimeUtility.GetWeekStartStamp(typeId, param, isEnd)
  elseif typeId >= EConditionEnum.timeCommerceServerMoreThan and typeId <= EConditionEnum.timeCommerceServerMoreNoEqual then
    return TimeUtility.GetCommerceServerTimeStartStamp(typeId, param, isEnd)
  elseif typeId >= EConditionEnum.timeActivityBetween and typeId <= EConditionEnum.timeOpenServerCrossBetween then
    return TimeUtility.GetActivityStartStamp(typeId, param, isEnd)
  end
end

function TimeUtility.GetSecondStamp(typeId, param)
  if typeId ~= EConditionEnum.timeBetween then
    return
  end
  local timeList = string.split(param, "-")
  if #timeList < 2 then
    return
  end
  local startTime = TimeUtility.AnalysisCurTime(timeList[1])
  if startTime == nil then
    return
  end
  local endTime = TimeUtility.AnalysisCurTime(timeList[2])
  if endTime == nil then
    return
  end
  return startTime, endTime
end

function TimeUtility.AnalysisCurTime(timeConfig)
  if type(timeConfig) ~= "string" then
    return
  end
  local timeList = string.split(timeConfig, ":")
  if #timeList < 3 then
    return
  end
  local hour = tonumber(timeList[1]) * 3600000
  local min = tonumber(timeList[2]) * 60000
  local sec = tonumber(timeList[3]) * 1000
  return hour + min + sec
end

function TimeUtility.AnalyseActivityYearMonthDayTime(timeConfig)
  if type(timeConfig) ~= "string" then
    return TimeUtility.MinTime
  end
  local timeList = string.split(timeConfig, "_")
  if #timeList < 3 then
    return TimeUtility.MinTime
  end
  local serverTimeAdvance = 0
  if type(LoginData.ServerTimeAdvance) == "number" then
    serverTimeAdvance = LoginData.ServerTimeAdvance
  end
  local time = DateToServerTime({
    year = tonumber(timeList[1]),
    month = tonumber(timeList[2]),
    day = tonumber(timeList[3]),
    hour = 0
  })
  return (time - serverTimeAdvance * ETimeSec.day) * 1000
end

function TimeUtility.GetOpenServerTimeStartStamp(typeId, param, isEnd)
  if isEnd == nil then
    isEnd = false
  end
  local openServerTime = LoginData.GetOpenServerDay()
  local configTime = tonumber(param)
  local startTime, endTime = Time.GetServerDayTime(), TimeUtility.MaxTime
  local addDayTime = isEnd and 1 or 0
  if typeId == EConditionEnum.timeOpenServerMoreThan then
    if configTime < openServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = LoginData.openServerTime + (configTime + 1) * TimeUtility.DayStamp
    end
  elseif typeId == EConditionEnum.timeOpenServerMoreThanOrEqual then
    if configTime <= openServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = LoginData.openServerTime + configTime * TimeUtility.DayStamp
    end
  elseif typeId == EConditionEnum.timeOpenServerMoreEqual then
    if openServerTime + addDayTime == configTime then
      startTime = LoginData.openServerTime + configTime * TimeUtility.DayStamp
      endTime = startTime + TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
  elseif typeId == EConditionEnum.timeOpenServerMoreMinOrEqual then
    if configTime >= openServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
    endTime = LoginData.openServerTime + configTime * TimeUtility.DayStamp
  elseif typeId == EConditionEnum.timeOpenServerMoreMin then
    if configTime > openServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
    endTime = LoginData.openServerTime + (configTime - 1) * TimeUtility.DayStamp
  elseif typeId == EConditionEnum.timeOpenServerMoreNoEqual then
    if configTime > openServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
      endTime = LoginData.openServerTime + (configTime - 1) * TimeUtility.DayStamp
    elseif configTime < openServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
  end
  return {
    [TimeDayType.StartTime] = startTime,
    [TimeDayType.EndTime] = endTime
  }
end

function TimeUtility.GetCommerceServerTimeStartStamp(typeId, param, isEnd)
  if isEnd == nil then
    isEnd = false
  end
  local CommerceServerTime = TimeUtility.GetCommerceDay()
  local configTime = tonumber(param)
  local startTime, endTime = Time.GetServerDayTime(), TimeUtility.MaxTime
  local addDayTime = isEnd and 1 or 0
  if typeId == EConditionEnum.timeCommerceServerMoreThan then
    if configTime < CommerceServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = Time.GetCommerceTime() + (configTime + 1) * TimeUtility.DayStamp
    end
  elseif typeId == EConditionEnum.timeCommerceServerMoreThanOrEqual then
    if configTime <= CommerceServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = Time.GetCommerceTime() + configTime * TimeUtility.DayStamp
    end
  elseif typeId == EConditionEnum.timeCommerceServerMoreEqual then
    if CommerceServerTime + addDayTime == configTime then
      startTime = Time.GetCommerceTime() + configTime * TimeUtility.DayStamp
      endTime = startTime + TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
  elseif typeId == EConditionEnum.timeCommerceServerMoreMinOrEqual then
    if configTime >= CommerceServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
    endTime = Time.GetCommerceTime() + configTime * TimeUtility.DayStamp
  elseif typeId == EConditionEnum.timeCommerceServerMoreMin then
    if configTime > CommerceServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
    endTime = Time.GetCommerceTime() + (configTime - 1) * TimeUtility.DayStamp
  elseif typeId == EConditionEnum.timeCommerceServerMoreNoEqual then
    if configTime > CommerceServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
      endTime = Time.GetCommerceTime() + (configTime - 1) * TimeUtility.DayStamp
    elseif configTime < openServerTime + addDayTime then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
  end
  return {
    [TimeDayType.StartTime] = startTime,
    [TimeDayType.EndTime] = endTime
  }
end

function TimeUtility.GetWeekStartStamp(typeId, param, isEnd)
  local targetWeek = tonumber(param)
  local weekDay = TimeUtility.GetWeekTime(Time.GetServerTime())
  if targetWeek < weekDay and weekDay == targetWeek and isEnd == true then
    targetWeek = targetWeek + 7
  end
  local remainDay = targetWeek - weekDay
  return {
    [TimeDayType.StartTime] = Time.GetServerDayTime() + remainDay * TimeUtility.DayStamp,
    [TimeDayType.EndTime] = Time.GetServerDayTime() + (remainDay + 1) * TimeUtility.DayStamp
  }
end

function TimeUtility.GetActivityStartStamp(typeId, param, isEnd)
  if isEnd == nil then
    isEnd = false
  end
  local startTime, endTime = Time.GetServerDayTime(), TimeUtility.MaxTime
  local addDayTime = isEnd and 1 or 0
  if typeId == EConditionEnum.timeActivityBetween then
    local timeStrArray = string.split(param, "-")
    local configStartTime, configEndTime
    if 1 < #timeStrArray then
      configStartTime = TimeUtility.AnalyseActivityYearMonthDayTime(timeStrArray[1])
      configEndTime = TimeUtility.AnalyseActivityYearMonthDayTime(timeStrArray[2]) + TimeUtility.DayStamp
      if configStartTime == TimeUtility.MinTime or configEndTime == TimeUtility.MinTime then
        startTime = TimeUtility.MinTime
      elseif configStartTime > startTime then
        startTime = configStartTime
        endTime = configEndTime
      elseif configEndTime < startTime then
        startTime = TimeUtility.MinTime
      else
        endTime = configEndTime
      end
    else
      startTime = TimeUtility.MinTime
    end
  elseif typeId == EConditionEnum.timeOpenServerBetween then
    if TimeUtility.OpenServerTimeDesignatesRange(param) then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
  elseif typeId == EConditionEnum.timeOpenServerCrossBetween then
    if TimeUtility.InTweenyearTimeRemoteOpen(param) then
      startTime = startTime + addDayTime * TimeUtility.DayStamp
    else
      startTime = TimeUtility.MinTime
    end
  end
  return {
    [TimeDayType.StartTime] = startTime,
    [TimeDayType.EndTime] = endTime
  }
end

function TimeUtility.GetWeekTime(timeStamp)
  local buyTime = math.floor(timeStamp / 1000)
  local weekDay = EWeekEnum[os.date("%A", buyTime)]
  return weekDay
end

function TimeUtility.CheckIsServerSameDay(timeStamp)
  if type(timeStamp) ~= "number" or timeStamp <= 0 then
    return false
  end
  local curserverTime = Time.GetServerTime()
  if curserverTime <= 0 then
    return 0
  end
  local serverTime = os.date("%Y%m%d", math.floor(curserverTime * 0.001))
  local inputTime = os.date("%Y%m%d", timeStamp)
  return serverTime == inputTime
end

function TimeUtility.GetRemainDay(timeStamp)
  if type(timeStamp) ~= "number" then
    return 0
  end
  local serverTime = Time.GetServerTime()
  if serverTime <= 0 then
    return 0
  end
  return math.floor((timeStamp - serverTime) / TimeUtility.DayStamp)
end

function TimeUtility.GetRemainTime(timeStamp)
  if type(timeStamp) ~= "number" then
    return 0
  end
  local serverTime = Time.GetServerTime()
  if serverTime <= 0 then
    return 0
  end
  return timeStamp - serverTime
end

function TimeUtility.GetRemainSecTime(timeStamp)
  if type(timeStamp) ~= "number" then
    return 0
  end
  local serverTime = Time.GetServerTime()
  if serverTime <= 0 then
    return 0
  end
  return math.floor((timeStamp - serverTime) * 0.001)
end

function TimeUtility.GetTodayTime(timeStamp)
  if type(timeStamp) ~= "number" then
    return 0
  end
  local time = os.date("!*t", 1783603924 + TimeUtility.TIMEZONES_SECONDS)
  return time.hour * 3600 + time.min * 60 + time.sec
end

function TimeUtility.GetCommerceDay()
  local CommerceDay = TimeUtility.DayApartFromTwoTime(Time.GetServerTime(), Time.GetCommerceTime()) + 1
  return CommerceDay
end

function TimeUtility.GetCommercePlayerDay()
  local CommerceDay = TimeUtility.DayApartFromTwoTime(Time.GetServerTime(), LoginData.createTime * 1000) + 1
  return CommerceDay
end

function TimeUtility.GetNetTenMinutes()
  local now = Time.GetServerSecondTime()
  local currMin = math.floor(now % 600)
  local remainingSecs = 600 - currMin
  return remainingSecs
end

function TimeUtility.GetServerDateByTime(format, serverTime)
  return TimeToServerDate(format, serverTime or Time.GetServerSecondTime())
end

function TimeUtility.GetServerTimeByDateTab(timeTab)
  if not timeTab then
    return Time.GetServerSecondTime()
  end
  return DateToServerTime(timeTab)
end
