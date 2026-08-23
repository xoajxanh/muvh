Mail_MailUI = class(BaseUI)
Mail_MailUI.layer = UILayer.Panel
Mail_MailUI.orderInLayer = 5
Mail_MailUI.hideType = UIHideType.Destroy
Mail_MailUI.hideFunc = UIHideFunc.MoveOutOfScreen
Mail_MailUI.escClose = UIEscClose.DontClose

function Mail_MailUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.img_leftLine = self:GetControl("img_bg/img_blackBottomFrame/img_leftLine")
  self.img_noMail = self:GetControl("img_bg/img_blackBottomFrame/img_noMail")
  self.lab_main = self:GetControl("img_bg/lab_main")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.Scroll_Mails = self:GetControl("img_bg/Scroll_Mails")
  self.Mail = self:GetControl("img_bg/Mail")
  self.btn_allGet = self:GetControl("img_bg/btn_allGet")
  self.lab_allGet = self:GetControl("img_bg/btn_allGet/lab_allGet")
  self.btn_allDelete = self:GetControl("img_bg/btn_allDelete")
  self.lab_allDelete = self:GetControl("img_bg/btn_allDelete/lab_allDelete")
  self.Image_MailContent = self:GetControl("Image_MailContent")
  self.lab_mainTitle = self:GetControl("Image_MailContent/lab_mainTitle")
  self.lab_clostTime = self:GetControl("Image_MailContent/lab_clostTime")
  self.lab_Content = self:GetControl("Image_MailContent/Des/Viewport/Content/lab_Content")
  self.lab_Content2 = self:GetControl("Image_MailContent/Des2/Viewport2/Content2/lab_Content2")
  self.img_tipsBgTitle = self:GetControl("Image_MailContent/img_tipsBgTitle")
  self.img_rewardCost = self:GetControl("Image_MailContent/img_rewardCost")
  self.Content = self:GetControl("Image_MailContent/img_rewardCost/Viewport/Content")
  self.Button_Item = self:GetControl("Image_MailContent/img_rewardCost/Viewport/Content/Button_Item")
  self.lab_num = self:GetControl("Image_MailContent/img_rewardCost/Viewport/Content/Button_Item/lab_num")
  self.btn_getAndDelete = self:GetControl("Image_MailContent/img_rewardCost/btn_getAndDelete")
  self.lab_getAndDelete = self:GetControl("Image_MailContent/img_rewardCost/btn_getAndDelete/lab_getAndDelete")
  self.btn_get = self:GetControl("Image_MailContent/img_rewardCost/btn_get")
  self.lab_get = self:GetControl("Image_MailContent/img_rewardCost/btn_get/lab_get")
  self.btn_delete = self:GetControl("Image_MailContent/img_rewardCost/btn_delete")
  self.lab_delete = self:GetControl("Image_MailContent/img_rewardCost/btn_delete/lab_delete")
  self.descBtn = self:GetControl("descBtn")
  self.showGMBtn = self:GetControl("showGMBtn")
end

function Mail_MailUI:Init()
  self.enclosureContainer = {}
  self.destoryTimeSchedule = nil
end

function Mail_MailUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Mail_MailUI:InitUI()
  self.initcount = 1
  self:CtrInit()
  self:MailInit()
  self:LocalInit()
end

function Mail_MailUI:CreateUITableView()
  self.tableView = UITableView()
  self.tableView:SetLowerMargin(0)
  self.tableView:SetScrollView(self.Scroll_Mails)
  self.tableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.tableView:SetUpperMargin(0)
  self.tableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.tableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.tableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
  self.tableView:ReloadData(1)
end

function Mail_MailUI:ScalarForCellInTableView()
  local _, sizeY = self.Mail:GetSizeDelta()
  return sizeY
end

function Mail_MailUI:NumberOfCellsInTableView()
  return #MailData.TotalMail
end

function Mail_MailUI:CellAtIndexInTableView(index)
  return self.tableView:ReuseOrCreateCell(self.Mail)
end

function Mail_MailUI:StringToTable(s)
  local tb = {}
  for utfChar in string.gmatch(s, "[%z\001-\127\194-\244][\128-\191]*") do
    table.insert(tb, utfChar)
  end
  return tb
end

function Mail_MailUI:GetUTFLen(s)
  local sTable = self:StringToTable(s)
  local len = 0
  local charLen = 0
  for i = 1, #sTable do
    local utfCharLen = string.len(sTable[i])
    if 1 < utfCharLen then
      charLen = 2
    else
      charLen = 1
    end
    len = len + charLen
  end
  return len
end

