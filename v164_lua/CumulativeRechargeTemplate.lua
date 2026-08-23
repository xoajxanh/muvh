local CumulativeRechargeTemplate = {}

function CumulativeRechargeTemplate:Init(data)
  if data then
    self.rootUI = data.rootUI
    self.activityType = data.activityType
  end
  self:InitControls()
  self:BindUIEvent()
end

function CumulativeRechargeTemplate:InitControls()
  self.slider = self:GetControl("Slider")
  self.btn_Get = self:GetControl("btn_Get")
  self.btn_Recharge = self:GetControl("btn_Recharge")
  self.btn_Received = self:GetControl("btn_Received")
  self.btn_3DItem = self:GetControl("btn_3DItem")
  self.btn_3DItem.itemCellData = ItemCellData()
  self.modelParent = self:GetControl("go_item")
  self.txt_Recharge = self:GetControl("Slider/txt_recharge")
end

function CumulativeRechargeTemplate:BindUIEvent()
  self.btn_Get:SetOnClick(self, self.btn_GetOnClick)
  self.btn_Recharge:SetOnClick(self, self.btn_RechargeOnClick)
end

function CumulativeRechargeTemplate:btn_GetOnClick()
  local functionConfig = ClientTable.cfg_Function_functionManager:TryGetValue(4010104)
  if functionConfig == nil or functionConfig.condition == nil then
    return
  end
  if ConditionManager.Check4D(functionConfig.condition) then
    UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 4})
    UIManager.Hide(UIID.Pc_ActivityUI)
  else
    UIManager.Show(UIID.Recharge_FirstChargeUI, {
      PayType = BusinessPayType.None
    })
    UIManager.Hide(UIID.Pc_ActivityUI)
  end
end

function CumulativeRechargeTemplate:btn_RechargeOnClick()
  local cumulativeRechargeGiftData = PCActivityManager:GetCumulativeRechargeGiftData()
  if cumulativeRechargeGiftData == nil or next(cumulativeRechargeGiftData) == nil then
    return
  end
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      cumulativeRechargeGiftData.id
    }
  })
end

function CumulativeRechargeTemplate:Refresh()
  self:Refresh3DItem()
  self:RefreshSlider()
  self:RefreshButtonState()
  self:RefreshModel()
end

function CumulativeRechargeTemplate:Refresh3DItem()
  local cumulativeRechargeGiftData = PCActivityManager:GetCumulativeRechargeGiftData()
  if cumulativeRechargeGiftData == nil or next(cumulativeRechargeGiftData) == nil then
    return
  end
  self.btn_3DItem.itemCellData:RecycleRes()
  local boxConfigTab = ClientTable.cfg_Box_boxManager:TryGetValue(tonumber(cumulativeRechargeGiftData.reward), "boxId")
  if boxConfigTab == nil or next(boxConfigTab) == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(boxConfigTab.itemId)
  itemData.count = boxConfigTab.count
  self.btn_3DItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.btn_3DItem.itemCellData, self.rootUI, true)
end

function CumulativeRechargeTemplate:RefreshSlider()
  local effect = GlobalConfig.GetGlobalConfig(63000008)
  if string.isNullOrEmpty(effect) then
    return
  end
  self.maxTotalNumber = tonumber(effect)
  self.nowNumber = PCActivityManager:GetPCTotalRechargePoint()
  self.slider:SetValue(self.nowNumber / self.maxTotalNumber)
  self.txt_Recharge:SetText(string.format("T\195\173ch N\225\186\161p hi\225\187\135n t\225\186\161i: %d VN\196\144 ", self.nowNumber))
end

function CumulativeRechargeTemplate:RefreshButtonState()
  local cumulativeRechargeGiftData = PCActivityManager:GetCumulativeRechargeGiftData()
  if cumulativeRechargeGiftData == nil or next(cumulativeRechargeGiftData) == nil then
    return
  end
  self.btn_Get:SetActive(false)
  self.btn_Recharge:SetActive(false)
  self.btn_Received:SetActive(false)
  if self.nowNumber >= self.maxTotalNumber then
    local isReceiveReward = PCActivityManager:CheckIsReceiveReward(cumulativeRechargeGiftData.countKey)
    self.btn_Recharge:SetActive(not isReceiveReward)
    self.btn_Received:SetActive(isReceiveReward)
  else
    self.btn_Get:SetActive(true)
  end
end

function CumulativeRechargeTemplate:RefreshModel()
  if self.loadMountCoroutine then
    Coroutine.Stop(self.loadMountCoroutine)
    self.loadMountCoroutine = nil
  end
  if self.LoadMountObject ~= nil then
    local go = self.LoadMountObject
    UnityEngineLua.GameObject.Destroy(go)
    self.LoadMountObject = nil
  end
  self.loadMountCoroutine = Coroutine.Start(self.DoLoadModel, self)
end

function CumulativeRechargeTemplate:DoLoadModel()
  local cumulativeRechargeGiftData = PCActivityManager:GetCumulativeRechargeGiftData()
  if cumulativeRechargeGiftData == nil or next(cumulativeRechargeGiftData) == nil then
    return
  end
  local boxConfigTab = ClientTable.cfg_Box_boxManager:TryGetValue(tonumber(cumulativeRechargeGiftData.reward), "boxId")
  if boxConfigTab == nil or next(boxConfigTab) == nil then
    return
  end
  local riderData = ClientTable.cfg_Item_mountManager:TryGetValue(boxConfigTab.itemId, "id")
  local path = string.format("Model/%s/%s.prefab", riderData.route, riderData.model)
  local request = self.rootUI:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
  Coroutine.Yield(request)
  if request.isError then
    print("\232\175\165\232\163\133\229\164\135\230\154\130\230\151\160\230\168\161\229\158\139")
    Coroutine.Break()
  end
  local go = Instantiate(request.res)
  self.LoadMountObject = go
  go.transform:SetParent(self.modelParent.transform, false)
  local itemData = ItemUtility.GenerateItemData(boxConfigTab.itemId)
  if itemData.tblItem and itemData.tblItem.showSize then
    local scale = itemData.tblItem.showSize
    go.transform.localPosition = Vector3(0, -35, -500)
    go.transform.localEulerAngles = Vector3(0, 135, 0)
    go.transform.localScale = Vector3(scale, scale, scale)
  else
    go.transform.localPosition = Vector3(0, -35, -500)
    go.transform.localEulerAngles = Vector3(0, 135, 0)
    go.transform.localScale = Vector3(38, 38, 38)
  end
  go:SetLayer(UI_LAYER)
  local orderLayer = 500
  if self then
    orderLayer = self.rootUI.root.canvas.sortingOrder
  end
  local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renders.Length - 1 do
    local rend = renders[i]
    rend.sortingOrder = orderLayer + 100
  end
end

return CumulativeRechargeTemplate
