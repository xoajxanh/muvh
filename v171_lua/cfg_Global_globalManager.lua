local cfg_Global_globalManager = {}

function cfg_Global_globalManager:GetName()
  return "cfg_Global_globalManager"
end

function cfg_Global_globalManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Global_global")
  end
  return self.dic
end

setmetatable(cfg_Global_globalManager, TableManagerBase)

function cfg_Global_globalManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Global_globalManager:GetGlobalItemEffect(id)
  local effect = ""
  local table = self:TryGetValue(id)
  if table ~= nil then
    effect = table.effect
  end
  return effect
end

function cfg_Global_globalManager:GetDropItemShowCountList()
  if self.DropItemShowCountList == nil then
    self.DropItemShowCountList = {}
    local temp = self:TryGetValue(3)
    if temp ~= nil and temp.effect ~= nil then
      local strs = string.split(temp.effect, "#")
      for i, v in pairs(strs) do
        table.insert(self.DropItemShowCountList, tonumber(v))
      end
    end
  end
  return self.DropItemShowCountList
end

function cfg_Global_globalManager:ExcellentEquipRecycleLimit()
  local globalTbl = self:TryGetValue(2140026)
  if globalTbl == nil or string.isNullOrEmpty(globalTbl.effect) then
    return true
  end
  return ConditionManager.Check4D(globalTbl.effect)
end

function cfg_Global_globalManager:AnalysisHibitAutoDrop(id)
  local DropCdTableList = {}
  local temp1 = cfg_Global_globalManager:TryGetValue(id)
  if temp1 ~= nil then
    local temp = string.split(temp1.effect, "&")
    for i, v in pairs(temp) do
      local strS = string.split(v, "#")
      if #strS == 2 then
        local data = {
          level = tonumber(strS[1]),
          cdTime = tonumber(strS[2])
        }
        table.insert(DropCdTableList, data)
      end
    end
  end
  return DropCdTableList
end

function cfg_Global_globalManager:GetHibitAutoDropCd()
  if RoleManager.me == nil then
    self.hibitAutoDropCd = nil
    self.immunityHibitAutoDropCd = nil
    self.hibitAutoDropCd_nowLevel = nil
    return 0, 0
  end
  if self.hibitAutoDropCd_nowLevel == RoleManager.me.level and self.hibitAutoDropCd ~= nil and self.immunityHibitAutoDropCd ~= nil then
    return self.hibitAutoDropCd, self.immunityHibitAutoDropCd
  end
  if self.hibitAutoDropCdTableList == nil then
    self.hibitAutoDropCdTableList = self:AnalysisHibitAutoDrop(1180004)
  end
  if self.immunityHibitAutoDropCdTable == nil then
    self.immunityHibitAutoDropCdTable = self:AnalysisHibitAutoDrop(1180005)
  end
  self.hibitAutoDropCd = self:GetHibitAutoDropCd_NowLevel(self.hibitAutoDropCdTableList)
  self.immunityHibitAutoDropCd = self:GetHibitAutoDropCd_NowLevel(self.immunityHibitAutoDropCdTable)
  self.hibitAutoDropCd_nowLevel = RoleManager.me.level
  return self.hibitAutoDropCd, self.immunityHibitAutoDropCd
end

function cfg_Global_globalManager:GetHibitAutoDropCd_NowLevel(CdTableList)
  for i, v in pairs(CdTableList) do
    if v.level >= RoleManager.me.level then
      return v.cdTime
    end
  end
  return 0
end

function cfg_Global_globalManager:TryInitMonsterGuideRangeConfig()
  if self.monsterGuideRange == nil then
    self.monsterGuideRange = {}
    local globalTbl = cfg_Global_globalManager:TryGetValue(8)
    if globalTbl == nil then
      return
    end
    local configList = string.split(globalTbl.effect, "#")
    if #configList < 2 then
      return
    end
    for i = 1, #configList do
      configList[i] = tonumber(configList[i])
    end
    self.monsterGuideRange = configList
  end
end

function cfg_Global_globalManager:CheckMonsterGuideRange(distance)
  self:TryInitMonsterGuideRangeConfig()
  if #self.monsterGuideRange > 0 then
    return distance < self.monsterGuideRange[1]
  end
end

function cfg_Global_globalManager:CheckMonsterGuideCloseRange(distance)
  self:TryInitMonsterGuideRangeConfig()
  if #self.monsterGuideRange > 1 then
    return distance >= self.monsterGuideRange[2]
  end
end

function cfg_Global_globalManager:GetAutoTaskLevel()
  if self.AutoTaskLevel == nil then
    local AutoTaskLevelGloble = cfg_Global_globalManager:TryGetValue(7)
    self.AutoTaskLevel = tonumber(AutoTaskLevelGloble.effect)
  end
  return self.AutoTaskLevel
end

