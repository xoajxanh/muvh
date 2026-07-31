local Team3v3RewardShowTemplate = {}

function Team3v3RewardShowTemplate:Init(rootPanel)
  self.rootPanel = rootPanel
  self:InitControls()
  self:InitData()
  self:InitUI()
  self:BindUIEvents()
end

local function RewardItemOnCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

local function RewardItemRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.itemCellData:RefreshData(itemData)
  local maskType = 5
  if data.isChangeMat then
    maskType = 3
    data.isChangeMat = false
  end
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true, nil, 2, maskType, nil, {
    go_effectModel = function(go)
      if itemData.tblItem.subType == EItemSubtype.EffectTitle then
        go.transform.localScale = Vector3(0.5, 0.5, 0.5)
      else
        go.transform.localScale = Vector3(1, 1, 1)
      end
    end
  })
end

local function RankItemOnCreate(ctr)
  ctr.txt_title = UIControl(ctr.transform, "img_title_bg/txt_title")
  ctr.rewardItem = UIControl(ctr.transform, "Content/btn_first")
  ctr.content = UIControl(ctr.transform, "Content")
end

local function RankItemRefresh(ctr, index, data, ui)
  ctr.txt_title:SetText(data.rewardTitle)
  if ctr.btn_firstContainer == nil then
    ctr.btn_firstContainer = UIContainer(ctr.rewardItem, ui, RewardItemOnCreate, RewardItemRefresh)
  end
  local info = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(data.rewardPreview, "boxId")
  table.sort(info, function(a, b)
    if a.layer and b.layer then
      return a.layer < b.layer
    else
      return false
    end
  end)
  ctr.btn_firstContainer:SetData(info)
  local lines = math.ceil((ctr.content.transform.childCount - 1) / 4)
  local textHeight = ctr.txt_title.rectTransform.sizeDelta.y
  local totlHeight = textHeight + lines * 55 + (lines - 1) * 5
  ctr:SetSizeDelta(315, totlHeight)
end

function Team3v3RewardShowTemplate:InitData()
  self.curModelIndex = 1
  self.modelList = {}
  self.effectList = {}
  self.modelCenterX = -5
  self.modelSlideDistance = 500
  self.modelAnimTime = 1
  self.isAnimating = false
end

function Team3v3RewardShowTemplate:InitUI()
  self.rewardItemList = UIContainer(self.btn_first, self.rootPanel, RewardItemOnCreate, RewardItemRefresh)
  self.promotionItemList = UIContainer(self.promotionItem, self.rootPanel, RankItemOnCreate, RankItemRefresh)
  self.rankItemList = UIContainer(self.rankItem, self.rootPanel, RankItemOnCreate, RankItemRefresh)
  self:ShowReward()
end

function Team3v3RewardShowTemplate:InitControls()
  self.btn_first = self:GetControl("panel_detail/panel_reward/dailyReward/reward/sw/Viewport/Content/btn_first")
  self.promotionItem = self:GetControl("panel_detail/panel_reward/panel_advanceReward/sw_rewardList/Viewport/Content/reward")
  self.rankItem = self:GetControl("panel_detail/panel_lastRankReward/sw_rewardList/Viewport/Content/reward")
  self.role_model = self:GetControl("panel_detail/panel_hugeReward/Viewport/Content/hugeReward/model")
  self.left_btn = self:GetControl("panel_detail/panel_hugeReward/left_btn")
  self.right_btn = self:GetControl("panel_detail/panel_hugeReward/right_btn")
  self.rewardName_txt = self:GetControl("panel_detail/panel_hugeReward/rewardName_txt")
  self.btn_detail_reward = self:GetControl("panel_detail/btn_detail_reward")
end

function Team3v3RewardShowTemplate:BindUIEvents()
  self.left_btn:SetOnClick(self, self.left_btnOnClick)
  self.right_btn:SetOnClick(self, self.right_btnOnClick)
  self.role_model:SetOnDrag(self, self.DragViewRole)
  self.role_model:SetOnEndDrag(self, self.DragViewRoleEnd)
  self.btn_detail_reward:SetOnClick(self, self.btn_detail_rewardOnClick)
