Commercialization_FirstActivityUI = class(BaseUI)
Commercialization_FirstActivityUI.layer = UILayer.Panel
Commercialization_FirstActivityUI.orderInLayer = 2
Commercialization_FirstActivityUI.hideType = UIHideType.WaitDestroy
Commercialization_FirstActivityUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercialization_FirstActivityUI.escClose = UIEscClose.DontClose

function Commercialization_FirstActivityUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.go_getWeek = self:GetControl("go_getWeek")
  self.tog_day1 = self:GetControl("go_getWeek/sw_weekBtns/Content/tog_day1")
  self.tog_day2 = self:GetControl("go_getWeek/sw_weekBtns/Content/tog_day2")
  self.tog_day3 = self:GetControl("go_getWeek/sw_weekBtns/Content/tog_day3")
  self.tog_day4 = self:GetControl("go_getWeek/sw_weekBtns/Content/tog_day4")
  self.tog_day5 = self:GetControl("go_getWeek/sw_weekBtns/Content/tog_day5")
  self.tog_day6 = self:GetControl("go_getWeek/sw_weekBtns/Content/tog_day6")
  self.tog_day7 = self:GetControl("go_getWeek/sw_weekBtns/Content/tog_day7")
  self.sw_firstActivityList = self:GetControl("sw_firstActivityList")
  self.tog_SevenDaysSignIn = self:GetControl("sw_firstActivityList/Viewport/Content/tog_SevenDaysSignIn")
  self.tog_firstGift = self:GetControl("sw_firstActivityList/Viewport/Content/tog_firstGift")
  self.tog_sportsBoss = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsBoss")
  self.tog_BossFirstKill = self:GetControl("sw_firstActivityList/Viewport/Content/tog_BossFirstKill")
  self.tog_EquipFirstGet = self:GetControl("sw_firstActivityList/Viewport/Content/tog_EquipFirstGet")
  self.tog_sportsLevel = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsLevel")
  self.tog_sportsIntensify = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsIntensify")
  self.tog_sportsExcellence = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsExcellence")
  self.tog_sportsZhuijia = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsZhuijia")
  self.tog_sportsOrnaments = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsOrnaments")
  self.tog_sportsFruit = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsFruit")
  self.tog_sportsFight = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsFight")
  self.tog_sportsEquip = self:GetControl("sw_firstActivityList/Viewport/Content/tog_sportsEquip")
  self.tog_guardInvest = self:GetControl("sw_firstActivityList/Viewport/Content/tog_guardInvest")
  self.go_firstGift = self:GetControl("go_firstGift")
  self.txt_lastTimeGift = self:GetControl("go_firstGift/txt_lastTimeGift")
  self.lab_lastTimeGift = self:GetControl("go_firstGift/lab_lastTimeGift")
  self.sw_firstGift = self:GetControl("go_firstGift/sw_firstGift")
  self.bg_firstGist = self:GetControl("go_firstGift/sw_firstGift/Viewport/Content/bg_firstGist")
  self.lab_firstGistName = self:GetControl("go_firstGift/sw_firstGift/Viewport/Content/bg_firstGist/lab_firstGistName")
  self.sw_ItemSecondary = self:GetControl("go_firstGift/sw_firstGift/Viewport/Content/bg_firstGist/go_firstGistItem/sw_ItemSecondary")
  self.img_recommend = self:GetControl("go_firstGift/sw_firstGift/Viewport/Content/bg_firstGist/img_recommend")
  self.go_sportsLevelrank = self:GetControl("go_sportsLevelrank")
  self.img_sportsLevelrank = self:GetControl("go_sportsLevelrank/img_sportsLevelrank")
  self.lab_descLevelrank = self:GetControl("go_sportsLevelrank/lab_descLevelrank")
  self.txt_lastTime = self:GetControl("go_sportsLevelrank/txt_lastTime")
  self.lab_lastTimeLevelrank = self:GetControl("go_sportsLevelrank/lab_lastTimeLevelrank")
  self.sw_spirtsrankList = self:GetControl("go_sportsLevelrank/sw_spirtsrankList")
  self.img_datarankBg = self:GetControl("go_sportsLevelrank/sw_spirtsrankList/Viewport/Content/img_datarankBg")
  self.img_dataSelfTaskBg = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg")
  self.lab_SelfTaskcondition = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/lab_SelfTaskcondition")
  self.SelfTaskbtn_Item = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/sw_gift/Viewport/Content/SelfTaskbtn_Item")
  self.SelfTaskgo_state = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/SelfTaskgo_state")
  self.SelfTaskbtn_get = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/SelfTaskgo_state/SelfTaskbtn_get")
  self.Eff_UI_SelfTask = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/SelfTaskgo_state/SelfTaskbtn_get/Eff_UI_SelfTask")
  self.SelfTasklab_Finish = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/SelfTaskgo_state/SelfTasklab_Finish")
  self.SelfTasklab_Noaccomp = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/SelfTaskgo_state/SelfTasklab_Noaccomp")
  self.SelfTasklab_Targetpro = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/SelfTaskgo_state/SelfTasklab_Targetpro")
  self.lab_sportsMyRank = self:GetControl("go_sportsLevelrank/img_dataSelfTaskBg/lab_sportsMyRank")
  self.go_EquipFirstGet = self:GetControl("go_EquipFirstGet")
  self.lab_descEquipFirstGet = self:GetControl("go_EquipFirstGet/lab_descEquipFirstGet")
  self.txt_lastTimEquipFirstKill = self:GetControl("go_EquipFirstGet/txt_lastTimEquipFirstKill")
  self.lab_lastTimeEquipFirstKill = self:GetControl("go_EquipFirstGet/lab_lastTimeEquipFirstKill")
  self.sw_equipFirstGetList = self:GetControl("go_EquipFirstGet/sw_equipFirstGetList")
  self.img_dataBgEquipFirstGet = self:GetControl("go_EquipFirstGet/img_dataBgEquipFirstGet")
  self.go_BossFirstKill = self:GetControl("go_BossFirstKill")
  self.lab_titilBossFirstKill = self:GetControl("go_BossFirstKill/lab_titilBossFirstKill")
  self.lab_descBossFirstKill = self:GetControl("go_BossFirstKill/lab_descBossFirstKill")
  self.txt_lastTimeBossFirstKill = self:GetControl("go_BossFirstKill/txt_lastTimeBossFirstKill")
  self.lab_lastTimeBossFirstKill = self:GetControl("go_BossFirstKill/lab_lastTimeBossFirstKill")
  self.sw_BossFirstKillList = self:GetControl("go_BossFirstKill/sw_BossFirstKillList")
  self.img_dataBgBossFirstKill = self:GetControl("go_BossFirstKill/sw_BossFirstKillList/Viewport/Content/img_dataBgBossFirstKill")
  self.go_TaskReward = self:GetControl("go_TaskReward")
  self.Content = self:GetControl("go_TaskReward/scroll_shop/Viewport/Content")
  self.go_item = self:GetControl("go_TaskReward/scroll_shop/Viewport/Content/go_item")
  self.btn_MonsterRewarItem = self:GetControl("go_TaskReward/scroll_shop/Viewport/Content/go_item/TaskContent/btn_MonsterRewarItem")
  self.nameText = self:GetControl("go_TaskReward/lab_name/nameText")
  self.imgName = self:GetControl("go_TaskReward/lab_name/imgName")
  self.PeriodicalReward = self:GetControl("go_TaskReward/PeriodicalReward")
  self.PeriodicalReward_Item = self:GetControl("go_TaskReward/PeriodicalReward/PeriodicalReward_Item")
  self.img_redPoint = self:GetControl("go_TaskReward/PeriodicalReward/PeriodicalReward_Item/img_redPoint")
  self.taskdes = self:GetControl("go_TaskReward/taskdes")
  self.lingquperiodical = self:GetControl("go_TaskReward/lingquperiodical")
  self.Image_Received = self:GetControl("go_TaskReward/Image_Received")
  self.txt_lastTimBoss = self:GetControl("go_TaskReward/txt_lastTimBoss")
  self.lab_lastTimeBoss = self:GetControl("go_TaskReward/lab_lastTimeBoss")
  self.btn_left = self:GetControl("go_TaskReward/btn_left")
  self.btn_right = self:GetControl("go_TaskReward/btn_right")
  self.go_guardInvest = self:GetControl("go_guardInvest")
  self.guardContent = self:GetControl("go_guardInvest/sw_guardList/Viewport/guardContent")
  self.tog_DamageIncreased = self:GetControl("go_guardInvest/sw_guardList/Viewport/guardContent/tog_DamageIncreased")
  self.tog_DamageReduction = self:GetControl("go_guardInvest/sw_guardList/Viewport/guardContent/tog_DamageReduction")
  self.tog_ReduceAttackSpeed = self:GetControl("go_guardInvest/sw_guardList/Viewport/guardContent/tog_ReduceAttackSpeed")
  self.lab_activityDateTime = self:GetControl("go_guardInvest/lab_activityDateTime")
  self.img_guardInvestAvtice = self:GetControl("go_guardInvest/img_guardInvestAvtice")
  self.img_blackBg = self:GetControl("go_guardInvest/img_guardInvestAvtice/img_blackBg")
  self.img_redBg = self:GetControl("go_guardInvest/img_guardInvestAvtice/img_redBg")
  self.sw_guardInvestList = self:GetControl("go_guardInvest/sw_guardInvestList")
  self.descBtn = self:GetControl("descBtn")
end

function Commercialization_FirstActivityUI:OnPreLoad()
end

local this = Commercialization_FirstActivityUI

function Commercialization_FirstActivityUI:Init()
  self.SportsLeveInfo, self.SportsEquipInfo, self.SportsIntensifyInfo, self.SportsZhuijiaInfo, self.EquipFirstInfo, self.BossFirstKill, self.SportsExcellenc, self.SportsJewelry, self.SportsFruitInfo, self.SportsFightInfo, self.SportsBoss, self.SevenDaysSignIn = CommercializeData:InitializeSportinfo()
  self.OpenFristcurshopInfo = nil
  self.FristGiftTableCondition = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.Openingser)[1].condition
  self:InitUnionTask()
  self.isOpen = false
end

function Commercialization_FirstActivityUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnBtnItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnBtnItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  local posy = 0
  local posx = -82
  if ui.descBtn.group == CommercializeOpeningserGrop.BossFirstKill or ui.descBtn.group == CommercializeOpeningserGrop.EquipFirstGet or ui.descBtn.group == CommercializeOpeningserGrop.Openingser then
    posx = 0
  end
  ctr.modelData.itemData.tipsPosition = Vector3(posx, posy, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function GetUIText(title)
  return LocalizationUtility.GetContentByKey(title)
end

local function OnfirstGistCreat(ctr)
  ctr.lab_firstGistName = UIControl(ctr.transform, "lab_firstGistName")
  ctr.btn_Item = UIControl(ctr.transform, "go_firstGistItem/sw_ItemSecondary/Viewport/Content/btn_Item")
  ctr.lab_limitNum = UIControl(ctr.transform, "lab_limit/lab_limitNum")
  ctr.img_recommend = UIControl(ctr.transform, "img_recommend")
  ctr.img_sellOut = UIControl(ctr.transform, "img_sellOut")
  ctr.lab_buy = UIControl(ctr.transform, "btn_freePrize/lab_buy")
  ctr.btn_freePrize = UIControl(ctr.transform, "btn_freePrize")
  ctr.MainitemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "go_firstGistItem/btn_ItemMain"))
  ctr.MainmodelData = ItemCellData()
end

local GuideEffecName = "Eff_UI_annuikuang06"

