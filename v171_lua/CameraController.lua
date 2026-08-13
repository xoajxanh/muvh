require("GamePlay/MainCamera")
CameraController = {}
local this = CameraController

function CameraController.Init()
  this.InitCamera()
  this.InitEvents()
end

function CameraController.InitEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_OnMeDestroy, this.OnRoleDestroy)
  this.eventContainer:Regist(Event.Logic_ActiveMainUI, this.OnActiveMainUI)
  this.eventContainer:Regist(Event.Logic_OpenSortPanel, this.OnOpenSortPanel)
  this.eventContainer:Regist(Event.Load_PreLoadEnd, this.OnPreLoadEnd)
end

function CameraController.OnActiveMainUI(_, state)
  if state and LoginData.InGame then
    MainCamera.SetCameraDev(Vector2.one)
    MainCamera.RefreshPosition()
  end
end

function CameraController.OnOpenSortPanel(_)
  if not LoginData.InGame then
    return
  end
  local devX = 0
  if UIManager.sortPanelPosAnchor[2].ui ~= nil then
    devX = UIManager.width / 2 - UIManager.sortPanelPosAnchor[2].pos
  elseif UIManager.sortPanelPosAnchor[1].ui ~= nil then
    devX = UIManager.width / 2 - UIManager.sortPanelPosAnchor[1].pos
  end
  local ratio = devX / UIManager.width / 2 + 0.2 * (UIManager.width / UIManager.idealWidth)
  MainCamera.SetCameraDev(Vector2.New(1 + ratio, 1 - ratio))
  MainCamera.RefreshPosition()
end

function CameraController.OnPreLoadEnd(_)
  if SceneData.textureType == "loading" then
    CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:OnEnterGame()
  end
  PreloadResourceData.ResetCount()
  UIManager.Hide(UIID.LoadingUI)
  MainCamera.AttachRole(RoleManager.me)
  EventManager.Dispatch(Event.CameraAttach)
  if not UIManager.IsVisible(UIID.MainMenuUI) then
    UIManager.Show(UIID.MainMenuUI)
    TipData.OpenShopTip()
  end
  if UIManager.IsVisible(UIID.MapNameUI) then
    Main_MapNameUI:Refresh()
  else
    UIManager.Show(UIID.MapNameUI)
  end
  Timer.Start(1, PreLoadManager.CatlikeLoadGuide)
  Timer.Start(3, PreLoadManager.CatlikeLoadRes)
end

function CameraController.OnRoleDestroy(_)
  MainCamera.Detach()
end

function CameraController.InitCamera()
  MainCamera.Init()
end

this.Init()
