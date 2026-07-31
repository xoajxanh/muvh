local PlayActivity = {}
setmetatable(PlayActivity, LuaClass.ActivityDataBase)

function PlayActivity:GetActivityId()
  return self.activityTbl.activityId
end

function PlayActivity:GetTransferId()
  return self.activityTbl.MaptransferID
end

function PlayActivity:GetOpenTimeConfig()
  return self.activityTbl.condition
end

function PlayActivity:GetNoticeTimeConfig()
  return self.activityTbl.preTime
end

function PlayActivity:GetOpenTimeDesFormat()
  return ClientTable.cfg_Ui_wordManager:GetUi_wordCount(self.activityTbl.openText)
end

function PlayActivity:GetNoticeTimeDesFormat()
  return ClientTable.cfg_Ui_wordManager:GetUi_wordCount(self.activityTbl.previewText)
end

function PlayActivity:GetActivityName()
  return self.activityTbl.activityName
end

function PlayActivity:GetEnterBtnName()
  if self.activityTbl == nil or string.isNullOrEmpty(self.activityTbl) then
    return
  end
  return ClientTable.cfg_Ui_wordManager:GetUi_wordCount(self.activityTbl.enter)
end

return PlayActivity