function cfg_Global_globalManager:GetDefaultGuardData()
  if self.DefaultGuardData == nil then
    local global = cfg_Global_globalManager:TryGetValue(21100002)
    local strS = string.split(global.effect, "&")
    self.DefaultGuardData = {}
    for i, v in pairs(strS) do
      local temp = string.split(v, "_")
      if #temp == 2 then
        local guardType = 0
        local guard = ClientTable.cfg_Equip_guard_levelManager:TryGetValue(tonumber(temp[1]))
        if guard ~= nil then
          guardType = guard.petType
        end
        local DefaultGuardDataItem = {
          id = tonumber(temp[1]),
          type = guardType,
          condition = temp[2]
        }
        table.insert(self.DefaultGuardData, DefaultGuardDataItem)
      end
    end
  end
  return self.DefaultGuardData
end

function cfg_Global_globalManager:CheckTipsShowStrengthenBtn(itemId)
  local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  if itemTbl == nil then
    return false
  end
  if self.mTipsShowStrengthenBtnItemTypeList == nil then
    local global = cfg_Global_globalManager:TryGetValue(31000001)
    local strTable = string.split(global.effect, "&")
    self.mTipsShowStrengthenBtnItemTypeList = {}
    for k, v in pairs(strTable) do
      local temp = string.split(v, "#")
      if 1 < #temp then
        local tipsShowStrengthenBtnItemInfo = {
          type = tonumber(temp[1]),
          subType = tonumber(temp[2])
        }
        table.insert(self.mTipsShowStrengthenBtnItemTypeList, tipsShowStrengthenBtnItemInfo)
      end
    end
  end
  if type(self.mTipsShowStrengthenBtnItemTypeList) ~= "table" or next(self.mTipsShowStrengthenBtnItemTypeList) == nil then
    return true
  end
  for k, v in pairs(self.mTipsShowStrengthenBtnItemTypeList) do
    if itemTbl.type == v.type and itemTbl.subType == v.subType then
      return false
    end
  end
  return true
end

function cfg_Global_globalManager:GetKillMonsterExpFormatDes(reinLv)
  if self.mKillMonsterExpFormatDesDic == nil then
    self.mKillMonsterExpFormatDesDic = {}
    local global = cfg_Global_globalManager:TryGetValue(50000001)
    local strTable = string.split(global.effect, "#")
    for k, v in pairs(strTable) do
      table.insert(self.mKillMonsterExpFormatDesDic, v)
    end
  end
  if type(reinLv) ~= "number" then
    return
  end
  return self.mKillMonsterExpFormatDesDic[reinLv + 1]
end

function cfg_Global_globalManager:GetRedEquipUpGradeConfig()
  if self.mRedEquipUpGradeConfig == nil then
    self.mRedEquipUpGradeConfig = {}
    local global = cfg_Global_globalManager:TryGetValue(10)
    local strTable = string.split(global.effect, "#")
    if 1 < #strTable then
      table.insert(self.mRedEquipUpGradeConfig, tonumber(strTable[1]))
      local des = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(strTable[2])
      table.insert(self.mRedEquipUpGradeConfig, des)
    end
  end
  if self.mRedEquipUpGradeConfig ~= nil and #self.mRedEquipUpGradeConfig > 1 then
    return self.mRedEquipUpGradeConfig[1], self.mRedEquipUpGradeConfig[2]
  end
end

function cfg_Global_globalManager:CheckHibitAutoDropMapByCurMapId()
  if self.hibitAutoDropMapList == nil then
    self.hibitAutoDropMapList = {}
    local globalTbl = ClientTable.cfg_Global_globalManager:TryGetValue(1180006)
    if globalTbl then
      self.hibitAutoDropMapList = TableParse:SplitStringToIntList(globalTbl.effect, "#")
    end
  end
  for i, v in pairs(self.hibitAutoDropMapList) do
    if v == SceneData.mapId then
      return true
    end
  end
  return false
end

function cfg_Global_globalManager:InitEquipPositionCheckEquipIndexConfig()
  if self.EquipPositionCheckEquipIndexDic ~= nil then
    return self.EquipPositionCheckEquipIndexDic
  end
  self.EquipPositionCheckEquipIndexDic = {}
  local globalTbl = ClientTable.cfg_Global_globalManager:TryGetValue(2140031)
  if globalTbl == nil then
    return
  end
  local configParamsList = string.split(globalTbl.effect, "&")
  for k, v in pairs(configParamsList) do
    local paramsArray = string.split(v, "_")
    if 1 < #paramsArray then
      local replacePositionConfig = {}
      replacePositionConfig.position = paramsArray[1]
      replacePositionConfig.replacePosition = paramsArray[2]
      replacePositionConfig.replacePositionList = table.ToNumber(string.split(replacePositionConfig.replacePosition, "#"))
      self.EquipPositionCheckEquipIndexDic[replacePositionConfig.position] = replacePositionConfig
    end
  end
