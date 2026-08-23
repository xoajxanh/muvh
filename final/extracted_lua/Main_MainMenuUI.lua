Main_MainMenuUI = class(BaseUI)
Main_MainMenuUI.layer = UILayer.Background
Main_MainMenuUI.orderInLayer = 1
Main_MainMenuUI.hideType = UIHideType.Hide
Main_MainMenuUI.hideFunc = UIHideFunc.Deactive
Main_MainMenuUI.escClose = UIEscClose.DontClose

function Main_MainMenuUI:InitControls()
  self.go_top = self:GetControl("go_top")
  self.go_left = self:GetControl("go_left")
  self.btn_micro = self:GetControl("go_left/btn_micro")
  self.go_left_tip = self:GetControl("go_left_tip")
  self.go_right = self:GetControl("go_right")
  self.btn_func = self:GetControl("go_right/btn_func")
  self.btn_funcBubble = self:GetControl("go_right/btn_funcBubble")
  self.img_redPointfunc = self:GetControl("go_right/img_redPointfunc")
  self.btn_bag = self:GetControl("go_right/btn_bag")
  self.Image_man = self:GetControl("go_right/btn_bag/Image_man")
  self.go_eliteBoss = self:GetControl("go_right/go_eliteBoss")
  self.sw_eliteBossList = self:GetControl("go_right/go_eliteBoss/sw_eliteBossList")
  self.Btns = self:GetControl("go_right/go_eliteBoss/Btns")
  self.btn_normal = self:GetControl("go_right/go_eliteBoss/sw_eliteBossList/Btns/btn_normal")
  self.btn_member = self:GetControl("go_right/go_eliteBoss/sw_eliteBossList/Btns/btn_member")
  self.Content = self:GetControl("go_right/go_eliteBoss/sw_eliteBossList/Viewport/Content")
  self.img_monsterList = self:GetControl("go_right/go_eliteBoss/sw_eliteBossList/Viewport/Content/img_monsterList")
  self.img_guideSubmit = self:GetControl("go_right/go_eliteBoss/sw_eliteBossList/Viewport/Content/img_monsterList/GuideSubmit/img_guideSubmit")
  self.btn_eliteBoss = self:GetControl("go_right/go_eliteBoss/btn_eliteBoss")
  self.Arrow = self:GetControl("go_right/go_eliteBoss/btn_eliteBoss/Arrow")
  self.btn_xiaoBoss = self:GetControl("go_right/go_eliteBoss/btn_xiaoBoss")
  self.btn_autoStart = self:GetControl("go_right/btn_autoStart")
  self.btn_autoPause = self:GetControl("go_right/btn_autoPause")
  self.btn_autoStop = self:GetControl("go_right/btn_autoStop")
  self.btn_autoPvp = self:GetControl("go_right/btn_autoPvp")
  self.go_fake = self:GetControl("go_right/go_fake")
  self.go_center = self:GetControl("go_center")
  self.go_center_top = self:GetControl("go_center_top")
  self.go_left_top = self:GetControl("go_left_top")
  self.go_left_topVertical = self:GetControl("go_left_top/go_left_topVertical")
  self.btn_TaskSchool = self:GetControl("go_left_top/go_left_topVertical/btn_TaskSchool")
  self.lab_TaskSchoolimg = self:GetControl("go_left_top/go_left_topVertical/btn_TaskSchool/lab_TaskSchoolimg")
  self.lab_TaskSchoolcount = self:GetControl("go_left_top/go_left_topVertical/btn_TaskSchool/lab_TaskSchoolcount")
  self.btn_Forecast = self:GetControl("go_left_top/go_left_topVertical/btn_Forecast")
  self.lab_imgForecast = self:GetControl("go_left_top/go_left_topVertical/btn_Forecast/lab_imgForecast")
  self.lab_title = self:GetControl("go_left_top/go_left_topVertical/btn_Forecast/lab_title")
  self.btn_newMember = self:GetControl("go_left_top/go_left_topVertical/btn_newMember")
  self.icon_member = self:GetControl("go_left_top/go_left_topVertical/btn_newMember/icon_member")
  self.lab_nextMemberlevel = self:GetControl("go_left_top/go_left_topVertical/btn_newMember/lab_nextMemberlevel")
  self.btn_donwload = self:GetControl("go_right_top/go_activity/btn_donwload")
  self.btn_Exit = self:GetControl("go_left_top/btn_Exit")
  self.lab_TimeValue = self:GetControl("go_left_top/btn_Exit/lab_TimeValue")
  self.go_right_top = self:GetControl("go_right_top")
  self.go_sceneInteractive = self:GetControl("go_right_top/go_sceneInteractive")
  self.btn_SitInteractive = self:GetControl("go_right_top/go_sceneInteractive/btn_SitInteractive")
  self.go_activity = self:GetControl("go_right_top/go_activity")
  self.btn_rankList = self:GetControl("go_right_top/go_activity/btn_rankList")
  self.btn_shop = self:GetControl("go_right_top/go_activity/btn_shop")
  self.btn_auctoin = self:GetControl("go_right_top/go_activity/btn_auctoin")
  self.btn_instance = self:GetControl("go_right_top/go_activity/btn_instance")
  self.btn_instanceBoss = self:GetControl("go_right_top/go_activity/btn_instanceBoss")
  self.btn_siege = self:GetControl("go_right_top/go_activity/btn_siege")
  self.btn_firstCharge = self:GetControl("go_right_top/go_activity/btn_firstCharge")
  self.btn_first_changzhu = self:GetControl("go_right_top/go_activity/btn_firstCharge/btn_first_changzhu")
  self.img_redPoint = self:GetControl("go_right_top/go_activity/btn_firstCharge/img_redPoint")
  self.btn_firstActivity = self:GetControl("go_right_top/go_activity/btn_firstActivity")
  self.btn_HolidayActivity = self:GetControl("go_right_top/go_activity/btn_HolidayActivity")
  self.btn_return = self:GetControl("go_right_top/go_activity/btn_return")
  self.btn_MonsterOffered = self:GetControl("go_right_top/go_activity/btn_MonsterOffered")
  self.btn_Welfare = self:GetControl("go_right_top/go_activity/btn_Welfare")
  self.btn_StarTask = self:GetControl("go_right_top/go_activity/btn_StarTask")
  self.btn_vvip = self:GetControl("go_right_top/go_activity/btn_vvip")
  self.btn_TianKong = self:GetControl("go_right_top/go_activity/btn_TianKong")
  self.btn_Tower = self:GetControl("go_right_top/go_activity/btn_Tower")
  self.btn_shopExp = self:GetControl("go_right_top/go_activity/btn_shopExp")
  self.btn_ActivityShow = self:GetControl("go_right_top/go_activity/btn_ActivityShow")
  self.btn_onHook = self:GetControl("go_right_top/go_activity/btn_onHook")
  self.btn_customer = self:GetControl("go_right_top/go_activity/btn_customer")
  self.btn_customer_sdk = self:GetControl("go_right_top/go_activity/btn_customer_sdk")
  self.btn_SpellFestival = self:GetControl("go_right_top/go_activity/btn_SpellFestival")
  self.btn_kuafu = self:GetControl("go_right_top/go_activity/btn_kuafu")
  self.btn_membervip = self:GetControl("go_right_top/go_activity/btn_membervip")
  self.btn_GameBook = self:GetControl("go_right_top/go_activity/btn_GameBook")
  self.btn_shrink = self:GetControl("go_right_top/btn_shrink")
  self.go_right_Tip = self:GetControl("go_right_Tip")
  self.go_left_bottom = self:GetControl("go_left_bottom")
  self.go_right_bottom = self:GetControl("go_right_bottom")
  self.grid_funcBtn = self:GetControl("go_right_bottom/grid_funcBtn")
  self.btn_settings = self:GetControl("go_right_bottom/grid_funcBtn/btn_settings")
  self.btn_skill = self:GetControl("go_right_bottom/grid_funcBtn/btn_skill")
  self.btn_roleInfo = self:GetControl("go_right_bottom/grid_funcBtn/btn_roleInfo")
  self.btn_forgeNav = self:GetControl("go_right_bottom/grid_funcBtn/btn_forgeNav")
  self.btn_mail = self:GetControl("go_right_bottom/grid_funcBtn/btn_mail")
  self.btn_friends = self:GetControl("go_right_bottom/grid_funcBtn/btn_friends")
  self.btn_warAlliance = self:GetControl("go_right_bottom/grid_funcBtn/btn_warAlliance")
  self.btn_qijiHelper = self:GetControl("go_right_bottom/grid_funcBtn/btn_qijiHelper")
  self.btn_appearance = self:GetControl("go_right_bottom/grid_funcBtn/btn_appearance")
  self.btn_mount = self:GetControl("go_right_bottom/grid_funcBtn/btn_mount")
  self.btn_rechange = self:GetControl("go_right_bottom/grid_funcBtn/btn_rechange")
  self.btn_fake = self:GetControl("go_right_bottom/grid_funcBtn/btn_fake")
  self.btn_GM = self:GetControl("go_right_bottom/grid_funcBtn/btn_GM")
  self.btn_guard = self:GetControl("go_right_bottom/grid_funcBtn/btn_guard")
  self.btn_Combine = self:GetControl("go_right_bottom/grid_funcBtn/btn_Combine")
  self.btn_GameBookold = self:GetControl("go_right_bottom/grid_funcBtn/btn_GameBookold")
  self.btn_Signet = self:GetControl("go_right_bottom/grid_funcBtn/btn_Signet")
  self.btn_BingJian = self:GetControl("go_right_bottom/grid_funcBtn/btn_BingJian")
  self.go_bottom = self:GetControl("go_bottom")
  self.btn_SceneInteractive = self:GetControl("go_bottom/btn_SceneInteractive")
  self.img_bloodStoneGrey = self:GetControl("go_bottom/img_chat/img_bloodStoneGrey")
  self.img_bloodStoneBright = self:GetControl("go_bottom/img_chat/img_bloodStoneGrey/img_bloodStoneBright")
  self.lab_bloodNum = self:GetControl("go_bottom/img_chat/img_bloodStoneGrey/lab_bloodNum")
  self.img_manaStoneGrey = self:GetControl("go_bottom/img_chat/img_manaStoneGrey")
  self.img_manaStoneBright = self:GetControl("go_bottom/img_chat/img_manaStoneGrey/img_manaStoneBright")
  self.lab_manaNum = self:GetControl("go_bottom/img_chat/img_manaStoneGrey/lab_manaNum")
  self.img_expbar = self:GetControl("go_bottom/img_expbar")
  self.ArrowNum = self:GetControl("go_bottom/img_expbar/img_arrow/ArrowNum")
  self.img_expbarSlider = self:GetControl("go_bottom/img_expbar/img_expbarSlider")
  self.btn_quicklyTeamMinimize = self:GetControl("go_bottom/btn_quicklyTeamMinimize")
  self.lab_MatchingCountown = self:GetControl("go_bottom/btn_quicklyTeamMinimize/lab_MatchingCountown")
  self.btn_attackmode = self:GetControl("go_bottom/btn_attackmode")
  self.grid_pkMode = self:GetControl("go_bottom/grid_pkMode")
  self.btn_mode = self:GetControl("go_bottom/grid_pkMode/btn_mode")
  self.lab_playerLevel = self:GetControl("go_bottom/player_level/lab_playerLevel")
  self.go_expUp = self:GetControl("go_bottom/go_expUp")
  self.img_wifi = self:GetControl("go_bottom/img_wifi")
  self.img_batteryBg = self:GetControl("go_bottom/img_batteryBg")
  self.nowTime = self:GetControl("go_bottom/nowTime")
  self.go_fastUseItem = self:GetControl("go_bottom/go_fastUseItem")
  self.btn_useItem1 = self:GetControl("go_bottom/go_fastUseItem/btn_useItem1")
  self.btn_useItem2 = self:GetControl("go_bottom/go_fastUseItem/btn_useItem2")
  self.btn_useItem3 = self:GetControl("go_bottom/go_fastUseItem/btn_useItem3")
  self.btn_useItem4 = self:GetControl("go_bottom/go_fastUseItem/btn_useItem4")
  self.btn_useItem5 = self:GetControl("go_bottom/go_fastUseItem/btn_useItem5")
  self.go_defenseValue = self:GetControl("go_bottom/go_defenseValue")
  self.Fill_Protective = self:GetControl("go_bottom/go_defenseValue/left/Fill Area/Fill_Protective")
  self.lab_shieldNum = self:GetControl("go_bottom/go_defenseValue/left/Fill Area/lab_shieldNum")
  self.btn_defenseValueleft = self:GetControl("go_bottom/go_defenseValue/left/btn_defenseValueleft")
  self.Fill_ComboEnergy = self:GetControl("go_bottom/go_defenseValue/right/Fill_Area/Fill_ComboEnergy")
  self.lab_ComboEnergynun = self:GetControl("go_bottom/go_defenseValue/right/Fill_Area/lab_ComboEnergynun")
  self.btn_defenseValueright = self:GetControl("go_bottom/go_defenseValue/right/btn_defenseValueright")
  self.TalentStudy = self:GetControl("go_bottom/TalentStudy")
  self.LangHunHurtTip = self:GetControl("go_bottom/LangHunHurtTip")
  self.go_killBossExp = self:GetControl("go_bottom/go_killBossExp")
  self.go_static = self:GetControl("go_static")
  self.go_tips = self:GetControl("go_tips")
  self.lab_playerFightNum = self:GetControl("go_tips/player_fight/lab_playerFightNum")
  self.tx_playerFightName = self:GetControl("go_tips/player_fight/tx_playerFightName")
  self.player_attribute = self:GetControl("go_tips/player_attribute")
  self.tx_playerAttack = self:GetControl("go_tips/player_attribute/tx_playerAttack")
  self.btn_GoodComment = self:GetControl("go_right_top/go_activity/btn_GoodComment")
  self.btn_timeLimitGift = self:GetControl("go_left_top/go_left_topVertical/btn_timeLimitGift")
  self.lab_TimeLimit = self:GetControl("go_left_top/go_left_topVertical/btn_timeLimitGift/lab_time")
  self.btn_Master = self:GetControl("go_right_bottom/grid_funcBtn/btn_Master")
  self.btn_Holyspirit = self:GetControl("go_right_bottom/grid_funcBtn/btn_Holyspirit")
  self.btn_SpellSwordGift = self:GetControl("go_right_top/go_activity/btn_SpellSwordGift")
  self.btn_Leaguesiege = self:GetControl("go_right_top/go_activity/btn_Leaguesiege")
  self.btn_Runes = self:GetControl("go_right_bottom/grid_funcBtn/btn_Runes")
  self.btn_combineActivity = self:GetControl("go_right_top/go_activity/btn_combineActivity")
  self.btn_QuestionnaireWX = self:GetControl("go_right_top/go_activity/btn_QuestionnaireWX")
  self.btn_VipWX = self:GetControl("go_right_top/go_activity/btn_VipWX")
  self.btn_HolyRing = self:GetControl("go_right_bottom/grid_funcBtn/btn_HolyRing")
  self.btn_SmallGame = self:GetControl("go_right_top/go_activity/btn_SmallGame")
  self.img_holyRing_guide = self:GetControl("go_right/img_holyRing_guide")
  self.btn_WarAllianceRedBag = self:GetControl("go_right_top/go_activity/btn_WarAllianceRedBag")
  self.btn_LimitedTimeActivity = self:GetControl("go_left_top/go_left_topVertical/btn_LimitedTimeActivity")
  self.lab_LimitedTimeActivity = self:GetControl("go_left_top/go_left_topVertical/btn_LimitedTimeActivity/lab_rechargeInvestment")
  self.btn_SurpriseActivity = self:GetControl("go_left_top/go_left_topVertical/btn_SurpriseActivity")
  self.lab_rechargeInvestment = self:GetControl("go_left_top/go_left_topVertical/btn_SurpriseActivity/lab_rechargeInvestment")
  self.surpriseRechargeEffect = self:GetControl("go_left_top/go_left_topVertical/btn_SurpriseActivity/img_redPoint/Eff_UI_anniutishi05")
  self.surpriseRechargeRedPointImg = self:GetControl("go_left_top/go_left_topVertical/btn_SurpriseActivity/img_redPoint")
  self.icon_Surprise = self:GetControl("go_left_top/go_left_topVertical/btn_SurpriseActivity/icon_Surprise")
  self.btn_TianShiBaoKu = self:GetControl("go_right_top/go_activity/btn_TianShiBaoKu")
  self.btn_HolySkeleton = self:GetControl("go_right_bottom/grid_funcBtn/btn_HolySkeleton")
  self.btn_RewriteServerName = self:GetControl("go_right_top/go_activity/btn_RewriteServerName")
  self.btn_DemonHuntRank = self:GetControl("go_right_top/go_activity/btn_DemonHuntRank")
  self.btn_NewRunes = self:GetControl("go_right_bottom/grid_funcBtn/btn_NewRunes")
  self.btn_ClimbTower = self:GetControl("go_right_top/go_activity/btn_ClimbTower")
  self.btn_PcActivity = self:GetControl("go_right_top/go_activity/btn_PcActivity")
  self.btn_JingHePuzzle = self:GetControl("go_right_bottom/grid_funcBtn/btn_JingHePuzzle")
  self.btn_pandora = self:GetControl("go_right_top/go_activity/btn_pandora")
  self.btn_Enchant = self:GetControl("go_right_bottom/grid_funcBtn/btn_Enchant")
  self.btn_AnniversaryCelebration = self:GetControl("go_right_top/go_activity/btn_AnniversaryCelebration")
  self.btn_GoldenHunt = self:GetControl("go_right_top/go_activity/btn_GoldenHunt")
  self.btn_OtherWelfare = self:GetControl("go_right_top/go_activity/btn_OtherWelfare")
  self.btn_JoinVIP = self:GetControl("go_right_top/go_activity/btn_JoinVIP")
  self.btn_JoinVIPRedPoint = self:GetControl("go_right_top/go_activity/btn_JoinVIP/img_redPoint")
  self.btn_newPackDownload = self:GetControl("go_right_top/go_activity/btn_newPackDownload")
end

local funcTimer
local funcSwitchTime = 10

function Main_MainMenuUI:Init()
  self.modeContainer = {}
  self.meData = RoleManager.me.data
  self.go_right_top_pos = Vector3.zero
  self.go_bottom_pos = Vector3.zero
  self.go_top_pos = Vector3.zero
  self.go_left_pos = Vector3.zero
  self.go_right_pos = Vector3.zero
  self.go_left_bottom_pos = Vector3.zero
  self.go_right_bottom_pos = Vector3.zero
  self.go_left_top_pos = Vector3.zero
  self.go_right_top_pos = Vector3.zero
  self.go_right_Tip_pos = Vector3.zero
  self.go_center_pos = Vector3.zero
  self.go_center_top_pos = Vector3.zero
  self.funcPosTbl = {}
  self.activityState = true
  self.activityPosTbl = {}
  self.TempSubPanelNameList = {}
  self.EffExp = {}
  self.reqProto = false
  self.rechargeRedPointMsg = nil
  self.firstShow = true
  self.IsAttackBoss = false
  self.isPlay = false
  self.go_eliteBossAct = true
  self.go_eliteBossNeedRef = false
  self.go_eliteBossEff = false
  self.djsTimeTab = {}
  self.curSelecteliteBossDoc = nil
  self.rightMonsterListTemplate = nil
  QiJiHelperData.SettingData.AddBuffToTeammate = false
  TeamData.SetAutoInTeam(false)
end

function Main_MainMenuUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  UIUtility.RefreshAutoRoleMpHpSetting()
  self:RefreshDisableEntry()
end

function Main_MainMenuUI:RefreshDisableEntry()
  self._bagIsOpen = gameMgr:GetFunctionDisableManager():GetFunctionState(ServerDisableFunctionType.Bag_DisableState)
  self.btn_bag:SetActive(self._bagIsOpen)
  local funcState = gameMgr:GetFunctionDisableManager():GetFunctionState(ServerDisableFunctionType.FuncBtn_DisableState)
  if funcState == false and SkillData.MainMode == EMainModeType.Func then
    self:btn_funcOnClick()
  end
  self.btn_func:SetActive(funcState)
  local activityState = gameMgr:GetFunctionDisableManager():GetFunctionState(ServerDisableFunctionType.Go_Activity_DisableState)
  self.btn_shrink:SetActive(activityState)
  self.go_activity:SetActive(activityState)
  self._chatState = gameMgr:GetFunctionDisableManager():GetFunctionState(ServerDisableFunctionType.Main_ChatUI_DisableState)
  if self._chatState then
    self:ShowSubUI(UIID.MainChatUI, {
      parent = self.go_left.transform
    })
  else
    self:HideSubUI(UIID.MainChatUI)
  end
end

local function InitEliteBossControls(item)
  item.lab_monsterName = UIControl(item.transform, "lab_monsterName")
  item.lab_monsterOnKill = UIControl(item.transform, "lab_monsterOnKill")
  item.lab_monsterTime = UIControl(item.transform, "lab_monsterTime")
  item.bg = UIControl(item.transform, "bg")
  item.img_select = UIControl(item.transform, "img_select")
  item.Eff_UI_annuikuang03 = UIControl(item.transform, "Eff_UI_annuikuang03")
end

local function EliteBossRefresh(ctr, k, info, ui)
  local name = ClientTable.cfg_Monster_monsterManager:TryGetValue(info.bossID).name
  ctr.lab_monsterName:SetText(name)
  local act = info.list[1].state == 1 and "\196\144\225\186\191n" or ""
  ctr.lab_monsterOnKill:SetText(act)
  ctr.lab_monsterTime:SetText("")
  if ui.djsTimeTab[k] ~= nil then
    Timer.Stop(ui.djsTimeTab[k])
    ui.djsTimeTab[k] = nil
  end
  ctr.Eff_UI_annuikuang03:SetActive(k == 1 and ui.go_eliteBossEff)
  ctr.bg:SetActive(math.floor(k % 2) == 0)
  if info.list[1].state == 0 then
    local time = math.floor((info.list[1].reliveTime - Time.GetServerTime()) / 1000) or 0
    if 0 < time then
      do
        local timeStr = TimeUtility.ShowTimeWithColon(time)
        ctr.lab_monsterTime:SetText(timeStr)
        ui.djsTimeTab[k] = Timer.StartLoop(1, time, function()
          if time <= 0 then
            if ui.djsTimeTab[k] ~= nil then
              Timer.Stop(ui.djsTimeTab[k])
              ui.djsTimeTab[k] = nil
            end
            ctr.lab_monsterTime:SetText("")
          end
          time = time - 1
          local timeStrB = TimeUtility.ShowTimeWithColon(time)
          ctr.lab_monsterTime:SetText(timeStrB)
        end)
      end
    end
  end
  ctr.goPos = Vector2(tonumber(info.list[1].x), tonumber(info.list[1].y))
  ctr:SetOnClick(ui, ui.btn_GoGoldOnClick)
  ctr.img_select:SetActive(false)
end

