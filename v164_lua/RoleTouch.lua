RoleTouch = {}

function RoleTouch.Init()
  RoleTouch.RegistEvent()
end

function RoleTouch.RegistEvent()
  EventManager.Regist(Event.Touch_TargetClick, RoleTouch.OnClickTarget)
end

function RoleTouch.OnClickTarget(eventId, avatar)
  if avatar and not avatar.isDead and not QiJiHelperData.isAutoFight then
    RoleManager.me:SetAutoFight(AutoFightStrKey.None)
  end
end