local function OnfirstGistRefresh(ctr, _, data, ui)
  ctr.lab_firstGistName:SetText(GetUIText(data.title))
  local recommend = data.recommend == 1 and true or false
  ctr.img_recommend:SetActive(recommend)
  local limet = data.refreshCountLimit - data.keycount
  ctr.lab_limitNum:SetText(limet .. "A")
  if ctr.FirstBtnItemContainer == nil then
    ctr.FirstBtnItemContainer = UIContainer(ctr.btn_Item, ui, OnBtnItemCreat, OnBtnItemRefresh)
  end
  ctr.FirstBtnItemContainer:SetData(data.BoxItem)
  if data.rmb ~= nil then
    local rmb = math.modf(data.rmb / 100)
    ctr.btn_freePrize.rmb = rmb
    ctr.btn_freePrize.count = data.rmb
    ctr.btn_freePrize.id = data.id
    ctr.lab_buy:SetText("" .. math.modf(rmb) .. "VND")
  else
    ctr.btn_freePrize.rmb = nil
    ctr.btn_freePrize.count = data.itembuycount
    ctr.btn_freePrize.cost = data.costs
    ctr.btn_freePrize.id = data.id
    local buytext = string.format("%s%s", data.itembuycount, "KC")
    ctr.lab_buy:SetText(buytext)
  end
  local effectItem = ctr.transform:Find(GuideEffecName)
  if data.soldout then
    ctr.btn_freePrize:SetActive(false)
    ctr.img_sellOut:SetActive(true)
    if effectItem then
      effectItem.gameObject:SetActive(false)
    end
  else
    if ui.args and (ui.args.ZhuanZhong == data.id or tonumber(ui.args.shopID) == data.id) then
      if not effectItem then
        effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, Vector2(1.5, 2.6), Vector3(0, -180, 0))
      else
        effectItem.gameObject:SetActive(true)
      end
      ui.args.ZhuanZhong = nil
    elseif effectItem then
      effectItem.gameObject:SetActive(false)
    end
    ctr.btn_freePrize:SetActive(true)
    ctr.img_sellOut:SetActive(false)
  end
  ctr.btn_freePrize:SetOnClick(ui, ui.OnFristActClickBuy)
end

local function OnSprotActivtItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnSprotActivtItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  local posy = 0
  local posx = -82
  if ui.descBtn.group == CommercializeOpeningserGrop.BossFirstKill or ui.descBtn.group == CommercializeOpeningserGrop.EquipFirstGet or ui.descBtn.group == CommercializeOpeningserGrop.Openingser then
    posy = 0
    posx = 0
  end
  ctr.modelData.itemData.tipsPosition = Vector3(posx, posy, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function OnSprotActivtCreat(ctr)
  ctr.btn_Item = UIControl(ctr.transform, "sw_gift/Viewport/Content/btn_Item")
  ctr.btn_get = UIControl(ctr.transform, "go_state/btn_get")
  ctr.lab_alreadyGet = UIControl(ctr.transform, "go_state/lab_alreadyGet")
  ctr.lab_CanNotGet = UIControl(ctr.transform, "go_state/lab_CanNotGet")
  ctr.lab_bossname = UIControl(ctr.transform, "go_bossInfo/lab_bossname")
  ctr.lab_firstKillName = UIControl(ctr.transform, "go_bossInfo/lab_firstKillName")
  ctr.btn_ItemKill = UIControl(ctr.transform, "sw_firstKillGift/Viewport/Content/btn_Item")
  ctr.Item_alreadyGet = UIControl(ctr.transform, "go_state/Item_alreadyGet")
  ctr.ItemInfoitemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "btn_ItemInfo"))
  ctr.ItemInfomodelData = ItemCellData()
end

local function OnSprotActivtRefresh(ctr, _, data, ui)
  local ServerGift, SelfGIft
  for i = 1, #data do
    if data[i].type == 1 then
      SelfGIft = data[i]
    else
      ServerGift = data[i]
    end
  end
  local titile = GetUIText(SelfGIft.taskKillgift.title)
  ctr.lab_bossname:SetText(titile)
  local extra = string.isNullOrEmpty(SelfGIft.Msg.extra) and ServerGift.Msg.extra or SelfGIft.Msg.extra
  if not string.isNullOrEmpty(extra) then
    ctr.lab_firstKillName:SetText(ServerGift.Msg.extra)
    ctr.Item_alreadyGet:SetActive(ServerGift.Msg.extra ~= ViewData.meData.name)
  else
    ctr.lab_firstKillName:SetText("Tr\225\187\145ng")
    ctr.Item_alreadyGet:SetActive(false)
  end
  if ctr.BoosFristKillItemContainer == nil then
    ctr.BoosFristKillItemContainer = UIContainer(ctr.btn_Item, ui, OnSprotActivtItemCreat, OnSprotActivtItemRefresh)
  end
  local BoxItemSelf = CommercializeData.CurrentOccupation(SelfGIft.BoxKillItem)
  ctr.BoosFristKillItemContainer:SetData(BoxItemSelf)
  if ctr.SprotActivtItemContainer == nil then
    ctr.SprotActivtItemContainer = UIContainer(ctr.btn_ItemKill, ui, OnSprotActivtItemCreat, OnSprotActivtItemRefresh)
  end
  local BoxItemSer = CommercializeData.CurrentOccupation(ServerGift.BoxKillItem)
  ctr.SprotActivtItemContainer:SetData(BoxItemSer)
  local CanGet = SelfGIft.Msg.giftInfo[1].canGet
  local GetCount = SelfGIft.refreshCountLimitrole - SelfGIft.Msg.giftInfo[1].roleCount
  ctr.lab_alreadyGet:SetActive(CanGet and GetCount <= 0)
  ctr.lab_CanNotGet:SetActive(not CanGet)
  ctr.lab_CanNotGet.id = SelfGIft.TaskGoalgoalParam
  ctr.lab_CanNotGet:SetOnClick(ui, ui.lab_CanNotGetBtn)
  ctr.btn_get:SetActive(CanGet and 0 < GetCount)
  ctr.btn_get.Killname = ServerGift.Msg.extra
  ctr.btn_get.Killid = ServerGift.taskKillgift.id
  ctr.btn_get.id = SelfGIft.taskKillgift.id
  ctr.btn_get.OpenSprotCurgroup = SelfGIft.group
  ctr.btn_get:SetOnClick(ui, ui.SprotActivtGetGiftBtn)
end

local function OnSprotrankActivtCreat(ctr)
  ctr.btn_Item = UIControl(ctr.transform, "sw_gift/Viewport/Content/btn_Item")
  ctr.lab_RoleName = UIControl(ctr.transform, "lab_RoleName")
  ctr.lab_RoleLevel = UIControl(ctr.transform, "lab_RoleLevel")
  ctr.one = UIControl(ctr.transform, "ico_rank/one")
  ctr.two = UIControl(ctr.transform, "ico_rank/two")
  ctr.three = UIControl(ctr.transform, "ico_rank/three")
  ctr.four = UIControl(ctr.transform, "ico_rank/four")
  ctr.img_noOne = UIControl(ctr.transform, "img_noOne")
end

local function OnSprotrankActivtRefresh(ctr, _, data, ui)
  if ctr.SprotrankActivtItemContainer == nil then
    ctr.SprotrankActivtItemContainer = UIContainer(ctr.btn_Item, ui, OnSprotActivtItemCreat, OnSprotActivtItemRefresh)
  end
  local BoxItem = CommercializeData.CurrentOccupation(data.BoxItem)
  ctr.SprotrankActivtItemContainer:SetData(BoxItem)
  if _ == 1 and not ctr.effobj then
    ctr.effobj = ctr.SprotrankActivtItemContainer.items[#BoxItem]
    ctr.effobj.Eff = UIEffectUtility.SetUIEffect("Eff_UI_xuanshangjiangli02", ctr.effobj, true, Vector3(2.5, 2.5, 500))
  end
  ctr.one:SetActive(_ == 1)
  ctr.two:SetActive(_ == 2)
  ctr.three:SetActive(_ == 3)
  ctr.four:SetActive(4 <= _)
  ctr.four:SetText("H\225\186\161ng" .. _ .. "0")
  local name = data.MsgRank and data.MsgRank.name or ""
  local levle = data.MsgRank and data.MsgRank.val or ""
  ctr.lab_RoleName:SetText(name)
  local open = data.MsgRank and true or false
  ctr.img_noOne:SetActive(not open)
  local myRank = type(data.myRank) == type(0) and data.myRank or 111
  if data.status ~= -1 and (myRank > data.status or data.status == 0) then
    ctr.lab_RoleLevel:SetActive(false)
  else
    ctr.lab_RoleLevel:SetActive(true)
    if string.isNullOrEmpty(levle) then
      ctr.lab_RoleLevel:SetActive(false)
    else
      local showText = ""
      if data.groupId == 101 then
        showText = ClientTable.cfg_Character_levelManager:GetLevelDes(levle)
      else
        showText = string.format(data.open, levle)
      end
      ctr.lab_RoleLevel:SetText(showText)
      ctr.lab_RoleLevel:SetActive(true)
    end
  end
end

function Commercialization_FirstActivityUI:SetSelfTaskFun(data)
  local giftdata = data.MsgTask.giftInfo[1]
  self.redPointHide = giftdata.canGet and giftdata.roleCount == 0
  self.SelfTaskbtn_get:SetActive(self.redPointHide)
  if not self.redPointHide then
    EventManager.Dispatch(Event.RefreshOpenServiceRedPointParam, self.redPointName)
  end
  self.SelfTasklab_Noaccomp:SetActive(false)
  if not giftdata.canGet then
    self.SelfTasklab_Noaccomp:SetActive(true)
    self.SelfTasklab_Finish:SetActive(false)
  else
    self.SelfTasklab_Finish:SetActive(giftdata.roleCount ~= 0)
  end
  if data.MsgTask.current >= data.Goals.goalCount then
    self.SelfTasklab_Targetpro:SetText(data.Goals.goalTips)
    self.SelfTaskgo_state:SetActive(true)
    self.lab_SelfTaskcondition:SetActive(false)
  else
    local desc = LocalizationUtility.GetContentByKey(data.desc)
    local text
    text = string.format(desc, data.MsgTask.current, data.Goals.goalCount)
    self.lab_SelfTaskcondition:SetText(text)
    self.SelfTaskgo_state:SetActive(false)
    self.lab_SelfTaskcondition:SetActive(true)
  end
  self.SprotSelfTaskItemContainer:SetData(data.BoxItem)
  self.SelfTaskbtn_get.OpenSprotCurgroup = data.group
  self.SelfTaskbtn_get.id = data.taskgift.id
  self.SelfTaskbtn_get:SetOnClick(self, self.SprotActivtGetGiftBtn)
end

local RawImageTbl = {}

function Commercialization_FirstActivityUI:LoadingImages(img, obj)
  self.cor = Coroutine.Start(function()
    local name = string.format("Texture/%s.png", img)
    local request = self:LoadAssetAsync(name, typeof(CS.UnityEngine.Texture2D))
    Coroutine.Yield(request)
    if request.isError then
      logError(request.error)
      Coroutine.Break()
    end
    obj:SetTexture(request.res)
    self.cor = nil
  end)
end

function Commercialization_FirstActivityUI:InitUI()
  self.FirstGistContainer = UIContainer(self.bg_firstGist, self, OnfirstGistCreat, OnfirstGistRefresh)
  self.SprotLevelrankContainer = UIContainer(self.img_datarankBg, self, OnSprotrankActivtCreat, OnSprotrankActivtRefresh)
  self.SprotSelfTaskItemContainer = UIContainer(self.SelfTaskbtn_Item, self, OnSprotActivtItemCreat, OnSprotActivtItemRefresh)
  self.BossFirstKillContainer = UIContainer(self.img_dataBgBossFirstKill, self, OnSprotActivtCreat, OnSprotActivtRefresh)
  self.weekBtns = {
    self.tog_day1,
    self.tog_day2,
    self.tog_day3,
    self.tog_day4,
    self.tog_day5,
    self.tog_day6,
    self.tog_day7
  }
  for i, ctr in pairs(self.weekBtns) do
    ctr.btn_ItemDay = UIControl(ctr.transform, "btn_ItemDay")
    ctr.btn_SignIn = UIControl(ctr.transform, "btn_SignIn")
    ctr.CheckedIn = UIControl(ctr.transform, "CheckedIn")
    ctr.btn_Reissue = UIControl(ctr.transform, "btn_Reissue")
    ctr.btn_ToSignIn = UIControl(ctr.transform, "btn_ToSignIn")
    ctr.Background = UIControl(ctr.transform, "Background")
    ctr.Checkmark = UIControl(ctr.transform, "Checkmark")
    ctr.Expected = UIControl(ctr.transform, "Expected")
    ctr.Reissued = UIControl(ctr.transform, "Reissued")
  end
  self:InitUnionUI()
end

function Commercialization_FirstActivityUI:EquipFirstTableView()
  self.EquipFirsttableView = UITableView()
  self.EquipFirsttableView:SetLowerMargin(0)
  self.EquipFirsttableView:SetScrollView(self.sw_equipFirstGetList)
  self.EquipFirsttableView:SetScalarForCellInTableView(self, self.ScalarForCellInEquipTableView)
  self.EquipFirsttableView:SetUpperMargin(0)
  self.EquipFirsttableView:SetTotalCellCount(self, self.NumberOfCellsInEquipTableView)
  self.EquipFirsttableView:SetCellAtIndexInTableView(self, self.CellAtIndexInEquipTableView)
  self.EquipFirsttableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInEquipTableViewWillAppear)
  self.EquipFirsttableView:ReloadData(1)
