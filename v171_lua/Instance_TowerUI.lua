Instance_TowerUI = class(BaseUI)
Instance_TowerUI.layer = UILayer.Panel
Instance_TowerUI.orderInLayer = 0
Instance_TowerUI.hideType = UIHideType.WaitDestroy
Instance_TowerUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_TowerUI.escClose = UIEscClose.DontClose

function Instance_TowerUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.lab_notice = self:GetControl("lab_notice")
  self.ScrollView = self:GetControl("ScrollView")
  self.img_Normal = self:GetControl("ScrollView/img_Normal")
  self.img_Special = self:GetControl("ScrollView/img_Special")
  self.img_Top = self:GetControl("ScrollView/img_Top")
  self.img_First = self:GetControl("ScrollView/img_First")
  self.img_NormalSelect = self:GetControl("ScrollView/img_NormalSelect")
  self.img_SpecialSelect = self:GetControl("ScrollView/img_SpecialSelect")
  self.img_TopSelect = self:GetControl("ScrollView/img_TopSelect")
  self.img_FirstSelect = self:GetControl("ScrollView/img_FirstSelect")
  self.tog_instance = self:GetControl("ScrollView/Viewport/Content/tog_instance")
  self.lab_floor = self:GetControl("rightpanel/lab_floor")
  self.img_itemicon = self:GetControl("rightpanel/lab_rewards/lab_requirements/img_itemicon")
  self.btn_get2 = self:GetControl("rightpanel/lab_rewards/lab_requirements/btn_get2")
  self.lab_consumeCount = self:GetControl("rightpanel/lab_rewards/lab_requirements/lab_consumeCount")
  self.grid = self:GetControl("rightpanel/grid")
  self.btn_3DItem = self:GetControl("rightpanel/grid/btn_3DItem")
  self.lab_count1 = self:GetControl("rightpanel/lab_leftcount/lab_count1")
  self.lab_leftcount = self:GetControl("rightpanel/lab_leftcount")
  self.btn_get1 = self:GetControl("rightpanel/lab_leftcount/btn_get1")
  self.btn_enter = self:GetControl("rightpanel/btn_enter")
  self.go_model = self:GetControl("go_model")
end

function Instance_TowerUI:OnPreLoad()
end

function Instance_TowerUI:Init()
end

function Instance_TowerUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnInstanceItemCreat(ctr)
  ctr.lab_InstanceName = UIControl(ctr.transform, "lab_instancename")
  ctr.img_click_putong = UIControl(ctr.transform, "img_click_putong")
  ctr.img_target = UIControl(ctr.transform, "img_target")
  ctr.img_bg_name = UIControl(ctr.transform, "img_bg_name")
  ctr.lab_instancename = UIControl(ctr.transform, "lab_instancename")
  ctr.btn_3DItem = ItemUtility.InitItemCell(UIControl(ctr.transform, "btn_3DItem"))
  ctr.rewardsItem = ItemCellData()
end

local normalSzie = Vector2.right * 265 + Vector2.up * 127.5
local topSzie = Vector2.right * 265 + Vector2.up * 430
local firstSzie = Vector2.right * 265 + Vector2.up * 275
local instanceRewards = {}

local function LoadRewardsModel()
  local ui = UIManager.GetUiByName(UIID.Instance_TowerUI)
  for i = #instanceRewards, 1, -1 do
    Coroutine.Yield()
    local item = instanceRewards[i]
    local itemData = ItemUtility.GenerateItemData(item.infor)
    item.control.rewardsItem:RefreshData(itemData)
    ItemUtility.ShowItemCell(item.control.btn_3DItem, item.control.rewardsItem, ui, true)
  end
end

