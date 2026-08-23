local OnHookGetExpTemplate = {}

function OnHookGetExpTemplate:Init()
  self:InitControls()
  self:InitData()
end

function OnHookGetExpTemplate:InitControls()
  self.getExp = self:GetControl()
  self.getTip = self:GetControl("getTip")
  self.lab_getCoinExp = self:GetControl("getTip/lab_getCoinExp")
  self.lab_lackCoinExp = self:GetControl("lab_lackCoinExp")
  self.btn_getCoinExp = self:GetControl("btn_getCoinExp")
  self.btn_getCoin = self:GetControl("btn_getCoin")
end

function OnHookGetExpTemplate:InitData()
  self.getTipPosX, self.getTipPosY = self.getTip:GetAnchoredPosition()
end

function OnHookGetExpTemplate:ResetData(data)
  self.data = data
  self.rewardId = (data.expType - 1) * table.count(OnHookGetExpEnum) + data.getExpType
  self.expTypeStr = self:GetExpTypeStr(data)
  self.getTip:SetAnchoredPosition(self.getTipPosX, self.getTipPosY)
  self.lab_lackCoinExp:SetActive(true)
end

function OnHookGetExpTemplate:GetExpTypeStr(data)
  local expTypeStr = ""
  if data.expType == OnHookExpTypeEnum.Rein then
    local reinLv = ViewData.meData:GetReinLv()
    if 0 < reinLv then
      local levelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(ViewData.meData.level)
      expTypeStr = " " .. levelTbl.tips
    end
  elseif data.expType == OnHookExpTypeEnum.Holy then
    expTypeStr = "EXP Th\195\161nh L\225\187\177c"
  end
  return expTypeStr
end

function OnHookGetExpTemplate:Refresh(data)
  self:ResetData(data)
  self:RefreshTip(data)
  if data.getExpType == OnHookGetExpEnum.Exp then
    self:UpdateCanGetExp(data, self.expTypeStr)
    self.lab_lackCoinExp:SetActive(false)
    self.getTip:SetAnchoredPosition(self.getTipPosX, self.getTipPosY - 13)
    self.btn_getCoinExp:SetOnClick(self, self.btn_getExpOnClick)
  elseif data.getExpType == OnHookGetExpEnum.CoinExp then
    self:UpdateLackCoinExp(data, self.expTypeStr)
    local itemData = ItemUtility.GenerateItemData(ECoinsType.integral)
    self.btn_getCoinExp.itemData = itemData
    self.btn_getCoinExp.OpenTipsType = EOpenTipsType.FastBuy
    self.btn_getCoinExp:SetOnClick(self, self.btn_getCoinExpOnClick)
  elseif data.getExpType == OnHookGetExpEnum.MedicineExp then
    self:UpdateLackMedicineCoinExp(data, self.expTypeStr)
    local itemData = ItemUtility.GenerateItemData(3000405)
    self.btn_getCoinExp.itemData = itemData
    self.btn_getCoinExp.OpenTipsType = EOpenTipsType.FastBuy
    self.btn_getCoinExp:SetOnClick(self, self.btn_getMedicineExpOnClick)
  end
end

function OnHookGetExpTemplate:RefreshTip(data)
  local idStr = "OnHookName_%d_%d"
  local text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(string.format(idStr, data.expType, data.getExpType))
  self.getTip:SetText(text)
end

function OnHookGetExpTemplate:UpdateCanGetExp(data, expTypeStr)
  local lab_getExpStr = string.format("%d%s", data.exp.EXP, data.exp.EXP > 0 and expTypeStr or "")
  self.lab_getCoinExp:SetText(lab_getExpStr)
end

