Main_NoticeUI = class(BaseUI)
Main_NoticeUI.layer = UILayer.Tooltip
Main_NoticeUI.orderInLayer = 98
Main_NoticeUI.hideType = UIHideType.Hide
Main_NoticeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_NoticeUI.escClose = UIEscClose.DontClose

function Main_NoticeUI:InitControls()
  self.img_topNotice = self:GetControl("img_topNotice")
  self.lab_topNotice = self:GetControl("img_topNotice/lab_topNotice")
  self.img_upperNotice = self:GetControl("img_upperNotice")
  self.lab_upperNotice = self:GetControl("img_upperNotice/lab_upperNotice")
  self.img_middleNotice = self:GetControl("img_middleNotice")
  self.lab_middleNotice = self:GetControl("img_middleNotice/lab_middleNotice")
  self.panel_lineNotice = self:GetControl("panel_lineNotice")
  self.lab_lineNotice = self:GetControl("panel_lineNotice/lab_lineNotice")
  self.img_lineNotice = self:GetControl("panel_lineNotice/lab_lineNotice/img_lineNotice")
  self.img_killNumberNotice = self:GetControl("img_killNumberNotice")
  self.lab_middleNotice = self:GetControl("img_killNumberNotice/lab_middleNotice")
  self.img_killNotice = self:GetControl("img_killNotice")
  self.img_jifenNumberNotice = self:GetControl("img_jifenNumberNotice")
  if self.img_killNumberNotice then
    self.killNumAnimator = self.img_killNumberNotice.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
  end
end

function Main_NoticeUI:OnPreLoad()
end

function Main_NoticeUI:Init()
end

function Main_NoticeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_NoticeUI:InitUI()
  self:InitNotice()
  self:InitContent()
  self:InitKillParams()
end

function Main_NoticeUI:InitNotice()
  self.noticeDict = {}
  self.img_topNotice.lab = self.lab_topNotice
  self.img_upperNotice.lab = self.lab_upperNotice
  self.img_middleNotice.lab = self.lab_middleNotice
  self.noticeDict[NoticeEnum.TOP] = self.img_topNotice
  self.noticeDict[NoticeEnum.UPPER] = self.img_upperNotice
  self.noticeDict[NoticeEnum.MIDDLE] = self.img_middleNotice
end

local function LabLineNoticeCreate(ctr)
end

local function LabLineNoticeUpdate(ctr, _, data, ui)
  local showStr = string.replace(data.noticeStr, "<a href=[system:1]>", "")
  showStr = string.replace(showStr, "</a>", "")
  ctr:SetText(showStr)
  local quence = DOTween.Sequence()
  local fragment1 = ctr.text:DOColor(Color(1, 0.78, 0.31, 1), 0.15)
  local fragment2 = ctr.text:DOColor(Color(0.54, 0.43, 0.16, 1), 0.15)
  quence:Append(fragment1)
  quence:Append(fragment2)
  local times = Mathf.Ceil(data.duration / 0.3)
  quence:SetLoops(times, CS.DG.Tweening.LoopType.Yoyo):OnComplete(function()
    ctr:SetActive(false)
    fragment1:Kill(true)
    fragment2:Kill(true)
    ui.doTweenTable[data.id] = nil
  end)
  ctr.quence = quence
  ctr.fragment1 = fragment1
  ctr.fragment2 = fragment2
  ctr:SetActive(true)
  ui.doTweenTable[data.id] = ctr
end

function Main_NoticeUI:InitContent()
  self.labLineContainer = UIContainer(self.lab_lineNotice, self, LabLineNoticeCreate, LabLineNoticeUpdate)
  self.doTweenTable = {}
end

