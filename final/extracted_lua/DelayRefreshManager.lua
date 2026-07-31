local DelayRefreshManager = {}

function DelayRefreshManager:Init()
  self.infoDic = {}
end

function DelayRefreshManager:Add(callBack, time, isReset)
  if self.infoDic == nil then
    self.infoDic = {}
  end
  if isReset == true or self.infoDic[callBack] == nil then
    self.infoDic[callBack] = time
  end
end

function DelayRefreshManager:Update()
  if self.infoDic == nil then
    self.infoDic = {}
  end
  for i, v in pairs(self.infoDic) do
    if 0 < v then
      self.infoDic[i] = v - Time.deltaTime
    else
      i()
      self.infoDic[i] = nil
    end
  end
end

return DelayRefreshManager
