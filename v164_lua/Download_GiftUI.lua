Download_GiftUI = class(BaseUI)
Download_GiftUI.layer = UILayer.Panel
Download_GiftUI.orderInLayer = 1
Download_GiftUI.hideType = UIHideType.Hide
Download_GiftUI.hideFunc = UIHideFunc.MoveOutOfScreen
Download_GiftUI.escClose = UIEscClose.DontClose

function Download_GiftUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.txt_tip = self:GetControl("img_Bg/img_game_pick/txt_tip")
  self.img_progress_bg = self:GetControl("img_Bg/img_game_pick/img_progress_bg")
  self.img_progress = self:GetControl("img_Bg/img_game_pick/img_progress_bg/img_progress")
  self.txt_progress_count = self:GetControl("img_Bg/img_game_pick/txt_progress_count")
  self.txt_download = self:GetControl("img_Bg/img_game_pick/txt_download")
  self.btn_3DItem = self:GetControl("img_Bg/img_download/content/btn_3DItem")
  self.btn_start = self:GetControl("img_Bg/btn_start")
  self.btn_stop = self:GetControl("img_Bg/btn_stop")
  self.btn_relive = self:GetControl("img_Bg/btn_relive")
  self.txt_tip_wifi = self:GetControl("img_Bg/img_game_pick/txt_tip_wifi")
end

function Download_GiftUI:OnPreLoad()
end

function Download_GiftUI:Init()
end

function Download_GiftUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:InitData()
end

function Download_GiftUI:InitData()
  self.giftId = ClientTable.cfg_Global_globalManager:GetDownLoadGiftId()
end

function Download_GiftUI:InitUI()
  self.progressWidth, self.progressHeight = self.img_progress_bg:GetSizeDelta()
  self.isLoaded = HotUpdateData.IsPackageDownloaded(1)
  self.c = 0
  self.itemContainer = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
end

function Download_GiftUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Download_GiftUI:OnHide()
  local pageTemplate
  if type(self.itemContainer) == "table" and type(self.itemContainer.items) == "table" then
    for k, v in pairs(self.itemContainer.items) do
      pageTemplate = v.itemTemp
      if pageTemplate.Hide ~= nil then
        pageTemplate:Hide()
      end
    end
  end
end

function Download_GiftUI:OnDestroy()
end

function Download_GiftUI:Update()
  if not self.isLoaded then
    if self.c < 5 then
      self.c = self.c + 1
    else
      self.c = 0
      self:DoRefresh()
    end
  end
end

function Download_GiftUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_start:SetOnClick(self, self.btn_startOnClick)
  self.btn_stop:SetOnClick(self, self.btn_stopOnClick)
  self.btn_relive:SetOnClick(self, self.btn_reliveOnClick)
end

function Download_GiftUI:btn_closeBgOnClick(control)
  UIManager.Hide(self.name)
end

function Download_GiftUI:btn_startOnClick(control)
  HotUpdateData.SetUseMobileData(true)
  HotUpdateData.SetDownloadPaused(false)
  HotUpdatePorcessMgr.userPauseDown = false
  self:ShowBtn()
end

function Download_GiftUI:btn_stopOnClick(control)
  HotUpdateData.SetUseMobileData(false)
  HotUpdateData.SetDownloadPaused(true)
  HotUpdatePorcessMgr.userPauseDown = true
  self:ShowBtn()
end

function Download_GiftUI:btn_reliveOnClick()
  networkRequest.ReqGetGift({
    self.giftId
  })
  UIManager.Hide(self.name)
end

function Download_GiftUI:RegistEvents()
  self:RegistEvent(Event.CountPackageDownload, self.refreshDownload, self)
  self:RegistEvent(Event.DownLoadGiftCountRefresh, self.ShowBtn, self)
end

function Download_GiftUI:refreshDownload()
  self:Refresh()
end

function Download_GiftUI:Refresh()
  self:DoRefresh()
  self:ShowBtn()
  self:ShowGift()
end

function Download_GiftUI:DoRefresh()
  local totalSize = HotUpdateData.GetSizeString(HotUpdateData.totalSize)
  local tipStr
  if not self.isLoaded and HotUpdateData.totalSize <= 0 then
    tipStr = self:GetUiWord("DownloadText_1")
  else
    tipStr = string.format(self:GetUiWord("DownloadText_4"), totalSize)
  end
  self.txt_tip:SetText(tipStr)
  self.txt_tip_wifi:SetText(self:GetUiWord("DownloadText_2"))
  local curSize = HotUpdateData.GetSizeString(HotUpdateData.GetCurSize())
  local process = HotUpdateData.GetProcess()
  self.img_progress:SetSizeDelta(self.progressWidth * process, self.progressHeight)
  self.txt_progress_count:SetActive(self.isLoaded or HotUpdateData.totalSize > 0)
  self.txt_progress_count:SetText(string.format(self:GetUiWord("DownloadText_3"), process * 100, "%", curSize, totalSize))
end

function Download_GiftUI:GetUiWord(id)
  local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue(id)
  return uiWord.content
end

function Download_GiftUI:ShowBtn()
  self.isLoaded = HotUpdateData.IsPackageDownloaded(1)
  local isLoadPaused = HotUpdateData.GetDownloadPaused()
  self.btn_start:SetActive(isLoadPaused and not self.isLoaded)
  self.btn_stop:SetActive(not isLoadPaused and not self.isLoaded)
  local reliveIsShow = self.isLoaded and ClientTable.cfg_Gift_giftManager:CheckGiftCanGet(self.giftId)
  self.btn_relive:SetActive(reliveIsShow)
end

function Download_GiftUI:ShowGift()
  local boxTblList = ClientTable.cfg_Gift_giftManager:GetGiftRewardBoxTblList(self.giftId)
  local data = TableParse:GetBoxListChangeItemCountList(boxTblList)
  if data then
    self.itemContainer:SetData(data)
  else
    self.itemContainer:SetData({})
  end
end
