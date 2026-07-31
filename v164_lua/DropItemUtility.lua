local jumpHeight = 6
local jumpSpeed = 1.5
local rotateAngle = 720
local DropItemDirTable = {
  ["1"] = Vector3(0, 0, 0),
  ["2"] = Vector3(-100, 0, -100),
  ["3"] = Vector3(-100, 0, 0),
  ["4"] = Vector3(0, 0, -100),
  ["5"] = Vector3(45, 180, -100),
  ["6"] = Vector3(0, 0, 0),
  ["11"] = Vector3(0, 225, 0),
  ["51"] = Vector3(45, 180, 0)
}
setmetatable(DropItemDirTable, {
  __index = function()
    return Vector3(0, 0, 0)
  end
})
local DropItemOffsetTable = {
  ["1"] = function(offsetY)
    return nil, tonumber(offsetY)
  end,
  ["2"] = function(offsetY)
    return nil, tonumber(offsetY)
  end,
  ["3"] = function(offsetY)
    return nil, tonumber(offsetY)
  end,
  ["4"] = function(offsetY)
    return nil, tonumber(offsetY)
  end,
  ["5"] = function(offsetY)
    return tonumber(offsetY), nil
  end,
  ["6"] = function(offsetY)
    return tonumber(offsetY), nil
  end,
  ["11"] = function(offsetY)
    return tonumber(offsetY), nil
  end,
  ["51"] = function(offsetY)
    return tonumber(offsetY), nil
  end
}
setmetatable(DropItemOffsetTable, {
  __index = function()
    return function(offsetY)
      return nil, nil
    end
  end
})
local GoldModelChoiceTable = {
  [1] = function()
    local index = Mathf.Random(1, 3)
    return string.format("Gold%02d", index)
  end,
  [2] = function()
    local index = Mathf.Random(4, 6)
    return string.format("Gold%02d", index)
  end,
  [3] = function()
    local index = Mathf.Random(7, 9)
    return string.format("Gold%02d", index)
  end
}
local DropItemLevelColorTable = {
  [101] = function()
    return Color.white, Color.black
  end,
  [102] = function()
    return Color.white, Color.black
  end,
  [103] = function()
    return Color.orange, Color.black
  end,
  [104] = function()
    return Color.blue, Color.black
  end,
  [105] = function()
    return Color.yellow, Color.black
  end,
  [106] = function()
    return Color.green, Color.black
  end,
  [107] = function()
    return Color.green, Color.blue
  end,
  [108] = function()
    return Color.pink, Color.black
  end,
  [109] = function()
    return Color.purple, Color.black
  end,
  [110] = function()
    return Color.red, Color.black
  end
}
setmetatable(DropItemLevelColorTable, {
  __index = function()
    return Color(0.627451, 0.627451, 0.627451, 1), Color.black
  end
})
local DropItemRarityTable = {
  [0] = 101,
  [1] = 102,
  [2] = 102,
  [3] = 103,
  [4] = 103,
  [5] = 104,
  [6] = 104,
  [7] = 105,
  [8] = 106,
  [9] = 107,
  [10] = 108,
  [11] = 109,
  [12] = 110
}
setmetatable(DropItemRarityTable, {
  __index = function()
    return 109
  end
})
local DropItemQToRTable = {
  [0] = 1,
  [1] = 2,
  [2] = 2,
  [3] = 3,
  [4] = 3,
  [5] = 4,
  [6] = 4,
  [7] = 5
}
local DropItemIsJewelryTable = {
  [91] = true,
  [92] = true,
  [93] = true
}
setmetatable(DropItemQToRTable, {
  __index = function()
    return 5
  end
})
local DropItemLevelEffectTable = {
  [104] = "Eff_diaoluo_lan",
  [106] = "Eff_diaoluo_lv",
  [107] = "Eff_diaoluo_lv",
  [109] = "Eff_diaoluo_zi",
  [110] = "Eff_diaoluo_hong"
}

local function IsDropItemIsJewelryTable(index)
  return DropItemIsJewelryTable[index]
end

local function GetDropItemDir(index)
  return DropItemDirTable[index]
end

local function GetDropItemOffset(index, parameter)
  return DropItemOffsetTable[index](parameter)
end

local function GetGoldModelChoice(index)
  return GoldModelChoiceTable[index]()
end

local function GetDropItemLevelColor(index)
  return DropItemLevelColorTable[index]()
end

local function GetDropItemRarity(index)
  return DropItemRarityTable[index]
end

local function GetDropItemQToRTable(index)
  return DropItemQToRTable[index]
end

local function GetDropItemLevelEffect(index)
  return DropItemLevelEffectTable[index]
end

local function IsNeedShowCount(itemID)
  local list = ClientTable.cfg_Global_globalManager:GetDropItemShowCountList()
  if list ~= nil then
    for i, v in pairs(list) do
      if itemID == v then
        return true
      end
    end
  end
  return false
end

DropItemUtility = {
  jumpHeight = jumpHeight,
  jumpSpeed = jumpSpeed,
  rotateAngle = rotateAngle,
  GetDropItemDir = GetDropItemDir,
  GetDropItemOffset = GetDropItemOffset,
  GetGoldModelChoice = GetGoldModelChoice,
  GetDropItemLevelColor = GetDropItemLevelColor,
  GetDropItemRarity = GetDropItemRarity,
  GetDropItemQToRTable = GetDropItemQToRTable,
  GetDropItemLevelEffect = GetDropItemLevelEffect,
  IsNeedShowCount = IsNeedShowCount,
  IsDropItemIsJewelryTable = IsDropItemIsJewelryTable
}
