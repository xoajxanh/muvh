local RedPointGoManager = {}

function RedPointGoManager:GetIDListByPathDic()
  if self.mIDListByGoDic == nil then
    self.mIDListByGoDic = {}
  end
  return self.mIDListByGoDic
end

function RedPointGoManager:GetGoByPathDic()
  if self.mGoByPathDic == nil then
    self.mGoByPathDic = {}
  end
  return self.mGoByPathDic
end

function RedPointGoManager:AllPathHashByGoDic()
  if self.mAllPathHashByGoDic == nil then
    self.mAllPathHashByGoDic = {}
  end
  return self.mAllPathHashByGoDic
end

function RedPointGoManager:GetUINameByStateDic()
  if self.mUINameByStateDic == nil then
    self.mUINameByStateDic = {}
  end
  return self.mUINameByStateDic
end

function RedPointGoManager:GetGoStateDic()
  if self.GoStateDic == nil then
    self.GoStateDic = {}
  end
  return self.GoStateDic
end

function RedPointGoManager:AllPathCacheStateDic()
  if self.mAllPathCacheStateDic == nil then
    self.mAllPathCacheStateDic = {}
  end
  return self.mAllPathCacheStateDic
end

function RedPointGoManager:GetCacheIdStateDic()
  if self.mCacheIdStateDic == nil then
    self.mCacheIdStateDic = {}
  end
  return self.mCacheIdStateDic
end

function RedPointGoManager:GetMainUI()
  if self.Main_MainMenuUI == nil then
    self.Main_MainMenuUI = UIManager.GetUiByName("Main_MainMenuUI")
  end
  return self.Main_MainMenuUI
end

function RedPointGoManager:Initialize()
end

function RedPointGoManager:RemoveGoEventCallBackByClient(msg)
  if string.isNullOrEmpty(msg.path) or msg.id == nil then
    return
  end
  if self:GetIDListByPathDic()[msg.path] ~= nil then
    self:GetIDListByPathDic()[msg.path][msg.id] = nil
  end
  self:GetGoStateDic()[msg.path] = nil
end

function RedPointGoManager:AddGoEventCallBackByClient(msg)
  self:AddGoEventCallBack(msg)
  if msg.go.activeSelf then
    msg.go:SetActive(false)
  end
  self:GetGoByPathDic()[msg.path] = msg.go
  self:AllPathHashByGoDic()[msg.go:GetHashCode()] = msg.path
end

function RedPointGoManager:AddGoEventCallBack(msg)
  if string.isNullOrEmpty(msg.path) or msg.id == nil then
    return
  end
  if self:GetIDListByPathDic()[msg.path] == nil then
    self:GetIDListByPathDic()[msg.path] = {}
  end
  local nameStr = ""
  local redTbl = ClientTable.cfg_Red_pointManager:TryGetValue(msg.id)
  if redTbl then
    nameStr = redTbl.name
  end
  if RedPointManager.isLog then
    print(msg.id .. "Add " .. msg.path)
  end
  self:GetIDListByPathDic()[msg.path][msg.id] = {
    id = msg.id,
    name = nameStr,
    path = msg.path,
    state = false
  }
  self:TryAddUINameData(msg)
end

function RedPointGoManager:TryRefreshGoEventCallBack(msg)
  if RedPointManager.isLog then
    CS.UnityEngine.Debug.Log(msg.id .. "\229\176\157\232\175\149\229\143\152\229\138\168\230\155\180\230\148\185" .. msg.path .. "\231\154\132\231\138\182\230\128\129\228\184\186" .. tostring(msg.state))
  end
  if string.isNullOrEmpty(msg.path) then
    return
  end
  if self:GetIDListByPathDic()[msg.path] == nil then
    return
  end
  if self:GetIDListByPathDic()[msg.path][msg.id] == nil then
    return
  end
  local lastIdState = self:GetIDListByPathDic()[msg.path][msg.id].state
  if RedPointManager.isLog then
    CS.UnityEngine.Debug.Log("Check idState: " .. msg.path .. " " .. tostring(msg.state) .. " " .. tostring(lastIdState))
  end
  self:GetIDListByPathDic()[msg.path][msg.id].state = msg.state
  local lastGoState = self:GetGoStateDic()[msg.path]
  if RedPointManager.isLog then
    CS.UnityEngine.Debug.Log("Check GOState: " .. msg.path .. " " .. tostring(msg.state) .. " " .. tostring(lastGoState))
  end
  if msg.state == lastGoState then
    return
  end
  local curGoState = self:GetGoCurState(msg.path)
  self:AllPathCacheStateDic()[msg.path] = curGoState
  local go = self:TryGetGo(msg.path)
  if RedPointManager.isLog then
    CS.UnityEngine.Debug.Log("GetGo\239\188\154 " .. msg.path .. "  " .. tostring(go))
  end
  if not IsNil(go) then
    if go.activeSelf ~= curGoState then
      go:SetActive(curGoState)
    end
    self:GetGoStateDic()[msg.path] = curGoState
    self:GetCacheIdStateDic()[msg.id] = nil
    if RedPointManager.isLog then
      CS.UnityEngine.Debug.Log(msg.id .. "\229\143\152\229\138\168\230\155\180\230\148\185\228\186\134" .. msg.path .. "\231\154\132\231\138\182\230\128\129\239\188\140\229\189\147\229\137\141\231\138\182\230\128\129\239\188\154" .. tostring(curGoState))
    end
  end
