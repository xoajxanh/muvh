UIControl = class()
require("GameConst/TextAnchorEnum")
local Object = CS.UnityEngine.Object
local UI = CS.UnityEngine.UI
local Canvas = CS.UnityEngine.Canvas
local ContentSizeFitter = UI.ContentSizeFitter
local CanvasGroup = CS.UnityEngine.CanvasGroup
local GraphicRaycaster = UI.GraphicRaycaster
local LayoutGroup = UI.LayoutGroup
local ScrollRect = UI.ScrollRect
local ToggleGroup = UI.ToggleGroup
local Graphic = UI.Graphic
local Selectable = UI.Selectable
local RectTransform = CS.UnityEngine.RectTransform
local Custom_ScrollRect = CS.Custom_UI.Custom_ScrollRect
local GridLayoutGroup = CS.UnityEngine.UI.GridLayoutGroup
setgetters(UIControl, {
  transform = function(self)
    local trans = (string.isNullOrEmpty(self.path) or IsNil(self.parent)) and self.parent or self.parent:Find(self.path)
    if trans == nil or IsNil(trans) then
      return nil
    end
    self.transform = trans
    return self.transform
  end,
  gameObject = function(self)
    self.gameObject = self.transform.gameObject
    return self.gameObject
  end,
  canvas = function(self)
    local canvas = self.gameObject:GetComponent(typeof(Canvas))
    self.canvas = canvas
    return canvas
  end,
  canvasGroup = function(self)
    local canvasGroup = self.gameObject:GetComponent(typeof(CanvasGroup))
    self.canvasGroup = canvasGroup
    return canvasGroup
  end,
  layoutGroup = function(self)
    local layoutGroup = self.gameObject:GetComponent(typeof(LayoutGroup))
    self.layoutGroup = layoutGroup
    return layoutGroup
  end,
  verticalLayoutGroup = function(self)
    return self.layoutGroup
  end,
  scrollRect = function(self)
    local scrollRect = self.gameObject:GetComponent(typeof(ScrollRect))
    self.scrollRect = scrollRect
    return scrollRect
  end,
  toggleGroup = function(self)
    local toggleGroup = self.gameObject:GetComponent(typeof(ToggleGroup))
    self.toggleGroup = toggleGroup
    return toggleGroup
  end,
  rectTransform = function(self)
    local rectTransform = self.gameObject:GetComponent(typeof(RectTransform))
    self.rectTransform = rectTransform
    return rectTransform
  end,
  gridContainer = function(self)
    local gridContainer = self.gameObject:GetComponent(typeof(CS.Framework.UIGridContainer))
    self.gridContainer = gridContainer
    return gridContainer
  end,
  Top_gridContainer = function(self)
    local Top_gridContainer = self.gameObject:GetComponent(typeof(CS.Top_UIGridContainer))
    self.Top_gridContainer = Top_gridContainer
    return Top_gridContainer
  end,
  contentSizeFitter = function(self)
    local contentSizeFitter = self.gameObject:GetComponent(typeof(ContentSizeFitter))
    self.contentSizeFitter = contentSizeFitter
    return contentSizeFitter
  end,
  customScrollRect = function(self)
    local customScrollRect = self.gameObject:GetComponent(typeof(Custom_ScrollRect))
    self.customScrollRect = customScrollRect
    return customScrollRect
  end,
  gridLayoutGroup = function(self)
    local gridLayoutGroup = self.gameObject:GetComponent(typeof(GridLayoutGroup))
    self.gridLayoutGroup = gridLayoutGroup
    return gridLayoutGroup
  end,
  graphic = function(self)
    local graphic = self.gameObject:GetComponent(typeof(Graphic))
    self.graphic = graphic
    return graphic
  end,
  image = function(self)
    return self.graphic
  end,
  rawImage = function(self)
    return self.graphic
  end,
  text = function(self)
    return self.graphic
  end,
  selectable = function(self)
    local selectable = self.gameObject:GetComponent(typeof(Selectable))
    self.selectable = selectable
    return selectable
  end,
  button = function(self)
    return self.selectable
  end,
  dropdown = function(self)
    return self.selectable
  end,
  inputField = function(self)
    return self.selectable
  end,
  scrollbar = function(self)
    return self.selectable
  end,
  slider = function(self)
    return self.selectable
  end,
  toggle = function(self)
    return self.selectable
  end,
  autoScrollText = function(self)
    local autoScrollText = self.gameObject:GetComponent("AutoScrollText")
    self.autoScrollText = autoScrollText
    return autoScrollText
  end
})

