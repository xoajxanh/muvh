BaseUI = class()
BaseUI.layer = UILayer.Panel
BaseUI.orderInLayer = 0
BaseUI.hideType = UIHideType.Hide
BaseUI.hideFunc = UIHideFunc.MoveOutOfScreen
BaseUI.escClose = UIEscClose.DontClose
BaseUI.visible = false
BaseUI.loaded = false
BaseUI.root = nil

local function SetRootXY(self)
  if self.logicTbl then
    if self.logicTbl.sortPos then
      self.rootSavedX, self.rootSavedY = UIManager.sortPanelPosAnchor[self.logicTbl.sortPos].pos, 0
    elseif self.logicTbl.isLabel == self.logicTbl.id then
      self.rootSavedX, self.rootSavedY = (UIManager.width - self.logicTbl.width) / 2 - AdapterUtility.offsetX, 0
    else
      self.rootSavedX, self.rootSavedY = 0, 0
    end
  elseif self.rootSavedY == nil and self.rootSavedX == nil then
    self.rootSavedX, self.rootSavedY = self.root:GetAnchoredPosition()
  end
end

local function SetUIVisible(self, visible)
  if self.hideFunc == UIHideFunc.MoveOutOfScreen or self.logicTbl and self.logicTbl.type == UIPanelType.SortAndHide and self.logicTbl.sortPos then
    if visible then
      SetRootXY(self)
      self.root:SetAnchoredPosition(self.rootSavedX, self.rootSavedY)
    else
      self.rootSavedX, self.rootSavedY = self.root:GetAnchoredPosition()
      self.root:SetAnchoredPosition(100000000, 100000000)
    end
  end
  self.root:SetActive(visible)
end

function BaseUI:Preload()
  if not self.loaded then
    self.visible = false
    self:StartPreLoad()
  end
end

function BaseUI:SetVisible(visible, animation)
  if self.visible == visible then
    self:IsVisibleRefresh()
    return
  end
  self.visible = visible
  self.animation = animation == nil and true or animation
  if self.visible then
    self:StopHide()
    if self.loaded then
      SetUIVisible(self, true)
      self:StartShow()
    else
      self:StartLoad()
    end
  else
    self:StopShow()
    if self.loaded then
      self:StartHide()
    end
  end
end

function BaseUI:IsVisibleRefresh()
end

function BaseUI:Show(animation)
  self:SetVisible(true, animation)
end

function BaseUI:Hide(animation)
  self:SetVisible(false, animation)
end

function BaseUI:Destroy()
  self:DestroySubUIs()
  self:SetVisible(false)
  self:ReleaseAllAssets()
  self:StopLoad()
  if not self.loaded then
    return
  end
  scall(self.OnDestroy, self)
  if type(self.args) == "table" and self.args.onDestroy then
    self.args.onDestroy(self)
  end
  EventManager.Dispatch(Event.UI_Destroy, self)
  CS.Framework.UGUIEx.RemoveUIAllListeners(self.root.gameObject)
  self.root:Destroy()
  self.root = nil
  self.loaded = false
end

function BaseUI:SetArgs(args)
  self.args = args
end

function BaseUI:SetLayer(layer)
  if self.layer ~= layer then
    self.layer = layer
    self:RefreshLayer()
  end
end

function BaseUI:SetOrderInLayer(orderInLayer)
  if self.orderInLayer ~= orderInLayer then
    self.orderInLayer = orderInLayer
    self:RefreshLayer()
  end
end

function BaseUI:RefreshLayer()
  self.root:SetSortingOrder(self.layer * 200 + self.orderInLayer)
end

function BaseUI:SetPanelZ()
  if self.layer > UILayer.Panel then
    local v3 = self.root.transform.localPosition
    self.root.transform.localPosition = Vector3(v3.x, v3.y, -700 - (self.layer - UILayer.Panel) * 800)
  end
end

function BaseUI:GetControl(path)
  return UIControl(self.root.transform, path)
end

function BaseUI:StartShow()
  self.coShow = Coroutine.Start(self.DoShow, self)
end

function BaseUI:StopShow()
  if self.coShow then
    Coroutine.Stop(self.coShow)
    self.coShow = nil
  end
end

function BaseUI:DoShow()
  self:DoShowSubUI()
  self:CheckParent()
  self:OnShow()
  if type(self.args) == "table" and self.args.onShow then
    self.args.onShow(self)
  end
  EventManager.Dispatch(Event.UI_Show, self)
  if self.animation then
    self:ShowAnimation()
  end
end

function BaseUI:CheckParent()
  if type(self.args) == "table" and self.args.parent and self.parent ~= self.args.parent then
    self.parent = self.args.parent
    self.root.transform:SetParent(self.parent, false)
  end
