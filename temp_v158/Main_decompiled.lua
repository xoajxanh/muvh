MAIN = true
require("UnityEngine/UnityEngine")
require("UtilityCommon/Common")
require("CSScripts/CSScripts")
TableLoad = require("Config/table/TableLoad")
require("GameConst/AcquireGameConst")
require("Utility/Utility")
require("Config/ConfigManager")
require("Config/GlobalConfig")
require("Localization/Localization")
require("LuaCore/AcquireLuaCore")
require("GamePlay/PoolManager/TableDataPool")
require("GameController/GameLogic")
require("GamePlay/GamePlay")
require("EmmyluaDebug")
gameMgr = require("GameMgr")
luaClassManager = require("LuaCore/LuaClass/LuaClassManager")
luaTemplateManager = require("LuaCore/LuaTemplate/LuaTemplateManager")
RedPointLoader = require("GamePlay/RedPoint/Base/RedPointLoader")
QuickFind = require("QuickFind/QuickFind")
local Main = {}
local this = Main

function Main.Start()
  collectgarbage("setpause", 120)
  collectgarbage("setstepmul", 500)
  TableLoad:Init()
  CS.UnityEngine.Application.runInBackground = true
  Game.New():OnInit()
  Profiler.BeginSample("MAIN.Start")
  Coroutine.Start(Main.DoStart, Main)
  Profiler.BeginSample("MAIN.Start")
  EventManager.Regist(Event.Game_Restart, this.Destroy)
  EmmyluaDebug.InitEmmyluaDebug()
  luaClassManager:Initialize()
  luaTemplateManager:Initialize()
  gameMgr:Initialize()
  RedPointLoader:Initialize()
  QuickFind:Init()
end

function Main.DoStart()
  ConfigManager.Preload()
  this.InitCallback()
  this.InitScreen()
  LoginData.LoginLog("------------\229\136\157\229\167\139\229\140\150shader:::::" .. tostring(CS.System.DateTime.Now.Ticks))
  this.InitRes()
  LoginData.LoginLog("------------\229\136\157\229\167\139\229\140\150shader\229\174\140\230\136\144,\229\138\160\232\189\189\229\156\176\229\189\162\229\188\128\229\167\139:::::" .. tostring(CS.System.DateTime.Now.Ticks))
  Scene.EnterLogin()
  LoginData.LoginLog("------------\232\174\176\229\189\149\229\174\140\230\136\144:::::" .. tostring(CS.System.DateTime.Now.Ticks))
end

function Main.InitCallback()
  local main = CS.Main.instance
  main.updateWithTime = this.Update
  main.lateUpdate = this.LateUpdate
  main.onLowMemory = this.OnLowMemory
  main.onSceneLoaded = this.OnSceneLoaded
  main.onApplicationFocus = this.OnApplicationFocus
  main.onApplicationPause = this.OnApplicationPause
  main.onApplicationQuit = this.OnApplicationQuit
end

function Main.ClearCallback()
  local main = CS.Main.instance
  main.updateWithTime = nil
  main.lateUpdate = nil
  main.onLowMemory = nil
  main.onSceneLoaded = nil
  main.onApplicationFocus = nil
  main.onApplicationPause = nil
  main.onApplicationQuit = nil
end

function Main.InitScreen()
  this.settingFps = tonumber(GlobalConfig.GetGlobalConfig(2150001))
  this.fpsTime = tonumber(GlobalConfig.GetGlobalConfig(2150002))
end

function Main.InitRes()
  if not CS.Framework.ResourceManager.editorMode then
    this.InitShader()
  end
end

function Main.InitShader()
  local request = CS.Framework.ResourceManager.LoadAssetAsync("Shader/ShaderVariantCollection.shadervariants", typeof(CS.UnityEngine.ShaderVariantCollection))
  Coroutine.Yield(request)
  if request.isError then
    logError(request.error)
    Coroutine.Break()
  end
  request.res:WarmUp()
  CS.Framework.ShaderEx.Init(request.task.bundleRequest.res)
end

function Main.Destroy()
  this.ClearCallback()
  QuickFind:Destory()
end

function Main.Update(deltaTime, unscaledDeltaTime)
  Profiler.BeginSample("Timer.RedPointManager")
  RedPointManager:Update()
  Profiler.EndSample()
  Profiler.BeginSample("Timer.Update")
  this.UpdateTime(deltaTime, unscaledDeltaTime)
  Profiler.EndSample()
  Profiler.BeginSample("NetManager.Update")
  NetManager.Update()
  Profiler.EndSample()
  Profiler.BeginSample("GameLogic.Update")
  GameLogic.Update()
  Profiler.EndSample()
  Profiler.BeginSample("GamePlay.Update")
  GamePlay.Update()
  Profiler.EndSample()
  Profiler.BeginSample("UIManager.Update")
  UIManager.Update()
  Profiler.EndSample()
  Profiler.BeginSample("PoolManagerTest.Update")
  PoolManagerTest.Update()
  Profiler.EndSample()
  DelayRefreshManager:Update()
  Profiler.BeginSample("Utility.Update")
  Utility.Update()
  Profiler.EndSample()
  Profiler.BeginSample("GameMgr.Update")
  gameMgr:Update()
  Profiler.EndSample()
end

function Main.UpdateTime(time, unscaledTime)
  Time.Update(time, unscaledTime)
  Timer.Update()
  UnscaledTimer.Update()
end

function Main.LateUpdate()
  Profiler.BeginSample("GameLogic.LateUpdate")
  GameLogic.LateUpdate()
  Profiler.EndSample()
  Profiler.BeginSample("GamePlay.LateUpdate")
  GamePlay.LateUpdate()
  Profiler.EndSample()
  Profiler.BeginSample("UIManager.LateUpdate")
  UIManager.LateUpdate()
  Profiler.EndSample()
end

function Main.OnLowMemory()
  logPurple("Low memory reported!")
  PoolManagerTest.Destroy()
  EventManager.Dispatch(Event.Game_LowMemory)
  CS.Framework.ResourceManager.ClearMemory()
  collectgarbage("collect")
  CS.System.GC.Collect()
end

function Main.OnSceneLoaded(name)
  EventManager.Dispatch(Event.Game_SceneLoaded, name)
end

function Main.OnApplicationFocus(focus)
  EventManager.Dispatch(Event.Game_ApplicationFocus, focus)
end

function Main.OnApplicationPause(pause)
  EventManager.Dispatch(Event.Game_ApplicationPause, pause)
end

function Main.OnApplicationQuit()
  EventManager.Dispatch(Event.Game_ApplicationQuit)
end

local detailTime = 0
local totalTime = 0
local FpsTab = {}

function Main.FpsCheck()
  if GameSettingsData.perfermanceOption ~= EPerfermanceType.Low then
    detailTime = detailTime + 0.02
    totalTime = totalTime + 0.02
    if 1 <= detailTime then
      detailTime = 0
      if CS.DebugTool.FPSCounter.s_fps > 10 then
        table.insert(FpsTab, CS.DebugTool.FPSCounter.s_fps)
      end
    end
    if totalTime >= this.fpsTime then
      local totalCount = 0
      for i, v in ipairs(FpsTab) do
        totalCount = totalCount + v
      end
      if totalCount / table.count(FpsTab) < this.settingFps then
        GameSettingsController.SetPerfermanceLevel(EPerfermanceType.Low)
      else
        FpsTab = {}
        totalTime = 0
      end
    end
  end
end

Main.Start()
