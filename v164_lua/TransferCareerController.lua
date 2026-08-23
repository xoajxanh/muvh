require("GameModel/TransferCareerData")
TransferCareerController = {}
local this = TransferCareerController

function TransferCareerController.Init()
  this.RegistMessages()
end

function TransferCareerController.RegistMessages()
  this.messageContainer = EventContainer(NetManager)
  this.messageContainer:Regist(TransferMessage.ResTransferState, this.ResTransferState)
end

function TransferCareerController.ResTransferState(_, msg)
  if msg.state == ERoleTransferCareerState.START then
    UIManager.Show(UIID.Zhuanzhi_LoadingUI)
  end
  TransferCareerData.TransferState(msg)
  EventManager.Dispatch(Event.Role_TransferCareerState, msg)
end