end

function cfg_Global_globalManager:GetConfigReplacePosition(equipPosition)
  self:InitEquipPositionCheckEquipIndexConfig()
  return self.EquipPositionCheckEquipIndexDic[equipPosition]
end

function cfg_Global_globalManager:GetBuyGuardJumpInfoDic()
  if self.BuyGuardJumpInfoDic == nil then
    self.BuyGuardJumpInfoDic = {}
    local globalTbl = ClientTable.cfg_Global_globalManager:TryGetValue(6030017)
    local strS = string.split(globalTbl.effect, "&")
    for i, v in pairs(strS) do
      local temp = string.split(v, "#")
      if #temp == 2 then
        self.BuyGuardJumpInfoDic[tonumber(temp[1])] = tonumber(temp[2])
      end
    end
  end
  return self.BuyGuardJumpInfoDic
end

function cfg_Global_globalManager:GetNPCShowShopSkillPanlID()
  if self.NPCShowShopSkillPanlID == nil then
    local globalTbl = ClientTable.cfg_Global_globalManager:TryGetValue(14)
    if globalTbl ~= nil then
      self.NPCShowShopSkillPanlID = tonumber(globalTbl.effect)
    end
  end
  return self.NPCShowShopSkillPanlID
end

function cfg_Global_globalManager:GetTransEffectDic()
  if self.mTransEffectDic == nil then
    self.mTransEffectDic = {}
    local globalTbl = ClientTable.cfg_Global_globalManager:TryGetValue(15)
    if globalTbl ~= nil then
      local tbl = TableParse:SplitStringToStrListList(globalTbl.effect, "&", "#")
      for i, v in pairs(tbl) do
        if v and table.count(v) > 2 then
          self.mTransEffectDic[v[1]] = {
            name = v[2],
            scale = tonumber(v[3]) / 100,
            rotation = 360 - tonumber(v[4])
          }
        end
      end
    end
  end
  return self.mTransEffectDic
end

function cfg_Global_globalManager:GetTransEffectData(id)
  if id ~= nil and type(id) == "number" then
    return self:GetTransEffectDic()[tostring(id)]
  end
  return nil
end

function cfg_Global_globalManager:GetBagGroupRefreshCount()
  if self.bagGroupRefreshCount == nil then
    self.bagGroupRefreshCount = self:GetGlobalItemEffect(2070005)
    if string.isNullOrEmpty(self.bagGroupRefreshCount) then
      self.bagGroupRefreshCount = 5
    else
      self.bagGroupRefreshCount = tonumber(self.bagGroupRefreshCount)
    end
  end
  return self.bagGroupRefreshCount
end

function cfg_Global_globalManager:GetMiniMapNeedShowImg_tipTaskIDList()
  if self.MiniMapNeedShowImg_tipTaskIDList == nil then
    self.MiniMapNeedShowImg_tipTaskIDList = {}
    local temp = self:TryGetValue(60000019)
    if temp ~= nil and temp.effect ~= nil then
      local strs = string.split(temp.effect, "#")
      for i, v in pairs(strs) do
        table.insert(self.MiniMapNeedShowImg_tipTaskIDList, tonumber(v))
      end
    end
  end
  return self.MiniMapNeedShowImg_tipTaskIDList
end

function cfg_Global_globalManager:GetBagInfoAsyncRefreshCount()
  local temp = self:TryGetValue(2140033)
  if temp == nil or temp.effect == nil then
    return 20
  end
  return tonumber(temp.effect)
end

function cfg_Global_globalManager:GetGlobal_BianshenInfoDic()
  if self.Global_BianshenInfoDic == nil then
    self.Global_BianshenInfoDic = {}
    local globalTbl = self:TryGetValue(60000021)
    local strS = string.split(globalTbl.effect, "&")
    for i, v in pairs(strS) do
      local temp = string.split(v, "#")
      if #temp == 5 then
        local Global_BianshenInfo = {
          modelID = temp[2],
          size = tonumber(temp[3]),
          equipIndex = tonumber(temp[4]),
          equippath = temp[5]
        }
        self.Global_BianshenInfoDic[tonumber(temp[1])] = Global_BianshenInfo
      end
    end
  end
  return self.Global_BianshenInfoDic
end

function cfg_Global_globalManager:GetGlobal_DaTianShiBianshenBuffIDDic()
  if self.Global_DaTianShiBianshenBuffIDDic == nil then
    self.Global_DaTianShiBianshenBuffIDDic = {}
    local globalTbl = self:TryGetValue(60000025)
    local strS = string.split(globalTbl.effect, "#")
    for i, v in pairs(strS) do
      self.Global_DaTianShiBianshenBuffIDDic[tonumber(v)] = true
    end
  end
  return self.Global_DaTianShiBianshenBuffIDDic
