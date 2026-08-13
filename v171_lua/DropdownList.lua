DropdownItem = class()

function DropdownItem:ctor(parent)
  self:Init(parent)
end

function DropdownItem:Init(parent)
  self.index = 1
  self.parent = parent
  self.child = {}
  if parent then
    self.switch = false
  else
    self.switch = true
  end
  self.upperMargin = 0
  self.bgHeight = 0
  self.btnHeight = 0
  self.target = nil
  self.moveSpeed = 0.1
  self.originalPos = Vector2(0, 0)
  self.reusableCellQueues = {}
  self.isCanClick = true
end

function DropdownItem:InitializeCellsPool()
  if self.cellsPool then
    return
  end
  local poolObject = CS.UnityEngine.GameObject("ReusableCells")
  self.cellsPool = UIControl(poolObject.transform)
  self.cellsPool:SetParent(self.childScrollView)
end

function DropdownItem:SetSwitchChangeCallback(ui, callback)
  function self.SwitchChangeCallback(switch, button)
    callback(ui, switch, button)
  end
end

function DropdownItem:SetButton(button)
  self.button = button
  self.target = button
  self.button:SetOnClick(self, self.ClickEvent)
  _, self.btnHeight = self.button:GetSizeDelta()
  self.btnHeight = self.btnHeight + self.upperMargin
end

function DropdownItem:SetChildScrollView(scrollViewBase)
  local scrollViewClone = scrollViewBase:Instantiate()
  local scrollView = UIControl(scrollViewClone.transform)
  self.childScrollView = scrollView
  if self.parent then
    self.childScrollView.transform:GetComponent("ScrollRect").enabled = false
  else
    self.childScrollView.transform:GetComponent("ScrollRect").enabled = true
  end
  if self.button then
    local childScrollViewWidth, childScrollViewHeight = self.childScrollView:GetSizeDelta()
    self.childScrollView:SetSizeDelta(childScrollViewWidth, 0)
    self.childScrollView:SetParent(self.button)
    local posY = self.btnHeight / 2
    self.childScrollView:SetAnchoredPosition(0, -posY)
  else
    self.target = self.childScrollView
  end
  self:InitializeCellsPool()
end

function DropdownItem:AddItems(item)
  table.insert(self.child, item)
end

function DropdownItem:GetChildNodes()
  return self.child
end

function DropdownItem:GetChildNodeByIndex(index)
  return self.child[index]
end

function DropdownItem:Close()
  self.switch = false
  if self.parent.SwitchChangeCallback then
    self.parent.SwitchChangeCallback(self.switch, self.button)
  end
end

function DropdownItem:Destroy()
  self.childScrollView:Destroy()
end

function DropdownItem:ImmediatelyClose()
  self.switch = false
  if self.parent.SwitchChangeCallback then
    self.parent.SwitchChangeCallback(self.switch, self.button)
  end
  local childScrollViewWidth, childScrollViewHeight = self.childScrollView:GetSizeDelta()
  self.childScrollView:SetSizeDelta(childScrollViewWidth, 0)
  self.childScrollView:SetActive(false)
  self.button:SetAnchoredPosition(self.originalPos.x, self.originalPos.y)
end

function DropdownItem:SetRootPosition(posX, posY)
  self.target:SetAnchoredPosition(posX, posY)
end

function DropdownItem:SetPosition()
  local posY = (self.index - 1) * self.btnHeight + self.btnHeight / 2
  self.originalPos = Vector2(0, -posY)
  self.target:SetAnchoredPosition(0, -posY)
end

function DropdownItem:SetScrollViewPosition(posX, posY)
  self.child:SetAnchoredPosition(posX, posY)
end

function DropdownItem:SetDropdownItemList(dropdownList)
  self.dropdownList = dropdownList
end

function DropdownItem:GetChild(name)
  return self.button:GetChild(name)
end

function DropdownItem:SetDropdownItemGenerateCallback(ui, callback)
  function self.DropdownItemAtIndexInList(index)
    callback(ui, index)
  end
end

function DropdownItem:SetOnClick(ui, callback)
  function self.BtnClickCallback(control)
    callback(ui, control)
    
    if #self.child > 0 then
      self:ClickEvent()
    end
  end
  
  self.button:SetOnClick(self, self.BtnClickCallback)
end

