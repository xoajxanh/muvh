require("LuaCore/UI/UIEnum")
require("LuaCore/UI/Control/UIControl")
require("LuaCore/UI/Control/UIContainer")
require("LuaCore/UI/Control/UIScroll")
require("LuaCore/UI/Control/ItemDrag/UIBaseCellContainer")
require("LuaCore/UI/Control/ItemDrag/UIDragCellContainer")
require("LuaCore/UI/Control/ItemDrag/UIFixedCellContainer")
require("LuaCore/UI/BaseUI")
require("LuaCore/UI/Logic/LogicBase")
require("LuaCore/UI/AutoPopUIManager")
require("GameConst/MocaaServerModel")
HideUIPointByMapIdMgr = require("LuaCore/UI/HideUIPoint/HideUIPointByMapIdMgr")
UIManager = {}
local this = UIManager
UIManager.sortedUIs = {}
UIManager.uiCamera = nil
local name2UI = {}
local preName2UI = {}
local delayDestroyUI = {}
local destroyCol
local correlateTbl = {}
UIManager.AcceptAdapterTbl = {
  "Main_MainMenuUI",
  "Chat_ChatUI",
  "Main_StartGame",
  "Rank_EquipInfoUI",
  "Activity_DuoQiUI"
}
UIManager.isNeedPlayUIOpenSound = false

function UIManager.Init()
  UIManager.root = CS.Main.instance.uiRoot
  UIManager.adapter_WindowCanvasUI = UIManager.root:Find("Adapter_WindowCanvasUI")
  UIManager.width = CS.Main.instance.uiRoot.rect.width
  UIManager.height = CS.Main.instance.uiRoot.rect.height
  UIManager.ratio = this.height / CS.UnityEngine.Screen.height
  UIManager.idealWidth = CS.UnityEngine.Screen.width
  UIManager.uiCamera = CS.UnityEngine.GameObject.Find("UICamera"):GetComponent("Camera")
  AdapterUtility.Refresh(UIManager.adapter_WindowCanvasUI)
  this.InitLogic()
  this.InitEvents()
  EventManager.Regist(Event.Game_Restart, this.Destroy)
  HideUIPointByMapIdMgr:Init()
end

function UIManager.RefreshScaleRatio()
  UIManager.ratio = this.height / UnityEngineLua.Screen.height
  AdapterUtility.Refresh(UIManager.adapter_WindowCanvasUI)
end

function UIManager.InitEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.UI_Destroy, this.CollectRemoveUI)
  this.eventContainer:Regist(Event.CallBack_ReqPy, this.OnCallBack_ReqPy)
  this.eventContainer:Regist(Event.CallBack_OpenGameQuit, this.OnCallBack_OpenGameQuit)
  this.eventContainer:Regist(Event.CallBack_ScreenOrientation, this.OnCallBack_ScreenOrientation)
  this.eventContainer:Regist(Event.CallBack_ClearAppMemorySuc, this.OnCallBack_ClearAppMemorySuc)
  this.eventContainer:Regist(Event.CallBack_OnVoicePermesionSuc, this.OnCallBack_OnVoicePermesionSuc)
  this.eventContainer:Regist(Event.CallBack_SendSession, this.OnCallBack_SendSession)
  this.eventContainer:Regist(Event.KoreaSDKLog_CALLBACK, this.OnCallBack_KoreaSDKLog)
end

local function LoadLua(name)
  if not trequire("GameUI/" .. name) then
    logError("file " .. name .. ".lua not exist!")
    return nil
  end
  local ui = _G[name]
  if not ui then
    logError("table " .. name .. " not exist!")
    return nil
  end
  return ui
end

local uiPool = {}

function UIManager.Create(name, args, animation)
  local pool = uiPool[name]
  local ui = pool and table.remove(pool)
  if not ui then
    ui = LoadLua(name)
    if ui == nil then
      return nil
    end
    ui.name = name
    ui:Init()
    this.AddUI(nil, ui)
  end
  ui:SetArgs(args)
  ui:Show()
  return ui
end

function UIManager.Recycle(ui)
  local pool = uiPool[ui.name]
  if not pool then
    pool = {}
    uiPool[ui.name] = pool
  end
  ui:Hide()
  table.insert(pool, ui)
end

function UIManager.PreLoadUI(nameTbl)
  for _ = 1, table.count(nameTbl) do
    local name = table.remove(nameTbl)
    this.OnPreLoadUI(name)
  end
end

function UIManager.OnPreLoadUI(name)
  local ui = name2UI[name]
  if ui then
    return
  end
  ui = preName2UI[name]
  if ui then
    return
  end
  ui = LoadLua(name)
  if not ui then
    return nil
  end
  ui.name = name
  preName2UI[name] = ui
  this.SetUILogic(ui)
  ui:Preload()
end

