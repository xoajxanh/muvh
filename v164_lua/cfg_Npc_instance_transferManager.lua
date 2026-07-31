local cfg_Npc_instance_transferManager = {}

function cfg_Npc_instance_transferManager:GetName()
  return "cfg_Npc_instance_transferManager"
end

function cfg_Npc_instance_transferManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Npc_instance_transfer")
  end
  return self.dic
end

setmetatable(cfg_Npc_instance_transferManager, TableManagerBase)

function cfg_Npc_instance_transferManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

cfg_Npc_instance_transferManager.Npc_Instance_TransferDic = nil

function cfg_Npc_instance_transferManager:GetNpc_Instance_TransferList(npcId)
  if type(self:GetDic()) ~= "table" then
    return
  end
  if type(self.Npc_Instance_TransferDic) ~= "table" then
    self:InitNpc_Instance_TransferDic()
    self:SortNpc_Instance_TransferDic()
  end
  return self.Npc_Instance_TransferDic[npcId]
end

function cfg_Npc_instance_transferManager:InitNpc_Instance_TransferDic()
  if self.Npc_Instance_TransferDic == nil then
    self.Npc_Instance_TransferDic = {}
  end
  for k, v in pairs(self:GetDic()) do
    local tbl = v
    local transferList = self.Npc_Instance_TransferDic[tbl.npcId]
    if transferList == nil then
      self.Npc_Instance_TransferDic[tbl.npcId] = {}
      transferList = self.Npc_Instance_TransferDic[tbl.npcId]
    end
    table.insert(transferList, tbl)
  end
end

function cfg_Npc_instance_transferManager:SortNpc_Instance_TransferDic()
  if type(self:GetDic()) ~= "table" then
    return
  end
  for k, v in pairs(self:GetDic()) do
    local transferlist = v
    table.sort(transferlist, function(a, b)
      return a.index < b.index
    end)
  end
end

function cfg_Npc_instance_transferManager:GetAllTabsByNpcId(_npcId)
  local dicTabs = {}
  for index, value in pairs(self:GetDic()) do
    if value.npcId == _npcId then
      local mIndex = tonumber(value.index)
      if dicTabs[mIndex] == nil then
        dicTabs[mIndex] = {}
      end
      table.insert(dicTabs[mIndex], value)
    end
  end
  for key, value in pairs(dicTabs) do
    table.sort(value, function(a, b)
      if a.id and b.id then
        return a.id < b.id
      else
        return false
      end
    end)
  end
  return dicTabs
end

return cfg_Npc_instance_transferManager