function OnHookGetExpTemplate:UpdateLackCoinExp(data, expTypeStr)
  local hookExpTbl = ClientTable.cfg_OnHook_OnLineManager:GetHookExpTblByLevel(OnHookExpType.OutLine, ViewData.meData.level)
  local baseDataIsEnough = hookExpTbl ~= nil and data.exp and data.exp.EXP > 0
  local ConfigCostItemId = hookExpTbl ~= nil and ClientTable.cfg_OnHook_OnLineManager:GetCostItemId(hookExpTbl.id)
  local ConfigCostText = hookExpTbl ~= nil and ClientTable.cfg_Ui_wordManager:GetUi_wordCount(hookExpTbl.goldui)
  local showOutLineInfo = baseDataIsEnough and ConfigCostItemId and string.isNullOrEmpty(ConfigCostText) == false and data.exp ~= nil
  self:GetControl():SetActive(showOutLineInfo)
  if not showOutLineInfo then
    return
  end
  local Eff_UI_annuikuang03 = self.btn_getCoinExp:GetChild("Eff_UI_annuikuang03")
  local ownGold = BagInfoData.GetItemTotalCountByItemId(ConfigCostItemId)
  Eff_UI_annuikuang03:SetActive(ownGold >= data.money)
  local lab_getCoinExpStr = string.format("%d%s", data.exp.EXP, data.exp.EXP > 0 and expTypeStr or "")
  self.lab_getCoinExp:SetText(lab_getCoinExpStr)
  self.lab_lackCoinExp:SetText(string.format(ConfigCostText, TimeUtility.ShowMinuteTime(data.exp.time), tostring(data.money)))
end

function OnHookGetExpTemplate:UpdateLackMedicineCoinExp(data, expTypeStr)
  local medTime = ExpAddData.MultipleTime and ExpAddData.MultipleTime or 0
  local timer = math.floor(medTime / 60)
  if timer < data.exp.time then
    self.btn_getMedicineExp:GetChild("Eff_UI_annuikuang03"):SetActive(false)
  else
    self.btn_getMedicineExp:GetChild("Eff_UI_annuikuang03"):SetActive(true)
  end
  local lab_getMedicineExpStr = string.format("%d%s", data.exp.EXP, 0 < data.exp.EXP and expTypeStr or "")
  self.lab_getMedicineExp:SetText(lab_getMedicineExpStr)
  self.lab_lackMedicineExp:SetText(string.format("Th\225\187\157i l\198\176\225\187\163ng Thu\225\187\145c EXP b\225\187\149 sung \196\145\225\186\167y %s", TimeUtility.ShowMinuteTime(data.exp.time)))
end

function OnHookGetExpTemplate:RefreshBtnEffect()
  if self.data.getExpType == OnHookGetExpEnum.CoinExp then
    self:UpdateLackCoinExp(self.data, self.expTypeStr)
  elseif self.data.getExpType == OnHookGetExpEnum.MedicineExp then
    self:UpdateLackMedicineCoinExp(self.data, self.expTypeStr)
  end
end

function OnHookGetExpTemplate:btn_getExpOnClick(control)
  NetManager.Send(OnHookMessage.ReqGetOnHookReward, {
    id = self.rewardId
  })
end

function OnHookGetExpTemplate:btn_getCoinExpOnClick(control)
  local hookExpTbl = ClientTable.cfg_OnHook_OnLineManager:GetHookExpTblByLevel(OnHookExpType.OutLine, ViewData.meData.level)
  if hookExpTbl == nil then
    return
  end
  local ConfigCostItemId = hookExpTbl ~= nil and ClientTable.cfg_OnHook_OnLineManager:GetCostItemId(hookExpTbl.id)
  if not ConfigCostItemId then
    return
  end
  local ownGold = BagInfoData.GetItemTotalCountByItemId(ConfigCostItemId)
  if ownGold < self.data.money then
    ItemUtility.ClickObtainItemBtn(_, control)
    FloatingTipUtility.QuickMsg("Ti\225\187\129n kh\195\180ng \196\145\225\187\167")
    return
  end
  NetManager.Send(OnHookMessage.ReqGetOnHookReward, {
    id = self.rewardId
  })
end

function OnHookGetExpTemplate:btn_getMedicineExpOnClick(control)
  local medTime = ExpAddData.MultipleTime and ExpAddData.MultipleTime or 0
  local timer = math.floor(medTime / 60)
  if timer < OnHookData.buffExp.time then
    ItemUtility.ClickObtainItemBtn(_, control)
    FloatingTipUtility.QuickMsg("Thu\225\187\145c EXP kh\195\180ng \196\145\225\187\167")
    return
  end
  NetManager.Send(OnHookMessage.ReqGetOnHookReward, {
    id = self.rewardId
  })
end

return OnHookGetExpTemplate
