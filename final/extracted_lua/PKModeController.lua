PKModeController = {}
require("GameModel/PKData")
local this = PKModeController

function PKModeController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function PKModeController.RegistMessages()
  this.messageContainer:Regist(RoleMessage.ResSetPKMode, this.OnResSetPKMode)
  this.messageContainer:Regist(MapMessage.ResPersonInstance_BloodCastle, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResPersonInstance_DemonSquare, this.ResPersonInstance_DemonSquare)
end

function PKModeController.OnResSetPKMode(_, data)
  data = data or {param = 0, campId = 0}
  ViewData.meData:SetPkMode(data.param)
  ViewData.meData:SetCampId(data.campId)
end

function PKModeController.ResPersonInstance_PersonResource(_, data)
  if ViewData.meData.PKMode ~= ERolePkMode.Peace then
    NetManager.Send(RoleMessage.ReqSetPKMode, {
      param = ERolePkMode.Peace
    })
  end
end

function PKModeController.ResPersonInstance_DemonSquare(_, data)
  if ViewData.meData.PKMode ~= ERolePkMode.Peace then
    NetManager.Send(RoleMessage.ReqSetPKMode, {
      param = ERolePkMode.Peace
    })
  end
end
