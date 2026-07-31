TimeCondition = class(ConditionBase)
setgetters(TimeCondition, {
  LoginData = function(self)
    return LoginData
  end,
  TimeUtility = function(self)
    return TimeUtility
  end,
  Time = function(self)
    return Time
  end
})
TimeCondition.comparatorMap = {
  [0] = function(self)
    return self.LoginData.GetOpenServerDay() > tonumber(self.content)
  end,
  [1] = function(self)
    return self.LoginData.GetOpenServerDay() >= tonumber(self.content)
  end,
  [2] = function(self)
    return self.LoginData.GetOpenServerDay() == tonumber(self.content)
  end,
  [3] = function(self)
    return self.LoginData.GetOpenServerDay() <= tonumber(self.content)
  end,
  [4] = function(self)
    return self.LoginData.GetOpenServerDay() < tonumber(self.content)
  end,
  [5] = function(self)
    return self.LoginData.GetOpenServerDay() ~= tonumber(self.content)
  end,
  [6] = function(self)
    local curRefreshState = self.TimeUtility.ArriveADayInMonth(self.content)
    return curRefreshState
  end,
  [7] = function(self)
    local curRefreshState = self.TimeUtility.ArriveACertainPointInTime(self.content)
    return curRefreshState
  end,
  [8] = function(self)
    return self.TimeUtility.InTweenTimeSlot(self.content)
  end,
  [9] = function(self)
    local curRefreshState = self.Time.GetServerTime() >= tonumber(self.content)
    return curRefreshState
  end,
  [10] = function(self)
    local curRefreshState = self.TimeUtility.ArriveADayInWeek(self.content)
    return curRefreshState
  end,
  [11] = function(self)
    return RoleManager.GetRoleMeOnLineTime() > tonumber(self.content)
  end,
  [18] = function(self)
    return self.TimeUtility.InTweenyearTimeSlot(self.content, nil, true)
  end,
  [19] = function(self)
    return self.TimeUtility.OpenServerTimeDesignatesRange(self.content)
  end,
  [21] = function(self)
    return (ViewData.meData.roleLoginTime - ViewData.meData.roleLogoutTime) * 1000 >= tonumber(self.content)
  end,
  [22] = function(self)
    return self.TimeUtility.InTweenyearTimeRemoteOpen(self.content)
  end,
  [23] = function(self)
    return QuickFind.LuaMainPlayerViewAttrData():GetRoleSingleOnLineTime() > tonumber(self.content)
  end,
  [24] = function(self)
    return self.TimeUtility.CheckServerOpenTimeLeOpen(self.content)
  end,
  [28] = function(self)
    return self.TimeUtility.InTweenyearTimeSlot(self.content, nil, false)
  end,
  [30] = function(self)
    return TimeUtility.GetCommerceDay() > self.content
  end,
  [31] = function(self)
    return TimeUtility.GetCommerceDay() >= self.content
  end,
  [32] = function(self)
    return TimeUtility.GetCommerceDay() == self.content
  end,
  [33] = function(self)
    return TimeUtility.GetCommerceDay() <= self.content
  end,
  [34] = function(self)
    return TimeUtility.GetCommerceDay() < self.content
  end,
  [35] = function(self)
    return not (TimeUtility.GetCommerceDay() < self.content)
  end,
  [40] = function(self)
    return self.Time.GetCommerceCount() > self.content
  end,
  [41] = function(self)
    return self.Time.GetCommerceCount() >= self.content
  end,
  [42] = function(self)
    local count = self.Time.GetCommerceCount()
    return self.Time.GetCommerceCount() == self.content
  end,
  [43] = function(self)
    return self.Time.GetCommerceCount() <= self.content
  end,
  [44] = function(self)
    return self.Time.GetCommerceCount() < self.content
  end,
  [45] = function(self)
    return not (self.Time.GetCommerceCount() < self.content)
  end,
  [50] = function(self)
    return self.LoginData.GetCreatePlayerDay() > tonumber(self.content)
  end,
  [51] = function(self)
    return self.LoginData.GetCreatePlayerDay() >= tonumber(self.content)
  end,
  [52] = function(self)
    return self.LoginData.GetCreatePlayerDay() == tonumber(self.content)
  end,
  [53] = function(self)
    return self.LoginData.GetCreatePlayerDay() <= tonumber(self.content)
  end,
  [54] = function(self)
    return self.LoginData.GetCreatePlayerDay() < tonumber(self.content)
  end,
  [55] = function(self)
    return self.LoginData.GetCreatePlayerDay() ~= tonumber(self.content)
  end
}

function TimeCondition:InitParam(param)
  self.content = param
end