function UIManager.JumpShow(type, name, args, animation)
  this.UICloseType(type, false)
  this.Show(name, args, animation)
end

function UIManager.ShowUILogo18(name)
  if name == nil or name == "" or name == UIID.Logo_18 then
    return
  end
  local loginUIIsShow = UIManager.IsVisible(UIID.LoginUI)
  local role_ResurgenceUIISShow = UIManager.IsVisible(UIID.Role_ResurgenceUI)
  local loginRoleUIIsShow = UIManager.IsVisible(UIID.LoginRoleUI)
  local loginCreateRoleUIIsShow = UIManager.IsVisible(UIID.LoginCreateRoleUI)
  local lockScreenUIShow = UIManager.IsVisible(UIID.LockScreenUI)
  if loginUIIsShow or role_ResurgenceUIISShow or loginRoleUIIsShow or loginCreateRoleUIIsShow or lockScreenUIShow then
    return
  end
  local uiCfg = ClientTable.cfg_Ui_logicManager:TryGetValue(name, "mainUI")
  if uiCfg and uiCfg.showLogo == 1 then
    local uiName = UIID.Logo_18
    if name2UI[uiName] then
      if not UIManager.IsVisible(uiName) then
        UIManager.Show(uiName)
      end
    else
      UIManager.Show(uiName)
    end
  end
end

function UIManager.Show(name, args, animation)
  this.CheckRemoveUI(name)
  local ui = name2UI[name]
  if not ui then
    ui = preName2UI[name]
    if ui then
      preName2UI[name] = nil
      ui:Init()
      ui:OnCreate()
      this.AddUI(name, ui)
    else
      ui = LoadLua(name)
      if not ui then
        return nil
      end
      ui.name = name
      ui:Init()
      this.AddUI(name, ui)
    end
  elseif ui.visible and ui.args == args then
    return
  end
  UIManager.ShowUILogo18(name)
  EventManager.Dispatch(Event.SDK_KOREAPAYREISSUE_CALLBACK, name)
  this.UILogicShow(ui, args)
  ui:SetArgs(args)
  ui:Show(animation)
  if args and args.correlationName then
    this.CollectCorrelation(args.correlationName, ui)
  end
  this.CleanUpCorrelation(ui.name)
  return ui
end

function UIManager.Hide(name, animation)
  local ui = name2UI[name]
  if ui and ui.visible then
    ui:Hide(animation)
    this.UILogicHide(ui)
  end
  UIManager.HideLogoR18(name)
  return ui
end

function UIManager.HideLogoR18(name)
  if name == UIID.Logo_18 then
    return
  end
  if not name2UI and table.count(name2UI) > 0 then
    return
  end
  local isShow = false
  for k, v in pairs(name2UI) do
    local uiCfg = ClientTable.cfg_Ui_logicManager:TryGetValue(k, "mainUI")
    if uiCfg and uiCfg.showLogo == 1 and v.visible and k then
      isShow = true
      break
    end
  end
  if not isShow then
    UIManager.Hide(UIID.Logo_18)
  end
end

function UIManager.IsVisible(name)
  local ui = name2UI[name]
  return ui and ui.visible
end

function UIManager.IsVisibleOrCorrelation(name, childUI)
  local ui = name2UI[name]
  local isVisible = ui and ui.visible
  if not isVisible and ui then
    isVisible = childUI.args and childUI.args.correlationName == name or false
  end
  return isVisible
end

function UIManager.GetUiByName(name)
  local ui = name2UI[name]
  return ui
end

function UIManager.CheckUIIsLoaded(name)
  local ui = name2UI[name] or preName2UI[name]
  if ui then
    return ui.loaded
  else
    return false
  end
end

function UIManager.SwitchVisible(name)
  if this.IsVisible(name) then
    this.Hide(name)
  else
    this.Show(name)
  end
end

local function EqualOrIn(name, names)
  if type(names) == "table" then
    return table.contains(names, name)
  else
    return name == names
  end
end

function UIManager.UICloseType(type, needShowMain)
  for _, v in ipairs(this.sortedUIs) do
    if v.logicTbl ~= nil and v.visible then
      if not type or type ~= v.logicTbl.type then
      end
      v:Hide()
      v.logicTbl.sortPos = nil
    end
  end
  UIManager.InitLogic()
  if needShowMain then
    EventManager.Dispatch(Event.Logic_ActiveMainUI, true)
  end
end

function UIManager.HideAll(excepts)
  for _, v in ipairs(this.sortedUIs) do
    if v.visible and not EqualOrIn(v.name, excepts) then
      v:Hide()
      if v.logicTbl then
        v.logicTbl.sortPos = nil
      end
    end
  end
  UIManager.InitLogic()
end

