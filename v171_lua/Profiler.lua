Profiler = {}
ENABLE_PROFILER = CS.UnityEngine.Debug.isDebugBuild
local LuaProfiler = CS.Framework.LuaProfiler

function Profiler.BeginSample(name)
  if ENABLE_PROFILER then
    LuaProfiler.BeginSample(StringPool.ToID(name))
  end
end

function Profiler.BeginSampleFunc(func)
  if ENABLE_PROFILER then
    local info = debug.getinfo(func, "nSl")
    local text = info.source .. ":" .. info.linedefined
    if info.name then
      text = info.name .. "@" .. text
    end
    Profiler.BeginSample(text)
  end
end

function Profiler.EndSample()
  if ENABLE_PROFILER then
    LuaProfiler.EndSample()
  end
end

function Profiler.BeginTime()
end

function Profiler.EndTime(name)
end