function UIControl:ctor(parent, path)
  if not path then
    self.transform = parent
  else
    self.parent = parent
    self.path = path
  end
end

function UIControl:SetLocalEulerAnglesZ(angleZ)
  self.transform:SetLocalEulerAngles(0, 0, angleZ)
end

function UIControl:GetLocalEulerAnglesZ()
  local _, _, angleZ = self.transform:GetLocalEulerAngles()
  return angleZ
end

function UIControl:SetLocalEulerAngles(eularAngle)
  self.transform:SetLocalEulerAngles(eularAngle.x, eularAngle.y, eularAngle.z)
end

function UIControl:GetLocalEulerAngles()
  return self.transform:GetLocalEulerAngles()
end

function UIControl:SetLocalScale(scale)
  self.transform:SetLocalScale(scale)
end

function UIControl:GetLocalScale()
  return self.transform:GetLocalScale()
end

function UIControl:SetScale(vector3)
  self.transform.localScale = vector3
end

function UIControl:SetParent(control)
  self.transform:SetParent(control.transform, false)
end

function UIControl:GetParent()
  return self.transform.parent
end

function UIControl:SetAsFirstSibling()
  self.transform:SetAsFirstSibling()
end

function UIControl:SetAsLastSibling()
  self.transform:SetAsLastSibling()
end

function UIControl:SetSiblingIndex(index)
  self.transform:SetSiblingIndex(index)
end

function UIControl:GetSiblingIndex()
  return self.transform:GetSiblingIndex()
end

function UIControl:GetChild(path)
  if not self.Child then
    self.Child = {}
  end
  local child = self.Child[path]
  if child == nil then
    child = UIControl(self.transform, path)
    self.Child[path] = child
  end
  return child
end

function UIControl:SetPivot(x, y)
  self.transform:SetPivot(x, y)
end

function UIControl:GetPivot()
  return self.transform:GetPivot()
end

function UIControl:SetSizeDelta(w, h)
  self.transform:SetSizeDelta(w, h)
end

function UIControl:GetSizeDelta()
  if self.transform and not IsNil(self.transform) then
    return self.transform:GetSizeDelta()
  end
  return 0
end

function UIControl:SetAnchoredPosition(x, y)
  self.transform:SetAnchoredPosition(x, y)
end

function UIControl:SetRotation(x, y, z)
  self.transform.localEulerAngles = Vector3(x, y, z)
end

function UIControl:GetAnchoredPosition()
  return self.transform:GetAnchoredPosition()
end

function UIControl:SetAnchorMin(x, y)
  self.transform:SetAnchorMin(x, y)
end

function UIControl:GetAnchorMin()
  return self.transform:GetAnchorMin()
end

function UIControl:SetAnchorMax(x, y)
  self.transform:SetAnchorMax(x, y)
end

function UIControl:GetAnchorMax()
  return self.transform:GetAnchorMax()
end

function UIControl:GetRectSize()
  return self.transform:GetRectSize()
end

function UIControl:SetVerticalFit(type)
  self.contentSizeFitter.verticalFit = type
end

function UIControl:SetHorizontalFit(type)
  self.contentSizeFitter.horizontalFit = type
end

function UIControl:SetName(name)
  self.gameObject.name = name
end

function UIControl:GetName()
  return self.gameObject.name
end

function UIControl:SetActive(active)
  if IsNil(self.gameObject) == true then
    return
  end
  if self.gameObject and self.gameObject.activeSelf ~= active then
    self.gameObject:SetActive(active)
  end
end

function UIControl:GetActive()
  return self.gameObject.activeSelf
end

function UIControl:Instantiate(parent, name)
  if IsNil(self.gameObject) or IsNil(parent) and IsNil(self:GetParent()) then
    return
  end
  local go = Object.Instantiate(self.gameObject, parent or self:GetParent(), false)
  go.name = name or self.gameObject.name
  return go
end

