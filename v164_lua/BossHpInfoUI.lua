BossHpInfoUI = class(BaseUI)
BossHpInfoUI.layer = UILayer.Background
BossHpInfoUI.orderInLayer = 0
BossHpInfoUI.hideType = UIHideType.WaitDestroy
BossHpInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
BossHpInfoUI.escClose = UIEscClose.DontClose

function BossHpInfoUI:InitControls()
  self.monsterhpdarkValue = self:GetControl("bg_monsterhpbar/monsterhpdarkValue")
  self.monsterhpValue = self:GetControl("bg_monsterhpbar/monsterhpValue")
  self.lab_hp = self:GetControl("bg_monsterhpbar/lab_hp")
  self.bg_monsterFrameIcon = self:GetControl("bg_monsterFrame/bg_monsterFrameIcon")
  self.lab_monsterName = self:GetControl("lab_monsterType/lab_monsterName")
  self.lab_monsterLv = self:GetControl("lab_monsterType/lab_monsterLv")
  self.GrabOwnershipBtn = self:GetControl("GrabOwnershipBtn")
  self.itemDrop = self:GetControl("Additional/StatusAndItems/Content/ItemGrop")
  self.btn_3DItem = self:GetControl("Additional/StatusAndItems/Content/ItemGrop/Content/btn_3DItem")
  self.buffName = self:GetControl("Additional/StatusAndItems/Content/Text")
  self.btn_buff = self:GetControl("Additional/StatusAndItems/Content/buffGrop/Grid_Buff/btn_buff")
  self.go_buffTip = self:GetControl("Additional/StatusAndItems/Content/buffGrop/go_buffTip")
end

function BossHpInfoUI:OnPreLoad()
end

function BossHpInfoUI:Init()
  self.currentid = 0
  self.AccelerHpSpeed = 1
  self.ownerName = ""
  self.showCellData = ItemCellData()
end

function BossHpInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function ItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function ItemRefresh(ctr, _, data, ui)
  local id = tonumber(data)
  local itemData = ItemUtility.GenerateItemData(id)
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  ItemUtility.ShowBossItemBg(ctr.itemCtr, ctr.modelData)
end

function BossHpInfoUI:InitUI()
  self.buffListContainer = UIContainer(self.btn_buff, self, self.CreateBuffItemCallBack, self.RefreshBuffItemCallBack)
  self.buffTipTemplate = luaTemplateManager.GetNewTemplate(self.go_buffTip, LuaComponentTemplates.BuffTipInfoTemplate)
end

function BossHpInfoUI:OnShow()
  local main = UIManager.GetUiByName(UIID.MainMenuUI)
  if main and main.go_center_top and self.root.transform.parent.parent.name ~= UIID.MainMenuUI then
    self.root.transform:SetParent(main.go_center_top.transform, false)
  end
  self:RegistEvents()
  RoleInteractData.BossHRepelPlayerHpMP()
  EventManager.Dispatch(Event.BossHpUI_ShowHide, true)
  self:Refresh()
end

function BossHpInfoUI:OnHide()
  self.refreshHpBk = nil
  self.showCellData:RecycleRes()
  self.GrabOwnershipBtn:SetActive(false)
end

function BossHpInfoUI:OnDestroy()
  if self.showCellData then
    self.showCellData:RecycleRes()
    self.showCellData = nil
  end
end

function BossHpInfoUI:RegistUIEvents()
  self.GrabOwnershipBtn:SetOnClick(self, self.GrabOwnershipBtnOnClick)
end