function Main_NoticeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_NoticeUI:OnHide()
  for i, v in pairs(self.noticeDict) do
    if self.countDownTime then
      Timer.Stop(self.countDownNotice)
      self.countDownNotice = nil
    end
    self:NoticeLabInit(v.lab)
    self:NoticeImgInit(v)
    v:SetActive(false)
  end
  for i, v in pairs(self.doTweenTable) do
    v.quence:Kill(true)
  end
  self.doTweenTable = {}
  self:HideNotice()
end

function Main_NoticeUI:OnDestroy()
end

function Main_NoticeUI:RegistUIEvents()
end

function Main_NoticeUI:RegistEvents()
  self:RegistEvent(Event.NoticeUpdate, self.UpdateNotice, self)
  self:RegistEvent(Event.RefreshKillNoticeView, self.RefreshKillTipsCallBack, self)
  self:RegistEvent(Event.RefreshMaxKillNoticeView, self.TryRefreshMaxKillCallBack, self)
  self:RegistEvent(Event.RefreshScoreNoticeView, self.RefreshScoreNoticeViewCallBack, self)
  self:RegistEvent(Event.UnionKillAniPlay, self.RealPlayMaxKillNotice, self)
  self:RegistEvent(Event.PlayFourPartyRivalryKillNotice, self.PlayFourPartyRivalryKillNotice, self)
end

function Main_NoticeUI:UpdateNotice(_, msg)
  local noticeImg = self.noticeDict[msg.noticeType]
  if noticeImg then
    self:ShowNotice(noticeImg, msg)
  else
    self:BreathNoticeAnimation(msg)
  end
end

function Main_NoticeUI:ShowNotice(noticeImg, noticeData)
  if not noticeData then
    noticeImg:SetActive(false)
    return
  end
  noticeImg:SetActive(true)
  local chatConfig = ClientTable.cfg_Chat_chatManager:TryGetValue(noticeData.id, "id")
  local style = chatConfig.style
  if chatConfig.countdown > 0 then
    self:CountDownAnimation(noticeImg, noticeData, chatConfig.countdown, chatConfig.systemChat)
  elseif style == NoticeStyleEnum.Roll and noticeData.noticeType ~= NoticeEnum.MIDDLE then
    self:RollAnimation(noticeImg, noticeData)
  elseif style == NoticeStyleEnum.Bomb then
    self:BombAnimation(noticeImg, noticeData)
  else
    self:CompleteAnimation(noticeImg, noticeData)
  end
end

function Main_NoticeUI:BreathNoticeAnimation(msg)
  local lineNoticeData = {}
  local lineNotices = string.split(msg.noticeData.chatMsg.message, "&")
  local chatConfig = ClientTable.cfg_Chat_chatManager:TryGetValue(msg.id, "id")
  for i = 1, #lineNotices do
    if not lineNoticeData[i] then
      lineNoticeData[i] = {}
    end
    lineNoticeData[i].noticeStr = lineNotices[i]
    lineNoticeData[i].duration = chatConfig.countdown
    lineNoticeData[i].id = string.format("%s_%s", msg.id, i)
  end
  for i, v in pairs(self.doTweenTable) do
    v.quence:Kill(true)
  end
  self.doTweenTable = {}
  self.panel_lineNotice:SetActive(true)
  self.labLineContainer:SetData(lineNoticeData)
end

function Main_NoticeUI:NoticeLabInit(lab)
  lab:SetAnchoredPosition(0, 0)
  lab:SetAlpha(1)
  if lab.movement then
    lab.movement:Kill()
    lab.movement = nil
  end
end

function Main_NoticeUI:NoticeImgInit(noticeImg, msg)
  noticeImg:SetScale(Vector3.one)
  if msg and (msg.noticeType == NoticeEnum.TOP or msg.noticeType == NoticeEnum.UPPER) then
    noticeImg:SetAlpha(0.3)
  else
    noticeImg:SetAlpha(1)
  end
  if noticeImg.movement then
    noticeImg.movement:Kill()
    noticeImg.movement = nil
  end
end

