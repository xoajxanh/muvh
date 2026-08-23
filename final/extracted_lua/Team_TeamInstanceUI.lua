Team_TeamInstanceUI = class(BaseUI)
Team_TeamInstanceUI.layer = UILayer.Panel
Team_TeamInstanceUI.orderInLayer = 0
Team_TeamInstanceUI.hideType = UIHideType.WaitDestroy
Team_TeamInstanceUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team_TeamInstanceUI.escClose = UIEscClose.DontClose

function Team_TeamInstanceUI:InitControls()
  self.txt_title = self:GetControl("img_bg/txt_title")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.btn_minimize = self:GetControl("img_bg/btn_minimize")
  self.go_teamList = self:GetControl("img_bg/go_teamList")
  self.go_teamMemberFrame = self:GetControl("img_bg/go_teamList/go_teamMemberFrame")
  self.go_matchSucceeded = self:GetControl("img_bg/go_matchSucceeded")
  self.btn_getReady = self:GetControl("img_bg/go_matchSucceeded/btn_getReady")
  self.btn_getCancel = self:GetControl("img_bg/go_matchSucceeded/btn_getCancel")
  self.btn_dessolve = self:GetControl("img_bg/go_matchSucceeded/btn_dessolve")
  self.txt_readyCountown = self:GetControl("img_bg/go_matchSucceeded/txt_readyCountown")
  self.lab_process = self:GetControl("img_bg/go_matchSucceeded/lab_process")
  self.lab_Ready = self:GetControl("img_bg/go_matchSucceeded/lab_Ready")
  self.txt_tips = self:GetControl("img_bg/go_matchSucceeded/txt_tips")
  self.lab_already = self:GetControl("img_bg/lab_requirements/lab_already")
  self.img_itemicon = self:GetControl("img_bg/lab_requirements/img_itemicon")
  self.btn_get2 = self:GetControl("img_bg/lab_requirements/btn_get2")
end

function Team_TeamInstanceUI:OnPreLoad()
end

function Team_TeamInstanceUI:Init()
  TeamUpQuicklyController.InterfaceEventRegist(Event.Team_MatchingTeamInforRefresh, self.RefreshTeamInfor)
end

function Team_TeamInstanceUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local this = Team_TeamInstanceUI

local function OnRoleInforCreate(ctr)
  ctr.iconText = UIControl(ctr.transform, "img_teamMemberHead")
  ctr.nameLab = UIControl(ctr.transform, "txt_teamMemberName")
  ctr.state = UIControl(ctr.transform, "img_state")
  ctr.lab_refuse = UIControl(ctr.transform, "lab_refuse")
  ctr.leaderSign = UIControl(ctr.transform, "leaderSign")
end

local refuseLab = {
  "L\225\187\151i th\195\180ng tin",
  "\196\144i\225\187\129u ki\225\187\135n kh\195\180ng th\225\187\143a",
  "\196\144\225\186\161o c\225\187\165 kh\195\180ng \196\145\225\187\167",
  "S\225\187\145 l\225\186\167n kh\195\180ng \196\145\225\187\167",
  "T\225\187\171 ch\225\187\145i v\195\160o"
}