function Main_MainMenuUI:InitUI()
  self:GoPosInit()
  self:SubPanelInit()
  self:InitUIFsmState()
  self:PKModeInit()
  self:EffInit()
  self.vipData = CommercializeData.ExchangeInfo()
  self.BtnAutoStartPos = self.btn_autoStart.transform.localPosition
  self.BtnAutoStopPos = self.btn_autoStop.transform.localPosition
  self.go_eliteBossPosX, _ = self.go_eliteBoss:GetAnchoredPosition()
  self.img_holyRing_guidePosX, _ = self.img_holyRing_guide:GetAnchoredPosition()
  self.guideCount = 0
  self.go_eliteBossTemp = UIContainer(self.img_monsterList, self, InitEliteBossControls, EliteBossRefresh)
  self.btn_GM:SetActive(QuickFind.LuaMainPlayerViewAttrData().level >= 50)
  self:BindExperienceBonusTemplate()
  self:BindBossExpTemplate()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_lifeLimitBuy
  })
  self.lab_LimitedTimeActivity:SetActive(false)
  self.btn_autoStopList = {
    CN = self.btn_autoStop,
    EN = self.btn_autoStop_EN,
    ID = self.btn_autoStop_ID,
    TH = self.btn_autoStop_TH,
    PH = self.btn_autoStop_PH
  }
end

function Main_MainMenuUI:InitCheckCanFouceUpdate()
  if not string.isNullOrEmpty(PlatformData.GetCanForceUpdateULR()) then
    self.btn_newPackDownload:SetActive(true)
  else
    self.btn_newPackDownload:SetActive(false)
  end
end

local function ModeOnCreate(ctr)
  ctr.lab_mode = UIControl(ctr.transform, "lab_mode")
end

local function ModeOnRefresh(ctr, _, data, ui)
  ctr.lab_mode:SetText(ERolePkModeStr[data])
  ctr.mode = ERolePkMode[data]
  ctr:SetOnClick(ui, ui.btn_selectModeOnClick)
end

local function sort(a, b)
  return a.sortid < b.sortid
end

function Main_MainMenuUI:ActivityPosRefresh()
  local topCfg = ConfigManager.GetConfigTable("cfg_Ui_rightTopZoom")
  table.sort(topCfg, sort)
  self.activityPosTbl = {}
  local initPos = C_UISettings.MainActivityInitPos
  local distance = C_UISettings.MainActivityDistance
  local Offsetleft = C_UISettings.MainActivityOffsetleft
  local MaxPos = C_UISettings.MainActivityMaxPos
  local index = 0
  local acc = 0
  for _, topUIInfo in pairs(topCfg) do
    local btnTrans = UIControl(self.go_activity.transform:Find(topUIInfo.btnName))
    if btnTrans:GetActive() and btnTrans.button.enabled then
      local localPosition
      if topUIInfo.sortid == 0 then
        localPosition = MaxPos
        acc = C_UISettings.MainActivityInitPosOut_x
      else
        local rows = Mathf.Floor(index / C_UISettings.MainActivityRowCount)
        local columns = index % C_UISettings.MainActivityRowCount
        localPosition = Vector3.New(initPos.x + rows * distance.x + columns * Offsetleft + acc, initPos.y + columns * distance.y, 0)
        index = index + 1
      end
      self.activityPosTbl[index] = {
        pos = localPosition,
        transCtr = btnTrans,
        orZoom = topUIInfo.orZoom == 1
      }
    end
  end
  for _, func in pairs(self.activityPosTbl) do
    func.transCtr:SetAnchoredPosition(func.pos.x, func.pos.y)
  end
end

function Main_MainMenuUI:SubPanelInit()
  self:ShowSubUI(UIID.TipFloatTipUI, {
    parent = self.go_tips.transform
  })
  self:ShowSubUI(UIID.TipFloatExpTipUI, {
    parent = self.go_bottom.transform
  })
  self:ShowSubUI(UIID.Tip_FloatTipTwoUI, {
    parent = self.go_static.transform
  })
  self:ShowSubUI(UIID.JoyStickUI, {
    parent = self.go_left_bottom.transform
  })
  self:ShowSubUI(UIID.MainSkillUI, {
    parent = self.go_right_bottom.transform
  })
  self:ShowSubUI(UIID.MiniMapUI, {
    parent = self.go_right_top.transform
  })
  self:ShowSubUI(UIID.InteractionUI, {
    parent = self.go_bottom.transform
  })
  self:ShowSubUI(UIID.MainChatUI, {
    parent = self.go_left.transform
  })
  self:ShowSubUI(UIID.Main_NoticeUI, {
    parent = self.go_static.transform
  })
  self:ShowSubUI(UIID.BubbleUI, {
    parent = self.go_bottom.transform
  })
  self:ShowSubUI(UIID.LeftTopPanelUI, {
    parent = self.go_left.transform
  })
  self:ShowSubUI(UIID.Buff, {
    parent = self.go_bottom.transform
  })
  self:ShowSubUI(UIID.TipAttrChangeUI, {
    parent = self.go_tips.transform
  })
  self:ShowSubUI(UIID.DragUI, {
    parent = self.go_static.transform
  })
  self:ShowSubUI(UIID.ShowTaskMonsterPage, {
    parent = self.go_center.transform
  })
  self:ShowSubUI(UIID.NpcInteraction, {
    parent = self.go_center.transform
  })
  self:ShowSubUI(UIID.Main_DownTipsUI, {
    parent = self.go_bottom.transform
  })
  self:ShowSubUI(UIID.Tip_duoqiScoreUI, {
    parent = self.go_tips.transform
  })
  self:ShowSubUI(UIID.Tip_FourPartyRivalryScoreUI, {
    parent = self.go_static.transform
  })
end

function Main_MainMenuUI:InitUIFsmState()
  local taskUIState = MainLeftTaskUIState(self)
  taskUIState:AddTransition(TransitionId.TtoR, StateID.RedFortUIStateID)
  taskUIState:AddTransition(TransitionId.TtoS, StateID.SiegeUIStateID)
  taskUIState:AddTransition(TransitionId.WtoS, StateID.WSiegeUIStateID)
  local redFortUIState = MainLeftRedFortUIState()
  redFortUIState:AddTransition(TransitionId.RtoT, StateID.TaskUIStateID)
  local siegeUIState = MainLeftSiegeUIState()
  siegeUIState:AddTransition(TransitionId.StoT, StateID.TaskUIStateID)
  local wolffortTaskUIState = MainLeftWolffortTaskUIState()
  wolffortTaskUIState:AddTransition(TransitionId.StoW, StateID.TaskUIStateID)
  local fourPartyRivalryTaskUIState = FourPartyRivalryTaskUIState(self)
  self.uiFsm = FSMSystem()
  self.uiFsm:AddState(taskUIState)
  self.uiFsm:AddState(redFortUIState)
  self.uiFsm:AddState(siegeUIState)
  self.uiFsm:AddState(wolffortTaskUIState)
  self.uiFsm:AddState(fourPartyRivalryTaskUIState)
end

function Main_MainMenuUI:GoPosInit()
  self.go_right_top_pos = self.go_right_top.transform.localPosition
  self.go_bottom_pos = self.go_bottom.transform.localPosition
  self.go_top_pos = self.go_top.transform.localPosition
  self.go_left_pos = self.go_left.transform.localPosition
  self.go_right_pos = self.go_right.transform.localPosition
  self.go_left_bottom_pos = self.go_left_bottom.transform.localPosition
  self.go_right_bottom_pos = self.go_right_bottom.transform.localPosition
  self.go_left_top_pos = self.go_left_top.transform.localPosition
  self.go_right_top_pos = self.go_right_top.transform.localPosition
  self.go_right_Tip_pos = self.go_right_Tip.transform.localPosition
  self.go_center_pos = self.go_center.transform.localPosition
  self.go_center_top_pos = self.go_center_top.transform.localPosition
  self.player_attribute_pos = self.player_attribute.transform.localPosition
end

function Main_MainMenuUI:FuncPosRefresh()
  self.funcPosTbl = {}
  local initPos = C_UISettings.MainFuncInitPos
  local distance = C_UISettings.MainFuncDistance
  local index = 0
  local objs = {}
  for i = 1, self.grid_funcBtn.transform.childCount do
    local trans = self.grid_funcBtn.transform:GetChild(i - 1)
    if trans.gameObject.activeSelf then
      table.insert(objs, trans)
    end
  end
  for i = 1, table.count(objs) do
    local rows = Mathf.Floor(index / C_UISettings.MainRowCount)
    local columns = index % C_UISettings.MainRowCount
    local localPosition = Vector3.New(initPos.x + rows * distance.x, initPos.y + columns * distance.y, 0)
    self.funcPosTbl[i] = {
      pos = localPosition,
      trans = objs[i].transform
    }
    index = index + 1
  end
  for _, func in pairs(self.funcPosTbl) do
    if SkillData.MainMode == EMainModeType.Skill then
      func.trans.localPosition = self.btn_fake.transform.localPosition
      func.trans.localScale = Vector3.zero
    else
      func.trans.localPosition = func.pos
      func.trans.localScale = Vector3.one
    end
  end
end

function Main_MainMenuUI:PKModeInit()
  self.modeContainer = UIContainer(self.btn_mode, self, ModeOnCreate, ModeOnRefresh)
end

function Main_MainMenuUI:OnShow()
  self:RegistEvents()
  self:RefreshTimeRechargeRedShow()
  self:Refresh()
  self:OnActiveMainUI(Event.Logic_ActiveMainUI, true)
  EventManager.Dispatch(Event.Role_OnArrive, RoleManager.me.cellPos)
  self:StartAutoF()
  self:RefreshRightList(SceneData.mapId)
  self:IsShowBlackHouseTime()
  self:RefreshExperienceBonusView()
  self:RefreshMemberTextView()
  self.mBossExpTemplate:Refresh(UnitType.BossExp)
  gameMgr:EnterGame()
  self:RefreshTimeLimitedActivitiesShowState()
  self:RefreshRechargeSurpriseIcon()
  self:RefreshActivityBtnImage()
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true then
    self:OnChangeRightTopBtn(nil, false)
  end
  if SpaceCrackUtility:CheckInSpaceCrackMap(SceneData.mapId) == true then
    self:OnChangeRightTopBtn(nil, false)
  end
  self:InitCheckCanFouceUpdate()
  self:CheckDownload()
  SiFangZhengBaController.OnReqUnionKuaFuGongChengZhanInfo()
  if FourPartyRivalryManager:CheckInFourPartyRivalryMap(SceneData.mapId) then
    self:DoFourPartyRivalryBeforeEntering()
  end
end

function Main_MainMenuUI:RefreshActivityBtnImage()
  if self.btn_HolidayActivity.gameObject.activeSelf then
    local image = ClientTable.cfg_Commerce_globalManager:TryGetValue(325001).effect
    self:SetSprite("Atlas_Main", image, self.btn_HolidayActivity)
  else
    local image = ClientTable.cfg_Commerce_globalManager:TryGetValue(325001).effect
    self:SetSprite("Atlas_Main", image, self.btn_HolidayActivity)
    self.btn_HolidayActivity:SetActive(false)
  end
end

function Main_MainMenuUI:RefreshTimeLimitedActivitiesShowStateByServeInfo()
  local isShow = CommercialTimeLimitedActivityData.IsShowMainMenuLimitedTimeActivityIconByServeInfo()
  self.btn_LimitedTimeActivity:SetActive(isShow)
  self.lab_LimitedTimeActivity:SetActive(false)
  if isShow then
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.TimeLimited_CollectWord
    })
  elseif UIManager.IsVisible(UIID.Commercial_LimitedTimeActivityUI) then
    UIManager.Hide(UIID.Commercial_LimitedTimeActivityUI)
  end
end

function Main_MainMenuUI:RefreshTimeLimitedActivitiesShowState()
  local isShow, openActivityNum = CommercialTimeLimitedActivityData.IsShowMainMenuLimitedTimeActivityIcon()
  self.btn_LimitedTimeActivity:SetActive(isShow)
  self.lab_LimitedTimeActivity:SetActive(false)
  local lid = ViewData.meData.id
  local showKey = lid .. "FucFirstShowTimeLimited"
  local numKey = lid .. "TimeLimitedOpenActivityNum"
  if isShow then
    local lastOpenActivityNum = PlayerPrefs.HasKey(numKey) and PlayerPrefs.GetInt(numKey) or 0
    PlayerPrefs.SetInt(numKey, openActivityNum)
    if PlayerPrefs.HasKey(showKey) == false or openActivityNum > lastOpenActivityNum and UIManager.IsVisible(UIID.Commercial_LimitedTimeActivityUI) == false then
      PlayerPrefs.SetInt(showKey, 1)
    end
    if PlayerPrefs.GetInt(showKey) == 1 then
      self:FirstChargeTimeLimitedActivity()
    end
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.TimeLimited_CollectWord
    })
  else
    local roleList = CommercialTimeLimitedActivityData.RoleList
    if not table.isNullOrEmpty(roleList) then
      for i, roleData in pairs(roleList) do
        local lid = roleData.info.roleId
        local showKey = lid .. "FucFirstShowTimeLimited"
        local numKey = lid .. "TimeLimitedOpenActivityNum"
        if PlayerPrefs.HasKey(showKey) then
          PlayerPrefs.DeleteKey(showKey)
        end
        if PlayerPrefs.HasKey(numKey) then
          PlayerPrefs.DeleteKey(numKey)
        end
      end
    end
    if UIManager.IsVisible(UIID.Commercial_LimitedTimeActivityUI) then
      UIManager.Hide(UIID.Commercial_LimitedTimeActivityUI)
    end
  end
end

function Main_MainMenuUI:RefreshReturnActivity()
  if not (ReturnActivityData and ReturnActivityData.HolidayTogSerInfo) or not ReturnActivityData.HolidayTogSerInfo.closeTime then
    self.btn_return:SetActive(false)
    return
  end
  local returnInfoTime = ReturnActivityData.HolidayTogSerInfo.closeTime
  local inActivity = returnInfoTime > Time.GetServerTime()
  local functionInfo = ClientTable.cfg_Function_functionManager:TryGetValue(4000014)
  local ReturnActivityShow = inActivity
  if functionInfo and functionInfo.condition then
    ReturnActivityShow = ConditionManager.Check4D(functionInfo.condition) and inActivity
  end
  self.btn_return:SetActive(ReturnActivityShow)
end

function Main_MainMenuUI:RefreshTimeRechargeRedShow()
  self.btn_timeLimitGift:GetChild("img_redPoint"):SetActive(true)
end

function Main_MainMenuUI:RefreshJY()
  if SceneData.CanShowByTable() and #SceneData.SmallIconData > 0 then
    self:Scene_SmallBossIcon()
  else
    self:SetRightListState(false)
  end
end

function Main_MainMenuUI:OnHide()
  for _, name in pairs(self.TempSubPanelNameList) do
    self:RemoveSubUI(name)
  end
  self.TempSubPanelNameList = {}
  if funcTimer then
    Timer.Stop(funcTimer)
    funcTimer = nil
  end
  self:StoppkModeTimer()
  if SkillData.MainMode ~= EMainModeType.Skill then
    SkillData.MainMode = EMainModeType.Skill
    EventManager.Dispatch(Event.Main_MainModeChanged)
  end
  self.reqProto = false
  self.uiFsm:SetState(StateID.TaskUIStateID)
  self:StopPromptBuyDrugTimer()
  self.btn_TaskSchool:SetActive(false)
  self.btn_Forecast:SetActive(false)
  self.go_defenseValue:GetChild("right/Fill_Area/Fill_ComboEnergy/Eff_UI_nengliangcao"):SetActive(false)
  self.lab_ComboEnergynun:SetActive(false)
  self.go_defenseValue:GetChild("right/Fill_Area/Eff_UI_nengliang_baokan"):SetActive(false)
  if self.mBossExpTemplate ~= nil then
    self.mBossExpTemplate:Destroy()
  end
  ReturnActivityData.DestroyReturnData()
end

function Main_MainMenuUI:OnDestroy()
  self.bagTip = nil
  self.downLoadTip = nil
  if self.mBossExpTemplate ~= nil then
    self.mBossExpTemplate:Destroy()
  end
end

local timer = 12
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode

function Main_MainMenuUI:Update()
  timer = timer + Time.deltaTime
  if 12 < timer then
    self:UpdateWifi()
    timer = 0
  end
  if Input.GetKeyDown(KeyCode.Tab) and LoginData.isWhite then
    UIManager.Show(UIID.GM_ToolUI)
  end
  if Input.GetKeyDown(KeyCode.F1) and LoginData.isWhite then
    UIManager.adapter_WindowCanvasUI.transform.localScale = Vector3.New(0, 0, 0)
  end
  if Input.GetKeyDown(KeyCode.F2) and LoginData.isWhite then
    UIManager.adapter_WindowCanvasUI.transform.localScale = Vector3.New(1, 1, 1)
  end
  self:UpdateNowTime()
end

local SitCellData = {}

function Main_MainMenuUI:RegistUIEvents()
  self.btn_bag:SetOnClick(self, self.btn_bagOnClick)
  self.btn_mail:SetOnClick(self, self.btn_mailOnClick)
  self.btn_skill:SetOnClick(self, self.Button_ClickSkill)
  self.btn_forgeNav:SetOnClick(self, self.btn_forgeNavOnClick)
  self.btn_qijiHelper:SetOnClick(self, self.btn_qijiHelperOnClick)
  self.btn_roleInfo:SetOnClick(self, self.btn_roleInfoOnClick)
  self.btn_guard:SetOnClick(self, self.btn_guardOnClick)
  self.btn_Combine:SetOnClick(self, self.btn_CombineOnClick)
  self.btn_GameBook:SetOnClick(self, self.btn_GameBookOnClick)
  self.btn_settings:SetOnClick(self, self.btn_settingsOnClick)
  self.btn_mount:SetOnClick(self, self.btn_mountOnClick)
  self.btn_rankList:SetOnClick(self, self.btn_rankListOnClick)
  self.btn_firstCharge:SetOnClick(self, self.btn_firstChargeOnClick)
  self.btn_firstActivity:SetOnClick(self, self.btn_firstActivityOnClick)
  self.btn_HolidayActivity:SetOnClick(self, self.btn_HolidayActivityOnClick)
  self.btn_return:SetOnClick(self, self.btn_returnOnClick)
  self.btn_Welfare:SetOnClick(self, self.btn_WelfareOnClick)
  self.btn_vvip:SetOnClick(self, self.btn_vvipOnClick)
  self.btn_TianKong:SetOnClick(self, self.btn_TianKongOnClick)
  self.btn_Tower:SetOnClick(self, self.btn_TowerOnClick)
  self.btn_shopExp:SetOnClick(self, self.btn_shopExpOnClick)
  self.btn_ActivityShow:SetOnClick(self, self.btn_ActivityShowOnClick)
  self.btn_TaskSchool:SetOnClick(self, self.btn_TaskSchoolOnClick)
  self.btn_Forecast:SetOnClick(self, self.btn_ForecastOnClick)
  self.btn_newMember:SetOnClick(self, self.btn_newMemberOnClick)
  self.btn_auctoin:SetOnClick(self, self.btn_auctoinOnClick)
  self.btn_warAlliance:SetOnClick(self, self.btn_warAllianceOnClick)
  self.btn_shop:SetOnClick(self, self.btn_shopOnClick)
  self.btn_kuafu:SetOnClick(self, self.btn_kuafuOnClick)
  self.btn_friends:SetOnClick(self, self.btn_friendsOnClick)
  self.btn_rechange:SetOnClick(self, self.btn_rechangeOnClick)
  self.btn_attackmode:SetOnClick(self, self.btn_attackModeOnClick)
  self.btn_func:SetOnClick(self, self.btn_funcOnClick)
  self.btn_instance:SetOnClick(self, self.btn_instanceOnClick)
  self.btn_instanceBoss:SetOnClick(self, self.btn_instanceBossOnClick)
  self.btn_siege:SetOnClick(self, self.btn_siegeOnClick)
  self.btn_shrink:SetOnClick(self, self.NewBtn_shrinkOnClick)
  self.btn_autoStart:SetOnClick(self, self.btn_autoAttackOnClick)
  self.btn_autoStop:SetOnClick(self, self.btn_autoStopOnClick)
  self.btn_autoPause:SetOnClick(self, self.btn_autoPauseOnClick)
  self.btn_SceneInteractive:SetOnClick(self, self.btn_SceneInteractiveOnClick)
  self.btn_SitInteractive:SetOnClick(self, self.OnStiButOnClick)
  self.btn_MonsterOffered:SetOnClick(self, self.btn_MonsterOfferedOnClick)
  self.btn_StarTask:SetOnClick(self, self.btn_StarTaskOnClick)
  self.btn_appearance:SetOnClick(self, self.btn_appearanceOnClick)
  self.btn_donwload:SetOnClick(self, self.btn_updateInRuntimeOnClick)
  self.btn_eliteBoss:SetOnClick(self, self.btn_eliteBossOnClick)
  self.btn_xiaoBoss:SetOnClick(self, self.btn_eliteBossOnClick)
  self.btn_GM:SetOnClick(self, self.btn_GMOnClick)
  self.btn_onHook:SetOnClick(self, self.BtnHookOnClick)
  self.btn_Exit:SetOnClick(self, self.BtnExitOnClick)
  self.btn_defenseValueleft:SetOnClick(self, self.btn_defenseValueleftOnClick)
  self.btn_defenseValueright:SetOnClick(self, self.btn_defenseValuerightOnClick)
  self.btn_customer:SetOnClick(self, self.btn_customerOnClick)
  self.btn_customer_sdk:SetOnClick(self, self.btn_customerSDKOnClick)
  self.btn_SpellFestival:SetOnClick(self, self.btn_SpellFestivalOnClick)
  self.btn_Signet:SetOnClick(self, self.btn_SignetOnClick)
  self.btn_BingJian:SetOnClick(self, self.btn_BingJianOnClick)
  self.btn_GoodComment:SetOnClick(self, self.btn_GoodCommentOnClick)
  self.btn_timeLimitGift:SetOnClick(self, self.btn_timeLimitGiftOnClick)
  self.btn_Master:SetOnClick(self, self.btn_MasterClick)
  self.btn_Holyspirit:SetOnClick(self, self.btn_HolyspiritOnClick)
  self.btn_SpellSwordGift:SetOnClick(self, self.btn_SpellSwordGiftOnClick)
  self.btn_combineActivity:SetOnClick(self, self.btn_combineActivityOnClick)
  self.btn_QuestionnaireWX:SetOnClick(self, self.btn_QuestionnaireWXOnClick)
  self.btn_VipWX:SetOnClick(self, self.btn_VipWXOnClick)
  self.btn_HolyRing:SetOnClick(self, self.btn_HolyRingOnClick)
  self.btn_HolySkeleton:SetOnClick(self, self.btn_HolySkeletonOnClick)
  self.btn_Leaguesiege:SetOnClick(self, self.btn_LeaguesiegeOnClick)
  self.btn_Runes:SetOnClick(self, self.btn_RunesOnClick)
  self.btn_SmallGame:SetOnClick(self, self.btn_SmallGameOnClick)
  self.btn_WarAllianceRedBag:SetOnClick(self, self.btn_WarAllianceRedBagOnClick)
  self:InitUseItemBtn()
  self.btn_LimitedTimeActivity:SetOnClick(self, self.btn_LimitedTimeActivityOnClick)
  self.btn_SurpriseActivity:SetOnClick(self, self.btn_SurpriseActivityOnClick)
  self.btn_TianShiBaoKu:SetOnClick(self, self.btn_TianShiBaoKuOnClick)
  self.btn_RewriteServerName:SetOnClick(self, self.btn_RewriteServerNameOnClick)
  self.btn_DemonHuntRank:SetOnClick(self, self.btn_DemonHuntRankOnClick)
  self.btn_NewRunes:SetOnClick(self, self.btn_NewRunesOnClick)
  self.btn_ClimbTower:SetOnClick(self, self.btn_ClimbTowerOnClick)
  self.btn_PcActivity:SetOnClick(self, self.btn_PcActivityOnClick)
  self.btn_JingHePuzzle:SetOnClick(self, self.btn_JingHePuzzleOnClick)
  self.btn_pandora:SetOnClick(self, self.btn_pandoraOnClick)
  self.btn_Enchant:SetOnClick(self, self.btn_EnchantOnClick)
  self.btn_AnniversaryCelebration:SetOnClick(self, self.btn_AnniversaryCelebrationOnClick)
  self.btn_GoldenHunt:SetOnClick(self, self.btn_GoldenHuntOnClick)
  self.btn_OtherWelfare:SetOnClick(self, self.btn_OtherWelfareOnClick)
  self.btn_JoinVIP:SetOnClick(self, self.btn_btn_JoinVIPOnClick)
  self.btn_newPackDownload:SetOnClick(self, self.btn_newPackDownloadOnClick)
