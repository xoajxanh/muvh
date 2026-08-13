PolicyData = {}
PolicyData.TimeExtentEnum = {
  day1 = "day1",
  day7 = "day7",
  month1 = "month1",
  month3 = "month3",
  year1 = "year1"
}
PolicyData.PHP_URL_USERINFORMATION = "http://getip.fgqj.db9k.com/kingapi?action=queryRoleAction&oper=%s&serverid=%d&roleid=%d"

function PolicyData:GetReqInfomation()
  local url = string.format(self.PHP_URL_USERINFORMATION, "ad_yhlm", LoginData.serverId, LoginData.roleId)
  Http.Request(url, function(text)
    if LoginData.externalNet == false then
    end
    if text then
      local jsonobject = json.decode(text)
      self:SetUserInformationInfo(jsonobject)
    end
  end)
end

function PolicyData:SetUserInformationInfo(js)
  self.userInfos = {}
  if js then
    for k, v in pairs(js) do
      self.userInfos[k] = {}
      self.userInfos[k][1] = tonumber(v.login or 0)
      self.userInfos[k][2] = tonumber(v.login or 0)
      self.userInfos[k][3] = tonumber(v.friend_add or 0) + tonumber(v.friend_delete or 0) + tonumber(v.login or 0)
      self.userInfos[k][4] = tonumber(v.recharge or 0)
      self.userInfos[k][5] = tonumber(v.chat or 0)
    end
  end
end

function PolicyData:GetInfomation(timeExtentType, policyType)
  if policyType == 0 then
    return 0
  end
  if self.userInfos ~= nil then
    return self.userInfos[timeExtentType][policyType]
  end
  return 0
end