end

function Commercialization_FirstActivityUI:ScalarForCellInEquipTableView()
  local sizeX, sizeY = self.img_dataBgEquipFirstGet:GetSizeDelta()
  return sizeY
end

function Commercialization_FirstActivityUI:NumberOfCellsInEquipTableView()
  return #self.ShowEquipFirstInfo
end

function Commercialization_FirstActivityUI:CellAtIndexInEquipTableView(index)
  return self.EquipFirsttableView:ReuseOrCreateCell(self.img_dataBgEquipFirstGet)
end

function Commercialization_FirstActivityUI:CellAtIndexInEquipTableViewWillAppear(index)
  local data = self.ShowEquipFirstInfo[index]
  local ShowData = {}
  local CanGetType, NoCanGetType, NoCount, GotoType
  for i, v in pairs(data) do
    local CanGet = v.Msg.giftInfo[1].canGet
    local RoleGetCount = v.refreshCountLimitrole - v.Msg.giftInfo[1].roleCount
    local SerGetCount = v.refreshCountLimitser - v.Msg.giftInfo[1].systemCount
    if 0 < SerGetCount then
      if CanGet then
        if 0 < RoleGetCount then
          CanGetType = v
          break
        else
          NoCanGetType = v
        end
      else
        GotoType = v
      end
    else
      NoCount = v
      break
    end
  end
  if NoCount then
    ShowData = NoCount
  elseif CanGetType then
    ShowData = CanGetType
  elseif GotoType then
    ShowData = GotoType
  else
    ShowData = NoCanGetType
  end
  local chatCell = self.EquipFirsttableView:GetLoadedCell(index)
  local btn_Item = chatCell:GetChild("sw_gift/Viewport/Content/btn_Item")
  local btn_get = chatCell:GetChild("go_state/btn_get")
  local lab_alreadyGet = chatCell:GetChild("go_state/lab_alreadyGet")
  local lab_CanNotGet = chatCell:GetChild("go_state/lab_CanNotGet")
  local lab_NoGet = chatCell:GetChild("go_state/lab_NoGet")
  local lab_severCountKey = chatCell:GetChild("lab_severCountKey")
  local btn_ItemInfo = chatCell:GetChild("btn_ItemInfo")
  local CanGet = ShowData.Msg.giftInfo[1].canGet
  local RoleGetCount = ShowData.refreshCountLimitrole - ShowData.Msg.giftInfo[1].roleCount
  local SerGetCount = ShowData.refreshCountLimitser - ShowData.Msg.giftInfo[1].systemCount
  local titctr = string.split(ShowData.taskgift.title, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(titctr[2]))
  if chatCell.ActivtItemContainer == nil then
    chatCell.ActivtItemContainer = UIContainer(btn_ItemInfo, self, OnSprotActivtItemCreat, OnSprotActivtItemRefresh)
  end
  chatCell.ActivtItemContainer:SetData({itemData})
  local severtext = string.format("<color=#CCCCCC>Su\225\186\165t c\195\178n l\225\186\161i: </color><color=#1ADD1F>%s</color>", SerGetCount)
  lab_severCountKey:SetText(severtext)
  if chatCell.SprotActivtItemContainer == nil then
    chatCell.SprotActivtItemContainer = UIContainer(btn_Item, self, OnSprotActivtItemCreat, OnSprotActivtItemRefresh)
  end
  local BoxItem = CommercializeData.CurrentOccupation(ShowData.BoxItem)
  chatCell.SprotActivtItemContainer:SetData(BoxItem)
  btn_get:SetActive(0 < SerGetCount and CanGet and 0 < RoleGetCount)
  lab_alreadyGet:SetActive(0 < SerGetCount and CanGet and RoleGetCount <= 0)
  lab_CanNotGet:SetActive(0 < SerGetCount and not CanGet)
  lab_NoGet:SetActive(SerGetCount <= 0)
  btn_get.OpenSprotCurgroup = ShowData.group
  btn_get.id = ShowData.taskgift.id
  btn_get.index = index
  btn_get:SetOnClick(self, self.SprotActivtGetGiftBtn)
  lab_CanNotGet:SetOnClick(self, self.lab_CanNotGetBtn)
end

function Commercialization_FirstActivityUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.openActivity,
    state = true
  })
  self:IsShowRedPoint()
  self:JumpLeftTag()
end

function Commercialization_FirstActivityUI:OnHide()
  self.FristServerGiftinfo = nil
  self:SetDestroyTime()
  self.EquipKillIndex = 1
end

function Commercialization_FirstActivityUI:OnDestroy()
end

function Commercialization_FirstActivityUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.btnlab_descBtn)
  self.btn_left:SetOnClick(self, self.OnClickLeftLevel)
  self.btn_right:SetOnClick(self, self.OnClickRightLevel)
  self.lingquperiodical:SetOnClick(self, self.ShowPeriodicalReward)
  self.tog_firstGift:SetOnToggleChanged(self, self.tog_firstGiftOnChanged)
  self.tog_sportsLevel:SetOnToggleChanged(self, self.tog_sportsLevelOnChanged)
  self.tog_sportsEquip:SetOnToggleChanged(self, self.tog_sportsEquipOnChanged)
  self.tog_sportsIntensify:SetOnToggleChanged(self, self.tog_sportsIntensifyOnChanged)
  self.tog_sportsZhuijia:SetOnToggleChanged(self, self.tog_sportsZhuijiaOnChanged)
  self.tog_BossFirstKill:SetOnToggleChanged(self, self.tog_BossFirstKillOnChanged)
  self.tog_EquipFirstGet:SetOnToggleChanged(self, self.tog_EquipFirstGetOnChanged)
  self.tog_sportsExcellence:SetOnToggleChanged(self, self.tog_sportsExcellenceOnChanged)
  self.tog_sportsOrnaments:SetOnToggleChanged(self, self.tog_sportsOrnamentsOnChanged)
  self.tog_sportsFruit:SetOnToggleChanged(self, self.tog_sportsFruitOnChanged)
  self.tog_sportsFight:SetOnToggleChanged(self, self.tog_sportsFightOnChanged)
  self.tog_sportsBoss:SetOnToggleChanged(self, self.tog_sportsBossOnChanged)
  self.tog_SevenDaysSignIn:SetOnToggleChanged(self, self.tog_SevenDaysSignInOnChanged)
  self.tog_guardInvest:SetOnToggleChanged(self, self.tog_GuardInvestOnChanged)
  self.tog_DamageIncreased:SetOnToggleChanged(self, self.tog_DamageIncreasedOnChanged)
  self.tog_DamageReduction:SetOnToggleChanged(self, self.tog_DamageReductionOnChanged)
  self.tog_ReduceAttackSpeed:SetOnToggleChanged(self, self.tog_ReduceAttackSpeedOnChanged)
end

function Commercialization_FirstActivityUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.CommercializationActivityUI)
end

function Commercialization_FirstActivityUI:btnlab_descBtn(control)
  local id = 0
  if control.group == CommercializeOpeningserGrop.SportsLevel then
    id = 1037
  elseif control.group == CommercializeOpeningserGrop.SportsIntensify then
    id = 1038
  elseif control.group == CommercializeOpeningserGrop.SportsJewelry then
    id = 1041
  elseif control.group == CommercializeOpeningserGrop.SportsZhuijia then
    id = 1040
  elseif control.group == CommercializeOpeningserGrop.EquipFirstGet then
    id = 1036
  elseif control.group == CommercializeOpeningserGrop.BossFirstKill then
    id = 1035
  elseif control.group == CommercializeOpeningserGrop.SportsFruit then
    id = 1042
  elseif control.group == CommercializeOpeningserGrop.SportsFight then
    id = 1043
  elseif control.group == CommercializeOpeningserGrop.SportsExcellenc then
    id = 1039
  elseif control.group == CommercializeOpeningserGrop.weekSignIn then
    id = 1049
  end
  UIManager.Show(UIID.System_DescUI, {id = id})
end

local function SendOpenserActMessge(groupId)
  this.OpenSprotCurgroup = nil
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
    icon = CommercializeActivityTab.Opening_service,
    groupId = groupId
  })
end

function Commercialization_FirstActivityUI:JumpLeftTag()
  if self.args == nil then
    return
  end
  if self.args.openFirstTab == CommercializeOpeningserGrop.GuardInvest then
    self.tog_guardInvest:SetIsOn(true)
    SendOpenserActMessge(CommercializeOpeningserGrop.GuardInvest)
    self:InitGuardInvestUI()
  elseif self.args.openFirstTab == CommercializeOpeningserGrop.Openingser then
    self.tog_firstGift:SetIsOn(true)
    SendOpenserActMessge(CommercializeOpeningserGrop.Openingser)
  end
end

function Commercialization_FirstActivityUI:tog_firstGiftOnChanged(control, eventData)
  self.tog_firstGift.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.Openingser)
  else
    self:SetDestroyTime()
  end
  self.go_firstGift:SetActive(eventData)
  self.descBtn:SetActive(not eventData)
end

function Commercialization_FirstActivityUI:tog_sportsLevelOnChanged(control, eventData)
  self.tog_sportsLevel.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsLevel)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsEquipOnChanged(control, eventData)
  self.tog_sportsEquip.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsEquip)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsIntensifyOnChanged(control, eventData)
  self.tog_sportsIntensify.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsIntensify)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsZhuijiaOnChanged(control, eventData)
  self.tog_sportsZhuijia.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsZhuijia)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_BossFirstKillOnChanged(control, eventData)
  self.tog_BossFirstKill.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    self.descBtn.group = CommercializeOpeningserGrop.BossFirstKill
    SendOpenserActMessge(CommercializeOpeningserGrop.BossFirstKill)
  end
  self.go_BossFirstKill:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_EquipFirstGetOnChanged(control, eventData)
  self.tog_EquipFirstGet.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    self.EquipKillIndex = 1
    self.descBtn.group = CommercializeOpeningserGrop.EquipFirstGet
    SendOpenserActMessge(CommercializeOpeningserGrop.EquipFirstGet)
  end
  self.go_EquipFirstGet:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsExcellenceOnChanged(control, eventData)
  self.tog_sportsExcellence.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsExcellenc)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsOrnamentsOnChanged(control, eventData)
  self.tog_sportsOrnaments.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsJewelry)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsFruitOnChanged(control, eventData)
  self.tog_sportsFruit.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsFruit)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsFightOnChanged(control, eventData)
  self.tog_sportsFight.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsFight)
  end
  self.go_sportsLevelrank:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_SevenDaysSignInOnChanged(control, eventData)
  self.tog_SevenDaysSignIn.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    self.descBtn.group = CommercializeOpeningserGrop.weekSignIn
    SendOpenserActMessge(CommercializeOpeningserGrop.weekSignIn)
  end
  self.go_getWeek:SetActive(eventData)
