EventContainer = class()

function EventContainer:ctor(manager)
  self.manager = manager
  self.events = {}
end

function EventContainer:Regist(type, func, data, priority)
  if self:Find(type, func, data) then
    return
  end
  self.manager.Regist(type, func, data, priority)
  table.insert(self.events, {
    type,
    func,
    data
  })
end

function EventContainer:UnRegist(type, func, data)
  self.manager:UnRegist(type, func, data)
  local index = self:Find(type, func, data)
  if index then
    table.remove(self.events, index)
  end
end

function EventContainer:UnRegistAll()
  for k, v in ipairs(self.events) do
    self.manager.UnRegist(v[1], v[2], v[3])
  end
  self.events = {}
end

function EventContainer:Find(type, func, data)
  for k, v in ipairs(self.events) do
    if v[1] == type and v[2] == func and v[3] == data then
      return k
    end
  end
  return nil
end
