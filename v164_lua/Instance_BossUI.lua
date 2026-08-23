Instance_BossUI = class(BaseUI)
Instance_BossUI.layer = UILayer.Panel
Instance_BossUI.orderInLayer = 0
Instance_BossUI.hideType = UIHideType.Destroy
Instance_BossUI.hideFunc = UIHideFunc.Deactive
Instance_BossUI.escClose = UIEscClose.DontClose
Instance_BossUI.IsOpenText = false

function Instance_BossUI:InitControls()
  self.btnClose = self:GetControl("img_Bg2/btnClose")
  self.goldBossPanel = self:GetControl("goldBossPanel")
  self.ContentGold = self:GetControl("goldBossPanel/levelScroll/Viewport/ContentGold")
  self.levelGoldBtnItem = self:GetControl("goldBossPanel/levelScroll/Viewport/ContentGold/levelGoldBtnItem")
  self.goldContent = self:GetControl("goldBossPanel/bossScroll/Viewport/goldContent")
  self.goldBossItem = self:GetControl("goldBossPanel/bossScroll/Viewport/goldContent/goldBossItem")
  self.goldMapItem = self:GetControl("goldBossPanel/bossScroll/Viewport/goldContent/goldBossItem/tog_mapName/posScroll/Viewport/Content/goldMapItem")
  self.goldBossContent = self:GetControl("goldBossPanel/grid_rewardsInfo2/goldBossContent")
  self.btn_gold3DItem = self:GetControl("goldBossPanel/grid_rewardsInfo2/goldBossContent/btn_gold3DItem")
  self.wildBossPanel = self:GetControl("wildBossPanel")
  self.wildContent = self:GetControl("wildBossPanel/levelScroll/Viewport/Content")
  self.wildBossItem = self:GetControl("wildBossPanel/wildBossItem")
  self.go_modelWild = self:GetControl("wildBossPanel/wildBossItem/go_modelWild")
  self.lab_wildBossName = self:GetControl("wildBossPanel/wildBossItem/lab_wildBossName")
  self.Viewport = self:GetControl("wildBossPanel/wildBossItem/tog_mapName/posScroll/Viewport")
  self.top_arrow = self:GetControl("wildBossPanel/wildBossItem/tog_mapName/top_arrow")
  self.down_arrow = self:GetControl("wildBossPanel/wildBossItem/tog_mapName/down_arrow")
  self.ContentWild = self:GetControl("wildBossPanel/wildBossItem/tog_mapName/posScroll/Viewport/ContentWild")
  self.wildMapItem = self:GetControl("wildBossPanel/wildBossItem/tog_mapName/posScroll/Viewport/ContentWild/wildMapItem")
  self.lab_desWild = self:GetControl("wildBossPanel/wildBossItem/des/lab_desWild")
  self.wildBossContent = self:GetControl("wildBossPanel/grid_rewardsInfo2/awardScroll/Viewport/wildBossContent")
  self.btn_wild3DItem = self:GetControl("wildBossPanel/grid_rewardsInfo2/awardScroll/Viewport/wildBossContent/btn_wild3DItem")
  self.levelScroll = self:GetControl("wildBossPanel/levelScroll")
  self.wildBtnItem = self:GetControl("wildBossPanel/wildBtnItem")
  self.privateBossPanel = self:GetControl("privateBossPanel")
  self.tog_bossinfo = self:GetControl("privateBossPanel/clo_bossinfo")
  self.lab_level = self:GetControl("privateBossPanel/clo_bossinfo/tog_bossinfo/lab_openlevel/lab_level")
  self.ScrollView = self:GetControl("privateBossPanel/ScrollView")
  self.go_model = self:GetControl("privateBossPanel/go_model")
  self.lab_countleft = self:GetControl("privateBossPanel/lab_countleft")
  self.lab_countAll = self:GetControl("privateBossPanel/lab_countleft/lab_countAll")
  self.lab_bossname2 = self:GetControl("privateBossPanel/lab_bossname2")
  self.lab_descrpboss = self:GetControl("privateBossPanel/lab_bossname2/lab_descrpboss")
  self.lab_des = self:GetControl("privateBossPanel/lab_bossname2/lab_descrpboss/lab_des")
  self.lab_rewards = self:GetControl("privateBossPanel/lab_bossname2/lab_rewards")
  self.grid_rewardsinfo = self:GetControl("privateBossPanel/lab_bossname2/lab_rewards/grid_rewardsinfo")
  self.btn_3DItem = self:GetControl("privateBossPanel/lab_bossname2/lab_rewards/grid_rewardsinfo/btn_3DItem")
  self.lab_rewardsBelong = self:GetControl("privateBossPanel/lab_bossname2/lab_rewardsBelong")
  self.grid_rewardsinfoBelong = self:GetControl("privateBossPanel/lab_bossname2/lab_rewardsBelong/grid_rewardsinfoBelong")
  self.btn_3DItemBelong = self:GetControl("privateBossPanel/lab_bossname2/lab_rewardsBelong/grid_rewardsinfoBelong/btn_3DItemBelong")
  self.btn_enter = self:GetControl("privateBossPanel/btn_enter")
  self.mapName = self:GetControl("privateBossPanel/mapName")
  self.ContentExcellent = self:GetControl("privateBossPanel/mapName/posScroll/Viewport/ContentExcellent")
  self.excellentMapItem = self:GetControl("privateBossPanel/mapName/posScroll/Viewport/ContentExcellent/excellentMapItem")
  self.tog_tempSecret = self:GetControl("bossBtnGroup/Content/tog_tempSecret")
  self.tog_goldBoss = self:GetControl("bossBtnGroup/Content/tog_goldBoss")
  self.tog_wildBoss = self:GetControl("bossBtnGroup/Content/tog_wildBoss")
  self.tog_brilliantBoss = self:GetControl("bossBtnGroup/Content/tog_brilliantBoss")
  self.tog_privateBoss = self:GetControl("bossBtnGroup/Content/tog_privateBoss")
  self.tog_secretBoss = self:GetControl("bossBtnGroup/Content/tog_secretBoss")
  self.tog_spanBoss = self:GetControl("bossBtnGroup/Content/tog_spanBoss")
  self.tog_angelBoss = self:GetControl("bossBtnGroup/Content/tog_angelBoss")
  self.tog_shengGuBoss = self:GetControl("bossBtnGroup/Content/tog_shengGuBoss")
  self.tog_enchantSmeltBoss = self:GetControl("bossBtnGroup/Content/tog_enchantSmeltBoss")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
  self.plane_top = self:GetControl("plane_top")
  self.onHookPanelObject = self:GetControl("onHookPanel")
  self.lab_timeLeft = self:GetControl("privateBossPanel/lab_timeLeft")
  self.lab_countDown = self:GetControl("privateBossPanel/lab_timeLeft/lab_countDown")
  self.posScroll = self:GetControl("wildBossPanel/wildBossItem/tog_mapName/posScroll")
  self.wildBossPanel_Grid = self:GetControl("wildBossPanel/Grid")
  self.reinBossPanel = self:GetControl("reinBossPanel")
  self.reinMapItem = self:GetControl("reinBossPanel/reinBossItem/tog_mapName/posScroll/Viewport/ContentWild/reinMapItem")
  self.reinBossPanel_Grid = self:GetControl("reinBossPanel/Grid")
  self.lab_reinBossName = self:GetControl("reinBossPanel/reinBossItem/lab_reinBossName")
  self.go_modelRein = self:GetControl("reinBossPanel/reinBossItem/go_modelRein")
  self.reinContent = self:GetControl("reinBossPanel/levelScroll/Viewport/reinContent")
  self.ContentRein = self:GetControl("reinBossPanel/reinBossItem/tog_mapName/posScroll/Viewport/ContentWild")
  self.lab_ReieCountAll = self:GetControl("reinBossPanel/lab_countleft/lab_countAll")
  self.btn_obtain = self:GetControl("reinBossPanel/lab_countleft/btn_obtain")
  self.reinLevelScroll = self:GetControl("reinBossPanel/levelScroll")
  self.levelReinBtnItem = self:GetControl("reinBossPanel/levelReinBtnItem")
  self.kalimaBossPanelNew = self:GetControl("kalimaBossPanel")
  self.levelkalimaBtnItemNew = self:GetControl("kalimaBossPanel/levelScroll/Viewport/kalimaContent/levelkalimaBtnItem")
  self.kaLiMaBtnGold3DItemNew = self:GetControl("kalimaBossPanel/grid_rewardsInfo2/goldBossContent/btn_gold3DItem")
  self.kalimaBossList = self:GetControl("kalimaBossPanel/bossScroll/Viewport/kalimaContent/kalimaBossList")
  self.btn_enter_kalima = self:GetControl("kalimaBossPanel/btn_enter_kalima")
  self.kaLiMaTicketsModel = self:GetControl("kalimaBossPanel/requirements_item_kalima/Model")
  self.lab_num = self:GetControl("kalimaBossPanel/requirements_item_kalima/lab_num")
  self.btn_obtainKaLiMa = self:GetControl("kalimaBossPanel/requirements_item_kalima/btn_obtain")
  self.lab_countAllKaLiMa = self:GetControl("kalimaBossPanel/lab_countleft_kalima/lab_countAll")
  self.descBtnKaLiMa = self:GetControl("kalimaBossPanel/descBtn")
  self.lab_countTime_kalima = self:GetControl("kalimaBossPanel/img_countTime_kalima/lab_countTime_kalima")
  self.PersonkaLiMaBossPanel = self:GetControl("personBossPanel")
  self.go_modelPersonKaLiMa = self:GetControl("personBossPanel/personBossItem/go_modelPerson")
  self.personKaLiMaTicketsModel = self:GetControl("personBossPanel/requirements_item_person/Model")
  self.personKaLiMalab_num = self:GetControl("personBossPanel/requirements_item_person/lab_num")
  self.btn_obtainPersonKaLiMa = self:GetControl("personBossPanel/requirements_item_person/btn_obtain")
  self.personKaLiMaBossPanel_Grid = self:GetControl("personBossPanel/Grid")
  self.lab_personBossName = self:GetControl("personBossPanel/personBossItem/lab_personBossName")
  self.btn_enter_person = self:GetControl("personBossPanel/btn_enter_person")
  self.descBtnPersonKaLiMa = self:GetControl("personBossPanel/descBtn")
  self.personkaLiMaLevelScroll = self:GetControl("personBossPanel/levelScroll")
  self.levelPersonkaLiMaBtnItem = self:GetControl("personBossPanel/levelpersonkaLiMaBtnItem")
  self.angelBossPanel = self:GetControl("AngelBossPanel")
  self.angelMapItem = self:GetControl("AngelBossPanel/angelBossItem/tog_mapName/posScroll/Viewport/ContentAngel/angelMapItem")
  self.angelBossPanel_Grid = self:GetControl("AngelBossPanel/Grid")
  self.lab_angelBossName = self:GetControl("AngelBossPanel/angelBossItem/lab_angelBossName")
  self.go_modelAngel = self:GetControl("AngelBossPanel/angelBossItem/go_modelAngel")
  self.angelContent = self:GetControl("AngelBossPanel/levelScroll/Viewport/Content")
  self.ContentAngel = self:GetControl("AngelBossPanel/angelBossItem/tog_mapName/posScroll/Viewport/ContentAngel")
  self.lab_angelReieCountAll = self:GetControl("AngelBossPanel/lab_countleft/lab_countAll")
  self.btn_angelObtain = self:GetControl("AngelBossPanel/lab_countleft/btn_obtain")
  self.angelLevelScroll = self:GetControl("AngelBossPanel/levelScroll")
  self.levelAngelBtnItem = self:GetControl("AngelBossPanel/levelAngelBtnItem")
  self.angeltop_arrow = self:GetControl("AngelBossPanel/angelBossItem/tog_mapName/top_arrow")
  self.angeldown_arrow = self:GetControl("AngelBossPanel/angelBossItem/tog_mapName/down_arrow")
  self.angelViewport = self:GetControl("AngelBossPanel/angelBossItem/tog_mapName/posScroll/Viewport")
  self.regenerateBossPanel = self:GetControl("RegenerateBossPanel")
  self.regeneratetop_arrow = self:GetControl("RegenerateBossPanel/regenerateBossItem/tog_mapName/top_arrow")
  self.regeneratedown_arrow = self:GetControl("RegenerateBossPanel/regenerateBossItem/tog_mapName/down_arrow")
  self.regenerateViewport = self:GetControl("RegenerateBossPanel/regenerateBossItem/tog_mapName/posScroll/Viewport")
  self.ContentRegenerate = self:GetControl("RegenerateBossPanel/regenerateBossItem/tog_mapName/posScroll/Viewport/ContentRegenerate")
  self.HolySkeletonBossPanel = self:GetControl("HolySkeletonBossPanel")
  self.RunesNewBossPanel = self:GetControl("RunesNewBossPanel")
  self.EnchantSmeltBossPanel = self:GetControl("EnchantSmeltBossPanel")