function DropdownItem:HideAllChildButton()
  for i, v in ipairs(self.child) do
    v.button:SetActive(false)
    v.button:SetParent(self.cellsPool)
    self.reusableCellQueues[#self.reusableCellQueues + 1] = v.button
  end
  self.child = {}
end

function DropdownItem:ReuseHideButton()
  local btn = table.remove(self.reusableCellQueues, 1)
  return btn
end

function DropdownItem:Start()
end

function DropdownItem:ClickEvent()
  if GuideManager.isCoerceGuide then
    if not self.isCanClick then
      return
    end
    self.isCanClick = false
  end
  local lastIndex
  if #self.child > 0 then
    if self.parent then
      local child = self.parent:GetChildNodes()
      for i, v in pairs(child) do
        if v.index ~= self.index then
          if v.switch then
            lastIndex = v.index
          end
          v:Close()
        end
      end
    end
    self.dropdownList:ChangeDropdownItemPos(self.index, self.switch, self.parent.child, lastIndex)
    self:Switch()
  end
  if GuideManager.isCoerceGuide then
    Timer.StartLoop(1, 1, function()
      self.isCanClick = true
    end)
  end
end

function DropdownItem:Switch()
  self.switch = not self.switch
  if self.parent.SwitchChangeCallback then
    self.parent.SwitchChangeCallback(self.switch, self.button)
  end
end

function DropdownItem:SliderDown(posIndex)
  self.button.transform:DOLocalMoveY(self.button.transform.anchoredPosition.y - posIndex, self.moveSpeed)
  return posY
end

function DropdownItem:SliderUp(posIndex)
  self.button.transform:DOLocalMoveY(self.button.transform.anchoredPosition.y + posIndex, self.moveSpeed)
  return posY
end

function DropdownItem:GetPosY()
  local _, posY = self.button:GetAnchoredPosition()
  return posY
end

function DropdownItem:ScrollToCellAtIndex(index)
  if not self.childScrollView then
    return
  end
  local posY = 0
  for i, v in pairs(self.child) do
    if index == i then
      posY = v.button:GetAnchoredPosition()
      break
    end
  end
  if posY == 0 then
    return
  end
  local x, y = self.childScrollView:GetNormalizedPosition()
  local viewPort = self.childScrollView:GetChild("Viewport")
  local content = viewPort:GetChild("Content")
  local contentSize = Vector2(content:GetRectSize())
  local viewPostSize = Vector2(viewPort:GetRectSize())
  local deltaSize = contentSize - viewPostSize
  y = 1 - posY / deltaSize.y
  y = Mathf.Clamp(y, 0, 1)
  self.childScrollView:SetNormalizedPosition(x, y)
end

function DropdownItem:OpenDownScrollView(openSize)
  if not self.childScrollView then
    return
  end
  local childScrollViewWidth, childScrollViewHeight = self.childScrollView:GetSizeDelta()
  if childScrollViewHeight == openSize then
    return
  end
  self.childScrollView:SetPivot(0.5, 1)
  self.childScrollView:SetActive(true)
  for i, v in pairs(self.child) do
    v.button:SetActive(true)
  end
  DOTween.To(function(value)
    self.childScrollView:SetSizeDelta(childScrollViewWidth, value * openSize)
  end, 0, 1, self.moveSpeed):SetEase(Ease.Linear)
end

function DropdownItem:CloseUpScrollView()
  if not self.childScrollView then
    return
  end
  local childScrollViewWidth, childScrollViewHeight = self.childScrollView:GetSizeDelta()
  if childScrollViewHeight == 0 then
    return
  end
  DOTween.To(function(value)
    self.childScrollView:SetSizeDelta(childScrollViewWidth, childScrollViewHeight - value * childScrollViewHeight)
  end, 0, 1, self.moveSpeed):SetEase(Ease.Linear):OnComplete(function()
    self.childScrollView:SetActive(false)
    for i, v in pairs(self.child) do
      v.button:SetActive(false)
    end
  end)
end

DropdownList = class()

function DropdownList:ctor()
  self:Init()
end

function DropdownList:Init()
  self.upperMargin = 0
  self.rootTable = {}
  self.subItemTotalHeight = {}
  self.subItemCount = {}
  self.rootBaseContent = nil
  self.showType = 0
end

function DropdownList:SetUpperMargin(upperMargin, showType)
  self.upperMargin = upperMargin
  self.showType = showType
end

function DropdownList:CloseAll()
  for i, v in ipairs(self.rootTable) do
    if v.parent then
      v:ImmediatelyClose()
    end
  end
  self.rootBaseContent:SetSizeDelta(self.rootContentWeight, self.rootContentHeight)
end

function DropdownList:BuildDropdownList(root, dataCount, button, adaptive, isParent)
  if isParent then
    self.subItemTotalHeight = {}
    self.subItemCount = {}
    self.rootBaseContent = root.childScrollView:GetChild("Viewport/Content")
    local w, h = button:GetSizeDelta()
    local wi, he = self.rootBaseContent:GetSizeDelta()
    self.rootContentWeight = wi
    self.rootContentHeight = dataCount * (h + self.upperMargin)
    self.rootBaseContent:SetSizeDelta(self.rootContentWeight, self.rootContentHeight)
  else
    local _, height = button:GetSizeDelta()
    table.insert(self.subItemTotalHeight, dataCount * (height + self.upperMargin))
    table.insert(self.subItemCount, dataCount)
  end
  local _, bgHeight = root.childScrollView:GetSizeDelta()
  local content = root.childScrollView:GetChild("Viewport/Content")
  local contentWidth, _ = content:GetSizeDelta()
  self.rootTable[#self.rootTable + 1] = root
  if adaptive then
    local _, btnHeight = button:GetSizeDelta()
    local sumBtnHeight = 0
    for i = 1, dataCount do
      sumBtnHeight = sumBtnHeight + btnHeight + self.upperMargin
    end
    content:SetSizeDelta(contentWidth, sumBtnHeight)
  end
  for i = 1, dataCount do
    local btn = button:Instantiate(content.transform, "item")
    local objControl = UIControl(btn.transform)
    if root.parent then
      objControl:SetActive(false)
    else
      objControl:SetActive(true)
    end
    local dropdownItem = DropdownItem(root)
    dropdownItem.index = i
    dropdownItem.bgHeight = bgHeight
    dropdownItem.upperMargin = self.upperMargin
    dropdownItem:SetButton(objControl)
    dropdownItem:SetPosition()
    dropdownItem:SetDropdownItemList(self)
    root:AddItems(dropdownItem)
    root.DropdownItemAtIndexInList(i)
  end
end

function DropdownList:ReloadData(root, dataCount, button, adaptive)
  root:HideAllChildButton()
  local _, bgHeight = root.childScrollView:GetSizeDelta()
  local content = root.childScrollView:GetChild("Viewport/Content")
  local contentWidth, _ = content:GetSizeDelta()
  if adaptive then
    local _, btnHeight = button:GetSizeDelta()
    local sumBtnHeight = 0
    for i = 1, dataCount do
      sumBtnHeight = sumBtnHeight + btnHeight + self.upperMargin
    end
    content:SetSizeDelta(contentWidth, sumBtnHeight)
  end
  for i = 1, dataCount do
    local btn = root:ReuseHideButton()
    local objControl
    if not btn then
      btn = button:Instantiate(content.transform, "item")
      objControl = UIControl(btn.transform)
      objControl:SetActive(true)
    else
      btn:SetActive(true)
      btn:SetParent(content)
      objControl = btn
    end
    local dropdownItem = DropdownItem(root)
    dropdownItem.index = i
    dropdownItem.bgHeight = bgHeight
    dropdownItem.upperMargin = self.upperMargin
    dropdownItem:SetButton(objControl)
    dropdownItem:SetPosition()
    dropdownItem:SetDropdownItemList(self)
    root:AddItems(dropdownItem)
    root.DropdownItemAtIndexInList(i)
  end
end

function DropdownList:ChangeDropdownItemPos(index, switch, rootChild, lastIndex)
  if self.showType == 1 and self.subItemCount[index] == 1 then
    return
  end
  Coroutine.Start(function()
    local dropdownItemList = rootChild
    if lastIndex and self.subItemCount[lastIndex] ~= 1 then
      local _, height = self.rootBaseContent:GetSizeDelta()
      self.rootBaseContent:SetSizeDelta(_, height - self.subItemTotalHeight[lastIndex])
      dropdownItemList[lastIndex]:CloseUpScrollView()
      for i = lastIndex + 1, table.count(dropdownItemList) do
        dropdownItemList[i]:SliderUp(self.subItemTotalHeight[lastIndex])
      end
      Coroutine.Wait(0.1)
    end
    if 9 <= index and not switch and self.subItemCount[index] > 1 then
      self.rootBaseContent.transform.anchoredPosition = self.rootBaseContent.transform.anchoredPosition + Vector2(0, self.subItemTotalHeight[index])
    end
    local _, height = self.rootBaseContent:GetSizeDelta()
    if not switch then
      local interval = math.abs(dropdownItemList[index].bgHeight - dropdownItemList[1].btnHeight)
      dropdownItemList[index]:OpenDownScrollView(interval)
      self.rootBaseContent:SetSizeDelta(_, height + self.subItemTotalHeight[index])
    else
      dropdownItemList[index]:CloseUpScrollView()
      self.rootBaseContent:SetSizeDelta(_, height - self.subItemTotalHeight[index])
    end
    for i = index + 1, table.count(dropdownItemList) do
      if not switch then
        dropdownItemList[i]:SliderDown(self.subItemTotalHeight[index])
      else
        dropdownItemList[i]:SliderUp(self.subItemTotalHeight[index])
      end
    end
  end)
end
