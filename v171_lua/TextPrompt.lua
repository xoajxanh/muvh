TextPrompt = class()
local this = TextPrompt

function TextPrompt:ctor(data)
  self:InitAttribute(data)
  self:InitGameObject()
end

function TextPrompt:InitAttribute(data)
  self.data = data
end

function TextPrompt:Destroy()
  self:DestroyGameObject()
end

function TextPrompt:GetParent()
  return self.data.parent
end

function TextPrompt:GetName()
  return self.data.name
end

function TextPrompt:InitGameObject()
  Coroutine.Start(self.InstantiateGameObj, self)
end

function TextPrompt:InstantiateGameObj()
  local path = "UI/Guide_PromptUI.prefab"
  local res = CS.Framework.ResourceManager.InstantiateAsync(path)
  Coroutine.Yield(res)
  if res.isError then
    Coroutine.Break()
  end
  self.gameObject = res.gameObject
  self.gameObject:SetActive(self.ActiveState or false)
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
  self:InitPosition()
  self:InitCanvas()
  self:InitScale()
  self:InitRotation()
  self:SetPromptText()
  self:SetArrows()
  self:SetAnimation()
end

function TextPrompt:DestroyGameObject()
  if self.gameObject then
    CS.Framework.ObjectEx.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
end

function TextPrompt:InitCanvas()
  if self.data.sortOrder and self.data.sortOrder ~= 0 then
    self.gameObject:GetComponent(typeof(CS.UnityEngine.Canvas)).enabled = true
  else
    self.gameObject:GetComponent(typeof(CS.UnityEngine.Canvas)).enabled = false
    self.gameObject:RemoveComponent(typeof(CS.UnityEngine.UI.GraphicRaycaster))
    self.gameObject:RemoveComponent(typeof(CS.UnityEngine.Canvas))
  end
end

function TextPrompt:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.posX, self.data.posY, self.data.posZ)
  if self.data.sortOrder and self.data.sortOrder ~= 0 then
    local objControl = UIControl(self.gameObject.transform)
    objControl:SetSortingOrder(self.data.sortOrder)
  end
end

function TextPrompt:SetPosition(x, y, z)
  if self.transform then
    self.pos:Set(x, y, z or 0)
    self.transform.localPosition = self.pos
  end
end

function TextPrompt:SetParent(parent)
  self.data.parent = parent
  if self.transform then
    self.transform:SetParent(parent)
  end
  if self.data then
    self.data.parent = parent.transform
  end
end

function TextPrompt:InitScale()
  self:SetScale(self.data.ScaleX, self.data.ScaleY, self.data.ScaleZ)
end

function TextPrompt:SetScale(x, y, z)
  if self.transform then
    self.transform.localScale = Vector3:One()
    self.transform:SetSizeDelta(self.data.ScaleX, self.data.ScaleY)
  end
end

function TextPrompt:InitRotation()
end

function TextPrompt:SetActive(state)
  if not self.data.isGuide then
    if GuideManager.GetGuideTextPromptActive() == true then
      state = false
    end
  elseif state == true then
    TextPromptUtility.HideTextPrompt()
  end
  self.ActiveState = state
  if self == nil or self.gameObject == nil then
    return
  end
  if IsNil(self.gameObject) == true then
    return
  end
  if self.gameObject and self.gameObject.transform then
    self.gameObject:SetActive(state)
  end
  if self.gameObject and self.gameObject.gameObject then
    self.gameObject.gameObject:SetActive(state)
  end
  self.TextPrompt:SetAnchoredPosition(Vector2.zero)
end

function TextPrompt:GetActive()
  if self == nil or self.gameObject == nil then
    return
  end
  if IsNil(self.gameObject) == true then
    return
  end
  if self.gameObject and self.gameObject.transform then
    return self.gameObject.activeSelf
  end
  if self.gameObject and self.gameObject.gameObject then
    return self.gameObject.gameObject.activeSelf
  end
end

function TextPrompt:SetPromptText()
  self.TextPrompt = self.gameObject.transform:Find("promptText")
  self.TextPrompt:GetComponent(typeof(CS.UnityEngine.UI.Text)).text = self.data.text
  self.Btn = UIControl(self.TextPrompt.transform)
  self.Btn:SetOnClick(self, self.TextOnClick)
  self.TextPrompt:SetSizeDelta(self.data.ScaleX, self.data.ScaleY)
end

function TextPrompt:TextOnClick()
  if self.data and self.data.ok then
    self.data.ok(self.data.okArgs)
  end
end

function TextPrompt:SetArrows()
  self.img_leftPrompt = self.gameObject.transform:Find("img_leftPrompt")
  self.img_rigthPrompt = self.gameObject.transform:Find("img_rigthPrompt")
  self.img_leftPrompt:SetSizeDelta(tonumber(self.data.ScaleXLeft), tonumber(self.data.ScaleYLeft))
  self.img_rigthPrompt:SetSizeDelta(tonumber(self.data.ScaleXRight), tonumber(self.data.ScaleYRight))
  self.img_leftPrompt.transform.localEulerAngles = Vector3(0, 0, tonumber(self.data.RolationZLeft))
  self.img_rigthPrompt.transform.localEulerAngles = Vector3(0, 0, tonumber(self.data.RolationZRight))
  self.img_leftPrompt.transform.localPosition = Vector3(tonumber(self.data.posXLeft), tonumber(self.data.posYLeft), tonumber(self.data.posZLeft))
  self.img_rigthPrompt.transform.localPosition = Vector3(tonumber(self.data.posXRight), tonumber(self.data.posYRight), tonumber(self.data.posZRight))
end

function TextPrompt:SetText(text)
  if self.TextPrompt then
    self.TextPrompt:GetComponent(typeof(CS.UnityEngine.UI.Text)).text = text
  end
end

function TextPrompt:GetText()
  if self.TextPrompt then
    return self.TextPrompt:GetComponent(typeof(CS.UnityEngine.UI.Text)).text
  end
end

function TextPrompt:SetAnimation()
  self.gameObject.transform:DOKill()
  local left = false
  
  local function MoveLeft()
    self.gameObject.transform:DOLocalMoveX(left and self.gameObject.transform.localPosition.x - 10 or self.gameObject.transform.localPosition.x + 10, 1):OnComplete(function()
      left = not left
      self.gameObject.transform:DOLocalMoveX(left and self.gameObject.transform.localPosition.x - 10 or self.gameObject.transform.localPosition.x + 10, 1):OnComplete(function()
        left = not left
        MoveLeft()
      end)
    end)
  end
  
  MoveLeft()
end
