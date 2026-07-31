local PandoraActivityMiningTemplate = {}

local function btn3DItemCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function btn3DItemRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui.root, true)
end

function PandoraActivityMiningTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUIEvents()
  self.digType = 2
  self.promptWordIdList = {
    83,
    84,
    85,
    96,
    87,
    86
  }
  self.btn3DItemContainer = UIContainer(self.btn_3DItem, self, btn3DItemCreate, btn3DItemRefresh)
  self.lastTime1 = 0
  self.lastTime2 = 0
end

function PandoraActivityMiningTemplate:InitControls()
  self.digBtnList = {}
  self.digIconList = {}
  for i = 1, 5 do
    self.digBtnList[i] = self:GetControl("sw_diggings/img_bg_" .. i - 1 .. "/btn_dig")
    self.digIconList[i] = self:GetControl("sw_diggings/img_bg_" .. i - 1 .. "/img_icon")
  end
  self.btn_digFree = self:GetControl("btn_digFree")
  self.btn_digFreeDark = self:GetControl("btn_digFree/lab_get_dark")
  self.btn_digEndless = self:GetControl("btn_digEndless")
  self.btn_digStop = self:GetControl("btn_digStop")
  self.tipUI = self:GetControl("Tip_GetItemTipUI")
  self.btn_closeBg = self:GetControl("Tip_GetItemTipUI/Panel_Tip")
  self.tip_imgTitle = self:GetControl("Tip_GetItemTipUI/Panel_Tip/Img_TipBg/img_title")
  self.tip_labText = self:GetControl("Tip_GetItemTipUI/Panel_Tip/Img_TipBg/lab_text")
  self.btn_3DItem = self:GetControl("Tip_GetItemTipUI/Panel_Tip/Img_TipBg/sw_item/Viewport/Content/btn_3DItem")
  self.btn_ok = self:GetControl("Tip_GetItemTipUI/Panel_Tip/Img_TipBg/btn_ok")
end

function PandoraActivityMiningTemplate:InitUIEvents()
  for i = 1, #self.digIconList do
    self.digIconList[i]:SetOnClick(self, self.OnClickDigBtn)
  end
  self.btn_digFree:SetOnClick(self, self.OnClickFreeDigBtn)
  self.btn_digEndless:SetOnClick(self, self.OnClickDigStart)
  self.btn_digStop:SetOnClick(self, self.OnClickDigStop)
  self.btn_ok:SetOnClick(self, self.CloseGetItemTip)
  self.btn_closeBg:SetOnClick(self, self.CloseGetItemTip)
end

function PandoraActivityMiningTemplate:InitView()
  for i = 1, #self.digBtnList do
    self.digBtnList[i]:SetRaycastTarget(false)
    self.digBtnList[i]:SetActive(false)
  end
end

function PandoraActivityMiningTemplate:SetSelect()
  self:InitView()
  local index = PandoraActivityData.CheckLoggedThisRole(RoleManager.me.data.id)
  self.digBtnList[index]:SetActive(true)
end

function PandoraActivityMiningTemplate:OnClickFreeDigBtn(control)
  local state = PandoraActivityData.CheckFreeDigCount()
  if not state then
    TipUtility.QuickShowPrompt({
      id = 151,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end
    })
    return
  end
  self:FreeDig()
end

function PandoraActivityMiningTemplate:OnClickDigBtn(control)
  if control then
    self:InitView()
    local index = tonumber(string.sub(control:GetParent().name, -1))
    PandoraActivityData.selectIndexAll[RoleManager.me.data.id] = index + 1
    self.digBtnList[index + 1]:SetActive(true)
    if PandoraActivityData.CheckFreeDigCount() then
      self:FreeDig()
      return
    end
  end
  local isEnough = PandoraActivityData.CheckDiamondEnough()
  if isEnough == false then
    TipUtility.QuickShowPrompt({
      id = 88,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
        if RechargeData.IsNeedGotoRecharge(BusinessPayType.None) then
          UIManager.Show(UIID.Recharge_FirstChargeUI, {
            PayType = BusinessPayType.None
          })
        else
          UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 4})
        end
      end
    })
    return
  else
    local playerPrefs = string.format("%s_PandoraDigIsShowPandoraActivityUI", ViewData.meData.id)
    local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
    local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
    if lastRecordTime == 0 or isServerSameDay == false then
      if control ~= nil then
        TipUtility.QuickShowPrompt({
          id = 90,
          onlyOnce = true,
          onlyOnceArgs = nil,
          onlyOnceAction = function(args, isOn)
            PlayerPrefs.SetInt(playerPrefs, isOn and Time.GetServerSecondTime() or 0)
          end,
          cancelAction = function()
            UIManager.Hide(UIID.PromptTipUI)
          end,
          okAction = function()
            self:Dig(false)
          end
        })
      else
        self:Dig(false)
      end
    else
      self:Dig(false)
    end
  end
