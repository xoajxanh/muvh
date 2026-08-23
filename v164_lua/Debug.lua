local Debug = CS.UnityEngine.Debug
local isDebugBuild = Debug.isDebugBuild
local logEnable = CS.Main.instance.IsShowLog
local logErrorEnable = true
local logTime = true

local function timestr()
  local time = Time.realtimeSinceStartup
  local seconds = math.floor(time)
  local minutes = seconds // 60
  seconds = seconds % 60
  local milliseconds = math.floor((time - seconds) * 1000)
  return string.format("[%02d:%02d.%03d]", minutes, seconds, milliseconds)
end

local function concat(...)
  local args = spack(...)
  for i = 1, args.n do
    args[i] = tostring(args[i])
  end
  local str = table.concat(args, "\t")
  str = "s\227\128\144LUALOG\227\128\145" .. (logTime and timestr() .. str or str)
  return str
end

function log(...)
  if logEnable then
    Debug.Log(concat(...) .. "\n" .. debug.traceback())
  end
end

function logWarning(...)
  if logEnable then
    Debug.LogWarning(concat(...) .. "\n" .. debug.traceback())
  end
end

function logError(...)
  if logErrorEnable then
    Debug.LogError(concat(...) .. "\n" .. debug.traceback())
  end
end

function logPurple(...)
  if logEnable then
    local str = concat(...)
    str = string.GetColorText(str, "#D916D9")
    Debug.Log(str .. "\n" .. debug.traceback())
  end
end

function logOrange(...)
  if logEnable then
    local str = concat(...)
    str = string.GetColorText(str, "#FF7300")
    Debug.Log(str .. "\n" .. debug.traceback())
  end
end

function logTable(t, name)
  local spaceAdd = 4
  
  local function getTableStr(t, name, space)
    local str = string.format("%s%s = {\n", string.rep(" ", space - spaceAdd), name or "table")
    local init = false
    for k, v in pairs(t) do
      if type(v) == "table" then
        str = str .. getTableStr(v, k, space + spaceAdd)
      else
        if type(v) == "string" and string.len(v) > 2 and string.sub(v, 1, 3) == "cs." then
          init = true
        end
        str = str .. string.format("%s%s = %s\n", string.rep(" ", space), k, v)
      end
    end
    str = str .. string.rep(" ", space - spaceAdd) .. "}\n"
    return str
  end
  
  if type(t) == "table" then
    logError("\n" .. getTableStr(t, name, spaceAdd))
  else
    logError(t)
  end
end

print = log