end

function cfg_Global_globalManager:GetGlobal_Boss_wingDesChangeDic()
  if self.Global_Boss_wingDesChangeDic == nil then
    self.Global_Boss_wingDesChangeDic = {}
    local globalTbl = self:TryGetValue(4020008)
    local strS = string.split(globalTbl.effect, "&")
    for i, v in pairs(strS) do
      local temp = string.split(v, "#")
      if #temp == 2 then
        self.Global_Boss_wingDesChangeDic[tonumber(temp[1])] = temp[2]
      end
    end
  end
  return self.Global_Boss_wingDesChangeDic
end

function cfg_Global_globalManager:GetHideReinEffectMapTbl()
  if self.mHideReinEffectMapTbl == nil then
    self.mHideReinEffectMapTbl = {}
    local globalTbl = ClientTable.cfg_Global_globalManager:TryGetValue(6030033)
    if globalTbl then
      self.mHideReinEffectMapTbl = TableParse:SplitStringToIntList(globalTbl.effect, "#")
    end
  end
  return self.mHideReinEffectMapTbl
end

function cfg_Global_globalManager:CheckHideReinEffectByCurMapId()
  for i, v in pairs(self:GetHideReinEffectMapTbl()) do
    if v == SceneData.mapId then
      return true
    end
  end
  return false
end

function cfg_Global_globalManager:GetTaskId()
  if self.taskIdList == nil then
    self.taskIdList = {}
    local temp = ClientTable.cfg_Global_globalManager:TryGetValue(6030032)
    local taskTbl = string.split(temp.effect, "#")
    for i, v in pairs(taskTbl) do
      table.insert(self.taskIdList, tonumber(v))
    end
  end
  return self.taskIdList
end

function cfg_Global_globalManager:GetMasterExChangeTbl()
  if self.mMasterExChangeTbl == nil then
    self.mMasterExChangeTbl = TableParse:SpliteStringToExChangeList(self:GetGlobalItemEffect(30000001), true)
  end
  return self.mMasterExChangeTbl
end

function cfg_Global_globalManager:GetMasterExpPillItemID()
  if self.mMasterExpPillItemId == nil then
    local masterExChangeTbl = self:GetMasterExChangeTbl()
    if masterExChangeTbl and next(masterExChangeTbl) then
      self.mMasterExpPillItemId = masterExChangeTbl[1].masterExpPillItemId or 3003001
    else
      self.mMasterExpPillItemId = 3003001
    end
  end
  return self.mMasterExpPillItemId
end

function cfg_Global_globalManager:GetBaseMasterExChangeTbl()
  return TableParse:SpliteStringToExChangeList(self:GetGlobalItemEffect(30000001), true)
end

function cfg_Global_globalManager:GetMasterResetConsumTbl()
  if self.mMasterResetConsumTbl == nil then
    self.mMasterResetConsumTbl = TableParse:SpliteStringToItemCountList(self:GetGlobalItemEffect(30000004))
  end
  return self.mMasterResetConsumTbl
end

function cfg_Global_globalManager:GetMasterSwitchConsumTbl()
  if self.masterSwitchConsumTbl == nil then
    self.masterSwitchConsumTbl = TableParse:SpliteStringToItemCountList(self:GetGlobalItemEffect(30000003))
  end
  return self.masterSwitchConsumTbl
end

function cfg_Global_globalManager:GetWarnTipConsum()
  if self.mWarnTipConsumTbl == nil then
    self.mWarnTipConsumTbl = TableParse:SpliteStringToItemCountList(self:GetGlobalItemEffect(2550008))
  end
  return self.mWarnTipConsumTbl[1]
end

function cfg_Global_globalManager:GetTipsModelOffsetHeight(itemId)
  if self.mTipsModelOffsetHeightDic == nil then
    self.mTipsModelOffsetHeightDic = {}
    local tbl = TableParse:SplitStringToIntListList(self:GetGlobalItemEffect(4020018), "&", "#")
    if tbl then
      local offset, count = 0, 0
      for i, itemList in pairs(tbl) do
        count = table.count(itemList)
        if 1 < count then
          offset = itemList[1]
          for i = 2, count do
            self.mTipsModelOffsetHeightDic[itemList[i]] = offset
          end
        end
      end
    end
  end
  return self.mTipsModelOffsetHeightDic[itemId] or 0
end

function cfg_Global_globalManager:IsSpecialActiveEffect(name)
  if self.SpecialActiveEffectList == nil then
    self.SpecialActiveEffectList = {}
    local temp = ClientTable.cfg_Global_globalManager:TryGetValue(19)
    local Specialeffect = string.split(temp.effect, "#")
    for i, v in pairs(Specialeffect) do
      self.SpecialActiveEffectList[v] = true
    end
  end
  if self.SpecialActiveEffectList[name] == nil then
    return false
  end
  return self.SpecialActiveEffectList[name]