end

function PandoraActivityMiningTemplate:Dig(isFree)
  networkRequest.ReqPandoraLottery(PandoraActivityData.nowSelectTogCommerceId, isFree)
end

function PandoraActivityMiningTemplate:InfiniteDig()
  self.digType = 1
  networkRequest.ReqPandoraInfinite(self.digType, PandoraActivityData.nowSelectTogCommerceId)
end

function PandoraActivityMiningTemplate:OnClickDigStart(control)
  local nowTime = Time.GetServerTime()
  if nowTime - self.lastTime2 < 1500 then
    return
  else
    self.lastTime2 = nowTime
  end
  local isEnough = PandoraActivityData.CheckDiamondEnough()
  if isEnough == false then
    TipUtility.QuickShowPrompt({
      id = 88,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
        if RechargeData.IsNeedGotoRecharge(BusinessPayType.None) then
          UIManager.Show(UIID.Recharge_FirstChargeUI, {
            PayType = BusinessPayType.None
          })
        else
          UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 4})
        end
      end
    })
    return
  else
    local playerPrefs = string.format("%s_PandoraInfiniteDigIsShowPandoraActivityUI", ViewData.meData.id)
    local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
    local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
    if lastRecordTime == 0 or isServerSameDay == false then
      TipUtility.QuickShowPrompt({
        id = 95,
        onlyOnce = true,
        onlyOnceArgs = nil,
        onlyOnceAction = function(args, isOn)
          PlayerPrefs.SetInt(playerPrefs, isOn and Time.GetServerSecondTime() or 0)
        end,
        cancelAction = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        okAction = function()
          self.btn_closeBg:SetInteractable(false)
          self.root:SetToggleInteractable(false)
          self:InfiniteDig()
        end
      })
    else
      self.btn_closeBg:SetInteractable(false)
      self.root:SetToggleInteractable(false)
      self:InfiniteDig()
    end
  end
end

function PandoraActivityMiningTemplate:OnClickDigStop(control)
  self:StopInfiniteDig()
end

function PandoraActivityMiningTemplate:InfiniteStop()
  self:Reset()
  self.btn_ok:SetActive(true)
  self.btn_closeBg:SetInteractable(true)
  self.root:SetToggleInteractable(true)
end

function PandoraActivityMiningTemplate:Reset()
  if self.nowLayer == 1 then
    self.btn_digEndless:SetActive(true)
    self.btn_digStop:SetActive(false)
  else
    self.btn_digEndless:SetActive(false)
    self.btn_digStop:SetActive(false)
  end
  self.digType = 2
end

function PandoraActivityMiningTemplate:StopInfiniteDig()
  if self.digType == 1 then
    self.digType = 2
    networkRequest.ReqPandoraInfinite(self.digType, PandoraActivityData.nowSelectTogCommerceId)
    return false
  end
  return true
end

