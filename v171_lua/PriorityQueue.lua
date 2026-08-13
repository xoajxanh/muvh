local floor = math.floor
PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

function PriorityQueue:New(compareCallBack)
  local o = {
    heap = {},
    current_size = 0,
    compareCallBack = compareCallBack
  }
  setmetatable(o, self)
  return o
end

function PriorityQueue:Empty()
  return self.current_size == 0
end

function PriorityQueue:Size()
  return self.current_size
end

function PriorityQueue:Swim()
  local heap = self.heap
  local floor = floor
  local i = self.current_size
  while floor(i / 2) > 0 do
    local half = floor(i / 2)
    if self.compareCallBack(heap[i], heap[half]) then
      heap[i], heap[half] = heap[half], heap[i]
    else
      break
    end
    i = half
  end
end

function PriorityQueue:Put(p)
  self.heap[self.current_size + 1] = p
  self.current_size = self.current_size + 1
  self:Swim()
end

function PriorityQueue:Sink()
  local size = self.current_size
  local heap = self.heap
  local i = 1
  while size >= i * 2 do
    local mc = self:Min_child(i)
    if not self.compareCallBack(heap[i], heap[mc]) then
      heap[i], heap[mc] = heap[mc], heap[i]
    else
      break
    end
    i = mc
  end
end

function PriorityQueue:Min_child(i)
  if i * 2 + 1 > self.current_size then
    return i * 2
  elseif self.compareCallBack(self.heap[i * 2], self.heap[i * 2 + 1]) then
    return i * 2
  else
    return i * 2 + 1
  end
end

function PriorityQueue:Pop()
  local heap = self.heap
  local retval = heap[1]
  heap[1] = heap[self.current_size]
  heap[self.current_size] = nil
  self.current_size = self.current_size - 1
  self:Sink()
  return retval
end

function PriorityQueue:Top()
  local heap = self.heap
  local retval = heap[1]
  return retval
end
