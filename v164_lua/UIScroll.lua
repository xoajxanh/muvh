UIScroll = class(UIControl)
UIScroll.dirEnum = {
  none = enum(0),
  forward = enum(),
  backOff = enum(),
  goBack = enum()
}
UIScroll.scrollEnum = {
  none = enum(0),
  horizontal = enum(),
  vertical = enum()
}

function UIScroll:ctor(tbl)
  self.scrollDistance = tbl.scrollDistance or 400
  self.curPage = tbl.curPage or 1
  self.totalPage = tbl.totalPage or 1
  self.ui = tbl.ui
  self.dragCall = tbl.dragCall or nil
  self.endDragCall = tbl.endDragCall or nil
  self.scrollType = tbl.scrollEnum or self.scrollEnum.horizontal
  self.content = tbl.content
  self.animalTime = 0
  self.originPos = Vector3.one
  self.forwardPos = Vector3.one
  self.backOffPos = Vector3.one
  self.scrollDetlaRatio = 0.17
  self.scrollDetla = self.scrollDistance * self.scrollDetlaRatio
  self.scrollTimeRatio = tbl.scrollTimeRatio or 1.3
  self.scrollDir = self.dirEnum.none
  self.inAnimalRatio = 0.5
  self.contentCount = 1
  self.contentTbl = {}
  self.enable = true
  self.contentIndex = 1
  self.isDrag = false
  self.isMoveing = false
  self:Init()
end

function UIScroll:Init()
  self.originPos = self.content.transform.localPosition
  if self.scrollType == self.scrollEnum.horizontal then
    self.forwardPos = self.originPos + Vector3(-self.scrollDistance, 0, 0)
    self.backOffPos = self.originPos + Vector3(self.scrollDistance, 0, 0)
  else
    self.forwardPos = self.originPos + Vector3(0, self.scrollDistance, 0)
    self.backOffPos = self.originPos + Vector3(0, -self.scrollDistance, 0)
  end
  self:InitContent()
end

function UIScroll:InitContent()
  self.content:SetActive(false)
  for page = 1, self.contentCount + 1 do
    local obj = self.content:Instantiate()
    local objCtr = UIControl(obj.transform)
    if self.scrollType == self.scrollEnum.horizontal then
      objCtr.transform.localPosition = self.originPos + Vector3(self.scrollDistance * (page - 1), 0, 0)
    else
      objCtr.transform.localPosition = self.originPos + Vector3(0, self.scrollDistance * (page - 1), 0)
    end
    objCtr:SetActive(true)
    objCtr.page = page
    table.insert(self.contentTbl, page, objCtr)
  end
end

function UIScroll:GetContentTbl()
  return self.contentTbl
end

function UIScroll:SetContentTbl(index, content)
  self.contentTbl[index] = content
end

function UIScroll:GetCurContent(page)
  if page then
    self.curPage = page
  end
  return self.contentTbl[self.contentIndex]
end

function UIScroll:GetNextIndex()
  local nextContentIndex = self.contentIndex + 1
  if nextContentIndex > #self.contentTbl then
    nextContentIndex = 1
  end
  return nextContentIndex
end

function UIScroll:GetNextContent()
  local nextContentIndex = self:GetNextIndex()
  return self.contentTbl[nextContentIndex]
end

function UIScroll:SetDistance(w, h)
  if self.scrollType == self.scrollEnum.horizontal then
    self.scrollDistance = w
  else
    self.scrollDistance = h
  end
  self:Init()
end

function UIScroll:SetCurPage(index)
  index = index <= self.totalPage and index or self.totalPage
  self.curPage = index
  local content = self:GetCurContent()
  content.isShow = false
  self:OnDragCall(content, self.curPage)
  if self.endDragCall then
    self.endDragCall(self.ui)
  end
end

function UIScroll:SetTotalPage(count)
  self.totalPage = count
  if count < self.curPage then
    self:SetCurPage(count)
  end
end

function UIScroll:SetEnable(value)
  self.enable = value
  self:GetCurContent().transform.localPosition = self.originPos
  if self.scrollType == self.scrollEnum.horizontal then
    self:GetNextContent().transform.localPosition = self.originPos + Vector3(self.scrollDistance, 0, 0)
  else
    self:GetNextContent().transform.localPosition = self.originPos + Vector3(0, self.scrollDistance, 0)
  end
end

function UIScroll:CantBtnClick()
  return self.isDrag or self.isMoveing
end

function UIScroll:OnDragCall(content, page)
  content.isShow = content.isShow and content.page == page
  if content.isShow then
    return
  end
  content.page = page
  if self.dragCall then
    self.dragCall(self.ui, content)
  end
  content.isShow = true
end

