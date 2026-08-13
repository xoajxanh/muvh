BuffRoleAction = {}
local this = BuffRoleAction
BuffRoleAction.RoleAnimationAction = {}

function BuffRoleAction.Init()
end

function BuffRoleAction.Update()
  for k, v in pairs(this.RoleAnimationAction) do
  end
end

function BuffRoleAction.PlayAction(buff_struct)
  local strs = string.split(buff_struct.buffAction.animationName, "#")
  local animationName = ""
  if strs == nil or #strs == 0 then
    animationName = ""
  else
    animationName = Mathf.RandomTableValue(strs)
  end
  if buff_struct.buffOwner ~= nil then
    buff_struct.buffOwner:PlayAnimation(animationName, 1, 0, 0)
  end
end

function BuffRoleAction.RemoveAction(buffOwner, removeType)
  if buffOwner ~= nil and removeType ~= RoleBuffRemoveType.CastSkill then
    buffOwner:PlayAnimation("attackend", 1, 0, 0)
  end
end

function BuffRoleAction.SpecialRemoveAction()
end

function BuffRoleAction.Destroy(rid)
end