function Main_NoticeUI:BombAnimation(noticeImg, msg)
  local lab = noticeImg.lab
  lab:SetTextAnchor(TextAnchor.MiddleCenter)
  self:NoticeLabInit(lab)
  self:NoticeImgInit(noticeImg, msg)
  lab:SetText(msg.noticeData.chatMsg.message)
  noticeImg:SetScale(Vector3.one * 2)
  noticeImg:SetAlpha(0)
  local movement1 = noticeImg.image:DOFade(1, 0.3)
  local quence = DOTween.Sequence()
  local movement2 = noticeImg.image.transform:DOScale(Vector3.one, 0.3)
  local movement3 = noticeImg.image:DOFade(0, 1)
  quence:Append(movement2)
  quence:AppendInterval(1.5)
  quence:Append(movement3)
  quence:AppendCallback(function()
    msg = NoticeData.GetNoticeData(msg.noticeType)
    self:ShowNotice(noticeImg, msg)
  end)
  noticeImg.movement = quence
end

function Main_NoticeUI:RollAnimation(noticeImg, msg)
  local lab = noticeImg.lab
  lab:SetTextAnchor(TextAnchor.MiddleLeft)
  self:NoticeLabInit(lab)
  self:NoticeImgInit(noticeImg, msg)
  lab:SetActive(false)
  lab:SetText(msg.noticeData.chatMsg.message)
  local labWidth = lab.text.preferredWidth
  local imgWidth, _ = noticeImg:GetRectSize()
  local finalPos = Vector3(-labWidth, 0, 0)
  lab:SetAnchoredPosition(imgWidth, 0)
  lab:SetActive(true)
  local rollTime = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2350001)
  local intervalTime = imgWidth / rollTime
  local movement = lab.transform:DOLocalMove(finalPos, intervalTime):OnComplete(function()
    msg = NoticeData.GetNoticeData(msg.noticeType)
    self:ShowNotice(noticeImg, msg)
  end)
  lab.movement = movement
end

function Main_NoticeUI:CompleteAnimation(noticeImg, msg)
  local lab = noticeImg.lab
  lab:SetTextAnchor(TextAnchor.MiddleCenter)
  self:NoticeLabInit(lab)
  self:NoticeImgInit(noticeImg, msg)
  lab:SetText(msg.noticeData.chatMsg.message)
  lab:SetAnchoredPosition(0, 0)
  local hideTime = 0
  if msg.noticeType == NoticeEnum.MIDDLE then
    hideTime = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2350003) / 1000
  else
    hideTime = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2350002) / 1000
  end
  local movement = lab.text:DOFade(0, 0):OnComplete(function()
    msg = NoticeData.GetNoticeData(msg.noticeType)
    self:ShowNotice(noticeImg, msg)
  end):SetDelay(hideTime)
  lab.movement = movement
end

function Main_NoticeUI:CountDownAnimation(noticeImg, msg, countDownTime, systemChat)
  local lab = noticeImg.lab
  lab:SetTextAnchor(TextAnchor.MiddleCenter)
  self:NoticeLabInit(lab)
  self:NoticeImgInit(noticeImg, msg)
  local count = countDownTime
  lab:SetText(string.format(systemChat, count))
  self.countDownNotice = Timer.StartLoop(1, countDownTime, function()
    count = count - 1
    lab:SetText(string.format(systemChat, count))
  end)
  lab.inputData = msg.noticeData.chatMsg.inputData
  lab:SetOnTextPointerClick(self, self.ExecuteTextOrder)
  lab:SetAnchoredPosition(0, 0)
  local hideTime = 0
  if msg.noticeType == NoticeEnum.MIDDLE then
    hideTime = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2350003) / 1000
  else
    hideTime = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2350002) / 1000
  end
  local movement = lab.text:DOFade(0, 0):OnComplete(function()
    Timer.Stop(self.countDownNotice)
    self.countDownNotice = nil
    msg = NoticeData.GetNoticeData(msg.noticeType)
    self:ShowNotice(noticeImg, msg)
  end):SetDelay(countDownTime + 0.1)
  lab.movement = movement
