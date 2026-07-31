HotUpdateData = {}
local this = HotUpdateData
HotUpdateData.curSize = 0
HotUpdateData.initSize = 0
HotUpdateData.totalSize = 0
HotUpdateData.state = -1
HotUpdateData.cacheIsLoadFinish = false

function HotUpdateData.IsPackageDownloaded(package)
  HotUpdateData.cacheIsLoadFinish = DownLoadProcess.IsPackageDownloaded(package)
  return HotUpdateData.cacheIsLoadFinish
end

function HotUpdateData.SetSize(curSize, totalSize)
  HotUpdateData.initSize = curSize
  HotUpdateData.curSize = curSize
  HotUpdateData.totalSize = totalSize
end

function HotUpdateData.SetCurSize(size)
  HotUpdateData.curSize = HotUpdateData.initSize + size
end

function HotUpdateData.SetDownloadPaused(flag)
  DownLoadProcess.isDownloadPaused = flag
end

function HotUpdateData.SetUseMobileData(flag)
  HotUpdatePorcessMgr.useMobileData = flag
end

function HotUpdateData.GetProcess()
  if this.GetCurSize() == HotUpdateData.totalSize then
    if HotUpdateData.totalSize > 0 or HotUpdateData.cacheIsLoadFinish then
      return 1
    else
      return 0
    end
  else
    return this.GetCurSize() / HotUpdateData.totalSize
  end
end

function HotUpdateData.GetCurSize()
  if HotUpdateData.state == HotUpdateManager.Message.DownloadFinish then
    return HotUpdateData.totalSize
  end
  return HotUpdateData.curSize
end

function HotUpdateData.GetDownloadPaused()
  return HotUpdateData.state == HotUpdateManager.Message.DownloadData and DownLoadProcess.isDownloadPaused
end

function HotUpdateData.GetSizeString(size)
  return this.GetSizeStr(size, size)
end

local KB = 1024
local MB = 1048576

function HotUpdateData.GetSizeStr(size, maxSize)
  if maxSize >= MB then
    return string.format("%.2fMB", size / MB)
  else
    return string.format("%.2fKB", size / KB)
  end
end
