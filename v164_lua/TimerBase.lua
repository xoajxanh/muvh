local TimerBase = {}
local this = TimerBase
local timers = {}
local updating = false

function TimerBase.Start(time, func, ...)
  return this.StartLoop(time, 1, func, ...)
end

function TimerBase.StartLoop(time, count, func, ...)
  local t = {
    time = time,
    nextTime = this.GetTime() + time,
    count = count,
    func = func,
    args = spack(...),
    isRunning = true
  }
  table.insert(timers, t)
  return t
end

function TimerBase.StartLoopForever(time, func, ...)
  return this.StartLoop(time, -1, func, ...)
end

function TimerBase.Stop(t)
  if t == nil then
    return
  end
  if updating then
    t.count = 0
    t.isRunning = false
  else
    local index = array.indexOf(timers, t)
    if index then
      table.remove(timers, index)
      t.isRunning = false
    end
  end
end

function TimerBase.Update()
  updating = true
  local now = this.GetTime()
  local count = #timers
  local i = 1
  while count >= i do
    local t = timers[i]
    local remove = false
    if t.count == 0 then
      remove = true
    elseif now >= t.nextTime then
      t.func(sunpack(t.args))
      if t.count == 1 then
        remove = true
      else
        if 1 < t.count then
          t.count = t.count - 1
        end
        t.nextTime = t.nextTime + t.time
      end
    end
    if remove then
      timers[i].isRunning = false
      table.remove(timers, i)
      count = count - 1
    else
      i = i + 1
    end
  end
  updating = false
end

function TimerBase.GetTime()
  return 0
end

return TimerBase