end

function Main_NoticeUI:Refresh()
  ChatData.WelcomeEnterGame()
end

function Main_NoticeUI:InitKillParams()
  self.mKSBattleMaxKillCount = 0
  self.KillNoticeShowTimeCfg = ClientTable.cfg_Activity_globalManager:GetKSBattleMaxKillShowTime()
  self.killNoticeTemplate = luaTemplateManager.GetNewTemplate(self.img_killNotice, LuaComponentTemplates.KillNoticeTemplate, {baseUI = self})
  self.scoreNoticeTemplate = luaTemplateManager.GetNewTemplate(self.img_jifenNumberNotice, LuaComponentTemplates.ScoreNoticeTemplate, {baseUI = self})
end

function Main_NoticeUI:RefreshKillTipsCallBack(id, data)
  if self.killNoticeTemplate then
    self.killNoticeTemplate:RefreshKillTips(data)
  end
end

function Main_NoticeUI:TryRefreshMaxKillCallBack()
  if self.isRefreshMaxKill then
    return
  end
  self.isRefreshMaxKill = true
  self:PlayMaxKillNotice()
  if self.refreshMaxKillTimer == nil then
    self.refreshMaxKillTimer = Timer.StartLoopForever(self.KillNoticeShowTimeCfg, self.PlayMaxKillNotice, self)
  end
end

function Main_NoticeUI:PlayMaxKillNotice()
  if not TranScriptData.IsInRefineKSBattle() or KillNoticeMgr == nil or KillNoticeMgr:IndividualKillNum() == 0 then
    self.isRefreshMaxKill = false
    self:StopKillTimer()
    return
  end
  if self.mKSBattleMaxKillCount == KillNoticeMgr:IndividualKillNum() then
    self.isRefreshMaxKill = false
    self:StopKillTimer()
    return
  end
  self:RealPlayMaxKillNotice()
end

function Main_NoticeUI:RealPlayMaxKillNotice()
  self.mKSBattleMaxKillCount = KillNoticeMgr:IndividualKillNum()
  self.lab_middleNotice:SetText(tostring(self.mKSBattleMaxKillCount))
  if not self.img_killNumberNotice:GetActive() then
    self.img_killNumberNotice:SetActive(true)
  elseif self.killNumAnimator then
    self.killNumAnimator:Play("kunshouKillNumber", 0, 0)
  end
  self.killAudio = AudioManager.PlayMusicClipById(6300)
end

function Main_NoticeUI:PlayFourPartyRivalryKillNotice()
  self.mKSBattleMaxKillCount = KillNoticeMgr:IndividualKillNum()
  self.lab_middleNotice:SetText(tostring(self.mKSBattleMaxKillCount))
  if not self.img_killNumberNotice:GetActive() then
    self.img_killNumberNotice:SetActive(true)
  elseif self.killNumAnimator then
    self.killNumAnimator:Play("kunshouKillNumber", 0, 0)
  end
  self.killAudio = AudioManager.PlayMusicClipById(6300)
end

function Main_NoticeUI:StopKillTimer()
  if self.refreshMaxKillTimer then
    Timer.Stop(self.refreshMaxKillTimer)
    self.refreshMaxKillTimer = nil
  end
  if self.killAudio then
    AudioManager.Stop(self.killAudio)
  end
end

function Main_NoticeUI:RefreshScoreNoticeViewCallBack()
  if self.scoreNoticeTemplate then
    self.scoreNoticeTemplate:Refresh()
  end
end

function Main_NoticeUI:HideNotice()
  self.img_killNumberNotice:SetActive(false)
  self.img_killNotice:SetActive(false)
  self.img_jifenNumberNotice:SetActive(false)
end