function BossHpInfoUI:GrabOwnershipBtnOnClick()
  local ownerInfo = ViewData.GetGameObjectInViewById(self.ownerid)
  if ownerInfo then
    if RoleManager.me.data.unionId == ownerInfo.unionId and ownerInfo.unionId ~= 0 then
      FloatingTipUtility.QuickMsg("Th\195\160nh vi\195\170n c\225\187\167a c\195\185ng Li\195\170n Minh kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng l\225\186\171n nhau")
      return
    end
    if TeamData.teamId == ownerInfo.teamId and ownerInfo.teamId ~= 0 and (self.args.configData.dropType ~= 7 or SceneData.serverType ~= serverType.span) then
      FloatingTipUtility.QuickMsg("C\195\161c b\225\186\161n \196\145ang \225\187\159 c\195\185ng \196\145\225\187\153i, h\198\176\225\187\159ng quy\225\187\129n h\225\186\161n r\198\161i")
      return
    end
    if self.args.configData.dropType == 7 and CampController.GetIsSameCamp(self.ownerid) then
      FloatingTipUtility.QuickMsg("C\195\161c b\225\186\161n \196\145\195\163 \225\187\159 c\195\185ng m\225\187\153t Li\195\170n minh, c\195\179 quy\225\187\129n nh\225\186\173n \196\145\225\187\147 r\198\161i")
      return
    end
    NetManager.Send(RoleMessage.ReqSetPKMode, {
      param = ERolePkMode.All
    })
    local hitObj = {}
    hitObj.name = tostring(self.ownerid)
    local Avatar = RoleManager.GetRoleByModel(hitObj)
    RoleManager.me:SetTarget(Avatar)
    RoleManager.me:SetAutoFight(AutoFightStrKey.AutoFight)
    PKData.ScramblePlayerId = self.ownerid
  else
    FloatingTipUtility.QuickMsg("Kh\195\180ng t\195\172m th\225\186\165y" .. self.ownerName)
  end
end

function BossHpInfoUI:RegistEvents()
  self:RegistEvent(Event.Role_RefreshHp, self.OnRole_MyHPChanged, self)
  self:RegistEvent(Event.PKModeChanged, self.OnPKModeChanged, self)
  self:RegistEvent(Event.Role_OnRefreshRoleData, self.RefreshMonsterData, self)
  self:RegistEvent(Event.Buff_RefreshLid, self.RefreshBuffInfo, self)
end

local coefficient = 0.25

function BossHpInfoUI:DifferenceFun(Difference)
  if not self.darkValue then
    return
  end
  local deiff = Difference / self.maxhp
  deiff = deiff < 1.0E-4 and 1.0E-4 or deiff
  local canshu
  local Chazhi = self.darkValue - self.currhp / self.maxhp
  canshu = Chazhi < 0.02 and 3 or 4
  coefficient = deiff * canshu
end

function BossHpInfoUI:OnRole_MyHPChanged(_, roleid)
  if roleid.roleId == self.currentid then
    if roleid.roleData and roleid.roleData.ownerName ~= "" and self.ownerName ~= roleid.roleData.ownerName then
      self.ownerid = roleid.roleData.owner
      self:SetName(roleid.roleData.ownerName)
    end
    local old = self.currhp
    self.currhp = roleid.newValue
    local Difference = old - self.currhp
    self:DifferenceFun(Difference)
    self:RefreshShow()
    self:RefreshHPBkProgress(old)
  end
end

function BossHpInfoUI:RefreshMonsterData(_, data)
  if data.id == self.currentid then
    self.ownerid = data.owner
    self:SetName(data.ownerName)
  end
end

function BossHpInfoUI:RefreshBuffInfo(_, id)
  if id == self.currentid then
    self:RefreshBuffList()
  end
end

function BossHpInfoUI:RefreshHPBkProgress(hp)
  if self.refreshHpBk or not hp then
    return
  end
  
  local function refreshHpBk()
    local initHpPercent = hp / self.maxhp
    while true do
      initHpPercent = initHpPercent - coefficient * Time.deltaTime
      if initHpPercent * self.maxhp <= self.currhp then
        self:SetHPBkProgress(self.currhp)
        self.refreshHpBk = nil
        Coroutine.Break()
      end
      self:SetHPBkProgress(initHpPercent * self.maxhp)
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  if hp > self.currhp then
    self.refreshHpBk = Coroutine.Start(refreshHpBk)
  else
    self:SetHPBkProgress(self.currhp)
  end
end

