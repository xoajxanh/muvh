Activity_WolffortbuffUI = class(BaseUI)
Activity_WolffortbuffUI.layer = UILayer.Panel
Activity_WolffortbuffUI.orderInLayer = 4
Activity_WolffortbuffUI.hideType = UIHideType.Hide
Activity_WolffortbuffUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_WolffortbuffUI.escClose = UIEscClose.DontClose

function Activity_WolffortbuffUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_wolffor/btn_close")
  self.wolf_buffsContainer = self:GetControl("img_wolffor/go_top/wolf_buffs")
  self.choose_buffContainer = self:GetControl("img_wolffor/go_middle/choose_buff")
  self.describeContainer = self:GetControl("img_wolffor/go_middle/buff_tip")
  self.btn_refresh = self:GetControl("img_wolffor/go_top/btn_refresh")
end

function Activity_WolffortbuffUI:OnPreLoad()
end

function Activity_WolffortbuffUI:Init()
end

function Activity_WolffortbuffUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_WolffortbuffUI:InitUI()
  self.buffsContainer = {}
  local buffs = self.wolf_buffsContainer.transform
  for i = 0, buffs.childCount - 1 do
    local item = UIControl(buffs:GetChild(i))
    item.btn_yes = UIControl(item.transform, "btn_yes")
    item.btn_no = UIControl(item.transform, "btn_no")
    item.img_choosed = UIControl(item.transform, "img_choosed")
    item.img_select = UIControl(item.transform, "img_select")
    item.img_icon = UIControl(item.transform, "icon")
    item.lab_nextbuff = UIControl(item.transform, "lab_nextbuff")
    item.txt_buff_name = UIControl(item.transform, "txt_buff_name")
    table.insert(self.buffsContainer, item)
  end
  self.ownTalentContainer = {}
  local owns = self.choose_buffContainer.transform
  local ownDescribes = self.describeContainer.transform
  for i = 0, owns.childCount - 1 do
    local item = UIControl(owns:GetChild(i))
    item.changeBtn = UIControl(item.transform, "btn_ch1")
    item.img_littleBuff = UIControl(item.transform, "img_little_bg/img_little_buff")
    item.lab_name = UIControl(ownDescribes:GetChild(i))
    item.lab_describes = UIControl(ownDescribes:GetChild(i), "lab_getbuff")
    table.insert(self.ownTalentContainer, item)
  end
end

function Activity_WolffortbuffUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_WolffortbuffUI:OnHide()
end

function Activity_WolffortbuffUI:OnDestroy()
end

function Activity_WolffortbuffUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_refresh:SetOnClick(self, self.btn_refreshOnClick)
end

function Activity_WolffortbuffUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.WolffortbuffUI)
  Activity_LangHunYaoSaiData.TalentBtnOnClick = false
end

function Activity_WolffortbuffUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.WolffortbuffUI)
  Activity_LangHunYaoSaiData.TalentBtnOnClick = false
end

function Activity_WolffortbuffUI:btn_selectBuff(ctr)
end

function Activity_WolffortbuffUI:btn_refreshOnClick(ctr)
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiFlushTalent)
end

function Activity_WolffortbuffUI:RegistEvents()
  self:RegistEvent(Event.RefreshWolfforbuffUI, self.OnRefresh, self)
end

function Activity_WolffortbuffUI:OnBuffResult()
  logPurple("OnBuffResult................")
  UIManager.Hide(UIID.WolffortbuffUI)
end

function Activity_WolffortbuffUI:Refresh()
  self:OnRefresh()
end

local buffAtlasName = "Atlas_headPortrait"

local function MyTalentItemRefresh(item, data, ui)
  item.changeBtn.data = data
  item.changeBtn:SetOnClick(ui, ui.OnMyTalentItemClick)
  item.changeBtn:SetActive(false)
  local spriteName = ""
  local describe = ""
  local buffName = ""
  if data.infor then
    spriteName = ClientTable.cfg_Buff_buffManager:TryGetValue(data.infor.buffId)
    buffName = spriteName.name
    describe = spriteName.desc
    spriteName = spriteName and spriteName.icon or "wolf_dz"
    spriteName = string.isNullOrEmpty(spriteName) and "wolf_dz" or spriteName
  end
  if not string.isNullOrEmpty(buffName) then
    buffName = string.split(buffName, "-")[2]
  end
  ui:SetSprite(buffAtlasName, spriteName, item.img_littleBuff, false)
  item.lab_name:SetText(buffName)
  item.lab_describes:SetText(describe)
