GmMessageData = {}
local this = GmMessageData
this.AllMessageData = {}
this.FindMessageData = {}
this.EveryTypeMessageLength = 400

function GmMessageData.GetMessageDataManager(data)
  if data == nil then
    return nil
  end
  if data.type == GM_DataEnum.All then
    return this.GetAllMessageData()
  elseif data.type == GM_DataEnum.NetWork or data.type == GM_DataEnum.Log then
    return this.GetMessageByTypeData(data.type)
  else
    return this.FindRelatedIdData(data.id)
  end
end

function GmMessageData.RemoveMessageDataManager(type)
  if type == nil then
    return
  end
  if type == GM_DataEnum.All then
    this.RemoveAllMessageData()
  elseif type == GM_DataEnum.NetWork or type == GM_DataEnum.Log then
    this.RemoveTypeMessageData(type)
  end
end

function GmMessageData.GetTypeDataLength(type)
  if type == nil then
    return nil
  end
  return table.count(this.AllMessageData[type])
end

function GmMessageData.GetMessageByTypeData(type)
  return this.AllMessageData[type]
end

function GmMessageData.GetAllMessageData()
  local allMessageDataTab = {}
  for i = 1, table.count(this.AllMessageData) do
    if table.count(this.AllMessageData[i]) > 0 then
      table.combine(allMessageDataTab, this.AllMessageData[i])
    end
  end
  return allMessageDataTab
end

function GmMessageData.RemoveTypeMessageData(type)
  this.AllMessageData[type] = {}
end

function GmMessageData.RemoveAllMessageData()
  this.AllMessageData[GM_DataEnum.NetWork] = {}
  this.AllMessageData[GM_DataEnum.Log] = {}
  this.FindMessageData = {}
end

function GmMessageData.FindRelatedIdData(id)
  this.FindMessageData = {}
  for type = 1, table.count(this.AllMessageData) do
    if table.count(this.AllMessageData[type]) > 0 then
      for index = 1, table.count(this.AllMessageData[type]) do
        if this.AllMessageData[type][index].id == id then
          table.insert(this.FindMessageData, this.AllMessageData[type][index])
        end
      end
    end
  end
  return this.FindMessageData
end

function GmMessageData.Init()
  this.AllMessageData[GM_DataEnum.NetWork] = {}
  this.AllMessageData[GM_DataEnum.Log] = {}
end

function GmMessageData.UpdateMessageData(data)
  if data == nil then
    return
  end
  local data = data
  if this.GetTypeDataLength(data.type) > this.EveryTypeMessageLength then
    this.RemoveTypeMessageFirstData(data.type)
  end
  this.AddTypeMessageData(data)
end

function GmMessageData.AddTypeMessageData(data)
  table.insert(this.AllMessageData[data.type], data)
end

function GmMessageData.RemoveTypeMessageFirstData(type)
  if table.count(this.AllMessageData[type]) > 0 then
    table.remove(this.AllMessageData[type], 1)
  end
end
