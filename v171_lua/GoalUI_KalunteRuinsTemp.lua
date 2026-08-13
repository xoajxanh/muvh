local GoalUI_KalunteRuinsTemp = {}
local root = {}

function GoalUI_KalunteRuinsTemp:Init()
  self:InitControls()
  self:InitData()
  self:RegistUIEvents()
end

function GoalUI_KalunteRuinsTemp:InitControls()
  self.wait = self:GetControl("wait")
  self.lab_prepare = self:GetControl("wait/lab_prepare")
  self.lab_prepareTimeValue = self:GetControl("wait/lab_prepare/lab_prepareTimeValue")
  self.btn_rightnow = self:GetControl("wait/lab_prepare/btn_rightnow")
  self.btn_rightnow_Text = self:GetControl("wait/lab_prepare/btn_rightnow/Text")
  self.btn_talk = self:GetControl("wait/btn_talk")
  self.underway_klt = self:GetControl("underway_klt")
  self.info_klt = self:GetControl("underway_klt/info_klt")
  self.lab_goalKaLunTe = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe")
  self.lab_goalKaLunTeDes = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalKaLunTeDes")
  self.lab_goalMonsterNum_boss = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalMonsterNum_boss")
  self.lab_goalMonsterNum_textBoss = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalMonsterNum_boss/lab_goalMonsterNum_text")
  self.lab_goalMonsterNum_jy = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalMonsterNum_jy")
  self.lab_goalMonsterNum_textJY = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalMonsterNum_jy/lab_goalMonsterNum_text")
  self.lab_goalKillPlayer = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalKillPlayer")
  self.lab_goalKillPlayer_text = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalKillPlayer/lab_goalKillPlayer_text")
  self.lab_goalGetRewardNum = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalGetRewardNum")
  self.lab_goalGetRewardNum_text = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalGetRewardNum/lab_goalGetRewardNum_text")
  self.lab_goalCircleTime = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalCircleTime")
  self.lab_goalCircleTime_text = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalCircleTime/lab_goalCircleTime_text")
  self.lab_goalReviveNum = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalReviveNum")
  self.lab_goalReviveNum_text = self:GetControl("underway_klt/info_klt/lab_goalKaLunTe/lab_goalReviveNum/lab_goalGetRewardNum_text")
  self.lab_instance_klt = self:GetControl("lab_instance_klt")
  self.lab_text = self:GetControl("lab_instance_klt/lab_text")
  self.lab_goalKaLunTeNumber = self:GetControl("lab_instance_klt/lab_goalKaLunTeNumber")
  self.Btn_KillRank = self:GetControl("Btn_KillRank")
end

function GoalUI_KalunteRuinsTemp:InitData()
  self.normalTimer = {}
end

function GoalUI_KalunteRuinsTemp:RegistUIEvents()
  self.Btn_KillRank:SetOnClick(self, self.Btn_KillRankOnClick)
end

function GoalUI_KalunteRuinsTemp:Btn_KillRankOnClick()
  if not UIManager.IsVisible(UIID.Activity_ExpeditionPaiUI) then
    UIManager.Show(UIID.Activity_ExpeditionPaiUI)
  end
end