end

local mapPointTbl = {}
local bossMapTbl = {}
local mapItem

function Instance_BossUI:Init()
  BossData:InitData()
  self.normalTimer = {}
  self.bossTagTimer = {}
  self.LabTime = {}
  self.MyLevelTab = {obj = nil, level = nil}
  self.CurrentTab = {
    obj = nil,
    type = nil,
    level = nil
  }
  self.monsterModel = {}
end

function Instance_BossUI.SetCloneTransActive(name, act)
  local tempTog = BossData:GetTogByName(name)
  if tempTog then
    tempTog.gameObject:SetActive(act)
  end
end

function Instance_BossUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_BossUI:InitUI()
  self:InitContent()
end

function Instance_BossUI:OnShow()
  self:RegistEvents()
  networkRequest.ReqGetBossMapAndCount()
  networkRequest.ReqInstanceCoolDown(1106)
  networkRequest.ReqAncientBossInfo(MonsterBossType.HolySkeletonBoss)
  networkRequest.ReqAncientBossInfo(MonsterBossType.RunesNewBoss)
  networkRequest.ReqBossStateByType(MonsterBossType.secretBoss)
  networkRequest.ReqBossStateByType(MonsterBossType.reinBoss)
  networkRequest.ReqBossStateByType(MonsterBossType.AngelBoss)
  networkRequest.ReqBossStateByType(MonsterBossType.RegenerateBoss)
  networkRequest.ReqAncientBossInfo(MonsterBossType.EnchantSmeltBoss)
  networkRequest.ReqMonsterInfoByTypeAndInstanceType(MonsterType.KaLiMa, {
    KaLiMaMonsterType.boss,
    KaLiMaMonsterType.elite,
    KaLiMaMonsterType.Little
  })
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.pBoss,
    state = true
  })
  self:Refresh()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    BossTogType.wildBossTog,
    BossTogType.privateBossTog,
    BossTogType.goldMonsterTog,
    BossTogType.brilliantMonsterTog,
    BossTogType.secretBossTog,
    BossTogType.spanBossTog,
    BossTogType.OnHookPointTog,
    BossTogType.reinBossTog,
    BossTogType.KaLiMaTog,
    BossTogType.PersonKaLiMaTog,
    BossTogType.AngelBossTog,
    BossTogType.RegenerateBossTog,
    BossTogType.HolySkeletonBossTog,
    BossTogType.RunesNewBossTog,
    BossTogType.EnchantSmeltBossTog
  })
end

function Instance_BossUI:DestroyAllTimer()
  for k, v in pairs(self.normalTimer) do
    Timer.Stop(v)
    self.normalTimer[k] = nil
  end
  self.normalTimer = {}
end

