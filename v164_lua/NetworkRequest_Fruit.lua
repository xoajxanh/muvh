function networkRequest.ReqResetFruit(fruitAttribute)
  local reqTable = {}
  
  if fruitAttribute ~= nil then
    reqTable.fruitAttribute = fruitAttribute
  else
    reqTable.fruitAttribute = {}
  end
  NetManager.Send(FruitMessage.ReqResetFruit, reqTable)
end
