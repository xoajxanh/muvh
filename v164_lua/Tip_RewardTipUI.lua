Tip_RewardTipUI = class(BaseUI)
Tip_RewardTipUI.layer = UILayer.Tooltip
Tip_RewardTipUI.orderInLayer = 8
Tip_RewardTipUI.hideType = UIHideType.WaitDestroy
Tip_RewardTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_RewardTipUI.escClose = UIEscClose.DontClose

function Tip_RewardTipUI:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Img_TipBg = self:GetControl("Panel_Tip/Img_TipBg")
  self.img_title = self:GetControl("Panel_Tip/Img_TipBg/img_title")
  self.sw_item = self:GetControl("Panel_Tip/Img_TipBg/sw_item")
  self.Content = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content")
  self.btn_3DItem = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem")
  self.btn_3DItem1 = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem1")
  self.btn_3DItem2 = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem2")
  self.btn_3DItem3 = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem3")
  self.btn_3DItem4 = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem4")
  self.btn_3DItem5 = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem5")
  self.img_shopTitle = self:GetControl("Panel_Tip/Img_TipBg/img_shopTitle")
  self.plane_left = self:GetControl("Panel_Tip/plane_left")
  self.plane_right = self:GetControl("Panel_Tip/plane_right")
  self.tipPool = self:GetControl("tipPool")
end

function Tip_RewardTipUI:OnPreLoad()
end

function Tip_RewardTipUI:Init()
  self.model = {}
  self.matArray = {}
  self.itemCtrTime = {}
  self.itemEffectTime = {}
  self.refushNum = 0
  self.maxRefushNum = 6
  self.ItemTemp = {}
end