function Instance_BossUI:OnHide()
  self:DestroyAllTimer()
  self.secretSelectIndex = nil
  self.wildSelectIndex = nil
  self.target = nil
end

function Instance_BossUI:OnDestroy()
end

function Instance_BossUI:Update()
  if self.wildBossPanel.gameObject.activeSelf then
    local isshowTop_down, isshowDown_down = self:IsNeedShowTop_down_Arrow(self.Viewport, self.ContentWild)
    if self.isshowTop_down ~= isshowTop_down then
      self.isshowTop_down = isshowTop_down
      if self.top_arrow ~= nil then
        self.top_arrow:SetActive(isshowTop_down)
      end
    end
    if self.isshowDown_down ~= isshowDown_down then
      self.isshowDown_down = isshowDown_down
      if self.down_arrow ~= nil then
        self.down_arrow:SetActive(isshowDown_down)
      end
    end
  end
  if self.angelBossPanel.gameObject.activeSelf then
    local isshowTop_down, isshowDown_down = self:IsNeedShowTop_down_Arrow(self.angelViewport, self.ContentAngel)
    if self.isshowTop_down ~= isshowTop_down then
      self.isshowTop_down = isshowTop_down
      if self.angeltop_arrow ~= nil then
        self.angeltop_arrow:SetActive(isshowTop_down)
      end
    end
    if self.isshowDown_down ~= isshowDown_down then
      self.isshowDown_down = isshowDown_down
      if self.angeldown_arrow ~= nil then
        self.angeldown_arrow:SetActive(isshowDown_down)
      end
    end
  end
  if self.regenerateBossPanel.gameObject.activeSelf then
    local isshowTop_down, isshowDown_down = self:IsNeedShowTop_down_Arrow(self.regenerateViewport, self.ContentRegenerate)
    if self.isshowTop_down ~= isshowTop_down then
      self.isshowTop_down = isshowTop_down
      if self.regeneratetop_arrow ~= nil then
        self.regeneratetop_arrow:SetActive(isshowTop_down)
      end
    end
    if self.isshowDown_down ~= isshowDown_down then
      self.isshowDown_down = isshowDown_down
      if self.regeneratedown_arrow ~= nil then
        self.regeneratedown_arrow:SetActive(isshowDown_down)
      end
    end
  end
end

function Instance_BossUI:RegistUIEvents()
  self.btnClose:SetOnClick(self, self.btnCloseOnClick)
  self.posScroll:SetOnScroll(self, self.ScrollRectOnEndDrag)
  self.btn_obtain:SetOnClick(self, self.btn_obtainOnClick)
  self.descBtnKaLiMa:SetOnClick(self, self.DescBtnRbOnClick)
  self.descBtnPersonKaLiMa:SetOnClick(self, self.DescPersonBtnRbOnClick)
end

function Instance_BossUI:btnCloseOnClick()
  UIManager.Hide(UIID.Instance_BossUI)
end

function Instance_BossUI:btn_obtainOnClick()
  local itemData = ItemUtility.GenerateItemData(4021001)
  self.btn_obtain.itemData = itemData
  self.btn_obtain.itemData.isHide = true
  self.btn_obtain.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Instance_BossUI:DescBtnRbOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_KalimaCastleUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Instance_BossUI:DescPersonBtnRbOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_BossUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Instance_BossUI:RefreshToggleBasic(control)
  local color = control:GetIsOn() and "0xDBE0E0FF" or "0x999999FF"
  control:GetChild("lab_bossSecret"):SetColor(color)
  self.lab_rewardsBelong:SetActive(control:GetIsOn())
end

function Instance_BossUI:OnToggleChanged(id, togType)
  local bossType = BossData:GetBossTypeByTogType(togType)
  local control = BossData:GetTogByType(togType)
  self:RefreshToggleBasic(control)
  if bossType == nil or control == nil or control.transform == nil then
    logError("tabID l\225\187\151i: " .. togType)
    return
  end
  self:HideAllPanel()
  self.PanelManger[bossType]:SetActive(control:GetIsOn())
  if not control:GetIsOn() then
    return
  end
  self:DestroyAllTimer()
  self.selectToggleType = togType
  if togType == BossTogType.wildBossTog then
    self.wildBossTemplate:Refresh(self)
  elseif togType == BossTogType.secretBossTog then
    self.secretBossTemplate:Refresh(self)
  elseif togType == BossTogType.reinBossTog then
    self.reinBossTemplate:Refresh(self)
  elseif togType == BossTogType.KaLiMaTog then
  elseif togType == BossTogType.PersonKaLiMaTog then
  elseif togType == BossTogType.AngelBossTog then
    self.angelBossTemplate:Refresh(self)
  elseif togType == BossTogType.RegenerateBossTog then
    self.regenerateBossTemplate:Refresh(self)
  elseif togType == BossTogType.HolySkeletonBossTog then
    self.holySkeletonBossTemplate:Refresh(self)
  elseif togType == BossTogType.RunesNewBossTog then
    self.runesNewBossTemplate:Refresh(self)
  elseif togType == BossTogType.EnchantSmeltBossTog then
    self.enchantSmeltBossTemplate:Refresh(self)
  end
end

function Instance_BossUI:HideAllPanel()
  for i, v in pairs(self.PanelManger) do
    if v ~= nil then
      v:SetActive(false)
    end
  end
end

function Instance_BossUI:OnToggleChangedKaLiMa()
  local MonsterType = MonsterBossType.KaLiMaBoss
  local levelItem = self.levelKaLiMaBtnItemTemp
  mapItem = self.KaLiMaMonsterTemp
  self:SetMapTabView(MonsterType, levelItem)
  self:RefreShKaLiMaCount(self.lab_countAllKaLiMa, 3020601)
  self:SetKaLiMaBossData(self.MyLevelTab.obj, self.MyLevelTab.level)
end

function Instance_BossUI:OnToggleChangedPersonKaLiMa()
  self:SetDefaultLevelPersonKaLiMaBossIndex()
  self:RefreshPersonKaLiMaTableView(self.personKaLiMaSelectIndex)
end

function Instance_BossUI:SetDefaultLevelPersonKaLiMaBossIndex()
  self.personKaLiMaMonsterBossTblList = MonsterData.FilterSameBossId(MonsterData.GetMonsterBossType(MonsterBossType.PersonKaLiMaBoss, true))
  self.personKaLiMaSelectIndex = ClientTable.cfg_Monster_bossManager:GetRecommendWildIndex(RoleManager.me.level, self.personKaLiMaMonsterBossTblList)
  if self.args ~= nil and self.args.Monsterid ~= nil then
    local selectIndex = ClientTable.cfg_Monster_bossManager:GetArgsIndex(self.personKaLiMaMonsterBossTblList, self.args.Monsterid)
    if selectIndex then
      self.personKaLiMaSelectIndex = selectIndex
    end
  end
end

function Instance_BossUI:RefreshPersonKaLiMaTableView(selectIndex)
  if self.personKaLiMaBossTableView == nil then
    self.personKaLiMaBossTableView = UITableView:CreateTableView(self.personkaLiMaLevelScroll, self.levelPersonkaLiMaBtnItem, self.personKaLiMaMonsterBossTblList, EScrollViewDireEnum.Vertical, self.UpdatePersonKaLiMaCellCallBack, self)
  end
  if self.personKaLiMaBossTableView ~= nil then
    local smallSelectIndex = 0
    if 3 < selectIndex then
      smallSelectIndex = selectIndex - 2
    else
      smallSelectIndex = 1
    end
    self.personKaLiMaBossTableView:ReloadData(smallSelectIndex)
    local obj = self.personKaLiMaBossTableView:GetLoadedCell(selectIndex)
    self:SetPersonKaLiMaBossData(obj, self.personKaLiMaMonsterBossTblList[selectIndex])
  end
end

