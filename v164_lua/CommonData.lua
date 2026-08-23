CommonData = {}
local this = CommonData

function CommonData.Init()
  this.takeWeek = nil
  this.takeDays = nil
end

function CommonData.CurrentTakeWeek(curWeek)
  if curWeek ~= nil then
    this.takeWeek = curWeek.openWeek
  end
end
