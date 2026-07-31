ChatStrHandle = class()

function ChatStrHandle:ctor()
  self:Init()
end

function ChatStrHandle:Init()
  self.inputData = {
    itemData = {},
    posData = {},
    imgData = {}
  }
  self.allInputData = {}
  self.textKeyTab = {}
end

function ChatStrHandle:GetTextKeyTab()
  return self.textKeyTab
end

function ChatStrHandle:UpdateInputToChat(inputText, inputData)
  for word in string.gmatch(inputText, "%[([^%[%]]+)%]") do
    local key = "[" .. word .. "]"
    if inputData[key] then
      local replaceStr = string.gsub(key, "]", "%%]", 1)
      replaceStr = string.gsub(replaceStr, "%[", "%%[", 1)
      inputText = string.gsub(inputText, replaceStr, inputData[key], 1)
      table.insert(self.textKeyTab, key)
    end
  end
  return inputText
end

function ChatStrHandle:GetChatText(inputText)
  local chatText = self:UpdateInputToChat(inputText, self.allInputData)
  return chatText
end

function ChatStrHandle:GetInputStr(type, id)
  local key = ""
  if type == ChatInfoEnum.ITEM then
    key = string.format("[item:%d]", table.count(self.inputData.itemData) + 1)
    self:UpdateItemStr(key, id)
  end
  if type == ChatInfoEnum.IMG then
    key = string.format("[img:%d]", table.count(self.inputData.imgData) + 1)
    self:UpdateImgStr(key, id)
  end
  if type == ChatInfoEnum.POS then
    key = string.format("[pos:%d]", table.count(self.inputData.posData) + 1)
    self:UpdatePosStr(key)
  end
  return key
end

function ChatStrHandle:UpdateItemStr(itemKey, itemId)
  local itemInfo = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  local qualityColor = ItemQuality2ColorDic[itemInfo.colorShow]
  self.inputData.itemData[itemKey] = string.format("<color=%s><a href=%s>[%s]</a></color>", qualityColor, itemKey, itemInfo.name)
  self.allInputData[itemKey] = string.format("<color=%s><a href=%s>[%s]</a></color>", qualityColor, itemKey, itemInfo.name)
end

function ChatStrHandle:UpdateImgStr(imgKey, imgId)
  self.inputData.imgData[imgKey] = string.format("[%d]", imgId)
  self.allInputData[imgKey] = string.format("[%d]", imgId)
end

function ChatStrHandle:UpdatePosStr(posKey)
  local playerPos = string.format("[%s:%d,%d]", SceneData.name, RoleManager.me.cellPos.x, RoleManager.me.cellPos.y)
  self.inputData.posData[posKey] = string.format("<color=#28E529><a href=%s>%s</a></color>", posKey, playerPos)
  self.allInputData[posKey] = string.format("<color=#28E529><a href=%s>%s</a></color>", posKey, playerPos)
end

function ChatStrHandle:GetInputStrStallPos(_stallPos)
  local key = string.format("[pos:%d]", table.count(self.inputData.posData) + 1)
  local sharePos = string.format("[%s:%d,%d]", _stallPos.scenceName, _stallPos.x, _stallPos.y)
  self.inputData.posData[key] = string.format("<color=#28E529><a href=%s>%s</a></color>", key, sharePos)
  self.allInputData[key] = string.format("<color=#28E529><a href=%s>%s</a></color>", key, sharePos)
  return key
end

function ChatStrHandle:ResetData()
  self.inputData = {
    itemData = {},
    posData = {},
    imgData = {}
  }
  self.allInputData = {}
  self.textKeyTab = {}
end