function Instance_BossUI:UpdatePersonKaLiMaCellCallBack(index)
  if type(self.personKaLiMaMonsterBossTblList) ~= "table" or next(self.personKaLiMaMonsterBossTblList) == nil then
    return
  end
  if self.personKaLiMaMonsterBossTblList[index] ~= nil then
    local cell = self.personKaLiMaBossTableView:GetLoadedCell(index)
    self:RefreshWildBossOption(self.personKaLiMaMonsterBossTblList[index], cell, index)
  end
end

function Instance_BossUI:InitViewContent()
  self.MyLevelTab.obj = nil
  self.MyLevelTab.level = nil
  self.selectBossLevelTab = {}
end

function Instance_BossUI:btn_enterOnClick()
  if self.tog_privateBoss:GetIsOn() then
    if self.normalTimer[self.selectIndex] then
      FloatingTipUtility.QuickMsg("Ph\195\179 b\225\186\163n ch\198\176a l\195\160m m\225\187\155i")
      return
    end
    UIManager.Hide(UIID.Instance_BossUI)
    if not self.CurSingleCopydata then
      return
    end
    local mapData = {
      mapId = self.CurSingleCopydata.transferTable.id
    }
    SceneController.OnReqTransferTransmitMap(nil, mapData)
  end
end

function Instance_BossUI:RegistEvents()
  self:RegistEvent(Event.Scene_OnBeginEnterScene, self.Scene_OnBeginEnterScene, self)
  self:RegistEvent(Event.Scene_SceneBossCount, self.Scene_SceneBossCount, self)
  self:RegistEvent(Event.UpdateCopyCd, self.UpdateCopyCd, self)
  self:RegistEvent(Event.UpdateSecretBossCd, self.UpdateSecretBossCd, self)
  self:RegistEvent(Event.Boss_ClickTog, self.OnToggleChanged, self)
  self:RegistEvent(Event.OnHookMainTblSelect, self.OnHookMainTblSelect, self)
  self:RegistEvent(Event.OnHookSubTblSelect, self.OnHookSubTblSelect, self)
  self:RegistEvent(Event.OnHookBossMapSelect, self.OnHookBossMapSelect, self)
  self:RegistEvent(Event.RefreshKaLiMaBossTime, self.RefreShKaLiMaTime, self)
  self:RegistEvent(Event.RefreshBossDrop, self.RefreshBossPanelDorpRate, self)
end

function Instance_BossUI:Scene_OnBeginEnterScene(id, msg)
  UIManager.Hide(UIID.Instance_BossUI)
end

function Instance_BossUI:Scene_SceneBossCount()
  for k, v in pairs(self.PanelManger) do
    if v:GetActive() == true and self.panelTemplateList and self.panelTemplateList[k] then
      self.panelTemplateList[k]:Refresh(self)
    end
  end
end

function Instance_BossUI:UpdateCopyCd()
  local isTask = TranScriptData.GetSecretBossIsTask()
  for k, v in pairs(self.LabTime) do
    if not TranScriptData.priBossTimeTab[k] or isTask and k == 2101001 then
    else
      local time = math.floor((TranScriptData.priBossTimeTab[k] - Time.GetServerTime()) / 1000) or 0
      self:ShowTimer(time, v, k)
      v:SetActive(0 < time)
    end
  end
end

function Instance_BossUI:UpdateSecretBossCd()
  for k, v in pairs(mapPointTbl) do
    for kk, vv in pairs(TranScriptData.secretBossTimeTab) do
      if k == kk then
        local time = math.floor(vv - Time.GetServerSecondTime()) or 0
        if 0 < time then
          self:ShowTimer(time, v.lab_bossCount, k, MonsterBossType.secretBoss)
        end
      end
    end
  end
end

function Instance_BossUI:Refresh()
  if self.args ~= nil then
    if self.args.openFirstTab ~= nil then
      self.titleTog:SetTemplateData(self.args.openFirstTab, function(itemTemp, data)
        itemTemp:InitTogOn(data)
      end)
    end
    self.openSecondTab = self.args.openSecondTab
    self.subPosition = self.args.subPosition
    self.target = self.args.target
    if self.args.Monsterid and self.args.Monsterid ~= 0 then
      self.monsterTypeArgs = MonsterData.GetMonsterType(self.args.Monsterid)
      if BossData:GetTogByBossType(self.monsterTypeArgs) ~= nil then
        local temptog = BossData:GetTogByType(BossTogType.wildBossTog)
        if temptog then
          BossData:DoOnclick(temptog, true, BossTogType.wildBossTog)
        end
        BossData:GetTogByBossType(self.monsterTypeArgs):SetIsOn(true)
      end
    elseif BossData:GetTogByBossType(self.args.openFirstTab) ~= nil then
      BossData:GetTogByBossType(self.args.openFirstTab):SetIsOn(true)
    end
  elseif BossData:GSetCurTog() == BossTogType.wildBossTog then
    self.wildBossTemplate:Refresh(self)
  else
    BossData:GSetCurTog(BossTogType.wildBossTog)
    self.titleTog:SetData(BossData:GetTogDataList())
  end
end

function Instance_BossUI:GetSizeBossInfoCell()
  return self.tog_bossinfoSizeY
end

function Instance_BossUI:GetBossInfoCell()
  return self.tableView:ReuseOrCreateCell(self.tog_bossinfo)
end

function Instance_BossUI:ShowMonsterModel(monsterTbl, parent, scale, position)
  for k, v in pairs(self.monsterModel) do
    v:SetHide()
  end
  local monster
  if self.monsterModel and self.monsterModel[monsterTbl.model] == nil then
    monster = UIMonsterUtility(monsterTbl.id, parent, scale, position, Vector3(0, -180, 0))
    self.monsterModel[monsterTbl.model] = monster
  else
    monster = self.monsterModel[monsterTbl.model]
    monster:SetParent(parent)
  end
  monster.transform.localScale = scale
  monster.transform.localPosition = position
  monster:SetActive()
end

function Instance_BossUI:GetBossTransId(bossID, mapId)
  local monsterBossTbl = ConfigManager.FindConfigs("cfg_Monster_boss", "id", bossID)
  local mapIdTbl = ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
  for k, v in pairs(monsterBossTbl) do
    if v.id == bossID and v.mapId == mapIdTbl.groupId then
      return v.transferId, v.npcId
    end
  end
end

function Instance_BossUI:SetMapTabView(MonsterType, levelItem)
  self:InitViewContent()
  local bossTypeTab = MonsterData.GetMonsterBossType(MonsterType, true)
  if bossTypeTab then
    for i = 1, #bossTypeTab do
      local obj = levelItem:GetOrCreateItem(bossTypeTab[i].id .. bossTypeTab[i].mapId)
      local mapTable = ClientTable.cfg_Map_mapManager:TryGetValue(bossTypeTab[i].mapId, "id")
      local mapRestrict = mapTable.enterCondition
      obj.lab_name:SetText(mapTable.name)
      local isReachLevel = bossTypeTab[i].mapRestrict
      local levelCon
      if isReachLevel then
        levelCon = string.GetColorText(bossTypeTab[i].Displaylevel, ItemQuality2ColorDic[5])
      else
        levelCon = string.GetColorText(bossTypeTab[i].Displaylevel, ItemQuality2ColorDic[7])
      end
      obj.lab_level:SetText(levelCon)
      obj:SetOnClick(self, function()
        self:SetKaLiMaBossData(obj, bossTypeTab[i])
      end)
      if i < 2 then
        self.MyLevelTab.obj = obj
        self.MyLevelTab.level = bossTypeTab[i]
      end
      obj:SetAsLastSibling()
      table.insert(self.selectBossLevelTab, obj)
    end
  end
end

local function GetWhetherMeet(enterCondition)
  local vipCondition = {}
  local levelCondition = {}
  local isMeet, isVip = false, false
  local vipLevel = 0
  for i, v in pairs(enterCondition) do
    if v[1][1] == 101 then
      table.insert(levelCondition, v)
    elseif v[1][1] == 3101 then
      vipLevel = v[1][2]
      table.insert(vipCondition, v)
    end
  end
  if ConditionManager.Check4D(levelCondition) or ConditionManager.Check4D(vipCondition) then
    isMeet = true
  end
  if 0 < table.count(vipCondition) then
    isVip = true
  end
  return isMeet, isVip, vipLevel
