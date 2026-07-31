FunctionProfiler = {}
ENABLE_PROFILER = CS.UnityEngine.Debug.isDebugBuild

function FunctionProfiler.BeginSample(name, tag)
  if ENABLE_PROFILER then
    return CS.DebugTool.FunctionProfiler.BeginSample(StringPool.ToID(name), StringPool.ToID(tag))
  end
end

function FunctionProfiler.EndSample(id)
  if ENABLE_PROFILER then
    CS.DebugTool.FunctionProfiler.EndSample(id or -1)
  end
end
