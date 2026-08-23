BubbleData = {}
local this = BubbleData
BubbleTypeEnum = {
  MapRelated = enum(0),
  ItemOverdue = enum(1),
  Type2 = enum()
}
BubbleArticlesType = {
  Pet = enum(1)
}
this.BubbleList = {}

function BubbleData.Init()
end

function BubbleData.AddBubble(bubbleInfo)
  this.RemoveBubbleByInfo(bubbleInfo)
  table.insert(this.BubbleList, 1, bubbleInfo)
end

function BubbleData.RemoveAllBubble()
  for i = table.count(this.BubbleList), 1, -1 do
    table.remove(this.BubbleList, i)
  end
end

function BubbleData.RemoveBubbleByInfo(bubbleInfo)
  for i = table.count(this.BubbleList), 1, -1 do
    if this.BubbleList[i].id == bubbleInfo.id then
      table.remove(this.BubbleList, i)
      break
    end
  end
end

function BubbleData.RemoveBubbleById(id)
  for i = table.count(this.BubbleList), 1, -1 do
    if this.BubbleList[i].id == id then
      table.remove(this.BubbleList, i)
      break
    end
  end
end

function BubbleData.RemoveBubbleByitemId(itemId)
  for i = table.count(this.BubbleList), 1, -1 do
    if this.BubbleList[i].itemId == itemId then
      table.remove(this.BubbleList, i)
      break
    end
  end
end

function BubbleData.RemoveMapBubble()
  for i = table.count(this.BubbleList), 1, -1 do
    if this.BubbleList[i].type == BubbleTypeEnum.MapRelated then
      table.remove(this.BubbleList, i)
      break
    end
  end
end

this.Init()