end

function Instance_BossUI:TryInitComponent(obj)
  if obj.lab_name == nil then
    obj.lab_name = obj:GetChild("lab_name")
  end
  if obj.img_clickeffect == nil then
    obj.img_clickeffect = obj:GetChild("img_clickeffect")
  end
  if obj.lab_level == nil then
    obj.lab_level = obj:GetChild("lab_level")
  end
  if obj.img_bossicon == nil then
    obj.img_bossicon = obj:GetChild("img_bossicon")
  end
  if obj.lab_openLevel == nil then
    obj.lab_openLevel = obj:GetChild("lab_openLevel")
  end
  if obj.img_redPoint == nil then
    obj.img_redPoint = obj:GetChild("img_redPoint")
  end
end

function Instance_BossUI:RefreShKaLiMaConsume(modelControl, textControl, btn_obtainControl, itemId, bagCount, needCount)
  local itemData = ItemUtility.GenerateItemData(tonumber(itemId))
  modelControl.itemCellData = modelControl.itemCellData or ItemCellData()
  modelControl.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(modelControl, modelControl.itemCellData, self, true)
  local strColor = string.format("%d/%d", bagCount, needCount)
  if needCount <= bagCount then
    textControl:SetText(string.GetColorText(strColor, ItemQuality2ColorDic[5]))
  else
    textControl:SetText(string.GetColorText(strColor, ItemQuality2ColorDic[7]))
  end
  local itemData = ItemUtility.GenerateItemData(tonumber(itemId))
  btn_obtainControl.itemData = itemData
  btn_obtainControl.itemData.isHide = true
  btn_obtainControl.OpenTipsType = EOpenTipsType.FastBuy
  btn_obtainControl:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Instance_BossUI:RefreShKaLiMaCount(control, countKey)
  local remainCount = RefreshData.GetInstanceCount(countKey)
  control:SetText(remainCount)
end

function Instance_BossUI:RefreShKaLiMaTime()
  Timer.Stop(self.refreShTimer)
  local bossRefreShTime = SceneData.KaLiMaBossRefreShTime
  self.lab_countTime_kalima:SetText("\196\144\225\186\191m ng\198\176\225\187\163c l\195\160m m\225\187\155i " .. TimeUtility.ShowTime(bossRefreShTime))
  
  local function UpdateTimer()
    bossRefreShTime = bossRefreShTime - 1
    local timeStr = TimeUtility.ShowTime(bossRefreShTime)
    self.lab_countTime_kalima:SetText("\196\144\225\186\191m ng\198\176\225\187\163c l\195\160m m\225\187\155i " .. timeStr)
    if bossRefreShTime == 0 and self.refreShTimer then
      Timer.Stop(self.refreShTimer)
      self.lab_countTime_kalima:SetText("\196\144\225\186\191m ng\198\176\225\187\163c l\195\160m m\225\187\155i 00 ph\195\186t 00 gi\195\162y ")
      self.refreShTimer = nil
    end
  end
  
  self.refreShTimer = Timer.StartLoop(1, bossRefreShTime, UpdateTimer)
end

function Instance_BossUI:SetKaLiMaBossData(obj, bossTbl)
  if bossTbl == nil then
    return
  end
  self:SetButtonPitchOn(self.selectBossLevelTab, obj)
  self:RefreShKaLiMaBossPanel_Grid(bossTbl)
  for k, v in pairs(bossMapTbl) do
    v:SetActive(false)
  end
  local mapId = bossTbl.mapId
  networkRequest.ReqCountDown(mapId)
  local kaLiMaMonsterMapData = SceneData.KaLiMaMonsterMapData
  if kaLiMaMonsterMapData == nil then
    logError("D\225\187\175 li\225\187\135u boss Kalima server g\225\187\173i l\195\160 tr\225\187\145ng")
    return
  end
  for i = 1, table.count(kaLiMaMonsterMapData) do
    local oneTypeMapTab = kaLiMaMonsterMapData[i]
    if oneTypeMapTab.mapId == mapId then
      table.sort(oneTypeMapTab.mapMonsters, function(a, b)
        return a.monsterType > b.monsterType
      end)
      for i = 1, table.count(oneTypeMapTab.mapMonsters) do
        local monsterTyep = oneTypeMapTab.mapMonsters[i].monsterType
        local oneTypeMonsterTab = oneTypeMapTab.mapMonsters[i].monsterInfo
        for i = 1, table.count(oneTypeMonsterTab) do
          local monsterItem = oneTypeMonsterTab[i]
          local objMap = mapItem:GetOrCreateItem(bossTbl.id .. monsterItem.monsterConfigId)
          local monsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterItem.monsterConfigId, "id")
          local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
          local transferId = ClientTable.cfg_Monster_bossManager:TryGetValue(mapId, "mapId").transferId
          local scale = monsterTyep == KaLiMaMonsterType.boss and Vector3(80, 80, 80) or Vector3(50, 50, 50)
          local position = Vector3(0, -165, -100)
          self:ShowMonsterModel(monsterTbl, objMap.go_model2, scale, position)
          objMap:SetActive(true)
          objMap.lab_bossName:SetText(monsterTbl.name)
          if 0 < monsterItem.monsterCount then
            objMap.lab_bossCount:SetText(string.GetColorText(monsterItem.monsterCount .. " ch\225\187\137 ", ItemQuality2ColorDic[5]))
          else
            objMap.lab_bossCount:SetText(string.GetColorText(monsterItem.monsterCount .. " ch\225\187\137 ", ItemQuality2ColorDic[7]))
          end
          local expendTab = string.split(ClientTable.cfg_Map_transferManager:TryGetValue(transferId).cost, "#")
          local bagCount = BagInfoData.GetItemCountByItemConfigId(tonumber(expendTab[1]))
          local needCount = tonumber(expendTab[2])
          self:RefreShKaLiMaConsume(self.kaLiMaTicketsModel, self.lab_num, self.btn_obtainKaLiMa, expendTab[1], bagCount, needCount)
          local sprite = monsterTyep == KaLiMaMonsterType.boss and "txt_blg" or "txt_bld"
          local isShow = monsterTyep ~= KaLiMaMonsterType.elite
          if isShow then
            self:SetSprite("Atlas_Language", sprite, objMap.img_bao)
          end
          objMap.img_bao:SetActive(isShow)
          self.btn_enter_kalima:SetOnClick(self, function()
            local levelCondition = {}
            local vipCondition = {}
            local isVipMap = false
            for i, v in ipairs(mapTbl.enterCondition[1]) do
              if v[1] == 3101 then
                isVipMap = true
                table.insert(vipCondition, v)
              else
                table.insert(levelCondition, v)
              end
            end
            if not ConditionManager.Check(levelCondition) then
              local level = Mathf.Floor(levelCondition[1][2] / 400)
              FloatingTipUtility.QuickMsg(string.format("Ch\225\187\137 ng\198\176\225\187\157i ch\198\161i Chuy\225\187\131n %d m\225\187\155i c\195\179 th\225\187\131 v\195\160o", level))
              return
            end
            if isVipMap and not ConditionManager.Check(vipCondition) then
              local vip = vipCondition[1][2]
              local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(vip)
              FloatingTipUtility.QuickMsg(string.format("C\225\186\167n VIP %s tr\225\187\159 l\195\170n", memberTbl.name))
              return
            end
            if bagCount < needCount then
              local itemData = ItemUtility.GenerateItemData(tonumber(string.split(expendTab[1], "#")[1]))
              objMap.itemData = itemData
              objMap.itemData.isHide = true
              objMap.OpenTipsType = EOpenTipsType.FastBuy
              ItemUtility.ClickObtainItemBtn(_, objMap)
              FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("KalimaCastle_02"))
            else
              TipUtility.QuickShowPrompt({
                id = PromptWordType.enterKaLiMa,
                cancelAction = function()
                  UIManager.Hide(UIID.PromptTipUI)
                end,
                okAction = function()
                  networkRequest.ReqCreateTemporaryTransmit(transferId)
                  UIManager.Hide(UIID.Instance_BossUI)
                end
              })
            end
          end)
          bossMapTbl[bossTbl.id .. monsterItem.monsterConfigId] = objMap
        end
      end
    end
  end