function PandoraActivityMiningTemplate:Refresh(_data, _ui)
  if _data == nil or _ui == nil then
    return
  end
  if PandoraActivityData.lastRoleId == nil then
    PandoraActivityData.lastRoleId = RoleManager.me.data.id
  end
  if RoleManager.me.data.id ~= PandoraActivityData.lastRoleId then
    self:CloseGetItemTip()
  end
  if PandoraActivityData.GetLastLayer() == nil then
    PandoraActivityData.SetLastLayer(_data.layer)
  end
  self.nowLayer = _data.layer
  if self.nowLayer == 1 and self.digType == 2 then
    self.btn_digEndless:SetActive(true)
    self.btn_digStop:SetActive(false)
  elseif self.nowLayer == 1 and self.digType == 1 then
    self.btn_digEndless:SetActive(false)
    self.btn_digStop:SetActive(true)
  else
    self.btn_digEndless:SetActive(false)
    self.btn_digStop:SetActive(false)
  end
  if _data.openState and _data.openState == 1 and #_data.items ~= 0 then
    self.root.Btn_Pandora.toggle.isOn = true
    UIManager.Show(UIID.Tip_PromptItemTipUI, {
      itemData = _data.items,
      layer = _data.layer,
      rewardType = _data.rewardType
    })
    self.tipUI:SetActive(false)
    return
  end
  if _data.rewardType == 2 and PandoraActivityData.GetLastLayer() ~= PandoraActivityData.GetMaximumNumberOfLevels() then
    PandoraActivityData.SetLastLayer(_data.layer)
  end
  if _data.rewardType ~= -1 and #_data.items ~= 0 then
    local itemInfoTbl = {}
    for i, v in ipairs(_data.items) do
      local itemInfo = ItemUtility.GenerateItemData(v.itemId)
      itemInfo.count = v.count
      table.insert(itemInfoTbl, itemInfo)
    end
    local wordId
    local layer = -1
    local nowLayer = PandoraActivityData.GetLastLayer()
    local MaxLevel = PandoraActivityData.GetMaximumNumberOfLevels()
    if _data.rewardType == 1 then
      if nowLayer ~= 1 then
        wordId = 85
      else
        wordId = 93
      end
      layer = nowLayer
    elseif _data.rewardType == 2 then
      if nowLayer == MaxLevel then
        wordId = self.promptWordIdList[6]
      elseif 1 < nowLayer and nowLayer < MaxLevel then
        wordId = self.promptWordIdList[4]
        layer = nowLayer
      else
        wordId = self.promptWordIdList[4]
      end
    elseif _data.rewardType == 3 then
      wordId = self.promptWordIdList[5]
    end
    local infoTbl = {
      rewards = itemInfoTbl,
      promptWordId = wordId,
      digType = self.digType,
      layer = layer
    }
    self:ShowGetItemTip(infoTbl)
    PandoraActivityData.SetLastLayer(_data.layer)
  else
    self.btn_ok:SetActive(true)
  end
  
  local function digAgain()
    networkRequest.ReqPandoraInfinite(self.digType, PandoraActivityData.nowSelectTogCommerceId)
  end
  
  if _data.nextInfiniteTime ~= nil and self.digType == 1 then
    self:CloseTimer()
    local interval = _data.nextInfiniteTime - Time.GetServerTime()
    local timeInterval = tonumber(GlobalConfig.GetGlobalConfig(64001003))
    if interval > timeInterval then
      self.timer = Timer.Start(interval / 1000, digAgain)
    else
      self.timer = Timer.Start(timeInterval / 1000, digAgain)
    end
  end
end

function PandoraActivityMiningTemplate:CloseTimer()
  if self.timer ~= nil then
    Timer.Stop(self.timer)
    self.timer = nil
  end
end

function PandoraActivityMiningTemplate:SetBtnsState(state)
  self.btn_digEndless:SetInteractable(state)
  for i = 1, #self.digIconList do
    self.digIconList[i]:SetRaycastTarget(state)
  end
end

function PandoraActivityMiningTemplate:ShowGetItemTip(infoTbl)
  self.tipUI:SetActive(false)
  self.tip_imgTitle:SetActive(false)
  local showStr = ClientTable.cfg_Ui_promptwordManager:TryGetValue(infoTbl.promptWordId).content
  if infoTbl.layer ~= -1 then
    self.tip_labText:SetText(string.format(showStr, tostring(infoTbl.layer - 1)))
  else
    self.tip_labText:SetText(showStr)
  end
  if infoTbl.digType == PandoraDigTypeEnum.OrdinaryDig then
    self.btn_ok:SetActive(true)
  else
    self.btn_ok:SetActive(false)
  end
  self.btn3DItemContainer:SetData(infoTbl.rewards)
  self.tipUI:SetActive(true)
  PandoraActivityData.SetLastRoleGetRewardInfo(RoleManager.me.data.id, infoTbl)
end

function PandoraActivityMiningTemplate:CloseGetItemTip()
  self.tipUI:SetActive(false)
end

function PandoraActivityMiningTemplate:SetFreeDigBtnState()
  local state = PandoraActivityData.CheckFreeDigCount()
end

function PandoraActivityMiningTemplate:FreeDig()
  local playerPrefs = string.format("%s_PandoraFreeDigIsShowPandoraActivityUI", ViewData.meData.id)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    TipUtility.QuickShowPrompt({
      id = 149,
      onlyOnce = true,
      onlyOnceArgs = nil,
      onlyOnceAction = function(args, isOn)
        PlayerPrefs.SetInt(playerPrefs, isOn and Time.GetServerSecondTime() or 0)
      end,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        self:Dig(true)
      end
    })
  else
    self:Dig(true)
  end
end

function PandoraActivityMiningTemplate:OnDestroy()
end

return PandoraActivityMiningTemplate