local function OnRoleInforReflesh(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  else
    ctr:SetActive(true)
  end
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(data.iconSprite, "id").headPortrait
  ui:SetSprite("Atlas_headPortrait", spriteName, ctr.iconText)
  ctr.nameLab:SetText(data.roleName)
  ctr.leaderSign:SetActive(data.leaderSign)
  if data.reason == 0 then
    ctr.state.gameObject:SetActive(false)
    ctr.lab_refuse:SetActive(false)
    ctr.lab_refuse:SetText("<color=red>[Ch\198\176a chu\225\186\169n b\225\187\139]</color>")
  elseif data.reason == 1 then
    ctr.state.gameObject:SetActive(true)
    ctr.lab_refuse:SetActive(true)
    ctr.lab_refuse:SetText("<color=green>[\196\144\195\163 chu\225\186\169n b\225\187\139]</color>")
  elseif data.reason > 1 then
    ctr.state.gameObject:SetActive(false)
    ctr.lab_refuse:SetActive(true)
    ctr.lab_refuse:SetText(string.format("<color=red>\227\128\144%s\227\128\145</color>", refuseLab[data.reason - 1]))
  end
  local levelInfor = TeamUpQuicklyData.GetInterfaceTitleInfor()
  if data.rid == TeamUpQuicklyData.TeamInfor.leader then
    return
  end
  if data.level < tonumber(levelInfor.minLevel) then
    ctr.lab_refuse:SetText("<color=red>[Kh\195\180ng \196\145\225\187\167 c\225\186\165p]</color>")
    ctr.lab_refuse:SetActive(true)
  elseif data.level > tonumber(levelInfor.maxLevel) then
    ctr.lab_refuse:SetText("<color=red>[C\225\186\165p kh\195\180ng kh\225\187\155p]</color>")
    ctr.lab_refuse:SetActive(true)
  end
end

function Team_TeamInstanceUI:InitUI()
  self.roleInforContainer = UIContainer(self.go_teamMemberFrame, self, OnRoleInforCreate, OnRoleInforReflesh)
  self.sprite = UIControl(self.go_teamMemberFrame.transform, "img_teamMemberHead").image.sprite
  self.levelComID = {
    [1] = 101002,
    [2] = 101011,
    [3] = 101012,
    [4] = 101013,
    [5] = 101014,
    [6] = 101015,
    [7] = 101016
  }
  self.img_itemicon.modelData = ItemCellData()
  self.Cost_ItemIcon = ItemUtility.InitItemCell(self.img_itemicon)
end

local function SetBtn_get2Data(self)
  local item = string.split(TeamUpQuicklyData.GetEnterConditionData().cost, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(item[1]))
  self.btn_get2.itemData = itemData
  self.btn_get2.itemData.isHide = true
end

function Team_TeamInstanceUI:OnShow()
  self:RegistEvents()
  SetBtn_get2Data(self)
  self:Refresh()
end

function Team_TeamInstanceUI:OnHide()
end

function Team_TeamInstanceUI:OnDestroy()
end

local function CloseSelfInterface()
  TeamUpQuicklyData.TeamInfor = nil
  local instanceId, panelName = TeamUpQuicklyData.GetInstanceInfor()
  UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
  EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
  if panelName then
    UIManager.Hide(panelName)
  end
end

local matchState = false

local function waitServersMessage()
  Coroutine.Wait(1)
  if TeamUpQuicklyData.TeamInfor.match then
    TeamUpQuicklyData.State = 1
    return
  elseif not TeamUpQuicklyData.IsLeader() then
  end
  CloseSelfInterface()
end

local countownCount = 0

function Team_TeamInstanceUI:Update()
  if countownCount <= 0 then
    return
  end
  countownCount = countownCount - UnityEngineLua.Time.deltaTime
  if countownCount < 0 then
    countownCount = 0
  end
  local ceilNum = math.ceil(countownCount)
  self.txt_readyCountown:SetText(string.format("%s <size=18>gi\195\162y</size>", ceilNum))
end

function Team_TeamInstanceUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_minimize:SetOnClick(self, self.btn_minimizeOnClick)
  self.btn_getReady:SetOnClick(self, self.btn_getReadyOnClick)
  self.btn_getCancel:SetOnClick(self, self.btn_getCancelOnClick)
  self.btn_dessolve:SetOnClick(self, self.btn_dessolveOnClick)
  self.img_itemicon:SetOnClick(self, self.img_itemiconOnClick)
  self:SetBtn_get2Click()
end

function Team_TeamInstanceUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
end

function Team_TeamInstanceUI:btn_minimizeOnClick(control)
  local instanceId, panelName = TeamUpQuicklyData.GetInstanceInfor()
  UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
  EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, true)
  if panelName then
    UIManager.Hide(panelName)
  end
end

function Team_TeamInstanceUI:btn_getReadyOnClick(control)
  if TeamUpQuicklyData.TeamInfor == nil then
    return
  end
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
    teamId = TeamUpQuicklyData.TeamInfor.id,
    friend = false,
    agree = true
  })
end

function Team_TeamInstanceUI:btn_getCancelOnClick(control)
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
    teamId = TeamUpQuicklyData.TeamInfor.id,
    friend = false,
    agree = false
  })
end

