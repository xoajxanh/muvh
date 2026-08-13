PlayerControlForceData = {}
local this = PlayerControlForceData
PlayerControlForceData.sellJumpParam = {}
PlayerControlForceData.sellVipOpenParam = {}
PlayerControlForceData.storageJumpParam = {}
PlayerControlForceData.storageVipOpenParam = {}
PlayerControlForceData.shopJumpParam = {}
PlayerControlForceData.shopVipOpenParam = {}
PlayerControlForceData.composeOpenCondition = {}
PlayerControlForceData.composeJumpParam = {}
PlayerControlForceData.composeOpenParam = {}
PlayerControlForceData.AUTO_BUY_DRUG = "autoBuyDrugs"
PlayerControlForceData.AUTO_BUY_DRUG_EFFECT = "autoBuyDrugEffect"
PlayerControlForceData.autoBuyDrugOpenParam = {}
PlayerControlForceData.autoBuyDrugState = false
PlayerControlForceData.PROMPT_BUY_DRUG = "PromptBuyDrugs"
PlayerControlForceData.PromptBuyDrugsShow = false
PlayerControlForceData.PromptBuyDrugsId = 0
PlayerControlForceData.PromptBuyDrugsCount = 0
PlayerControlForceData.PromptBuyDrugslevel = 0
PlayerControlForceData.PromptBuyDrugsAllCount = 0
PlayerControlForceData.PromptBuyDrugsTime = 10
PlayerControlForceData.AUTO_RECYCLE = "autoRecycle"
PlayerControlForceData.AUTO_RECYCLE_EFFECT = "autoRecycleEffect"
PlayerControlForceData.autoRecycleOpenParam = {}
PlayerControlForceData.autoRecycleState = false
PlayerControlForceData.RECYCLE_CONFIG = "RECYCLE_CONFIG"
PlayerControlForceData.autoPickupState = false
PlayerControlForceData.AUTO_PICKUP = "autoPickup"
PlayerControlForceData.autoPickupOpenParam = {}
PlayerControlForceData.monthcardmaturitOpenParam = {}
PlayerControlForceData.RedemJumpParam = {}
PlayerControlForceData.bingJianOpenState = {}
PlayerControlForceData.exchangeOpenState = false

function PlayerControlForceData.Init()
  this.sellJumpParam = ParseUtility.ParseId(GlobalConfig.sellJump)
  this.sellVipOpenParam = ParseUtility.ParseUIParam(GlobalConfig.sellVipOpen)
  this.storageJumpParam = ParseUtility.ParseId(GlobalConfig.storageJump)
  this.storageVipOpenParam = ParseUtility.CuttingParam(GlobalConfig.storageVipOpen)
  this.shopJumpParam = ParseUtility.ParseId(GlobalConfig.shopJump)
  this.shopVipOpenParam = ParseUtility.CuttingParam(GlobalConfig.shopVipOpen)
  this.composeOpenCondition = ParseUtility.ParseId(GlobalConfig.composeCondition)
  this.composeJumpParam = ParseUtility.ParseId(GlobalConfig.composeJump)
  this.composeOpenParam = ParseUtility.ParseUIParam(GlobalConfig.composeOpen)
  this.autoBuyDrugOpenParam = ParseUtility.CuttingParam(GlobalConfig.autoBuyDrugOpenParam)
  this.autoRecycleOpenParam = ParseUtility.CuttingParam(GlobalConfig.autoRecycleOpenParam)
  this.autoPickupOpenParam = ParseUtility.CuttingParam(GlobalConfig.autoPickupOpenParam)
  this.monthcardmaturitOpenParam = ParseUtility.CuttingParam(GlobalConfig.monthcardmaturitOpenParam)
  this.RedemJumpParam = ParseUtility.ParseId(GlobalConfig.RedemJump)
  local PromptBuyDrugsTbl = string.split(GlobalConfig.PromptBuyDrugsAllCount, "&")
  this.PromptBuyDrugsAllCount = tonumber(PromptBuyDrugsTbl[2])
  this.PromptBuyDrugsTime = tonumber(PromptBuyDrugsTbl[1]) / 1000
  this.PromptBuyDrugsGlobal = ParseUtility.ParseId(GlobalConfig.Redemlevel)
  this.eventContainer = EventContainer(EventManager)
  this.RegisterEvents()
end

function PlayerControlForceData.RegisterEvents()
  this.eventContainer:Regist(Event.MemberLevelChanged, this.VvipinfoChangeDrug)
  this.eventContainer:Regist(Event.TemporaryMemberLevelChanged, this.VvipinfoChangeDrug)
end

function PlayerControlForceData.BagSellIsOpen()
  local openDir = true
  if not string.isNullOrEmpty(GlobalConfig.recycleCondition) then
    openDir = ConditionManager.Check4D(GlobalConfig.recycleCondition)
  end
  return openDir
end

