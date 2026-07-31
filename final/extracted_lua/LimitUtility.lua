LimitUtility = {}
local this = LimitUtility

function LimitUtility.NoEnoughPrompt(type, parent)
  local str = ""
  if type == EBuyTipEnum.noEnoughGold then
    str = LocalizationUtility.GetContentByKey("BuyFailed_1")
  elseif type == EBuyTipEnum.noEnoughLevel then
    str = LocalizationUtility.GetContentByKey("BuyFailed_2")
  elseif type == EBuyTipEnum.noEnoughCount then
    str = LocalizationUtility.GetContentByKey("BuyFailed_3")
  elseif type == EBuyTipEnum.noEnoughBgCell then
    str = LocalizationUtility.GetContentByKey("BuyFailed_4")
  elseif type == EBuyTipEnum.noProvideTime then
    str = LocalizationUtility.GetContentByKey("BuyFailed_5")
  elseif type == EBuyTipEnum.noServerTime then
    str = LocalizationUtility.GetContentByKey("BuyFailed_6")
  elseif type == EBuyTipEnum.instanceNoEnoughCount then
    str = LocalizationUtility.GetContentByKey("InstanceCountInsufficient")
  elseif type == EBuyTipEnum.noEnoughScore then
    str = LocalizationUtility.GetContentByKey("BuyFailed_1")
  else
    str = LocalizationUtility.GetContentByKey("BuyFailed_7")
  end
  FloatingTipUtility.QuickMsg(str)
end

function LimitUtility.GetTipText(buyLimitShow, shopInfo)
  local str, limitType
  if buyLimitShow then
    str, limitType = this.GenerateTipText(buyLimitShow)
  else
    local isFree = false
    if string.isNullOrEmpty(shopInfo.cost) then
      isFree = true
    end
    if shopInfo.countKey ~= 0 then
      str, limitType = this.GetLimitTipText(shopInfo.countKey, isFree)
    end
  end
  return str, limitType
end

function LimitUtility.LimitType(countTbl, count)
  local str
  if string.isNullOrEmpty(countTbl.refreshRule) then
    str = LocalizationUtility.GetContentByKey("ShopUi_9")
  else
    local refreshRuleTbl = string.split(countTbl.refreshRule, "#")
    local refreshType = tonumber(refreshRuleTbl[1])
    if refreshType == EConditionEnum.timeMonthMoreThanOrEqual then
      str = LocalizationUtility.GetContentByKey("ShopUi_7")
    elseif refreshType == EConditionEnum.timeWeekendMoreThanOrEqual then
      str = LocalizationUtility.GetContentByKey("ShopUi_8")
    else
      str = LocalizationUtility.GetContentByKey("ShopUi_15")
    end
  end
  return string.format("%s %d", str, count)
end

function LimitUtility.FreeLimitType(countTbl, count)
  local str
  if string.isNullOrEmpty(countTbl.refreshRule) then
    str = LocalizationUtility.GetContentByKey("ShopUi_13")
  else
    local refreshRuleTbl = string.split(countTbl.refreshRule, "#")
    local refreshType = tonumber(refreshRuleTbl[1])
    if refreshType == EConditionEnum.timeMonthMoreThanOrEqual then
      str = LocalizationUtility.GetContentByKey("ShopUi_12")
    elseif refreshType == EConditionEnum.timeWeekendMoreThanOrEqual then
      str = LocalizationUtility.GetContentByKey("ShopUi_11")
    else
      str = LocalizationUtility.GetContentByKey("ShopUi_10")
    end
  end
  return string.format("%s %d", str, count)
end

function LimitUtility.GetLimitTipText(countKey, isFree)
  local str, limit
  local remainder = RefreshData.GetLimitCount(countKey)
  local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
  if isFree then
    str = this.FreeLimitType(countTbl, remainder)
  else
    str = this.LimitType(countTbl, remainder)
  end
  if remainder == 0 then
    str = string.GetColorText(str, "#FF0000")
    limit = EBuyTipEnum.noEnoughCount
  end
  return str, limit
end

function LimitUtility.GenerateTipText(limitTbl)
  local str, limit
  if limitTbl.type == EConditionEnum.levelGEqual then
    str = string.format(LocalizationUtility.GetContentByKey("CanNotBuy_5"), limitTbl.content)
    limit = EBuyTipEnum.noEnoughLevel
  elseif limitTbl.type == EConditionEnum.timeBetween then
    str = LocalizationUtility.GetContentByKey("CanNotBuy_1") .. limitTbl.content
    limit = EBuyTipEnum.noProvideTime
  elseif limitTbl.type == EConditionEnum.timeOpenServerMoreThanOrEqual then
    str = LocalizationUtility.GetContentByKey("CanNotBuy_2") .. limitTbl.content
    limit = EBuyTipEnum.noServerTime
  elseif limitTbl.type >= EConditionEnum.careerUpWardCompatibilty and limitTbl.type <= EConditionEnum.careerDownWardCompatibilty then
    str = string.format(LocalizationUtility.GetContentByKey("CanNotBuy_4"), RoleUtility.GteCareerNameByType(tonumber(limitTbl.content)))
    limit = EBuyTipEnum.noEnoughCareer
  else
    str = LocalizationUtility.GetContentByKey("CanNotBuy_3")
    limit = EBuyTipEnum.ConditionNoteEnough
  end
  return str, limit
end

function LimitUtility.GetLimitShow(condition)
  local buyLimitShow = {}
  local buyConditionTbl = ParseUtility.GetTblByAnalysisCondition(condition)
  buyLimitShow = this.GenerateLimitShow(buyConditionTbl)
  return buyLimitShow
end

function LimitUtility.GenerateLimitShow(buyConditionTbl)
  local result = false
  for _, groupConditionTbl in pairs(buyConditionTbl) do
    local andResult = true
    for type, content in pairs(groupConditionTbl) do
      local checkResult = ConditionManager.Check(type .. "#" .. content)
      andResult = andResult and checkResult
      if checkResult then
        groupConditionTbl[type] = nil
      end
    end
    result = result or andResult
  end
  local tempTbl
  if not result then
    for _, groupConditionTbl in pairs(buyConditionTbl) do
      for mType, mContent in pairs(groupConditionTbl) do
        if mType >= EConditionEnum.timeOpenServerMoreThanOrEqual and mType <= EConditionEnum.timeMonthMoreThanOrEqual then
          tempTbl = tempTbl or {}
          tempTbl = {type = mType, content = mContent}
          tempTbl = {type = mType, content = mContent}
        end
        if mType >= EConditionEnum.levelGreater and mType <= EConditionEnum.levelNotEqual and not tempTbl then
          tempTbl = tempTbl or {}
          tempTbl = {type = mType, content = mContent}
        end
        if mType >= EConditionEnum.careerUpWardCompatibilty and mType <= EConditionEnum.careerDownWardCompatibilty and not tempTbl then
          tempTbl = tempTbl or {}
          tempTbl = {type = mType, content = mContent}
        end
        if not tempTbl then
          tempTbl = tempTbl or {}
          tempTbl = {type = mType, content = mContent}
        end
      end
    end
  end
  return tempTbl
end