end

function Commercialization_FirstActivityUI:tog_sportsBossOnChanged(control, eventData)
  self.tog_sportsFight.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.SportsBoss)
  end
  self.go_TaskReward:SetActive(eventData)
  self.descBtn:SetActive(not eventData)
end

function Commercialization_FirstActivityUI:tog_GuardInvestOnChanged(control, eventData)
  self.clickGuardIndex = 1
  self.tog_guardInvest.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    SendOpenserActMessge(CommercializeOpeningserGrop.GuardInvest)
    self:InitGuardInvestUI()
  end
  self.go_guardInvest:SetActive(eventData)
  self.descBtn:SetActive(not eventData)
  if eventData == false and self.curGuardChooseTog then
    self.curGuardChooseTog:SetIsOn(false)
  end
end

function Commercialization_FirstActivityUI:OnFristActClickBuy(control)
  if control.rmb then
    DataToCSharpMgr.Pay({
      amount = control.rmb,
      product_Id = control.id
    })
  else
    if BagInfoData.GetItemTotalCountByItemId(tonumber(control.cost)) < control.count then
      RechargeData.BuyDiamond(BusinessPayType.Opening_Gift)
      return
    end
    if self.isOpen then
      local text = ClientTable.cfg_Ui_promptwordManager:TryGetValue(33).content
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = text,
        cancelText = "",
        okText = "",
        onlyOnce = true,
        onlyOnceAction = function(id, isOn)
          self.isOpen = not isOn
        end,
        cancel = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        ok = function()
          NetManager.Send(ItemBuyMessage.ReqBuy, {
            goodId = control.id,
            buyCount = 1
          })
          UIManager.Hide(UIID.PromptTipUI)
        end
      })
    else
      NetManager.Send(ItemBuyMessage.ReqBuy, {
        goodId = control.id,
        buyCount = 1
      })
    end
  end
end

function Commercialization_FirstActivityUI:SprotActivtGetGiftBtn(control)
  self.EquipKillIndex = control.index
  local idGrop = {}
  if control.Killname ~= nil and ViewData.meData.name == control.Killname then
    table.insert(idGrop, control.Killid)
  end
  self.OpenSprotCurgroup = control.OpenSprotCurgroup
  table.insert(idGrop, control.id)
  NetManager.Send(RechargeMessage.ReqGetGift, {id = idGrop})
end

function Commercialization_FirstActivityUI:lab_CanNotGetBtn(control)
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Instance_BossUI, {
    openFirstTab = 1,
    Monsterid = control.id
  })
end

function Commercialization_FirstActivityUI:RegistEvents()
  self:RegistEvent(Event.Commer_OpeningserTog, self.SetOpeningserTog, self)
  self:RegistEvent(Event.Commer_Openingserinfo, self.SetOpeningserInfo, self)
  self:RegistEvent(Event.Commer_Openingserinfo_Mu2, self.SetOpeningserInfo_Mu2, self)
  self:RegistEvent(Event.Commer_SetOpenserReqinfo, self.SetOpenserReqInfo, self)
  self:RegistEvent(Event.UnionTask_Update, self.RefushUnionTask, self)
  self:RegistEvent(Event.RefreshZeroTime, self.RefreshZeroTime, self)
end

function Commercialization_FirstActivityUI:SetOpeningserTog(_)
  local AlltogInfoMap = {
    {
      id = CommercializeOpeningserGrop.weekSignIn,
      tog = self.tog_SevenDaysSignIn,
      onChanged = self.tog_SevenDaysSignInOnChanged,
      view = self.go_getWeek,
      redPoint = 60
    },
    {
      id = CommercializeOpeningserGrop.SportsBoss,
      tog = self.tog_sportsBoss,
      onChanged = self.tog_sportsBossOnChanged,
      view = self.go_TaskReward,
      redPoint = 53
    },
    {
      id = CommercializeOpeningserGrop.Openingser,
      tog = self.tog_firstGift,
      onChanged = self.tog_firstGiftOnChanged,
      view = self.go_firstGift,
      redPoint = nil
    },
    {
      id = CommercializeOpeningserGrop.GuardInvest,
      tog = self.tog_guardInvest,
      onChanged = self.tog_GuardInvestOnChanged,
      view = self.go_guardInvest,
      redPoint = 78
    },
    {
      id = CommercializeOpeningserGrop.BossFirstKill,
      tog = self.tog_BossFirstKill,
      onChanged = self.tog_BossFirstKillOnChanged,
      view = self.go_BossFirstKill,
      redPoint = 31
    },
    {
      id = CommercializeOpeningserGrop.EquipFirstGet,
      tog = self.tog_EquipFirstGet,
      onChanged = self.tog_EquipFirstGetOnChanged,
      view = self.go_EquipFirstGet,
      redPoint = 32
    },
    {
      id = CommercializeOpeningserGrop.SportsLevel,
      tog = self.tog_sportsLevel,
      onChanged = self.tog_sportsLevelOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 27
    },
    {
      id = CommercializeOpeningserGrop.SportsIntensify,
      tog = self.tog_sportsIntensify,
      onChanged = self.tog_sportsIntensifyOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 29
    },
    {
      id = CommercializeOpeningserGrop.SportsExcellenc,
      tog = self.tog_sportsExcellence,
      onChanged = self.tog_sportsExcellenceOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 34
    },
    {
      id = CommercializeOpeningserGrop.SportsZhuijia,
      tog = self.tog_sportsZhuijia,
      onChanged = self.tog_sportsZhuijiaOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 30
    },
    {
      id = CommercializeOpeningserGrop.SportsJewelry,
      tog = self.tog_sportsOrnaments,
      onChanged = self.tog_sportsOrnamentsOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 35
    },
    {
      id = CommercializeOpeningserGrop.SportsFruit,
      tog = self.tog_sportsFruit,
      onChanged = self.tog_sportsFruitOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 36
    },
    {
      id = CommercializeOpeningserGrop.SportsFight,
      tog = self.tog_sportsFight,
      onChanged = self.tog_sportsFightOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 37
    },
    {
      id = CommercializeOpeningserGrop.SportsEquip,
      tog = self.tog_sportsEquip,
      onChanged = self.tog_sportsEquipOnChanged,
      view = self.go_sportsLevelrank,
      redPoint = 28
    }
  }
  for key, value in pairs(AlltogInfoMap) do
    local cfg_Commerce = ClientTable.cfg_Commerce_overviewManager:GetCommerceTabByGroup(value.id)
    if cfg_Commerce ~= nil then
      value.tog.transform:SetSiblingIndex(cfg_Commerce.order)
    end
  end
  local ctr = CommercializeData.OpenSergroupTogId
  if table.count(ctr) <= 0 then
    self:btn_closeOnClick()
    return
  end
  local togInfoMap = {}
  local page
  for index, info in pairs(AlltogInfoMap) do
    if table.contains(ctr, info.id) then
      page = page or info.id
      table.insert(togInfoMap, info)
    else
      info.tog:SetActive(false)
      info.view:SetActive(false)
    end
  end
  for index, info in pairs(togInfoMap) do
    if info.redPoint ~= nil then
      local cfg = ClientTable.cfg_Red_pointManager:TryGetValue(info.redPoint, "id")
      if cfg ~= nil then
        local isShow = RedPointChecker_Ext:JudgeUseMethod(cfg.uiName, cfg.parentPosition, cfg.childPosition)
        local isShow_Mu2 = RedPointChecker:CheckIsNeedShow(cfg.id)
        if isShow or isShow_Mu2 then
          page = info.id
          break
        end
      end
    end
  end
  if self.args then
    page = self.args.openFirstTab and self.args.openFirstTab or page
    self.args.openFirstTab = nil
  end
  local showViewMap = {}
  for index, info in ipairs(togInfoMap) do
    if table.contains(ctr, info.id) then
      info.tog:SetActive(true)
      if page == info.id then
        table.insert(showViewMap, info.view)
        if info.tog.toggle.isOn then
          info.onChanged(self, "", true)
        else
          for i, v in pairs(togInfoMap) do
            if v.tog.toggle.isOn then
              v.tog:SetIsOn(false)
              break
            end
          end
          info.tog:SetIsOn(true)
        end
      end
    else
      info.tog:SetActive(false)
      if not table.contains(showViewMap, info.view) then
        info.view:SetActive(false)
      end
    end
  end
end

local function DaojishiTime(condition)
  local down = TimeUtility.AddDay(LoginData.openServerTime, condition[2][2])
  local Difference = TimeUtility.RefreshSec(down)
  return Difference
end

local DaojiTime = 0