end

function BaseUI:StartHide()
  self.coHide = Coroutine.Start(self.DoHide, self)
end

function BaseUI:StopHide()
  if self.coHide then
    Coroutine.Stop(self.coHide)
    self.coHide = nil
  end
end

function BaseUI:DoHide()
  self:HideSubUIs()
  self:UnRegistAllEvents()
  self:OnHide()
  if type(self.args) == "table" and self.args.onHide then
    self.args.onHide(self)
  end
  EventManager.Dispatch(Event.UI_Hide, self)
  if self.animation then
    self:HideAnimation()
  end
  if self.hideType == UIHideType.Destroy then
    self:Destroy()
  elseif self.hideType == UIHideType.WaitDestroy then
    SetUIVisible(self, false)
    Coroutine.Wait(WAIT_DESTROY_TIME)
    self:Destroy()
  else
    SetUIVisible(self, false)
  end
end

function BaseUI:StartLoad()
  if self.request then
    return
  end
  self.coLoad = Coroutine.Start(self.DoLoad, self)
end

function BaseUI:GetRoot()
  local root = table.contains(UIManager.AcceptAdapterTbl, self.name) and UIManager.adapter_WindowCanvasUI or UIManager.root
  return root
end

function BaseUI:DoLoad()
  local path = "UI/" .. self.name .. ".prefab"
  self.parent = type(self.args) == "table" and self.args.parent or self:GetRoot()
  self.request = CS.Framework.ResourceManager.InstantiateAsync(path, self.parent, false)
  Coroutine.Yield(self.request)
  if not self.request or self.request.isError then
    Coroutine.Break()
  end
  local go = self.request.gameObject
  local canvas = go:AddMissingComponent(typeof(CS.UnityEngine.Canvas))
  canvas.overrideSorting = true
  go:AddMissingComponent(typeof(CS.UnityEngine.UI.GraphicRaycaster))
  self.root = UIControl(go.transform)
  self:RefreshLayer()
  self:SetPanelZ()
  SetUIVisible(self, self.visible)
  self.loaded = true
  self:OnCreate()
  if type(self.args) == "table" and self.args.onCreate then
    self.args.onCreate(self)
  end
  EventManager.Dispatch(Event.UI_Create, self)
  self:InitAnimation()
  if self.visible then
    self:StartShow()
  end
  self.coLoad = nil
  self.request = nil
end

function BaseUI:StartPreLoad()
  if self.request then
    return
  end
  self.coLoad = Coroutine.Start(self.DoPreLoad, self)
end

function BaseUI:DoPreLoad()
  local path = "UI/" .. self.name .. ".prefab"
  self.parent = type(self.args) == "table" and self.args.parent or self:GetRoot()
  self.request = CS.Framework.ResourceManager.InstantiateAsync(path, self.parent, false)
  Coroutine.Yield(self.request)
  PreLoadManager.Count()
  if not self.request or self.request.isError then
    Coroutine.Break()
  end
  local go = self.request.gameObject
  local canvas = go:AddMissingComponent(typeof(CS.UnityEngine.Canvas))
  canvas.overrideSorting = true
  go:AddMissingComponent(typeof(CS.UnityEngine.UI.GraphicRaycaster))
  self.root = UIControl(go.transform)
  self:RefreshLayer()
  self:SetPanelZ()
  SetUIVisible(self, self.visible)
  self.loaded = true
  self:OnPreLoad()
  self.coLoad = nil
  self.request = nil
end

function BaseUI:StopLoad()
  if self.coLoad then
    Coroutine.Stop(self.coLoad)
    self.coLoad = nil
  end
  if self.request then
    self.request:Dispose()
    self.request = nil
  end
end

function BaseUI:OnPreLoad()
end

function BaseUI:OnCreate()
end

function BaseUI:OnShow()
end

function BaseUI:ShowAnimation()
  self:DefaultShowAnimation()
end

function BaseUI:OnHide()
end

function BaseUI:HideAnimation()
  self:DefaultHideAnimation()
end

function BaseUI:OnDestroy()
end

function BaseUI:OnEscClose()
  if self.escClose == UIEscClose.Close then
    self:Hide()
    return true
  end
end

function BaseUI:OnLogOut()
end

function BaseUI:RegistEvent(type, func, data, priority)
  if not type then
    print("event not exist")
    return
  end
  if not self.eventContainer then
    self.eventContainer = EventContainer(EventManager)
  end
  self.eventContainer:Regist(type, func, data, priority)
end

function BaseUI:UnRegistEvent(type, func, data)
  if not type then
    return
  end
  if self.eventContainer then
    self.eventContainer:UnRegist(type, func, data)
  end
end