end

function cfg_Global_globalManager:GetKaLunTeBoxSpriteName(subType)
  if self.mKaLunTeBoxSpriteNameTbl == nil then
    self.mKaLunTeBoxSpriteNameTbl = {}
    local tbl = TableParse:SplitStringToStrListList(self:GetGlobalItemEffect(20), "&", "#")
    for i, v in pairs(tbl) do
      if table.count(v) > 1 then
        self.mKaLunTeBoxSpriteNameTbl[tonumber(v[1])] = v[2]
      end
    end
  end
  return self.mKaLunTeBoxSpriteNameTbl[subType]
end

function cfg_Global_globalManager:GlobalIdDicByCareer()
  if self.mGlobalIdDicByCareer == nil then
    self:InitEquipSpriteBg()
  end
  return self.mGlobalIdDicByCareer
end

function cfg_Global_globalManager:SpriteBgGroupDicByGlobalId()
  if self.mSpriteBgGroupDicByGlobalId == nil then
    self:InitEquipSpriteBg()
  end
  return self.mSpriteBgGroupDicByGlobalId
end

function cfg_Global_globalManager:InitEquipSpriteBg()
  self.mGlobalIdDicByCareer = {}
  self.mSpriteBgGroupDicByGlobalId = {}
  local globalTbl = TableParse:SplitStringToIntListList(self:GetGlobalItemEffect(2500011), "&", "#")
  local spriteTbl
  for i, v in pairs(globalTbl) do
    if table.count(v) > 1 then
      self.mGlobalIdDicByCareer[tonumber(v[1])] = v[2]
      spriteTbl = TableParse:SplitStringToStrListList(self:GetGlobalItemEffect(v[2]), "&", "#")
      local result = {}
      for i2, v2 in pairs(spriteTbl) do
        if table.count(v2) > 1 then
          result[v2[1]] = v2[2]
        end
      end
      self:SpriteBgGroupDicByGlobalId()[v[2]] = result
    end
  end
end

function cfg_Global_globalManager:GetMainPlayerEquipBgSpiteByCellIndex(cellIndex)
  return self:GetEquipBgSpiteByCellIndex(cellIndex, RoleManager.me.career)
end

function cfg_Global_globalManager:GetEquipBgSpiteByCellIndex(cellIndex, career)
  local basicCareer = career and RoleUtility.GetBasicCareer(career) or 0
  local globalId = self:GlobalIdDicByCareer()[basicCareer] or self:GlobalIdDicByCareer()[0]
  if globalId == nil then
    return
  end
  local bgTbl = self:SpriteBgGroupDicByGlobalId()[globalId]
  if bgTbl == nil or table.count(bgTbl) == 0 then
    return
  end
  local bg = bgTbl[tostring(cellIndex)]
  if bg == nil then
    local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(cellIndex)
    local basicIndex = cellTbl and cellTbl.basicPosition ~= 0 and cellTbl.basicPosition or cellIndex % 100
    bg = bgTbl[tostring(basicIndex)]
  end
  return bg
end

function cfg_Global_globalManager:GetSpellSwordGiftDiscountDic(giftId)
  if self.mSpellSwordGiftDiscountDic == nil then
    self.mSpellSwordGiftDiscountDic = {}
    local temp = self:TryGetValue(5000111)
    if temp.effect then
      local str = string.split(temp.effect, "&")
      for i, v in ipairs(str) do
        local discountStr = string.split(v, "#")
        if 3 <= #discountStr then
          local subType = tonumber(discountStr[1])
          local discount = tonumber(discountStr[2])
          local spriteName = discountStr[3]
          self.mSpellSwordGiftDiscountDic[subType] = {discount = discount, spriteName = spriteName}
        end
      end
    end
  end
  return self.mSpellSwordGiftDiscountDic
end

function cfg_Global_globalManager:GetSpellSwordGiftDiscountBySubType(subType)
  local giftDiscount = self:GetSpellSwordGiftDiscountDic()[subType]
  if giftDiscount then
    return giftDiscount.discount
  end
  logError("Kh\195\180ng c\195\179 Qu\195\160 cho lo\225\186\161i Ma Ki\225\186\191m S\196\169 n\195\160y")
  return 1
end

function cfg_Global_globalManager:GetSpellSwordGiftSpriteNameBySubType(subType)
  local giftDiscount = self:GetSpellSwordGiftDiscountDic()[subType]
  if giftDiscount then
    return giftDiscount.spriteName
  end
  logError("Kh\195\180ng c\195\179 Qu\195\160 cho lo\225\186\161i Ma Ki\225\186\191m S\196\169 n\195\160y")
  return "SS01ZHE"
end