function Tip_RewardTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function InitRewardsItemControls(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemRewardsRefresh(ctr, _, itemData, ui)
  if ui.itemCtrTime[_] then
    Timer.Stop(ui.itemCtrTime[_])
    ui.itemCtrTime[_] = nil
  end
  ctr.gameObject:SetActive(false)
  
  local function rewardsShow()
    ctr.itemCellData:Reset()
    ctr.gameObject:SetActive(true)
    ctr.itemCellData:RefreshData(itemData)
    if ctr.itemCellData.itemData then
      ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
      local count = ctr.itemCellData.itemData.count
      if count and 1 <= count then
        ctr.countCtr:SetActive(true)
        ctr.countCtr:SetText(count)
      end
    else
      ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
    end
    ui.model[_] = ctr
    if ui.itemCtrTime[_] then
      Timer.Stop(ui.itemCtrTime[_])
      ui.itemCtrTime[_] = nil
    end
    if ui.refushNum <= ui.maxRefushNum and _ == ui.refushNum then
      ui:AddCoolDownTimeFadeOut()
    end
  end
  
  ui.itemCtrTime[_] = Timer.StartLoop(0.3 * (_ - 1), 1, rewardsShow)
end

function Tip_RewardTipUI:InitContent()
  self.rewardsItemTemp = UIContainer(self.btn_3DItem, self, InitRewardsItemControls, ItemRewardsRefresh)
end

function Tip_RewardTipUI:BianKuangEffect(_, parentItem)
  local effectData = {
    modelType = EEffectModelType.UI,
    model = "Eff_UI_jiangli"
  }
  local effect = EffectModel(parentItem.transform, nil, effectData)
  effect:Init()
  effect:SetLayer(UI_LAYER)
  effect:SetPosition(0, 0, 0)
  effect:SetModel(1)
  effect.transform.localScale = Vector3(1, 1, 1)
  self.bianKuangEffect[_] = effect
  if Tip_RewardTipUI.itemEffectTime[_] then
    Timer.Stop(Tip_RewardTipUI.itemEffectTime[_])
    Tip_RewardTipUI.itemEffectTime[_] = nil
  end
  
  local function rewardsShow()
    if effect ~= nil then
      effect:Destroy()
      Tip_RewardTipUI.bianKuangEffect[_] = nil
    end
    if Tip_RewardTipUI.itemEffectTime[_] then
      Timer.Stop(Tip_RewardTipUI.itemEffectTime[_])
      Tip_RewardTipUI.itemEffectTime[_] = nil
    end
  end
  
  self.itemEffectTime[_] = Timer.StartLoop(1, 1, rewardsShow)
end

function Tip_RewardTipUI:CleanEffect()
  for k, v in pairs(self.bianKuangEffect) do
    if v ~= nil then
      v:Destroy()
    end
  end
  for k, v in pairs(self.itemEffectTime) do
    if v then
      Timer.Stop(v)
      v = nil
    end
  end
end

function Tip_RewardTipUI:CleanModer()
  for k, v in pairs(self.model) do
    v.itemCellData:RecycleRes()
  end
  self:RemoveTipRewardPool()
  self.model = {}
  self.matArray = {}
end

function Tip_RewardTipUI:InitUI()
  self.Content.layoutGroup.enabled = false
  self.Content.layoutGroup.enabled = true
  self.contentX, self.contentY = self.sw_item:GetNormalizedPosition()
  self:InitContent()
  self.ItemTemp = {
    [1] = self.btn_3DItem,
    [2] = self.btn_3DItem1,
    [3] = self.btn_3DItem2,
    [4] = self.btn_3DItem3,
    [5] = self.btn_3DItem4,
    [6] = self.btn_3DItem5
  }
  self.tipRewardPool = {}
end

function Tip_RewardTipUI:OnShow()
  self:StartFadeTask(true, 0)
  self:RegistEvents()
  self:Refresh()
  if self.args and self.args.type then
    if self.args.type == BagChangeTypeEnum.Shop or self.args.type == BagChangeTypeEnum.OptionalBox then
      self.img_shopTitle:SetActive(true)
      self.img_title:SetActive(false)
    else
      self.img_title:SetActive(true)
      self.img_shopTitle:SetActive(false)
    end
  end
end

function Tip_RewardTipUI:AddCoolDownTimeFadeOut()
  if self.downTimer then
    Timer.Stop(self.downTimer)
    self.downTimer = nil
  end
  local downtime = tonumber(GlobalConfig.GetGlobalConfig(2460102))
  if downtime then
    self.downTimer = Timer.StartLoop(downtime / 1000, 1, function()
      self:AddFadeOutTime()
    end)
  end
end

function Tip_RewardTipUI:AddFadeOutTime()
  if self.fadeDownTimer then
    Timer.Stop(self.fadeDownTimer)
    self.fadeDownTimer = nil
  end
  local time = GlobalConfig.GetGlobalConfig(2460103)
  if time then
    self:StartFadeTask(false, tonumber(time / 1000))
    self:HideModer(tonumber(time / 1000))
  end
end

function Tip_RewardTipUI:StartFadeTask(isActivity, time)
  local quence = DOTween.Sequence()
  if self.Panel_Tip then
    if isActivity then
      quence:Append(self.Panel_Tip.canvasGroup:DOFade(1, time)):OnComplete(function()
      end)
    else
      quence:Append(self.Panel_Tip.canvasGroup:DOFade(0, time)):OnComplete(function()
        self:CloseTime()
        self:CleanModer()
        UIManager.Hide(UIID.Tip_RewardTipUI)
      end)
    end
  end
end

function Tip_RewardTipUI:HideModer(time)
  for k, v in pairs(self.model) do
    ItemUtility.FadeOut(v, v.itemCellData.model, time, tonumber(time + 0.1))
  end
end

function Tip_RewardTipUI:AddCoolDownTime()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
  local time = GlobalConfig.GetGlobalConfig(2460102)
  if time then
    self:StartAutoClose(tonumber(time))
  end
end

function Tip_RewardTipUI:StartAutoClose(time)
  self.countDownTimer = Timer.StartLoop(time / 1000, 1, function()
    self:CloseTime()
    self:CleanModer()
    UIManager.Hide(UIID.Tip_RewardTipUI)
  end)
end

function Tip_RewardTipUI:CloseTime()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
  if self.fadeDownTimer then
    Timer.Stop(self.fadeDownTimer)
    self.fadeDownTimer = nil
  end
  if self.downTimer then
    Timer.Stop(self.downTimer)
    self.downTimer = nil
  end
  for k, v in pairs(self.itemCtrTime) do
    if v then
      Timer.Stop(v)
      v = nil
    end
  end
  self.itemCtrTime = {}
end

function Tip_RewardTipUI:OnHide()
  if self.rewardsItemTemp ~= nil and self.rewardsItemTemp.RemoveKTable ~= nil then
    self.rewardsItemTemp:RemoveKTable()
  end
end

function Tip_RewardTipUI:OnDestroy()
end

function Tip_RewardTipUI:RegistUIEvents()
  self.Panel_Tip:SetOnClick(self, self.Panel_TipOnClick)
end

function Tip_RewardTipUI:Panel_TipOnClick(control)
  self:CloseTime()
  UIManager.Hide(UIID.Tip_RewardTipUI)
end

function Tip_RewardTipUI:RegistEvents()
end

function Tip_RewardTipUI:Refresh()
  if self.args ~= nil and self.args.rewards then
    local rewardsTabl = {}
    for i, v in pairs(self.args.rewards) do
      table.insert(rewardsTabl, v)
    end
    self.rewardsItemTemp:SetData(rewardsTabl)
    self:RemoveTipRewardPool()
    local allRewardData = {}
    for k, v in pairs(self.args.rewards) do
      local count = v.count
      local frequency = math.ceil(v.count / v.tblItem.overlying)
      if v.tblItem.overlying ~= -1 and v.count > v.tblItem.overlying then
        for i = 1, frequency do
          local item = table.DeepCopy(v)
          item.count = count >= v.tblItem.overlying and v.tblItem.overlying or count
          table.insert(allRewardData, item)
          count = count - v.tblItem.overlying
        end
      else
        table.insert(allRewardData, v)
      end
    end
    self.refushNum = table.count(rewardsTabl)
    local GridLayoutGroup = self.Content.transform:GetComponent("GridLayoutGroup")
    local ContentSizeFitted = self.Content.transform:GetComponent("ContentSizeFitter")
    self.sw_item:SetNormalizedPosition(0, 0)
    self.Content.transform.offsetMax = Vector2.zero
    if self.refushNum > self.maxRefushNum then
      GridLayoutGroup.childAlignment = TextAnchor.UpperLeft
      self.Content.contentSizeFitter.enabled = true
      if ContentSizeFitted ~= nil then
        ContentSizeFitted.horizontalFit = FitModeEnum.PreferredSize
      end
      self.plane_left:SetActive(true)
      self.plane_right:SetActive(true)
    else
      GridLayoutGroup.childAlignment = TextAnchor.MiddleCenter
      self.Content.contentSizeFitter.enabled = false
      self.plane_left:SetActive(false)
      self.plane_right:SetActive(false)
    end
  end
end

function Tip_RewardTipUI:RefreshBtns(itemData)
  for k, v in pairs(itemData) do
    if k > table.count(self.ItemTemp) then
      return
    end
    local item
    if k <= table.count(self.ItemTemp) then
      item = self.ItemTemp[k]
    else
      item = self:AddTipRewardPool(k - table.count(self.ItemTemp))
      item:SetActive(true)
    end
    if not item.itemCellData then
      item.itemCellData = ItemCellData()
    else
      item.itemCellData:RecycleRes()
    end
    if self.itemCtrTime[k] then
      Timer.Stop(ui.itemCtrTime[k])
      self.itemCtrTime[k] = nil
    end
    item:SetActive(false)
    
    local function rewardsShow()
      item.itemCellData:Reset()
      item.gameObject:SetActive(true)
      item.itemCellData:RefreshData(itemData[k])
      ItemUtility.ShowItemCell(item, item.itemCellData, self, true)
      self.model[k] = item
      if self.itemCtrTime[k] then
        Timer.Stop(self.itemCtrTime[k])
        self.itemCtrTime[k] = nil
      end
      if k == self.refushNum then
        self:AddCoolDownTimeFadeOut()
      end
    end
    
    self.itemCtrTime[k] = Timer.StartLoop(0.3 * (k - 1), 1, rewardsShow)
  end
end

function Tip_RewardTipUI:AddTipRewardPool(index)
  local item
  if self.tipRewardPool ~= nil then
    if self.tipRewardPool[index] then
      item = self.tipRewardPool[index]
      item.transform:SetParent(self.Content.transform, false)
    else
      item = Instantiate(self.btn_3DItem.gameObject)
      item.transform:SetParent(self.Content.transform, false)
      item = UIControl(item.transform)
      self.tipRewardPool[index] = item
    end
  else
    self.tipRewardPool = {}
    item = Instantiate(self.btn_3DItem.gameObject)
    item.transform:SetParent(self.Content.transform, false)
    item = UIControl(item.transform)
    self.tipRewardPool[index] = item
  end
  return item
end

function Tip_RewardTipUI:RemoveTipRewardPool()
  for k, v in pairs(self.ItemTemp) do
    v:SetActive(false)
  end
  if self.tipRewardPool ~= nil then
    for k, v in pairs(self.tipRewardPool) do
      if v ~= nil then
        v.transform:SetParent(self.tipPool.transform, false)
        v:SetActive(false)
      end
    end
  end
end