function UIManager.Destroy()
  for _, v in ipairs(this.sortedUIs) do
    v:Destroy()
  end
  this.sortedUIs = {}
  this.name2UI = {}
  for _, uis in pairs(uiPool) do
    for k, v in ipairs(uis) do
      v:Destroy()
    end
  end
  uiPool = {}
  for _, v in pairs(preName2UI) do
    v:Destroy()
  end
  preName2UI = {}
end

function UIManager.AddUIAnother(name, ui)
  if name then
    name2UI[name] = ui
  end
end

function UIManager.AddUI(name, ui)
  if name then
    name2UI[name] = ui
  end
  local index
  for k, v in ipairs(this.sortedUIs) do
    if ui.layer > v.layer or ui.layer == v.layer and ui.orderInLayer >= v.orderInLayer then
      index = k
      break
    end
  end
  if index then
    table.insert(this.sortedUIs, index, ui)
  else
    table.insert(this.sortedUIs, ui)
  end
end

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode

function UIManager.Update()
  if Input.GetKeyDown(KeyCode.Escape) then
    this.OnEscClose()
  end
  this.OnKeyInput()
  for k, v in ipairs(this.sortedUIs) do
    if v.visible and v.loaded and v.Update then
      v:Update()
    end
  end
  if this.isNeedPlayUIOpenSound then
    AudioManager.PlayMusicClipById(6205)
    this.isNeedPlayUIOpenSound = false
  end
end

function UIManager.LateUpdate()
  for k, v in ipairs(this.sortedUIs) do
    if v.visible and v.loaded and v.LateUpdate then
      v:LateUpdate()
    end
  end
end

function UIManager.OnEscClose()
  local processed = false
  for _, v in ipairs(this.sortedUIs) do
    if v.visible and v:OnEscClose() then
      processed = true
      break
    end
  end
  if not processed and this.escUI then
    UIManager.Show(this.escUI)
  end
  if not CS.Framework.ResourceManager.editorMode and not processed and (name2UI[UIID.PromptTipUI] or preName2UI[UIID.PromptTipUI]) then
    local title = {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "X\195\161c nh\225\186\173n tho\195\161t game",
      cancelText = "",
      okText = "",
      cancel = nil,
      ok = function()
        Application.Quit()
      end
    }
    UIManager.Show(UIID.PromptTipUI, title)
  end
end

function UIManager.OnKeyInput()
  for _, v in ipairs(this.sortedUIs) do
    if v.visible and v.loaded and v.input and v.OnKeyInput and v:OnKeyInput() then
      break
    end
  end
end

local UILogicCfg = {}
local logicTbl = {}
UIManager.sortPanelPosAnchor = {}
UIManager.logicUIStack = {}

function UIManager.InitLogic()
  UILogicCfg = ClientTable.cfg_Ui_logicManager:GetDic()
  this.logicUIStack = Stack:New()
  this.sortPanelPosAnchor = {
    [1] = {pos = 425, ui = nil},
    [2] = {pos = 0, ui = nil}
  }
end

function UIManager.SetUILogic(ui)
  if not ui.logicTbl then
    local logic
    for _, tempLogic in pairs(UILogicCfg) do
      if tempLogic.mainUI == ui.name then
        logic = tempLogic
        break
      end
    end
    if logic then
      ui.logicTbl = logic
      if ui.logicTbl.type == UIPanelType.SortAndHide then
        ui.orderInLayer = 0
      end
      ui.hideFunc = UIHideFunc.MoveOutOfScreen
      ui.hideType = UIHideType.Hide
    end
  end
end

function UIManager.UILogicShow(ui, args)
  this.SetUILogic(ui)
  if ui.logicTbl == nil then
    return
  end
  if not logicTbl[ui.logicTbl.type] then
    local logicTypeName = "LuaCore/UI/Logic/LogicType" .. ui.logicTbl.type
    logicTbl[ui.logicTbl.type] = require(logicTypeName)
  end
  logicTbl[ui.logicTbl.type]:LogicShow(ui, args)
  this.isNeedPlayUIOpenSound = true
end

function UIManager.UILogicHide(ui)
  if not ui.logicTbl then
    return
  end
  logicTbl[ui.logicTbl.type]:LogicHide(ui)
end

function UIManager.UILogicClose(ui, flag)
  ui:Hide()
  if flag then
    this.logicUIStack:Push(ui)
  end
end

function UIManager.UICloseRank(ui, rank)
  for _, v in ipairs(this.sortedUIs) do
    if v.logicTbl ~= nil and v ~= ui and v.visible and v.logicTbl.type == UIPanelType.SortAndHide and rank <= v.logicTbl.rank then
      v:Hide()
      this.ClearSortPos(v)
    end
  end
end

function UIManager.ClearSortPos(ui)
  for i, v in pairs(this.sortPanelPosAnchor) do
    if v.ui and v.ui.name == ui.name then
      this.sortPanelPosAnchor[i].ui = nil
    end
  end
