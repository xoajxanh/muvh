Commercial_RewriteServerName = class(BaseUI)
Commercial_RewriteServerName.layer = UILayer.Panel
Commercial_RewriteServerName.orderInLayer = 0
Commercial_RewriteServerName.hideType = UIHideType.WaitDestroy
Commercial_RewriteServerName.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_RewriteServerName.escClose = UIEscClose.DontClose

function Commercial_RewriteServerName:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.img_bg = self:GetControl("go_RewriteServerName/img_bg")
  self.img_frist = self:GetControl("go_RewriteServerName/img_frist")
  self.img_jy = self:GetControl("go_RewriteServerName/img_frist/img_jy")
  self.lab_ServerName = self:GetControl("go_RewriteServerName/img_frist/img_1/lab_ServerName")
  self.lab_Name = self:GetControl("go_RewriteServerName/img_frist/img_1/lab_Name")
  self.go_model = self:GetControl("go_RewriteServerName/img_frist/go_model/go_model")
  self.btn_AllRank = self:GetControl("go_RewriteServerName/btn_AllRank")
  self.txt_SevenDayGifts_lastTime = self:GetControl("go_RewriteServerName/lab_Time/txt_SevenDayGifts_lastTime")
  self.lab_Des = self:GetControl("go_RewriteServerName/lab_Des")
  self.RewriteServerName = self:GetControl("go_RewriteServerName/RewriteServerName")
  self.Input_roleName = self:GetControl("go_RewriteServerName/RewriteServerName/Input_roleName")
  self.lab_returnTime = self:GetControl("go_RewriteServerName/RewriteServerName/lab_returnTime")
  self.Text = self:GetControl("go_RewriteServerName/RewriteServerName/Input_roleName/Text")
  self.btn_write = self:GetControl("go_RewriteServerName/RewriteServerName/btn_write")
  self.rewriteBtnItem = self:GetControl("go_RewriteServerName/RewriteServerName/btn_Item")
  self.btn_rewrite = self:GetControl("go_RewriteServerName/RewriteServerName/btn_rewrite")
  self.btn_rewriteTip = self:GetControl("go_RewriteServerName/RewriteServerName/btn_rewrite/tip")
  self.btn_get = self:GetControl("go_RewriteServerName/FreeGift/btn_get")
  self.btn_Item = self:GetControl("go_RewriteServerName/FreeGift/sw_reward/Viewport/Content/btn_Item")
  self.RewriteServerNameRank_AllPanel = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel")
  self.bg_blackbox = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/bg_blackbox")
  self.person_rank = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/Scroll View/Viewport/Content/person_rank")
  self.lab_rechargeNum = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/MyRank/lab_rechargeNum")
  self.lab_career = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/MyRank/lab_career")
  self.lab_name = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/MyRank/lab_name")
  self.lab_img_rank = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/MyRank/lab_img_rank")
  self.lab_noRank = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/MyRank/lab_noRank")
  self.lab_rank = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/MyRank/lab_rank")
  self.btn_closeRankPanel = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/btn_closeRankPanel")
  self.btn_giftItem1 = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/Scroll View/Viewport/Content/person_rank/lab_rank_gift/btn_giftItem1")
  self.btn_giftItem = self:GetControl("go_RewriteServerName/RewriteServerNameRank_AllPanel/img_bg/MyRank/lab_rank_gift/btn_giftItem")
  self.RewriteServerName_InputPanel = self:GetControl("go_RewriteServerName/RewriteServerName_InputPanel")
  self.btn_closeInputPanel = self:GetControl("go_RewriteServerName/RewriteServerName_InputPanel/btn_closeInputPanel")
  self.btn_ok = self:GetControl("go_RewriteServerName/RewriteServerName_InputPanel/btn_ok")
  self.lab_ok = self:GetControl("go_RewriteServerName/RewriteServerName_InputPanel/btn_ok/lab_ok")
  self.btn_examine = self:GetControl("go_RewriteServerName/RewriteServerName_InputPanel/btn_examine")
  self.lab_examine = self:GetControl("go_RewriteServerName/RewriteServerName_InputPanel/btn_examine/lab_examine")
  self.Input_Account = self:GetControl("go_RewriteServerName/RewriteServerName_InputPanel/go_Account/Input_Account")
  self.txt_SevenDayGifts_lastTime = self:GetControl("go_RewriteServerName/lab_Time/txt_SevenDayGifts_lastTime")
  self.descBtn = self:GetControl("descBtn")
  self.btn_closePanel = self:GetControl("btn_closePanel")
