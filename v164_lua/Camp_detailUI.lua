Camp_detailUI = class(BaseUI)
Camp_detailUI.layer = UILayer.Panel
Camp_detailUI.orderInLayer = 0
Camp_detailUI.hideType = UIHideType.WaitDestroy
Camp_detailUI.hideFunc = UIHideFunc.MoveOutOfScreen
Camp_detailUI.escClose = UIEscClose.DontClose

function Camp_detailUI:InitControls()
  self.panel = self:GetControl("panel")
  self.bg_frame = self:GetControl("panel/bg_frame")
  self.CloseBtn = self:GetControl("panel/bg_frame/CloseBtn")
  self.Camp_Info = self:GetControl("panel/Camp_Info")
  self.CampName = self:GetControl("panel/Camp_Info/img_titleBg/CampName")
  self.flag = self:GetControl("panel/Camp_Info/flag")
  self.info_leader = self:GetControl("panel/Camp_Info/panel_info/Scroll View/Viewport/Content/info_leader")
  self.info_viceLeader = self:GetControl("panel/Camp_Info/panel_info/Scroll View/Viewport/Content/info_viceLeader")
  self.unionItem = self:GetControl("panel/Camp_Info/panel_info/Scroll View/Viewport/Content/info_unionList/unionItem")
  self.btn_exitunion = self:GetControl("panel/Camp_Info/btn_exitunion")
  self.btn_joinunion = self:GetControl("panel/Camp_Info/btn_joinunion")
  self.descBtn = self:GetControl("panel/descBtn")
end

function Camp_detailUI:OnPreLoad()
end

function Camp_detailUI:Init()
  self.mLeagueBasicInfo = nil
end

function Camp_detailUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Camp_detailUI:InitUI()
  self.mUnionContainer = UIContainer(self.unionItem, self, self.UnionItemCreate)
end

function Camp_detailUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Camp_detailUI:OnHide()
  self.mUnionContainer:RemoveKTable()
end

function Camp_detailUI:OnDestroy()
end

function Camp_detailUI:RegistUIEvents()
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Camp_detailUI:CloseBtnOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Camp_detailUI)
end

function Camp_detailUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Camp_detailUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Camp_detailUI:RegistEvents()
  self:RegistEvent(Event.Camp_detailUIData, self.Camp_detailUIData, self)
end

function Camp_detailUI:Refresh()
  self:RefreshLeagueBasicInfo()
  if self.mLeagueBasicInfo then
  end
end

function Camp_detailUI:RefreshLeagueBasicInfo()
  local cfg_Camp_detail = ClientTable.cfg_Camp_detailManager:GetDic()
  for i, v in pairs(cfg_Camp_detail) do
    if v.npcId == self.args.npcConfigID then
      self.mLeagueBasicInfo = v
    end
  end
  if self.mLeagueBasicInfo == nil then
    return
  end
  self:SetSprite("Atlas_Common", self.mLeagueBasicInfo.icon, self.flag)
  self.CampName:SetText(self.mLeagueBasicInfo.name)
end

function Camp_detailUI:RefreshLeagueBtn(myCamp)
  local isJoinBtn = false
  local isExitBtn = false
  if 0 < myCamp then
    if myCamp == self.mLeagueBasicInfo.id then
      isExitBtn = true
    end
  else
    isJoinBtn = true
  end
  self.btn_joinunion:SetActive(isJoinBtn)
  self.btn_exitunion:SetActive(isExitBtn)
  if isJoinBtn then
    self.btn_joinunion:SetOnClick(self, self.btn_joinunionOnClick)
  end
  if isExitBtn then
    self.btn_exitunion:SetOnClick(self, self.btn_exitunionOnClick)
  end
end

function Camp_detailUI.btn_joinunionOnClick(control)
end

function Camp_detailUI.btn_exitunionOnClick(control)
  local text = string.format("X\195\161c nh\225\186\173n mu\225\187\145n r\225\187\157i kh\225\187\143i <color=%s>%s</color>", "#1add1f", Camp_detailUI.mLeagueBasicInfo.name)
  local prompTipArgs = {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = text,
    ok = function()
      Camp_detailUI:CloseBtnOnClick()
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Camp_detailUI:Camp_detailUIData(id, msg)
  local data = CampData.mUICampData
  if data == nil then
    return
  end
  if data.members == nil then
    return
  end
  local str1 = {}
  local str2 = {}
  local str3 = {}
  for i = 1, #data.members do
    local mem = data.members[i]
    if mem.job == 1 and not string.isNullOrEmpty(mem.unionLeaderName) then
      table.insert(str1, string.format("[%s] %s", mem.unionName, mem.unionLeaderName))
    elseif mem.job == 2 and not string.isNullOrEmpty(mem.unionLeaderName) then
      table.insert(str2, string.format("[%s] %s", mem.unionName, mem.unionLeaderName))
    end
    table.insert(str3, string.format("S%d [%s]", mem.serverId, mem.unionName))
  end
  if #str1 == 0 then
    table.insert(str1, string.format("%s", "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"))
  end
  if #str2 == 0 then
    table.insert(str2, string.format("%s", "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"))
  end
  if #str3 == 0 then
    table.insert(str3, string.format("%s", "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"))
  end
  self.info_leader:SetText(table.concat(str1, "\n"))
  self.info_viceLeader:SetText(table.concat(str2, "\n"))
  for i = 1, #str3 do
    local obj = self.mUnionContainer:GetOrCreateItem(i)
    obj.lab_name:SetText(str3[i])
  end
  self:RefreshLeagueBtn(data.myCamp)
end

function Camp_detailUI.UnionItemCreate(control)
  control.lab_name = UIControl(control.transform, "lab")
end