function Commercialization_FirstActivityUI:RefreshTime(lab_lastTime, txt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    txt_lastTime:SetActive(false)
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercialization_FirstActivityUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Commercialization_FirstActivityUI:SetOpeningserInfo(_)
  local ctr = CommercializeData.OpenSercurTogInfo
  if ctr.groupId == CommercializeOpeningserGrop.Openingser then
    if self.destoryTimeSchedule then
      self:SetDestroyTime()
    end
    local Difference = DaojishiTime(self.FristGiftTableCondition)
    local DaoJiShi
    if Difference <= 0 then
      self.txt_lastTimeGift:SetActive(false)
      DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
      self.lab_lastTimeGift:SetText(DaoJiShi)
    else
      self.txt_lastTimeGift:SetActive(true)
      DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
      self.lab_lastTimeGift:SetText(DaoJiShi)
      DaojiTime = Difference
      self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTimeGift, self.txt_lastTimeGift)
    end
    if self.FristServerGiftinfo == nil then
      self.OpenFristcurshopInfo = ctr.shopInfo
      self.FristServerGiftinfo = CommercializeData:GetFristServerGiftinfo(ctr.shopInfo)
    else
      local shopInfocountser, shopInfocountcur, acc = #ctr.shopInfo, #self.OpenFristcurshopInfo, 0
      if shopInfocountser == shopInfocountcur then
        for i = 1, shopInfocountser do
          if ctr.shopInfo[i].id == self.OpenFristcurshopInfo[i].id then
            acc = acc + 1
          end
        end
        if acc ~= shopInfocountser then
          self.FristServerGiftinfo = CommercializeData:GetFristServerGiftinfo(ctr.shopInfo)
        end
      else
        self.FristServerGiftinfo = CommercializeData:GetFristServerGiftinfo(ctr.shopInfo)
      end
    end
    self:RefreshOpenSerGiftData()
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsLevel then
    self.redPointName = "tog_sportsLevel"
    self:LoadingImages("img_firstActRank_level", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsLeveInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsEquip then
    self.redPointName = "tog_sportsEquip"
    self:LoadingImages("img_firstAct_weapen", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsEquipInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsIntensify then
    self.redPointName = "tog_sportsIntensify"
    self:LoadingImages("img_firstActRank_intensify", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsIntensifyInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsZhuijia then
    self.redPointName = "tog_sportsZhuijia"
    self:LoadingImages("img_firstActRank_add", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsZhuijiaInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.BossFirstKill then
    self.redPointName = "tog_BossFirstKill"
    self:RefreshBossFirstKill(ctr.taskInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.EquipFirstGet then
    self.redPointName = "tog_EquipFirstGet"
    self:RefreshEquipFirst(ctr.taskInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsExcellenc then
    self.redPointName = "tog_sportsExcellence"
    self:LoadingImages("img_firstActRank_excellent", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsExcellenc)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsJewelry then
    self.redPointName = "tog_sportsOrnaments"
    self:LoadingImages("img_firstActRank_ornament", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsJewelry)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsFruit then
    self.redPointName = "tog_sportsFruit"
    self:LoadingImages("img_firstActRank_fruit", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsFruitInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsFight then
    self.redPointName = "tog_sportsFight"
    self:LoadingImages("img_firstActRank_power", self.img_sportsLevelrank)
    self:RefreshSportlevelrank(ctr, self.SportsFightInfo)
  elseif ctr.groupId == CommercializeOpeningserGrop.SportsBoss then
    self.redPointName = "tog_sportsBoss"
    self:RefreshSportBoss(ctr, self.SportsBoss)
  elseif ctr.groupId == CommercializeOpeningserGrop.weekSignIn then
    self.redPointName = "tog_SevenDaysSignIn"
    self:RefreshSevenDaysSignIn(ctr)
  end
end

function Commercialization_FirstActivityUI:SetOpeningserInfo_Mu2(_, _groupId)
  if _groupId == nil then
    return
  end
  if _groupId == CommercializeOpeningserGrop.GuardInvest then
    self.redPointName = "tog_guardInvest"
    self:RefreshGuardInvest()
  end
end

function Commercialization_FirstActivityUI:SetOpenserReqInfo()
  if self.OpenSprotCurgroup then
    SendOpenserActMessge(self.OpenSprotCurgroup)
  end
end

function Commercialization_FirstActivityUI:RefreshZeroTime()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.Opening_service
  })
end

function Commercialization_FirstActivityUI:RefreshOpenSerGiftData()
  local mixkey, maxkey = CommercializeData:GetFristSerMinMaxCountKey()
  self.RoleKeyCountData = RefreshData.TotalRefreshTbl
  for i, v in pairs(self.RoleKeyCountData) do
    if i >= mixkey and i <= maxkey then
      local acc = 0
      for k = 1, #self.FristServerGiftinfo do
        k = k + acc
        if self.FristServerGiftinfo[k].countKey == i then
          self.FristServerGiftinfo[k].keycount = v.count
          if v.count >= self.FristServerGiftinfo[k].refreshCountLimit then
            self.FristServerGiftinfo[k].soldout = true
            table.insert(self.FristServerGiftinfo, self.FristServerGiftinfo[k])
            table.remove(self.FristServerGiftinfo, k)
            acc = acc - 1
          end
          break
        end
      end
    end
  end
  local FristServerGiftinfoTemp = {}
  for key, value in pairs(self.FristServerGiftinfo) do
    if ConditionManager.Check4D(value.showCondition) then
      table.insert(FristServerGiftinfoTemp, value)
    end
  end
  self.FirstGistContainer:SetData(FristServerGiftinfoTemp)
  local shopIndex
  if self.args ~= nil and self.args.shopID ~= nil then
    for index, data in ipairs(FristServerGiftinfoTemp) do
      if data.id == tonumber(self.args.shopID) and data.soldout == false then
        shopIndex = index
        break
      end
    end
  end
  if shopIndex ~= nil then
    local target_OnlyOne = self:GetScrollViewNormalizedPositionOnlyOne(self.sw_firstGift.scrollRect, shopIndex - 2, false, 0)
    self.sw_firstGift:SetNormalizedPosition(target_OnlyOne, 1)
  end
end

function Commercialization_FirstActivityUI:GetScrollViewNormalizedPositionOnlyOne(scrollRect, currentChildIndex, inverse, pixelOffset)
  local childTrans = scrollRect.content:GetChild(0)
  local viewportRect = scrollRect.viewport.rect
  local contentRect = scrollRect.content.rect
  local childrenRect = childTrans.rect
  local diff = contentRect.width - viewportRect.width
  local elementLength = childrenRect.width - 5
  return Mathf.Clamp01((currentChildIndex * elementLength + pixelOffset) / diff)
end

local function sort(a, b)
  local amore = a.massgeinfo.roleCount < a.refreshCountLimitrole and 1 or 0
  local bmore = b.massgeinfo.roleCount < b.refreshCountLimitrole and 1 or 0
  if a.massgeinfo.canGet ~= b.massgeinfo.canGet then
    if amore ~= bmore then
      return amore > bmore
    else
      local aindex = a.massgeinfo.canGet and 1 or 0
      local bindex = b.massgeinfo.canGet and 1 or 0
      return aindex > bindex
    end
  elseif amore == bmore then
    if amore == 1 then
      local serindexa = a.massgeinfo.systemCount < a.refreshCountLimitser and 1 or 0
      local serindexb = b.massgeinfo.systemCount < b.refreshCountLimitser and 1 or 0
      if serindexa ~= serindexb then
        return serindexa > serindexb
      else
        return a.taskgift.sortId < b.taskgift.sortId
      end
    else
      return a.taskgift.sortId < b.taskgift.sortId
    end
  else
    return amore > bmore
  end
end

local function SportmergeSort(info, msgdata)
  for i, v in pairs(info) do
    for k, w in pairs(msgdata) do
      if v.commerceId == w.taskId then
        v.massgeinfo = w.giftInfo[1]
        v.extra = w.extra
        break
      end
    end
  end
  table.sort(info, sort)
end

local function SportRank(info, msgdata)
  local RankData = {}
  local TaskData = {}
  for i, v in pairs(info) do
    if v.RankData then
      local rank = v.RankData
      local MsgRank = msgdata.rankInfo and msgdata.rankInfo.ranks or {}
      local rankdata = {}
      for k, w in pairs(rank) do
        if MsgRank[k] then
          rankdata[k] = w
          rankdata[k].MsgRank = MsgRank[k]
          rankdata[k].myRank = msgdata.rankInfo.myRank
        else
          rankdata[k] = w
          rankdata[k].myRank = msgdata.rankInfo ~= nil and msgdata.rankInfo.myRank <= 100 and msgdata.rankInfo.myRank or "Ch\198\176a l\195\170n BXH"
        end
      end
      RankData = rankdata
    else
      local MsgTask = msgdata.taskInfo
      for k, w in pairs(MsgTask) do
        if w.taskId == v.commerceId then
          local Task = v
          Task.MsgTask = MsgTask[k]
          table.insert(TaskData, Task)
        end
      end
    end
  end
  local ShowTask
  local taskcount = #TaskData
  if taskcount ~= 0 then
    for i, v in pairs(TaskData) do
      if v.MsgTask.giftInfo[1].canGet and v.MsgTask.giftInfo[1].roleCount == 0 then
        ShowTask = v
        ShowTask.group = msgdata.groupId
        break
      end
    end
    if not ShowTask then
      for i, v in pairs(TaskData) do
        if not v.MsgTask.giftInfo[1].canGet then
          ShowTask = v
          ShowTask.group = msgdata.groupId
          break
        end
      end
    end
    ShowTask = ShowTask or TaskData[taskcount]
  end
  return RankData, ShowTask
end

local function OpenDownTime(condition)
  local groupStr = string.split(condition, "&")
  local OpenTime = string.split(groupStr[1], "#")
  local DownTime = string.split(groupStr[2], "#")
  local open = TimeUtility.AddDay(LoginData.openServerTime, tonumber(OpenTime[2]) - 1)
  local down = TimeUtility.AddDay(LoginData.openServerTime, tonumber(DownTime[2]))
  local openTime = TimeUtility.SwitchsecondStamp(open)
  local downTime = TimeUtility.SwitchsecondStamp(down)
  local timeshow = openTime .. " - " .. downTime
  return timeshow
end

function Commercialization_FirstActivityUI:RefreshSportlevelrank(data, info)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = DaojishiTime(info[1].condition)
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTime:SetActive(false)
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTimeLevelrank:SetText(DaoJiShi)
  else
    self.txt_lastTime:SetActive(true)
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTimeLevelrank:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTimeLevelrank, self.txt_lastTime)
  end
  self.lab_descLevelrank:SetText(GetUIText(info[1].desc))
  if not data.rankInfo then
    logError("Server kh\195\180ng c\195\179 th\195\180ng tin rankInfo ")
  end
  local ranktext = data.rankInfo ~= nil and data.rankInfo.myRank <= 100 and data.rankInfo.myRank or "Ch\198\176a l\195\170n BXH"
  self.lab_sportsMyRank:SetText(ranktext)
  local RankData, ShowTask = SportRank(info, data)
  self.descBtn.group = RankData[1].groupId
  self.SprotLevelrankContainer:SetData(RankData)
  if ShowTask then
    self.sw_spirtsrankList.transform.localPosition = Vector3.New(-11, -23, 0)
    self.sw_spirtsrankList:SetSizeDelta(818, 283)
    self.img_dataSelfTaskBg:SetActive(true)
    self:SetSelfTaskFun(ShowTask)
  else
    self.sw_spirtsrankList.transform.localPosition = Vector3.New(-11, -70, 0)
    self.sw_spirtsrankList:SetSizeDelta(818, 380)
    self.img_dataSelfTaskBg:SetActive(false)
  end
end

function Commercialization_FirstActivityUI:RefreshSportBoss(data, info)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = DaojishiTime(info[1].condition)
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTimBoss:SetActive(false)
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTimeBoss:SetText(DaoJiShi)
  else
    self.txt_lastTimBoss:SetActive(true)
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTimeBoss:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTimeBoss, self.txt_lastTimBoss)
  end
  self:RefushUnionTask()
end

local function FirstKillSort(data, self)
  local ShowData = {}
  for i, v in pairs(data) do
    if not ShowData[v.same] then
      ShowData[v.same] = {}
    end
    table.insert(ShowData[v.same], v)
  end
  self.redPointHide = true
  local acc = 0
  for k = 1, #ShowData do
    k = k + acc
    local ItemData = ShowData[k]
    local pos = 111
    for i = 1, #ItemData do
      local CanGet = ItemData[i].Msg.giftInfo[1].canGet
      local RoleGetCount = ItemData[i].refreshCountLimitrole - ItemData[i].Msg.giftInfo[1].roleCount
      local SerGetCount = ItemData[i].refreshCountLimitser - ItemData[i].Msg.giftInfo[1].systemCount
      if 0 < SerGetCount then
        if CanGet then
          if 0 < RoleGetCount then
            self.redPointHide = false
            pos = 1
            break
          elseif pos ~= 0 then
            pos = 2
          end
        else
          pos = 0
        end
      else
        if pos ~= 0 then
          pos = 2
        end
        break
      end
    end
    if pos == 1 then
      table.insert(ShowData, 1, ShowData[k])
      table.remove(ShowData, k + 1)
    elseif pos == 2 then
      table.insert(ShowData, ShowData[k])
      table.remove(ShowData, k)
      acc = acc - 1
    end
  end
  if self.redPointHide then
    EventManager.Dispatch(Event.RefreshOpenServiceRedPointParam, self.redPointName)
  end
  return ShowData
end

function Commercialization_FirstActivityUI:RefreshEquipFirst(data)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = DaojishiTime(self.BossFirstKill[1].condition)
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTimEquipFirstKill:SetActive(false)
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTimeEquipFirstKill:SetText(DaoJiShi)
  else
    self.txt_lastTimEquipFirstKill:SetActive(true)
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTimeEquipFirstKill:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTimeEquipFirstKill, self.txt_lastTimEquipFirstKill)
  end
  local KillData = CommercializeData.GetEquipFirstInfo(data)
  self.ShowEquipFirstInfo = FirstKillSort(KillData, self)
  if not self.EquipFirsttableView then
    self:EquipFirstTableView()
  end
  self.EquipFirsttableView:ReloadData(self.EquipKillIndex)
end

local function FirstKillSort(data, self)
  local ShowData = {}
  for i, v in pairs(data) do
    if not ShowData[v.same] then
      ShowData[v.same] = {}
    end
    table.insert(ShowData[v.same], v)
  end
  local acc = 0
  self.redPointHide = true
  for i = 1, #ShowData do
    i = i + acc
    local one = ShowData[i][1]
    local two = ShowData[i][2]
    local SortData = one.type == 1 and one or nil
    SortData = SortData or two
    local CanGet = SortData.Msg.giftInfo[1].canGet
    local GetCount = SortData.refreshCountLimitrole - SortData.Msg.giftInfo[1].roleCount
    if CanGet then
      if 0 < GetCount then
        self.redPointHide = false
        table.insert(ShowData, 1, ShowData[i])
        table.remove(ShowData, i + 1)
      else
        table.insert(ShowData, ShowData[i])
        table.remove(ShowData, i)
        acc = acc - 1
      end
    end
  end
  if self.redPointHide then
    EventManager.Dispatch(Event.RefreshOpenServiceRedPointParam, self.redPointName)
  end
  return ShowData
end

function Commercialization_FirstActivityUI:RefreshBossFirstKill(data)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = DaojishiTime(self.BossFirstKill[1].condition)
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTimeBossFirstKill:SetActive(false)
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTimeBossFirstKill:SetText(DaoJiShi)
  else
    self.txt_lastTimeBossFirstKill:SetActive(true)
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTimeBossFirstKill:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTimeBossFirstKill, self.txt_lastTimeBossFirstKill)
  end
  local BossKillData = {}
  for i = 1, #data do
    for k = 1, #self.BossFirstKill do
      if data[i].taskId == self.BossFirstKill[k].commerceId then
        local TabData = self.BossFirstKill[k]
        BossKillData[i] = TabData
        BossKillData[i].Msg = data[i]
        break
      end
    end
  end
  local ShowData = FirstKillSort(BossKillData, self)
  self.BossFirstKillContainer:SetData(ShowData)
  if self.redPointHide then
    EventManager.Dispatch(Event.RefreshOpenServiceRedPointParam, self.redPointName)
  end
end

function Commercialization_FirstActivityUI:LoadgiftModel(ctr, data)
  local itemdata = ItemUtility.GenerateItemData(data.itemId)
  if not ctr.itemCellData then
    ctr.itemCellData = ItemCellData()
  end
  itemdata.count = data.count
  ctr.itemCellData:RefreshData(itemdata)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, self, true)