end

function Commercial_RewriteServerName:Init()
end

function Commercial_RewriteServerName:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Commercial_RewriteServerName:InitUI()
  self.RewardRefreshTemplate = UIUtility.BindUIContainerTemp(self.btn_Item, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
  self.RefreshRankTemplate = UIUtility.BindUIContainerTemp(self.person_rank, LuaComponentTemplates.RefreshRankTemplate, self)
  self.modeViewerList = {}
  self.getCountKey = true
end

function Commercial_RewriteServerName:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_AllRank:SetOnClick(self, self.btn_AllRankOnClick)
  self.btn_write:SetOnClick(self, self.btn_writeOnClick)
  self.btn_rewrite:SetOnClick(self, self.btn_rewriteOnClick)
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
  self.btn_closeRankPanel:SetOnClick(self, self.btn_closeRankPanelOnClick)
  self.btn_giftItem1:SetOnClick(self, self.btn_giftItem1OnClick)
  self.btn_giftItem:SetOnClick(self, self.btn_giftItemOnClick)
  self.btn_closeInputPanel:SetOnClick(self, self.btn_closeInputPanelOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
  self.btn_examine:SetOnClick(self, self.btn_examineOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_closePanel:SetOnClick(self, self.btn_closePanelOnClick)
  self.Text:SetOnClick(self, self.btn_writeOnClick)
  self.bg_blackbox:SetOnClick(self, self.bg_blackboxClick)
  self.rewriteBtnItem:SetOnClick(self, self.bg_BtnItemClick)
end

function Commercial_RewriteServerName:btn_closeBgOnClick(control)
  self:Hide()
end

function Commercial_RewriteServerName:btn_AllRankOnClick(control)
  self.RewriteServerNameRank_AllPanel:SetActive(true)
  local RankListData = self:GetRewriteNamingData():GetRankListData()
  self.RefreshRankTemplate:SetData(RankListData)
  local NamingMyData = self:GetRewriteNamingData():GetNamingMyData()
  self.lab_rechargeNum:SetText(tostring(NamingMyData.rechargeNum))
  self.lab_career:SetText(RoleUtility.GteCareerNameByType(ViewData.meData.career))
  self.lab_name:SetText(ViewData.meData.name)
  if NamingMyData.rank then
    self.lab_rank:SetText(NamingMyData.rank)
    self.lab_rank:SetActive(true)
    if NamingMyData.rank > 0 and NamingMyData.rank <= 3 then
      self:SetSprite("Atlas_Main", "ico_l" .. NamingMyData.rank, self.lab_img_rank)
      self.lab_rank:SetActive(false)
    else
      self.lab_img_rank:SetActive(false)
    end
    self.lab_noRank:SetActive(false)
  else
    self.lab_rank:SetActive(false)
    self.lab_img_rank:SetActive(false)
    self.lab_noRank:SetActive(true)
  end
end

function Commercial_RewriteServerName:btn_writeOnClick(control)
  self.RewriteServerName_InputPanel:SetActive(true)
  self.result = 0
  self.inputText = nil
end

function Commercial_RewriteServerName:btn_rewriteOnClick(control)
  if self.result == 1 and self.Input_roleName.inputField.text and self.Input_roleName.inputField.text ~= "" then
    local uiWord_2 = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Guanming_2")
    local uiWord_3 = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Guanming_3")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = uiWord_2,
      okText = "G\225\187\173i",
      ok = function()
        self.btn_write:SetActive(false)
        self.Text:SetInteractable(false)
        networkRequest.ReqSettingRegionName(self.Input_roleName.inputField.text)
        FloatingTipUtility.QuickMsg(uiWord_3)
        UIManager.Hide(UIID.PromptTipUI)
      end
    })
  else
    FloatingTipUtility.QuickMsg("T\195\170n \196\145\225\186\183t tr\225\187\145ng, ch\198\176a ki\225\187\131m tra ho\225\186\183c ch\225\187\169a k\195\189 t\225\187\177 nh\225\186\161y c\225\186\163m")
  end
end

function Commercial_RewriteServerName:btn_getOnClick(control)
  if self.getCountKey then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        self:GetRewriteNamingData().NamingGiftId
      }
    })
    self.btn_get:GetChild("tip"):SetText("\196\144\195\163 nh\225\186\173n xong")
    self.getCountKey = false
  else
    FloatingTipUtility.QuickMsg("Ph\225\186\167n th\198\176\225\187\159ng \196\145\195\163 nh\225\186\173n")
  end