end

function Instance_BossUI:SetPersonKaLiMaBossData(obj, bossTbl)
  if bossTbl == nil and obj.param and obj.param.bossMonsterTbl then
    bossTbl = obj.param.bossMonsterTbl
  end
  if bossTbl == nil then
    return
  end
  if obj.param and obj.param.index then
    if self.personKaLiMaBossTableView then
      local cell = self.personKaLiMaBossTableView:GetLoadedCell(self.personKaLiMaSelectIndex)
      if cell then
        cell.img_clickeffect:SetActive(false)
      end
    end
    self.personKaLiMaSelectIndex = obj.param.index
    obj.img_clickeffect:SetActive(true)
  end
  if bossTbl == nil then
    return
  end
  local mapId = bossTbl.mapId
  local monsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(bossTbl.id, "id")
  local transferId = ClientTable.cfg_Monster_bossManager:TryGetValue(mapId, "mapId").transferId
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
  local scaleStr = string.split(bossTbl.scale, "#")
  local strPosPrompt = string.sub(bossTbl.position, 2)
  local posStr = string.split(strPosPrompt, "#")
  local scale = Vector3(tonumber(scaleStr[1]), tonumber(scaleStr[2]), tonumber(scaleStr[3]))
  local position = Vector3(tonumber(posStr[1]), tonumber(posStr[2]), -100)
  self:RefreShPersonKaLiMaBossPanel_Grid(bossTbl)
  self.lab_personBossName:SetText(monsterTbl.name)
  self:ShowMonsterModel(monsterTbl, self.go_modelPersonKaLiMa, scale, position)
  local expendTab = string.split(ClientTable.cfg_Map_transferManager:TryGetValue(transferId).cost, "#")
  local bagCount = BagInfoData.GetItemCountByItemConfigId(tonumber(expendTab[1]))
  local needCount = tonumber(expendTab[2])
  self:RefreShKaLiMaConsume(self.personKaLiMaTicketsModel, self.personKaLiMalab_num, self.btn_obtainPersonKaLiMa, expendTab[1], bagCount, needCount)
  self.btn_enter_person:SetOnClick(self, function()
    local isMeet, isVip, vipLevel = GetWhetherMeet(mapTbl.enterCondition)
    if isMeet then
      if bagCount < needCount then
        FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("KalimaCastle_02"))
        return
      else
        networkRequest.ReqCreateTemporaryTransmit(transferId)
        UIManager.Hide(UIID.Instance_BossUI)
        return
      end
    else
      FloatingTipUtility.QuickMsg("Kh\195\180ng \196\145\225\187\167 \196\145i\225\187\129u ki\225\187\135n, kh\195\180ng th\225\187\131 v\195\160o PB")
      return
    end
  end)
end

function Instance_BossUI:KaLiMaPosOnClick()
  local itemData = ItemUtility.GenerateItemData(4021001)
  self.btn_obtain.itemData = itemData
  self.btn_obtain.itemData.isHide = true
  self.btn_obtain.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Instance_BossUI:SetMapCount(tv, objMap, condition, mapData)
  local levelStr
  local isVip = false
  local isShow = true
  local monsterCount = tv.count or 1
  local line = tv.line % 3
  if line == 0 then
    line = 3
  end
  local vipLevel = 0
  if mapData.virMap ~= 0 then
    local LineCount = MonsterData.GetLineNumByMapID(mapData.id, tv.bossId)
    if 0 < LineCount then
      monsterCount = LineCount
    end
  end
  vipLevel = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberLevle()
  if monsterCount == 0 then
    self:SetSprite("Atlas_Common", "ty_btn_boss_more_AN", objMap, false)
    if condition[1][1][1] == 101 or condition[1][1][1] == 7001 then
      levelStr = condition[1][1][2]
      objMap.lab_level:SetActive(false)
      objMap.lab_mapName:SetText(string.GetColorText(string.format("%s ", mapData.name), ItemQuality2ColorDic[10]))
      objMap.lab_bossCount:SetText(string.GetColorText(string.format("%d ", monsterCount), ItemQuality2ColorDic[10]))
    elseif BossData.IsVipCanIn(condition[1][1][1]) then
      levelStr = string.split(mapData.level, "#")[1]
      local vipID = tonumber(condition[1][1][2])
      local VipTab = ClientTable.cfg_MemberManager:TryGetValue(vipID)
      local name = "Ch\198\176a m\225\187\159 "
      if VipTab then
        name = VipTab.name
      end
      local str = string.GetColorText(string.format("%s ", name), ItemQuality2ColorDic[7]) .. string.GetColorText(string.format("%d ", monsterCount), ItemQuality2ColorDic[5])
      if vipLevel >= vipID then
        objMap.lab_bossCount:SetText(string.GetColorText(string.format("%d ", monsterCount), ItemQuality2ColorDic[10]))
        objMap.lab_level:SetActive(false)
      else
        isVip = true
        objMap.lab_level:SetText(str)
        objMap.lab_level:SetActive(true)
      end
      objMap.lab_mapName:SetText(string.GetColorText(string.format("%s", mapData.name), ItemQuality2ColorDic[10]))
    end
  else
    self:SetSprite("Atlas_Common", "ty_btn_boss_more_N", objMap, false)
    local lab_bossCountcolor = ItemQuality2ColorDic[5]
    if monsterCount == 0 or monsterCount == nil then
      lab_bossCountcolor = ItemQuality2ColorDic[10]
    elseif ConditionManager.Check4D(mapData.enterCondition) == false then
      lab_bossCountcolor = ItemQuality2ColorDic[7]
    end
    local mapName = string.GetColorText(string.format("%s", mapData.name), ItemQuality2ColorDic[0])
    local lineName = string.GetColorText(string.format("[Tuy\225\186\191n %s]", line), ItemQuality2ColorDic[0])
    if condition[1][1][1] == 101 or condition[1][1][1] == 7001 then
      levelStr = condition[1][1][2]
      objMap.lab_level:SetActive(false)
      objMap.lab_bossCount:SetText(string.GetColorText(string.format("%d ", monsterCount), lab_bossCountcolor))
      objMap.lab_mapName:SetText(mapName .. " " .. lineName)
    elseif BossData.IsVipCanIn(condition[1][1][1]) then
      local vipID = tonumber(condition[1][1][2])
      local vipTab = ClientTable.cfg_MemberManager:TryGetValue(vipID)
      levelStr = string.split(mapData.level, "#")[1]
      if vipLevel >= vipID then
        objMap.lab_level:SetActive(false)
        objMap.lab_bossCount:SetText(string.GetColorText(string.format("%d ", monsterCount), lab_bossCountcolor))
      else
        isVip = true
        local name = ""
        if vipTab then
        end
        local str = string.GetColorText(string.format("%s ", name), ItemQuality2ColorDic[7]) .. string.GetColorText(string.format("%d ", monsterCount), lab_bossCountcolor)
        objMap.lab_level:SetActive(false)
        objMap.lab_bossCount:SetText(str)
        goto lbl_343
        objMap.lab_level:SetText(str)
        objMap.lab_level:SetActive(true)
      end
      ::lbl_343::
      objMap.lab_mapName:SetText(mapName .. " " .. lineName)
    end
  end
  if mapData.serverType == serverType.span then
    local spanName = string.GetColorText("[Li\195\170n SV]", ItemQuality2ColorDic[5])
    local spanNameStr = mapData.name
    objMap.lab_mapName:SetText(spanName .. spanNameStr)
    for i = 1, #condition do
      for j = 1, #condition[i] do
        if condition[i][j][1] == 901 then
          isShow = LoginData.openServerDay >= condition[i][j][2]
          return levelStr, isVip, isShow
        end
      end
    end
  end
  return levelStr, isVip, isShow