end

function Main_MainMenuUI:btn_newPackDownloadOnClick()
  if not string.isNullOrEmpty(PlatformData.GetCanForceUpdateULR()) then
    Application.OpenURL(PlatformData.GetCanForceUpdateULR())
  end
end

function Main_MainMenuUI:btn_btn_JoinVIPOnClick()
  QuickFind:GetJoinVipManager():SetSendSaveData()
  UIManager.Show(UIID.JoinVIP)
end

function Main_MainMenuUI:btn_OtherWelfareOnClick()
  UIManager.Show(UIID.Activity_OtherWelfare)
end

function Main_MainMenuUI:btn_GoldenHuntOnClick()
  networkRequest.ReqActivityResult(5100002)
  networkRequest.ReqCountByType(260001)
  UIManager.Show(UIID.Task_EarlyGoldGameplay)
end

function Main_MainMenuUI:btn_EnchantOnClick()
  UIManager.Show(UIID.Enchant_NavUI)
end

function Main_MainMenuUI:btn_AnniversaryCelebrationOnClick()
  UIManager.Show(UIID.Commercial_AnniversaryCelebrationUI)
end

function Main_MainMenuUI:btn_pandoraOnClick()
  UIManager.Show(UIID.Commercial_PandoraActivityUI)
end

function Main_MainMenuUI:btn_PcActivityOnClick()
  UIManager.Show(UIID.Pc_ActivityUI)
end

function Main_MainMenuUI:btn_ClimbTowerOnClick()
  UIManager.Show(UIID.Instance_ClimbTowerUI)
end

function Main_MainMenuUI:btn_TianShiBaoKuOnClick()
  logPurple("Li\195\170n k\225\186\191t ngo\195\160i xyv3ios")
  local globalTable = ClientTable.cfg_Global_globalManager:TryGetValue(5000115)
  if globalTable and globalTable.effect then
    local url = globalTable.effect .. "&uid=%s&token=%s&sid=%s&gid=%s&rid=%s&rname=%s&rtype=%s"
    url = string.format(url, LoginData.sdkUserId, LoginData.token, LoginData.serverId, LoginData.gid, LoginData.roleId, CS.System.Uri.EscapeDataString(LoginData.roleName), ViewData.meData.career % 10)
    Application.OpenURL(url)
  end
end

function Main_MainMenuUI:btn_RewriteServerNameOnClick()
  UIManager.Show(UIID.Commercial_RewriteServerName)
end

function Main_MainMenuUI:btn_DemonHuntRankOnClick()
  UIManager.Show(UIID.DemonHunt_ListInfoUI)
end

function Main_MainMenuUI:BtnExitOnClick()
  UIManager.Show(UIID.Warning_TipsUI)
end

function Main_MainMenuUI:BtnHookOnClick()
  UIManager.Show(UIID.OnHook)
  EventManager.Dispatch(Event.GetOnHookInfo)
end

function Main_MainMenuUI:btn_customerOnClick()
  logPurple("CSKH")
  local globalTable = ClientTable.cfg_Global_globalManager:TryGetValue(4020014)
  if globalTable then
    Application.OpenURL(globalTable.effect)
  end
end

function Main_MainMenuUI:btn_SpellFestivalOnClick()
  local globalTable = ClientTable.cfg_Global_globalManager:TryGetValue(5000116)
  if globalTable then
    globalTable = globalTable.effect .. string.format("#/?uid=%s&token=%s&sid=%s&gid=%s&rid=%s&rname=%s&rtype=%s", LoginData.sdkUserId, LoginData.token, LoginData.serverId, LoginData.gid, LoginData.roleId, CS.System.Uri.EscapeDataString(LoginData.roleName), ViewData.meData.career)
    Application.OpenURL(globalTable)
  end
end

function Main_MainMenuUI:btn_customerSDKOnClick()
  logPurple("CSKH")
  DataToCSharpMgr.HelpServer()
end

function Main_MainMenuUI:btn_defenseValueleftOnClick(control)
  EventManager.Dispatch(Event.Buff_LJSDTips, {pos = "left"})
end

function Main_MainMenuUI:btn_defenseValuerightOnClick(control)
  EventManager.Dispatch(Event.Buff_LJSDTips, {pos = "right"})
end

function Main_MainMenuUI:btn_updateInRuntimeOnClick()
  local isReceive = PlayerPrefs.GetInt("CountDownReceive", 0) ~= 0
  if not UIManager.IsVisible(UIID.Download_GiftUI) and not isReceive then
    UIManager.Show(UIID.Download_GiftUI)
  end
end

function Main_MainMenuUI:btn_eliteBossOnClick()
  self.go_eliteBossAct = not self.go_eliteBossAct
  self.sw_eliteBossList:SetActive(self.go_eliteBossAct)
  self.Btns:SetActive(self.go_eliteBossAct)
  self:SetRightListState(self.go_eliteBossAct)
  self.btn_xiaoBoss:SetActive(not self.go_eliteBossAct)
  self.btn_eliteBoss:SetActive(self.go_eliteBossAct)
  local rot = self.go_eliteBossAct and 0 or 180
  self.Arrow:SetRotation(0, 0, rot)
  if self.rightMonsterListTemplate ~= nil and self.rightMonsterListTemplate.SetNormalizedPosition then
    self.rightMonsterListTemplate:SetNormalizedPosition()
  end
end

function Main_MainMenuUI:OnStiButOnClick()
  local index = math.random(#SitCellData)
  EventManager.Dispatch(Event.SceneInteractiveSitOnClick, SitCellData[index].cellPos)
  self.btn_SitInteractive.gameObject:SetActive(false)
end

function Main_MainMenuUI:InitUseItemBtn()
  self.useItems = {}
  for i = 1, 5 do
    local btn_useItem = self:GetControl("go_bottom/go_fastUseItem/btn_useItem" .. i)
    btn_useItem:SetOnClick(self, self.btn_itemOnClick)
    btn_useItem.itemCellData = ItemCellData()
    self.useItems[#self.useItems + 1] = btn_useItem
  end
end

function Main_MainMenuUI:btn_SceneInteractiveOnClick()
  self.btn_SceneInteractive.gameObject:SetActive(false)
  EventManager.Dispatch(Event.SceneInteractiveOnClick)
end

function Main_MainMenuUI:StoppkModeTimer(btn)
  if self.pkModeTimer then
    Timer.Stop(self.pkModeTimer)
    self.pkModeTimer = nil
  end
  self.grid_pkMode:SetActive(false)
  if btn then
    self.grid_pkMode.clickmun = 0
  end
end

function Main_MainMenuUI:CheckModeCanChange()
  local flag = true
  if TranScriptData.InTranscriptType == TranScriptType.BloodCastle or TranScriptData.InTranscriptType == TranScriptType.DemonPlaza or TranScriptData.InTranscriptType == TranScriptType.RefineTower then
    flag = false
    local str = "Trong ph\195\179 b\225\186\163n kh\195\180ng th\225\187\131 thay \196\145\225\187\149i ch\225\186\191 \196\145\225\187\153"
    FloatingWordUtility.QuickMsg(str)
  end
  if Activity_LangHunYaoSaiData.inActivity then
    flag = false
    FloatingTipUtility.QuickMsg("Ho\225\186\161t \196\145\225\187\153ng n\195\160y kh\195\180ng th\225\187\131 \196\145\225\187\149i ch\225\186\191 \196\145\225\187\153")
  end
  if Activity_LuoLanSiegeData.activityStatus == ActivityStatusEnum.RUNNING then
    flag = false
    FloatingTipUtility.QuickMsg("Trong th\225\187\157i gian C\195\180ng Th\195\160nh Chi\225\186\191n kh\195\180ng th\225\187\131 s\225\187\173a ch\225\186\191 \196\145\225\187\153 PK")
  end
  if SceneData.mapId == 1019001 then
    flag = false
    FloatingTipUtility.QuickMsg("Trong Ph\195\161o \196\144\195\160i \196\144\225\187\143 kh\195\180ng th\225\187\131 s\225\187\173a ch\225\186\191 \196\145\225\187\153 pk")
  end
  if TranScriptData.IsInRefineKSBattle() then
    flag = false
    FloatingTipUtility.QuickMsg("Trong Kh\225\187\145n Th\195\186 \196\144\225\186\165u kh\195\180ng th\225\187\131 \196\145\225\187\149i ch\225\186\191 \196\145\225\187\153 PK")
  end
  if FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    flag = false
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("fourPartyRivalryModeNotChange"))
  end
  return flag
end

function Main_MainMenuUI:GetPkMode()
  local pkMode = table.DeepCopy(ERolePkModeToString)
  local isKuaFuMap = SceneData.IsCrossRealm()
  if isKuaFuMap and ViewData.meData.unionCamp > 0 then
    table.remove(pkMode, 3)
  else
    table.remove(pkMode, 4)
  end
  if Activity_LuoLanSiegeData.activityStatus == ActivityStatusEnum.RUNNING and RoleManager.me.unionId ~= 0 then
    if RoleManager.me.unionId == Activity_LuoLanSiegeData.holdUnionId then
      table.insert(pkMode, "SiegeDefense")
    else
      table.insert(pkMode, "SiegeAttack")
    end
  end
  return pkMode
end

function Main_MainMenuUI:btn_attackModeOnClick()
  RiskSpotManager.RiskSpotPlaceType(RiskSpotType.SwitchAttackModer)
  if not self:CheckModeCanChange() then
    return
  end
  if self.grid_pkMode.clickmun == 1 then
    self:StoppkModeTimer(true)
    return
  end
  self.grid_pkMode.clickmun = 1
  self:StoppkModeTimer()
  local timer = 10
  
  local function OnpkMode(ui)
    if timer == 0 then
      ui:StoppkModeTimer(true)
    else
      timer = timer - 1
    end
  end
  
  self.pkModeTimer = Timer.StartLoopForever(1, OnpkMode, self)
  self.grid_pkMode:SetActive(true)
  self.modeContainer:SetData(self:GetPkMode())
end

function Main_MainMenuUI:btn_funcOnClick()
  self:AppearBtnShowOrHide()
  if SkillData.MainMode == EMainModeType.Skill then
    SkillData.MainMode = EMainModeType.Func
  else
    SkillData.MainMode = EMainModeType.Skill
  end
  RiskSpotManager.RiskSpotPlaceType(RiskSpotType.SwitchFunction)
  EventManager.Dispatch(Event.Main_MainModeChanged)
  EventManager.Dispatch(Event.Recharge_FreePrizeTip, RechargeData.FreePrizeRefresh())
  self:RedPointBubbleBtnFuncOnClick()
end

function Main_MainMenuUI:TaskNavBtn_funcOnClick()
  if SkillData.MainMode == EMainModeType.Skill then
    self:btn_funcOnClick()
  else
    EventManager.Dispatch(Event.Main_MainModeChanged)
    EventManager.Dispatch(Event.Recharge_FreePrizeTip, RechargeData.FreePrizeRefresh())
    self:RedPointBubbleBtnFuncOnClick()
  end
end

function Main_MainMenuUI:TaskNavBtn_funcOnClick()
  if SkillData.MainMode == EMainModeType.Skill then
    self:btn_funcOnClick()
  else
    EventManager.Dispatch(Event.Main_MainModeChanged)
  end
end

function Main_MainMenuUI:btn_instanceOnClick()
  UIManager.Show(UIID.Instance_InstanceUI)
end

function Main_MainMenuUI:btn_instanceBossOnClick()
  UIManager.Show(UIID.Instance_BossUI)
  TipUtility.GetSessionTips()
end

function Main_MainMenuUI:btn_siegeOnClick()
  NetManager.Send(ActivityMessage.ReqGetLuoLanXiaGuGongChengActivityWinUnion)
end

function Main_MainMenuUI:btn_selectModeOnClick(ctr)
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true then
    FloatingTipUtility.QuickMsg(QuickFind:GetDuoQiCrossDataManager():GetCanNotOperateStr())
    return
  end
  self:StoppkModeTimer()
  if RoleManager.me.evilLevel ~= EvilRoleType.Level0 and ctr.mode == ERolePkMode.Peace then
    FloatingTipUtility.QuickMsg("Tr\225\186\161ng th\195\161i t\195\170n \196\145\225\187\143 kh\195\180ng th\225\187\131 \196\145\225\187\149i th\195\160nh ch\225\186\191 \196\145\225\187\153 h\195\178a b\195\172nh")
    return
  end
  NetManager.Send(RoleMessage.ReqSetPKMode, {
    param = ctr.mode
  })
  EventManager.Dispatch(Event.CloseKillMonsterCard)
end

function Main_MainMenuUI:btn_GoGoldOnClick(ctr)
  if self.curSelecteliteBossDoc ~= nil then
    self.curSelecteliteBossDoc.img_select:SetActive(false)
    self.curSelecteliteBossDoc = nil
  end
  self.curSelecteliteBossDoc = ctr
  if self.curSelecteliteBossDoc.Eff_UI_annuikuang03:GetActive() then
    self.go_eliteBossEff = false
    self.curSelecteliteBossDoc.Eff_UI_annuikuang03:SetActive(false)
  end
  self.curSelecteliteBossDoc.img_select:SetActive(true)
  PathFinderManager.pathFinding.Reset()
  PathFinderManager.JumpMapToMoveToPos(SceneData.groupId, ctr.goPos, nil, nil, nil, nil, function()
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
  end, nil, true)
end

function Main_MainMenuUI:btn_bagOnClick()
  UIManager.Show(UIID.NewBagInfoUI)
end

function Main_MainMenuUI:btn_MedicinalOnClick()
  UIManager.Show(UIID.PromptTipUI, {
    title = string.GetColorText("Nh\225\186\175c nh\225\187\159", "#000000FF"),
    textContent = string.GetColorText("D\225\187\139ch chuy\225\187\131n kh\195\180ng", "#000000FF"),
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      local mapData = {mapId = 100158}
      EventManager.Dispatch(Event.Map_ChangeMap, mapData)
      UIManager.JumpShow(UIPanelType.SortAndHide, UIID.BagShopInfoUI)
    end
  })
end

function Main_MainMenuUI:btn_rankListOnClick()
  UIManager.Show(UIID.Rank_ListInfoUI)
end

function Main_MainMenuUI:btn_firstChargeOnClick()
  if UIManager.IsVisible(UIID.FirstChargeRecom) then
    UIManager.Hide(UIID.FirstChargeRecom)
    UIManager.UICloseType(UIPanelType.SortAndHide, true)
  end
  UIManager.Show(UIID.Recharge_FirstChargeUI, {
    PayType = BusinessPayType.Main_First
  })
end

function Main_MainMenuUI:btn_firstActivityOnClick()
  UIManager.Show(UIID.CommercializationActivityUI)
end

function Main_MainMenuUI:btn_HolidayActivityOnClick()
  UIManager.Show(UIID.Commercial_HolidayActivityUI)
end

function Main_MainMenuUI:btn_returnOnClick()
  UIManager.Show(UIID.Commercial_ReturnActivityUI)
end

function Main_MainMenuUI:btn_WelfareOnClick()
  UIManager.Show(UIID.RechargeWelfareUI, {
    PayType = BusinessPayType.Welfare_Recharge
  })
  EventManager.Dispatch(Event.KoreaSDKClienAirbrigeAndFirebase, {
    type = KoreaSDKEnum.redstore_click,
    param = "",
    reason = "",
    node = KoreaSDKNodeEnum.firebase
  })
end

function Main_MainMenuUI:btn_vvipOnClick()
  UIManager.Show(UIID.Vip_MemberUI, {
    red = CommercializeData.Vip_VipRedRoint
  })
end

function Main_MainMenuUI:btn_TianKongOnClick()
  UIManager.Show(UIID.ActivityTiankongmigeUI)
end

function Main_MainMenuUI:btn_TowerOnClick()
  UIManager.Show(UIID.Instance_TowerUI)
end

function Main_MainMenuUI:btn_shopExpOnClick()
  if UIManager.IsVisible(UIID.ExpUpRecom) then
    UIManager.Hide(UIID.ExpUpRecom)
    UIManager.UICloseType(UIPanelType.SortAndHide, true)
  end
  UIManager.Show(UIID.Shop_ExpUpUI)
  self.firstShow = false
  self:SetMultipleEffActive()
end

function Main_MainMenuUI:btn_ActivityShowOnClick()
  NetManager.Send(RoleMessage.ReqActiveAndFind)
end

function Main_MainMenuUI:btn_TaskSchoolOnClick()
  UIManager.Show(UIID.Task_SchoolUI)
end

function Main_MainMenuUI:btn_ForecastOnClick(control)
  local Gropu = control.data and control.data.group or 1
  UIManager.Show(UIID.System_ForecastUI, {group = Gropu})
end

function Main_MainMenuUI:btn_newMemberOnClick()
  UIManager.Show(UIID.Vip_NewMemberMainUI)
end

function Main_MainMenuUI:btn_auctoinOnClick()
  UIManager.Show(UIID.Auction_AuctionUI)
end

function Main_MainMenuUI:btn_warAllianceOnClick()
  UIManager.Show(UIID.WarAlliance_menuUI)
end

function Main_MainMenuUI:btn_shopOnClick()
  UIManager.Show(UIID.Shop)
  EventManager.Dispatch(Event.KoreaSDKClienAirbrigeAndFirebase, {
    type = KoreaSDKEnum.store_click,
    param = "",
    reason = "",
    node = KoreaSDKNodeEnum.firebase
  })
end

function Main_MainMenuUI:btn_kuafuOnClick()
  UIManager.Show(UIID.CrossServer_IntoUI)
end

function Main_MainMenuUI:btn_MonsterOfferedOnClick()
  self.allTaskInfo = TaskData.GetAllMonsterLevelTasks()
  if self.allTaskInfo == nil then
    FloatingTipUtility.QuickMsg("Hi\225\187\135n ch\198\176a nh\225\186\173n Nhi\225\187\135m V\225\187\165 Treo Th\198\176\225\187\159ng n\195\160o")
    return
  end
  UIManager.Show(UIID.Task_TaskReward_New)
end

function Main_MainMenuUI:btn_StarTaskOnClick()
  UIManager.Show(UIID.Task_TaskStart)
end

function Main_MainMenuUI:btn_mailOnClick()
  NetManager.Send(MailMessage.ReqGetMailList)
  UIManager.Show(UIID.MailUI)
end

function Main_MainMenuUI:Button_ClickSkill()
  UIManager.Show(UIID.SkillUI)
end

function Main_MainMenuUI:btn_forgeNavOnClick()
  self:FuncPosRefresh()
  UIManager.Show(UIID.Equip_ForgeNavUi)
end

function Main_MainMenuUI:btn_roleInfoOnClick()
  UIManager.Show(UIID.Role_AttributeUI, {FristPanelUI = true})
end

function Main_MainMenuUI:btn_guardOnClick()
  UIManager.Show(UIID.Equip_GuardNavUI)
end

function Main_MainMenuUI:btn_CombineOnClick()
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Combine_Carry, true) == false then
    return
  end
  UIManager.Show(UIID.Item_CombineUI, {npcConfigID = 1004005})
end

function Main_MainMenuUI:btn_GameBookOnClick()
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.GameBook, true) == false then
    return
  end
  UIManager.Show(UIID.System_GameBookUI)
end

function Main_MainMenuUI:btn_SignetOnClick()
  UIManager.Show(UIID.Equip_SignetUI)
end

function Main_MainMenuUI:btn_BingJianOnClick()
  UIManager.Show(UIID.Bag_EquipInfoAngelUI)
end

function Main_MainMenuUI:btn_equipUIOnClick()
  UIManager.Show(UIID.Bag_EquipInfoUI)
end

function Main_MainMenuUI:btn_settingsOnClick()
  UIManager.Show(UIID.PreferenceUI)
end

function Main_MainMenuUI:btn_qijiHelperOnClick()
  UIManager.Show(UIID.Preference_QiJiHelperUI)
end

function Main_MainMenuUI:btn_mountOnClick()
  UIManager.Show(UIID.MountUI)
end

function Main_MainMenuUI:btn_GMOnClick()
  UIManager.Show(UIID.InvestigationUI)
end

function Main_MainMenuUI:btn_friendsOnClick()
  UIManager.Show(UIID.Friend_FriChatUI)
end

function Main_MainMenuUI:btn_appearanceOnClick()
  if ClientTable.cfg_Global_globalManager:CheckHideAppearanceByCurMap() then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Appearance_1"))
    return
  end
  UIManager.Show(UIID.AppearBagInfoUI)
end

function Main_MainMenuUI:btn_rechangeOnClick()
  print("\229\188\128\230\156\141\229\164\169\230\149\176" .. LoginData.GetOpenServerDay())
  if LoginData.GetOpenServerDay() <= 7 then
    UIManager.Show(UIID.Friend_FriChatUI)
  end
  UIManager.Show(UIID.Recharge_RechargeUI)
end

function Main_MainMenuUI:btn_autoAttackOnClick(control)
  if Scene.IsSafeZone(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y) then
    local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("AutoAttack_safetyTips")
    FloatingTipUtility.QuickMsg(title)
    return
  end
  RoleManager.me:SetAutoFight(AutoFightStrKey.AutoFight)
  AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.AutoFight)
  EventManager.Dispatch(Event.CloseKillMonsterCard)
end

function Main_MainMenuUI:btn_autoStopOnClick(control)
  EventManager.Dispatch(Event.CloseKillMonsterCard)
  RoleManager.me:SetAutoFight(AutoFightStrKey.None)
  AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.AutoFight)
  self.btn_autoStop:SetActive(QiJiHelperData.isAutoFight)
  self.btn_autoStart:SetActive(not QiJiHelperData.isAutoFight)
  self.btn_autoPause:SetActive(false)
