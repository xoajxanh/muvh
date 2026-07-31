UIContainer = class(UIControl)

function UIContainer:ctor(template, ui, onCreateItem, onRefreshItem, onRefreshEnd)
  UIControl.ctor(self, template:GetParent())
  self.template = template
  self.ui = ui
  self.onCreateItem = onCreateItem
  self.onRefreshItem = onRefreshItem
  self.onRefreshEnd = onRefreshEnd
  self.itemName = self.template:GetName()
  self.template:SetActive(false)
  self.unusedItems = {}
  self.items = {}
  self.maxCount = 0
end

function UIContainer:SetMaxCount(maxCount)
  self.maxCount = maxCount
end

local function CalcDataCount(data)
  local t = type(data)
  if t == "table" then
    return table.count(data)
  elseif t == "number" then
    return data
  end
  return 0
end

function UIContainer:SetData(data, isRich, isPair)
  self.isRich = isRich or isRich == nil
  self.isPair = isPair or isPair ~= nil
  self.data = data
  self.maxCount = CalcDataCount(self.data)
  self:Refresh(data)
end

function UIContainer:SetTemplateData(data, callBack)
  for k, v in pairs(self.items) do
    if v.itemTemp then
      callBack(v.itemTemp, data)
    end
  end
end

function UIContainer:InitTemplateData(data)
  for k, v in pairs(self.items) do
    if v.itemTemp then
      v.itemTemp:Init(data)
    end
  end
end

function UIContainer:Refresh()
  local count = self.maxCount
  for k = 1, count do
    self:RefreshItem(k)
  end
  for k = #self.items, count + 1, -1 do
    self:RemoveItem(k)
  end
  self:RefreshEnd()
end

local function GetData(data, k, isPair)
  if isPair then
    local m = 1
    for i, v in pairs(data) do
      if m == k then
        return v
      end
      m = m + 1
    end
    return nil
  end
  return type(data) == "table" and data[k] or nil
end

function UIContainer:RefreshItem(k)
  local item = self:GetOrCreateItem(k)
  if item == nil or IsNil(item.gameObject) then
    return
  end
  local v = GetData(self.data, k, self.isPair)
  if self.onRefreshItem then
    if type(v) == "table" then
      v.isRich = self.isRich
    end
    self.onRefreshItem(item, k, v, self.ui)
  end
end

function UIContainer:RefreshEnd()
  local items = self.items
  local data = self.data
  if self.onRefreshEnd then
    self.onRefreshEnd(items, data, self.ui)
  end
end

function UIContainer:RemoveKTable()
  for i, _ in pairs(self.items) do
    self:RecycleItem(self.items[i])
  end
  self.items = {}
end

function UIContainer:SetDataKTable(data)
  self.data = data
  for id, _ in pairs(self.data) do
    self:GetOrCreateItem(id)
  end
  self:RefreshKTable()
end

function UIContainer:RefreshKTable()
  for k, item in pairs(self.items) do
    local v = GetData(self.data, k, self.isPair)
    if self.onRefreshItem then
      self.onRefreshItem(item, k, v, self.ui)
    end
  end
  if self.onRefreshEnd then
    self.onRefreshEnd(self.item, self.data, self.ui)
  end
end

function UIContainer:GetOrCreateItem(k)
  local item = self.items[k]
  if item then
    return item
  end
  local item = self:CreateItem()
  self.items[k] = item
  return item
end

function UIContainer:CreateItem()
  local item
  if #self.unusedItems > 0 then
    item = table.remove(self.unusedItems)
  else
    item = self:CreateCurItem()
  end
  if item == nil or IsNil(item.gameObject) then
    item = self:CreateCurItem()
  end
  if item == nil or IsNil(item.gameObject) then
    return
  end
  item.gameObject:SetActive(true)
  item.transform:SetAsLastSibling()
  return item
end

function UIContainer:CreateCurItem()
  if IsNil(self.transform) then
    return
  end
  local go = self.template:Instantiate(self.transform, self.itemName)
  go.name = self.itemName
  local item = UIControl()
  item.transform = go.transform
  if self.onCreateItem then
    self.onCreateItem(item, self.ui)
  end
  return item
end

function UIContainer:RemoveAll()
  for i, _ in pairs(self.items) do
    self:RemoveItem(i)
  end
end

function UIContainer:RemoveItem(k)
  local item = table.remove(self.items, k)
  if not item then
    return
  end
  self:RecycleItem(item)
end

function UIContainer:DesToryItem(k)
  local item = table.remove(self.items, k)
  if not item then
    return
  end
end

function UIContainer:DesToryTable()
  for i, _ in pairs(self.items) do
    self:DesToryItem(i)
  end
  self.items = {}
end

function UIContainer:SetActiveTable()
  for i, _ in pairs(self.items) do
    if _ then
      _:SetActive(false)
    end
  end
end

function UIContainer:RecycleItem(item)
  item.gameObject:SetActive(false)
  table.insert(self.unusedItems, item)
end

function UIContainer:FindItem(value, key)
  local isTable = type(self.data) ~= "table"
  for k, v in ipairs(self.items) do
    if (key and v[key] or v) == value then
      if isTable then
        return v, k
      else
        return v, k, self.data[k]
      end
    end
  end
  return nil
end

function UIContainer:PeekItem(value, key)
  local item, k, v = self:FindItem(value, key)
  if item then
    table.remove(self.items, k)
  end
  return item, k, v
end

function UIContainer:RecycleRes()
  for _, ctr in pairs(self.item) do
    if ctr.itemCellData then
      ctr.itemCellData:Reset()
    end
  end
end

function UIContainer:SetDataByPairs(data, isRich)
  self.isRich = isRich or isRich == nil
  self.data = data
  local count = self:PairsRefresh()
  return count
end

function UIContainer:PairsRefresh()
  local resCount = self.transform.childCount
  local runCount = 0
  local ctr
  for k, v in pairs(self.items) do
    v:SetActive(false)
  end
  if not self.data then
    return runCount
  end
  for k, v in pairs(self.data) do
    if type(v) == "table" then
      runCount = runCount + 1
      if resCount > runCount then
        ctr = self.items[runCount]
      else
        local go = self.template:Instantiate(self.transform, self.itemName)
        ctr = UIControl(go.transform)
        if self.onCreateItem then
          self.onCreateItem(ctr, self.ui)
        end
        self.items[runCount] = ctr
      end
      if self.onRefreshItem then
        if ctr then
          self.onRefreshItem(ctr, k, v, self.ui)
        else
          logError("Ki\225\187\131m so\195\161t m\225\187\165c UIContainer kh\195\180ng t\225\187\147n t\225\186\161i v\195\160 kh\195\180ng \196\145\198\176\225\187\163c l\195\160m m\225\187\155i" .. runCount .. ">>" .. k .. tostring(self.transform))
        end
      end
      ctr:SetActive(true)
    end
  end
  return runCount
end
