SmallGameData = {}
SmallGameData.IsRunning = false

function SmallGameData.SetRunningStatus(status)
  if type(status) == "boolean" then
    SmallGameData.IsRunning = status
  end
end

function SmallGameData.GetRunningStatus()
  return SmallGameData.IsRunning
end

function SmallGameData.IsSupportedWebView()
  return type(typeof(CS.Vuplex.WebView.CanvasWebViewPrefab)) == "userdata"
end

function SmallGameData.GetConfigUrl()
  local tbl = ClientTable.cfg_Global_globalManager:TryGetValue(5000114)
  if tbl and tbl.effect then
    return tbl.effect
  end
  return "https://static.xyyx82.com/cn/static/apph5/archeryweb_two/index.html"
end
