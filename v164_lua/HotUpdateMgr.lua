HotUpdateMgr = {}
local this = HotUpdateMgr

function HotUpdateMgr.CheckCountPackageUpdate()
  DownLoadProcess.DoDownloadPackage(1, this.CallBackPackageUpdate, this.OnHotUpdateMessage)
end

function HotUpdateMgr.CallBackPackageUpdate(curSize, totalSize)
  HotUpdateData.SetSize(curSize, totalSize)
end

function HotUpdateMgr.OnHotUpdateMessage(message)
  HotUpdateData.state = message
  if message == HotUpdateManager.Message.DownloadFinish then
    EventManager.Dispatch(Event.CountPackageDownload)
  elseif message == HotUpdateManager.Message.DownloadData then
    HotUpdateData.SetCurSize(HotUpdatePorcessMgr.currentDownloadSize)
  end
end

function HotUpdateMgr.CheckHotUpdateConfig(CallBack)
  if CS.Framework.ResourceManager.editorMode or not MuInterfaceLua.Instance:IsSDKDevelopApk() then
    CallBack()
    return
  end
  local url = ""
  if MuInterfaceLua.Instance.GetHotUpdateConfigUrl then
    url = MuInterfaceLua.Instance:GetHotUpdateConfigUrl()
  end
  if string.isNullOrEmpty(url) then
    CallBack()
    return
  end
  Http.Request(url, function(text)
    if text then
      local needHotUpdate = false
      local apkVersion = MuInterfaceLua.Instance:GetInstallResVersion()
      local curVersion = CS.Framework.HotUpdatePorcessMgr.localVersion:ToString()
      local a = json.decode(text)
      ClientConfigData.OpenRecharge = a.openVerify == 1
      for _, v in pairs(a.VersionList) do
        if string.contains(apkVersion, v.version) then
          needHotUpdate = not string.contains(curVersion, v.resVersion)
          break
        end
      end
      if needHotUpdate then
        local title = {
          title = "Nh\225\186\175c nh\225\187\159",
          textContent = "Ph\195\161t hi\225\187\135n c\195\179 n\225\187\153i dung phi\195\170n b\225\186\163n m\225\187\155i, c\225\186\167n c\225\186\173p nh\225\186\173t",
          cancelText = "",
          okText = "",
          cancel = nil,
          ok = function()
            Application.Quit()
          end
        }
        UIManager.Hide(UIID.WaitingUI)
        UIManager.Show(UIID.PromptTipUI, title)
      else
        CallBack()
      end
    else
      CallBack()
    end
  end)
end