function Team_TeamInstanceUI:btn_dessolveOnClick()
  UIManager.Show(UIID.PromptTipUI, {
    title = LocalizationUtility.GetContentByKey("tishi"),
    textContent = "X\195\161c nh\225\186\173n gi\225\186\163i t\195\161n \196\145\225\187\153i kh\195\180ng",
    cancel = nil,
    ok = function()
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCancelMatch)
      UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
    end
  })
end

function Team_TeamInstanceUI:img_itemiconOnClick(control)
end

function Team_TeamInstanceUI:SetBtn_get2Click(control)
  self.btn_get2.countDownTime = self.intervalTime
  self.btn_get2.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_get2:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Team_TeamInstanceUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.ItemRefresh, self)
end

local refreshState = false

function Team_TeamInstanceUI:Refresh()
  countownCount = (TeamUpQuicklyData.TeamInfor.endTime - Time.GetServerTime()) * 0.001
  local titleInfor = TeamUpQuicklyData.GetInterfaceTitleInfor()
  self.txt_title:SetText(string.format("Lv.%s (%s-%s)%s", titleInfor.instanceLevel, titleInfor.minLevel, titleInfor.maxLevel, titleInfor.name))
  local item = string.split(TeamUpQuicklyData.GetEnterConditionData().cost, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(item[1]))
  itemData.count = tonumber(item[2])
  self.img_itemicon.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.Cost_ItemIcon, self.img_itemicon.modelData, self, true)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(item[1]))
  self.lab_already:SetText(string.format("%d/1", bagCount))
  if 0 < bagCount then
    self.lab_already:SetColor("0x1ADD1FFF")
    self.btn_get2:SetActive(false)
  else
    self.lab_already:SetColor("0xFF2323FF")
    self.btn_get2:SetActive(true)
  end
  if countownCount < 0 then
    CloseSelfInterface()
  end
  EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
end

function Team_TeamInstanceUI:ItemRefresh()
  local item = string.split(TeamUpQuicklyData.GetEnterConditionData().cost, "#")
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(item[1]))
  self.lab_already:SetText(string.format("%d/1", bagCount))
  if 0 < bagCount then
    self.lab_already:SetColor("0x1ADD1FFF")
    self.btn_get2:SetActive(false)
  else
    self.lab_already:SetColor("0xFF2323FF")
    self.btn_get2:SetActive(true)
  end
end

function Team_TeamInstanceUI:RefreshTeamInfor()
  if not TeamUpQuicklyData.TeamInfor then
    return
  end
  if not this.roleInforContainer then
    return
  end
  local membersInfor = TeamUpQuicklyData.GetTeamMemberInfor()
  this.roleInforContainer:SetDataKTable(membersInfor)
  if TeamUpQuicklyData.process == 1 then
    this.lab_process:SetText("Chu\225\186\169n b\225\187\139 c\195\178n")
    if TeamUpQuicklyData.IsLeader() then
      this.btn_getReady:SetActive(false)
      this.btn_getCancel:SetActive(false)
      this.btn_dessolve:SetActive(true)
      this.lab_Ready:SetActive(false)
    else
      for i = 1, #membersInfor do
        if membersInfor[i].rid == RoleManager.me.data.id then
          this.btn_getReady:SetActive(true)
          this.btn_getCancel:SetActive(true)
          this.btn_dessolve:SetActive(false)
          this.lab_Ready:SetActive(false)
        end
      end
    end
  else
    countownCount = (TeamUpQuicklyData.TeamInfor.endTime - Time.GetServerTime()) * 0.001
    this.lab_process:SetText("ph\195\179 b\225\186\163n v\195\160o \196\145\225\186\191m ng\198\176\225\187\163c")
    this.btn_getReady:SetActive(false)
    this.btn_getCancel:SetActive(false)
    this.btn_dessolve:SetActive(false)
    this.lab_Ready:SetActive(true)
    if not TeamUpQuicklyData.matchResult then
      this.lab_Ready:SetText("<color=red><size=26>Kh\195\180ng \196\145\225\187\167 \196\145i\225\187\129u ki\225\187\135n \196\145\225\187\131 v\195\160o PB</size></color>")
    else
      this.lab_Ready:SetText("<color=green><size=38>\196\145\195\163 chu\225\186\169n b\225\187\139</size></color>")
    end
  end
end

function Team_TeamInstanceUI:ReSetCountDown()
  countownCount = (TeamUpQuicklyData.TeamInfor.endTime - Time.GetServerTime()) * 0.001
end
