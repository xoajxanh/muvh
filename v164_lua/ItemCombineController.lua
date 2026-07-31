ItemCombineController = {}
require("GameModel/ItemCombineData")
local this = ItemCombineController

function ItemCombineController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistMessages()
end

function ItemCombineController.RegistMessages()
  this.messageContainer:Regist(ItemCombineMessage.ResItemCombine, this.ResItemCombine)
  this.eventContainer:Regist(Event.Bag_ResBagInfo, this.Bag_ResBagInfo)
  this.eventContainer:Regist(Event.Bag_ResBagChangeDelay, this.OnBagChange)
end

function ItemCombineController.ResItemCombine(_, msg)
  EventManager.Dispatch(Event.Item_CombineRsp, msg)
end

function ItemCombineController.OnBagChange(_, msg)
  local changeItemIdList = {}
  if type(msg) == "table" then
    for i, bagChangeInfo in ipairs(msg) do
      if bagChangeInfo.showItemTbl then
        for itemId, itemInfo in pairs(bagChangeInfo.showItemTbl) do
          table.insert(changeItemIdList, itemId)
        end
      end
      if bagChangeInfo.removeItems then
        for i, itemInfo in ipairs(bagChangeInfo.removeItems) do
          table.insert(changeItemIdList, itemInfo.itemId)
        end
      end
    end
  end
  ItemCombineData:CheckCombineState(changeItemIdList)
end

function ItemCombineController.Bag_ResBagInfo()
  ItemCombineData:FirstCheckItemCombine()
end

function ItemCombineController.ReqCombine(combineId, mainBuckets, bonusBuckets, combineCount)
  local req = {
    combineId = combineId,
    mainBuckets = mainBuckets,
    bonusBuckets = bonusBuckets,
    combineCount = combineCount
  }
  NetManager.Send(ItemCombineMessage.ReqItemCombine, req)
end

this.Init()