function cfg_Global_globalManager:GetTransferInfoDic()
  if self.mTransferInfoDic == nil then
    self.mTransferInfoDic = {}
    local temp = self:TryGetValue(22)
    if temp and temp.effect then
      local transferGroup = string.split(temp.effect, "&")
      for i, v in ipairs(transferGroup) do
        local transferInfo = string.split(v, "#")
        if table.count(transferInfo) >= 3 then
          local type = tonumber(transferInfo[1])
          self.mTransferInfoDic[type] = {
            titleSprite = transferInfo[2],
            equipTip = transferInfo[3]
          }
        end
      end
    end
  end
  return self.mTransferInfoDic
end

function cfg_Global_globalManager:MoveSpeedChangeBuffSubTypeDic()
  if self.mMoveSpeedChangeBuffSubTypeDic == nil then
    self.mMoveSpeedChangeBuffSubTypeDic = {}
    local tbl = TableParse:SplitStringToIntList(self:GetGlobalItemEffect(2800001), "#")
    for i, v in pairs(tbl) do
      self.mMoveSpeedChangeBuffSubTypeDic[v] = true
    end
  end
  return self.mMoveSpeedChangeBuffSubTypeDic
end

function cfg_Global_globalManager:CheckIsChangeMoveSpeedBuffBySubType(subType)
  return self:MoveSpeedChangeBuffSubTypeDic()[subType] or false
end

function cfg_Global_globalManager:GetCoalitionKickPlayerConfigNum()
  if self.mCoalitionKickPlayerConfigNum == nil then
    self.mCoalitionKickPlayerConfigNum = 1
    local tbl = self:TryGetValue(16010007)
    if tbl ~= nil then
      self.mCoalitionKickPlayerConfigNum = tonumber(tbl.effect)
    end
  end
  return self.mCoalitionKickPlayerConfigNum
end

function cfg_Global_globalManager:GetMapShowMonsterTypeList()
  if self.mBossTypeList == nil then
    self.mBossTypeList = {}
    local tbl = self:TryGetValue(3000002)
    if tbl == nil then
      return
    end
    local typeList = string.split(tbl.effect, "#")
    for i = 1, table.count(typeList) do
      table.insert(self.mBossTypeList, tonumber(typeList[i]))
    end
  end
  return self.mBossTypeList
end

function cfg_Global_globalManager:GetSuitEffectDic()
  if self.mSuitEffectDic == nil then
    self.mSuitEffectDic = {}
    local effect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(16)
    if not string.isNullOrEmpty(effect) then
      local effectArray = string.split(effect, "&")
      for i = 1, #effectArray do
        local infoArray = string.split(effectArray[i], "#")
        if 4 <= #infoArray then
          local cellType = tonumber(infoArray[1])
          self.mSuitEffectDic[cellType] = {
            iconName = infoArray[2],
            selectIconName = infoArray[3],
            suitName = infoArray[4]
          }
        end
      end
    end
  end
  return self.mSuitEffectDic
end

function cfg_Global_globalManager:GetSuitEffectDataByCellType(suitType)
  if suitType == nil then
    return nil
  end
  local effectData = self:GetSuitEffectDic()[suitType]
  if effectData ~= nil then
    return effectData
  else
    return nil
  end
end

function cfg_Global_globalManager:GetCombineHolyRingBagFilterNum()
  if self.combineHolyRingBagFilterNum == nil then
    local dic = self:TryGetValue(60000036)
    local effect = dic and dic.effect or ""
    self.combineHolyRingBagFilterNum = string.isNullOrEmpty(effect) and 3 or tonumber(effect)
  end
  return self.combineHolyRingBagFilterNum or 3
end

function cfg_Global_globalManager:SuitExcellenceAtrShieldDic()
  if self.mSuitExcellenceAtrShieldDic == nil then
    self.mSuitExcellenceAtrShieldDic = {}
    local tbl = TableParse:SplitStringToIntList(self:GetGlobalItemEffect(40), "#")
    for i, v in pairs(tbl) do
      self.mSuitExcellenceAtrShieldDic[v] = 1
    end
  end
  return self.mSuitExcellenceAtrShieldDic
end

function cfg_Global_globalManager:IsShieldSuitExcellenceAtrByBagIndex(bagIndex)
  if bagIndex == nil or type(bagIndex) ~= "number" then
    return false
  end
  local tbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagIndex)
  if tbl then
    return self:IsShieldSuitExcellenceAtrByCellType(tbl.cellType)
  end
end

function cfg_Global_globalManager:IsShieldSuitExcellenceAtrByCellType(cellType)
  if cellType == nil or type(cellType) ~= "number" then
    return false
  end
  return self:SuitExcellenceAtrShieldDic() ~= nil and self:SuitExcellenceAtrShieldDic()[cellType]
end

