MailData = {}
local this = MailData
MailData.TotalMail = {}
MailData.CurReadMail = nil

function MailData.SetTotalMails(mailInfos)
  for _, newMail in pairs(mailInfos) do
    for key, oldMail in pairs(this.TotalMail) do
      if newMail.mailId == oldMail.mailId then
        this.TotalMail[key] = newMail
        this.SetMailInfo(this.TotalMail[key])
        break
      end
    end
  end
end

function MailData.AddTotalMails(mailInfo)
  table.insert(this.TotalMail, mailInfo)
  this.SetMailInfo(mailInfo)
end

function MailData.GetMailIndex(selectMail)
  for i, mail in pairs(this.TotalMail) do
    if mail.mailId == selectMail.mailId then
      return i
    end
  end
end

function MailData.GetMailInfo(selectMail)
  for i, mail in pairs(this.TotalMail) do
    if mail.mailId == selectMail.mailId then
      return mail
    end
  end
end

function MailData.GetMailIndexByMailId(mailId)
  for i, mail in pairs(this.TotalMail) do
    if mail.mailId == mailId then
      return i
    end
  end
end

local function sort(a, b)
  if a.stateType == b.stateType then
    return a.sendTime > b.sendTime
  else
    return a.stateType < b.stateType
  end
end

function MailData.SetMailStateType(mail)
  if mail.haveItems or table.count(mail.items) > 0 then
    if mail.state == EMailState.Mail_UnRead then
      mail.stateType = EMailStateType.Un_Read_Items
    elseif mail.state == EMailState.Mail_Read then
      mail.stateType = EMailStateType.Read_No_Receive
    elseif mail.state == EMailState.Mail_Received then
      mail.stateType = EMailStateType.Read_Received
    end
  elseif mail.state == EMailState.Mail_UnRead then
    mail.stateType = EMailStateType.Un_Read_No_Items
  elseif mail.state == EMailState.Mail_Read then
    mail.stateType = EMailStateType.Read_Received
  end
end

function MailData.SetMailDestroyTime(mail)
  local refreshSec = TimeUtility.RefreshSecToADay(mail.sendTime, 15)
  mail.refreshSec = refreshSec
end

function MailData.SetMailInfo(mail)
  this.SetMailStateType(mail)
  this.SetMailDestroyTime(mail)
end

function MailData.CheckMail()
  for key, mail in ipairs(this.TotalMail) do
    this.SetMailInfo(mail)
  end
  this.SortMail()
end

function MailData.SortMail()
  table.sort(this.TotalMail, sort)
end

function MailData.MailReset()
  for i, _ in pairs(this.TotalMail) do
    this.TotalMail[i] = nil
  end
  this.TotalMail = {}
  this.CurReadMail = nil
end