local function OnInstanceItemRefresh(ctr, index, data, ui)
  if data.unique > 0 then
    if data.floorIndex == 1 then
      ctr.transform.sizeDelta = firstSzie
      ctr.img_target:SetSprite(ui.img_First.image.sprite)
      ctr.img_click_putong:SetSprite(ui.img_FirstSelect.image.sprite)
      ctr.img_bg_name.transform.localPosition = Vector2.up * -123
      ctr.lab_instancename.transform.localPosition = Vector2.up * -123
      ctr.btn_3DItem.transform.localPosition = Vector2.up * -65
    elseif data.floorIndex == TowerData.GetMaxFloorNum() then
      ctr.transform.sizeDelta = topSzie
      ctr.img_target:SetSprite(ui.img_Top.image.sprite)
      ctr.img_click_putong:SetSprite(ui.img_TopSelect.image.sprite)
      ctr.img_bg_name.transform.localPosition = Vector2.up * -185
      ctr.lab_instancename.transform.localPosition = Vector2.up * -185
      ctr.btn_3DItem.transform.localPosition = Vector2.up * -140
    else
      ctr.transform.sizeDelta = normalSzie
      ctr.img_target:SetSprite(ui.img_Special.image.sprite)
      ctr.img_click_putong:SetSprite(ui.img_SpecialSelect.image.sprite)
      ctr.img_bg_name.transform.localPosition = Vector2.up * -43.5
      ctr.lab_instancename.transform.localPosition = Vector2.up * -43.5
      ctr.btn_3DItem.transform.localPosition = Vector2.up * -3
    end
    ctr.btn_3DItem:SetActive(true)
    local rewardInfor = {
      control = ctr,
      infor = data.unique
    }
    table.insert(instanceRewards, rewardInfor)
  else
    if data.floorIndex == 1 then
      ctr.transform.sizeDelta = firstSzie
      ctr.img_target:SetSprite(ui.img_First.image.sprite)
      ctr.img_click_putong:SetSprite(ui.img_FirstSelect.image.sprite)
      ctr.img_bg_name.transform.localPosition = Vector2.up * -123
      ctr.lab_instancename.transform.localPosition = Vector2.up * -123
    elseif data.floorIndex == TowerData.GetMaxFloorNum() then
      ctr.transform.sizeDelta = topSzie
      ctr.img_target:SetSprite(ui.img_Top.image.sprite)
      ctr.img_click_putong:SetSprite(ui.img_TopSelect.image.sprite)
      ctr.img_bg_name.transform.localPosition = Vector2.up * -185
      ctr.lab_instancename.transform.localPosition = Vector2.up * -185
    else
      ctr.transform.sizeDelta = normalSzie
      ctr.img_target:SetSprite(ui.img_Normal.image.sprite)
      ctr.img_click_putong:SetSprite(ui.img_NormalSelect.image.sprite)
      ctr.img_bg_name.transform.localPosition = Vector2.up * -43.5
      ctr.lab_instancename.transform.localPosition = Vector2.up * -43.5
    end
    ctr.btn_3DItem:SetActive(false)
  end
  ctr.img_target:SetNativeSize()
  ctr.img_click_putong:SetNativeSize()
  ctr.lab_InstanceName:SetText(data.name)
  ctr:SetOnToggleChanged(ctr, function(contr, _, isOn)
    if isOn then
      ui:SetCurrentInstanceInfor(ctr, data)
      ctr.img_click_putong:SetActive(true)
    else
      ui:CancelSelectInstanceInfor(data)
      ctr.img_click_putong:SetActive(false)
    end
  end)
  if data.passed then
    ctr.toggle.isOn = true
    ui:SetCurrentInstanceInfor(ctr, data)
    ctr.img_click_putong:SetActive(true)
  else
  end
  if index == TowerData.GetDisplayCount() then
    Coroutine.Start(LoadRewardsModel)
  end
end

local function OnRewardItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
end

local function OnRewardItemRefresh(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  else
    ctr:SetActive(true)
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  local modelData = ItemCellData()
  modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, modelData, ui, true)
end

function Instance_TowerUI:InitUI()
  self.InstanceContainer = UIContainer(self.tog_instance, self, OnInstanceItemCreat, OnInstanceItemRefresh)
  self.rewardContainer = UIContainer(self.btn_3DItem, self, OnRewardItemCreat, OnRewardItemRefresh)
  self.viewScroll = self.InstanceContainer.transform.parent.parent:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
end

function Instance_TowerUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  local hight = 0
  for i = 1, #self.InstanceContainer.items do
    local itemSize = self.InstanceContainer.items[i].transform.sizeDelta
    hight = hight + itemSize.y
  end
  self.InstanceContainer.rectTransform.sizeDelta = Vector2.right * 410 + Vector2.up * hight
  self.viewScroll.normalizedPosition = Vector2.zero
end

local bossPool = {}
local bossStatePool = {}
local currentData

function Instance_TowerUI:OnHide()
  for k, v in pairs(self.InstanceContainer.items) do
    v.toggle.onValueChanged:RemoveAllListeners()
  end
  if bossPool[currentData.bossModel].name then
    bossPool[currentData.bossModel]:SetActive(false)
    bossStatePool[currentData.bossModel] = false
  end
  for i = 1, #instanceRewards do
    instanceRewards[i].control.rewardsItem:RecycleRes()
  end
end

function Instance_TowerUI:OnDestroy()
end

