AutoPopUIManager = {}
local this = AutoPopUIManager
this.uiQueue = {}
this.prePopUIID = nil

function AutoPopUIManager.OnEnterGame()
  this.RegistEvents()
end

function AutoPopUIManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.InsertAutoPopUI, this.PushAutoUI)
  this.eventContainer:Regist(Event.PopAutoPopUI, this.PopAutoUI)
  this.eventContainer:Regist(Event.UI_Hide, this.UIHide)
end

function AutoPopUIManager.PushAutoUI(_, uiid)
  if string.isNullOrEmpty(uiid) then
    return
  end
  this.uiQueue[#this.uiQueue + 1] = uiid
  if UIManager.IsVisible(UIID.MainMenuUI) and #this.uiQueue == 1 and not this.prePopUIID then
    this.PopAutoUI()
  end
end

function AutoPopUIManager.PopAutoUI()
  this.prePopUIID = this.uiQueue[1]
  table.remove(this.uiQueue, 1)
  if this.prePopUIID then
    UIManager.Show(this.prePopUIID)
  end
end

function AutoPopUIManager.UIHide(_, msg)
  if this.prePopUIID == msg.name then
    this.PopAutoUI()
  end
end

function AutoPopUIManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.prePopUIID = nil
end

function AutoPopUIManager.UnRegistAll()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.prePopUIID = nil
end