end

function Commercial_RewriteServerName:btn_closeRankPanelOnClick(control)
  self.RewriteServerNameRank_AllPanel:SetActive(false)
end

function Commercial_RewriteServerName:bg_blackboxClick(control)
  self.RewriteServerNameRank_AllPanel:SetActive(false)
end

function Commercial_RewriteServerName:bg_BtnItemClick(control)
  local OneData = self:GetRewriteNamingData():GetOneRewardData()
  local itemConfig = ItemUtility.GenerateItemData(tonumber(OneData[1].itemId))
  UIManager.Show(UIID.ItemTipUI, {
    item = itemConfig,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Commercial_RewriteServerName:btn_giftItem1OnClick(control)
end

function Commercial_RewriteServerName:btn_giftItemOnClick(control)
end

function Commercial_RewriteServerName:btn_closeInputPanelOnClick(control)
  self.RewriteServerName_InputPanel:SetActive(false)
end

function Commercial_RewriteServerName:btn_okOnClick(control)
  if self.result == 1 and self.Input_Account.inputField.text and self.Input_Account.inputField.text ~= "" and self.inputText ~= nil and self.inputText == self.Input_Account.inputField.text then
    self.RewriteServerName_InputPanel:SetActive(false)
    self.Input_roleName.inputField.text = self.Input_Account.inputField.text
  else
    FloatingTipUtility.QuickMsg("T\195\170n \196\145\225\186\183t tr\225\187\145ng, ch\198\176a ki\225\187\131m tra ho\225\186\183c ch\225\187\169a k\195\189 t\225\187\177 nh\225\186\161y c\225\186\163m")
  end
end

function Commercial_RewriteServerName:btn_examineOnClick(control)
  if self.RewriteServerName_InputPanel:GetActive() and self.Input_Account.inputField.text and self.Input_Account.inputField.text ~= "" then
    networkRequest.ReqCheckText(self.Input_Account.inputField.text)
  end
end

function Commercial_RewriteServerName:descBtnOnClick(control)
end

function Commercial_RewriteServerName:btn_closePanelOnClick(control)
  self:Hide()
end

function Commercial_RewriteServerName:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Commercial_RewriteServerName:RegistEvents()
  self:RegistEvent(Event.NamingDataChange, self.NamingDataChange, self)
  self:RegistEvent(Event.IsNamingDetection, self.IsNamingDetection, self)
  self:RegistEvent(Event.NamingPlayerData, self.NamingPlayerData, self)
end

function Commercial_RewriteServerName:Refresh()
  self:RefreshReward()
end

function Commercial_RewriteServerName:RefreshReward()
  networkRequest.ReqActivityRechargeInfo()
end

function Commercial_RewriteServerName:IsNamingDetection(_, data)
  self.result = data.code
  self.inputText = self.Input_Account.inputField.text
  FloatingTipUtility.QuickMsg("\196\144\195\163 th\195\180ng qua")
end

function Commercial_RewriteServerName:NamingDataChange()
  self:RefreshSportBoss()
  local data = self:GetRewriteNamingData():GetItemMyRewardData()
  self.RewardRefreshTemplate:SetData(data)
  local OneData = self:GetRewriteNamingData():GetOneRewardData()
  if self.rewriteBtnItem and not IsNil(self.rewriteBtnItem.transform) and OneData[1].itemId ~= nil then
    if self.titleEffectLid ~= nil then
      self:GetUITitleEffectProcessor():RemoveEffect(self.titleEffectLid)
    end
    self.titleEffectLid = self:GetUITitleEffectProcessor():InstantiationEffect({
      lid = self.img_titleEffect,
      panel = self,
      itemId = OneData[1].itemId
    }, self.rewriteBtnItem.transform)
  end
  local reward = self:GetRewriteNamingData():GetNamingMyData()
  if reward then
    self.btn_get:SetActive(reward.isOn)
    self.Input_roleName:SetActive(reward.isActivity and reward.rank == 1)
    self.lab_returnTime:SetActive(reward.isActivity and reward.rank == 1)
    self.btn_write:SetActive(reward.isActivity and reward.rank == 1)
    self.btn_rewrite:SetActive(reward.isActivity and reward.rank == 1)
    if not reward.isActivity or reward.rank ~= 1 then
      self.rewriteBtnItem.transform.localPosition = Vector3(0, -60, 0)
    else
      self.rewriteBtnItem.transform.localPosition = Vector3(-127, -50, 0)
    end
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Naming
  })
  self.img_jy:SetActive(true)
  self.lab_Name:SetActive(false)
  local OnePlayer = self:GetRewriteNamingData():GetNamingOnePlayerData()
  if OnePlayer.status and OnePlayer.status ~= 0 and reward.rank == 1 then
    if OnePlayer.status == 2 then
      self.btn_rewriteTip:SetText("\196\144ang x\195\169t duy\225\187\135t")
      self.Input_roleName.inputField.text = OnePlayer.tempName
    elseif OnePlayer.status == 4 then
      self.btn_rewriteTip:SetText("Kh\195\180ng v\198\176\225\187\163t qua x\195\169t duy\225\187\135t")
      self.Input_roleName.inputField.text = OnePlayer.tempName
    elseif OnePlayer.status == 3 then
      self.Input_roleName.inputField.text = OnePlayer.regionName
    end
    self.btn_rewrite:SetInteractable(false)
    self.Text:SetInteractable(false)
    self.btn_write:SetActive(false)
    if OnePlayer.status == 1 then
      self.Input_roleName.inputField.text = ""
      self.btn_rewriteTip:SetText("\196\144\225\186\183t t\195\170n")
      self.Text:SetInteractable(true)
      self.btn_write:SetActive(true)
      self.btn_rewrite:SetActive(true)
      self.btn_rewrite:SetInteractable(true)
    end
  end
  if OnePlayer.status == 0 then
    self.btn_get:GetChild("tip"):SetText("Nh\225\186\173n")
    self.getCountKey = true
    if self:GetRewriteNamingData().NamingGiftCountKey then
      local refresh = RefreshData.GetLimitCount(self:GetRewriteNamingData().NamingGiftCountKey)
      if refresh and refresh <= 0 then
        self.btn_get:GetChild("tip"):SetText("\196\144\195\163 nh\225\186\173n xong")
        self.getCountKey = false
      end
    end
  else
    self.btn_get:SetActive(false)
  end
  if OnePlayer.rid and OnePlayer.rid ~= 0 then
    networkRequest.ReqOtherRoleInfo(0, 0, OnePlayer.rid, ViewData.meData.serverId)
    if OnePlayer.regionName and OnePlayer.regionName ~= "" then
      self.lab_ServerName:SetText(OnePlayer.regionName)
    else
      self.lab_ServerName:SetText("Hi\225\187\135n kh\195\180ng c\195\179 \196\144\225\186\183t T\195\170n")
    end
  else
    self.lab_ServerName:SetText("Hi\225\187\135n kh\195\180ng c\195\179 \196\144\225\186\183t T\195\170n")
  end
  if not self.des then
    self.des = ConfigManager.GetConfig("cfg_Ui_word", "Guanming_1").content
    self.lab_Des:SetText(self.des)
  end
