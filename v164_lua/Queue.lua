Queue = {}
Queue.__index = Queue

function Queue:New()
  local o = {
    first = 0,
    last = -1,
    dataTb = {}
  }
  setmetatable(o, self)
  return o
end

function Queue:PushFirst(value)
  self.first = self.first - 1
  self.dataTb[self.first] = value
end

function Queue:PushLast(value)
  self.last = self.last + 1
  self.dataTb[self.last] = value
end

function Queue:PopFirst()
  if self.first > self.last then
    logPurple("queue is empty")
    return
  end
  local value = self.dataTb[self.first]
  self.dataTb[self.first] = nil
  self.first = self.first + 1
  return value
end

function Queue:PopLast()
  if self.first > self.last then
    logPurple("queue is empty")
    return
  end
  local value = self.dataTb[self.last]
  self.dataTb[self.last] = nil
  self.last = self.last - 1
  return value
end

function Queue:IsEmpty()
  return self.first > self.last
end

function Queue:Count()
  if self.first > self.last then
    return 0
  end
  return Mathf.Abs(Mathf.Abs(self.last) - Mathf.Abs(self.first)) + 1
end

function Queue:LastValue()
  if self.first > self.last then
    logPurple("queue is empty")
    return
  end
  local value = self.dataTb[self.last]
  return value
end

function Queue:GetValueByIndex(index)
  if self.first > self.last then
    logPurple("queue is empty")
    return
  end
  index = index - 1 + self.first
  local value = self.dataTb[index]
  return value
end

function Queue:Clear()
  self.first = 0
  self.last = -1
  self.dataTb = {}
end