end

local function ChooseTalentItemRefresh(item, data, ui)
  item.btn_yes.data = data
  item.btn_yes:SetOnClick(ui, ui.OnChooseTalentClick)
  item.img_select:SetActive(false)
  item.btn_no:SetOnClick(ui, ui.OnChooseCancelClick)
  local spriteName = ClientTable.cfg_Buff_buffManager:TryGetValue(data.buffId)
  local buffName = spriteName.name
  local describe = spriteName.desc
  spriteName = spriteName and spriteName.icon or "wolf_dz"
  spriteName = string.isNullOrEmpty(spriteName) and "wolf_dz" or spriteName
  ui:SetSprite(buffAtlasName, spriteName, item.img_icon, false)
  buffName = string.split(buffName, "-")[2]
  item.txt_buff_name:SetText(buffName)
  item.lab_nextbuff:SetText(describe)
  if data.state == 0 then
    item.btn_yes:SetActive(true)
    item.btn_no:SetActive(false)
    item.img_choosed:SetActive(false)
    item.img_icon.image.color = Color(1, 1, 1, 1)
  elseif data.state == 1 then
    item.btn_yes:SetActive(false)
    item.btn_no:SetActive(false)
    item.img_choosed:SetActive(true)
    item.img_icon.image.color = Color(1, 1, 1, 1)
  else
    item.btn_yes:SetActive(false)
    item.btn_no:SetActive(false)
    item.img_choosed:SetActive(false)
    item.img_icon.image.color = Color(0.390625, 0.390625, 0.390625, 1)
  end
end

function Activity_WolffortbuffUI:OnRefresh()
  self.selectPos = nil
  self.myTalent = Activity_LangHunYaoSaiData.TalentInfors.myTalent
  local chooseTalent = Activity_LangHunYaoSaiData.TalentInfors.choose
  for i = 1, #self.buffsContainer do
    local item = self.buffsContainer[i]
    chooseTalent[i].index = i
    ChooseTalentItemRefresh(item, chooseTalent[i], self)
  end
  local talentShowInfor = {
    {index = 1},
    {index = 2},
    {index = 3}
  }
  for i = 1, #talentShowInfor do
    talentShowInfor[i].infor = self.myTalent[i]
  end
  for i = 1, #self.ownTalentContainer do
    local item = self.ownTalentContainer[i]
    MyTalentItemRefresh(item, talentShowInfor[i], self)
  end
  if 1 < Activity_LangHunYaoSaiData.Count then
    self.btn_refresh:SetActive(true)
  else
    self.btn_refresh:SetActive(false)
  end
end

function Activity_WolffortbuffUI:OnChooseTalentClick(control)
  local position = 0
  if #self.myTalent < 3 then
    position = #self.myTalent + 1
  end
  if position == 0 then
    for i = 1, #self.ownTalentContainer do
      local item = self.ownTalentContainer[i]
      item.changeBtn:SetActive(true)
    end
    self.selectPos = control.data.index
    for i = 1, #self.buffsContainer do
      local item = self.buffsContainer[i]
      if i ~= control.data.index then
        item.btn_yes:SetActive(false)
        item.btn_no:SetActive(false)
        item.img_choosed:SetActive(false)
      else
        item.btn_yes:SetActive(false)
        item.btn_no:SetActive(true)
        item.img_choosed:SetActive(false)
      end
    end
    return
  end
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiChooseTalent, {
    position = position,
    index = control.data.index
  })
end

function Activity_WolffortbuffUI:OnChooseCancelClick(control)
  for i = 1, #self.ownTalentContainer do
    local item = self.ownTalentContainer[i]
    item.changeBtn:SetActive(false)
  end
  for i = 1, #self.buffsContainer do
    local item = self.buffsContainer[i]
    item.btn_yes:SetActive(true)
    item.btn_no:SetActive(false)
    item.img_choosed:SetActive(false)
  end
end

function Activity_WolffortbuffUI:OnMyTalentItemClick(control)
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiChooseTalent, {
    position = control.data.index,
    index = self.selectPos
  })
  for i = 1, #self.ownTalentContainer do
    local item = self.ownTalentContainer[i]
    item.changeBtn:SetActive(false)
  end
end