function GoalUI_KalunteRuinsTemp:SetStage(state)
  local totalTime = root.args.nextStateTime or 0
  if state == KalunteRuinsStage.WAITING or state == KalunteRuinsStage.INIT then
    root.lab_instance:SetActive(false)
    root.descBtn:SetActive(false)
    self.wait:SetActive(true)
    self.underway_klt:SetActive(false)
    self.lab_instance_klt:SetActive(true)
    self.lab_goalKaLunTeNumber:SetActive(false)
    self.Btn_KillRank:SetActive(false)
    self:ShowTimer(totalTime, self.lab_prepareTimeValue, 1)
  elseif state == KalunteRuinsStage.RUNNING then
    root.lab_instance:SetActive(false)
    root.descBtn:SetActive(false)
    self.wait:SetActive(false)
    self.underway_klt:SetActive(true)
    self.lab_instance_klt:SetActive(true)
    self.lab_goalKaLunTeNumber:SetActive(true)
    self.Btn_KillRank:SetActive(true)
    local curWaveNum = root.args.nowStage or 0
    local totalWaveNum = root.args.totalStage or 0
    local WaveNum = string.format("%d/%d", curWaveNum, totalWaveNum)
    WaveNum = "H\225\186\161ng" .. WaveNum .. "\196\144\225\187\163t"
    self.lab_goalKaLunTeNumber:SetText(WaveNum)
    local table_uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_kalunte_5")
    local uiWord_content = table_uiWord and table_uiWord.content or ""
    local content = TableParse:SplitStringToStrListList(uiWord_content, "&", "#")
    local des = content[curWaveNum] and (content[curWaveNum][2] or "Di\225\187\135t Qu\195\161i V\225\186\173t Xu\225\186\165t Hi\225\187\135n") or "Di\225\187\135t Qu\195\161i V\225\186\173t Xu\225\186\165t Hi\225\187\135n"
    self.lab_goalKaLunTeDes:SetText(des)
    local str = tostring(root.args.canReliveCount or 0)
    self.lab_goalReviveNum_text:SetText(string.format("%s", str))
    local str = tostring(root.args.coletBossNum or 0)
    self.lab_goalMonsterNum_textBoss:SetText(string.format("%s", str))
    local str = tostring(root.args.coletEliteNum or 0)
    self.lab_goalMonsterNum_textJY:SetText(string.format("%s", str))
    local str = tostring(root.args.hasKillNum or 0)
    self.lab_goalKillPlayer_text:SetText(string.format("%s", str))
    local str = tostring(root.args.openBoxNum or 0)
    self.lab_goalGetRewardNum_text:SetText(string.format("%s", str))
    local remainTime = root.args.remainTime or 0
    self:ShowTimer(remainTime, self.lab_goalCircleTime_text, 2)
    local audios = ClientTable.cfg_Audio_audioManager:TryGetValue(38, "id")
    if audios and root.IsPlayBgm == false then
      AudioManager.PlayBGM(audios.resourceName, audios.volume)
      root.IsPlayBgm = true
    end
    root.lab_fightTimeValue:SetActive(true)
    if 0 < totalTime then
      self:ShowTimer(totalTime, root.lab_fightTimeValue, 3)
    end
  end
end

function GoalUI_KalunteRuinsTemp:DestroyAllTimer()
  if self.normalTimer then
    for i, v in pairs(self.normalTimer) do
      if v then
        Timer.Stop(v)
        v = nil
      end
    end
  end
end

function GoalUI_KalunteRuinsTemp:ShowTimer(surplusTime, lab_countdown, index)
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    
    if surplusTime <= 0 then
      if self.normalTimer[index] then
        Timer.Stop(self.normalTimer[index])
        self.normalTimer[index] = nil
      end
      if index == 3 then
        if UIManager.IsVisible(UIID.Activity_ExpeditionPaiUI) then
          UIManager.Hide(UIID.Activity_ExpeditionPaiUI)
        end
        TranScriptController.ReqExitInstance()
      end
    end
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    if index == 1 then
      lab_countdown:SetText(timeStr)
    elseif index == 2 then
      lab_countdown:SetText(surplusTime .. "s")
    elseif index == 3 then
      lab_countdown:SetText(timeStr)
    end
  end
  
  if surplusTime < 0 then
    return
  end
  local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
  if index == 1 then
    lab_countdown:SetText(timeStr)
  elseif index == 2 then
    lab_countdown:SetText(surplusTime .. "s")
  elseif index == 3 then
    lab_countdown:SetText(timeStr)
  end
  if self.normalTimer[index] then
    Timer.Stop(self.normalTimer[index])
    self.normalTimer[index] = nil
  end
  self.normalTimer[index] = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function GoalUI_KalunteRuinsTemp:OnHide()
  self:DestroyAllTimer()
  self:InitData()
end

function GoalUI_KalunteRuinsTemp:OnDestroy()
  self.normalTimer = nil
end

function GoalUI_KalunteRuinsTemp:SetRoot(parent)
  if parent == nil then
    return
  end
  root = parent
end

return GoalUI_KalunteRuinsTemp