end

function Team3v3RewardShowTemplate:btn_detail_rewardOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1158})
end

function Team3v3RewardShowTemplate:DragViewRole(control, eventData)
  self.dragModel = true
  if self.modelList[self.curModelIndex] then
    local rotY = self.modelList[self.curModelIndex].transform.localEulerAngles.y
    rotY = rotY - eventData.delta.x
    self.modelList[self.curModelIndex].transform.localEulerAngles = Vector3(0, rotY, 0)
  end
end

function Team3v3RewardShowTemplate:DragViewRoleEnd(control, eventData)
  self.dragModel = false
end

function Team3v3RewardShowTemplate:left_btnOnClick()
  if self.isAnimating then
    return
  end
  self:SwitchModel(-1)
  self:ResetTimer()
end

function Team3v3RewardShowTemplate:right_btnOnClick()
  if self.isAnimating then
    return
  end
  self:SwitchModel(1)
  self:ResetTimer()
end

function Team3v3RewardShowTemplate:Refresh()
  self.isAnimating = false
  self.rewardData = QuickFind:GetTeam3V3DataMgr().rewardData
  self:ShowModel(nil)
  self:ResetTimer()
end

function Team3v3RewardShowTemplate:ClampModelIndex(index)
  local total = #self.rewardData
  if total == 0 then
    return 1
  end
  index = (index - 1) % total + 1
  return index
end

function Team3v3RewardShowTemplate:ShowModel(direction)
  local index = self.curModelIndex
  index = self:ClampModelIndex(index)
  self.curModelIndex = index
  local data = self.rewardData[index]
  if not data then
    return
  end
  self.rewardName_txt:SetText(data.rewardName)
  if self.modelList[index] then
    if data.type == 1 then
      self.modelList[index].transform.localEulerAngles = Vector3(0, 0, 0)
    end
    return
  end
  self:CleanupModel(index)
  if data.type == 1 then
    self:CreateCharacterModel(index, data)
  elseif data.type == 2 then
    self:CreateMountModel(index, data, direction)
  end
end

function Team3v3RewardShowTemplate:CreateCharacterModel(index, data)
  local suitDic = QuickFind:GetTeam3V3DataMgr().rewardSuitDic
  local modelData = QuickFind:GetTeam3V3DataMgr():GetRoleModelShowInfo(suitDic[RoleManager.me.career][data.suitType], self.role_model.transform)
  local viewRole = ViewRole(modelData)
  self.modelList[index] = viewRole
  viewRole.transform.localScale = viewRole.transform.localScale * data.size
  self:SetupModelRender(viewRole, 1)
  local capturedIndex = index
  Coroutine.Start(function()
    Coroutine.Yield(CS.UnityEngine.WaitForSeconds(0.5))
    if self.modelList[capturedIndex] then
      self:SetupModelRender(self.modelList[capturedIndex], 1)
    end
  end)
  local buffAnchor = viewRole.model.BuffAnchor
  local effectName = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(82000001)
  local suitEffectPath = string.format("Effect/Skill/%s.prefab", effectName)
  self.suitEffectCoroutine = Coroutine.Start(function()
    local request = self.rootPanel:LoadAssetAsync(suitEffectPath, typeof(CS.UnityEngine.GameObject))
    Coroutine.Yield(request)
    if request.isError then
      if self.suitEffectCoroutine then
        Coroutine.Stop(self.suitEffectCoroutine)
        self.suitEffectCoroutine = nil
      end
      return
    end
    if not self.modelList[capturedIndex] then
      UnityEngineLua.GameObject.Destroy(request.res)
      if self.suitEffectCoroutine then
        Coroutine.Stop(self.suitEffectCoroutine)
        self.suitEffectCoroutine = nil
      end
      return
    end
    local effectModel = Instantiate(request.res)
    effectModel.transform:SetParent(buffAnchor.transform, false)
    self:SetupModelRender(effectModel, 3)
    self.effectList[capturedIndex] = effectModel
    if self.suitEffectCoroutine then
      Coroutine.Stop(self.suitEffectCoroutine)
      self.suitEffectCoroutine = nil
    end
  end)