function BossHpInfoUI:SetHPBkProgress(hp)
  self.darkValue = hp / self.maxhp
  self.monsterhpdarkValue:SetFillAmount(self.darkValue)
end

function BossHpInfoUI:RefreshBossBuffInfo()
  local buffDes = self.args:GetBufferDes()
  local haveBuffDes = string.isNullOrEmpty(buffDes) == false
  if haveBuffDes then
    self.buffName:SetText(buffDes)
  end
  self.buffName:SetActive(haveBuffDes)
end

function BossHpInfoUI:OnPKModeChanged()
  self:SetName(self.ownerName)
end

local function GetTableItem(BoosGrop, ShowData)
  local ItemIdData
  for i, v in pairs(BoosGrop) do
    local itemGrop = string.split(v, "_")
    if tonumber(itemGrop[1]) == RoleUtility.GetBasicCareer(ViewData.meData.career) then
      ItemIdData = string.split(itemGrop[2], "#")
    end
  end
  if ItemIdData then
    local index = #ItemIdData <= 4 and #ItemIdData or 4
    for i = 1, index do
      ShowData[i] = ItemIdData[i]
    end
  end
end

function BossHpInfoUI:Refresh()
  self.currentid = self.args.id
  self.currhp = self.args.hp
  self.maxhp = self.args.maxHp
  self.oldhpPrg = self.currhp / self.maxhp
  self.ownerid = self.args.data.owner
  if self.args.configData.dropType == 6 then
    self.args.ownerName = RoleManager.me.data.name
  end
  local Lv = "Lv" .. self.args.configData.level
  local bossType = self.args.configData.type == 2001 and 1 or self.args.configData.type == 2002 and 4 or 0
  local cfg = ConfigManager.FindConfigs("cfg_Monster_boss_rewards", "bossType", bossType)
  local dropItem
  for k, v in pairs(cfg) do
    local LvGrop = string.split(v.id, "#")
    if tonumber(LvGrop[1]) <= self.args.configData.level and tonumber(LvGrop[2]) >= self.args.configData.level then
      dropItem = v.dropItem
      break
    end
  end
  local ShowData = {}
  if dropItem then
    local BoosGrop = string.split(dropItem, "&")
    GetTableItem(BoosGrop, ShowData)
  end
  if table.count(ShowData) == 0 then
    local BossDrop = ConfigManager.FindConfigs("cfg_Monster_boss", "id", self.args.configData.id)
    if BossDrop[1] then
      local BoosGrop = string.split(BossDrop[1].dropItem, "&")
      GetTableItem(BoosGrop, ShowData)
    end
  end
  self.itemDrop:SetActive(0 < table.count(ShowData))
  if not self.tog_vvipContainer then
    self.tog_vvipContainer = UIContainer(self.btn_3DItem, self, ItemCreat, ItemRefresh)
  end
  self.tog_vvipContainer:SetData(ShowData)
  if self.args.configData.id == 100112 then
    Lv = "LvMAX"
  end
  self.BossLv = Lv
  self:SetName(self.args.data.ownerName)
  self:RefreshShow()
  self:SetHPBkProgress(self.currhp)
  self:RefreshBuffList()
  if self.buffTipTemplate ~= nil then
    self.buffTipTemplate:SetBuffTipState(false)
  end
end