end

local function ReissueOK(Args)
  if Args.bagcount < Args.money then
    FloatingTipUtility.QuickMsg("Xu K\225\187\179 T\195\173ch kh\195\180ng \196\145\225\187\167")
  else
    Args.ui.OpenSprotCurgroup = Args.OpenSprotCurgroup
    NetManager.Send(CommerceMessage.ReqSevenDayReissue, {
      id = Args.id
    })
  end
  UIManager.Hide(UIID.PromptTipUI)
end

function Commercialization_FirstActivityUI:btn_ReissueOnClick(control)
  local Group = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(4020001)
  local money = string.split(Group, "#")
  local Curgroup = control.OpenSprotCurgroup
  local bagcount = BagInfoData.GetItemTotalCountByItemId(tonumber(money[2]))
  local content = ""
  if bagcount < tonumber(money[1]) then
    local str = LocalizationUtility.GetContentByKey("Yinghe_1")
    content = string.format(str, bagcount, money[1])
  else
    local str = LocalizationUtility.GetContentByKey("Yinghe_2")
    content = string.format(str, money[1])
  end
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = content,
    cancel = function()
      UIManager.Hide(UIID.PromptTipUI)
    end,
    ok = ReissueOK,
    okArgs = {
      bagcount = bagcount,
      money = tonumber(money[1]),
      ui = self,
      OpenSprotCurgroup = Curgroup,
      id = control.id
    }
  })
end

function Commercialization_FirstActivityUI:btn_SignInOnClick(control)
  self.OpenSprotCurgroup = control.OpenSprotCurgroup
  NetManager.Send(CommerceMessage.ReqSevenDaySign, {
    id = control.id
  })
end

function Commercialization_FirstActivityUI:ShowDaysSignIn(ctr, _, data)
  local BoxItem = CommercializeData.CurrentOccupation(data.BoxItem)
  self:LoadgiftModel(ctr.btn_ItemDay, BoxItem[1])
  local Gift = data.Msg.giftInfo[1]
  ctr.Background:SetActive(Gift.roleCount <= 0)
  ctr.Checkmark:SetActive(Gift.roleCount > 0)
  ctr.btn_SignIn:SetActive(Gift.canGet and Gift.roleCount <= 0 and _ == self.yingheDay and self.SevenDayisExpected)
  ctr.CheckedIn:SetActive(Gift.canGet and Gift.roleCount > 0 and not data.Msg.isReissue)
  ctr.Reissued:SetActive(Gift.canGet and Gift.roleCount > 0 and data.Msg.isReissue)
  ctr.btn_Reissue:SetActive(Gift.canGet and Gift.roleCount <= 0 and _ < self.yingheDay and _ <= self.SevenDayReissueTime and self.reissueNumber < 3)
  ctr.Expected:SetActive(Gift.roleCount <= 0 and not self.SevenDayisExpected and _ > self.SevenDayReissueTime)
  ctr.btn_ToSignIn:SetActive(_ > self.yingheDay and self.SevenDayisExpected)
  ctr.btn_Reissue.id = data.commerceId
  ctr.btn_Reissue.OpenSprotCurgroup = data.group
  ctr.btn_SignIn.id = data.commerceId
  ctr.btn_SignIn.OpenSprotCurgroup = data.group
  ctr.btn_Reissue:SetOnClick(self, self.btn_ReissueOnClick)
  ctr.btn_SignIn:SetOnClick(self, self.btn_SignInOnClick)
  local effectItem = ctr.transform:Find(GuideEffecName)
  if Gift.canGet and Gift.roleCount <= 0 and _ == self.yingheDay and self.SevenDayisExpected and self.before then
    if not effectItem then
      if _ == 7 then
        effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, Vector2(1.7, 2.6))
      else
        effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, Vector2(1.1, 1.25))
      end
    else
      effectItem.gameObject:SetActive(true)
    end
  elseif effectItem then
    effectItem.gameObject:SetActive(false)
  end
end

function Commercialization_FirstActivityUI:RefreshSevenDaysSignIn(data)
  local AllSignInInfo = {}
  local MsgInfo = data.taskInfo
  self.reissueNumber = data.reissueNumber
  self.yingheDay = data.yingheDay
  self.SevenDayReissueTime = CommercializeData.ReissueTime(data)
  self.redPointHide, self.before = CommercializeData.WeekSignRed(data)
  self.SevenDayisExpected = self.before and self.before or self.SevenDayReissueTime + 1 >= self.yingheDay
  logError(self.SevenDayReissueTime, self.yingheDay, self.before)
  for i = 1, #MsgInfo do
    for k = 1, #self.SevenDaysSignIn do
      if MsgInfo[i].taskId == self.SevenDaysSignIn[k].commerceId then
        local TabData = self.SevenDaysSignIn[k]
        AllSignInInfo[i] = TabData
        AllSignInInfo[i].Msg = MsgInfo[i]
        break
      end
    end
  end
  for i, v in pairs(self.weekBtns) do
    local info = AllSignInInfo[i]
    self:ShowDaysSignIn(v, i, info)
  end
  local redGift
  if AllSignInInfo[self.yingheDay] then
    redGift = AllSignInInfo[self.yingheDay].Msg.giftInfo[1]
  else
    logError("Ch\198\176a nh\225\186\173n \196\145\198\176\225\187\163c s\225\187\145 ng\195\160y \196\145i\225\187\131m danh" .. self.yingheDay)
    return
  end
  if not self.redPointHide then
    EventManager.Dispatch(Event.RefreshOpenServiceRedPointParam, self.redPointName)
  end
end

local function InitRewardItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function RefreshRewardItem(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  if ctr.modelData == nil then
    ctr.modelData = ItemCellData()
  end
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function Commercialization_FirstActivityUI:InitGuardInvestUI()
  local _, defaultType = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetTypeAndReward()
  if defaultType == GuardTypeEnum.DamageIncreased then
    UIControl(self.tog_DamageIncreased):SetIsOn(true)
  elseif defaultType == GuardTypeEnum.DamageReduction then
    UIControl(self.tog_DamageReduction):SetIsOn(true)
  elseif defaultType == GuardTypeEnum.ReduceAttack then
    UIControl(self.tog_ReduceAttackSpeed):SetIsOn(true)
  end
end

local DaojiTime = 0

function Commercialization_FirstActivityUI:RefreshDownTime(_lab_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    _lab_lastTime:SetText(DaoJiShi .. " sau k\225\186\191t th\195\186c")
  else
    _lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercialization_FirstActivityUI:ShowDownTime(_cfg_Commerce, _lab_lastTime)
  if _cfg_Commerce == nil then
    return ""
  end
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = DaojishiTime(_cfg_Commerce.condition)
  if Difference <= 0 then
    if _lab_lastTime then
      _lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
    end
  else
    local DaoJiShi = TimeUtility.ShowDayHourMin(Difference) or ""
    if _lab_lastTime then
      _lab_lastTime:SetText(DaoJiShi .. " sau k\225\186\191t th\195\186c")
    end
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshDownTime, self, _lab_lastTime)
  end
end

function Commercialization_FirstActivityUI:RefreshGuardModel()
  if self.guardTags == nil then
    self.guardTags = {}
  end
  local tabLists = ClientTable.cfg_Guard_investManager:GetAllTabType()
  for i = 1, table.count(tabLists) do
    if self.guardTags[i] == nil then
      local obj = self.guardContent.transform:GetChild(i - 1)
      local guardModel = UIControl(obj, "btn_guardItem")
      guardModel.itemContainer = UIContainer(guardModel, self, InitRewardItemCreat, RefreshRewardItem)
      self.guardTags[i] = guardModel
    end
    local cfg_tab = tabLists[i]
    local giftTbl = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(cfg_tab.reward))
    local boxId = tonumber(giftTbl.reward)
    local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", boxId)
    self.guardTags[i].itemContainer:SetData(BoxItem)
  end
end

function Commercialization_FirstActivityUI:RefreshGuardInvest()
  local activityDataMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr()
  local curGuardType = activityDataMgr:CurGuardType(IndexerEnum.get)
  local curActivityData = activityDataMgr:GetGuardInvestDataByType(curGuardType)
  if curActivityData == nil then
    return
  end
  self:RefreshGuardModel()
  local cfg_Commerce = ClientTable.cfg_Commerce_overviewManager:TryGetValue(CommercializeOpeningserGrop.GuardInvest, "group")
  self:ShowDownTime(cfg_Commerce, self.lab_activityDateTime)
  self:CreateAndRefreshTableView()
end

function Commercialization_FirstActivityUI:CreateAndRefreshTableView()
  if not self.tableView then
    self.tableView = UITableView()
    self.tableView:SetLowerMargin(0)
    self.tableView:SetScrollView(self.sw_guardInvestList)
    self.tableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
    self.tableView:SetUpperMargin(0)
    self.tableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
    self.tableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
    self.tableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
    self.tableView:ReloadData(1)
  elseif self.clickGuardIndex ~= nil then
    self.tableView:ReloadData(self.clickGuardIndex)
  else
    self.tableView:ReloadData()
  end
end

function Commercialization_FirstActivityUI:ScalarForCellInTableView()
  local _, sizeY = self.img_guardInvestAvtice:GetSizeDelta()
  return sizeY
end