end

function Team3v3RewardShowTemplate:CreateMountModel(index, data, direction)
  local itemMountCfg = ClientTable.cfg_Item_mountManager:TryGetValue(data.itemId, "id")
  if not itemMountCfg then
    return
  end
  local modelPath = string.format("Model/%s/%s.prefab", itemMountCfg.route, itemMountCfg.model)
  local capturedIndex = index
  self.mountCoroutine = Coroutine.Start(function()
    local request = self.rootPanel:LoadAssetAsync(modelPath, typeof(CS.UnityEngine.GameObject))
    Coroutine.Yield(request)
    if request.isError then
      if self.mountCoroutine then
        Coroutine.Stop(self.mountCoroutine)
        self.mountCoroutine = nil
      end
      return
    end
    if self.modelList[capturedIndex] then
      if self.mountCoroutine then
        Coroutine.Stop(self.mountCoroutine)
        self.mountCoroutine = nil
      end
      return
    end
    local go = Instantiate(request.res)
    self.modelList[capturedIndex] = go
    go.transform.localScale = go.transform.localScale * data.size
    self:SetupModelRender(go, 2)
    self:PlaySlideInAnim(go, direction)
    if self.mountCoroutine then
      Coroutine.Stop(self.mountCoroutine)
      self.mountCoroutine = nil
    end
  end)
end

function Team3v3RewardShowTemplate:CleanupModel(index)
  local model = self.modelList[index]
  if model then
    if model.isRole then
      model:Destroy()
    else
      UnityEngineLua.GameObject.Destroy(model)
    end
    self.modelList[index] = nil
  end
  local effect = self.effectList[index]
  if effect then
    UnityEngineLua.GameObject.Destroy(effect)
    self.effectList[index] = nil
  end
end

function Team3v3RewardShowTemplate:SetupModelRender(go, modelType)
  if not go or not self.role_model then
    return
  end
  if modelType == 1 then
    go:SetPosition(-5, -100, -500)
    go:SetRotation(0, 180, 0)
    go.isRole = true
    go.model:SetLayer(UI_LAYER)
  elseif modelType == 2 then
    go.transform:SetParent(self.role_model.transform, false)
    go.transform.localPosition = Vector3(go.transform.localPosition.x, -95, -500)
    go.transform.localEulerAngles = Vector3(0, 135, 0)
    go:SetLayer(UI_LAYER)
  elseif modelType == 3 then
    go.gameObject.layer = LayerMask.NameToLayer("UI")
    self:ApplyRenderParamsRecursive(go)
    return
  end
  local orderLayer = 500
  if self.rootPanel then
    orderLayer = self.rootPanel.root.canvas.sortingOrder
  end
  local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renders.Length - 1 do
    renders[i].sortingOrder = orderLayer + 100
  end
  local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  for i = 0, sys.Length - 1 do
    local par = sys[i]
    par.gameObject.layer = 5
    local parRenderer = par:GetComponent(typeof(CS.UnityEngine.Renderer))
    if parRenderer then
      parRenderer.sortingOrder = orderLayer + 50
    end
  end
end

function Team3v3RewardShowTemplate:ApplyRenderParamsRecursive(go)
  local orderLayer = 500
  if self.rootPanel then
    orderLayer = self.rootPanel.root.canvas.sortingOrder
  end
  local renderer = go:GetComponent(typeof(CS.UnityEngine.Renderer))
  if not IsNil(renderer) then
    renderer.sortingOrder = orderLayer + 50
  end
  for i = 0, go.transform.childCount - 1 do
    local child = go.transform:GetChild(i).gameObject
    child.layer = LayerMask.NameToLayer("UI")
    self:ApplyRenderParamsRecursive(child)
  end
end

function Team3v3RewardShowTemplate:PlaySlideInAnim(model, direction)
  if not model or not direction then
    return
  end
  model.transform:DOKill()
  local pos = model.transform.localPosition
  model.transform.localPosition = Vector3(self.modelCenterX + direction * self.modelSlideDistance, pos.y, pos.z)
  Coroutine.Start(function()
    Coroutine.WaitForEndOfFrame()
    if model and model.transform then
      model.transform:DOLocalMoveX(self.modelCenterX, self.modelAnimTime):SetEase(Ease.OutQuart)
    end
  end)
