InstantiateManager = {}
local this = InstantiateManager
local maxInstantiatePerFrame = 10
local m_CurrentFrame = -1
local m_CurrentInstantiate = 0

local function CheckInstantiateCount()
  if not Application.isPlaying then
    return true
  end
  if m_CurrentFrame ~= Time.frameCount then
    m_CurrentFrame = Time.frameCount
    m_CurrentInstantiate = 1
    return true
  else
    if m_CurrentInstantiate < maxInstantiatePerFrame then
      m_CurrentInstantiate = m_CurrentInstantiate + 1
      return true
    end
    return false
  end
end

local function DoInstantiate(t)
  while not CheckInstantiateCount() do
    Coroutine.WaitForEndOfFrame()
  end
  local go = t.template:Instantiate(t.parent)
  if t.ui then
    t.CallBack(t.ui, go, sunpack(t.args))
  else
    t.CallBack(go, sunpack(t.args))
  end
end

function InstantiateManager.Instantiate(template, parent, callBack, ui, ...)
  local t = {
    template = template,
    parent = parent,
    CallBack = callBack,
    ui = ui,
    args = spack(...)
  }
  Coroutine.Start(DoInstantiate, t)
end
