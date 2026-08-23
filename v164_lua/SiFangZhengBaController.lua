SiFangZhengBaController = {}
local this = SiFangZhengBaController

function SiFangZhengBaController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function SiFangZhengBaController.RegistEvent()
  this.messageContainer:Regist(MapMessage.ResUnionSiFangZhengBaInfo, this.OnResUnionKuaFuGongChengZhanInfo)
end

function SiFangZhengBaController.OnReqUnionKuaFuGongChengZhanInfo()
  networkRequest.ReqUnionSiFangZhengBaInfo()
end

function SiFangZhengBaController.OnReqUnionKuaFuGongChengZhanBaoMing(targetServerId)
  networkRequest.ReqUnionSiFangZhengBaBaoMing(targetServerId)
end

function SiFangZhengBaController.OnResUnionKuaFuGongChengZhanInfo(_, msg)
  if msg then
    QuickFind:GetSiFangZhengBaDataManager():SetUnionListData(msg)
    EventManager.Dispatch(Event.RefreshSiFangZhengBaUI)
  end
end

function SiFangZhengBaController.CheckActivityOpen()
  local isOpen = QuickFind:GetSiFangZhengBaDataManager():GetIsOpenSiFangZhengBa()
  if isOpen == false then
    return false
  end
  local isFinished = QuickFind:GetSiFangZhengBaDataManager():CheckActivityFinish()
  if isOpen == true and isFinished == true then
    return false
  end
  local needLevel = QuickFind:GetSiFangZhengBaDataManager():GetNeedLevel()
  if needLevel > ViewData.meData.level then
    return false
  end
  if TranScriptData.InTranscript == true or TranScriptData.InAllGodsscript == true then
    return false
  end
  if FourPartyRivalryManager:CheckInFourPartyRivalryMap(SceneData.mapId) then
    return false
  end
  if RoleManager.me.unionId == 0 then
    return false
  end
  local isAlreadyRuWei = QuickFind:GetSiFangZhengBaDataManager():GetIsAlreadyRuWei()
  if isAlreadyRuWei == false then
    return false
  end
  local isEnough = QuickFind:GetSiFangZhengBaDataManager():GetUnionNumber()
  if isEnough == false then
    return false
  end
  return true
end
