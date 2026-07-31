TextPromptUtility = {}
local this = TextPromptUtility
TextPromptUtility.UIPrompt = {}

function TextPromptUtility.SetTextPrompt(data, state)
  local promptData = {
    text = data.text,
    parent = data.gameObject.transform,
    posX = tonumber(data.pos.x),
    posY = tonumber(data.pos.y),
    posZ = tonumber(data.pos.z),
    ScaleX = tonumber(data.scale.x),
    ScaleY = tonumber(data.scale.y),
    posXLeft = data.posLeft.x,
    posYLeft = data.posLeft.y,
    posZLeft = data.posLeft.z,
    ScaleXLeft = data.scaLeft.x,
    ScaleYLeft = data.scaLeft.y,
    RolationZLeft = data.rotationLeft,
    posXRight = data.posRight.x,
    posYRight = data.posRight.y,
    posZRight = data.posRight.z,
    ScaleXRight = data.scaRight.x,
    ScaleYRight = data.scaRight.y,
    RolationZRight = data.rotationRight,
    arrows = data.arrows,
    ok = data.ok,
    okArgs = data.okArgs,
    sortOrder = data.sortOrder,
    removeCanvas = data.removeCanvas,
    state = state
  }
  local prompt = TextPrompt(promptData)
  table.insert(this.UIPrompt, prompt)
  
  local function waitActive()
    Coroutine.Wait(0.1)
    if GuideManager.GetGuideTextPromptActive() == true then
      prompt:SetActive(false)
    else
      prompt:SetActive(state or false)
    end
  end
  
  Coroutine.Start(waitActive, self)
  return prompt
end

function TextPromptUtility.HideTextPrompt()
  for k, v in pairs(this.UIPrompt) do
    if v.Drug then
      v.Drug:SetActive(false)
    else
      v:SetActive(false)
    end
  end
end

function TextPromptUtility.ShowTextPrompt()
  for k, v in pairs(this.UIPrompt) do
    if v.Drug then
      v.Drug:SetActive(true)
    elseif v and v.data and v.data.state then
      v:SetActive(v.data.state)
    end
  end
end
