EquipRedemptionData = {}
local this = EquipRedemptionData
this.equipGetData = {}
this.equipLostData = {}
this.equipGetUnOverTimeData = {}
this.equipLostUnOverTimeData = {}

function EquipRedemptionData.InitData(data)
  this.Reset()
  this.equipGetData = data.canRansom
  this.equipLostData = data.detainItem
  EventManager.Dispatch(Event.EquipRedemptionRefresh)
end

function EquipRedemptionData.GetEquipGetUnOverTime()
  this.equipGetUnOverTimeData = {}
  for i = 1, #this.equipGetData do
    if Time.GetServerTime() < this.equipGetData[i].overTime then
      table.insert(this.equipGetUnOverTimeData, this.equipGetData[i])
    end
  end
  return this.equipGetUnOverTimeData
end

function EquipRedemptionData.GetEquipLostUnOverTime()
  this.equipLostUnOverTimeData = {}
  for i = 1, #this.equipLostData do
    if Time.GetServerTime() < this.equipLostData[i].overTime then
      table.insert(this.equipLostUnOverTimeData, this.equipLostData[i])
    end
  end
  return this.equipLostUnOverTimeData
end

function EquipRedemptionData.Reset()
  this.equipGetData = {}
  this.equipLostData = {}
  this.equipGetUnOverTimeData = {}
  this.equipLostUnOverTimeData = {}
end
