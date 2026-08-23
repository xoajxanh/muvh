local PrivilegeManager = {}
PrivilegeManager.PrivilegeObjList = nil

function PrivilegeManager:RefreshPrivilegeList(tblData)
  if self.PrivilegeObjList == nil then
    self.PrivilegeObjList = {}
  end
  local privilegeObj = self.PrivilegeObjList[tblData.type]
  if privilegeObj == nil then
    privilegeObj = LuaClass.PrivilegeObject:New()
    self.PrivilegeObjList[tblData.type] = privilegeObj
  end
  privilegeObj:Refresh(tblData)
  EventManager.Dispatch(Event.AddOrChangePrivilege, tblData.type)
end

function PrivilegeManager:GetPrivilegeObj(type)
  if self.PrivilegeObjList == nil then
    self.PrivilegeObjList = {}
  end
  if self.PrivilegeObjList[type] == nil then
    self.PrivilegeObjList[type] = LuaClass.PrivilegeObject:New()
  end
  return self.PrivilegeObjList[type]
end

function PrivilegeManager:Destroy()
  self.PrivilegeObjList = nil
end

return PrivilegeManager
