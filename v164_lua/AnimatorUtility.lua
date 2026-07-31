AnimatorUtility = {}
local this = AnimatorUtility

function AnimatorUtility.GetAnimationClip(animator, motionName, layer)
  local state = this.GetAnimatorState(animator, motionName, layer)
  return state and state.motion
end

function AnimatorUtility.GetAnimatorState(animator, stateName, layer)
  if not animator then
    return nil
  end
  layer = layer or 0
  local motionDepthDesc = string.split(stateName, ".")
  local animatorController = animator.runtimeAnimatorController
  local animatorControllerLayer = animatorController.layers[layer]
  local state
  if #motionDepthDesc == 1 then
    local animatorStates = animatorControllerLayer.stateMachine.states
    for i = 0, animatorStates.Length - 1 do
      if animatorStates[i].state.name == motionDepthDesc[1] then
        state = animatorStates[i].state
        break
      end
    end
  else
    local curStateMachines = animatorControllerLayer.stateMachine.stateMachines
    for i = 1, #motionDepthDesc - 2 do
      for j = 0, curStateMachines.Length - 1 do
        if curStateMachines[j].stateMachine.name == motionDepthDesc[i] then
          curStateMachines = curStateMachines[j].stateMachine.stateMachines
        end
      end
    end
    local targetStateMachine
    for i = 0, curStateMachines.Length - 1 do
      if curStateMachines[i].stateMachine.name == motionDepthDesc[#motionDepthDesc - 1] then
        targetStateMachine = curStateMachines[i].stateMachine
      end
    end
    local animatorStates = targetStateMachine.states
    for i = 0, animatorStates.Length - 1 do
      if animatorStates[i].state.name == motionDepthDesc[#motionDepthDesc] then
        state = animatorStates[i].state
        break
      end
    end
  end
  return state
end
