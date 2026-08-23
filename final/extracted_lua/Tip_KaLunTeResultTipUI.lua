Tip_KaLunTeResultTipUI = class(BaseUI)
Tip_KaLunTeResultTipUI.layer = UILayer.Tip
Tip_KaLunTeResultTipUI.orderInLayer = 8
Tip_KaLunTeResultTipUI.hideType = UIHideType.WaitDestroy
Tip_KaLunTeResultTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_KaLunTeResultTipUI.escClose = UIEscClose.DontClose

function Tip_KaLunTeResultTipUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Button_OK = self:GetControl("Panel_Tip/Image_TipBg/Button_OK")
  self.Text_OK = self:GetControl("Panel_Tip/Image_TipBg/Button_OK/Text_OK")
  self.Btn_Description = self:GetControl("Panel_Tip/Image_TipBg/Button_OK/Btn_Description")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.info_rank = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_rank")
  self.info_paodianExp = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_paodianExp")
  self.info_rewardBox = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_rewardBox")
  self.info_killPlayerNum = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_killPlayerNum")
  self.rank_num = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_rank/num")
  self.paodianExp_num = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_paodianExp/num")
  self.rewardBox_num = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_rewardBox/num")
  self.killPlayerNum_num = self:GetControl("Panel_Tip/Image_TipBg/ResultInfo/Viewport/resultInfoList/info_killPlayerNum/num")
end

function Tip_KaLunTeResultTipUI:Init()
  self.numFormatStr = "<color=#fff997>%d</color>"
  self.textFormatStr = "<color=#d6d6d6>Chuy\225\187\131n %d</color>" .. self.numFormatStr
end

function Tip_KaLunTeResultTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_KaLunTeResultTipUI:InitUI()
  self:ClearView()
  self:InitData()
end

function Tip_KaLunTeResultTipUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.DownExitOnClick)
  self.Button_OK:SetOnClick(self, self.DownExitOnClick)
  self.btn_close:SetOnClick(self, self.DownExitOnClick)
end

function Tip_KaLunTeResultTipUI:DownExitOnClick(control)
  UIManager.Hide(self.name)
end

function Tip_KaLunTeResultTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_KaLunTeResultTipUI:RegistEvents()
  self:RegistEvent(Event.KalunteRuinsColetSettle, self.Refresh, self)
end

function Tip_KaLunTeResultTipUI:Refresh()
  self:RefreshView()
end

function Tip_KaLunTeResultTipUI:OnHide()
  if self.countdownExit then
    Timer.Stop(self.countdownExit)
    self.countdownExit = nil
  end
  self:ClearView()
end

function Tip_KaLunTeResultTipUI:OnDestroy()
end

function Tip_KaLunTeResultTipUI:GetKLTSettleMgr()
  if gameMgr:GetAvatarManager():GetMainPlayer() ~= nil then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetKLTSettleManager()
  end
  return nil
end

function Tip_KaLunTeResultTipUI:InitData()
  self.btnName = self.Text_OK:GetText()
end

function Tip_KaLunTeResultTipUI:RefreshView()
  local settleInfo = self:GetKLTSettleMgr():GetSettleInfo()
  if settleInfo == nil then
    logError("Th\195\180ng tin t\225\187\149ng k\225\186\191t tr\225\187\145ng")
    return
  end
  self.rank_num:SetText(string.format(self.numFormatStr, settleInfo.reliveRank))
  local reincarnationLevel = ClientTable.cfg_Character_levelManager:GetReincarnationLevel(QuickFind.LuaMainPlayerViewAttrData().level)
  if reincarnationLevel then
    local expCountStr = string.format(self.textFormatStr, reincarnationLevel, settleInfo.gainExpCount)
    self.paodianExp_num:SetText(expCountStr)
  end
  self.rewardBox_num:SetText(string.format(self.numFormatStr, settleInfo.gainBoxCount))
  self.killPlayerNum_num:SetText(string.format(self.numFormatStr, settleInfo.killPlayerCount))
  self:StartCountdownExit()
end

function Tip_KaLunTeResultTipUI:ClearView()
  self.rank_num:SetText("0")
  self.paodianExp_num:SetText("0")
  self.rewardBox_num:SetText("0")
  self.killPlayerNum_num:SetText("0")
end

function Tip_KaLunTeResultTipUI:StartCountdownExit()
  local exitTime = 10000
  exitTime = tonumber(exitTime) / 1000
  self.Text_OK:SetText(string.format("%s(%d)", self.btnName, exitTime))
  self.countdownExit = Timer.StartLoop(1, exitTime, function()
    exitTime = exitTime - 1
    self.Text_OK:SetText(string.format("%s(%d)", self.btnName, exitTime))
    if exitTime == 0 then
      self:DownExitOnClick()
    end
  end)
end