end

function Team3v3RewardShowTemplate:SwitchModel(direction)
  local oldIndex = self.curModelIndex
  local oldModel = self.modelList[oldIndex]
  self.curModelIndex = self:ClampModelIndex(oldIndex + direction)
  self:ShowModel(direction)
  local newModel = self.modelList[self.curModelIndex]
  self.isAnimating = true
  local fadeDistance = 200
  local outTargetX = self.modelCenterX - direction * self.modelSlideDistance
  local inStartX = self.modelCenterX + direction * self.modelSlideDistance
  local animDoneCount = 0
  local totalAnims = 0
  if newModel then
    totalAnims = totalAnims + 1
  end
  if oldModel then
    totalAnims = totalAnims + 1
  end
  
  local function onAnimComplete()
    animDoneCount = animDoneCount + 1
    if animDoneCount >= totalAnims then
      self.isAnimating = false
    end
  end
  
  if newModel then
    newModel.transform:DOKill()
    local pos = newModel.transform.localPosition
    newModel.transform.localPosition = Vector3(inStartX, pos.y, pos.z)
    local fadeInTriggered = false
    Coroutine.Start(function()
      Coroutine.WaitForEndOfFrame()
      if newModel and newModel.transform then
        local tw = newModel.transform:DOLocalMoveX(self.modelCenterX, self.modelAnimTime):SetEase(Ease.OutQuart)
        tw:OnUpdate(function()
          if not fadeInTriggered and math.abs(newModel.transform.localPosition.x - self.modelCenterX) <= fadeDistance then
            fadeInTriggered = true
            newModel:SetActive(true)
          end
        end)
        tw:OnComplete(function()
          if not fadeInTriggered then
            newModel:SetActive(true)
          end
          onAnimComplete()
        end)
      end
    end)
  end
  if oldModel then
    oldModel.transform:DOKill()
    local fadeOutTriggered = false
    local tw = oldModel.transform:DOLocalMoveX(outTargetX, self.modelAnimTime):SetEase(Ease.OutQuart)
    tw:OnUpdate(function()
      if not fadeOutTriggered and math.abs(oldModel.transform.localPosition.x - self.modelCenterX) >= fadeDistance then
        fadeOutTriggered = true
        oldModel:SetActive(false)
      end
    end)
    tw:OnComplete(function()
      if not fadeOutTriggered then
        oldModel:SetActive(false)
      end
      onAnimComplete()
    end)
  end
  if totalAnims == 0 then
    self.isAnimating = false
  end
end

function Team3v3RewardShowTemplate:ShowReward()
  local daily = QuickFind:GetTeam3V3DataMgr().dailyReward
  local promotion = QuickFind:GetTeam3V3DataMgr().promotionRewards
  local rank = QuickFind:GetTeam3V3DataMgr().rankRewards
  local dailyRewardCopy = {}
  for i, v in ipairs(daily.reward) do
    dailyRewardCopy[i] = {
      itemId = v.itemId,
      count = v.count,
      isChangeMat = true
    }
  end
  self.rewardItemList:SetData(dailyRewardCopy)
  self.promotionItemList:SetData(promotion)
  self.rankItemList:SetData(rank)
end

function Team3v3RewardShowTemplate:ResetTimer()
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
  self.timer = Timer.StartLoopForever(8, function()
    if self.dragModel or self.isAnimating then
      return
    end
    self:SwitchModel(1)
  end)
end

function Team3v3RewardShowTemplate:Exit()
  self.curModelIndex = 1
  self.dragModel = false
  for i, v in pairs(self.modelList) do
    if v then
      if v.isRole then
        v:Destroy()
      else
        UnityEngineLua.GameObject.Destroy(v)
      end
      self.modelList[i] = nil
    end
  end
  for i, v in pairs(self.effectList) do
    if v then
      UnityEngineLua.GameObject.Destroy(v)
      self.effectList[i] = nil
    end
  end
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
end

return Team3v3RewardShowTemplate
