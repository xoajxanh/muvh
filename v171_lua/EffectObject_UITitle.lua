local EffectObject_UITitle = {}
setmetatable(EffectObject_UITitle, LuaClass.EffectObject_Title)

function EffectObject_UITitle:Refresh(data)
  self:RunBaseFunction("Refresh", data)
  if data == nil or data.panel == nil then
    return
  end
  self.parentPanel = data.panel
  self.layer = UI_LAYER
end

function EffectObject_UITitle:EffectLoadCallBack(effectObj, name)
  self:RunBaseFunction("EffectLoadCallBack", effectObj, name)
  if effectObj == nil then
    return
  end
  self:SetRender(effectObj)
end

function EffectObject_UITitle:SetRender(go)
  if go == nil or IsNil(go) then
    return
  end
  local orderLayer = self:GetOrderLayer()
  if self.parentPanel then
    local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
    for i = 0, renders.Length - 1 do
      local rend = renders[i]
      rend.sortingOrder = orderLayer + 100
    end
  end
  local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  for i = 0, sys.Length - 1 do
    local par = sys[i]
    par.gameObject.layer = self:GetLayer()
    if self.parentPanel then
      par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = orderLayer + 50
    end
  end
end

function EffectObject_UITitle:GetOrderLayer()
  local orderLayer = 400
  if self.parentPanel then
    orderLayer = self.parentPanel.root.canvas.sortingOrder
  end
  return orderLayer
end

function EffectObject_UITitle:Reset()
  self:RunBaseFunction("Reset")
  self.parentPanel = nil
end

return EffectObject_UITitle