function PlayerControlForceData.BagShopIsOpen()
  local openDir = false
  if not string.isNullOrEmpty(GlobalConfig.shopCondition) then
    openDir = ConditionManager.Check4D(GlobalConfig.shopCondition)
  end
  return openDir
end

function PlayerControlForceData.ComposeIsOpen()
  local openDir = false
  if table.count(PlayerControlForceData.composeOpenCondition) > 0 then
    for _, id in ipairs(PlayerControlForceData.composeOpenCondition) do
      if ViewData.meData.equipsData:CheckPrivilegeInfor(id) then
        openDir = true
      end
    end
  end
  return openDir
end

function PlayerControlForceData.StorageIsOpen()
  local openDir = true
  if not string.isNullOrEmpty(GlobalConfig.storageCondition) then
    openDir = ConditionManager.Check4D(GlobalConfig.storageCondition)
  end
  return openDir
end

function PlayerControlForceData.AutoBuyDrug()
  local openDir = false
  if not string.isNullOrEmpty(GlobalConfig.autoBuyDrugOpen) then
    openDir = ConditionManager.Check4D(GlobalConfig.autoBuyDrugOpen)
  end
  return openDir
end

function PlayerControlForceData.AutoRecycle()
  local openDir = false
  if not string.isNullOrEmpty(GlobalConfig.autoRecycleOpen) then
    openDir = ConditionManager.Check4D(GlobalConfig.autoRecycleOpen)
  end
  return openDir
end

function PlayerControlForceData.AutoPickup()
  local openDir = false
  if not string.isNullOrEmpty(GlobalConfig.autoPickupOpen) then
    openDir = ConditionManager.Check4D(GlobalConfig.autoPickupOpen)
  end
  return openDir
end

function PlayerControlForceData.GetAutoBuyDrugKey()
  return string.format("%s%s", this.AUTO_BUY_DRUG, tostring(LoginData.roleId))
end

function PlayerControlForceData.RefreshAutoBuyDrugState()
  local a = ServerDataRecordData.GetIntRecordData(SerRecordIntType.autoBuyDrugOpen)
  local flag = a and a == 1 and true or false
  this.autoBuyDrugState = flag
end

function PlayerControlForceData.SetAutoBuyDrugState(flag)
  if this.autoBuyDrugState == flag then
    return
  end
  this.autoBuyDrugState = flag
  local a = flag and 1 or 0
  ServerDataRecordData.IntDataChange(SerRecordIntType.autoBuyDrugOpen, a)
  ServerDataRecordData.SendSaveData({
    dataInt = {
      [SerRecordIntType.autoBuyDrugOpen] = a
    }
  })
end

function PlayerControlForceData.GetPromptBuyDrugKey()
  return string.format("%s%s", this.PROMPT_BUY_DRUG, tostring(LoginData.roleId))
end

function PlayerControlForceData.ComparePromptBuyDrugState(Drugid)
  if ViewData.meData.level < this.PromptBuyDrugsGlobal[2] then
    return
  end
  if not this.PromptBuyDrugsShow and Drugid ~= this.PromptBuyDrugsId and this.PromptBuyDrugsCount < this.PromptBuyDrugsAllCount and this.PromptBuyDrugslevel ~= ViewData.meData.level then
    EventManager.Dispatch(Event.PromptBuyDrug, Drugid)
  end
end

function PlayerControlForceData.SetStringPromptBuyDrug(Drugid)
  this.PromptBuyDrugsCount = this.PromptBuyDrugsCount + 1
  this.PromptBuyDrugslevel = ViewData.meData.level
  local a = string.format("%s#%s#%s", this.PromptBuyDrugsId, this.PromptBuyDrugsCount, ViewData.meData.level)
  PlayerPrefs.SetString(this.GetPromptBuyDrugKey(), a)
end

function PlayerControlForceData.InitPromptBuyDrugState(nextday)
  local a = PlayerPrefs.GetString(this.GetPromptBuyDrugKey(), "")
  if #ShopData.shopShowTbl == 0 or nextday then
    ShopData.GetPortableShopInfo()
  end
  for i, v in pairs(ShopData.shopShowTbl) do
    local Drug = tonumber(string.split(v.reward, "#")[1])
    if SkillSettingData.hpPriorityId[Drug] then
      this.PromptBuyDrugsId = Drug
      break
    end
  end
  if string.isNullOrEmpty(a) then
    this.PromptBuyDrugsCount = 0
    this.PromptBuyDrugslevel = ViewData.meData.level
    a = string.format("%s#%s#%s", this.PromptBuyDrugsId, 0, ViewData.meData.level)
    PlayerPrefs.SetString(this.GetPromptBuyDrugKey(), a)
  else
    local infos = string.split(a, "#")
    if this.PromptBuyDrugsId == tonumber(infos[1]) then
      this.PromptBuyDrugsCount = tonumber(infos[2])
      this.PromptBuyDrugslevel = tonumber(infos[3])
    else
      this.PromptBuyDrugsCount = 0
      this.PromptBuyDrugslevel = ViewData.meData.level
    end
  end