function UIScroll:OnDrag(control, eventData)
  if not self.enable or self.isMoveing then
    return
  end
  self.isDrag = true
  local delta = self.scrollType == self.scrollEnum.horizontal and eventData.pressPosition.x - eventData.position.x or eventData.pressPosition.y - eventData.position.y
  local curPosition = self:GetCurContent().transform.localPosition
  if self.scrollType == self.scrollEnum.horizontal then
    self:GetCurContent().transform.localPosition = curPosition + Vector3(eventData.delta.x, 0, 0)
    self:OnDragCall(self:GetCurContent(), self.curPage)
    if 0 < delta then
      if self.curPage ~= self.totalPage then
        self:GetNextContent().transform.localPosition = curPosition + Vector3(eventData.delta.x + self.scrollDistance, 0, 0)
        self:OnDragCall(self:GetNextContent(), self.curPage + 1)
      end
    elseif self.curPage ~= 1 then
      self:GetNextContent().transform.localPosition = curPosition + Vector3(eventData.delta.x - self.scrollDistance, 0, 0)
      self:OnDragCall(self:GetNextContent(), self.curPage - 1)
    end
  else
    self:GetCurContent().transform.localPosition = curPosition + Vector3(0, eventData.delta.y, 0)
    if 0 < delta then
      if self.curPage ~= 1 then
        self:GetNextContent().transform.localPosition = curPosition + Vector3(0, eventData.delta.y + self.scrollDistance, 0)
        self:OnDragCall(self:GetNextContent(), self.curPage - 1)
      end
    elseif self.curPage ~= self.totalPage then
      self:GetNextContent().transform.localPosition = curPosition + Vector3(0, eventData.delta.y - self.scrollDistance, 0)
      self:OnDragCall(self:GetNextContent(), self.curPage + 1)
    end
  end
end

function UIScroll:OnEndDrag(control, eventData)
  if not self.enable or self.isMoveing then
    return
  end
  self.isDrag = false
  local delta = self.scrollType == self.scrollEnum.horizontal and eventData.pressPosition.x - eventData.position.x or eventData.pressPosition.y - eventData.position.y
  if delta == 0 then
    self.scrollDir = self.dirEnum.none
  elseif delta <= self.scrollDetla and 0 < delta or delta >= -self.scrollDetla and delta < 0 then
    self.forward = false
    self.backoff = false
    if 0 < delta then
      self.forward = true
    elseif delta < 0 then
      self.backoff = true
    end
    self.scrollDir = self.dirEnum.goBack
  elseif delta > self.scrollDetla then
    self.scrollDir = self.scrollType == self.scrollEnum.horizontal and self.dirEnum.forward or self.dirEnum.backOff
  elseif delta < -self.scrollDetla then
    self.scrollDir = self.scrollType == self.scrollEnum.horizontal and self.dirEnum.backOff or self.dirEnum.forward
  end
  if self.scrollDir == self.dirEnum.backOff and self.curPage == 1 then
    self.scrollDir = self.dirEnum.goBack
  elseif self.scrollDir == self.dirEnum.forward and self.curPage == self.totalPage then
    self.scrollDir = self.dirEnum.goBack
  end
  self:OnScrollMove()
end

function UIScroll:OnScrollMove()
  if self.scrollDir == self.dirEnum.none then
    return
  end
  self.isMoveing = true
  local curPos, nextPos
  local curContent = self:GetCurContent()
  local nextContent = self:GetNextContent()
  if self.scrollDir == self.dirEnum.goBack then
    curPos = self.originPos
    if self.forward then
      if self.curPage ~= self.totalPage then
        nextPos = self.backOffPos
      end
    elseif self.backoff and self.curPage ~= 1 then
      nextPos = self.forwardPos
    end
  elseif self.scrollDir == self.dirEnum.backOff then
    curPos = self.backOffPos
    nextPos = self.originPos
    self:RecordCurPage()
  elseif self.scrollDir == self.dirEnum.forward then
    curPos = self.forwardPos
    nextPos = self.originPos
    self:RecordCurPage()
  end
  curContent.transform:DOLocalMove(curPos, self:CalculScrollTime(curContent.transform.localPosition, curPos)):SetEase(Ease.OutQuart):OnComplete(function()
    self.isMoveing = false
  end)
  if nextPos then
    nextContent.transform:DOLocalMove(nextPos, self:CalculScrollTime(nextContent.transform.localPosition, nextPos)):SetEase(Ease.OutQuart)
  end
  for _, content in ipairs(self.contentTbl) do
    content.isShow = false
  end
end

function UIScroll:CalculScrollTime(curPos, nextPos, speed)
  if nextPos == nil then
    if self.scrollDir == self.dirEnum.goBack then
      nextPos = self.originPos
    elseif self.scrollDir == self.dirEnum.backOff then
      nextPos = self.backOffPos
    elseif self.scrollDir == self.dirEnum.forward then
      nextPos = self.forwardPos
    end
  end
  local time = self.scrollType == self.scrollEnum.horizontal and Mathf.Abs(curPos.x - nextPos.x) / self.scrollDistance or Mathf.Abs(curPos.y - nextPos.y) / self.scrollDistance
  return speed and time * self.scrollTimeRatio * speed or time * self.scrollTimeRatio
end

function UIScroll:RecordCurPage()
  local page = self.curPage
  if self.scrollDir == self.dirEnum.backOff then
    page = page - 1
  elseif self.scrollDir == self.dirEnum.forward then
    page = page + 1
  end
  self.contentIndex = self:GetNextIndex()
  self:SetCurPage(page)
end
