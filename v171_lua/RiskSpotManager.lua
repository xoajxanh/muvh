RiskSpotManager = {}
local this = RiskSpotManager
RiskSpotType = {
  None = enum(0),
  ClickOpenMap = enum(),
  ServiceType = enum(),
  FreeResurrection = enum(),
  SwitchAttackModer = enum(),
  ClickChallengeBoss = enum(),
  ClickMapPos = enum(),
  SwitchFunction = enum(),
  SwitchAutoFight = enum(),
  LookSockMonster = enum(),
  LookSockPlayer = enum(),
  ClickGeneralAttack = enum()
}
RiskSpotManager.ReportedFlag = {
  [RiskSpotType.None] = 0,
  [RiskSpotType.ClickOpenMap] = 1,
  [RiskSpotType.ServiceType] = 1,
  [RiskSpotType.FreeResurrection] = 1,
  [RiskSpotType.SwitchAttackModer] = 1,
  [RiskSpotType.ClickChallengeBoss] = 1,
  [RiskSpotType.ClickMapPos] = 1,
  [RiskSpotType.SwitchFunction] = 1,
  [RiskSpotType.SwitchAutoFight] = 1,
  [RiskSpotType.LookSockMonster] = 1,
  [RiskSpotType.LookSockPlayer] = 1,
  [RiskSpotType.ClickGeneralAttack] = 1
}

function RiskSpotManager.Init()
  this.riskSpotType = RiskSpotType.None
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
  this.RegistMessages()
end

function RiskSpotManager.RegistEvent()
end

function RiskSpotManager.RegistMessages()
  this.messageContainer:Regist(CommonMessage.ResService, this.RiskSpotService)
end

function RiskSpotManager.RiskSpotService()
  this.RiskSpotPlaceType(RiskSpotType.ServiceType)
end

function RiskSpotManager.RiskSpotPlaceType(riskSpotType)
  if RiskSpotManager.ReportedFlag[riskSpotType] and RiskSpotManager.ReportedFlag[riskSpotType] > 0 then
    this.riskSpotType = riskSpotType
    if CS.MuInterface.Instance ~= nil and CS.MuInterface.Instance.GetSession ~= nil then
      CS.MuInterface.Instance:GetSession()
    end
  end
end

RiskSpotManager.Init()