function cfg_Global_globalManager:SuitSpecialExcellenceAtrDic()
  if self.mSuitSpecialExcellenceAtrDic == nil then
    self.mSuitSpecialExcellenceAtrDic = {}
    local tbl = TableParse:SplitStringToIntList(self:GetGlobalItemEffect(41), "#")
    for i, v in pairs(tbl) do
      self.mSuitSpecialExcellenceAtrDic[v] = 1
    end
  end
  return self.mSuitSpecialExcellenceAtrDic
end

function cfg_Global_globalManager:IsShowSuitSpecialEAtrByItemInfo(itemInfo)
  if itemInfo.tblEquip == nil then
    return false
  end
  local bagIndex = string.split(itemInfo.tblEquip.equipPosition, "#")[1]
  return self:IsShowSuitSpecialEAtrByBagIndex(tonumber(bagIndex))
end

function cfg_Global_globalManager:IsShowSuitSpecialEAtrByBagIndex(bagIndex)
  if bagIndex == nil or type(bagIndex) ~= "number" then
    return false
  end
  local tbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagIndex)
  if tbl then
    return self:IsShowSuitSpecialEAtrBySuitCellType(tbl.cellType)
  end
end

function cfg_Global_globalManager:IsShowSuitSpecialEAtrBySuitCellType(cellType)
  if cellType == nil or type(cellType) ~= "number" then
    return false
  end
  return self:SuitSpecialExcellenceAtrDic() ~= nil and self:SuitSpecialExcellenceAtrDic()[cellType]
end

function cfg_Global_globalManager:GetCouturJsonGloble(id)
  local CouturJsonGlobleList = {}
  local dic = self:TryGetValue(id)
  local strS = string.split(dic and dic.effect or "", "&")
  for i, v in pairs(strS) do
    local tempS = string.split(v, "#")
    if #tempS == 2 then
      local info = {
        name = tempS[1],
        index = tempS[2]
      }
      CouturJsonGlobleList[tempS[1]] = tonumber(tempS[2])
    end
  end
  return CouturJsonGlobleList
end

function cfg_Global_globalManager:GetCouturSubtypeDic()
  if self.CouturSubtypeDic == nil then
    self.CouturSubtypeDic = {}
    local dic = self:TryGetValue(2800009)
    local strS = string.split(dic and dic.effect or "", "&")
    for i, v in pairs(strS) do
      local tempS = string.split(v, "#")
      if #tempS == 2 then
        self.CouturSubtypeDic[tonumber(tempS[1])] = tonumber(tempS[2])
      end
    end
  end
  return self.CouturSubtypeDic
end

function cfg_Global_globalManager:GetSchoolModelList()
  if self.mSchoolModelList == nil then
    self.mSchoolModelList = TableParse:SplitStringToStrListList(self:GetGlobalItemEffect(2800016), "&", "#")
  end
  return self.mSchoolModelList
end

function cfg_Global_globalManager:BagSellSelectConfigDic()
  if self.mBagSellSelectConfigDic == nil then
    self.mBagSellSelectConfigDic = {}
    local tbl = TableParse:SplitStringToIntListList(self:GetGlobalItemEffect(101), "&", "#")
    for i, v in pairs(tbl) do
      if table.count(v) > 0 then
        self.mBagSellSelectConfigDic[v[1]] = v
        table.remove(self.mBagSellSelectConfigDic[v[1]], 1)
      end
    end
  end
  return self.mBagSellSelectConfigDic
end

function cfg_Global_globalManager:BagSellUnSelectConfigDic()
  if self.mBagSellUnSelectConfigDic == nil then
    self.mBagSellUnSelectConfigDic = {}
    local tbl = TableParse:SplitStringToIntListList(self:GetGlobalItemEffect(102), "&", "#")
    for i, v in pairs(tbl) do
      if table.count(v) > 0 then
        self.mBagSellUnSelectConfigDic[v[1]] = v
        table.remove(self.mBagSellUnSelectConfigDic[v[1]], 1)
      end
    end
  end
  return self.mBagSellUnSelectConfigDic
end

function cfg_Global_globalManager:GetBagSellSelectRuleByCareerCategory(careerCategory)
  return self:BagSellSelectConfigDic()[careerCategory], self:BagSellUnSelectConfigDic()[careerCategory]
end

function cfg_Global_globalManager:GetBossExpTotalTime()
  if self.mKillBossTotalTime == nil then
    self.mKillBossTotalTime = 1 / tonumber(self:TryGetValue(60000039).effect)
  end
  return self.mKillBossTotalTime
end

function cfg_Global_globalManager:GetMemberNaviPos()
  if self.memberNaviPos == nil then
    self.memberNaviPos = tonumber(self:GetGlobalItemEffect(31))
  end
  return self.memberNaviPos
end