end

function RedPointGoManager:TryGetPointIdListByUIName(UIName)
  if self:GetUINameByStateDic()[UIName] == nil or self:GetUINameByStateDic()[UIName].isInitialized then
    return nil
  end
  self:GetUINameByStateDic()[UIName].isInitialized = true
  return self:GetUINameByStateDic()[UIName].idList
end

function RedPointGoManager:TryAddUINameData(data)
  local uiTbl = string.split(data.path, "#")
  if table.count(uiTbl) < 2 then
    return
  end
  if self:GetUINameByStateDic()[uiTbl[1]] == nil then
    self:GetUINameByStateDic()[uiTbl[1]] = {
      idList = {},
      isInitialized = false
    }
  else
    for i, v in pairs(self:GetUINameByStateDic()[uiTbl[1]].idList) do
      if v == data.id then
        return
      end
    end
  end
  table.insert(self:GetUINameByStateDic()[uiTbl[1]].idList, data.id)
end

function RedPointGoManager:TryGetGo(path)
  local go = self:GetGoByPathDic()[path]
  if go == nil then
    go = self:TryGetGoByPath(path)
    if not IsNil(go) then
      self:GetGoByPathDic()[path] = go
      self:AllPathHashByGoDic()[go:GetHashCode()] = path
    end
  end
  return go
end

function RedPointGoManager:GetGoCurState(path)
  if path == "Main_MainMenuUI#btn_shrink" and self:GetMainUI() ~= nil and self:GetMainUI().activityState then
    return false
  end
  local idList = self:GetIDListByPathDic()[path]
  if idList then
    for i, v in pairs(idList) do
      if self:GetCacheIdStateDic()[v.id] ~= nil then
        if self:GetCacheIdStateDic()[v.id] then
          return true
        end
      elseif v.state then
        return true
      end
    end
  end
  return false
end

function RedPointGoManager:TryGetGoByPath(path)
  if string.isNullOrEmpty(path) then
    return nil
  end
  local count, redGo
  local pathList = string.split(path, "#")
  count = table.count(pathList)
  if 1 < count then
    local uiPanel = UIManager.GetUiByName(pathList[1])
    if RedPointManager.isLog then
      CS.UnityEngine.Debug.Log("TryGetGoByPath: " .. path .. " " .. tostring(uiPanel))
    end
    if uiPanel then
      if count == 2 and pathList[2] == "btn_func" and uiPanel.img_redPointfunc then
        return uiPanel.img_redPointfunc.gameObject
      end
      for i = 2, count do
        if uiPanel[pathList[i]] ~= nil and uiPanel[pathList[i]].transform and not IsNil(uiPanel[pathList[i]].transform) then
          redGo = uiPanel[pathList[i]]:GetChild("img_redPoint").gameObject
          if not IsNil(redGo) then
            return redGo
          end
        end
      end
    end
  end
  return nil
end

function RedPointGoManager:GetCacheStateByPath(_path)
  return self:AllPathCacheStateDic()[_path] or false
end

function RedPointGoManager:GedRedIdListByGo(_go)
  if _go == nil or IsNil(_go) then
    return 0
  end
  local path = self:AllPathHashByGoDic()[_go:GetHashCode()]
  if path == nil then
    return 1
  end
  return self:GetIDListByPathDic()[path]
end

function RedPointGoManager:Reset()
  for k, v in pairs(self:GetIDListByPathDic()) do
    v = nil
  end
end

function RedPointGoManager:Destroy()
  self:Reset()
  for i, v in pairs(self) do
    self[i] = nil
  end
end

return RedPointGoManager
