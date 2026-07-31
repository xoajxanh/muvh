FruitData = {}
local this = FruitData
FruitData.FruitDataItemData = {
  [1] = {
    3000111,
    3000121,
    3000131,
    3000141,
    3000151,
    3000161
  }
}
FruitData.FruitAttributeData = {}
FruitData.FruitAttributeOldData = {}
FruitData.freeReset = false

function FruitData.Init()
end

function FruitData.RefreshFreeReset(msg)
  if msg then
    this.freeReset = msg.freeReset
  end
end

function FruitData.Clear()
  this.freeReset = false
end

FruitData.Init()