function Instance_TowerUI:SetCurrentInstanceInfor(ctr, data)
  self.lab_floor:SetText(string.format("T\225\186\167ng %d", data.floorIndex))
  if data.passed then
    self.btn_enter.gameObject:SetActive(true)
  else
    self.btn_enter.gameObject:SetActive(false)
  end
  if bossPool[data.bossModel] then
    if bossPool[data.bossModel].name then
      bossPool[data.bossModel]:SetActive(true)
    end
  else
    Coroutine.Start(self.LoadBossModel, self, data)
    bossStatePool[data.bossModel] = true
  end
  self.rewardContainer:SetDataKTable(data.rewards)
  currentData = data
end

function Instance_TowerUI:LoadBossModel(data)
  if not data.bossModel then
    return
  end
  local modelPath = string.format("Model/Monster/%s.prefab", data.bossModel)
  bossPool[data.bossModel] = CS.Framework.ResourceManager.InstantiateAsync(modelPath, self.go_model.transform, false)
  Coroutine.Yield(bossPool[data.bossModel])
  if not bossPool[data.bossModel] or bossPool[data.bossModel].isError then
    Coroutine.Break()
  end
  bossPool[data.bossModel] = bossPool[data.bossModel].gameObject
  local renderers = bossPool[data.bossModel]:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renderers.Length - 1 do
    renderers[i].gameObject.layer = 5
  end
  bossPool[data.bossModel].transform.localScale = data.modelScale
  bossPool[data.bossModel].transform.localPosition = data.localPos
  bossPool[data.bossModel].transform.forward = -self.go_model.transform.forward
  bossPool[data.bossModel]:SetActive(bossStatePool[data.bossModel])
  local monsterShadow = bossPool[data.bossModel]:GetComponentInChildren(typeof(CS.Framework.MonsterShadow))
  if monsterShadow then
    monsterShadow.enabled = false
  end
end

function Instance_TowerUI:CancelSelectInstanceInfor(data)
  if not data.bossModel or not bossPool[data.bossModel] then
    return
  end
  if not bossPool[data.bossModel].name then
    bossStatePool[data.bossModel] = false
  else
    bossPool[data.bossModel]:SetActive(false)
  end
end

function Instance_TowerUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.img_itemicon:SetOnClick(self, self.img_itemiconOnClick)
  self.btn_get2:SetOnClick(self, self.btn_get2OnClick)
  self.btn_get1:SetOnClick(self, self.btn_get1OnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
end

function Instance_TowerUI:btn_closeOnClick(control)
  if RoleManager.me.TargetAvatar then
    RoleManager.me.TargetAvatar:OnCancelTouch()
    RoleManager.me.TargetAvatar = nil
  end
  UIManager.Hide(self.name)
end

function Instance_TowerUI:img_itemiconOnClick(control)
end

function Instance_TowerUI:btn_get2OnClick(control)
end

function Instance_TowerUI:btn_ItemOnClick(control)
end

function Instance_TowerUI:btn_get1OnClick(control)
end

function Instance_TowerUI:btn_enterOnClick(control)
  if CS.UnityEngine.Input.GetKey(CS.UnityEngine.KeyCode.G) and CS.UnityEngine.Input.GetKey(CS.UnityEngine.KeyCode.LeftControl) and CS.UnityEngine.Debug.isDebugBuild then
    UIManager.Hide(self.name)
    return
  end
  if TowerData.GetResidueChallengeCount() > 0 then
    local mapData = {
      mapId = currentData.transferId
    }
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
    UIManager.Hide(self.name)
    TowerData:SetRunningInstanceData(currentData)
  else
    LimitUtility.NoEnoughPrompt(EBuyTipEnum.instanceNoEnoughCount, self.btn_enter)
  end
end

function Instance_TowerUI:RegistEvents()
end

function Instance_TowerUI:Refresh()
  local display = TowerData:GetDisplayInfor()
  if not display then
    return
  end
  table.sort(display, function(a, b)
    return a.mapId > b.mapId
  end)
  instanceRewards = {}
  self.InstanceContainer:SetDataKTable(display)
  local currentChallengedFloor = TowerData.GetCurrentChallenged()
  if currentChallengedFloor == 0 then
    self:SetCurrentInstanceInfor(self.InstanceContainer.items[1], display[1])
    self.lab_notice:SetText("\196\144\195\163 v\198\176\225\187\163t to\195\160n b\225\187\153")
  else
    self.lab_notice:SetText(string.format("\196\144\195\163 khi\195\170u chi\225\186\191n \196\145\225\186\191n t\225\186\167ng th\225\187\169 %s", currentChallengedFloor))
  end
  local count = TowerData.GetResidueChallengeCount()
  if 0 < count then
    self.lab_count1:SetText(string.format("<color=green>%s</color>", count))
  else
    self.lab_count1:SetText(string.format("<color=red>%s</color>", count))
  end
  self.lab_leftcount:SetActive(true)
end