function UIControl:InstantiateWarp(parent, name)
  if IsNil(self.gameObject) or IsNil(parent) and IsNil(self:GetParent()) then
    return
  end
  local go = Object.Instantiate(self.gameObject, parent or self:GetParent(), false)
  go.name = name or self.gameObject.name
  local goControl = UIControl(go.transform)
  return goControl
end

function UIControl:Destroy()
  if self.gameObject then
    CS.Framework.ObjectEx.Destroy(self.gameObject)
  end
end

function UIControl:SetSortingOrder(order)
  self.canvas.sortingOrder = order
end

function UIControl:SetGroundAlpha(alpha)
  if self.canvasGroup then
    self.canvasGroup.alpha = alpha
  elseif alpha ~= 1 then
    self.canvasGroup = self.gameObject:AddComponent(typeof(CanvasGroup))
    self.canvasGroup.alpha = alpha
  end
end

function UIControl:SetBlocksRaycasts(value)
  if self.canvasGroup then
    self.canvasGroup.blocksRaycasts = value
  elseif not value then
    self.canvasGroup = self.gameObject:AddComponent(typeof(CanvasGroup))
    self.canvasGroup.blocksRaycasts = value
  end
end

function UIControl:SetCanvasInteractable(value)
  if self.canvasGroup then
    self.canvasGroup.interactable = value
  elseif not value then
    self.canvasGroup = self.gameObject:AddComponent(typeof(CanvasGroup))
    self.canvasGroup.interactable = value
  end
end

function UIControl:SetVerticalLayoutGroupChildControlWidth(childControlWidth)
  self.verticalLayoutGroup.childControlWidth = childControlWidth
end

function UIControl:SetVerticalLayoutGroupChildControlHeight(childControlHeight)
  self.verticalLayoutGroup.childControlHeight = childControlHeight
end

function UIControl:SetVerticalLayoutGroupPaddingTop(Top)
  self.verticalLayoutGroup.padding.top = Top
end

function UIControl:SetOnScrollRectChanged(ui, callback)
  self.scrollRect.onValueChanged:AddListener(self:Bind(ui, callback))
end

function UIControl:RemoveAllOnScrollRectChanged()
  self.scrollRect.onValueChanged:RemoveAllListeners()
end

function UIControl:SetNormalizedPosition(x, y)
  self.scrollRect:SetNormalizedPosition(x, y)
end

function UIControl:GetNormalizedPosition()
  return self.scrollRect:GetNormalizedPosition()
end

function UIControl:GetScrollRectContent()
  return self.scrollRect:GetScrollRectContent()
end

function UIControl:SetMovementType(num)
  self.scrollRect.movementType = num
end

function UIControl:SetOnCustomScrollRectChanged(ui, callback)
  self.customScrollRect.onValueChanged:AddListener(self:Bind(ui, callback))
end

function UIControl:RemoveAllOnCustomScrollRectChanged()
  self.customScrollRect.onValueChanged:RemoveAllListeners()
end

function UIControl:SetCustomNormalizedPosition(x, y)
  self.customScrollRect:SetCustomNormalizedPosition(x, y)
end

function UIControl:GetCustomNormalizedPosition()
  return self.customScrollRect:GetCustomNormalizedPosition()
end

function UIControl:GetCustomScrollRectContent()
  return self.customScrollRect:GetCustomScrollRectContent()
end

function UIControl:SetCustomScrollMovementType(num)
  self.customScrollRect.movementType = num
end

function UIControl:SetRaycastTarget(value)
  self.graphic.raycastTarget = value
end

function UIControl:SetColor(colorInt)
  self.graphic:SetColor(colorInt)
end

function UIControl:GetColor()
  return self.graphic.color
end

function UIControl:SetAlpha(alpha)
  self.graphic:SetAlpha(alpha)
end

function UIControl:SetMaterial(mat)
  self.graphic.material = mat
end

function UIControl:SetSprite(sprite)
  if IsNil(self.gameObject) == true then
    return
  end
  self.image.sprite = sprite
end

function UIControl:SetFillAmount(value)
  self.image.fillAmount = value
end

function UIControl:SetNativeSize()
  self.image:SetNativeSize()
end

function UIControl:GetImageMaterial()
  if IsNil(self.gameObject) == true then
    return
  end
  return self.image.material
end

