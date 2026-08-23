netMsgPreprocessing[6001] = function(msgID, tblData)
end
netMsgPreprocessing[6002] = function(msgID, tblData)
  EventManager.Dispatch(Event.RefreshSingleCountShop)
  EventManager.Dispatch(Event.RefreshAnniversaryStoreSingleCount)
  EventManager.Dispatch(Event.RefreshAnniversaryNewCharacterGiftCount)
  EventManager.Dispatch(Event.RefreshAnniversaryMonsterGiftCount)
end