function Mail_MailUI:GetUTFLenWithCount(s, count)
  local sTable = self:StringToTable(s)
  local len = 0
  local charLen = 0
  local isLimited = 0 <= count
  for i = 1, #sTable do
    local utfCharLen = string.len(sTable[i])
    if 1 < utfCharLen then
      charLen = 2
    else
      charLen = 1
    end
    len = len + utfCharLen
    if isLimited then
      count = count - charLen
      if count <= 0 then
        break
      end
    end
  end
  return len
end

function Mail_MailUI:GetMaxLenString(s, maxLen)
  local len = self:GetUTFLen(s)
  local dstString = s
  if maxLen < len then
    dstString = string.sub(s, 1, self:GetUTFLenWithCount(s, maxLen))
    dstString = dstString .. " ..."
    return dstString
  else
    return dstString
  end
end

function Mail_MailUI:CellAtIndexInTableViewWillAppear(index)
  local maildata = MailData.TotalMail[index]
  local chatCell = self.tableView:GetLoadedCell(index)
  local img_state = chatCell:GetChild("img_state")
  local lab_title = chatCell:GetChild("lab_title")
  local lab_time = chatCell:GetChild("lab_time")
  local img_select = chatCell:GetChild("img_select")
  local colorStr = self:GetColorByState(maildata.state)
  local lab_title_sub = self:GetMaxLenString(maildata.title, 14)
  lab_title:SetText(string.GetColorText(lab_title_sub, colorStr))
  lab_time:SetText(TimeUtility.SwitchTimeStamp(maildata.sendTime))
  local isSelect = MailData.CurReadMail and index == MailData.GetMailIndex(MailData.CurReadMail) or false
  img_select:SetActive(isSelect)
  if chatCell.cot then
    Coroutine.Stop(chatCell.cot)
    chatCell.cot = nil
  end
  chatCell.cot = self:SetSprite("Atlas_Common", EMailStateSpriteName[maildata.stateType], img_state, true)
  chatCell.mail = maildata
  chatCell:SetOnClick(self, self.Button_SelectMail)
end

local function ItemOnCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr.img_icon = UIControl(ctr.transform, "img_icon")
  ctr.icon = UIControl(ctr.transform, "img_icon/icon")
  ctr.rarity = UIControl(ctr.transform, "img_icon/rarity")
end

local function ItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemDataByServerData(data)
  itemData.count = data.count
  if ctr.modelData ~= nil then
    ctr.modelData:RecycleRes()
  end
  local isEffectTitle = itemData.tblItem and itemData.tblItem.subType == EItemSubtype.EffectTitle
  ctr.lab_num:SetActive(true)
  ctr.img_icon:SetActive(false)
  ctr.rarity:SetActive(false)
  if itemData and itemData.tblItem.type == 29 then
    ctr.lab_num:SetActive(false)
    ctr.img_icon:SetActive(true)
    ctr.rarity:SetActive(true)
    local scale = tonumber(itemData.tblItem.pngSize) / 100
    ui:SetSprite("Atlas_Common", itemData.tblItem.icon, ctr.icon, true)
    ctr.icon.transform.localScale = Vector3(scale, scale, scale)
    ui:SetSprite("Atlas_Common", "ty_puzzle_" .. itemData.tblItem.quality, ctr.rarity, true)
    ctr.icon:SetOnClick(ui, function()
      local data = {}
      data.m_ItemConfig = itemData.tblItem
      data.m_ServerInfo = itemData.serverInfo
      UIManager.Show(UIID.Tip_CrystalNucleusUI, {data = data, type = 1})
    end)
  else
    ctr.modelData:RefreshData(itemData)
    ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true, nil, nil, nil, isEffectTitle)
  end
  local isReceived = MailData.CurReadMail and MailData.CurReadMail.stateType == EMailStateType.Read_Received or false
  ctr.itemCtr.selectImageCtr:SetActive(isReceived)
  ctr.itemCtr.img_grrow.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = not isReceived
  if isEffectTitle then
    if ctr.titleEffectLid ~= nil then
      ui:GetUITitleEffectProcessor():RemoveEffect(ctr.titleEffectLid)
    end
    ctr.titleEffectLid = ui:GetUITitleEffectProcessor():InstantiationEffect({
      lid = ctr.img_titleEffect,
      panel = ui,
      itemId = itemData.itemId
    }, ctr.transform)
  elseif ctr.titleEffectLid ~= nil then
    ui:GetUITitleEffectProcessor():RemoveEffect(ctr.titleEffectLid)
  end
end

function Mail_MailUI:GetUITitleEffectProcessor()
  return gameMgr:GetEffectManager():GetEffectActionUtility():GetEffectProcessor(EffectProcessorType.UI_Title)
end

function Mail_MailUI:MailInit()
  self.enclosureContainer = UIContainer(self.Button_Item, self, ItemOnCreate, ItemRefresh)