function UIControl:SetImageMaterialFloat(name, value)
  if IsNil(self:GetImageMaterial()) or type(name) ~= "string" or type(value) ~= "number" then
    return
  end
  self:GetImageMaterial():SetFloat(name, value)
end

function UIControl:SetTexture(texture)
  self.rawImage.texture = texture
end

function UIControl:SetUVRect(x, y, w, h)
  self.rawImage:SetUVRect(x, y, w, h)
end

function UIControl:SetText(text)
  self.text.text = text
  if self.autoScrollText ~= nil and not IsNil(self.autoScrollText) then
    self.autoScrollText.text = text
  end
end

function UIControl:GetText()
  return self.text.text
end

function UIControl:SetTextAnchor(alignment)
  self.text.alignment = alignment
end

function UIControl:SetFontSize(num)
  self.text.fontSize = num
end

function UIControl:SetInteractable(value)
  self.selectable.interactable = value
end

function UIControl:SetOnClick(ui, callback)
  if self.button == nil or callback == nil then
    return
  end
  self:SetClickInterval(0.2)
  local onClick = self.button.onClick
  onClick:RemoveAllListeners()
  self.onClick = self:IntervalBind(ui, callback)
  onClick:AddListener(self.onClick)
end

function UIControl:SetOnClickParam(ui, callback, param)
  self:SetClickInterval(0.2)
  local onClick = self.button.onClick
  onClick:RemoveAllListeners()
  self.onClick = self:IntervalBind(ui, callback)
  self.param = param
  onClick:AddListener(self.onClick)
end

function UIControl:GetSelectValue()
  return self.dropdown.value
end

function UIControl:SetSelectValue(valueIndex)
  self.dropdown.value = valueIndex
end

function UIControl:SetOnDropDownValueChanged(ui, callback)
  self.dropdown.onValueChanged:AddListener(self:Bind(ui, callback))
end

function UIControl:RemoveAllOnDropDownListeners()
  self.dropdown.onValueChanged:RemoveAllListeners()
end

function UIControl:ClearOptions()
  self.dropdown:ClearOptions()
end

function UIControl:AddOptions(options)
  self.dropdown:AddOptions(options)
end

function UIControl:SetInputText(text)
  self.inputField.text = text
end

function UIControl:GetInputText()
  return self.inputField.text
end

function UIControl:SetOnValueChanged(ui, callback)
  self.inputField.onValueChanged:AddListener(self:Bind(ui, callback))
end

function UIControl:SetOnEndEdit(ui, callback)
  self.inputField.onEndEdit:AddListener(self:Bind(ui, callback))
end

function UIControl:MoveTextEnd()
  self.inputField:ActivateInputField()
  Coroutine.Start(self.MoveEnd, self)
end

function UIControl:MoveTextStart()
  self.inputField:ActivateInputField()
  Coroutine.Start(self.MoveStart, self)
end

function UIControl:MoveEnd()
  Coroutine.WaitForEndOfFrame()
  self.inputField:MoveTextEnd(false)
end

function UIControl:MoveStart()
  Coroutine.WaitForEndOfFrame()
  self.inputField:MoveTextStart(false)
end

function UIControl:SetOnSliderValueChanged(ui, callback)
  self.slider.onValueChanged:AddListener(self:Bind(ui, callback))
end

function UIControl:SetValue(value)
  self.slider.value = value
end

function UIControl:GetValue()
  return self.slider.value
end

function UIControl:SetOnToggleChanged(ui, callback)
  local onClick = self.toggle.onValueChanged
  onClick:RemoveAllListeners()
  self.onClick = self:Bind(ui, callback)
  onClick:AddListener(self.onClick)
end

function UIControl:SetIsOn(isOn)
  self.toggle.isOn = isOn
end

function UIControl:GetIsOn()
  return self.toggle.isOn
end

function UIControl:SetClickInterval(time)
  self.interval = time
end

function UIControl:GetClickInterval()
  if not self.interval then
    self.interval = 0
  end
  return self.interval
end

function UIControl:SetAutoScrollText(text)
  if IsNil(self.autoScrollText) then
    return
  end
  self.autoScrollText.text = text
end

function UIControl:ClickTimeLimit()
  local interval = self:GetClickInterval()
  if interval == 0 then
    return true
  end
  if not self.nextClickTime or self.nextClickTime <= Time.time or interval == 0 then
    self.nextClickTime = Time.time + interval
    return true
  end
  return false