function Commercialization_FirstActivityUI:NumberOfCellsInTableView()
  local activityDataMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr()
  local curGuardType = activityDataMgr:CurGuardType(IndexerEnum.get)
  local curActivityData = activityDataMgr:GetGuardInvestDataByType(curGuardType)
  local tabList = ClientTable.cfg_Guard_investManager:GetTabByType(curActivityData.guardInvestType)
  return #tabList
end

function Commercialization_FirstActivityUI:CellAtIndexInTableView(index)
  return self.tableView:ReuseOrCreateCell(self.img_guardInvestAvtice)
end

function Commercialization_FirstActivityUI:CellAtIndexInTableViewWillAppear(index)
  local activityDataMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr()
  local tabList = activityDataMgr:GetCurTypeGuardInvestData()
  local dataInfo = tabList[index]
  local obj = self.tableView:GetLoadedCell(index)
  obj.btn_Item = obj:GetChild("img_firstAvtice_red/sw_rewardItem/Viewport/Content/btn_Item")
  obj.lab_desc = obj:GetChild("img_firstAvtice_red/lab_desc")
  obj.btn_Get = obj:GetChild("img_firstAvtice_red/go_state/btn_Get")
  obj.btn_EnableInvest = obj:GetChild("img_firstAvtice_red/go_state/btn_EnableInvest")
  obj.lab_EnablePrice = obj:GetChild("img_firstAvtice_red/go_state/btn_EnableInvest/lab_EnablePrice")
  obj.img_EnableCost = obj:GetChild("img_firstAvtice_red/go_state/btn_EnableInvest/img_EnableCost")
  obj.lab_Got = obj:GetChild("img_firstAvtice_red/go_state/lab_Got")
  obj.lab_Unfinsh = obj:GetChild("img_firstAvtice_red/go_state/lab_Unfinsh")
  obj.img_redBg = obj:GetChild("img_redBg")
  obj.img_blackBg = obj:GetChild("img_blackBg")
  obj.lab_desc:SetText(tostring(dataInfo.description))
  if not obj.itemContainer then
    obj.itemContainer = UIContainer(obj.btn_Item, self, InitRewardItemCreat, RefreshRewardItem)
  end
  local giftTbl = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(dataInfo.reward))
  local boxId = tonumber(giftTbl.reward)
  local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", boxId)
  obj.itemContainer:SetData(BoxItem)
  local rewardState = dataInfo.rewardState
  if index == 1 then
    obj.img_redBg:SetActive(true)
    obj.img_blackBg:SetActive(false)
    local enableCostArray = string.split(dataInfo.activeCondition, "#")
    local parms = {}
    if enableCostArray and #enableCostArray == 2 then
      local costItemId = tonumber(enableCostArray[1])
      local costItemNum = enableCostArray[2]
      parms.costItemId = costItemId
      parms.costItemNum = tonumber(costItemNum)
      parms.guardInvestType = dataInfo.type
      obj.lab_EnablePrice:SetText(costItemNum)
      local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(costItemId)
      self:SetSprite("Atlas_Icon", itemTab.icon, obj.img_EnableCost, false)
    end
    obj.btn_EnableInvest:SetOnClickParam(self, self.OnReqEnableInvestClick, parms)
    obj.btn_EnableInvest:SetActive(rewardState == GuardRewardStateEnum.NotGet)
    obj.lab_Unfinsh:SetActive(false)
  else
    obj.img_redBg:SetActive(false)
    obj.img_blackBg:SetActive(index % 2 ~= 0)
    obj.btn_EnableInvest:SetActive(false)
    obj.lab_Unfinsh:SetActive(rewardState == GuardRewardStateEnum.NotGet)
  end
  if dataInfo.rewardState == GuardRewardStateEnum.NotGet then
    obj.lab_Unfinsh:SetActive(false)
  end
  obj.lab_Got:SetActive(rewardState == GuardRewardStateEnum.Got)
  obj.btn_Get:SetActive(rewardState == GuardRewardStateEnum.CanGet)
  local params = {
    idGrop = {
      tonumber(dataInfo.reward)
    },
    index = index
  }
  obj.btn_Get:SetOnClickParam(self, self.OnReqGetAwardClick, params)
end

function Commercialization_FirstActivityUI:Refresh()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.Opening_service
  })
  self.sw_firstActivityList:SetNormalizedPosition(0, 1)
  self.sw_firstGift:SetNormalizedPosition(0, 0)
  self.sw_BossFirstKillList:SetNormalizedPosition(0, 1)
  self.sw_BossFirstKillList:SetNormalizedPosition(0, 1)
  self.sw_equipFirstGetList:SetNormalizedPosition(0, 1)
  self.sw_spirtsrankList:SetNormalizedPosition(0, 1)
  self.sw_guardInvestList:SetNormalizedPosition(0, 1)
end

function Commercialization_FirstActivityUI:InitUnionTask()
  self.curSelectLabelPage = nil
  self.curJumpMapId = nil
  self.roleLevel = ViewData.meData.level
  self.selectLevel = Mathf.Floor(ViewData.meData.level / 10) * 10 <= 0 and 1 or Mathf.Floor(ViewData.meData.level / 10) * 10
  self.refushPageLevel = {}
  self.limitNum = 0
  self.monsterList = {}
end

local function InitRewardItemControls(item)
  local itemCellData = ItemCellData()
  item.itemCellData = itemCellData
end

local function ItemRewardRefresh(item, _, rewards, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(rewards.itemID))
  itemInfo.count = rewards.itemNum
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

local function InitLevelBossItemControls(ctr)
  ctr.taskMonsterName = UIControl(ctr.transform, "lab_name")
  ctr.taskProgress = UIControl(ctr.transform, "kill_num")
  ctr.taskMonsterIcon = UIControl(ctr.transform, "img_icon")
  ctr.taskMonsterLevel = UIControl(ctr.transform, "img_icon/level")
  ctr.btn_leave = UIControl(ctr.transform, "btn_leave")
  ctr.btn_complete = UIControl(ctr.transform, "btn_complete")
  ctr.btn_cpmpleted = UIControl(ctr.transform, "btn_cpmpleted")
  ctr.img_bgback = UIControl(ctr.transform, "img_bgback")
  ctr.taskRewardContent = UIControl(ctr.transform, "TaskContent/btn_MonsterRewarItem")
end

local function ItemLevelBossRefresh(ctr, _, monsterTasks, ui)
  if not ctr.rewardItemTemp then
    ctr.rewardItemTemp = UIContainer(ctr.taskRewardContent, ui, InitRewardItemControls, ItemRewardRefresh)
  end
  local rewards = monsterTasks:GetRewards()
  local allRewards = {}
  for k, v in pairs(rewards) do
    table.insert(allRewards, {itemID = k, itemNum = v})
  end
  ctr.rewardItemTemp:SetData(allRewards)
  local monsterLevelTable = ClientTable.cfg_Task_rewardManager:TryGetValue(ui.selectLevel, "levelReward")
  ctr.cor = Coroutine.Start(function()
    local name = string.format("Texture/%s", monsterLevelTable.mapImage)
    local request = ui:LoadAssetAsync(name, typeof(CS.UnityEngine.Texture2D))
    Coroutine.Yield(request)
    if request.isError then
      Coroutine.Break()
    end
    ctr.img_bgback:SetTexture(request.res)
    ctr.cor = nil
  end)
  local position = string.split(GlobalConfig.GetGlobalConfig(2490002), "#")
  local scale = GlobalConfig.GetGlobalConfig(2490004)
  local rotation = string.split(GlobalConfig.GetGlobalConfig(2490003), "#")
  if ui.monsterList[monsterTasks:GetId()] then
    local monster = ui.monsterList[monsterTasks:GetId()]
    monster:SetActive(true)
    monster:SetParent(ctr.taskMonsterIcon.transform)
    monster:SetLocalPosition(Vector3(position[1], position[2], position[3]))
    monster:SetLocalScale(Vector3(scale, scale, scale))
    monster:SetLocalRotate(Vector3(rotation[1], rotation[2], rotation[3]))
  else
    local monster = UIMonsterUtility(monsterTasks:GetMonsterId(), ctr.taskMonsterIcon.transform, Vector3(scale, scale, scale), Vector3(position[1], position[2], position[3]), Vector3(rotation[1], rotation[2], rotation[3]))
    monster:SetActive(true)
    ui.monsterList[monsterTasks:GetId()] = monster
  end
  local str = monsterTasks:GetTaskMonsterName()
  if monsterTasks:GetMonsterType() == MonsterType.wildBoss then
    str = string.format("<color=#FF0000>%s</color>", str)
  end
  if monsterTasks:GetMonsterType() == MonsterType.goldBoss then
    str = string.format("<color=#E6E600>%s</color>", str)
  end
  ctr.taskMonsterName:SetText(str .. monsterTasks:GetTaskMonsterProgress())
  ctr.taskProgress:SetActive(false)
  ctr.taskProgress:SetText(monsterTasks:GetTaskMonsterProgress())
  ctr.taskMonsterLevel:SetText(monsterTasks:GetTaskMonsterLevel())
  ctr.btn_leave:SetActive(monsterTasks:GetState() == TaskStateType.Acceptable or monsterTasks:GetState() == TaskStateType.Accept)
  ctr.btn_complete:SetActive(monsterTasks:GetState() == TaskStateType.Completed)
  ctr.btn_cpmpleted:SetActive(monsterTasks:GetState() == TaskStateType.Submitted)
  ctr.btn_leave:SetOnClick(ui, function()
    ui:StartToDoTask(monsterTasks)
  end)
  ctr.btn_complete:SetOnClick(ui, function()
    ui:StartToDoCompleteTask(monsterTasks)
  end)
  GuideUtility.AddCreatObj("Task_TaskReward", ctr.btn_leave)
  ui:AddCompleteEffect(monsterTasks, ctr.btn_complete, 2490005)
end

local function InitPerRewardItemControls(item)
  local itemCellData = ItemCellData()
  item.itemCellData = itemCellData
end

local function ItemPerRewardRefresh(item, _, rewards, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(rewards.itemID))
  itemInfo.count = rewards.itemNum
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

function Commercialization_FirstActivityUI:InitContent()
  self.levleBossItemTemp = UIContainer(self.go_item, self, InitLevelBossItemControls, ItemLevelBossRefresh)
  self.perItemTemp = UIContainer(self.PeriodicalReward_Item, self, InitPerRewardItemControls, ItemPerRewardRefresh)
end

function Commercialization_FirstActivityUI:InitUnionUI()
  self.Content.layoutGroup.enabled = true
  self.selectLevel = nil
  self.monsterLevelIndex = {}
  self:InitContent()
  self:SubSortIndex()
  self.taskEffeList = {}
  self.perTaskEffeList = {}
end

function Commercialization_FirstActivityUI:SubSortIndex()
  local allLevel = {}
  for k, v in pairs(TaskData.allMonsterLevel) do
    table.insert(allLevel, v)
  end
  for i = 1, #allLevel do
    self.monsterLevelIndex[i] = allLevel[i]
  end
end

function Commercialization_FirstActivityUI:ResetUI()
  self.curJumpMapId = nil
  self.roleLevel = ViewData.meData.level
  self.refushPageLevel = {}
  self.selectLevel = nil
end

function Commercialization_FirstActivityUI:AddPerCompleteEffect(task, parentItem, globalId)
  self:CleanAllPerTaskEffect()
  if task.state ~= TaskStateType.Completed then
    return
  end
  local effectInfo = GlobalConfig.GetGlobalConfig(globalId)
  if effectInfo == nil or effectInfo == "" then
    return
  end
  local effectList = string.split(effectInfo, "&")
  if self.perTaskEffeList[task.taskId] == nil then
    self.perTaskEffeList[task.taskId] = {}
  end
  local scaleList = string.split(effectList[2], "#")
  self.perTaskEffeList[task.taskId].submitEffect = UIEffectUtility.SetUIEffect(effectList[1], parentItem, true, Vector3(scaleList[1], scaleList[2], scaleList[3]))
