local util = require("xlua.util")
local coroutineRunner = CS.Main.instance
Coroutine = {}

function Coroutine.Start(func, ...)
  if CS.UnityEngine.Debug.isDebugBuild then
    local param = {
      ...
    }
    
    local function co_Func()
      local callRet, err = xpcall(func, debug.traceback, table.unpack(param))
      if not callRet then
        logError(err)
      end
    end
    
    return coroutineRunner:StartCoroutine(util.cs_generator(co_Func, ...))
  else
    return coroutineRunner:StartCoroutine(util.cs_generator(func, ...))
  end
end

function Coroutine.Stop(c)
  coroutineRunner:StopCoroutine(c)
end

function Coroutine.StopAll()
  coroutineRunner:StopAllCoroutines()
end

function Coroutine.Yield(enumerator)
  coroutine.yield(enumerator)
end

function Coroutine.Wait(time)
  coroutine.yield(CS.UnityEngine.WaitForSeconds(time))
end

local sharedWaitForEndOfFrame = CS.UnityEngine.WaitForEndOfFrame()

function Coroutine.WaitForEndOfFrame()
  coroutine.yield(sharedWaitForEndOfFrame)
end

function Coroutine.Break()
  coroutine.yield(util.move_end)
end
