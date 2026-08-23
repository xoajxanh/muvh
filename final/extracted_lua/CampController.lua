require("GameModel/CampData")
CampController = {}

function CampController.Init()
  CampController.messageContainer = EventContainer(NetManager)
  CampController.eventContainer = EventContainer(EventManager)
  CampController.RegistEvent()
  CampController.RegistMessages()
end

function CampController.RegistMessages()
end

function CampController.ResUnionList(id, msg)
end

function CampController.ResUnionKuaFuInfo(id, msg)
  CampData.RefreshUICampData(msg)
  EventManager.Dispatch(Event.Camp_detailUIData, msg)
end

function CampController.RegistEvent()
end

function CampController.goldUnionChange()
end

function CampController:UnionCamp(_indexer, _value)
  if _indexer == IndexerEnum.get then
    return ViewData.meData.unionCamp
  elseif _indexer == IndexerEnum.dis then
    if RoleManager.me.PKMode == ERolePkMode.Union then
      if SceneData.IsCrossRealm() and ViewData.meData.unionCamp > 0 then
        NetManager.Send(RoleMessage.ReqSetPKMode, {
          param = ERolePkMode.UnionKuaFu
        })
      end
    elseif RoleManager.me.PKMode == ERolePkMode.UnionKuaFu and (not SceneData.IsCrossRealm() or ViewData.meData.unionCamp == 0) then
      NetManager.Send(RoleMessage.ReqSetPKMode, {
        param = ERolePkMode.Union
      })
    end
    EventManager.Dispatch(Event.Camp_ChangeUnionCamp)
  end
end

function CampController.GetIsSameCamp(id)
  local player = RoleManager.GetRoleById(id)
  if player and ViewData.meData.unionCamp > 0 and ViewData.meData.unionCamp == player.data.unionCamp then
    return true
  end
  return false
end

function CampController.IsSameCamp(camp)
  if ViewData.meData.unionCamp > 0 and ViewData.meData.unionCamp == camp then
    return true
  end
  return false
end

CampController.Init()
