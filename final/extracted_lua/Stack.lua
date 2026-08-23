Stack = {}
Stack.__index = Stack
local tinsert = table.insert

function Stack:New()
  local o = {
    dataTb = {}
  }
  setmetatable(o, self)
  return o
end

function Stack:Push(...)
  local arg = {
    ...
  }
  self.dataTb = self.dataTb or {}
  if next(arg) then
    for i = 1, #arg do
      tinsert(self.dataTb, arg[i])
    end
  end
end

function Stack:Pop(num)
  num = num or 1
  assert(0 < num, "num ph\225\186\163i l\195\160 s\225\187\145 nguy\195\170n d\198\176\198\161ng")
  local popTb = {}
  for i = 1, num do
    tinsert(popTb, self.dataTb[#self.dataTb])
    table.remove(self.dataTb)
  end
  return unpack(popTb)
end

function Stack:Peek()
  return self.dataTb[#self.dataTb]
end

function Stack:List()
  for i = #self.dataTb, 1, -1 do
    logOrange(i, self.dataTb[i].name, self.dataTb[i].logicTbl.rank)
  end
end

function Stack:Count()
  return #self.dataTb
end

function Stack:IsEmpty()
  return #self.dataTb == 0
end