end

function Mail_MailUI:TimeScheduleInit()
  local longTime = ETimeSec.day
  self:SetDestroyTime()
  self.destoryTimeSchedule = Timer.StartLoop(1, longTime, self.RefreshDestroyTime, self)
end

function Mail_MailUI:CtrInit()
  self.btn_allGet:SetActive(false)
  self.btn_allDelete:SetActive(false)
  self.btn_get:SetActive(false)
  self.btn_delete:SetActive(false)
  self.lab_mainTitle:SetText("")
  self.lab_Content:SetText("")
  self.lab_Content2:SetText("")
  self.lab_clostTime:SetText("")
  self.lab_num:SetText("")
end

function Mail_MailUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:InitData()
end

function Mail_MailUI:InitData()
  self.clickHideCount = 0
end

function Mail_MailUI:OnHide()
  MailData.CurReadMail = nil
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Mail_MailUI:OnDestroy()
end

function Mail_MailUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.Button_CloseOnClick)
  self.btn_allDelete:SetOnClick(self, self.Button_AllDeleteClick)
  self.btn_allGet:SetOnClick(self, self.Button_AllGetClick)
  self.btn_closeBg:SetOnClick(self, self.Button_CloseOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.showGMBtn:SetOnClick(self, self.showGMBtnOnClick)
end

function Mail_MailUI:Button_AllGetClick()
  local openTis = false
  for i, v in pairs(MailData.TotalMail) do
    if v.rechargeId ~= 0 and v.stateType ~= EMailStateType.Read_Received then
      openTis = true
      break
    end
  end
  if openTis then
    NetManager.Send(MailMessage.ReqGetMailItems)
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
  else
    NetManager.Send(MailMessage.ReqGetMailItems)
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
  end
end

function Mail_MailUI:Button_AllDeleteClick()
  local mailIdsTbl = {}
  for _, v in ipairs(MailData.TotalMail) do
    table.insert(mailIdsTbl, v.mailId)
  end
  NetManager.Send(MailMessage.ReqDeleteMail, {mailIds = mailIdsTbl})
end

function Mail_MailUI:Button_CloseOnClick(_)
  UIManager.Hide(UIID.MailUI)
end

function Mail_MailUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Mail_MailUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Mail_MailUI:showGMBtnOnClick()
  self.clickHideCount = self.clickHideCount + 1
  if self.clickHideCount >= 10 and LoginData.isWhite then
    UIManager.Show(UIID.GM_ToolUI)
    UIManager.Hide(UIID.MailUI)
  end
end

function Mail_MailUI:Button_SelectMail(control)
  local mailInfo = control.mail
  self:SelectMail(mailInfo)
  if not (not mailInfo.haveItems and mailInfo.items and mailInfo.content) or mailInfo.state == EMailState.Mail_UnRead then
    NetManager.Send(MailMessage.ReqReadMail, {
      mailId = {
        mailInfo.mailId
      }
    })
  else
    MailData.CurReadMail = mailInfo
    self:OnResReadMail(nil, {mailInfo})
  end
end

function Mail_MailUI:Button_Receive(control)
  local rechargeId = control.mail and control.mail.rechargeId
  if rechargeId and rechargeId ~= 0 then
    NetManager.Send(MailMessage.ReqGetMailItems, {
      mailIds = {
        control.mail.mailId
      },
      delete = control.delete
    })
  else
    NetManager.Send(MailMessage.ReqGetMailItems, {
      mailIds = {
        control.mail.mailId
      },
      delete = control.delete
    })
  end
end

function Mail_MailUI:Button_Delete(control)
  NetManager.Send(MailMessage.ReqDeleteMail, {
    mailIds = {
      control.mail.mailId
    }
  })
end

function Mail_MailUI:RegistEvents()
  self:RegistEvent(Event.Mail_ResMailList, self.OnResMailList, self)
  self:RegistEvent(Event.Mail_ResReadMail, self.OnResReadMail, self)
  self:RegistEvent(Event.Mail_ResGetMailItem, self.OnResGetMailItem, self)
  self:RegistEvent(Event.Mail_ResDeleteMail, self.OnResDeleteMail, self)
  self:RegistEvent(Event.Mail_ResNewMail, self.OnResMailList, self)
end

function Mail_MailUI:SelectMail(mailInfo)
  local curCtr
  if MailData.CurReadMail then
    curCtr = self.tableView:GetLoadedCell(MailData.GetMailIndex(MailData.CurReadMail))
    if curCtr then
      curCtr.Child.img_select:SetActive(false)
    end
  end
  curCtr = self.tableView:GetLoadedCell(MailData.GetMailIndex(mailInfo))
  curCtr.Child.img_select:SetActive(true)
end

function Mail_MailUI:ShowMails()
  local isBtnSelect = false
  if not self.tableView then
    self:CreateUITableView()
  else
    self.tableView:ReloadData(1)
  end
  if not MailData.CurReadMail and #MailData.TotalMail > 0 then
    local ctr = self.tableView:GetLoadedCell(MailData.GetMailIndex(MailData.TotalMail[1]))
    self:Button_SelectMail(ctr)
    isBtnSelect = true
  end
  if not isBtnSelect then
    self:ShowMailContent()
  end
  local isAllDelete = true
  local hasMail = #MailData.TotalMail > 0
  for _, v in ipairs(MailData.TotalMail) do
    if v.stateType ~= EMailStateType.Un_Read_No_Items and v.stateType ~= EMailStateType.Read_Received then
      isAllDelete = false
      break
    end
  end
  self.btn_allDelete:SetActive(hasMail and isAllDelete)
  self.btn_allGet:SetActive(hasMail and not isAllDelete)
end

function Mail_MailUI:GetColorByState(state)
  return state == EMailState.Mail_UnRead and "#E6E600" or "#CCCCCC"
end

function Mail_MailUI:SetDestroyTime()
  if MailData.CurReadMail then
    self.lab_clostTime:SetText(LocalizationUtility.GetContentByKey("mailshijian") .. TimeUtility.SwitchTimeStamp(MailData.CurReadMail.sendTime))
  end
end

function Mail_MailUI:RefreshDestroyTime()
  for _, mail in ipairs(MailData.TotalMail) do
    mail.refreshSec = mail.refreshSec - 1
  end
  self:SetDestroyTime()
end

function Mail_MailUI:ActiveContent(flag)
  self.Image_MailContent:SetActive(flag)
  self.img_leftLine:SetActive(flag)
  self.img_noMail:SetActive(not flag)
end

function Mail_MailUI:ShowMailContent()
  self:ActiveContent(MailData.CurReadMail)
  if MailData.CurReadMail then
    local mailInfo = MailData.CurReadMail
    self.lab_mainTitle:SetText(mailInfo.title)
    local text = string.replace(mailInfo.content, "\\n", "\n")
    self:SetDestroyTime()
    if #mailInfo.items > 0 and true or false then
      self.img_tipsBgTitle:SetActive(true)
      self.lab_Content2:SetActive(false)
      self.lab_Content:SetActive(true)
      self.lab_Content:SetText(text)
    else
      self.img_tipsBgTitle:SetActive(false)
      self.lab_Content:SetActive(false)
      self.lab_Content2:SetActive(true)
      self.lab_Content2:SetText(text)
    end
    if self.initcount == 1 then
      self.Content.layoutGroup.enabled = false
      self.Content.layoutGroup.enabled = true
      self.initcount = 2
    end
    self.enclosureContainer:SetData(mailInfo.items)
    self.btn_get:SetActive(false)
    self.btn_delete:SetActive(false)
    if mailInfo.stateType == EMailStateType.Un_Read_Items or mailInfo.stateType == EMailStateType.Read_No_Receive then
      self.btn_get:SetActive(true)
      self.btn_get.delete = false
      self.btn_get.mail = mailInfo
      self.btn_get:SetOnClick(self, self.Button_Receive)
    else
      self.btn_delete:SetActive(true)
      self.btn_delete.mail = mailInfo
      self.btn_delete:SetOnClick(self, self.Button_Delete)
    end
  end
end

function Mail_MailUI:OnResReadMail(_, data)
  local mails = data or {}
  for _, mail in ipairs(mails) do
    self:CellAtIndexInTableViewWillAppear(MailData.GetMailIndex(mail))
  end
  self:ShowMailContent()
end

function Mail_MailUI:OnResGetMailItem(_, data)
  self:OnRefresh()
end

function Mail_MailUI:OnResDeleteMail()
  self:OnRefresh()
end

function Mail_MailUI:OnResMailList()
  self:OnRefresh()
end

function Mail_MailUI:Refresh()
  MailData.SortMail()
  self:OnRefresh()
end

function Mail_MailUI:OnRefresh()
  self:ShowMails()
  if not self.destoryTimeSchedule then
    self:TimeScheduleInit()
  end
end

function Mail_MailUI:LocalInit()
  self.lab_main:SetText(LocalizationUtility.GetContentByKey("youjian"))
  self.lab_get:SetText(LocalizationUtility.GetContentByKey("lingqu"))
  self.lab_delete:SetText(LocalizationUtility.GetContentByKey("shanchu"))
  self.lab_allDelete:SetText(LocalizationUtility.GetContentByKey("quanbushanchu"))
  self.lab_allGet:SetText(LocalizationUtility.GetContentByKey("quanbulingqu"))
end
