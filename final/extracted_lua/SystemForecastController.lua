require("GameModel/SystemForecastData")
SystemForecastController = {}

function SystemForecastController.Init()
  SystemForecastController.messageContainer = EventContainer(NetManager)
  SystemForecastController.eventContainer = EventContainer(EventManager)
  SystemForecastController.RegistEvent()
  SystemForecastController.RegistMessages()
end

function SystemForecastController.RegistEvent()
end

function SystemForecastController.RegistMessages()
end

function SystemForecastController.ResGetCommercialActivityTabInfo(_, data)
end