end

function UIControl:Bind(ui, callback)
  if not callback then
    return nil
  end
  return ui and function(eventData)
    callback(ui, self, eventData)
  end or function(eventData)
    callback(self, eventData)
  end
end

function UIControl:BindTextClick(ui, callback)
  if not callback then
    return nil
  end
  return ui and function(eventData, name)
    callback(ui, self, eventData, name)
  end or function(eventData, name)
    callback(self, eventData, name)
  end
end

function UIControl:IntervalBind(ui, callback)
  if not callback then
    return nil
  end
  return ui and function(eventData)
    if self:ClickTimeLimit() then
      UIManager.isNeedPlayUIOpenSound = true
      callback(ui, self, eventData)
    end
  end or function(eventData)
    if self:ClickTimeLimit() then
      UIManager.isNeedPlayUIOpenSound = true
      callback(self, eventData)
    end
  end
end

function UIControl:IsDoubleClickBind(ui, callback, flag)
  if not callback then
    return nil
  end
  return ui and function(eventData)
    callback(ui, self, eventData, flag)
  end or function(eventData)
    callback(self, eventData, flag)
  end
end

function UIControl:SetOnLongPress(ui, pressBeginCB, dragCB, endDragCB)
  if not self.UILongPressEvent then
    local component = self.gameObject:AddMissingComponent(typeof(CS.Framework.UILongPressEvent))
    self.UILongPressEvent = component
  end
  if not self.onLongPressEventOnLongPress then
    self.onLongPressEventOnLongPress = self:Bind(ui, pressBeginCB)
    self.UILongPressEvent.onLongPress = self.onLongPressEventOnLongPress
  end
  if dragCB ~= nil and not self.UILongPressEventOnDragEvent then
    self.UILongPressEventOnDragEvent = self:Bind(ui, dragCB)
    self.UILongPressEvent.onDrag = self.UILongPressEventOnDragEvent
  end
  if endDragCB ~= nil and not self.UILongPressEventOnEndDragEvent then
    self.UILongPressEventOnEndDragEvent = self:Bind(ui, endDragCB)
    self.UILongPressEvent.onEndDrag = self.UILongPressEventOnEndDragEvent
  end
end

function UIControl:SetLongPressDelay(value)
  if not self.UILongPressEvent then
    local component = self.gameObject:AddMissingComponent(typeof(CS.Framework.UILongPressEvent))
    self.UILongPressEvent = component
  end
  self.UILongPressEvent:SetDelay(value)
end

function UIControl:SetOnLongClick(ui, callback)
  if not self.UILongPressEvent then
    local component = self.gameObject:AddMissingComponent(typeof(CS.Framework.UILongPressEvent))
    self.UILongPressEvent = component
  end
  if not self.onLongClick or self.LongClickCallBack ~= callback then
    if self.onLongClick then
      self.UILongPressEvent.onClick:RemoveListener(self.onLongClick)
    end
    self.LongClickCallBack = callback
    self.onLongClick = self:IsDoubleClickBind(ui, callback, false)
    self.UILongPressEvent.onClick:AddListener(self.onLongClick)
  end
end

function UIControl:SetOnLongDoubleClick(ui, callback)
  if not self.UILongPressEvent then
    local component = self.gameObject:AddMissingComponent(typeof(CS.Framework.UILongPressEvent))
    self.UILongPressEvent = component
  end
  if not self.onLongDoubleClick or self.LongDoubleClickCallBack ~= callback then
    if self.onLongDoubleClick then
      self.UILongPressEvent.onDoubleClick:RemoveListener(self.onLongDoubleClick)
    end
    self.LongDoubleClickCallBack = callback
    self.onLongDoubleClick = self:IsDoubleClickBind(ui, callback, true)
    self.UILongPressEvent.onDoubleClick:AddListener(self.onLongDoubleClick)
  end
end

function UIControl:SetOnPress(ui, onPress, onEndPress, pressDelay)
  local component = self.gameObject:AddMissingComponent(typeof(CS.Framework.UIPressEvent))
  component.pressDelay = pressDelay
  component.onPress = self:Bind(ui, onPress)
  component.onEndPress = self:Bind(ui, onEndPress)
end