end

function Commercialization_FirstActivityUI:AddCompleteEffect(task, parentItem, globalId)
  if task.state ~= TaskStateType.Completed and self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].submitEffect ~= nil then
    self:CleanTaskEffect(task:GetId())
    return
  end
  if task.state ~= TaskStateType.Completed then
    return
  end
  local effectInfo = GlobalConfig.GetGlobalConfig(globalId)
  if effectInfo == nil or effectInfo == "" then
    return
  end
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].submitEffect ~= nil then
    self.taskEffeList[task.taskId].submitEffect.transform:SetParent(parentItem.transform)
    self.taskEffeList[task.taskId].submitEffect:SetPosition(0, 0, 0)
    return
  end
  local effectList = string.split(effectInfo, "&")
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local scaleList = string.split(effectList[2], "#")
  self.taskEffeList[task.taskId].submitEffect = UIEffectUtility.SetUIEffect(effectList[1], parentItem, true, Vector3(scaleList[1], scaleList[2], scaleList[3]))
end

function Commercialization_FirstActivityUI:CleanTaskEffect(taskId)
  for k, v in pairs(self.taskEffeList) do
    if k == taskId and v.submitEffect ~= nil then
      v.submitEffect:Destroy()
      v.submitEffect = nil
    end
    if TaskData.AllTasks[k] == nil and v.submitEffect ~= nil then
      v.submitEffect:Destroy()
      v.submitEffect = nil
    end
  end
end

function Commercialization_FirstActivityUI:CleanAllPerTaskEffect()
  if self.perTaskEffeList then
    for k, v in pairs(self.perTaskEffeList) do
      if v.submitEffect ~= nil then
        v.submitEffect:Destroy()
        v.submitEffect = nil
      end
    end
    self.perTaskEffeList = {}
  end
end

function Commercialization_FirstActivityUI:CleanAllTaskEffect()
  if self.taskEffeList then
    for k, v in pairs(self.taskEffeList) do
      if v.submitEffect ~= nil then
        v.submitEffect:Destroy()
        v.submitEffect = nil
      end
    end
    self.taskEffeList = {}
  end
end

function Commercialization_FirstActivityUI:DefaultPageShow()
  if self.selectLevel == nil then
    self.selectLevel = TaskData.allMonsterLevel[1]
  end
  if self.selectLevel ~= nil and self.selectLevel >= self.monsterLevelIndex[1] then
    self:RefushPeriodicalReward()
    self:RefushCurLevelInfo(self.selectLevel)
  end
end

function Commercialization_FirstActivityUI:ClickTask()
  if self.args ~= nil and self.args.openFirstTab ~= nil and self.args.openFirstTab > 0 then
    self.selectLevel = self.monsterLevelIndex[self.args.openFirstTab]
    self.args = nil
  end
  if self.args ~= nil and self.args.openLevle ~= nil then
    self.selectLevel = self.args.openLevle
    self.args = nil
  end
end

function Commercialization_FirstActivityUI:RefushTableView()
  self.Content.transform.localPosition = Vector3(0, 0, 0)
end

function Commercialization_FirstActivityUI:RefushPeriodicalReward()
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(self.selectLevel)
  if periodicalTask ~= nil then
    local rewards = periodicalTask:GetRewards()
    local allRewards = {}
    for k, v in pairs(rewards) do
      table.insert(allRewards, {itemID = k, itemNum = v})
    end
    self.perItemTemp:SetData(allRewards)
    if periodicalTask.state == TaskStateType.Submitted then
      self.Image_Received:SetActive(true)
    else
      self.Image_Received:SetActive(false)
      self.taskdes:SetText(periodicalTask:GetDes())
    end
  end
end

function Commercialization_FirstActivityUI:ShowPeriodicalReward()
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(self.selectLevel)
  if periodicalTask ~= nil then
    local isNotFinish = TaskData.GetCurMonsterLevelFinish(self.selectLevel)
    if not isNotFinish then
      if periodicalTask.state == TaskStateType.Completed then
        EventManager.Dispatch(Event.Task_BtnSubmitClick, periodicalTask:GetId())
      end
      if periodicalTask.state == TaskStateType.Submitted then
        print("\229\183\178\233\162\134\229\143\150\229\165\150\229\138\177")
      end
    else
      local uiWord = periodicalTask:GetDes()
      FloatingTipUtility.QuickMsg(uiWord)
    end
  end
end

function Commercialization_FirstActivityUI:OnDestroy()
  self:CleanAllTaskEffect()
  self:CleanAllPerTaskEffect()
end

function Commercialization_FirstActivityUI:OnHidePer()
  for k, v in pairs(self.monsterList) do
    v:DestroyGameObject()
  end
  self.monsterList = {}
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.CommercializationActivityUI)
end

function Commercialization_FirstActivityUI:RefushUnionTask()
  self:ResetUI()
  self:GetPageList()
  self:ClickTask()
  self:DefaultPageShow()
  self:RefushTableView()
end

function Commercialization_FirstActivityUI:GetPageList()
  local curNotFinishLevel
  if self.roleLevel < TaskData.allMonsterLevel[1] then
  else
    local maxLevel
    for k, v in pairs(TaskData.allMonsterLevel) do
      if v <= self.roleLevel then
        maxLevel = v
      end
    end
    for k, v in pairs(TaskData.allMonsterLevel) do
      if v <= self.roleLevel then
        local ifNotFinish = TaskData.GetCurMonsterLevelFinish(v)
        local generalTask = TaskData.GetPeriodicalTaskByLevel(v)
        if ifNotFinish or not ifNotFinish and generalTask and generalTask:GetState() ~= TaskStateType.Submitted then
          curNotFinishLevel = v
          table.insert(self.refushPageLevel, v)
        end
      end
    end
    if self.refushPageLevel ~= nil and 1 > #self.refushPageLevel then
      for k, v in pairs(TaskData.allMonsterLevel) do
        if v >= maxLevel and v <= self.roleLevel then
          table.insert(self.refushPageLevel, v)
        end
      end
    end
  end
  for k, v in pairs(TaskData.allMonsterLevel) do
    if v > self.roleLevel then
      table.insert(self.refushPageLevel, v)
    elseif curNotFinishLevel ~= nil and v > curNotFinishLevel then
      table.insert(self.refushPageLevel, v)
    end
  end
  if self.refushPageLevel ~= nil and table.count(self.refushPageLevel) > 0 then
    self.selectLevel = self.refushPageLevel[1]
  end
end

function Commercialization_FirstActivityUI:OnClickLeftLevel()
  local index = 0
  for k, v in pairs(self.refushPageLevel) do
    if self.selectLevel == v then
      index = k
    end
  end
  if 1 < index then
    index = index - 1
  end
  if self.selectLevel ~= self.refushPageLevel[index] then
    local level = self.refushPageLevel[index]
    if level then
      local levelTasks = TaskData.GetMonsterLevelTasks(level)
      if levelTasks and level <= self.roleLevel then
        self.selectLevel = level
        self:RefushCurLevelInfo(self.selectLevel)
        self:RefushPeriodicalReward()
        self:RefushTableView()
      else
        local titleStrCon = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_2")
        local titleStr = string.format(titleStrCon, level)
        FloatingWordUtility.QuickMsg(titleStr)
      end
    end
  end
end

function Commercialization_FirstActivityUI:OnClickRightLevel()
  local index = 0
  for k, v in pairs(self.refushPageLevel) do
    if self.selectLevel == v then
      index = k
    end
  end
  if index < #self.refushPageLevel then
    index = index + 1
  end
  if self.selectLevel ~= self.refushPageLevel[index] then
    local level = self.refushPageLevel[index]
    if level then
      local levelTasks = TaskData.GetMonsterLevelTasks(level)
      if levelTasks and level <= self.roleLevel then
        self.selectLevel = level
        self:RefushCurLevelInfo(self.selectLevel)
        self:RefushPeriodicalReward()
        self:RefushTableView()
      else
        local titleStrCon = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_2")
        local titleStr = string.format(titleStrCon, level)
        FloatingWordUtility.QuickMsg(titleStr)
      end
    end
  end
end

local unionTitle = {
  [50] = "first_task50",
  [60] = "first_task60",
  [100] = "first_task100",
  [150] = "first_task150",
  [200] = "first_task200"
}

function Commercialization_FirstActivityUI:RefushCurLevelInfo(level)
  for k, v in pairs(self.monsterList) do
    v:SetHide()
  end
  local titleStr = ClientTable.cfg_Task_rewardManager:TryGetValue(level, "levelReward").title
  self:SetSprite("Atlas_Language", unionTitle[level], self.imgName)
  self.nameText:SetActive(false)
  self.nameText:SetText(titleStr)
  local curLevelMonsterTasks = TaskData.GetMonsterLevelTasks(level)
  if curLevelMonsterTasks ~= nil then
    self.levleBossItemTemp:SetData(curLevelMonsterTasks)
  end
end

function Commercialization_FirstActivityUI:StartToDoTask(monsterTasks)
  self:OnHidePer()
  TaskData.SetClickLevelBossTask(monsterTasks:GetId())
  UIManager.Show(UIID.Instance_BossUI, {
    Monsterid = tonumber(monsterTasks:GetMonsterId())
  })
end

function Commercialization_FirstActivityUI:StartToDoCompleteTask(monsterTasks, level)
  EventManager.Dispatch(Event.Task_BtnSubmitClick, monsterTasks:GetId())
end

function Commercialization_FirstActivityUI:IsShowRedPoint(level)
  self.tog_sportsBoss.transform:Find("img_redPoint").gameObject:SetActive(RedPointChecker_Ext:JudgeUnionComplete())
end

function Commercialization_FirstActivityUI:tog_DamageIncreasedOnChanged(control, eventData)
  self.clickGuardIndex = 1
  local checkmark = UIControl(control.transform, "Background/Checkmark")
  checkmark:SetActive(eventData)
  if eventData then
    self.curGuardChooseTog = control
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():CurGuardType(IndexerEnum.set, GuardTypeEnum.DamageIncreased)
    self:RefreshGuardInvest()
  end
end

function Commercialization_FirstActivityUI:tog_DamageReductionOnChanged(control, eventData)
  self.clickGuardIndex = 1
  local checkmark = UIControl(control.transform, "Background/Checkmark")
  checkmark:SetActive(eventData)
  if eventData then
    self.curGuardChooseTog = control
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():CurGuardType(IndexerEnum.set, GuardTypeEnum.DamageReduction)
    self:RefreshGuardInvest()
  end
end

function Commercialization_FirstActivityUI:tog_ReduceAttackSpeedOnChanged(control, eventData)
  self.clickGuardIndex = 1
  local checkmark = UIControl(control.transform, "Background/Checkmark")
  checkmark:SetActive(eventData)
  if eventData then
    self.curGuardChooseTog = control
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():CurGuardType(IndexerEnum.set, GuardTypeEnum.ReduceAttack)
    self:RefreshGuardInvest()
  end
end

function Commercialization_FirstActivityUI:OnReqGetAwardClick(_obj)
  local idGrop = _obj.param.idGrop
  self.clickGuardIndex = nil
  networkRequest.ReqGetGift(idGrop)
end

function Commercialization_FirstActivityUI:OnReqEnableInvestClick(_obj)
  local parms = _obj.param
  if parms == nil or table.count(parms) == 0 then
    return
  end
  local bagcount = BagInfoData.GetItemTotalCountByItemId(parms.costItemId)
  if bagcount < parms.costItemNum then
    RechargeData.BuyDiamond(BusinessPayType.None)
  else
    networkRequest.ReqActiveGuardInvest(parms.guardInvestType)
  end
end
