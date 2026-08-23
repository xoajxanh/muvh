AnniversaryActivity_StoreData = {}
AnniversaryActivity_StoreData.storeData = {}
AnniversaryActivity_StoreData.memoryStoneCount = 0

function AnniversaryActivity_StoreData.SetStoreData(data)
  if data then
    AnniversaryActivity_StoreData.storeData = data
  end
end

function AnniversaryActivity_StoreData.GetStoreData()
  return AnniversaryActivity_StoreData.storeData
end

function AnniversaryActivity_StoreData.GetMemoryStoneCount()
  if BagInfoData.CoinInfos[ECoinsType.AnniversaryActivityMemoryStone] then
    AnniversaryActivity_StoreData.memoryStoneCount = BagInfoData.CoinInfos[ECoinsType.AnniversaryActivityMemoryStone] or 0
  end
  return AnniversaryActivity_StoreData.memoryStoneCount
end

function AnniversaryActivity_StoreData.GetStoreCurrencyModel()
  if not AnniversaryActivity_StoreData.storeCurrencyModel then
    AnniversaryActivity_StoreData.storeCurrencyModel = ClientTable.cfg_Commerce_globalManager:TryGetValue(127003).effect
  end
  return AnniversaryActivity_StoreData.storeCurrencyModel
end