function UIControl:SetOnPointerEnter(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIPointerEnterEvent)).onPointerEnter = self:Bind(ui, callback)
end

function UIControl:SetOnPointerExit(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIPointerExitEvent)).onPointerExit = self:Bind(ui, callback)
end

function UIControl:SetOnPointerDown(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIPointerDownEvent)).onPointerDown = self:Bind(ui, callback)
end

function UIControl:SetOnPointerUp(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIPointerUpEvent)).onPointerUp = self:Bind(ui, callback)
end

function UIControl:SetOnPointerClick(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIPointerClickEvent)).onPointerClick = self:Bind(ui, callback)
end

function UIControl:SetOnTextPointerClick(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.ChatHyperPointClick)).onPointerClick = self:BindTextClick(ui, callback)
end

function UIControl:SetOnInitializePotentialDrag(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIInitializePotentialDragEvent)).onInitializePotentialDrag = self:Bind(ui, callback)
end

function UIControl:SetOnBeginDrag(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIBeginDragEvent)).onBeginDrag = self:Bind(ui, callback)
end

function UIControl:SetOnDrag(ui, callback)
  if not self.UIDragEvent then
    self.UIDragEvent = self.gameObject:AddMissingComponent(typeof(CS.Framework.UIDragEvent))
  end
  if not self.UIDragEventOnDragEvent then
    self.UIDragEventOnDragEvent = self:Bind(ui, callback)
    self.UIDragEvent.onDrag = self.UIDragEventOnDragEvent
  end
end

function UIControl:SetOnEndDrag(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIEndDragEvent)).onEndDrag = self:Bind(ui, callback)
end

function UIControl:SetOnDrop(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIDropEvent)).onDrop = self:Bind(ui, callback)
end

function UIControl:SetOnScroll(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIScrollEvent)).onScroll = self:Bind(ui, callback)
end

function UIControl:SetOnUpdateSelected(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIUpdateSelectedEvent)).onUpdateSelected = self:Bind(ui, callback)
end

function UIControl:SetOnSelect(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UISelectEvent)).onSelect = self:Bind(ui, callback)
end

function UIControl:SetOnDeselect(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIDeselectEvent)).onDeselect = self:Bind(ui, callback)
end

function UIControl:SetOnMove(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UIMoveEvent)).onMove = self:Bind(ui, callback)
end

function UIControl:SetOnSubmit(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UISubmitEvent)).onSubmit = self:Bind(ui, callback)
end

function UIControl:SetOnCancel(ui, callback)
  self.gameObject:AddMissingComponent(typeof(CS.Framework.UICancelEvent)).onCancel = self:Bind(ui, callback)
end

function UIControl:GetTopGridMaxCount()
  if self.Top_gridContainer == nil then
    return
  end
  return self.Top_gridContainer.MaxCount
end

function UIControl:SetTopGridMaxCount(number)
  if self.Top_gridContainer == nil then
    return
  end
  if number == nil or tonumber(number) == nil then
    return
  end
  if number <= 0 then
    number = 0
  end
  self.Top_gridContainer.MaxCount = number
end

function UIControl:GetTopGridObjectList()
  if self.Top_gridContainer == nil then
    return {}
  end
  return self.Top_gridContainer.controlList
end

function UIControl:GetTopGridCellHeight()
  if self.Top_gridContainer == nil then
    return 0
  end
  return self.Top_gridContainer.CellHeight
end

function UIControl:GetTopGridCellWidth()
  if self.Top_gridContainer == nil then
    return 0
  end
  return self.Top_gridContainer.CellWidth
end

function UIControl:GetTopGridControlTemplate()
  if self.Top_gridContainer == nil then
    return
  end
  return self.Top_gridContainer.controlTemplate
end

function UIControl:GetCellSize()
  if self.gridLayoutGroup == nil then
    return
  end
  return self.gridLayoutGroup.cellSize
end

function UIControl:SetCellSize(x, y)
  if self.gridLayoutGroup == nil then
    return
  end
  local originSize = self:GetCellSize()
  if x ~= nil then
    originSize.x = x
  end
  if y ~= nil then
    originSize.y = y
  end
  self.gridLayoutGroup.cellSize = originSize
end

function UIControl:GetSpacing()
  if self.gridLayoutGroup == nil then
    return
  end
  return self.gridLayoutGroup.spacing
end
