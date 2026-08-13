ItemboxDisplayManager = {}
local this = ItemboxDisplayManager

function ItemboxDisplayManager.Init()
  local boxShowCfg = ClientTable.cfg_Box_showManager:GetDic()
  this.boxMap = {}
  for k, v in pairs(boxShowCfg) do
    if not this.boxMap[v.boxId] then
      this.boxMap[v.boxId] = {}
    end
    table.insert(this.boxMap[v.boxId], v)
  end
end

function ItemboxDisplayManager.GetBox(career, boxid)
  local boxes = this.boxMap[boxid]
  local result = {}
  for i = 1, #boxes do
    if boxes[i].career == "0" or string.contains(boxes[i].career, tostring(ViewData.meData.career)) then
      table.insert(result, boxes[i])
    end
  end
  table.sort(result, function(a, b)
    if a ~= nil and b ~= nil then
      if a.id and b.id then
        return a.id < b.id
      else
        return false
      end
    else
      return false
    end
  end)
  return result
end

function ItemboxDisplayManager.GenerateItemShowData(boxShowCfg)
  local data = ItemUtility.GenerateItemData(boxShowCfg.itemId)
  data.intensify = boxShowCfg.strRange
  data.additional = boxShowCfg.addRange
  data.skill = boxShowCfg.orSkill > 0
  data.luck = ItemUtility.GetEquipeLuckIds(0 < boxShowCfg.orLucky) or {}
  return data
end

this.Init()