end

local function OnNameBtnItemCreate(control)
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_level = UIControl(control.transform, "lab_level")
  control.img_bossicon = UIControl(control.transform, "img_bossicon")
  control.lab_openLevel = UIControl(control.transform, "lab_openLevel")
  control.ima_strideServerMap = UIControl(control.transform, "img_sign")
end

local function PersonKaLiMaOnNameBtnItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.img_bossicon = UIControl(control.transform, "img_bossicon")
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_openLevel = UIControl(control.transform, "lab_openLevel")
  control.ima_strideServerMap = UIControl(control.transform, "img_sign")
  control.lab_condition = UIControl(control.transform, "lab_condition")
end

local function KaLiMaOnNameBtnItemCreate(control)
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_level = UIControl(control.transform, "lab_level")
  control.ima_strideServerMap = UIControl(control.transform, "img_sign")
end

local function OnMapItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

local function excellentMapItemCreat(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

local function OnItemCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

local function OnItemRefresh(ctr, _, awardData, ui)
  local itemData = ItemUtility.GenerateItemData(tonumber(awardData.id))
  itemData.count = 1
  ctr.itemCellData:RefreshData(itemData)
  if awardData.isEff and not ctr.Eff then
    ctr.Eff = UIEffectUtility.SetUIEffect("Eff_UI_xuanshangjiangli02", ctr, true, Vector3(2, 2, 500))
  elseif not awardData.isEff and ctr.Eff then
    ctr.Eff:SetActive(false)
  elseif awardData.isEff and ctr.Eff then
    ctr.Eff:SetActive(true)
  end
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

local function KaLiMaAwardCreate(control)
  control.go_model = UIControl(control.transform, "go_model")
  control.go_modelData = ItemCellData()
end

local function KaLiMaAwardRefresh(control, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(tonumber(data))
  itemData.count = ""
  if ui.dropItemNumTab then
    for i, v in pairs(ui.dropItemNumTab) do
      if tonumber(v[1]) == tonumber(data) then
        itemData.count = v[2]
        break
      end
    end
  end
  control.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(control, control.go_modelData, ui, true)
end

local function KaLiMaMonsterCreate(control)
  control.go_model2 = UIControl(control.transform, "go_model2")
  control.lab_bossName = UIControl(control.transform, "lab_bossName")
  control.lab_bossCount = UIControl(control.transform, "img_numbg/lab_num")
  control.img_bao = UIControl(control.transform, "img_bao")
end

function Instance_BossUI:InitContent()
  self.wildBossTemplate = luaTemplateManager.GetNewTemplate(self.wildBossPanel, LuaComponentTemplates.BossUI_WildBossTemp)
  self.secretBossTemplate = luaTemplateManager.GetNewTemplate(self.privateBossPanel, LuaComponentTemplates.BossUI_SecretBossTemp)
  self.reinBossTemplate = luaTemplateManager.GetNewTemplate(self.reinBossPanel, LuaComponentTemplates.BossUI_ReinBossTemp)
  self.angelBossTemplate = luaTemplateManager.GetNewTemplate(self.angelBossPanel, LuaComponentTemplates.BossUI_AngelBossTemp)
  self.regenerateBossTemplate = luaTemplateManager.GetNewTemplate(self.regenerateBossPanel, LuaComponentTemplates.BossUI_RegenerateBossTemp)
  self.holySkeletonBossTemplate = luaTemplateManager.GetNewTemplate(self.HolySkeletonBossPanel, LuaComponentTemplates.BossUI_HolySkeletonBossTemp)
  self.runesNewBossTemplate = luaTemplateManager.GetNewTemplate(self.RunesNewBossPanel, LuaComponentTemplates.BossUI_RunesNewBossTemp)
  self.enchantSmeltBossTemplate = luaTemplateManager.GetNewTemplate(self.EnchantSmeltBossPanel, LuaComponentTemplates.BossUI_EnchantSmeltBossTemp)
  self.titleTog = UIUtility.BindUIContainerTemp(self.tog_tempSecret, LuaComponentTemplates.BossUI_TitleTogTemp, self)
  self.titleTog:SetData(BossData:GetTogDataList())
  UIManager.AddUIAnother("Instance_BossUI", self)
  self.wildBossContent.layoutGroup.enabled = true
  self.levelKaLiMaBtnItemTemp = UIContainer(self.levelkalimaBtnItemNew, self, KaLiMaOnNameBtnItemCreate)
  self.KaLiMaAwardContainer = UIContainer(self.kaLiMaBtnGold3DItemNew, self, KaLiMaAwardCreate, KaLiMaAwardRefresh)
  self.KaLiMaMonsterTemp = UIContainer(self.kalimaBossList, self, KaLiMaMonsterCreate)
  self.wildMapItemTemp = UIContainer(self.wildMapItem, self, OnMapItemCreate)
  self.reinMapItemTemp = UIContainer(self.reinMapItem, self, OnMapItemCreate)
  self.angelMapItemTemp = UIContainer(self.angelMapItem, self, OnMapItemCreate)
  self.onHookPanel = luaTemplateManager.GetNewTemplate(self.onHookPanelObject, LuaComponentTemplates.onHookTemplate, {baseUI = self})
  self.excellentMapItemTemp = UIContainer(self.excellentMapItem, self, excellentMapItemCreat)
  self.PanelManger = {
    [MonsterBossType.wildBoss] = self.wildBossPanel,
    [MonsterBossType.secretBoss] = self.privateBossPanel,
    [MonsterBossType.OnHookPoint] = self.onHookPanelObject,
    [MonsterBossType.reinBoss] = self.reinBossPanel,
    [MonsterBossType.KaLiMaBoss] = self.kalimaBossPanelNew,
    [MonsterBossType.PersonKaLiMaBoss] = self.PersonkaLiMaBossPanel,
    [MonsterBossType.AngelBoss] = self.angelBossPanel,
    [MonsterBossType.RegenerateBoss] = self.regenerateBossPanel,
    [MonsterBossType.HolySkeletonBoss] = self.HolySkeletonBossPanel,
    [MonsterBossType.RunesNewBoss] = self.RunesNewBossPanel,
    [MonsterBossType.EnchantSmeltBoss] = self.EnchantSmeltBossPanel
  }
  self.panelTemplateList = {
    [MonsterBossType.wildBoss] = self.wildBossTemplate,
    [MonsterBossType.secretBoss] = self.secretBossTemplate,
    [MonsterBossType.OnHookPoint] = self.onHookPanel,
    [MonsterBossType.reinBoss] = self.reinBossTemplate,
    [MonsterBossType.AngelBoss] = self.angelBossTemplate,
    [MonsterBossType.RegenerateBoss] = self.regenerateBossTemplate,
    [MonsterBossType.HolySkeletonBoss] = self.holySkeletonBossTemplate,
    [MonsterBossType.RunesNewBoss] = self.runesNewBossTemplate,
    [MonsterBossType.EnchantSmeltBoss] = self.enchantSmeltBossTemplate
  }
  self.selectBossLevelTab = {}
end

function Instance_BossUI:InitonHookPanel()
  if self.onHookPanel == nil then
    return
  end
  self.onHookPanel:Refresh()
  self.onHookPanel:InitData(self.openSecondTab, self.subPosition, self.target)
end

function Instance_BossUI:ShowTimer(surplusTime, lab_countdown, index, type)
  local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
  lab_countdown:SetText(timeStr)
  lab_countdown:SetActive(0 < surplusTime)
  
  local function UpdateTimer()
    if surplusTime <= 1 then
      lab_countdown:SetActive(type and type == MonsterBossType.secretBoss)
      if self.normalTimer[index] then
        Timer.Stop(self.normalTimer[index])
        self.normalTimer[index] = nil
      end
    end
    surplusTime = surplusTime - 1
    local timeStrB = TimeUtility.ShowTimeWithColon(surplusTime)
    if type and type == MonsterBossType.secretBoss then
      if surplusTime <= 1 then
        lab_countdown:SetText(string.GetColorText("1", ItemQuality2ColorDic[5]))
      else
        lab_countdown:SetText(string.GetColorText(tostring(timeStrB), ItemQuality2ColorDic[7]))
      end
    else
      lab_countdown:SetText(timeStrB)
    end
  end
  
  if self.normalTimer[index] then
    lab_countdown:SetActive(false)
    Timer.Stop(self.normalTimer[index])
    self.normalTimer[index] = nil
  end
  lab_countdown:SetActive(type and type == MonsterBossType.secretBoss)
  self.normalTimer[index] = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Instance_BossUI:RefreshBossTopInfo(_BossTogType, _MonsterBossType)
  if self.bossTagTimer[_MonsterBossType] == nil then
    local refresh = RefreshData.GetRefreshByKey(2440600)
    if BossData:GSetCurTog() == _BossTogType and refresh ~= nil then
      local effectStr = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1)
      local intervalTime = string.split(effectStr, "#")
      local time = math.floor(refresh.updateTime / 1000) + tonumber(intervalTime[1]) * 60 - Time.GetServerSecondTime()
      if 0 < time then
        self:ShowBossTagTimer(time, self.lab_countDown, self.lab_timeLeft, _MonsterBossType)
      end
    else
      self.lab_timeLeft:SetActive(false)
    end
  end
end

function Instance_BossUI:ShowBossTagTimer(surplusTime, lab_countdown, lab_countdownDis, type)
  local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
  lab_countdown:SetActive(0 < surplusTime)
  lab_countdownDis:SetActive(0 < surplusTime)
  
  local function UpdateTimer()
    if surplusTime <= 1 then
      if self.bossTagTimer[type] then
        Timer.Stop(self.bossTagTimer[type])
        self.bossTagTimer[type] = nil
        lab_countdown:SetActive(false)
        lab_countdownDis:SetActive(false)
      end
    else
      surplusTime = surplusTime - 1
      local timeStrB = TimeUtility.ShowTimeWithColon(surplusTime)
      lab_countdown:SetText(timeStrB)
    end
  end
  
  self.bossTagTimer[type] = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Instance_BossUI:OnHookMainTblSelect(id, data)
  if self.onHookPanel == nil then
    return
  end
  self.onHookPanel:RefreshMainTblSelect(data)
end

function Instance_BossUI:OnHookSubTblSelect(id, data)
  self.onHookPanel:RefreshSubTblSelect(data)
end

function Instance_BossUI:OnHookBossMapSelect(id, data)
  self.onHookPanel:RefreshBossTblSelect(data)
end

function Instance_BossUI:IsNeedShowTop_down_Arrow(Viewport, Content)
  local isshowTop_down = false
  local isshowDown_down = false
  local startPos = 50
  local deviation = 1
  local Viewport_height = Viewport.rectTransform.sizeDelta.y
  local ContentWild_height = Content.rectTransform.sizeDelta.y
  if ContentWild_height - Viewport_height < 0 then
    return isshowTop_down, isshowDown_down
  end
  local posY = Content.transform.localPosition.y
  if posY >= startPos + deviation then
    isshowTop_down = true
  end
  if ContentWild_height - Viewport_height + startPos > posY + deviation then
    isshowDown_down = true
  end
  return isshowTop_down, isshowDown_down
end

function Instance_BossUI:RefreshBossPanelDorpRate()
  local imagaObj
  if BossData:GSetCurTog() == BossTogType.wildBossTog then
    imagaObj = self:GetControl("wildBossPanel/img_bao")
  elseif BossData:GSetCurTog() == BossTogType.reinBossTog then
    imagaObj = self:GetControl("reinBossPanel/img_bao")
  elseif BossData:GSetCurTog() == BossTogType.AngelBossTog then
    imagaObj = self:GetControl("AngelBossPanel/img_bao")
  elseif BossData:GSetCurTog() == BossTogType.RegenerateBossTog then
    imagaObj = self:GetControl("RegenerateBossPanel/img_bao")
  elseif BossData:GSetCurTog() == BossTogType.HolySkeletonBossTog then
    imagaObj = self:GetControl("HolySkeletonBossPanel/img_bao")
  elseif BossData:GSetCurTog() == BossTogType.RunesNewBossTog then
    imagaObj = self:GetControl("RunesNewBossPanel/img_bao")
  elseif BossData:GSetCurTog() == BossTogType.EnchantSmeltBossTog then
    imagaObj = self:GetControl("EnchantSmeltBossPanel/img_bao")
  end
  if imagaObj == nil then
    return
  end
  local monsterBossTbl = BossData:GetCurSelectBossTbl()
  local dropItemPicArray = string.split(monsterBossTbl.dropItemPic, "#")
  local dropNumber = BossData:GetBossDropNumber(monsterBossTbl.id)
  if dropNumber ~= nil and 0 < #dropItemPicArray then
    local imageName = "txt_bl"
    if dropNumber >= tonumber(dropItemPicArray[1]) * (1 + self:GetBuffDropLimitValue()) then
      imageName = imageName .. "d"
    elseif dropNumber >= tonumber(dropItemPicArray[2]) * (1 + self:GetBuffDropLimitValue()) then
      imageName = imageName .. "z"
    else
      imageName = imageName .. "g"
    end
    self:SetSprite("Atlas_Language", imageName, imagaObj)
  end
end

function Instance_BossUI:RefreShKaLiMaBossPanel_Grid(monsterBossTbl)
  if monsterBossTbl ~= nil or monsterBossTbl.dropItemNum ~= nil then
    self.dropItemNumTab = {}
    local dropItemNum = string.split(monsterBossTbl.dropItemNum, "&")
    for i, v in pairs(dropItemNum) do
      if string.find(v, "#") then
        local nowaward = string.split(v, "#")
        table.insert(self.dropItemNumTab, nowaward)
      end
    end
  end
  local tblData = MonsterData.GetBossShowDropItemList(monsterBossTbl)
  self.KaLiMaAwardContainer:SetData(tblData[1].tabReward)
end

function Instance_BossUI:RefreShPersonKaLiMaBossPanel_Grid(monsterBossTbl)
  local tblData = MonsterData.GetBossShowDropItemList(monsterBossTbl)
  local length = UIUtility.GetDicLength(tblData)
  self.personKaLiMaBossPanel_Grid:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tblData) do
    local object = self.personKaLiMaBossPanel_Grid:GetTopGridObjectList()[index]
    if self.bossDropTblDic == nil then
      self.bossDropTblDic = {}
    end
    if self.bossDropTblDic[object] == nil then
      self.bossDropTblDic[object] = luaTemplateManager.GetNewTemplate(object, LuaComponentTemplates.BossUI_dropListTemp, {baseUI = self})
    end
    self.bossDropTblDic[object]:Refresh(v)
    index = index + 1
  end
end

function Instance_BossUI:GetBuffDropLimitValue()
  if RoleManager.me == nil then
    return 0
  end
  local dropLimitBuff = BuffData.GetBuff(RoleManager.me.id, 12151001)
  if dropLimitBuff and dropLimitBuff.attribute and 0 < table.count(dropLimitBuff.attribute) then
    if AttributeConfig.IsRatioAttribute("dropRateToplimit") then
      return dropLimitBuff.attribute[EAttributeType.dropRateToplimit] / 10000
    else
      return dropLimitBuff.attribute[EAttributeType.dropRateToplimit] / 100
    end
  end
  return 0
end
