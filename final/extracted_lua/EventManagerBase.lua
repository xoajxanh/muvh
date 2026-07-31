local EventManagerBase = {}
local this = EventManagerBase
local events = {}
local dispatchCount = 0
local curDispatchTbl = {}
local savedRegists = {}
local savedUnRegists = {}

function EventManagerBase.Regist(id, func, owner, priority)
  if not id then
    return
  end
  if not func then
    logError("\196\144ang c\225\187\145 g\225\186\175ng \196\145\196\131ng k\195\189 ph\198\176\198\161ng th\225\187\169c tr\225\187\145ng, EventId", id)
    return
  end
  if this.IsDispatching(id) then
    table.insert(savedRegists, {
      id,
      func,
      owner
    })
    return
  end
  local items = events[id]
  if not items then
    items = {}
    events[id] = items
  end
  priority = priority or 0
  local index
  for k, v in ipairs(items) do
    if priority < v[3] then
      index = k
      break
    end
  end
  table.insert(items, index or #items + 1, {
    func,
    owner,
    priority
  })
end

function EventManagerBase.UnRegist(id, func, owner)
  local items = events[id]
  if not items then
    return false
  end
  if this.IsDispatching(id) then
    table.insert(savedUnRegists, {
      id,
      func,
      owner
    })
    return
  end
  for k, v in ipairs(items) do
    if v[1] == func and v[2] == owner then
      table.remove(items, k)
      return true
    end
  end
  return false
end

function EventManagerBase.Dispatch(id, message, sequence)
  local items = events[id]
  if not items then
    return false
  end
  this.BeginDispatch(id)
  for k, v in ipairs(items) do
    if v[2] then
      local callRet, err = xpcall(v[1], debug.traceback, v[2], id, message, sequence)
      if not callRet then
        logError(err)
      end
    else
      local callRet, err = xpcall(v[1], debug.traceback, id, message, sequence)
      if not callRet then
        logError(err)
      end
    end
  end
  this.EndDispatch(id)
end

function EventManagerBase.HasCallback(id)
  local items = events[id]
  return items and 0 < #items
end

function EventManagerBase.BeginDispatch(id)
  curDispatchTbl[id] = true
  dispatchCount = dispatchCount + 1
end

function EventManagerBase.EndDispatch(id)
  curDispatchTbl[id] = false
  dispatchCount = dispatchCount - 1
  if 0 < dispatchCount then
    return
  end
  if savedUnRegists and 0 < #savedUnRegists then
    for k, v in ipairs(savedUnRegists) do
      this.UnRegist(v[1], v[2], v[3])
    end
    savedUnRegists = {}
  end
  if savedRegists and 0 < #savedRegists then
    for k, v in ipairs(savedRegists) do
      this.Regist(v[1], v[2], v[3], v[4])
    end
    savedRegists = {}
  end
end

function EventManagerBase.IsDispatching(id)
  if curDispatchTbl[id] then
    return true
  end
end

return EventManagerBase