end

function UIManager.NeedHideMainUI(type)
  return type == UIPanelType.NormalAndHide or type == UIPanelType.SortAndHide
end

local function RemoveUI()
  for _, ui in pairs(delayDestroyUI) do
    this.DoRemoveUI(ui.name)
  end
end

function UIManager.CollectRemoveUI(_, ui)
  delayDestroyUI[ui.name] = ui
  if destroyCol then
    Timer.Stop(destroyCol)
    destroyCol = nil
  end
  destroyCol = Timer.Start(5, RemoveUI)
end

function UIManager.OnCallBack_ReqPy(_, msg)
  if msg == "1" or msg == 1 then
    UIManager.Show(UIID.WaitingUI, {msg = ""})
  elseif UIManager.IsVisible(UIID.WaitingUI) then
    UIManager.Hide(UIID.WaitingUI)
  end
end

function UIManager.OnCallBack_KoreaSDKLog(_, msg)
  local isopensdk = false
  local configJson = ""
  if CS.MuInterface.Instance.GetVersionConfig then
    configJson = CS.MuInterface.Instance:GetVersionConfig()
  end
  if not string.isNullOrEmpty(configJson) then
    local config = json.decode(configJson)
    if not string.isNullOrEmpty(config.isopensdk) then
      isopensdk = tonumber(config.isopensdk) == 1
    end
  end
  if KoreaEorroData and isopensdk == true then
    local datas = KoreaEorroData:onGetErrorCode(msg)
    if datas then
      logError(datas)
      FloatingWordUtility.QuickMsg("code:" .. msg)
    else
      FloatingWordUtility.QuickMsg("code:" .. msg)
    end
  end
end

function UIManager.GetMocaaServerMode()
  local configJson = ""
  local ServerMode = MocaaServerModelType.null
  if CS.MuInterface.Instance.GetVersionConfig then
    configJson = CS.MuInterface.Instance:GetVersionConfig()
  end
  if not string.isNullOrEmpty(configJson) then
    local config = json.decode(configJson)
    if not string.isNullOrEmpty(config.koreaenv) then
      if config.koreaenv == "alpha" then
        ServerMode = MocaaServerModelType.alpha
      elseif config.koreaenv == "live" then
        ServerMode = MocaaServerModelType.live
      end
    end
  end
  return ServerMode
end

function UIManager.OnCallBack_OpenGameQuit(_)
  logError("UIManager.OnCallBack_OpenGameQuit ")
end

function UIManager.OnCallBack_ScreenOrientation(_, msg)
  AdapterUtility.Refresh(UIManager.adapter_WindowCanvasUI)
end

function UIManager.OnCallBack_ClearAppMemorySuc(_)
  logError("UIManager.OnCallBack_ClearAppMemorySuc ")
end

function UIManager.OnCallBack_OnVoicePermesionSuc(_, msg)
  VoiceData.HasVoicePermission = msg == "0"
  logError("UIManager.OnCallBack_OnVoicePermesionSuc ", VoiceData.HasVoicePermission)
end

function UIManager.OnCallBack_SendSession(msg1)
  NetManager.Send(CommonMessage.ReqService, {
    token = CS.Main.instance.SdkSession,
    type = RiskSpotManager.riskSpotType
  })
end

function UIManager.DoRemoveUI(name)
  delayDestroyUI[name] = nil
  name2UI[name] = nil
  package.loaded["GameUI/" .. name] = nil
  local index
  for k, v in pairs(this.sortedUIs) do
    if v.name == name then
      index = k
      break
    end
  end
  if index then
    table.remove(this.sortedUIs, index)
  end
end

function UIManager.CheckRemoveUI(name)
  if destroyCol then
    Timer.Stop(destroyCol)
    destroyCol = nil
  end
  if delayDestroyUI[name] then
    this.DoRemoveUI(name)
  end
  destroyCol = Timer.Start(5, RemoveUI)
end

function UIManager.CollectCorrelation(uiid, ff)
  if not correlateTbl[uiid] then
    correlateTbl[uiid] = ff
  end
end

function UIManager.CleanUpCorrelation(uiid)
  if correlateTbl[uiid] then
    local ff = correlateTbl[uiid]
    if ff.args then
      ff.args.correlationName = nil
    end
  end
end

function UIManager.Logout()
  if type(name2UI) ~= "table" then
    return
  end
  for k, v in pairs(name2UI) do
    if v.OnLogOut ~= nil then
      v.OnLogOut(v)
    end
  end
end

function UIManager.GetGoByPoint(point)
  if point.uiName == nil or point.pointName == nil then
    return
  end
  local uiPanel = UIManager.GetUiByName(point.uiName)
  if uiPanel then
    return uiPanel[point.pointName] or uiPanel:GetSubUI(point.pointName)
  end
end

UIManager.Init()
