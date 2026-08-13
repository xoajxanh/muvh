AnniversaryActivity_ActivityData = {}
AnniversaryActivity_ActivityData.AllActivityData = {}
AnniversaryActivity_ActivityData.ActivityTogId = {}
AnniversaryActivity_ActivityData.HolidayTogIdInfo = {}
TaskStateEnum = {
  CanNotGet = enum(1),
  CanGet = enum(2),
  Got = enum(3)
}

function AnniversaryActivity_ActivityData.SetAllActivityData(data)
  if data then
    AnniversaryActivity_ActivityData.AllActivityData = data
  end
end

function AnniversaryActivity_ActivityData.GetAllActivityData()
  return AnniversaryActivity_ActivityData.AllActivityData
end

function AnniversaryActivity_ActivityData.GetActivityTog(index)
  local TogGroup = AnniversaryActivity_ActivityData.ActivityTogId
  AnniversaryActivity_ActivityData.HolidayTogIdInfo = {}
  for i, id in pairs(TogGroup) do
    local cfgTabList = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", id)
    for _index, cfgData in ipairs(cfgTabList) do
      if cfgData.condition and ConditionManager.Check(cfgData.condition) then
        if i == index then
          cfgData.Selected = true
        else
          cfgData.Selected = false
        end
        table.insert(AnniversaryActivity_ActivityData.HolidayTogIdInfo, cfgData)
        break
      end
    end
  end
  return AnniversaryActivity_ActivityData.HolidayTogIdInfo
end

function AnniversaryActivity_ActivityData.GetActivityByGroupId(group)
  return ClientTable.cfg_Commerce_overviewManager:TryGetValue(group, "group")
end