function cfg_Global_globalManager:GetQuickBuyRefreshType()
  if self.quickBuyRefreshTypeList == nil then
    self.quickBuyRefreshTypeList = table.ToNumber(string.split(self:GetGlobalItemEffect(202), "#"))
  end
  return self.quickBuyRefreshTypeList
end

function cfg_Global_globalManager:AllNeedShowItemTipUIRuleList()
  if self.mAllNeedShowItemTipUIList == nil then
    self.mAllNeedShowItemTipUIList = {}
    self.mAllNeedShowItemTipUIList = TableParse:SplitStringToStrList(201, "#")
  end
  return self.mAllNeedShowItemTipUIList
end

function cfg_Global_globalManager:CheckShowItemTipsByUIVisible()
  if not UIManager.IsVisible(UIID.NewBagInfoUI) then
    return false
  end
  local bagUI = UIManager.GetUiByName(UIID.NewBagInfoUI)
  for i, v in pairs(self:AllNeedShowItemTipUIRuleList()) do
    if UIManager.IsVisibleOrCorrelation(UIID.BagSellInfoUI, bagUI) then
      return true
    end
  end
  return false
end

function cfg_Global_globalManager:GetSceneBoneDic(mapId)
  local global = self:TryGetValue(2800018).effect
  local globalString = string.split(global, "#")
  for i, v in pairs(globalString) do
    if tonumber(v) == mapId then
      return true
    end
  end
  return false
end

function cfg_Global_globalManager:HideAppearanceMapIdList()
  if self.mHideAppearanceMapIdList == nil then
    self.mHideAppearanceMapIdList = {}
    self.mHideAppearanceMapIdList = TableParse:SplitStringToIntList(self:GetGlobalItemEffect(301), "#")
  end
  return self.mHideAppearanceMapIdList
end

function cfg_Global_globalManager:CheckHideAppearanceByMapId(mapId)
  return table.contains(self:HideAppearanceMapIdList(), mapId)
end

function cfg_Global_globalManager:CheckHideAppearanceByCurMap()
  return self:CheckHideAppearanceByMapId(SceneData.mapId)
end

function cfg_Global_globalManager:GetRankBuffSpriteName(buffId)
  if self.mRankBuffSpriteNameTbl == nil then
    self.mRankBuffSpriteNameTbl = {}
    local tbl = TableParse:SplitStringToStrListList(self:GetGlobalItemEffect(5501001), "/", "#")
    for i, v in pairs(tbl) do
      if table.count(v) > 1 then
        self.mRankBuffSpriteNameTbl[tonumber(v[1])] = v[2]
      end
    end
  end
  return self.mRankBuffSpriteNameTbl[buffId]
end

function cfg_Global_globalManager:GetUINameCheckResisue(uiname)
  if not uiname then
    return false
  end
  if self.mUINameListTbl == nil then
    self.mUINameListTbl = {}
    local tables = self:TryGetValue(63000004)
    if tables and tables.effect then
      local strs = string.split(tables.effect, "#")
      for i = 1, #strs do
        table.insert(self.mUINameListTbl, strs[i])
      end
    end
  end
  if self.mUINameListTbl then
    for i = 1, #self.mUINameListTbl do
      if self.mUINameListTbl[i] == uiname then
        return true
      end
    end
  end
  return false
end

function cfg_Global_globalManager:GetMapidCheckResisue(mapid)
  if not mapid then
    return
  end
  if self.mMapIdKoreaListTbl == nil then
    self.mMapIdKoreaListTbl = {}
    local tables = self:TryGetValue(63000003)
    if tables and tables.effect then
      local strs = string.split(tables.effect, "#")
      for i = 1, #strs do
        table.insert(self.mMapIdKoreaListTbl, strs[i])
      end
    end
  end
  if self.mMapIdKoreaListTbl then
    for i = 1, #self.mMapIdKoreaListTbl do
      if self.mMapIdKoreaListTbl[i] == mapid then
        return true
      end
    end
  end
  return false
end

function cfg_Global_globalManager:IsNeedShowTipBossCount(itemID)
  if self.m_NeedShowTipBossCount == nil then
    self.m_NeedShowTipBossCount = {}
    local tblData = self:TryGetValue(60000041)
    if tblData == nil then
      return false
    end
    local global = tblData.effect
    local globalString = string.split(global, "#")
    for i, v in pairs(globalString) do
      self.m_NeedShowTipBossCount[tonumber(v)] = true
    end
  end
  if self.m_NeedShowTipBossCount[itemID] == nil then
    return false
  end
  return true
end

function cfg_Global_globalManager:GetDownLoadGiftId()
  if self.mDownLoadGiftId then
    return self.mDownLoadGiftId
  end
  local effect = self:GetGlobalItemEffect(2430021)
  self.mDownLoadGiftId = string.isNullOrEmpty(effect) and 0 or tonumber(effect)
  return self.mDownLoadGiftId
end

return cfg_Global_globalManager