end

function Commercial_RewriteServerName:NamingPlayerData(_, data)
  local PlayerData = data
  if not PlayerData then
    return
  end
  local index = 1
  if table.count(PlayerData) > 0 or not PlayerData and PlayerData ~= nil then
    local modelViewer = self.modeViewerList[index]
    self.lab_Name:SetActive(true)
    self.lab_Name:SetText(PlayerData.info.name)
    self.img_jy:SetActive(false)
    local viewRoleData = {}
    local equipData = RoleEquipData(PlayerData.equips)
    viewRoleData.equipsData = equipData
    viewRoleData.career = PlayerData.info.career
    viewRoleData.modelType = EModelType.Charactor
    viewRoleData.model = 1003
    viewRoleData.id = PlayerData.info.roleId
    viewRoleData.parent = self.go_model.transform
    viewRoleData.serverCoord = Vector2Int()
    viewRoleData.roleType = ERoleType.Player
    if not modelViewer then
      modelViewer = ViewRole(viewRoleData)
      if modelViewer then
        modelViewer:GetParent().transform.localScale = Vector3(0.8, 0.8, 0.8)
        modelViewer.transform.localScale = Vector3(100, 100, 100)
        table.insert(self.modeViewerList, index, modelViewer)
      end
    end
    if equipData then
      modelViewer:SetRotation(0, -180, 0)
      index = index + 1
    end
  end
