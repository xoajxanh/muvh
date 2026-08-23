SceneTouchEffect = {}
local TouchEffect
local TouchShaderActions = {}
local this = SceneTouchEffect

function SceneTouchEffect.Update()
end

function SceneTouchEffect.ChangeProperty(action)
end

local terrinEffect

function SceneTouchEffect.InitTerrain()
  if TouchEffect == nil then
    local effectModel = CS.Framework.GameModel("mouseTouch", SkillMgr.ROOT, function(go, name)
      terrinEffect = go:GetComponentInChildren(typeof(CS.Framework.ScreenTerrrinEffect))
    end)
    effectModel:LoadAsync("Effect/Scene/dianji.prefab")
    TouchEffect = effectModel.gameObject
    TouchEffect:SetActive(false)
  end
  EventManager.Regist(Event.Game_Restart, this.Destroy)
end

function SceneTouchEffect.Destroy()
  if TouchEffect then
    CS.Framework.ObjectEx.Destroy(TouchEffect)
    TouchEffect = nil
  end
end

function SceneTouchEffect.Play(pos)
  if TouchEffect then
    TouchEffect:SetActive(false)
  end
  if terrinEffect then
    this.OnInitEffect(terrinEffect, pos)
  end
  if TouchEffect then
    TouchEffect.transform:SetPosition(pos.x, pos.y, pos.z)
    TouchEffect:SetActive(true)
  end
end

local topLeft, topCenter, topRight, centerLeft, center, centerRight, bottomLeft, bottomCenter, bottomRight, centerCell

function SceneTouchEffect.OnInitEffect(terrinEffect, pos)
  centerCell = Scene.GetCellByPos(pos)
  terrinEffect:InitEffect(centerCell.x, centerCell.y, pos)
end