end

function Main_MainMenuUI:btn_autoPauseOnClick(control)
  RoleManager.me:SetAutoFight(AutoFightStrKey.None)
  AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.AutoFight)
  EventManager.Dispatch(Event.CloseKillMonsterCard)
end

function Main_MainMenuUI:btn_itemOnClick(control)
  if not control.id or control.id == 0 or BagInfoData.GetItemCountByItemConfigId(control.id) == 0 then
    if ClientTable.cfg_Global_globalManager:CheckHideAppearanceByCurMap() then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Activity_kunshou_12"))
      return
    end
    UIManager.Show(UIID.Skill_SetSkillUI, {showItem = true})
    return
  end
  local item = BagInfoData.GetFirstItemTblByConfigId(control.id)
  if not item then
    return
  end
  if ItemUtility.IsCanUseItemCd(item.itemId) then
    return
  end
  local useItemTbl = {
    useCount = 1,
    useItemId = item.id,
    configId = item.itemId,
    useParam = item.tblItem.useParam,
    useParamExtend = item.tblItem.useParamExtend,
    params = nil
  }
  ItemUtility.UseItem(useItemTbl)
end

local shrinking = false
local completeCount = 0
local totalAnimation = 0
local PreviousState = false

local function shrinkComplete()
  completeCount = completeCount + 1
  if totalAnimation == completeCount then
    shrinking = false
  end
end

function Main_MainMenuUI:btn_GoodCommentOnClick()
  UIManager.Show(UIID.Activity_GoodCommentUI)
end

function Main_MainMenuUI:btn_timeLimitGiftOnClick()
  UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 6})
  if self.btn_timeLimitGift:GetChild("img_redPoint"):GetActive() then
    self.btn_timeLimitGift:GetChild("img_redPoint"):SetActive(false)
  end
end

function Main_MainMenuUI:btn_LimitedTimeActivityOnClick()
  if self.TimeLimitedActivityEffect then
    self.TimeLimitedActivityEffect:SetActive(false)
  end
  UIManager.Show(UIID.Commercial_LimitedTimeActivityUI)
  PlayerPrefs.SetInt(ViewData.meData.id .. "FucFirstShowTimeLimited", 0)
end

function Main_MainMenuUI:btn_MasterClick()
  if self.MasterEffect and self.MasterEffect:GetActive() then
    self.MasterEffect:SetActive(false)
  end
  UIManager.Show(UIID.MasterSkill_newMainUI)
end

function Main_MainMenuUI:btn_HolyspiritOnClick()
  if self.HolyspiritEffect and self.HolyspiritEffect:GetActive() then
    self.HolyspiritEffect:SetActive(false)
  end
  UIManager.Show(UIID.Equip_HolySpiritLeftUI)
end

function Main_MainMenuUI:btn_SpellSwordGiftOnClick()
  UIManager.Show(UIID.Commercial_SpellSwordGiftUI)
end

function Main_MainMenuUI:btn_combineActivityOnClick()
  UIManager.Show(UIID.Commercial_CombineActivityUI)
end

function Main_MainMenuUI:btn_QuestionnaireWXOnClick()
  UIManager.Show(UIID.Activity_GoodCommentWxUI)
end

function Main_MainMenuUI:btn_VipWXOnClick()
  UIManager.Show(UIID.Recharge_SuperVipUI)
end

function Main_MainMenuUI:btn_LeaguesiegeOnClick()
  UIManager.Show(UIID.Activity_LeagueSiegeUI)
end

function Main_MainMenuUI:btn_RunesOnClick()
  if self.RuneEffect and self.RuneEffect:GetActive() then
    self.RuneEffect:SetActive(false)
  end
  UIManager.Show(UIID.Equip_RunesNavUI)
end

function Main_MainMenuUI:btn_NewRunesOnClick()
  if self.NewRuneEffect and self.NewRuneEffect:GetActive() then
    self.NewRuneEffect:SetActive(false)
  end
  UIManager.Show(UIID.Equip_RunesNavNewUI)
end

function Main_MainMenuUI:btn_HolyRingOnClick()
  if self.HolyRingEffect and self.HolyRingEffect:GetActive() then
    self.HolyRingEffect:SetActive(false)
    self:HideGuideArrow()
  end
  UIManager.Show(UIID.Equip_HolyRingNavUi)
end

function Main_MainMenuUI:btn_HolySkeletonOnClick()
  if self.HolySkeletonEffect and self.HolySkeletonEffect:GetActive() then
    self.HolySkeletonEffect:SetActive(false)
    self:HideGuideArrow()
  end
  UIManager.Show(UIID.Equip_HolySkeletonNavUi)
end

function Main_MainMenuUI:btn_SmallGameOnClick()
  if self.btn_SmallGame and self.btn_SmallGame:GetActive() then
    UIManager.Show(UIID.System_SmallGameUI)
  end
end

function Main_MainMenuUI:btn_WarAllianceRedBagOnClick()
  if WarAllianceData.IsHaveUnion == false then
    FloatingTipUtility.QuickMsg("Ch\198\176a gia nh\225\186\173p Guild, h\195\163y gia nh\225\186\173p Guild tr\198\176\225\187\155c")
    return
  end
  if not UIManager.IsVisible(UIID.Activity_WarAllianceRedBagUI) then
    UIManager.Show(UIID.Activity_WarAllianceRedBagUI)
  end
end

function Main_MainMenuUI:BossHpUI_ShowHide(_, show)
  if show then
    if self.activityState then
      self:NewBtn_shrinkOnClick()
      PreviousState = true
    else
      PreviousState = false
    end
  elseif PreviousState ~= self.activityState then
    self:NewBtn_shrinkOnClick()
  end
end

function Main_MainMenuUI:SceneDataChange(msgId, mapId)
  if SceneData.resName == 1001 and not self.activityState then
    self:NewBtn_shrinkOnClick()
  end
  self:RefreshRightList(mapId)
end

function Main_MainMenuUI:NewBtn_shrinkOnClick()
  if self.isRightTopButtonRefresh then
    return
  end
  self.isRightTopButtonRefresh = true
  self.activityState = not self.activityState
  EventManager.Dispatch(Event.Main_UpdateMainUIShrink, self.activityState)
  self:RightTopButtonRefresh(1)
  local needFadeCount = 0
  local isShowRedPoint = false
  for index, activityInfo in pairs(self.activityPosTbl) do
    if activityInfo.orZoom then
      needFadeCount = needFadeCount + 1
    end
    if self.activityState then
      if self.btn_shrink:GetChild("img_redPoint"):GetActive() then
        self.btn_shrink:GetChild("img_redPoint"):SetActive(false)
      end
    elseif not isShowRedPoint then
      local name = activityInfo.transCtr:GetName()
      if name == "btn_firstCharge" or name == "btn_Welfare" or name == "btn_firstActivity" or name == "btn_HolidayActivity" then
        local red = activityInfo.transCtr:GetChild("img_redPoint")
        if red and red:GetActive() then
          isShowRedPoint = true
          self.btn_shrink:GetChild("img_redPoint"):SetActive(true)
        end
      end
    end
  end
  local completeCount = 0
  
  local function PosRefresh()
    completeCount = completeCount + 1
    if not self.activityState and completeCount == needFadeCount then
      self:RightTopButtonRefresh(3)
    end
    self.isRightTopButtonRefresh = false
  end
  
  local rows, devX, alpha, enabled
  for index, activityInfo in pairs(self.activityPosTbl) do
    if self.activityState then
      rows = Mathf.Floor(index / C_UISettings.MainActivityRowCount)
      devX = C_UISettings.MainActivityDevNegative
      alpha = 1
      enabled = true
    else
      rows = Mathf.Floor((totalAnimation - index) / C_UISettings.MainActivityRowCount)
      devX = C_UISettings.MainActivityDev
      alpha = 0
      enabled = false
    end
    local quence = DOTween.Sequence()
    if activityInfo.orZoom then
      activityInfo.transCtr.button.enabled = enabled
      activityInfo.transCtr.image.enabled = enabled
      quence:Append(activityInfo.transCtr.canvasGroup:DOFade(alpha, C_UISettings.MainActivityPopTime)):OnComplete(PosRefresh)
    end
  end
  local tempScale = self.activityState and Vector3.one or Vector3(-1, 1, 1)
  self.btn_shrink:SetScale(tempScale)
end

function Main_MainMenuUI:btn_shrinkOnClick()
  if shrinking then
    return
  end
  shrinking = true
  completeCount = 0
  totalAnimation = #self.activityPosTbl + 1
  self.activityState = not self.activityState
  if self.activityState then
    self:ActivityPosRefresh(true)
    for index, activityInfo in pairs(self.activityPosTbl) do
      if activityInfo.transCtr.canvasGroup.alpha == 0 then
        activityInfo.transCtr:SetActive(true)
      end
    end
  end
  local offset = 2
  local rows, devX, alpha, enabled
  for index, activityInfo in pairs(self.activityPosTbl) do
    if self.activityState then
      rows = Mathf.Floor(index / C_UISettings.MainActivityRowCount)
      devX = C_UISettings.MainActivityDevNegative
      alpha = 1
      enabled = true
    else
      rows = Mathf.Floor((totalAnimation - index) / C_UISettings.MainActivityRowCount)
      devX = C_UISettings.MainActivityDev
      alpha = 0
      enabled = false
    end
    local quence = DOTween.Sequence()
    local delayTime = rows * C_UISettings.MainActivityInterval
    quence:AppendInterval(delayTime)
    quence:Append(activityInfo.transCtr.transform:DOLocalMove(activityInfo.pos + devX, GameSettingsData.C_UISettings):SetEase(Ease.InBack))
    quence:Append(activityInfo.transCtr.transform:DOLocalMove(activityInfo.pos, C_UISettings.MainActivityPopTime):SetEase(Ease.OutSine)):OnComplete(shrinkComplete)
    if activityInfo.orZoom then
      if not self.activityState and 0 < activityInfo.transCtr.transform.childCount and activityInfo.transCtr:GetChild("img_redPoint"):GetActive() then
        offset = offset + 1
      else
        quence:Insert(C_UISettings.MainActivityPushTime / 2 + delayTime, activityInfo.transCtr.canvasGroup:DOFade(alpha, C_UISettings.MainActivityPopTime))
        activityInfo.transCtr.button.enabled = enabled
      end
    end
  end
  local waitTime = (table.count(self.activityPosTbl) - offset) * C_UISettings.MainActivityInterval
  Coroutine.Start(function()
    Coroutine.Wait(waitTime)
    if not self.activityState then
      for index, activityInfo in pairs(self.activityPosTbl) do
        if activityInfo.transCtr.canvasGroup.alpha == 0 then
          activityInfo.transCtr:SetActive(false)
        end
      end
      self:ActivityPosRefresh()
    end
  end)
  local tempScale = self.activityState and Vector3.one or Vector3(-1, 1, 1)
  self.btn_shrink:SetScale(tempScale)
end

function Main_MainMenuUI:RegistEvents()
  self:RegistEvent(Event.Main_MainModeChanged, self.OnModeChanged, self)
  self:RegistEvent(Event.Logic_ActiveMainUI, self.OnActiveMainUI, self)
  self:RegistEvent(Event.Role_MyLvChanged, self.OnRole_MyLvChanged, self)
  self:RegistEvent(Event.Role_MyExpChanged, self.OnRole_MyExpChanged, self)
  self:RegistEvent(Event.Role_RefreshHp, self.OnRole_MyHPChanged, self)
  self:RegistEvent(Event.Role_RefreshMp, self.OnRole_MyMPChanged, self)
  self:RegistEvent(Event.Role_RefreshShield, self.OnRole_MyShieldChanged, self)
  self:RegistEvent(Event.Role_MyAttributeChanged, self.On_RoleAttributeChanged, self)
  self:RegistEvent(Event.Role_AutoFightChange, self.AutoFightChange, self)
  self:RegistEvent(Event.SetIsExpShow, self.SetIsExpShow, self)
  self:RegistEvent(Event.QiJiHelper_OpenAutoFight, self.QiJiHelperOpenAutoFight, self)
  self:RegistEvent(Event.Mail_ResNewMail, self.OnResNewMail, self)
  self:RegistEvent(Event.PKModeChanged, self.OnPKModeChanged, self)
  self:RegistEvent(Event.Bag_ResBagInfo, self.RefreshBag, self)
  self:RegistEvent(Event.Bag_FullState, self.OnBagFullState, self)
  self:RegistEvent(Event.Main_SetItem, self.RefreshUseItem, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshBag, self)
  self:RegistEvent(Event.UpdateCd, self.RefreshSameItemIdCd, self)
  self:RegistEvent(Event.OpenSiegeTaskUI, self.OpenSiegeTaskUI, self)
  self:RegistEvent(Event.OpenActivityListUI, self.OpenActivityListUI, self)
  self:RegistEvent(Event.Recharge_FreePrizeTip, self.SetRechargeButtonTip, self)
  self:RegistEvent(Event.SetSceneInteractiveState, self.SetSceneInteractiveState, self)
  self:RegistEvent(Event.SceneInteractiveSit, self.SceneInteractiveSitActive, self)
  self:RegistEvent(Event.RedFortEntered, self.ShowRedFortUI, self)
  self:RegistEvent(Event.RedFortQuit, self.HideRedFortUI, self)
  self:RegistEvent(Event.EnterSiege, self.ShowSiegeUI, self)
  self:RegistEvent(Event.QuitSiege, self.HideSiegeUI, self)
  self:RegistEvent(Event.EnterWolffortSiege, self.EnterWolffortSiege, self)
  self:RegistEvent(Event.QuitWolffortSiege, self.QuitWolffortSiege, self)
  self:RegistEvent(Event.PutOnEquip, self.AppearBtnShowOrHide, self)
  self:RegistEvent(Event.TakeOffEquip, self.AppearBtnShowOrHide, self)
  self:RegistEvent(Event.Guard_InfoChange, self.AppearBtnShowOrHide, self)
  self:RegistEvent(Event.Task_Update, self.RefreshTask, self)
  self:RegistEvent(Event.BossHpUI_ShowHide, self.BossHpUI_ShowHide, self)
  self:RegistEvent(Event.MainBtnPosRefresh, self.BtnPosRefresh, self)
  self:RegistEvent(Event.Fuc_FirstShow, self.Fuc_FirstShow, self)
  self:RegistEvent(Event.StartAttack, self.OnCloseRightTopButton, self)
  self:RegistEvent(Event.OnOpenRightTopBtn, self.OnOpenRightTopButton, self)
  self:RegistEvent(Event.ChangeRightTopBtn, self.OnChangeRightTopBtn, self)
  self:RegistEvent(Event.SelectMonster, self.SelectMonster, self)
  self:RegistEvent(Event.ShowAutoFightEffect, self.ShowAutoFightEffect, self)
  self:RegistEvent(Event.Role_OnMove, self.CloseExpShowUI, self)
  self:RegistEvent(Event.Task_ClickFuncOnClick, self.TaskNavBtn_funcOnClick, self)
  self:RegistEvent(Event.Scene_SceneDataChange, self.SceneDataChange, self)
  self:RegistEvent(Event.Main_UpdateBattery, self.UpdateBattery, self)
  self:RegistEvent(Event.CountPackageDownload, self.refreshDownload, self)
  self:RegistEvent(Event.Commer_NewVip, self.RefreshVipRedPoint, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.RefreshVipRedPoint, self)
  self:RegistEvent(Event.Scene_SmallBossIcon, self.Scene_SmallBossIcon, self)
  self:RegistEvent(Event.Task_ClickGoldOnClick, self.Scene_SmallBossIconEffect, self)
  self:RegistEvent(Event.Role_OnChangeMap, self.OnMapChange, self)
  self:RegistEvent(Event.Scene_SmallBossShow, self.Scene_SmallBossShow, self)
  self:RegistEvent(Event.Scene_SmallBossReset, self.ResetEliteBoss, self)
  self:RegistEvent(Event.Scene_SmallBossListShow, self.SetSceenSmallBossPos, self)
  self:RegistEvent(Event.MiracleTask_Update, self.RefreshTaskShool, self)
  self:RegistEvent(Event.SetFakeAutoFightBtn, self.RefreshFakeAutoFight, self)
  self:RegistEvent(Event.SystemPreview, self.RefreshSystemPreview, self)
  self:RegistEvent(Event.PromptBuyDrug, self.PromptBuyDrug, self)
  self:RegistEvent(Event.Task_MianPanelHide, self.Task_MianPanelHide, self)
  self:RegistEvent(Event.UI_Show, self.UI_Show, self)
  self:RegistEvent(Event.UI_Hide, self.UI_Hide, self)
  self:RegistEvent(Event.Role_RefreshMyShield, self.RefreshSDUI, self)
  self:RegistEvent(Event.Skill_ResLearnSkill, self.RefreshComboSkill, self)
  self:RegistEvent(Event.Skill_UpdateComboSkill, self.UpdateComboValue, self)
  self:RegistEvent(Event.Map_BlackRoomInfo, self.BlackHouseTimeShow, self)
  self:RegistEvent(Event.Role_OnLoginedMap, self.IsShowBlackHouseTime, self, 3)
  self:BindExpChangeEvent()
  self:RegistEvent(Event.Skill_Pan_Changed, self.On_SkillModelChanged, self)
  self:RegistEvent(Event.RightMonsterEff, self.SetTogEff, self)
  self:RegistEvent(Event.MemberLevelChanged, self.MemberLevelChangedCallBack, self)
  self:RegistEvent(Event.RefreshTimeRecharge, self.RefreshTimeRechargeUI, self)
  self:RegistEvent(Event.ChangeScreen, self.ChangeScreen, self)
  self:RegistEvent(Event.SystemOpenTipUIClose, self.OnSystemOpenTipUIClose, self)
  self:RegistEvent(Event.WarAlliance_MyWarAllianceData, self.RefreshRedEnvelopeData, self)
  self:RegistEvent(Event.AddOrChangePrivilege, self.AddOrChangePrivilegeCallBack, self)
  self:RegistEvent(Event.BossDead, self.BossDeadCallBack, self)
  self:RegistEvent(Event.TimeAcrossDay, self.TimeAcrossDayCallBack, self)
  self:RegistEvent(Event.Recharge_RechargeSuccess, self.RechargeSuccess, self)
  self:RegistEvent(Event.OpenServerInvestmentRefresh, self.RefreshTimeLimitedActivitiesShowState, self)
  self:RegistEvent(Event.RechargeSurprise, self.RefreshRechargeSurprise, self)
  self:RegistEvent(Event.PurchaseRechargeSurprise, self.RefreshRechargeSurpriseIcon, self)
  self:RegistEvent(Event.ServerFunctionDisableChange, self.RefreshDisableEntry, self)
  self:RegistEvent(Event.ThreeVSThree3V3BeginBgHide, self.DelSmallMap, self)
  self:RegistEvent(Event.RefreshDimensionalCracks, self.RefreshDimensionalCracks, self)
  self:RegistEvent(Event.RefreshAncientBossRedPoint, self.RefreshAncientBossEffect, self)
  self:RegistEvent(Event.MainActivityWolffortTaskUI, self.MainActivityWolffortTaskUI, self)
  self:RegistEvent(Event.EnterUnionMap, self.OpenDuoQiUI, self)
  self:RegistEvent(Event.Commer_Holidayinfo, self.RefreshReturnActivity, self)
  self:RegistEvent(Event.ResSpaceCrackTranscriptLeftTopPanel, self.ResSpaceCrackTranscriptLeftTopPanel, self)
  self:RegistEvent(Event.DownLoadGiftCountRefresh, self.CheckDownload, self)
  self:RegistEvent(Event.JoinVIPRedPoint, self.JoinVIPRedPoint, self)
  self:RegistEvent(Event.EnterFourPartyRivalryScene, self.DoFourPartyRivalryBeforeEntering, self)
  self:RegistEvent(Event.QuitFourPartyRivalryScene, self.DoFourPartyRivalryBeforeLeaving, self)
end

function Main_MainMenuUI:RefreshAncientBossEffect()
  if self.AncientBossEffect == nil then
    self.AncientBossEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_instanceBoss, true, Vector3(1.2, 1.2, 1.2))
  end
  self.AncientBossEffect:SetActive(false)
  for i, v in pairs(SceneData.AncientStateData) do
    if v and v == true then
      self.AncientBossEffect:SetActive(true)
      break
    end
  end
end

function Main_MainMenuUI:DelSmallMap(_, state)
  if SceneData.mapId == 1095 then
    self.go_right_top:SetActive(false)
  end
  if state then
    self.go_right_top:SetActive(true)
  end
end

function Main_MainMenuUI:TimeAcrossDayCallBack()
  self:RefreshTimeLimitedActivitiesShowState()
end

function Main_MainMenuUI:RechargeSuccess()
  self:RefreshTimeLimitedActivitiesShowState()
end

function Main_MainMenuUI:ChangeScreen()
  if self.changeScreenCoroutine then
    Coroutine.Stop(self.changeScreenCoroutine)
    self.changeScreenCoroutine = nil
  end
  self.changeScreenCoroutine = Coroutine.Start(function()
    Coroutine.Wait(1)
    self:OnActiveMainUI(Event.Logic_ActiveMainUI, true)
  end)
end

function Main_MainMenuUI:RefreshRedEnvelopeData()
  networkRequest.ReqUnionRedPacket()
end

function Main_MainMenuUI:AddOrChangePrivilegeCallBack(id, type)
  if self.mBossExpTemplate == nil or type ~= UnitType.BossExp then
    return
  end
  self.mBossExpTemplate:Refresh(type, self)
end

function Main_MainMenuUI:BossDeadCallBack(id, tblData)
  if self.mBossExpTemplate == nil then
    return
  end
  local effectManager = gameMgr:GetEffectManager()
  local scenePosition = Scene.GetPosByCell(Vector2(tblData.x, tblData.y))
  local screenPosition = MainCamera.initCamera:WorldToScreenPoint(scenePosition)
end

function Main_MainMenuUI:EffectLoadCallBack(effectObject)
  gameMgr:GetEffectManager():GetEffectActionUtility():EffectFlyToObject(effectObject.Lid, EffectProcessorType.SCENE, self.mBossExpTemplate.EffectRoot.transform, effectObject.effectData.tbl.effectTime / 1000)
end

function Main_MainMenuUI:IsShowBlackHouseTime()
  if SceneData.groupId == 100510 then
    NetManager.Send(MapMessage.ReqBlackRoomInfo)
  else
    if self.warningTimer then
      Timer.Stop(self.warningTimer)
      self.warningTimer = nil
    end
    if self.btn_Exit:GetActive() then
      self.btn_Exit:SetActive(false)
    end
  end
end

