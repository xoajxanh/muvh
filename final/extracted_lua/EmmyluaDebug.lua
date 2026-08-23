EmmyluaDebug = {}

function try(block)
  local main = block.main
  local catch = block.catch
  local finally = block.finally
  assert(main)
  local ok, errors = xpcall(main, debug.traceback)
  if not ok then
    if catch then
      catch(errors)
    else
      luaDebug.LogError(errors, false)
    end
  end
  if finally then
    finally(ok, errors)
  end
  if ok then
    return errors
  end
end

function EmmyluaDebug.InitEmmyluaDebug(obj)
  if CS.TCFramework.Platform.isEditor then
    local applicationDataPath = CS.System.Environment.GetFolderPath(CS.System.Environment.SpecialFolder.ApplicationData)
    applicationDataPath = applicationDataPath .. "/JetBrains/IdeaIC2021.3/plugins/EmmyLua/debugger/emmy/windows/x64/?.dll"
    package.cpath = package.cpath .. ";" .. applicationDataPath
    try({
      main = function()
        local dbg = require("emmy_core")
        dbg.tcpConnect("localhost", 9966)
      end,
      catch = function(errors)
      end
    })
  end
end

EmmyluaDebug.InitEmmyluaDebug()