function BossHpInfoUI:SetName(name)
  self.ownerName = name
  local instanceType = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(10520102).effect)
  local isRein = TranScriptData.InTranscriptData.instanceType ~= nil and TranScriptData.InTranscriptData.instanceType == instanceType
  local isKaliMa = TranScriptData.InTranscriptType == TranScriptType.Person_KaliMaTemple
  local isTrial = TranScriptData.InTranscriptType == TranScriptType.TrialsBoss
  local isRegenerate = TranScriptData.InTranscriptType == TranScriptType.RegenerateBoss
  if not string.isNullOrEmpty(self.ownerName) and self.ownerName ~= RoleManager.me.data.name and self.args.configData.snatch == 0 and not isRein and not isKaliMa and not isTrial and not isRegenerate then
    self.GrabOwnershipBtn:SetActive(true)
  else
    self.GrabOwnershipBtn:SetActive(false)
  end
  local rolename = ""
  if not string.isNullOrEmpty(self.ownerName) then
    local nameColor = RoleUtility.ModelRoleNameColor(self.ownerid)
    rolename = string.format(" <color=%s>%s</color>", nameColor, self.ownerName)
  end
  local text
  if self.args.monsterType == 2002 then
    text = string.GetColorText(string.format("%s %s", self.BossLv, self.args.name), "#ffd616")
  else
    text = string.GetColorText(string.format("%s %s", self.BossLv, self.args.name), "#ff2323")
  end
  local name = string.format("%s %s", text, rolename)
  local mTextGenerator = self.lab_monsterName.text.cachedTextGeneratorForLayout
  local mTgSettings = self.lab_monsterName.text:GetGenerationSettings(Vector2(0, 0))
  local txtwith = mTextGenerator:GetPreferredWidth(name, mTgSettings) / self.lab_monsterName.text.pixelsPerUnit
  self.GrabOwnershipBtn.transform.localPosition = Vector3(txtwith - 10, 21, 0)
  self.lab_monsterName:SetText(name)
end

function BossHpInfoUI:RefreshShow()
  self.hpratio = self.currhp / self.maxhp
  local hptext = math.ceil(self.hpratio * 100)
  hptext = hptext == 0 and 1 or hptext
  hptext = hptext .. "%"
  self.lab_hp:SetText(hptext)
  self.monsterhpValue:SetFillAmount(self.hpratio)
end

function BossHpInfoUI:ISColseUI(id)
  if id == self.currentid then
    UIManager.Hide(UIID.BossHpInfoUI)
  end
end

function BossHpInfoUI:RefreshBuffList()
  self.buffListContainer:SetData(self:GetShowBuff())
end

function BossHpInfoUI:GetShowBuff()
  local buffList, showBuffList = BuffData.GetBuffs(self.args.id), {}
  for k, v in pairs(buffList) do
    if v ~= nil and v.buffConfig ~= nil and string.isNullOrEmpty(v.buffConfig.icon) == false then
      table.insert(showBuffList, v)
    end
  end
  return showBuffList
end

function BossHpInfoUI.CreateBuffItemCallBack(ctr, self)
  ctr.lab_buff = UIControl(ctr.transform, "lab_buff")
  ctr.img_mask = UIControl(ctr.transform, "img_mask")
  ctr.img_buff = UIControl(ctr.transform, "img_buff")
  ctr.lab_buffNum = UIControl(ctr.transform, "lab_buffNum")
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr:SetOnClick(self, self.btn_buffOnClick)
end

function BossHpInfoUI:btn_buffOnClick(control)
  if control == nil or control.buffData == nil then
    return
  end
  self.buffTipTemplate:Refresh(control)
end

function BossHpInfoUI.RefreshBuffItemCallBack(ctr, _, data, ui)
  if ctr == nil or data == nil then
    ctr:SetActive(false)
    return
  end
  ctr.buffData = data
  local haveTotalTime = data.totalTime > 0
  ctr.img_mask:SetActive(haveTotalTime)
  if haveTotalTime then
    ctr.img_mask:SetFillAmount(1 - data.time / data.totalTime)
  end
  if ctr.img_buff.loader then
    Coroutine.Stop(ctr.img_buff.loader)
  end
  local buffOverlayNum = ""
  if ctr.lab_buffNum and type(data.overlayNum) == "number" and 1 < data.overlayNum then
    buffOverlayNum = data.overlayNum
  end
  ctr.lab_buffNum:SetText(buffOverlayNum)
  local buffCount = ""
  if ctr.lab_num and type(data.count) == "number" and 1 < data.count then
    buffCount = data.count
  end
  ctr.lab_num:SetText(buffCount)
  ctr.img_buff.loader = ui:SetSprite("Atlas_Buff", data.buffConfig.icon, ctr.img_buff)
end