function BaseUI:UnRegistAllEvents()
  if self.eventContainer then
    self.eventContainer:UnRegistAll()
  end
end

function BaseUI:LoadAsset(path, type)
  return self:GetAssetGroup():LoadAsset(path, type)
end

function BaseUI:LoadAssetAsync(path, type, callback)
  local request = self:GetAssetGroup():LoadAssetAsync(path, type)
  if callback then
    request:AddCallback(callback)
  end
  return request
end

function BaseUI:GetAssetLoader(callback)
  if not self.assetLoaders then
    self.assetLoaders = {}
  end
  local loader = CS.Framework.AssetLoader(callback)
  table.insert(self.assetLoaders, loader)
  return loader
end

function BaseUI:ReleaseAllAssets()
  if self.assetGroup then
    self.assetGroup:Dispose()
    self.assetGroup = nil
  end
  if self.assetLoaders then
    for k, v in ipairs(self.assetLoaders) do
      v:Dispose()
    end
    self.assetLoaders = nil
  end
end

function BaseUI:GetAssetGroup()
  if not self.assetGroup then
    self.assetGroup = CS.Framework.AssetGroup()
  end
  return self.assetGroup
end

function BaseUI:InitAnimation()
  self.panels = {}
end

function BaseUI:DefaultShowAnimation()
end

function BaseUI:DefaultHideAnimation()
end

function BaseUI:ShowSubUI(name, args)
  local ui = UIManager.Show(name, args)
  if not self.subUIs then
    self.subUIs = {}
  end
  if not self.subUIs[name] then
    self.subUIs[name] = ui
  end
end

function BaseUI:HideSubUI(name)
  if not self.subUIs then
    return
  end
  local ui = self.subUIs[name]
  if ui then
    ui:Hide()
  end
end

function BaseUI:GetSubUI(name)
  if self.subUIs ~= nil then
    return self.subUIs[name]
  end
end

function BaseUI:DoShowSubUI()
  if not self.subUIs then
    return
  end
  for k, v in pairs(self.subUIs) do
    v:Show()
  end
end

function BaseUI:HideSubUIs()
  if not self.subUIs then
    return
  end
  for k, v in pairs(self.subUIs) do
    v:Hide()
  end
end

function BaseUI:DestroySubUIs()
  if not self.subUIs then
    return
  end
  for k, v in pairs(self.subUIs) do
    v:Destroy()
  end
end

function BaseUI:RemoveSubUI(name)
  if not self.subUIs then
    return
  end
  local ui = self.subUIs[name]
  if ui then
    ui:Hide()
  end
  self.subUIs[name] = nil
end

function BaseUI:SetSprite(atlasName, IconName, Image, NativeSize)
  if self == BaseUI then
    logError("G\225\187\141i b\225\186\165t h\225\187\163p ph\195\161p \196\145\225\186\191n BaseUI:SetSprite, vui l\195\178ng s\225\187\173 d\225\187\165ng self \196\145\225\187\131 g\225\187\141i")
  end
  if Image == nil or IsNil(Image.image) then
    return
  end
  if not IsNil(Image.image.sprite) and Image.image.sprite.name == IconName then
    if not Image:GetActive() then
      Image:SetActive(true)
    end
    return nil
  end
  local imageTable = {
    atlasName = atlasName,
    IconName = IconName,
    Image = Image,
    NativeSize = NativeSize
  }
  local spriteCol = Coroutine.Start(self.DoSetSprite, self, imageTable)
  return spriteCol
end

function BaseUI:DoSetSprite(imageTable)
  if not string.isNullOrEmpty(imageTable.atlasName) then
    local atlasPath = string.format("Texture/%s.spriteatlas", imageTable.atlasName)
    local request = self:LoadAssetAsync(atlasPath, typeof(CS.UnityEngine.U2D.SpriteAtlas))
    if request ~= nil then
      Coroutine.Yield(request)
      if request.isError then
        Coroutine.Break()
      end
      local spriteAtlas = request.res
      local sprite = spriteAtlas:GetSprite(tostring(imageTable.IconName))
      if sprite ~= nil and imageTable.IconName ~= nil then
        sprite.name = tostring(imageTable.IconName)
      end
      imageTable.Image:SetSprite(sprite)
      imageTable.Image:SetActive(sprite)
      if imageTable.NativeSize then
        imageTable.Image:SetNativeSize()
      end
      imageTable.Image.loader = nil
    end
  else
    imageTable.Image:SetActive(false)
  end
end

function BaseUI:UpdateCanvasAdditionalShaderChannel(channel)
  self.root.canvas.additionalShaderChannels = channel
end

function BaseUI:ResetSortPos()
  SetUIVisible(self, true)
end