end

function PlayerControlForceData.GetRecycleConfigKey()
  return string.format("%s%s", this.RECYCLE_CONFIG, tostring(LoginData.roleId))
end

function PlayerControlForceData.InitAutoRecycleConfig()
  local str = PlayerPrefs.GetString(this.GetRecycleConfigKey(), "{}")
  BagSellController.InitCurrRecycleTogConfig(json.decode(str))
end

function PlayerControlForceData.GetAutoRecycleKey()
  return string.format("%s%s", this.AUTO_RECYCLE, tostring(LoginData.roleId))
end

function PlayerControlForceData.RefreshAutoRecycleState()
  local a = ServerDataRecordData.GetIntRecordData(SerRecordIntType.autoRecycleOpen)
  local flag = a and a == 1 and true or false
  this.autoRecycleState = flag
  this.InitAutoRecycleConfig()
end

function PlayerControlForceData.SetAutoRecycleState(flag)
  if this.autoRecycleState == flag then
    return
  end
  this.autoRecycleState = flag
  local a = flag and 1 or 0
  ServerDataRecordData.IntDataChange(SerRecordIntType.autoRecycleOpen, a)
  ServerDataRecordData.SendSaveData({
    dataInt = {
      [SerRecordIntType.autoRecycleOpen] = a
    }
  })
end

function PlayerControlForceData.GetAutoPickupKey()
  return string.format("%s%s", this.AUTO_PICKUP, tostring(LoginData.roleId))
end

function PlayerControlForceData.RefreshAutoPickupState()
  local a = ServerDataRecordData.GetIntRecordData(SerRecordIntType.autoPickupOpen)
  local flag = a and a == 1 and true or false
  flag = flag and PlayerControlForceData.AutoPickup()
  this.autoPickupState = flag
end

function PlayerControlForceData.RefreshArchangeOpenState()
  local curState = ServerDataRecordData.GetIntRecordData(SerRecordIntType.ArchangeOpen) == 1
  if this.archangeOpenState ~= curState then
    this.archangeOpenState = curState
    EventManager.Dispatch(Event.Fuc_SingleRefresh, {
      FunctionSystemEnumId.BingJian
    })
  end
end

function PlayerControlForceData.RefreshSuitOpenState()
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():RefreshSuitTypeState()
end

function PlayerControlForceData.IsShowBingjian()
  local isShow = false
  for i, v in pairs(this.bingJianOpenState) do
    if this.bingJianOpenState[i] == true then
      isShow = true
      break
    end
  end
  return isShow
end

function PlayerControlForceData.RefreshExchangeOpenState()
  local state = ServerDataRecordData.GetIntRecordData(SerRecordIntType.exchangeOpen)
  local flag = state and state == 1 and true or false
  this.exchangeOpenState = flag
end

function PlayerControlForceData.SetAutoPickupState(flag)
  flag = flag and PlayerControlForceData.AutoPickup()
  if this.autoPickupState == flag then
    return
  end
  this.autoPickupState = flag
  local a = flag and 1 or 0
  ServerDataRecordData.IntDataChange(SerRecordIntType.autoPickupOpen, a)
  ServerDataRecordData.SendSaveData({
    dataInt = {
      [SerRecordIntType.autoPickupOpen] = a
    }
  })
  EventManager.Dispatch(Event.QiJiHelper_SetAutoPickup)
end

function PlayerControlForceData.VvipinfoChangeDrug()
  if not string.isNullOrEmpty(GlobalConfig.autoBuyDrugOpen) then
    local openDir = ConditionManager.Check4D(GlobalConfig.autoBuyDrugOpen)
    this.SetAutoBuyDrugState(openDir)
  end
  if not string.isNullOrEmpty(GlobalConfig.autoRecycleOpen) then
    local openDir = ConditionManager.Check4D(GlobalConfig.autoRecycleOpen)
    this.SetAutoRecycleState(openDir)
  end
  if not string.isNullOrEmpty(GlobalConfig.autoPickupOpen) then
    local openDir = ConditionManager.Check4D(GlobalConfig.autoPickupOpen)
    this.SetAutoPickupState(openDir)
  end
end

function PlayerControlForceData.VvipinfoOpen(itemId)
  if not string.isNullOrEmpty(GlobalConfig.autoBuyDrugOpen) then
    local openDir = ConditionManager.Check4D(GlobalConfig.autoBuyDrugOpen)
    this.SetAutoBuyDrugState(openDir)
  end
  if not string.isNullOrEmpty(GlobalConfig.autoPickupOpen) then
    local openDir = ConditionManager.Check4D(GlobalConfig.autoPickupOpen)
    this.SetAutoPickupState(openDir)
  end
  if not string.isNullOrEmpty(GlobalConfig.autoRecycleOpen) then
    local openDir = ConditionManager.Check4D(GlobalConfig.autoRecycleOpen)
    this.SetAutoRecycleState(openDir)
  end
end