function Main_MainMenuUI:BlackHouseTimeShow(_, msg)
  if self.warningTimer then
    Timer.Stop(self.warningTimer)
    self.warningTimer = nil
  end
  local surplusTime, lab_countdown = msg.time, self.lab_TimeValue
  if 0 < surplusTime then
    surplusTime = surplusTime * 0.001
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    lab_countdown:SetText(timeStr)
    self.warningTimer = Timer.StartLoop(1, surplusTime, function()
      if surplusTime <= 1 then
        lab_countdown:SetText(TimeUtility.ShowTimeWithColon(0))
        Timer.Stop(self.warningTimer)
        self.warningTimer = nil
        self.btn_Exit:SetActive(false)
      end
      surplusTime = surplusTime - 1
      local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
      lab_countdown:SetText(timeStr)
    end)
  else
    lab_countdown:SetText(TimeUtility.ShowTimeWithColon(0))
  end
  self.btn_Exit:SetActive(true)
  self.lab_TimeValue:SetActive(true)
end

function Main_MainMenuUI:CheckDownload()
  local isLoaded = HotUpdateData.IsPackageDownloaded(1)
  local isReceive = isLoaded and ClientTable.cfg_Gift_giftManager:CheckGiftGetFinish(ClientTable.cfg_Global_globalManager:GetDownLoadGiftId())
  local needRuntimeUpdate = MuInterfaceLua.Instance:IsNeedRuntimeUpdate()
  self.btn_donwload:SetActive(not isReceive and needRuntimeUpdate)
  if needRuntimeUpdate then
    if isLoaded then
      self:refreshDownload()
      self:HideDownLoadTip()
    else
      HotUpdateMgr.CheckCountPackageUpdate()
      if self.downLoadTip then
        self.downLoadTip.data.state = true
        self.downLoadTip:SetActive(true)
        local data = {
          text = ClientTable.cfg_Ui_wordManager:TryGetValue("DownloadText_5").content,
          gameObject = self.btn_donwload,
          pos = Vector3(-152.8, 0, 0),
          scale = Vector3(210, 60, 1),
          ok = nil,
          okArgs = self,
          sortOrder = 1000,
          posLeft = Vector3(3.9, -14.68, 0),
          scaLeft = Vector3(30, 185, 0),
          rotationLeft = -270,
          posRight = Vector3(3.9, 15.34, 0),
          scaRight = Vector3(30, 185, 0),
          rotationRight = -270,
          rootUI = self
        }
        self.downLoadTip = TextPromptUtility.SetTextPrompt(data, true)
      end
    end
  end
  self:ActivityPosRefresh()
end

function Main_MainMenuUI:HideDownLoadTip()
  if self.downLoadTip then
    self.downLoadTip.data.state = false
    self.downLoadTip:SetActive(false)
  end
end

function Main_MainMenuUI:StartAutoF()
  if ForgeData.isFirstEnterGame then
    EventManager.Dispatch(Event.Fuc_Refresh)
  end
  if ForgeData.isFirstEnterGame and OnHookData.IsReachLinePoint() then
    ForgeData.isFirstEnterGame = false
    RoleManager.me:SetAutoHookFight(true)
  end
  ForgeData.isFirstEnterGame = false
end

local HurtTipShowTime = 0

local function TipShowCoroutine(self)
  self.LangHunHurtTip:SetActive(true)
  Coroutine.Wait(9)
  self.LangHunHurtTip:SetActive(false)
end

function Main_MainMenuUI:SetLangHunHurtTipState(_, state)
  if state then
    if HurtTipShowTime == 0 then
      HurtTipShowTime = Time.unscaledTime
      Coroutine.Start(TipShowCoroutine, self)
    elseif Time.unscaledTime - HurtTipShowTime > 10 then
      HurtTipShowTime = Time.unscaledTime
      Coroutine.Start(TipShowCoroutine, self)
    end
  else
    self.LangHunHurtTip:SetActive(false)
  end
end

function Main_MainMenuUI:refreshDownload()
  self.btn_donwload:GetChild("img_redPoint"):SetActive(true)
end

function Main_MainMenuUI:CloseExpShowUI()
end

function Main_MainMenuUI:ShowAutoFightEffect(_, isOpen)
  self.autoStartEffect:SetActive(isOpen)
end

function Main_MainMenuUI:ShowRedFortUI()
  self.uiFsm:PerformTransition(TransitionId.TtoR)
end

function Main_MainMenuUI:HideRedFortUI()
  self.uiFsm:PerformTransition(TransitionId.RtoT)
end

function Main_MainMenuUI:ShowSiegeUI()
  self.uiFsm:PerformTransition(TransitionId.TtoS)
end

function Main_MainMenuUI:HideSiegeUI()
  self.uiFsm:PerformTransition(TransitionId.StoT)
end

function Main_MainMenuUI:EnterWolffortSiege()
  self.uiFsm:PerformTransition(TransitionId.WtoS)
end

function Main_MainMenuUI:QuitWolffortSiege()
  self.uiFsm:PerformTransition(TransitionId.StoW)
end

local function SitButtonOnClick(index)
  EventManager.Dispatch(Event.SceneInteractiveSitOnClick, SitCellData[index])
end

function Main_MainMenuUI:SceneInteractiveSitActive(_, scenePos)
  local copyItem = self.go_sceneInteractive.transform:GetChild(0).gameObject
  if 0 < #scenePos then
    copyItem:SetActive(true)
    SitCellData = scenePos
  else
    copyItem:SetActive(false)
  end
end

function Main_MainMenuUI:SetSceneInteractiveState(id, msg)
  self.btn_SceneInteractive.gameObject:SetActive(msg)
end

function Main_MainMenuUI:SetRechargeButtonTip(id, msg)
  self.rechargeRedPointMsg = msg
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function Main_MainMenuUI:OnResNewMail()
end

function Main_MainMenuUI:UpdatePkMode(PKMode)
  local lab_mode = UIControl(self.btn_attackmode.transform, "lab_mode")
  local index = PKMode + 1
  lab_mode:SetText(ERolePkModeStr[ERoleAllPkModeToString[index]])
  RoleManager.RefreshHeadColor()
  self.modeContainer:SetData(self:GetPkMode())
end

function Main_MainMenuUI:OnPKModeChanged()
  self:UpdatePkMode(RoleManager.me.PKMode)
end

function Main_MainMenuUI:OpenSiegeTaskUI()
  if not UIManager.IsVisible(UIID.Activity_SiegefortTaskUI) then
    self:ShowSubUI(UIID.Activity_SiegefortTaskUI, {
      parent = self.go_left.transform
    })
    if not table.contains(self.TempSubPanelNameList, UIID.Activity_SiegefortTaskUI) then
      table.insert(self.TempSubPanelNameList, UIID.Activity_SiegefortTaskUI)
    end
  end
end

function Main_MainMenuUI:MainActivityWolffortTaskUI()
  if not UIManager.IsVisible(UIID.Activity_WolffortTaskUI) then
    self:ShowSubUI(UIID.Activity_WolffortTaskUI, {
      parent = self.go_left.transform
    })
    if not table.contains(self.TempSubPanelNameList, UIID.Activity_WolffortTaskUI) then
      table.insert(self.TempSubPanelNameList, UIID.Activity_WolffortTaskUI)
    end
  end
end

function Main_MainMenuUI:OpenDuoQiUI(_, isEnterDuoQi)
  if isEnterDuoQi then
    if not UIManager.IsVisible(UIID.Activity_DuoQiUI) then
      UIManager.Show(UIID.Activity_DuoQiUI)
    end
    if UIManager.IsVisible(UIID.LeftTopPanelUI) then
      UIManager.Hide(UIID.LeftTopPanelUI)
    end
  else
    if not UIManager.IsVisible(UIID.LeftTopPanelUI) then
      UIManager.Show(UIID.LeftTopPanelUI)
    end
    if UIManager.IsVisible(UIID.Activity_DuoQiUI) then
      UIManager.Hide(UIID.Activity_DuoQiUI)
    end
  end
  self.go_left_top:SetActive(not isEnterDuoQi)
end

function Main_MainMenuUI:OpenActivityListUI()
  if not UIManager.IsVisible(UIID.War_ActiveListUI) and not SpaceCrackUtility:CheckInSpaceCrackMap(SceneData.mapId) then
    self:ShowSubUI(UIID.War_ActiveListUI, {
      parent = self.go_right.transform
    })
    if not table.contains(self.TempSubPanelNameList, UIID.War_ActiveListUI) then
      table.insert(self.TempSubPanelNameList, UIID.War_ActiveListUI)
    end
  end
end

function Main_MainMenuUI:ActiveMainUICall(state)
  self.mainActiveCol = nil
  if self.state ~= state then
    return
  end
  if HideUIPointByMapIdMgr:IsHideByUIName(self.name) then
    return
  end
  EventManager.Dispatch(Event.Main_UpdateMainUICall, state)
  self.go_bottom:SetActive(state)
  self.go_top:SetActive(state)
  self.go_left:SetActive(state)
  self.go_right:SetActive(state)
  self.go_left_bottom:SetActive(state)
  self.go_right_bottom:SetActive(state)
  local isInDuoQiMap = QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi()
  if isInDuoQiMap ~= true then
    self.go_left_top:SetActive(state)
  else
    self.go_left_top:SetActive(false)
  end
  self.go_right_top:SetActive(state)
  self.go_center:SetActive(state)
end

