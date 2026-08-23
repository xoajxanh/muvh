MailController = {}
require("GameModel/MailData")
local this = MailController

function MailController.Init()
  this.messageContainer = EventContainer(NetManager)
  MailController.RegistEvent()
end

function MailController.RegistEvent()
  this.messageContainer:Regist(MailMessage.ResGetMailList, MailController.OnResGetMailList)
  this.messageContainer:Regist(MailMessage.ResNewMail, MailController.OnResNewMail)
  this.messageContainer:Regist(MailMessage.ResReadMail, MailController.OnResReadMail)
  this.messageContainer:Regist(MailMessage.ResGetMailItems, MailController.OnResGetMailItems)
  this.messageContainer:Regist(MailMessage.ResDeleteMail, MailController.OnResDeleteMail)
end

function MailController.OnResDeleteMail(_, data)
  local mails = data and data.mailIds or {}
  for _, id in ipairs(mails) do
    local index = MailData.GetMailIndexByMailId(id)
    if MailData.CurReadMail and id == MailData.CurReadMail.mailId then
      MailData.CurReadMail = nil
    end
    table.remove(MailData.TotalMail, index)
  end
  EventManager.Dispatch(Event.Mail_ResDeleteMail)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function MailController.OnResGetMailList(_, data)
  MailData.MailReset()
  if data and data.mailInfo then
    MailData.TotalMail = data.mailInfo
    MailData.CheckMail()
  end
  EventManager.Dispatch(Event.Mail_ResMailList)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function MailController.OnResNewMail(_, data)
  if data and data.mailInfo then
    MailData.AddTotalMails(data.mailInfo)
    EventManager.Dispatch(Event.Mail_ResNewMail)
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
  end
end

function MailController.OnResReadMail(_, data)
  if data and data.mailInfo then
    MailData.SetTotalMails(data.mailInfo)
    MailData.CurReadMail = data.mailInfo[1]
    EventManager.Dispatch(Event.Mail_ResReadMail, data.mailInfo)
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function MailController.OnResGetMailItems(_, data)
  if data and data.mailInfo then
    MailData.SetTotalMails(data.mailInfo)
    if MailData.CurReadMail then
      MailData.CurReadMail = MailData.GetMailInfo(MailData.CurReadMail)
    end
    EventManager.Dispatch(Event.Mail_ResGetMailItem, data.mailInfo)
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  local text = LocalizationUtility.GetContentByKey("fujianlingquchenggong")
  FloatingWordUtility.QuickMsg(text)
end

MailController.Init()
