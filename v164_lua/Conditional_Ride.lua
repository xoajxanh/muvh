Conditional_Ride = class(BaseConditional)
Conditional_Ride.name = "Conditional_Ride"

function Conditional_Ride:Calc(tblSkill, tblAction)
  if tblSkill.needRide == "" then
    return true
  end
  local needRides = string.split(tblSkill.needRide, "#")
  local rider = RoleManager.me.mountData
end