function Main_MainMenuUI:OnActiveMainUI(_, state)
  EventManager.Dispatch(Event.TipsMainUIPosChange, state)
  self.MultipleEff2:SetActive(false)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  self.state = state
  if state then
    if self.mainActiveCol then
      Timer.Stop(self.mainActiveCol)
      self.mainActiveCol = nil
    end
    self:ActiveMainUICall(state)
    self.go_bottom.transform:DOLocalMove(self.go_bottom_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_top.transform:DOLocalMove(self.go_top_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_left.transform:DOLocalMove(self.go_left_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_right.transform:DOLocalMove(self.go_right_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_left_bottom.transform:DOLocalMove(self.go_left_bottom_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_right_bottom.transform:DOLocalMove(self.go_right_bottom_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_left_top.transform:DOLocalMove(self.go_left_top_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_right_top.transform:DOLocalMove(self.go_right_top_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_right_Tip.transform:DOLocalMove(self.go_right_Tip_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_center_top.transform:DOLocalMove(self.go_center_top_pos, animalTime):SetEase(Ease.OutQuad)
    self.go_center.transform:DOLocalMove(self.go_center_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.go_bottom.transform:DOLocalMove(self.go_bottom_pos + Vector3.New(0, -distance, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_top.transform:DOLocalMove(self.go_top_pos + Vector3.New(0, distance, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_left.transform:DOLocalMove(self.go_left_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_right.transform:DOLocalMove(self.go_right_pos + Vector3.New(distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_left_bottom.transform:DOLocalMove(self.go_left_bottom_pos + Vector3.New(-distance, -distance, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_right_bottom.transform:DOLocalMove(self.go_right_bottom_pos + Vector3.New(distance, -distance, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_left_top.transform:DOLocalMove(self.go_left_top_pos + Vector3.New(-distance, distance, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_right_top.transform:DOLocalMove(self.go_right_top_pos + Vector3.New(distance, distance, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_right_Tip.transform:DOLocalMove(self.go_right_Tip_pos + Vector3.New(0, -distance - 500, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_center_top.transform:DOLocalMove(self.go_center_top_pos + Vector3.New(0, distance, 0), animalTime):SetEase(Ease.OutQuad)
    self.go_center.transform:DOLocalMove(self.go_center_pos + Vector3.New(0, distance * 2, 0), animalTime):SetEase(Ease.OutQuad)
    self.mainActiveCol = Timer.Start(animalTime, self.ActiveMainUICall, self, state)
  end
  local modeCheck = state and SkillData.MainMode == EMainModeType.Func or false
  self:CheckMode(modeCheck)
  self:SetEffActive()
end

function Main_MainMenuUI:OnModeChanged(_)
  if SkillData.MainMode == EMainModeType.Func then
    self:OnActiveGrid(true)
  else
    self:OnActiveGrid(false)
  end
  self:CheckMode(SkillData.MainMode == EMainModeType.Func)
end

function Main_MainMenuUI:OnMainModeChanged()
  if SkillData.MainMode == EMainModeType.Skill then
    local quence3 = DOTween.Sequence()
    quence3:Append(self.btn_autoStart.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
    quence3:Insert(0, self.btn_autoStart.transform:DOLocalMove(self.BtnAutoStartPos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    local quence4 = DOTween.Sequence()
    quence4:Append(self.btn_autoStop.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
    quence4:Insert(0, self.btn_autoStop.transform:DOLocalMove(self.BtnAutoStopPos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
  else
    local quence3 = DOTween.Sequence()
    quence3:Append(self.btn_autoStart.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
    quence3:Insert(C_UISettings.SkillUIDelayScaleTime, self.btn_autoStart.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
    local quence4 = DOTween.Sequence()
    quence4:Append(self.btn_autoStop.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
    quence4:Insert(C_UISettings.SkillUIDelayScaleTime, self.btn_autoStop.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
  end
end

function Main_MainMenuUI:OnCheckMode()
  if funcSwitchTime == 0 then
    self:btn_funcOnClick()
  else
    funcSwitchTime = funcSwitchTime - 1
  end
end

function Main_MainMenuUI:CheckMode(flag)
  if funcTimer then
    Timer.Stop(funcTimer)
    funcSwitchTime = 10
    funcTimer = nil
  end
  if flag then
    funcTimer = Timer.StartLoopForever(1, self.OnCheckMode, self)
  end
end

function Main_MainMenuUI:SetEffActive()
  local function waitExe()
    Coroutine.Wait(1)
    
    self.MultipleEff:SetActive(true)
    self:SetMultipleEffActive()
  end
  
  Coroutine.Start(waitExe, self)
end

function Main_MainMenuUI:UpLvOpenEquip_Tips()
  TipData.CloseItemData(TipShowSort.use)
  TipData.CloseItemData(TipShowSort.equip)
  TipData.CloseItemData(TipShowSort.auction)
  local BagIteminfo = BagInfoData.TotalItems
  local AddShowItems = {}
  local addindex = 1
  for i, Items in pairs(BagIteminfo) do
    if Items.tblItem.rightOperate == EItemOperateType.Wear then
      if RoleEquipUtility.CanUpFight(Items) == EquipUpState.CanWearUpFight then
        local wearindex = RoleEquipUtility.WearEquipIndex(Items)
        local wearble = RoleManager.me.data.equipsData.Data[wearindex]
        if wearble == nil then
          AddShowItems[addindex] = Items
          AddShowItems[addindex].wearindex = wearindex
          addindex = addindex + 1
        else
          AddShowItems[addindex] = Items
          AddShowItems[addindex].wearindex = wearindex
          addindex = addindex + 1
        end
      end
    elseif Items.tblItem.rightOperate == EItemOperateType.Use or Items.tblItem.rightOperate == EItemOperateType.UseAll then
      local canUse, state = RoleEquipUtility.CheckUseItem(Items, CheckUseItemWay.NotAddPoint)
      if canUse or state == ItemUseCheckState.attrPointEnough then
        ItemUtility.UseRoleSkill(Items, true)
      end
    end
  end
  if table.count(TipData.StorageInfo[TipShowSort.use]) ~= 0 then
    local ShowItemUse = {}
    for i, v in pairs(TipData.StorageInfo[TipShowSort.use]) do
      for k = 1, v.count do
        table.insert(ShowItemUse, v)
      end
    end
    TipData.StorageInfo[TipShowSort.use] = ShowItemUse
    local UnCacheData = TipData.UnCacheinfo(TipShowSort.use, ShowItemUse)
    if UnCacheData then
      local SkillTIpsUI = UIManager.GetUiByName(UIID.SkillTIpsUI)
      if not SkillTIpsUI or not SkillTIpsUI.visible then
        UIManager.Show(UIID.SkillTIpsUI, {ItemInfo = ShowItemUse})
      else
        SkillTIpsUI:UpLInsertData(ShowItemUse)
      end
      TipData.CloseItemData(TipShowSort.use)
    end
  end
  if table.count(AddShowItems) ~= 0 then
    local UnCacheData = TipData.UnCacheinfo(TipShowSort.equip, AddShowItems)
    if UnCacheData then
      local EquipTIpsUI = UIManager.GetUiByName(UIID.EquipTIpsUI)
      if not EquipTIpsUI or not EquipTIpsUI.visible then
        UIManager.Show(UIID.EquipTIpsUI, {ItemInfo = AddShowItems})
      else
        EquipTIpsUI:UpLInsertData(AddShowItems)
      end
      TipData.CloseItemData(TipShowSort.equip)
    end
  end
end

function Main_MainMenuUI:UpLvOpenShopSkill(lv)
  TipData.OpenShopTip()
end

function Main_MainMenuUI:OnRole_MyLvChanged(_, addLv)
  self:RefreshTimeLimitedActivitiesShowState()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_lifeLimitBuy
  })
  if TipData.addPointCondition and ConditionManager.Check4D(TipData.addPointCondition) and (ConditionManager.GenerateSingleCondition(TipData.UpAddProint[1][1]):Check() and addLv.attributePoint >= tonumber(TipData.UpAddProint[1][2]) or ConditionManager.GenerateSingleCondition(TipData.UpAddProint[2][1]):Check() and addLv.attributePoint >= tonumber(TipData.UpAddProint[2][2])) then
    local UnCacheData = TipData.UnlvPointData(TipShowSort.addPoint, {
      addLv.attributePoint
    })
    if UnCacheData then
      local AttributeUI = UIManager.GetUiByName(UIID.AttributeAddTipsUI)
      if not AttributeUI or not AttributeUI.visible then
        UIManager.Show(UIID.AttributeAddTipsUI, {
          ItemInfo = {
            addLv.attributePoint
          }
        })
      else
        AttributeUI.args.ItemInfo = {
          addLv.attributePoint
        }
        AttributeUI:Refresh()
      end
    end
  end
  if addLv.level <= TipData.UpLevel then
    self:UpLvOpenEquip_Tips()
    self:UpLvOpenShopSkill(addLv.level)
    TipData.CloseItemData(TipShowSort.auction)
    local BagIteminfo = BagInfoData.TotalItems
    for i, Items in pairs(BagIteminfo) do
      if Items.tblItem.rightOperate == EItemOperateType.Use or Items.tblItem.rightOperate == EItemOperateType.UseAll then
        local canUse, state = RoleEquipUtility.CheckUseItem(Items, CheckUseItemWay.NotAddPoint)
        if canUse or state == ItemUseCheckState.attrPointEnough then
          ItemUtility.UseRoleSkillII(Items, true)
        end
      end
    end
    if table.count(TipData.StorageInfo[TipShowSort.auction]) ~= 0 then
      local ShowItemUse = {}
      for i, v in pairs(TipData.StorageInfo[TipShowSort.auction]) do
        for k = 1, v.count do
          table.insert(ShowItemUse, v)
        end
      end
      local UnCacheData = TipData.UnCacheinfo(TipShowSort.auction, ShowItemUse)
      if UnCacheData then
        local AuctionTIpsUI = UIManager.GetUiByName(UIID.AuctionTIpsUI)
        if not AuctionTIpsUI or not AuctionTIpsUI.visible then
          UIManager.Show(UIID.AuctionTIpsUI, {ItemInfo = ShowItemUse})
        else
          AuctionTIpsUI:UpLInsertData(ShowItemUse)
        end
        TipData.CloseItemData(TipShowSort.auction)
      end
    end
  else
    self:UpLvOpenEquip_Tips()
    TipData.CloseItemData(TipShowSort.auction)
    local BagIteminfo = BagInfoData.TotalItems
    for i, Items in pairs(BagIteminfo) do
      if Items.tblItem.rightOperate == EItemOperateType.Use or Items.tblItem.rightOperate == EItemOperateType.UseAll then
        local canUse, state = RoleEquipUtility.CheckUseItem(Items, CheckUseItemWay.NotAddPoint)
        if canUse or state == ItemUseCheckState.attrPointEnough then
          ItemUtility.UseRoleSkillII(Items, true)
        end
      end
    end
    if table.count(TipData.StorageInfo[TipShowSort.auction]) ~= 0 then
      local ShowItemUse = {}
      for i, v in pairs(TipData.StorageInfo[TipShowSort.auction]) do
        for k = 1, v.count do
          table.insert(ShowItemUse, v)
        end
      end
      local UnCacheData = TipData.UnCacheinfo(TipShowSort.auction, ShowItemUse)
      if UnCacheData then
        local AuctionTIpsUI = UIManager.GetUiByName(UIID.AuctionTIpsUI)
        if not AuctionTIpsUI or not AuctionTIpsUI.visible then
          UIManager.Show(UIID.AuctionTIpsUI, {ItemInfo = ShowItemUse})
        else
          AuctionTIpsUI:UpLInsertData(ShowItemUse)
        end
        TipData.CloseItemData(TipShowSort.auction)
      end
    end
    self:UpLvOpenShopSkill(addLv.level)
  end
  self:FirstChargeRecomFun()
  self.btn_GM:SetActive(QuickFind.LuaMainPlayerViewAttrData().level >= 50)
  EventManager.Dispatch(Event.RefreshDailyPackRedPointByServer, {
    redPointId = ERedPointId.everydaytarget_activity
  })
  self:RefreshSystemPreview()
  self:RefreshVipRedPoint()
  self:RefreshRightListHintEffect()
end

function Main_MainMenuUI:OnRole_MyExpChanged(_, msg)
  if not msg then
    return
  end
  local totalAddExp, playerAddExp, holyRingAddExp = 0, 0, 0
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    totalAddExp = gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr():GetTotalAddExpNum()
  end
  local holyRingLotionData = gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr():GetExperienceBonusData(1009)
  if holyRingLotionData ~= nil then
    local holyRingLotionAddExp = holyRingLotionData.value
    if 0 < totalAddExp then
      playerAddExp = totalAddExp - holyRingLotionAddExp <= 0 and 0 or totalAddExp - holyRingLotionAddExp
    end
    holyRingAddExp = holyRingLotionAddExp
  end
  self:ShowExpEffModel(msg.addExp)
  local addExpMultiple
  local killMonsterExpFormat = ClientTable.cfg_Global_globalManager:GetKillMonsterExpFormatDes(msg.expLevel)
  if msg.logAction == AddExpType.killMonster or msg.logAction == AddExpType.killminiMonster then
    if string.isNullOrEmpty(killMonsterExpFormat) then
      killMonsterExpFormat = "E%sCA%dBD"
    end
    addExpMultiple = string.format(killMonsterExpFormat, msg.addExp, playerAddExp)
  elseif msg.logAction == AddExpType.paoDian then
    if string.isNullOrEmpty(killMonsterExpFormat) then
      killMonsterExpFormat = "FE%sCA%dBD"
    else
      killMonsterExpFormat = "F" .. killMonsterExpFormat
    end
    addExpMultiple = string.format(killMonsterExpFormat, msg.addExp, playerAddExp)
  elseif msg.logAction == AddExpType.HolyForceMonster or msg.logAction == AddExpType.HolyForceMinMonster then
    local val = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.ringExperienceRate) or 0
    holyRingAddExp = MathUtility.FormatNum(val * 0.01)
    killMonsterExpFormat = "XE%sCA%sBD"
    addExpMultiple = string.format(killMonsterExpFormat, msg.addExp, holyRingAddExp)
  elseif msg.logAction == AddExpType.HolyForcePoint then
    if string.isNullOrEmpty(killMonsterExpFormat) then
      killMonsterExpFormat = "XE%sCA%dBD"
    else
      killMonsterExpFormat = "X" .. killMonsterExpFormat
    end
    addExpMultiple = string.format(killMonsterExpFormat, msg.addExp, holyRingAddExp)
  elseif msg.logAction == AddExpType.HolyBubblePoint then
    local level = msg.expLevel
    killMonsterExpFormat = "FE%s-%sQXRSCA%dBD"
    if msg.expLevel >= 10 then
      level = msg.expLevel - 10
      killMonsterExpFormat = "FE%sK%sQXRSCA%dBD"
    elseif msg.expLevel >= 20 then
      level = msg.expLevel - 20
      killMonsterExpFormat = "FE%sL%sQXRSCA%dBD"
    end
    addExpMultiple = string.format(killMonsterExpFormat, msg.addExp, level, holyRingAddExp)
  else
    addExpMultiple = string.format(killMonsterExpFormat, msg.addExp, 0)
  end
  if 0 < tonumber(msg.addExp) then
    FloatingExpUtility.QuickMsg(addExpMultiple)
  end
end

function Main_MainMenuUI:OnRole_MyHPChanged(_, roleid)
  if roleid.roleId == ViewData.meData.id then
    self:SetHp()
  end
end

function Main_MainMenuUI:OnRole_MyMPChanged(_, roleid)
  if roleid.id == ViewData.meData.id then
    self:SetMp()
  end
end

function Main_MainMenuUI:OnRole_MyShieldChanged(_, roleid)
  if roleid.roleId == ViewData.meData.id then
    self:SetProtective()
  end
end

function Main_MainMenuUI:On_RoleAttributeChanged(_, changeList)
  if changeList[EAttributeType.maximumHealth] ~= nil then
    self:SetHp()
  end
  if changeList[EAttributeType.maximumMana] ~= nil then
    self:SetMp()
  end
  if changeList[EAttributeType.maximumShield] ~= nil then
    self:SetProtective()
  end
  if changeList[EAttributeType.maximumPhysBaseDmg] ~= nil or changeList[EAttributeType.maximumWizBaseDmg] or changeList[EAttributeType.monsterDamageAbsorptionShow] then
    self:SetAttackValue()
  end
  if changeList[EAttributeType.monsterDamageAbsorptionShow] ~= nil then
    self:RefreshRightList(SceneData.mapId, true)
  end
  self:RefreshRightListHintEffect()
end

function Main_MainMenuUI:On_SkillModelChanged(_, msg)
  self:RefreshRightList(SceneData.mapId, true)
end

function Main_MainMenuUI:RefreshFakeAutoFight(_, state)
  self.btn_autoStop:SetActive(state)
  self.btn_autoStart:SetActive(not state)
  self.btn_autoPause:SetActive(false)
end

function Main_MainMenuUI:RefreshAutoFight()
  if self.btn_autoStop:GetActive() ~= QiJiHelperData.isAutoFight then
    RiskSpotManager.RiskSpotPlaceType(RiskSpotType.SwitchAutoFight)
  end
  self.btn_autoStop:SetActive(QiJiHelperData.isAutoFight)
  self.btn_autoStart:SetActive(not QiJiHelperData.isAutoFight)
  self.btn_autoPause:SetActive(false)
end

function Main_MainMenuUI:AutoFightChange()
  self:RefreshAutoFight()
  self.firstShow = true
  self:SetMultipleEffActive()
end

function Main_MainMenuUI:SetIsExpShow(_, autoFightState)
  if autoFightState == AutoFightStateEnum.Pause then
    self.btn_autoStop:SetActive(false)
    self.btn_autoStart:SetActive(false)
    self.btn_autoPause:SetActive(true)
  else
    self.btn_autoStop:SetActive(QiJiHelperData.isAutoFight)
    self.btn_autoStart:SetActive(not QiJiHelperData.isAutoFight)
    self.btn_autoPause:SetActive(false)
  end
  self:SetExpShowUI()
end

function Main_MainMenuUI:QiJiHelperOpenAutoFight()
end

local ExpEffPos
local EaseType = {
  Ease.InCubic,
  Ease.InQuad,
  Ease.InQuart,
  Ease.InQuint,
  Ease.InExpo,
  Ease.InCirc,
  Ease.InBack
}

function Main_MainMenuUI:ShowExpEffModel(addExp)
  if self.EffExp ~= nil and self.isPlay == false then
    self.isPlay = true
    local exp = QuickFind.LuaMainPlayerViewAttrData().exp - addExp
    local CurrentNum = self:GetExpAndSlider(exp, false)
    local index = Mathf.Random(1, #EaseType)
    ExpEffPos = Vector3(CurrentNum, -100, 0)
    for i = 1, #self.EffExp do
      self.EffExp[i]:SetActive(true)
      self.EffExp[i].transform:DOLocalMove(ExpEffPos, 1):SetEase(EaseType[index]):OnComplete(function()
        self:EffModelClear(i, nil)
      end)
    end
  else
    self:UpdateRoleExpInAnimation()
  end
end

local timer

function Main_MainMenuUI:UpdateRoleExpInfo()
  self.expPos = self.img_expbarSlider.transform:GetComponent("RectTransform").rect
  local sliderNum = self:GetExpAndSlider(QuickFind.LuaMainPlayerViewAttrData().exp, true)
  local leveltext = self:PlayerLevelTextRefresh(Mathf.keepthreefloor(sliderNum))
  self.lab_playerLevel:SetText(leveltext)
  local slider = tonumber(string.format("%.2f", sliderNum))
  self.img_expbarSlider.slider.value = slider
end

function Main_MainMenuUI:UpdateRoleExpInAnimation()
  if timer ~= nil then
    Timer.Stop(timer)
    timer = nil
  end
  local sliderNum = self:GetExpAndSlider(QuickFind.LuaMainPlayerViewAttrData().exp, true)
  local leveltext = self:PlayerLevelTextRefresh(Mathf.keepthreefloor(sliderNum))
  self.lab_playerLevel:SetText(leveltext)
  local slider = tonumber(string.format("%.2f", sliderNum))
  local sliderNow = tonumber(string.format("%.2f", self.img_expbarSlider.slider.value))
  if sliderNum <= 0 or slider <= 0 or 1 < sliderNum or 1 < slider then
    self.img_expbarSlider.slider.value = 0
    return
  end
  if slider == sliderNow then
    return
  end
  timer = Timer.StartLoopForever(0.01, function()
    self.ExpSliderBarEff:SetActive(true)
    self.img_expbarSlider.slider.value = self.img_expbarSlider.slider.value + 0.01
    local posX = self:GetExpBarPosition(self.img_expbarSlider.slider.value)
    self.ExpSliderBarEff.transform:SetLocalPosition(posX, -98, 0)
    local sliderValue = tonumber(string.format("%.2f", self.img_expbarSlider.slider.value))
    if self.img_expbarSlider.slider.value >= 1 then
      self.img_expbarSlider.slider.value = 0
    end
    if sliderValue == slider then
      if timer ~= nil then
        Timer.Stop(timer)
        timer = nil
      end
      self.ExpSliderBarEff:SetActive(false)
    end
  end)
end

function Main_MainMenuUI:PlayerLevelTextRefresh(slider)
  local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().level)
  if tbl == nil or string.isNullOrEmpty(tbl.name) then
    return ""
  end
  local MaxLv = ClientTable.cfg_Character_levelManager:GetDic()
  local leveltext
  if QuickFind.LuaMainPlayerViewAttrData().level < table.count(MaxLv) then
    local mun = slider * 100
    local slidertext = mun .. "%"
    leveltext = string.format("%s<color=#8a8a8a> %s</color>", tbl.name, slidertext)
  else
    leveltext = tbl.name
  end
  return leveltext
end

function Main_MainMenuUI:OnActiveGrid(state)
  if state then
    for _, func in pairs(self.funcPosTbl) do
      local quence = DOTween.Sequence()
      quence:Append(func.trans:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
      quence:Insert(0, func.trans:DOLocalMove(func.pos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    end
    self.btn_func.transform:DOLocalRotate(Vector3.New(0, 0, 45), C_UISettings.SkillUIScaleTime)
  else
    for _, func in pairs(self.funcPosTbl) do
      local quence = DOTween.Sequence()
      quence:Append(func.trans:DOLocalMove(self.btn_fake.transform.localPosition, C_UISettings.SkillUIMoveTime))
      quence:Insert(C_UISettings.SkillUIDelayScaleTime, func.trans:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime):SetEase(Ease.OutBack))
    end
    self.btn_func.transform:DOLocalRotate(Vector3.New(0, 0, 0), C_UISettings.SkillUIScaleTime)
    if self.redPointGuideTip ~= nil then
      self.redPointGuideTip:SetActive(true)
    end
  end
end

function Main_MainMenuUI:Refresh()
  local isInDuoQiMap = QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi()
  self:OpenDuoQiUI(nil, isInDuoQiMap)
  self:ResSpaceCrackTranscriptLeftTopPanel(nil, SpaceCrackUtility:CheckInSpaceCrackMap(SceneData.mapId))
  if UIManager.IsVisible(UIID.Activity_Sport3V3Task) then
    UIManager.Hide(UIID.LeftTopPanelUI)
  end
  self:OnReqInfoInit()
  SkillData.MainMode = EMainModeType.Skill
  EventManager.Dispatch(Event.Main_MainModeChanged)
  self:UpdatePkMode(RoleManager.me.data.PKMode)
  self:SetAttackValue()
  self:WifiBatteryInit()
  self:AppearBtnShowOrHide()
  self:RefreshAutoFight()
  self:RefreshUseItem()
  self:UpdateRoleExpInfo()
  self:RefreshLeftUI()
  self:SetHp()
  self:SetMp()
  self:SetProtective()
  self:SetMultipleEff()
  self:ShowStartGame()
  self:ShowWelcomeUI()
  self:CheckBagPrompt()
  self:FirstChargeRecomFun()
  self:SetExpShowUI()
  self:ShowTip_killMonsterUI()
  self:RefreshVipRedPoint()
  self:RefreshTaskShool()
  self:RefreshSystemPreview()
  TipData.AuctionRecomBuyFuc()
  EventManager.Dispatch(Event.Buff_RoleMonthCardBuff)
  ExpiredPromptData.TraverseShowUI()
  PlayerControlForceData.InitPromptBuyDrugState()
  self:Task_MianPanelHide()
  self:RefreshComboSkill()
  RechargeController.RefreshTimeRecharge()
  self:RefreshActivityBtnImage()
end

function Main_MainMenuUI:UpdateComboValue()
  self:UpdatePowerValue()
  self:UpdateRiseComboEffect()
  self:PlayBombComboEffect()
end

function Main_MainMenuUI:PlayBombComboEffect()
  if HPData.IsComboValeMax() then
    local bombEffect = self.go_defenseValue:GetChild("right/Fill_Area/Eff_UI_nengliang_baokan")
    bombEffect:SetActive(false)
    bombEffect:SetActive(true)
  end
end

function Main_MainMenuUI:UpdateRiseComboEffect()
  local percent = HPData.GetComboPercent()
  local riseEffect = self.go_defenseValue:GetChild("right/Fill_Area/Eff_UI_nengliang_huxi")
  riseEffect:SetScale(Vector3(1, percent, 1))
  riseEffect:SetActive(false)
  riseEffect:SetActive(true)
end

function Main_MainMenuUI:UpdatePowerValue()
  self.go_defenseValue:GetChild("right/Fill_Area/Fill_ComboEnergy/Eff_UI_nengliangcao"):SetActive(true)
  local nengliang = self.go_defenseValue:GetChild("right/Fill_Area/Fill_ComboEnergy/Eff_UI_nengliangcao/nengliang")
  local power = nengliang.transform:GetComponent(typeof(UnityEngineLua.SpriteRenderer))
  local material = power.material
  material:SetFloat("_Health", HPData.comboValue)
  self.lab_ComboEnergynun:SetActive(true)
  local ctr = string.format("%s%s", math.floor(HPData.GetComboPercent() * 100), "%")
  self.lab_ComboEnergynun:SetText(ctr)
end

function Main_MainMenuUI:RefreshComboSkill()
  local hpPosX = 55
  local mpPosX = -59
  for i, v in pairs(RoleManager.me.skills) do
    if SkillUtility.IsComboSkill(v.sid) then
      self.go_defenseValue:SetActive(true)
      self:SetBtn_useItem5Active()
      self:UpdatePowerValue()
      self.img_bloodStoneGrey:SetAnchoredPosition(hpPosX + 10, -17)
      self.img_manaStoneGrey:SetAnchoredPosition(mpPosX - 10, -17)
      return
    end
  end
  self.img_bloodStoneGrey:SetAnchoredPosition(hpPosX, -17)
  self.img_manaStoneGrey:SetAnchoredPosition(mpPosX, -17)
  self.go_defenseValue:SetActive(RoleManager.me.data.hasShield)
  self:SetBtn_useItem5Active()
end

function Main_MainMenuUI:RefreshSDUI()
  if RoleManager.me then
    self.go_defenseValue:SetActive(RoleManager.me.data.hasShield or SkillUtility.GetMeComboSkill())
    self:SetBtn_useItem5Active()
    self:SetProtective()
  end
end

function Main_MainMenuUI:SetBtn_useItem5Active()
  self.btn_useItem5:SetActive(not self.go_defenseValue:GetActive())
end

function Main_MainMenuUI:ShowStartGame()
  local firstIdStr = PlayerPrefs.GetString(LoginData:GetFirstIdKey(), "")
  local firstTbl = string.split(firstIdStr, "#")
  local surplusTbl = {}
  local isFirstStart = false
  for _, roleId in ipairs(firstTbl) do
    if tonumber(roleId) == LoginData.roleId then
      isFirstStart = true
    elseif tonumber(roleId) then
      table.insert(surplusTbl, tonumber(roleId))
    end
  end
  firstIdStr = table.concat(surplusTbl, "#")
  PlayerPrefs.SetString(LoginData:GetFirstIdKey(), firstIdStr)
  if isFirstStart then
    UIManager.Show(UIID.Main_StartGame)
  end
end

function Main_MainMenuUI:ShowWelcomeUI()
  if FucShowOrHideController.FuncSystemIsOpen(2600004) then
    EventManager.Dispatch(Event.InsertAutoPopUI, UIID.Login_WelcomeUI)
  end
  local pid = LoginData.externalNet and LoginData.pId or LoginData.internalPId
  local tbl = ClientTable.cfg_Login_Welcome_NewManager:GetTblByIdAndCondition(pid)
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Login_Welcome) and tbl ~= nil then
    EventManager.Dispatch(Event.InsertAutoPopUI, UIID.Login_WelcomeServerUI)
  end
end

function Main_MainMenuUI:RefreshLeftUI()
  if RedFortData.InRedFortActivity then
    self:ShowRedFortUI()
  elseif Activity_LuoLanSiegeData.IsActivityOpen() then
    self:ShowSiegeUI()
  end
end

function Main_MainMenuUI:OnReqInfoInit()
  if not self.reqProto then
    self.reqProto = true
    EventManager.Dispatch(Event.GetOnHookInfo)
    NetManager.Send(BagMessage.ReqBagInfo)
    NetManager.Send(MailMessage.ReqGetMailList)
    NetManager.Send(BagMessage.ReqStorageInfo)
    NetManager.Send(MapMessage.ReqGetBossMapAndCount)
    CommercializeController.OpenserActivit()
    CommercializeController.ReqEverydayRecharge()
    CommercializeController.ReqNomalrechange()
    NetManager.Send(CountMessage.ReqCountByKey, {key = 2360151})
    NetManager.Send(UnionMessage.ReqUnionLogoInfo, {
      unionId = RoleManager.me.unionId or 0,
      count = 100
    })
    networkRequest.ReqUnionRedPacket()
    networkRequest.ReqAccumulateRechargeActivityInfo()
    ReturnActivityData.CheckReturnActivityData()
    AnniversaryActivityController.GetActivityData()
  end
end

function Main_MainMenuUI:OpenSell()
  local openDir = PlayerControlForceData.BagSellIsOpen()
  if openDir then
    UIManager.Show(UIID.BagSellInfoUI)
  else
    TipUtility.ShowSellOpenPrompt()
  end
end

function Main_MainMenuUI:HideBagFull()
  if self.bagTip then
    self.bagTip.data.state = false
    self.bagTip:SetActive(false)
  end
  if self.BuyDrugGuideEff then
    self.BuyDrugGuideEff:SetActive(false)
  end
  self.Image_man:SetActive(false)
end

function Main_MainMenuUI:CheckBagPrompt()
  if BagInfoData.bagFull then
    if not PlayerControlForceData.autoRecycleState then
      if self.bagTip then
        self.bagTip.data.state = true
        self.bagTip:SetActive(true)
      else
        local data = {
          text = LocalizationUtility.GetContentByKey("beibaohuishou"),
          gameObject = self.btn_bag,
          pos = Vector3(-152.8, 0, 0),
          scale = Vector3(210, 60, 1),
          ok = self.OpenSell,
          okArgs = self,
          sortOrder = 1000,
          posLeft = Vector3(3.9, -14.68, 0),
          scaLeft = Vector3(30, 227, 0),
          rotationLeft = -270,
          posRight = Vector3(3.9, 15.34, 0),
          scaRight = Vector3(30, 227, 0),
          rotationRight = -270
        }
        self.bagTip = TextPromptUtility.SetTextPrompt(data, true)
      end
      if self.BuyDrugGuideEff then
        self.BuyDrugGuideEff:SetActive(true)
      else
        self.BuyDrugGuideEff = UIEffectUtility.SetUIEffect("Eff_UI_zidong", self.btn_bag, false, Vector3(4.5, 4.5, 500))
        self.BuyDrugGuideEff:SetActive(true)
      end
    end
  else
    self:HideBagFull()
  end
  self.Image_man:SetActive(BagInfoData.bagFull)
  if self._bagIsOpen then
    local spriteName = BagInfoData.bagFull and "img_new_btn_bao2" or "img_new_btn_bao"
    self:SetSprite("Atlas_Main", spriteName, self.btn_bag)
  end
end

local taskID = {10018, 100061}

function Main_MainMenuUI:RefreshTask(_, task)
  for k, v in pairs(taskID) do
    if TaskData.GetTaskById(tonumber(v)) ~= nil and (TaskData.GetTaskById(tonumber(v)):GetState() == TaskStateType.Acceptable or TaskData.GetTaskById(tonumber(v)):GetState() == TaskStateType.Accept or TaskData.GetTaskById(tonumber(v)):GetState() == TaskStateType.Completed) and self.bagTip then
      self.bagTip:SetActive(false)
    end
  end
end

function Main_MainMenuUI:OnBagFullState()
  self:CheckBagPrompt()
end

function Main_MainMenuUI:RefreshBag()
  self:RefreshUseItem()
end

local initcun = 1

function Main_MainMenuUI:RefreshUseItem()
  if initcun == 1 then
    initcun = initcun + 1
    return
  end
  local useItemTable = self.useItems
  local HPGuideTip, MPGuideTip
  for i, v in ipairs(SkillSettingData.skill_use_items) do
    local previousId = useItemTable[i].id
    useItemTable[i].id = v
    if previousId ~= v then
      self:RefreshUseItemCd(useItemTable[i])
    end
    useItemTable[i]:GetChild("Img_grey"):SetActive(true)
    local img_add = useItemTable[i]:GetChild("img_add")
    if v == 0 then
      useItemTable[i]:GetChild("Img_grey"):SetActive(false)
      self:SetBuyDrugGuide(false, useItemTable[i])
      img_add:SetActive(false)
    else
      local count = BagInfoData.GetItemCountByItemConfigId(v)
      if count == 0 then
        if SkillSettingData.hpPriorityId[v] or SkillSettingData.mpPriorityId[v] then
          if SkillSettingData.hpPriorityId[v] then
            HPGuideTip = useItemTable[i]
          end
          if SkillSettingData.mpPriorityId[v] then
            MPGuideTip = useItemTable[i]
          end
          img_add:SetActive(true)
          img_add:SetOnClick(self, self.PortableStoreOnclick)
        else
          self:SetBuyDrugGuide(false, useItemTable[i])
          img_add:SetActive(false)
        end
      else
        self:SetBuyDrugGuide(false, useItemTable[i])
        img_add:SetActive(false)
        useItemTable[i]:GetChild("Img_grey"):SetActive(false)
        useItemTable[i]:GetChild("img_add"):SetActive(false)
      end
    end
  end
  if HPGuideTip then
    if MPGuideTip then
      self:SetBuyDrugGuide(false, MPGuideTip)
    end
    self:SetBuyDrugGuide(true, HPGuideTip)
  elseif MPGuideTip then
    self:SetBuyDrugGuide(true, MPGuideTip)
  end
  self:LoadItemsSetting()
end

function Main_MainMenuUI:PortableStoreOnclick(control)
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) then
    FloatingWordUtility.QuickMsg("\196\144ang r\195\168n, kh\195\180ng th\225\187\131 d\195\185ng")
    return
  end
  local openDir = PlayerControlForceData.BagShopIsOpen()
  if openDir then
    UIManager.Show(UIID.BagShopInfoUI)
  else
    TipUtility.QuickShowPrompt({
      id = PromptWordType.MainBuyDrugPrompt
    })
  end
  local parent = control.parent
  local promptText = parent:Find("use_Prompt/promptText")
  if promptText.gameObject:GetComponent(typeof(CS.UnityEngine.UI.Graphic)).text == "C\195\179 th\225\187\131 mua thu\225\187\145c c\225\186\165p cao h\198\161n" then
    control:SetActive(false)
    self:StopPromptBuyDrugTimer()
  end
end

function Main_MainMenuUI:LoadItemsSetting()
  for i = 1, #self.useItems do
    local id = SkillSettingData.skill_use_items[i]
    if id ~= 0 then
      local itemData = ItemUtility.GenerateItemData(id)
      itemData.count = BagInfoData.GetItemCountByItemConfigId(id)
      self.useItems[i].itemCellData:RefreshData(itemData)
    else
      self.useItems[i].itemCellData:Reset()
    end
    ItemUtility.ShowItemCell(self.useItems[i], self.useItems[i].itemCellData, self, false)
  end
end

function Main_MainMenuUI:RefreshUseItemCd(control)
  if control.cdAnim then
    Coroutine.Stop(control.cdAnim)
    control.cdAnim = nil
    local imgCd = control:GetChild("img_cd")
    imgCd:SetFillAmount(0)
    imgCd:SetActive(false)
  end
  self:UpdateItemUseCd(control)
end

function Main_MainMenuUI:RefreshSameItemIdCd(_, cdMsg)
  for i, v in pairs(self.useItems) do
    if v.id ~= 0 then
      local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(v.id)
      if itemConfig and itemConfig.useCdGroup == cdMsg.key then
        self:UpdateItemUseCd(v)
      end
    elseif v.cdAnim then
      Coroutine.Stop(v.cdAnim)
      v.cdAnim = nil
      local imgCd = v:GetChild("img_cd")
      imgCd:SetFillAmount(0)
      imgCd:SetActive(false)
    end
  end
end

function Main_MainMenuUI:UpdateItemUseCd(control)
  if not control then
    return
  end
  if ItemUtility.IsCanUseItemCd(control.id) then
    if control.cdAnim then
      Coroutine.Stop(control.cdAnim)
      control.cdAnim = nil
    end
    
    local function StartCountDown()
      control:GetChild("img_cd"):SetActive(true)
      local imgCd = control:GetChild("img_cd")
      local surplusTime = (ItemUtility.GetItemCd(control.id) - Time.GetServerTime()) / 1000
      local startTime = 0
      while true do
        startTime = startTime + Time.deltaTime
        local percent = startTime / surplusTime
        imgCd:SetFillAmount(1 - percent)
        if surplusTime - startTime <= 0.001 then
          imgCd:SetFillAmount(0)
          control.cdAnim = nil
          control:GetChild("img_cd"):SetActive(false)
          Coroutine.Break()
        end
        Coroutine.WaitForEndOfFrame()
      end
    end
    
    control.cdAnim = Coroutine.Start(StartCountDown)
  end
end

function Main_MainMenuUI:SetHp()
  if not RoleManager.me then
    logError("RoleManager.me  tr\225\187\145ng")
    return
  end
  local curhp = QuickFind.LuaMainPlayerViewAttrData().hp
  local maxhp = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumHealth)
  self.img_bloodStoneBright.image.fillAmount = curhp / maxhp
  self.lab_bloodNum:SetText(curhp)
end

function Main_MainMenuUI:SetMp()
  if not RoleManager.me then
    logError("RoleManager.me  tr\225\187\145ng")
    return
  end
  local curMp = RoleManager.me.mp
  local maxMp = RoleManager.me.maxMp
  self.img_manaStoneBright.image.fillAmount = curMp / maxMp
  self.lab_manaNum:SetText(curMp)
end

function Main_MainMenuUI:SetProtective()
  if not RoleManager.me then
    logError("RoleManager.me  tr\225\187\145ng")
    return
  end
  local shield = RoleManager.me.data.shield
  local maxShield = RoleManager.me.data.maxShield
  if not RoleManager.me.data.hasShield then
    shield = 0
    maxShield = 0
  end
  self.Fill_Protective.image.fillAmount = shield / maxShield
  self.lab_shieldNum:SetText(shield)
  self.lab_shieldNum:SetActive(shield and 0 < shield)
end

function Main_MainMenuUI:GetExpAndSlider(Exp, ExpState)
  local lvLastCfg = {}
  if QuickFind.LuaMainPlayerViewAttrData().level == nil then
    return
  end
  local lvCfg = ClientTable.cfg_Character_levelManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().level, "level")
  local strTbl = string.split(lvCfg.exp, "#")
  local cfgExp = 0
  if 1 < #strTbl then
    cfgExp = tonumber(strTbl[2])
  end
  local sliderNum = Exp / cfgExp
  local AllLegLength = self.go_right_bottom_pos.x * 2
  local CurrentNum = -self.go_right_bottom_pos.x + AllLegLength * sliderNum
  if ExpState then
    return sliderNum
  else
    return CurrentNum
  end
end

function Main_MainMenuUI:GetExpBarPosition(sliderNum)
  local starPos, dis
  local width = self.expPos.width
  starPos = width / 2 * -1
  dis = self.expPos.width
  local sliderPos = sliderNum * dis
  local posX = sliderPos + starPos
  return posX
end

function Main_MainMenuUI:EffInit()
  local effectModel = CS.Framework.GameModel("ExpEff", SkillMgr.ROOT, function()
  end)
  effectModel:LoadAsync("Effect/Skill/Eff_jingyanqiu_01.prefab")
  effectModel.transform:SetParent(self.go_bottom.transform)
  self:EffModelInit(effectModel.gameObject)
  local effectModelTwo = CS.Framework.GameModel("ExpEffTwo", SkillMgr.ROOT, function()
  end)
  effectModelTwo:LoadAsync("Effect/Skill/Eff_jingyanqiu_02lan.prefab")
  effectModelTwo.transform:SetParent(self.go_bottom.transform)
  self:EffModelInit(effectModelTwo.gameObject)
  local effectModelThree = CS.Framework.GameModel("ExpEffThree", SkillMgr.ROOT, function()
  end)
  effectModelThree:LoadAsync("Effect/UI/Eff_UI_jingyantiao.prefab")
  effectModelThree.transform:SetParent(self.go_bottom.transform)
  effectModelThree.gameObject.transform.localScale = Vector3(1, 1, 1)
  self.ExpSliderBarEff = effectModelThree.gameObject
  self.ExpSliderBarEff:SetActive(false)
end

function Main_MainMenuUI:SetAttackValue()
  local attack = 0
  if RoleUtility.CareerJudge(QuickFind.LuaMainPlayerViewAttrData().career, ERoleCareer.SwordMan) or RoleUtility.CareerJudge(QuickFind.LuaMainPlayerViewAttrData().career, ERoleCareer.Archer) then
    attack = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumPhysBaseDmg)
  elseif RoleUtility.CareerJudge(QuickFind.LuaMainPlayerViewAttrData().career, ERoleCareer.SpellSword) then
    local strength = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength)
    local energy = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy)
    attack = strength <= energy and QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumWizBaseDmg) or QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumPhysBaseDmg)
  elseif RoleUtility.CareerJudge(QuickFind.LuaMainPlayerViewAttrData().career, ERoleCareer.SummonMagician) then
    local Curse = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumCurseBaseDmg)
    local magic = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumWizBaseDmg)
    attack = Curse >= magic and Curse or magic
  else
    attack = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumWizBaseDmg)
  end
  local defenseBase = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow)
  local Showtext = string.format("BC%dCAC%d", attack, defenseBase)
  self.tx_playerAttack:SetText(Showtext)
end

function Main_MainMenuUI:EffModelInit(go)
  local EffExpModel = go
  EffExpModel.transform.localPosition = Vector3(0, 430, 0)
  EffExpModel.transform.localScale = Vector3(100, 100, 100)
  EffExpModel.layer = 5
  EffExpModel:SetActive(false)
  table.insert(self.EffExp, EffExpModel)
end

function Main_MainMenuUI:EffModelClear(i, Tab)
  self.isPlay = false
  if i ~= 0 then
    self.EffExp[i].transform.localPosition = Vector3(0, 430, 0)
    self.EffExp[i]:SetActive(false)
    self:UpdateRoleExpInAnimation()
  end
  if Tab ~= nil then
    for j = 1, #Tab do
      self.EffExp[j].transform.localPosition = Vector3(0, 430, 0)
      self.EffExp[j]:SetActive(false)
    end
  end
end

function Main_MainMenuUI:InitBatteryItem()
  self.BatteryItems = {}
  for i = 1, 5 do
    local BatteryItem = self:GetControl("go_bottom/img_batteryBg/sw_battery/Viewport/Content/img_battery" .. i)
    self.BatteryItems[i] = BatteryItem
  end
end

function Main_MainMenuUI:WifiBatteryInit()
  self:InitBatteryItem()
  self:UpdateBattery()
end

function Main_MainMenuUI:UpdateWifi()
  local dfs = CS.UnityEngine.NetworkReachability
  if Application.internetReachability == dfs.ReachableViaCarrierDataNetwork then
    self.img_wifi:SetActive(true)
  else
    self.img_wifi:SetActive(false)
  end
end

function Main_MainMenuUI:UpdateBattery(_, Bat)
  local Battery = Bat
  Battery = Battery or CS.MuInterface.Instance:GetBattery()
  local BatteryCount = 0
  if Battery <= 5 and 0 < Battery then
    BatteryCount = 0
  elseif Battery <= 20 and 5 < Battery then
    BatteryCount = 1
  elseif 20 < Battery and Battery <= 40 then
    BatteryCount = 2
  elseif 40 < Battery and Battery <= 60 then
    BatteryCount = 3
  elseif 60 < Battery and Battery <= 80 then
    BatteryCount = 4
  elseif 80 < Battery then
    BatteryCount = 5
  end
  for i, v in pairs(self.BatteryItems) do
    if i > BatteryCount then
      v:SetActive(false)
    else
      v:SetActive(true)
    end
  end
end

function Main_MainMenuUI:AppearBtnShowOrHide(id, msg)
  local isShow = false
  if table.count(ViewData.meData.titleData.TitleInfo) > 0 then
    isShow = true
  end
  if not isShow then
    for i, v in pairs(RoleManager.me.data.equipsData.Data) do
      if 0 < v.tblItem.fashion then
        isShow = true
        break
      end
    end
  end
  if not isShow and not table.isNullOrEmpty(gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():GetAllActiveGuardInfoList()) then
    isShow = true
  end
  if not isShow and gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():IsHaveFashionInfo() then
    isShow = true
  end
  self.btn_appearance:SetActive(isShow)
  self:FuncPosRefresh()
end

function Main_MainMenuUI:BtnPosRefresh(_, isRedPoint)
  if isRedPoint then
    self:ActivityPosRefresh()
  else
    self:FuncPosRefresh()
    self:ActivityPosRefresh()
  end
end

function Main_MainMenuUI:Fuc_FirstShow(_, funid)
  if not funid then
    return
  end
  if funid == 4010105 then
    NetManager.Send(RechargeMessage.ReqEverydayRechargeInfo)
  elseif funid == 4010103 then
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.recharge,
      state = true
    })
  elseif funid == 2510001 then
    self:RefreshTaskShool(true)
  elseif funid == 2510001 then
    self:FirstChargeRecomjudge()
  elseif funid == 2310001 then
    TipData.AuctionRecomBuyFuc()
  elseif funid == 3000001 then
    self:FirstChargeMaster()
  elseif funid == 3000101 then
    self:FirstChargeHolyspirit()
  elseif funid == 3000103 then
    self:FirstChargeRune()
  elseif funid == 3000201 then
    self:FirstChargeHolyRing()
  elseif funid == 3000401 then
    self:FirstChargeHolySkeleton()
  elseif funid == 3000701 then
    self:FirstChargeNewRune()
  end
end

function Main_MainMenuUI:RightTopButtonRefresh(condition)
  local topCfg = ConfigManager.GetConfigTable("cfg_Ui_rightTopZoom")
  table.sort(topCfg, sort)
  self.activityPosTbl = {}
  local initPos = C_UISettings.MainActivityInitPos
  local distance = C_UISettings.MainActivityDistance
  local Offsetleft = C_UISettings.MainActivityOffsetleft
  local MaxPos = C_UISettings.MainActivityMaxPos
  local index = 0
  local acc = 0
  for _, topUIInfo in pairs(topCfg) do
    local btnTrans = UIControl(self.go_activity.transform:Find(topUIInfo.btnName))
    if condition == 1 then
      if btnTrans:GetActive() then
        local localPosition
        if topUIInfo.sortid == 0 then
          localPosition = MaxPos
          acc = C_UISettings.MainActivityInitPosOut_x
        else
          local rows = Mathf.Floor(index / C_UISettings.MainActivityRowCount)
          local columns = index % C_UISettings.MainActivityRowCount
          localPosition = Vector3.New(initPos.x + rows * distance.x + columns * Offsetleft + acc, initPos.y + columns * distance.y, 0)
          index = index + 1
        end
        self.activityPosTbl[index] = {
          pos = localPosition,
          transCtr = btnTrans,
          orZoom = topUIInfo.orZoom == 1
        }
      end
    elseif condition == 2 then
      if 0 < btnTrans.transform.childCount and btnTrans:GetChild("img_redPoint"):GetActive() then
        btnTrans.canvasGroup.alpha = 1
        btnTrans.button.enabled = true
        btnTrans.image.enabled = true
      end
      if btnTrans:GetActive() and btnTrans.button.enabled then
        if topUIInfo.sortid == 0 then
          localPosition = MaxPos
          acc = C_UISettings.MainActivityInitPosOut_x
        else
          local rows = Mathf.Floor(index / C_UISettings.MainActivityRowCount)
          local columns = index % C_UISettings.MainActivityRowCount
          localPosition = Vector3.New(initPos.x + rows * distance.x + columns * Offsetleft + acc, initPos.y + columns * distance.y, 0)
          index = index + 1
        end
        self.activityPosTbl[index] = {
          pos = localPosition,
          transCtr = btnTrans,
          orZoom = topUIInfo.orZoom == 1
        }
      end
    elseif condition == 3 and btnTrans:GetActive() and topUIInfo.orZoom == 2 then
      if topUIInfo.sortid == 0 then
        localPosition = MaxPos
        acc = C_UISettings.MainActivityInitPosOut_x
      else
        local rows = Mathf.Floor(index / C_UISettings.MainActivityRowCount)
        local columns = index % C_UISettings.MainActivityRowCount
        localPosition = Vector3.New(initPos.x + rows * distance.x + columns * Offsetleft + acc, initPos.y + columns * distance.y, 0)
        index = index + 1
      end
      self.activityPosTbl[index] = {
        pos = localPosition,
        transCtr = btnTrans,
        orZoom = topUIInfo.orZoom == 1
      }
    end
  end
  for _, func in pairs(self.activityPosTbl) do
    func.transCtr:SetAnchoredPosition(func.pos.x, func.pos.y)
  end
end

function Main_MainMenuUI:SetMultipleEff()
  self.firstShow = true
  if not self.MultipleEff then
    self.MultipleEff = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi04", self.btn_shopExp, true, Vector3(1, 1, 1))
  end
  self.MultipleEff:SetActive(self.activityState)
  if not self.MultipleEff2 then
    self.MultipleEff2 = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_shopExp, true, Vector3(1, 1, 1))
  end
  self.MultipleEff2:SetActive(false)
end

function Main_MainMenuUI:FirstChargeRecomjudge()
  local roledata = string.format("%s-%d", RechargeData.FIRSTCHARGGIFT, RoleManager.me.id)
  local Info = PlayerPrefs.GetString(roledata)
  if Info then
    self:FirstChargeRecomFun()
  end
end

function Main_MainMenuUI:FirstChargeMaster()
  self.MasterEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_Master, true, Vector3(1, 1, 1))
end

function Main_MainMenuUI:FirstChargeHolyspirit()
  self.HolyspiritEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_Holyspirit, true, Vector3(1, 1, 1))
end

function Main_MainMenuUI:FirstChargeRune()
  self.RuneEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_Runes, true, Vector3(1, 1, 1))
end

function Main_MainMenuUI:FirstChargeNewRune()
  self.NewRuneEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_NewRunes, true, Vector3(1, 1, 1))
end

function Main_MainMenuUI:FirstChargeHolyRing()
  self.HolyRingEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_HolyRing, true, Vector3(1, 1, 1))
  EventManager.Dispatch(Event.InsertAutoPopUI, UIID.Tip_HolyRingOpenUI)
end

function Main_MainMenuUI:FirstChargeTimeLimitedActivity()
  if self.TimeLimitedActivityEffect == nil then
    self.TimeLimitedActivityEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_LimitedTimeActivity, true, Vector3(1.2, 1.2, 1.2))
    self.TimeLimitedActivityEffect:SetActive(true)
  else
    self.TimeLimitedActivityEffect:SetActive(true)
  end
end

function Main_MainMenuUI:FirstChargeHolySkeleton()
  self.HolySkeletonEffect = UIEffectUtility.SetUIEffect("Eff_UI_anniutishi05", self.btn_HolySkeleton, true, Vector3(1, 1, 1))
  EventManager.Dispatch(Event.InsertAutoPopUI, UIID.Tip_HolyBoneOpenUI)
end

function Main_MainMenuUI:FirstChargeRecomFun()
  local function WriteFun(roledata, Group, i, Condition)
    local time = RechargeData.RecomTime
    
    local text = string.format("%s#%s#%s", i, Condition, time)
    Group[i] = text
    local texts = ""
    for k, v in pairs(Group) do
      if k == #Group then
        texts = texts .. v
      else
        texts = texts .. v .. "/"
      end
    end
    PlayerPrefs.SetString(roledata, texts)
  end
  
  if self.btn_firstCharge.gameObject.activeSelf then
    local FirstChargCountdown = RechargeData.GetFirstChargeRecom()
    for i = 1, #FirstChargCountdown do
      local Condition = FirstChargCountdown[i].Condition
      for j = 1, #Condition do
        if ConditionManager.GenerateSingleCondition(Condition[j]):Check() then
          local roledata = string.format("%s-%d", RechargeData.FIRSTCHARGGIFT, RoleManager.me.id)
          local Info = PlayerPrefs.GetString(roledata)
          local Group = string.split(Info, "/")
          if Group[i] then
            local Write = true
            local isopen = true
            local Gr = string.split(Group[i], "#")
            if tonumber(Gr[1]) == i then
              local XX = string.split(Condition[j], "#")
              if Gr[3] == XX[2] then
                if tonumber(Gr[4]) < 0 then
                  isopen = false
                end
                Write = false
              end
            end
            if Write then
              WriteFun(roledata, Group, i, Condition[j])
            end
            if isopen then
              UIManager.Show(UIID.FirstChargeRecom, {
                parent = self.btn_firstCharge.transform
              })
              local ui = UIManager.GetUiByName(UIID.FirstChargeRecom)
              if ui and ui.root and ui.visible then
                ui:Refresh()
              end
            end
          else
            WriteFun(roledata, Group, i, Condition[j])
            UIManager.Show(UIID.FirstChargeRecom, {
              parent = self.btn_firstCharge.transform
            })
            local ui = UIManager.GetUiByName(UIID.FirstChargeRecom)
            if ui and ui.root and ui.visible then
              ui:Refresh()
            end
          end
        end
      end
    end
  end
end

local function UpdateTimerBtn(Prompt)
  Prompt:SetActive(false)
  PlayerControlForceData.PromptBuyDrugsShow = false
end

function Main_MainMenuUI:SetBuyDrugGuide(state, ItemObj)
  local Prompt = ItemObj:GetChild("use_Prompt")
  local promptText = ItemObj:GetChild("use_Prompt/promptText")
  if state then
    if self.PromptBuyDrugTimer then
      self:StopPromptBuyDrugTimer(Prompt)
      UpdateTimerBtn(Prompt)
    end
    promptText:SetText("Thu\225\187\145c kh\195\180ng \196\145\225\187\167, \196\145\225\186\191n mua")
    TextPromptUtility.UIPrompt.Drug = Prompt
    Prompt:SetActive(true)
  elseif not self.PromptBuyDrugTimer then
    Prompt:SetActive(false)
  end
  Prompt:SetOnClick(self, self.PortableStoreOnclick)
end

function Main_MainMenuUI:StopPromptBuyDrugTimer()
  if self.PromptBuyDrugTimer then
    Timer.Stop(self.PromptBuyDrugTimer)
  end
  self.PromptBuyDrugTimer = nil
  PlayerControlForceData.PromptBuyDrugsShow = false
end

function Main_MainMenuUI:PromptBuyDrug(_, Drugid)
  local ItemObj
  local useItemTable = self.useItems
  for i, v in ipairs(SkillSettingData.skill_use_items) do
    if v == Drugid then
      ItemObj = useItemTable[i]
    end
  end
  if ItemObj == nil then
    return
  end
  local Prompt = ItemObj:GetChild("use_Prompt")
  local promptText = ItemObj:GetChild("use_Prompt/promptText")
  if not Prompt.gameObject.activeSelf then
    promptText:SetText("C\195\179 th\225\187\131 mua thu\225\187\145c c\225\186\165p cao h\198\161n")
    Prompt:SetActive(true)
    TextPromptUtility.UIPrompt.Drug = Prompt
    PlayerControlForceData.SetStringPromptBuyDrug(Drugid)
    self.PromptBuyDrugTimer = Timer.StartLoop(PlayerControlForceData.PromptBuyDrugsTime, 1, UpdateTimerBtn, Prompt)
    PlayerControlForceData.PromptBuyDrugsShow = true
  end
  Prompt:SetOnClick(self, self.PortableStoreOnclick)
end

function Main_MainMenuUI:OnCloseRightTopButton()
  if self.activityState and not TranScriptData.InTranscript then
    self:NewBtn_shrinkOnClick()
  end
end

function Main_MainMenuUI:OnOpenRightTopButton()
  if not self.activityState then
    self:NewBtn_shrinkOnClick()
  end
end

function Main_MainMenuUI:OnChangeRightTopBtn(id, state)
  if state ~= self.activityState then
    self:NewBtn_shrinkOnClick()
  end
end

function Main_MainMenuUI:UI_Show(_, msg)
  if not string.isNullOrEmpty(msg) and SystemForecastData.NoticeBtnShowHideUI[msg.name] and self.btn_Forecast.gameObject.activeSelf then
    self.btn_Forecast:SetActive(false)
    EventManager.Dispatch(Event.TaskBtn_indentation, {Preview = false})
    self.btn_ForecastClosetrue = true
  end
end

function Main_MainMenuUI:UI_Hide(_, msg)
  if not string.isNullOrEmpty(msg) and SystemForecastData.NoticeBtnShowHideUI[msg.name] and self.btn_ForecastClosetrue then
    self:RefreshSystemPreview()
    self.btn_ForecastClosetrue = false
  end
end

function Main_MainMenuUI:Task_MianPanelHide()
  self.go_left_topVertical.transform:DOLocalMove(LeftTopPanelManager.GetTaskBtnFlag() and Vector2(-700, 100) or Vector2(250, 100), 0.5)
  self.player_attribute.transform:DOLocalMove(LeftTopPanelManager.GetTaskBtnFlag() and Vector2(-700, self.player_attribute_pos.y) or Vector2(0, self.player_attribute_pos.y), 0.5)
end

function Main_MainMenuUI:RefreshSystemPreview()
  for i, v in pairs(SystemForecastData.NoticeBtnShowHideUI) do
    if UIManager.IsVisible(i) then
      self.btn_ForecastClosetrue = true
      EventManager.Dispatch(Event.TaskBtn_indentation, {
        Preview = self.btn_Forecast.gameObject.activeSelf
      })
      return
    end
  end
  local MainPreview, MianRed = SystemForecastData.GetMainPreviewGear()
  if not MainPreview and not MianRed then
    self.btn_Forecast:SetActive(false)
    EventManager.Dispatch(Event.TaskBtn_indentation, {Preview = false})
    return
  else
    self.btn_Forecast:SetActive(true)
    EventManager.Dispatch(Event.TaskBtn_indentation, {Preview = true})
  end
  self.btn_Forecast:GetChild("img_redPoint"):SetActive(MianRed)
  local ShowPreview = MainPreview and MainPreview or SystemForecastData.Info1[#SystemForecastData.Info1]
  self:SetSprite("Atlas_Common", ShowPreview.imgName, self.lab_imgForecast)
  self.lab_title:SetText(ShowPreview.Name)
  self.btn_Forecast.data = {
    group = ShowPreview.group,
    preview = ShowPreview.preview
  }
end

function Main_MainMenuUI:RefreshTaskShool(First)
  local TaskSchoolBtn = self.btn_TaskSchool.gameObject.activeSelf
  if not First and not TaskSchoolBtn then
    return
  end
  local taskidGrop, Subtypetask, SubTypeidGrop, RewardItems = CommercializeData.GetTaskSchoolInfo()
  local Schoolinfo = TaskData.instituteMiracleTasks
  local chapter, chapterid, chapterCount, Over
  for i, v in pairs(Schoolinfo) do
    if v.state == TaskStateType.Accept then
      chapterid = v.taskTbl.subtype
      break
    end
  end
  for i = 1, #taskidGrop do
    if taskidGrop[i] == chapterid then
      chapter = i
    end
  end
  Over = chapter == nil
  chapter = chapter and chapter or #taskidGrop
  chapterid = chapterid and chapterid or taskidGrop[chapter]
  local pagecount = 0
  local Subdata = Subtypetask[chapterid]
  chapterCount = #Subdata
  for k = 1, chapterCount do
    for i, v in pairs(Schoolinfo) do
      if Subdata[k] == v.taskId and v.state == TaskStateType.Accept then
        pagecount = pagecount + 1
      end
    end
  end
  pagecount = chapterCount - pagecount
  if chapter == self.TaskSchollchapter and pagecount == self.TaskSchoolPage then
    return
  end
  self.TaskSchoolchapter = chapter
  self.TaskSchoolPage = pagecount
  local progress = string.format("DB%sA%sC", pagecount, chapterCount)
  self.lab_TaskSchoolcount:SetText(progress)
  if Over then
    self.lab_TaskSchoolcount:SetColor(EUIColor.Green)
  else
    self.lab_TaskSchoolcount:SetColor(EUIColor.White)
  end
end

function Main_MainMenuUI:SetExpShowUI()
  self:ShowSubUI(UIID.Exp_ExpShowUI, {
    parent = self.go_bottom.transform
  })
end

function Main_MainMenuUI:ShowTip_killMonsterUI()
  self:ShowSubUI(UIID.Tip_killMonsterCardUI, {
    parent = self.go_bottom.transform
  })
end

function Main_MainMenuUI:SelectMonster(_, role)
  if role == nil then
    return
  end
  self.IsAttackBoss = false
  local BossidInfo = MonsterData.GetBossidInfo()
  if BossidInfo[role.data.configId] then
    self.IsAttackBoss = true
  end
  self:SetMultipleEffActive()
end

local docTime = 0
local HelperOpenCount = 0
local tipsLV = 0
local tipsCD = 0
local docTipsCD = 0

function Main_MainMenuUI:SetMultipleEffActive()
  if self.MultipleEff2 then
    local isActive = OnHookData.IsReachLinePoint() and QiJiHelperData.isAutoFight and not self.IsAttackBoss and self.firstShow
    self.MultipleEff2:SetActive(isActive)
    if isActive then
      if UIManager.IsVisible(UIID.ExpUpRecom) or ExpAddData.MultipleTime > 0 then
        return
      end
      local setQijiHelperCount = PlayerPrefs.GetInt(QuickFind.LuaMainPlayerViewAttrData().name .. "HelperArriveCount", 0)
      if HelperOpenCount <= 0 then
        HelperOpenCount = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(2520001, "id").effect)
      end
      if tipsLV <= 0 then
        tipsLV = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(2520006, "id").effect)
      end
      if tipsCD <= 0 then
        tipsCD = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(2520007, "id").effect)
      end
      if setQijiHelperCount < HelperOpenCount and QuickFind.LuaMainPlayerViewAttrData().level >= tipsLV and (docTipsCD <= 0 or Time.time - docTipsCD > tipsCD) then
        docTipsCD = Time.time
        UIManager.Show(UIID.ExpUpRecom, {
          parent = self.btn_shopExp.transform
        })
        setQijiHelperCount = setQijiHelperCount + 1
        PlayerPrefs.SetInt(QuickFind.LuaMainPlayerViewAttrData().name .. "HelperArriveCount", setQijiHelperCount)
      end
    end
  end
end

function Main_MainMenuUI:SetRedPointGuide(_, uiId)
  self.redPointUIId = uiId
  if uiId then
    if not self.redPointGuideTip then
      local name = ""
      if uiId == UIID.Equip_IntensifyUI then
        name = "C\198\176\225\187\157ng h\195\179a"
      elseif uiId == UIID.Equip_OrnamentsUI then
        name = "Trang s\225\187\169c"
      end
      local data = {
        text = name,
        gameObject = self.btn_funcBubble,
        pos = Vector3(-96, 0, 1000),
        scale = Vector3(219.8, 60, 1),
        ok = self.RedPointBubbleOnClick,
        okArgs = self,
        sortOrder = 1000,
        posLeft = Vector3(2.4, -13.3, 0),
        scaLeft = Vector3(26.5, 118, 0),
        rotationLeft = -270,
        posRight = Vector3(2.4, 13.1, 0),
        scaRight = Vector3(26.5, 118, 0),
        rotationRight = 90
      }
      self.redPointGuideTip = TextPromptUtility.SetTextPrompt(data, true)
    else
      local name = ""
      if uiId == UIID.Equip_IntensifyUI then
        name = "C\198\176\225\187\157ng h\195\179a"
      elseif uiId == UIID.Equip_OrnamentsUI then
        name = "Trang s\225\187\169c"
      end
      local str = self.redPointGuideTip:GetText()
      if SkillData.MainMode == EMainModeType.Skill then
        if str == name then
          self.redPointGuideTip:SetActive(true)
        else
          self.redPointGuideTip:SetText(name)
          self.redPointGuideTip:SetActive(true)
        end
        self.redPointGuideTip.data.state = true
      end
    end
  else
    if self.redPointGuideTip then
      self.redPointGuideTip:Destroy()
      self.redPointGuideTip = nil
    end
    if self.redPointSecondTip then
      self.redPointSecondTip:Destroy()
      self.redPointSecondTip = nil
    end
  end
end

function Main_MainMenuUI:RedPointBubbleOnClick()
  self:btn_funcOnClick()
  self.redPointGuideTip:SetActive(false)
  self.redPointGuideTip.data.state = false
  local name = ""
  if self.redPointUIId == UIID.Equip_IntensifyUI then
    name = "C\198\176\225\187\157ng h\195\179a"
  elseif self.redPointUIId == UIID.Equip_OrnamentsUI then
    name = "Trang s\225\187\169c"
  end
  if not self.redPointSecondTip then
    local data = {
      text = name,
      gameObject = self.btn_forgeNav,
      pos = Vector3(-96, 0, 1000),
      scale = Vector3(219.8, 60, 1),
      ok = self.SecondTipOnClick,
      okArgs = self,
      sortOrder = 1000,
      posLeft = Vector3(2.4, -13.3, 0),
      scaLeft = Vector3(26.5, 118, 0),
      rotationLeft = -270,
      posRight = Vector3(2.4, 13.1, 0),
      scaRight = Vector3(26.5, 118, 0),
      rotationRight = 90
    }
    self.redPointSecondTip = TextPromptUtility.SetTextPrompt(data, SkillData.MainMode == EMainModeType.Skill)
  elseif self.redPointSecondTip then
    local str = self.redPointSecondTip:GetText()
    if str ~= name then
      self.redPointSecondTip:SetText(name)
    end
    self.redPointSecondTip:SetActive(true)
    self.redPointSecondTip.data.state = true
  end
end

function Main_MainMenuUI:RedPointBubbleBtnFuncOnClick()
  if not self.redPointGuideTip then
    return
  end
  self.redPointGuideTip:SetActive(SkillData.MainMode == EMainModeType.Skill)
  local name = ""
  if self.redPointUIId == UIID.Equip_IntensifyUI then
    name = "C\198\176\225\187\157ng h\195\179a"
  elseif self.redPointUIId == UIID.Equip_OrnamentsUI then
    name = "Trang s\225\187\169c"
  end
  if not self.redPointSecondTip then
    local data = {
      text = name,
      gameObject = self.btn_forgeNav,
      pos = Vector3(-140, 0, 1000),
      scale = Vector3(219.8, 60, 1),
      ok = self.SecondTipOnClick,
      okArgs = self,
      sortOrder = 1000,
      posLeft = Vector3(0.25, -13, 0),
      scaLeft = Vector3(31.5, 227.7, 0),
      rotationLeft = -270,
      posRight = Vector3(0, 18, 0),
      scaRight = Vector3(31.7, 227.7, 0),
      rotationRight = 90
    }
    self.redPointSecondTip = TextPromptUtility.SetTextPrompt(data, true)
  elseif self.redPointSecondTip then
    local str = self.redPointSecondTip:GetText()
    if str ~= name then
      self.redPointSecondTip:SetText(name)
    end
    self.redPointSecondTip:SetActive(true)
    self.redPointSecondTip.data.state = true
  end
end

function Main_MainMenuUI:UpdateNowTime()
  if Time.GetServerSecondTime() then
    local easternTime = TimeUtility.GetTimeByConture(Time.GetServerSecondTime())
    self.nowTime:SetText(easternTime)
  end
end

function Main_MainMenuUI:SecondTipOnClick()
  UIManager.Show(UIID.Equip_ForgeNavUi)
end

function Main_MainMenuUI:RefreshVipRedPoint(id, msg)
  if id == 50 then
    local novip = true
    for i, v in pairs(msg.coins) do
      if v.itemId == ECoinsType.VipEssence or v.itemId == ECoinsType.integral then
        novip = false
      end
    end
    if novip then
      return
    end
  end
  local bool = false
  local Mainbool = false
  local agrs = {}
  local count = 0
  local total = 4
  local itemCount = RefreshData.TotalRefreshTbl[2360151]
  if type(msg) == type({}) and msg.key == 2360151 then
    count = msg.count
    total = msg.total
  elseif itemCount ~= nil then
    count = itemCount.count
    total = itemCount.total
  end
  if agrs.a or agrs.b then
    self:BtnPosRefresh(nil, true)
  end
end

function Main_MainMenuUI:Scene_SmallBossIcon(id, msg)
  self:SetRightListState(true)
  if self.go_eliteBossAct then
    self.go_eliteBossTemp:SetData(SceneData.SmallIconData)
  else
    self.go_eliteBossNeedRef = true
  end
end

function Main_MainMenuUI:Scene_SmallBossIconEffect(id, msg)
  if self.go_eliteBoss:GetActive() and not self.go_eliteBossAct then
    self:SetRightListOpenState(true)
  end
end

function Main_MainMenuUI:OnMapChange(id, msg)
  SceneData.SmallIconData = {}
  self:SetRightListState(false)
end

function Main_MainMenuUI:Scene_SmallBossShow(id, msg)
  if msg == nil or msg == false then
    SceneData.SmallIconListActive = false
    self:SetRightListState(false)
    return
  end
  SceneData.SmallIconListActive = true
  SceneData.RefreshDistance()
end

function Main_MainMenuUI:ResetEliteBoss(id, msg)
  if self.curSelecteliteBossDoc ~= nil then
    self.curSelecteliteBossDoc.img_select:SetActive(false)
    self.curSelecteliteBossDoc = nil
  end
end

function Main_MainMenuUI:SetSceenSmallBossPos()
  local arrowOffset = self.img_holyRing_guide:GetActive() and 30 or 0
  local x, y = self.go_eliteBoss:GetAnchoredPosition()
  self.go_eliteBoss:SetAnchoredPosition(self.go_eliteBossPosX - arrowOffset, y)
  local War_ActiveListUI = UIManager.GetUiByName(UIID.War_ActiveListUI)
  if War_ActiveListUI and War_ActiveListUI.visible then
    if not War_ActiveListUI.root then
      logError("War_ActiveListUI ch\198\176a load xong")
      return
    end
    local position
    if self.go_eliteBoss.gameObject.activeSelf then
      if self.sw_eliteBossList.gameObject.activeSelf then
        position = Vector3.New(-550 - arrowOffset, 0, 700)
      else
        position = Vector3.New(-357 - arrowOffset, 0, 700)
      end
    else
      position = Vector3.New(-357, 0, 700)
    end
    War_ActiveListUI.root.transform.localPosition = position
  end
end

function Main_MainMenuUI:SetRightListState(state)
  if type(state) ~= "boolean" then
    return
  end
  self:SetSceenSmallBossPos()
end

function Main_MainMenuUI:SetRightListOpenState(state)
  if type(state) ~= "boolean" then
    return
  end
  self.go_eliteBossAct = not state
  self:btn_eliteBossOnClick()
end

function Main_MainMenuUI:RefreshRightList(mapId, isSpecial)
  if self.rightMonsterListTemplate == nil then
    self.rightMonsterListTemplate = luaTemplateManager.GetNewTemplate(self.go_eliteBoss, LuaComponentTemplates.RightMonsterListTemplate)
  end
  if self.rightMonsterListTemplate ~= nil then
    self.rightMonsterListTemplate:Refresh(mapId, isSpecial, self.sw_eliteBossList)
  end
end

function Main_MainMenuUI:RefreshRightListHintEffect()
  if self.rightMonsterListTemplate ~= nil then
    self.rightMonsterListTemplate:RefreshAllHintLight()
  end
end

local curDocTogEff

function Main_MainMenuUI:SetTogEff(_, obj)
  if curDocTogEff ~= nil then
    curDocTogEff:SetActive(false)
  end
  curDocTogEff = obj
  if curDocTogEff ~= nil then
    curDocTogEff:SetActive(true)
  end
end

function Main_MainMenuUI:BindExperienceBonusTemplate()
  if self.experienceBonusViewTemplate == nil then
    self.experienceBonusViewTemplate = luaTemplateManager.GetNewTemplate(self.go_expUp, LuaComponentTemplates.ExperienceBonusViewTemplate)
  end
end

function Main_MainMenuUI:RefreshExperienceBonusView()
  if self.experienceBonusViewTemplate ~= nil then
    self.experienceBonusViewTemplate:InitView()
  end
end

function Main_MainMenuUI:BindExpChangeEvent()
  self:RegistEvent(Event.ExperienceBonusStateChanged, self.ExperienceBonusStateChangedCallBack, self)
  self:RegistEvent(Event.ExperienceBonusDataChanged, self.ExperienceBonusDataChangedCallBack, self)
end

function Main_MainMenuUI:ExperienceBonusStateChangedCallBack()
  if self.experienceBonusViewTemplate then
    self.experienceBonusViewTemplate:ExperienceBonusStateChangedCallBack()
  end
end

function Main_MainMenuUI:ExperienceBonusDataChangedCallBack()
  if self.experienceBonusViewTemplate then
    self.experienceBonusViewTemplate:ExperienceBonusDataChangedCallBack()
  end
end

function Main_MainMenuUI:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function Main_MainMenuUI:GetNormalMemberText()
  if self.mNormalMemberText == nil then
    self.mNormalMemberText = CommercialHolidayData.Getcfg_Ui_wordFun("Newmember_1")
  end
  return self.mNormalMemberText
end

function Main_MainMenuUI:MemberLevelChangedCallBack()
  self:RefreshMemberTextView()
  self:RefreshRightList(SceneData.mapId, true)
end

function Main_MainMenuUI:RefreshTimeRechargeUI(_, isOpen)
  self.btn_timeLimitGift:SetActive(isOpen)
  if isOpen then
    self:TimeRechargeShowTime(TimeUtility.GetToNextDayTime())
  end
end

function Main_MainMenuUI:TimeRechargeShowTime(surplusTime)
  if self.normalTimer then
    Timer.Stop(self.normalTimer)
  end
  local timeStr = TimeUtility.ShowHourTime(surplusTime)
  self.lab_TimeLimit:SetText(string.GetColorText(tostring(timeStr), ItemQuality2ColorDic[7]))
  
  local function UpdateTimer()
    local timeStr = TimeUtility.ShowHourTime(surplusTime)
    surplusTime = surplusTime - 1
    self.lab_TimeLimit:SetText(string.GetColorText(tostring(timeStr), ItemQuality2ColorDic[7]))
    if surplusTime == 0 and self.normalTimer then
      Timer.Stop(self.normalTimer)
      self.normalTimer = nil
      self.lab_TimeLimit:SetText(string.GetColorText("", ItemQuality2ColorDic[7]))
    end
  end
  
  self.normalTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Main_MainMenuUI:RefreshMemberTextView()
  if self:GetMemberDataMgr() == nil then
    return
  end
  local curLevel = self:GetMemberDataMgr():GetMemberLevle()
  if curLevel == 0 then
    self.lab_nextMemberlevel:SetText(self:GetNormalMemberText())
  else
    local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(curLevel)
    self.lab_nextMemberlevel:SetText(memberTbl and memberTbl.showtips and memberTbl.showtips or "")
  end
end

function Main_MainMenuUI:OnSystemOpenTipUIClose()
  self.guideCount = self.guideCount + 1
  self.img_holyRing_guide:SetActive(true)
  local x, y = self.img_holyRing_guide:GetAnchoredPosition()
  self.img_holyRing_guide:SetAnchoredPosition(self.img_holyRing_guidePosX, y)
  self:SetAnimation()
  self:SetRightListState(true)
end

function Main_MainMenuUI:SetAnimation()
  self.img_holyRing_guide.transform:DOKill()
  local left = false
  
  local function MoveLeft()
    self.img_holyRing_guide.transform:DOLocalMoveX(left and self.img_holyRing_guide.transform.localPosition.x - 10 or self.img_holyRing_guide.transform.localPosition.x + 10, 1):OnComplete(function()
      left = not left
      self.img_holyRing_guide.transform:DOLocalMoveX(left and self.img_holyRing_guide.transform.localPosition.x - 10 or self.img_holyRing_guide.transform.localPosition.x + 10, 1):OnComplete(function()
        left = not left
        MoveLeft()
      end)
    end)
  end
  
  MoveLeft()
end

function Main_MainMenuUI:HideGuideArrow()
  self.guideCount = self.guideCount - 1
  if self.guideCount > 0 then
    return
  end
  self.guideCount = 0
  if self.img_holyRing_guide:GetActive() then
    self.img_holyRing_guide:SetActive(false)
    self.img_holyRing_guide.transform:DOKill()
    self:SetRightListState(true)
  end
end

function Main_MainMenuUI:BindBossExpTemplate()
  if self.mBossExpTemplate == nil then
    self.mBossExpTemplate = luaTemplateManager.GetNewTemplate(self.go_killBossExp, LuaComponentTemplates.BossExpTemplate)
  end
end

function Main_MainMenuUI:RefreshRechargeSurprise()
  self:RefreshRechargeSurpriseEffect()
  self:RefreshRechargeSurpriseIcon()
end

function Main_MainMenuUI:RefreshRechargeSurpriseEffect()
  self.surpriseRechargeEffect:SetActive(true)
  self.surpriseRechargeRedPointImg:SetActive(true)
end

function Main_MainMenuUI:RefreshRechargeSurpriseIcon()
  local rechargeData = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetRechargeSurpriseManager():GetRechargeSurpriseDataList()
  self.btn_SurpriseActivity:SetActive(table.count(rechargeData) > 0)
  if table.count(rechargeData) > 0 then
    local leastData = rechargeData[1]
    for i, itemData in pairs(rechargeData) do
      if itemData.giftTime < leastData.giftTime then
        leastData = itemData
      end
    end
    self:RefreshRechargeSprite(leastData)
    local lastServerTimer = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetRechargeSurpriseManager():GetRechargeServerTimer()
    local timeDifference = Time.GetServerTime() - lastServerTimer
    local remainderTimer = (leastData.giftTime - timeDifference) * 0.001
    self:RechargeShowCountdown(remainderTimer)
  elseif self.normalSurpriseTimer then
    Timer.Stop(self.normalSurpriseTimer)
  end
end

function Main_MainMenuUI:RefreshRechargeSprite(data)
  self:SetSprite("Atlas_Common", data.rechargeSurpriseConfig.showIcon, self.icon_Surprise, true)
end

function Main_MainMenuUI:btn_SurpriseActivityOnClick()
  if self.surpriseRechargeEffect and self.surpriseRechargeEffect:GetActive() then
    self.surpriseRechargeEffect:SetActive(false)
    self.surpriseRechargeRedPointImg:SetActive(false)
  end
  if not UIManager.IsVisible(UIID.Recharge_SurpriseUI) then
    UIManager.Show(UIID.Recharge_SurpriseUI)
  end
end

function Main_MainMenuUI:RechargeShowCountdown(surplusTime)
  if self.normalSurpriseTimer then
    Timer.Stop(self.normalSurpriseTimer)
  end
  local timeStr = TimeUtility.ShowTime(surplusTime)
  self.lab_rechargeInvestment:SetText(string.GetColorText(tostring(timeStr), ItemQuality2ColorDic[7]))
  
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    local timeStr = TimeUtility.ShowTime(surplusTime)
    self.lab_rechargeInvestment:SetText(string.GetColorText(tostring(timeStr), ItemQuality2ColorDic[7]))
    if surplusTime <= 0 and self.normalSurpriseTimer then
      Timer.Stop(self.normalSurpriseTimer)
      self.normalSurpriseTimer = nil
      self.lab_rechargeInvestment:SetText(string.GetColorText("", ItemQuality2ColorDic[7]))
      self:RefreshRechargeSurpriseIcon()
    end
  end
  
  self.normalSurpriseTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Main_MainMenuUI:RefreshDimensionalCracks(_, data)
  UIManager.Show(UIID.Tip_MonsterTipUI, {DimensionalCracksData = data})
end

function Main_MainMenuUI:btn_JingHePuzzleOnClick()
  UIManager.Show(UIID.Puzzle_JH_NavUI)
end

function Main_MainMenuUI:ResSpaceCrackTranscriptLeftTopPanel(_, isEnterSpaceCrack)
  if isEnterSpaceCrack then
    if UIManager.IsVisible(UIID.CrossServer_IntoUI) then
      UIManager.Hide(UIID.CrossServer_IntoUI)
    end
    if not UIManager.IsVisible(UIID.Activity_ShiKongUI) then
      UIManager.Show(UIID.Activity_ShiKongUI)
    end
    if UIManager.IsVisible(UIID.LeftTopPanelUI) then
      UIManager.Hide(UIID.LeftTopPanelUI)
    end
    if UIManager.IsVisible(UIID.War_ActiveListUI) then
      UIManager.Hide(UIID.War_ActiveListUI)
    end
  else
    if not UIManager.IsVisible(UIID.LeftTopPanelUI) then
      UIManager.Show(UIID.LeftTopPanelUI)
    end
    if UIManager.IsVisible(UIID.Activity_ShiKongUI) then
      UIManager.Hide(UIID.Activity_ShiKongUI)
    end
  end
  self.go_left_top:SetActive(not isEnterSpaceCrack)
end

function Main_MainMenuUI:JoinVIPRedPoint()
  self.btn_JoinVIPRedPoint:SetActive(false)
end

function Main_MainMenuUI:DoFourPartyRivalryBeforeEntering()
  self.uiFsm:SetState(StateID.FourPartyRivalryUIStateID)
end

function Main_MainMenuUI:DoFourPartyRivalryBeforeLeaving()
  self.uiFsm:SetState(StateID.TaskUIStateID)
end

function Main_MainMenuUI:EnterFourPartyRivalryScene()
  self:ShowSubUI(UIID.Activity_SiFangUI, {
    parent = self.go_left.transform
  })
  if not table.contains(self.TempSubPanelNameList, UIID.Activity_SiFangUI) then
    table.insert(self.TempSubPanelNameList, UIID.Activity_SiFangUI)
  end
end

function Main_MainMenuUI:QuitFourPartyRivalryScene()
  self:HideSubUI(UIID.Activity_SiFangUI)
end