end

function Commercial_RewriteServerName:GetRewriteNamingData()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetRewriteNamingData()
end

local function DaojishiTime(condition)
  local down = TimeUtility.AddDay(LoginData.openServerTime, condition[2][2])
  local Difference = TimeUtility.RefreshSec(down)
  return Difference
end

local DaojiTime = 0

function Commercial_RewriteServerName:RefreshTime(lab_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local countdown = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText("Th\225\187\157i gian c\195\178n: " .. countdown)
  else
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercial_RewriteServerName:RefreshSportBoss()
  local conFg = ConfigManager.FindConfigs("cfg_Commerce_overview", "commerceId", self:GetRewriteNamingData().commerceId)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  if self.Timer then
    Timer.Stop(self.Timer)
    self.Timer = nil
  end
  if self:GetRewriteNamingData().commerceId == 55101 then
    local Difference = DaojishiTime(conFg[1].condition)
    local countdown
    if Difference <= 0 then
      countdown = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
      self.txt_SevenDayGifts_lastTime:SetText(countdown)
    else
      countdown = TimeUtility.ShowDayHourMin(Difference)
      self.txt_SevenDayGifts_lastTime:SetText("Th\225\187\157i gian c\195\178n: " .. countdown)
      DaojiTime = Difference
      self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.txt_SevenDayGifts_lastTime)
    end
  elseif conFg[1] then
    self:ShowTime(conFg[1])
  end
end

function Commercial_RewriteServerName:ShowTime(cfg)
  local sStamp, eStamp = TimeUtility.CalcTimeStamp(cfg.condition)
  local remainderTime = (eStamp - Time.GetServerTime()) / 1000
  self.txt_SevenDayGifts_lastTime:SetText(string.GetColorText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c", ItemQuality2ColorDic[5]))
  if 0 < remainderTime then
    local timeStr = TimeUtility.ShowDayHourMin(remainderTime)
    self.txt_SevenDayGifts_lastTime:SetText(string.GetColorText("Th\225\187\157i gian c\195\178n: " .. timeStr, ItemQuality2ColorDic[5]))
    
    local function UpdateTimer()
      local sStamp, eStamp = TimeUtility.CalcTimeStamp(cfg.condition)
      local remainderTime = (eStamp - Time.GetServerTime()) / 1000
      if 0 < remainderTime then
        local countdown = TimeUtility.ShowDayHourMin(remainderTime)
        self.txt_SevenDayGifts_lastTime:SetText("Th\225\187\157i gian c\195\178n: " .. countdown)
      else
        self.txt_SevenDayGifts_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
        if self.Timer then
          Timer.Stop(self.Timer)
          self.Timer = nil
        end
      end
    end
    
    self.Timer = Timer.StartLoop(1, remainderTime, UpdateTimer)
  end
end

function Commercial_RewriteServerName:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Commercial_RewriteServerName:Exit()
  for i, v in pairs(self.modeViewerList) do
    v:Destroy()
  end
  self.modeViewerList = {}
end

function Commercial_RewriteServerName:GetUITitleEffectProcessor()
  return gameMgr:GetEffectManager():GetEffectActionUtility():GetEffectProcessor(EffectProcessorType.UI_Title)
end

function Commercial_RewriteServerName:RemoveAllTitleEffect()
  if self.nameItemTab == nil then
    return
  end
  for i, v in pairs(self.nameItemTab) do
    if v and v.titleEffectLid then
      self:GetUITitleEffectProcessor():RemoveEffect(v.titleEffectLid)
      v.titleItemId = nil
    end
  end
end

function Commercial_RewriteServerName:OnHide()
  self:Exit()
  if self.titleEffectLid ~= nil then
    self:GetUITitleEffectProcessor():RemoveEffect(self.titleEffectLid)
  end
  if self.Timer then
    Timer.Stop(self.Timer)
    self.Timer = nil
  end
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  UIManager.Hide(UIID.Commercial_RewriteServerName)
end

function Commercial_RewriteServerName:OnDestroy()
end
