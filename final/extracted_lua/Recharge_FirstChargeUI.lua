Recharge_FirstChargeUI = class(BaseUI)
Recharge_FirstChargeUI.layer = UILayer.Panel
Recharge_FirstChargeUI.orderInLayer = 3
Recharge_FirstChargeUI.hideType = UIHideType.WaitDestroy
Recharge_FirstChargeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Recharge_FirstChargeUI.escClose = UIEscClose.DontClose
local this = Recharge_FirstChargeUI

function Recharge_FirstChargeUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.Tip_ModelShow = self:GetControl("Tip_ModelShow")
  self.lab_itemName = self:GetControl("Tip_ModelShow/lab_itemName")
  self.tog_gear = self:GetControl("go_firstChangeGear/sw_firstChangeGear/Viewport/Content/tog_gear")
  self.lab_changeMoney = self:GetControl("go_giftItem/lab_changeMoney")
  self.sw_firstChangePrize = self:GetControl("go_giftItem/sw_firstChangePrize")
  self.btn_3DItem = self:GetControl("go_giftItem/sw_firstChangePrize/Viewport/Content/btn_3DItem")
  self.btn_change = self:GetControl("go_change/btn_change")
  self.lab_buy = self:GetControl("go_change/btn_change/lab_buy")
  self.lab_receive = self:GetControl("go_change/btn_change/lab_receive")
  self.Eff_UI_annuikuang03 = self:GetControl("go_change/btn_change/Eff_UI_annuikuang03")
  self.lab_received = self:GetControl("go_change/lab_received")
  self.img_title_rec = self:GetControl("bg_firstCharge/img_title_rec")
end

function Recharge_FirstChargeUI:OnPreLoad()
end

local isChooseId

function Recharge_FirstChargeUI:Init()
  local FirstChargeInfo = RechargeData.GetFirstChargeInfo()
  self.Rechargedata = FirstChargeInfo.Rechargedata
  self.ReceiveShowdata = FirstChargeInfo.ReceiveShowdata
  self.FirstSetKey = FirstChargeInfo.FirstSetKey
  self.LastSetKey = FirstChargeInfo.LastSetKey
  self.FirstGetKey = FirstChargeInfo.FirstGetKey
  self.LastGetKey = FirstChargeInfo.LastGetKey
  self.career = ViewData.meData.career
  self.ShowModlePos = RechargeData.GetFristMainPos()
end

function Recharge_FirstChargeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnRechargeCreat(ctr)
  ctr.togLabel = UIControl(ctr.transform, "Label")
  ctr.ArrowRight = UIControl(ctr.transform, "img_ArrowRight")
  ctr.rechargeTips = UIControl(ctr.transform, "lb_rechargeMember")
end

local function CanReceive(control, _)
  for i, v in pairs(control) do
    if v == _ then
      return true
    end
  end
  return false
end

local titles = {
  [1] = "Qu\195\160 1200 VN\196\144",
  [2] = "Qu\195\160 Qu\195\160 9000 VN\196\144",
  [3] = "Qu\195\160 10000 VN\196\144"
}

local function OnRechargeTogRefresh(ctr, _, data, ui)
  local lab
  if ui.specialDispose then
    lab = titles[_]
  else
    lab = data.titleshow
  end
  ctr.togLabel:SetText(lab)
  ctr.data = data
  ctr._ = _
  ctr:SetOnToggleChanged(ui, ui.OnToggleChangedFirst)
  if ui.Showindex == _ then
    ctr.toggle.isOn = true
    this.chooseId = data.id
  else
    ctr.toggle.isOn = false
  end
end

local function OnItemRechargeCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function CloseModle(ctr)
  if ctr.LoadEquipObject ~= nil then
    local go = ctr.LoadEquipObject
    UnityEngineLua.GameObject.Destroy(go)
    ctr.LoadEquipObject = nil
  end
end

local function OnItemRechargeRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true, true)
end

local loadCol

function Recharge_FirstChargeUI:ShowBigModelFun(itemData)
  if loadCol then
    CloseModle(self)
    Coroutine.Stop(loadCol)
    loadCol = nil
  end
  loadCol = Coroutine.Start(self.DoLoadModel, self, itemData)
  self.Tip_ModelShow:SetOnClick(self, function()
    UIManager.Show(UIID.ItemTipUI, {
      item = itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = self.Tip_ModelShow
    })
  end)
  local color = ItemQuality2ColorDic[EItemColorEnum.white]
  local subType = itemData.tblItem.subType
  local type = itemData.tblItem.type
  if ItemUtility.IsEquipType(itemData.tblItem.type) then
    if type >= EItemType.FireGem and type <= EItemType.SoilGem then
      color = ItemQuality2ColorDic[EItemColorEnum.bPurple]
    elseif 1 <= subType and subType <= 17 or subType == 24 or subType == 25 then
      if itemData.isSuit then
        color = "#f36055"
      elseif table.count(itemData.excellence) > 0 then
        color = ItemQuality2ColorDic[EItemColorEnum.green]
      elseif 0 < table.count(itemData.luckIds) then
        color = ItemQuality2ColorDic[EItemColorEnum.bBlue]
      else
        local equip = ConfigManager.GetConfig("cfg_Item_equip", itemData.itemId, "id")
        local bool = equip.excellentNumber ~= "" and true or false
        if bool then
          color = ItemQuality2ColorDic[EItemColorEnum.green]
        else
          color = ItemQuality2ColorDic[EItemColorEnum.white]
        end
      end
    elseif subType == 18 or subType == 19 or subType == 26 then
      color = ItemQuality2ColorDic[EItemColorEnum.green]
    elseif subType == 20 then
      color = ItemQuality2ColorDic[11]
    elseif subType == 21 then
      color = ItemQuality2ColorDic[EItemColorEnum.bBlue]
    elseif subType == 27 or subType == 28 then
      color = ItemQuality2ColorDic[EItemColorEnum.gold]
    elseif subType == 29 then
      color = ItemQuality2ColorDic[EItemColorEnum.gold]
    elseif subType == 22 then
      color = ItemQuality2ColorDic[EItemColorEnum.bBlue]
    end
  elseif type == 1 then
    color = ItemQuality2ColorDic[EItemColorEnum.white]
  elseif type == 3 then
    color = ItemQuality2ColorDic[EItemColorEnum.white]
  elseif type == 5 then
    color = ItemQuality2ColorDic[EItemColorEnum.gold]
  elseif type == 6 then
    color = ItemQuality2ColorDic[EItemColorEnum.gold]
  end
  local equipName = string.GetColorText(itemData.tblItem.name, color)
  self.lab_itemName:SetText(equipName)
end

function Recharge_FirstChargeUI:DoLoadModel(itemData)
  self.LoadShow = false
  local subType = itemData.tblItem.subType
  local path
  if subType == EItemSubtype.Mount then
    local riderData = ClientTable.cfg_Item_mountManager:TryGetValue(itemData.itemId, "id")
    path = string.format("Model/%s/%s.prefab", riderData.route, riderData.model)
  else
    local modelName = RoleEquipUtility.GetEquipUIModelName(itemData)
    path = ModelConfig.GetCommentModelPath(subType, modelName)
    if not modelName then
      path = ResourceConfig.GetPathByItemData(itemData)
    end
  end
  local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
  Coroutine.Yield(request)
  if request.isError then
    print("\232\175\165\232\163\133\229\164\135\230\154\130\230\151\160\230\168\161\229\158\139")
    Coroutine.Break()
  else
    local go = Instantiate(request.res)
    self.LoadEquipObject = go
    go.transform:SetParent(self.Tip_ModelShow.transform, false)
    local posInfos = {}
    local goConfig = {}
    if not string.isNullOrEmpty(itemData.tblItem.Position) then
      posInfos = string.split(itemData.tblItem.Position, "#")
      if table.count(posInfos) == 3 then
        local pos = string.split(posInfos[1], "|")
        local rota = string.split(posInfos[3], "|")
        goConfig = {
          pos = Vector3(tonumber(pos[1]), tonumber(pos[2]), -50),
          rota = Vector3(tonumber(rota[1]), tonumber(rota[2]), tonumber(rota[3])),
          scale = tonumber(posInfos[2])
        }
      else
        goConfig = ItemUtility.GetItemTransformInfo(itemData)
      end
    else
      goConfig = ItemUtility.GetItemTransformInfo(itemData)
    end
    local pos, scale, rota
    self.index = itemData.index
    if self.index then
      local posdata = self.ShowModlePos[self.index]
      local data = posdata[self.career]
      if data then
        pos = Vector3(data.posdata[1], data.posdata[2], data.posdata[3])
        scale = data.scaledata[1]
      else
        local sizeRatio = 1.5
        pos = Vector3(goConfig.pos.x * sizeRatio, goConfig.pos.y * sizeRatio, goConfig.pos.z)
        scale = goConfig.scale * sizeRatio
      end
    else
      local sizeRatio = 1.5
      pos = Vector3(goConfig.pos.x * sizeRatio, goConfig.pos.y * sizeRatio, goConfig.pos.z)
      scale = goConfig.scale * sizeRatio
    end
    go.transform.localPosition = pos
    go.transform.localScale = Vector3(scale, scale, scale)
    if subType == EItemSubtype.Mount then
      local animator = go:GetComponent(typeof(CS.UnityEngine.Animator))
      animator:Play("idle")
      rota = Vector3(0, 135, 0)
    elseif subType == EItemSubtype.Wing then
      local animator = go:GetComponent(typeof(CS.UnityEngine.Animator))
      animator:Play("Take 001")
      rota = Vector3(0, 0, 0)
    else
      rota = goConfig.rota
    end
    go.transform.localEulerAngles = rota
    go:SetLayer(UI_LAYER)
    local orderLayer = 500
    if self then
      orderLayer = self.root.canvas.sortingOrder
    end
    if go.transform:Find("smdimport") and not IsNil(go.transform:Find("smdimport")) then
      go.transform:Find("smdimport").gameObject.layer = 5
      if go.transform:Find("smdimport"):GetComponent(typeof(UnityEngineLua.SkinnedMeshRenderer)) then
        go.transform:Find("smdimport"):GetComponent(typeof(UnityEngineLua.SkinnedMeshRenderer)).sortingOrder = orderLayer + 100
      elseif go.transform:Find("smdimport"):GetComponent(typeof(UnityEngineLua.MeshRenderer)) then
        go.transform:Find("smdimport"):GetComponent(typeof(UnityEngineLua.MeshRenderer)).sortingOrder = orderLayer + 100
      end
    end
    local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    for i = 0, sys.Length - 1 do
      local par = sys[i]
      par.gameObject.layer = 5
      par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = orderLayer + 50
    end
    self.MainItemShow = go
    self.SpinAxis = itemData.tblItem.SpinAxis
    self.LoadShow = true
  end
  request = nil
end

function Recharge_FirstChargeUI:InitUI()
  self.TogRechargeContainer = UIContainer(self.tog_gear, self, OnRechargeCreat, OnRechargeTogRefresh)
  self.ItemRechargeContainer = UIContainer(self.btn_3DItem, self, OnItemRechargeCreat, OnItemRechargeRefresh)
  self.index = 1
  self.specialDispose = false
end

function Recharge_FirstChargeUI:IsReceive(index)
  local RechargeRecord = self.ReceiveShowdata
  local countkey = RechargeRecord[index].countKey
  local Total = RefreshData.TotalRefreshTbl
  if not Total[countkey] or not (Total[countkey].count > 0) then
    return true
  end
  return false
end

function Recharge_FirstChargeUI:OnShow()
  self.career = ViewData.meData.career
  self.RechargeRecord = {}
  self:RegistEvents()
  NetManager.Send(CountMessage.ReqCountByType, {
    type = RefreshData.TypeEnum.RechFristRmbGift
  })
  self:RefreshBagModle()
  seisChooseId = nil
  this.chooseId = nil
end

local timer = 5
local ShowIndex = 1

function Recharge_FirstChargeUI:OnHide()
  timer = 5
  ShowIndex = 1
  self.ShowBigModel = {}
  loadCol = nil
  CloseModle(self)
end

function Recharge_FirstChargeUI:OnDestroy()
end

function Recharge_FirstChargeUI:Update()
  if self.LoadShow and self.MainItemShow and self.SpinAxis and self.ReceiveShowdata[self.index].showTurn == 0 then
    RoleEquipUtility.EquipModelRotation(self.MainItemShow, self.SpinAxis, 2)
  end
end

function Recharge_FirstChargeUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_change:SetOnClick(self, self.btn_changeOnClick)
  self.descBtn:SetOnClick(self, self.btnlab_descBtn)
end

function Recharge_FirstChargeUI:btn_closeOnClick(control)
  UIManager.Hide(self.name)
end

function Recharge_FirstChargeUI:btnlab_descBtn(control)
  UIManager.Show(UIID.System_DescUI, {id = 1048})
end

function Recharge_FirstChargeUI:btn_changeOnClick(control)
  if self.BuyCond then
    if self.specialDispose and not self.lastBuy then
      FloatingTipUtility.QuickMsg("H\195\163y mua qu\195\160 m\225\187\145c tr\195\170n tr\198\176\225\187\155c")
      return
    end
    if not self:BuyByGears() then
      FloatingTipUtility.QuickMsg("H\195\163y mua v\195\160 nh\225\186\173n ph\225\186\167n th\198\176\225\187\159ng giai \196\145o\225\186\161n tr\198\176\225\187\155c r\225\187\147i th\225\187\173 l\225\186\161i")
      return
    end
    local reqbuyid
    local rmb = 0
    local RechargeTbl = ConfigManager.FindConfigs("cfg_Recharge_recharge", "type", 3)
    if not this.chooseId then
      this.chooseId = RechargeTbl[1].id
    end
    for i, v in pairs(RechargeTbl) do
      if 3 >= v.sortId and v.id == this.chooseId then
        rmb = v.rmb
        reqbuyid = v.id
        break
      end
    end
    rmb = math.modf(rmb)
    local PayType
    if not self.args and not self.args.PayType and self.args.PayType == BusinessPayType.None then
      logError("Giao di\225\187\135n N\225\186\161p \196\144\225\186\167u kh\195\180ng c\195\179 log ghi ch\195\169p")
      PayType = BusinessPayType.None
    else
      PayType = self.args.PayType
    end
    DataToCSharpMgr.Pay({
      amount = rmb,
      product_Id = reqbuyid,
      product_name = control.name,
      BusinessPayType = PayType
    })
  else
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        self.Receiveid
      }
    })
  end
end

function Recharge_FirstChargeUI:BuyByGears()
  if self.index >= 2 then
    local index = self.index - 1
    local control = self.ShowToggerData
    return CanReceive(self.RechargeIndx, index)
  end
  return true
end

function Recharge_FirstChargeUI:OnToggleChangedFirst(control, eventData)
  control.ArrowRight:SetActive(eventData)
  local lastKey = self.ReceiveShowdata
  if eventData then
    self.BuyCond = true
    local AgainAdd = 0
    if self.ShowToggerData ~= nil then
      self.ShowToggerData.ArrowRight:SetActive(false)
      control.ArrowRight:SetActive(true)
    end
    self.ShowToggerData = control
    if CanReceive(self.RechargeIndx, control._) then
      self.btn_change:SetActive(false)
      self.lab_received:SetActive(true)
    else
      local index = 0
      AgainAdd = control.data.Btnmoney / 100
      local iosrmb = 0
      for i, v in pairs(self.RechargeRecord) do
        if control.data.buyCond[v] ~= nil then
          index = index + 1
        else
          iosrmb = iosrmb + self.Rechargedata[v].iosrmb
        end
      end
      AgainAdd = (control.data.Btnmoney - iosrmb) / 100
      if index ~= 0 then
        self.BuyCond = false
        AgainAdd = 0
      end
      if 0 >= control._ - 1 then
        self.lastBuy = true
      else
        local lastIndex = 0
        for i, v in pairs(self.RechargeRecord) do
          if self.ReceiveShowdata[control._ - 1].buyCond[v] ~= nil then
            lastIndex = lastIndex + 1
          end
        end
        if lastIndex ~= 0 then
          self.lastBuy = true
        else
          self.lastBuy = false
        end
      end
      self.Buyrmb = math.modf(AgainAdd * 100)
      self.Receiveid = control.data.id
      self.btn_change.name = control.data.name
      self.btn_change.buyCondi = control.data.buyCond
      self.lab_buy:SetActive(self.BuyCond)
      self.lab_receive:SetActive(not self.BuyCond)
      self.Eff_UI_annuikuang03:SetActive(not self.BuyCond)
      self.btn_change:SetActive(true)
      self.lab_received:SetActive(false)
      AgainAdd = math.modf(AgainAdd)
    end
    local RechargeTbl = ConfigManager.FindConfigs("cfg_Recharge_recharge", "type", 3)
    local rmb = 0
    for i, v in pairs(RechargeTbl) do
      if PlatformData.PlatformCheck(v.channelControl) and v.iosrmb == self.Buyrmb then
        rmb = v.rmb
        break
      end
    end
    rmb = math.modf(rmb / 100)
    local des = ClientTable.cfg_Commerce_globalManager:GetFirstChargeDes(control.data.id)
    if des == nil then
      des = "N\225\186\161p \196\145\225\186\167u <color=#3CD9FF> " .. rmb .. "VN\196\144</color> th\198\176\225\187\159ng v\225\186\173t ph\225\186\169m"
    end
    self.lab_changeMoney:SetText(des)
    if self.specialDispose then
      self.lab_changeMoney:SetActive(false)
    else
      self.lab_changeMoney:SetActive(true)
    end
    local boxitem = {}
    for i, v in pairs(control.data.BoxItem) do
      if string.isNullOrEmpty(v.condition) then
        table.insert(boxitem, v)
      elseif RoleUtility.CareerJudge(self.career, v.condition[1][1][2][1]) then
        table.insert(boxitem, v)
      end
    end
    self.ItemRechargeContainer:SetData(boxitem)
  end
  local itemData = ItemUtility.GenerateItemData(self.ShowBigModel[control._].itemId)
  itemData.index = control._
  self:ShowBigModelFun(itemData)
end

function Recharge_FirstChargeUI:RegistEvents()
  self:RegistEvent(Event.FirstChargeRefresh, self.RefreshShow, self)
  self:RegistEvent(Event.AllCountsRefresh, self.AllCountsRefresh, self)
end

function Recharge_FirstChargeUI:AllCountsRefresh()
  self:Refresh()
  if self.args then
    if self.args.page == 1 then
      local curCtr = self.TogRechargeContainer:GetOrCreateItem(1)
      curCtr:SetIsOn(true)
    elseif self.args.page == 2 then
      local curCtr = self.TogRechargeContainer:GetOrCreateItem(2)
      curCtr:SetIsOn(true)
    elseif self.args.page == 3 then
      local curCtr = self.TogRechargeContainer:GetOrCreateItem(3)
      curCtr:SetIsOn(true)
    end
    if self.args.openFirstTab == 1 then
      local curCtr = self.TogRechargeContainer:GetOrCreateItem(1)
      curCtr:SetIsOn(true)
    elseif self.args.openFirstTab == 2 then
      local curCtr = self.TogRechargeContainer:GetOrCreateItem(2)
      curCtr:SetIsOn(true)
    elseif self.args.openFirstTab == 3 then
      local curCtr = self.TogRechargeContainer:GetOrCreateItem(3)
      curCtr:SetIsOn(true)
    end
  end
end

function Recharge_FirstChargeUI:RefreshShow()
  self:Refresh()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    4010401,
    4010102,
    4010103
  })
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.firstCharge,
    state = true
  })
end

local function GetRechargeData(control, ui)
  local toggleindex = {}
  if table.count(control) == 0 then
    return toggleindex
  end
  for i, v in pairs(control) do
    if i >= ui.FirstGetKey and i <= ui.LastGetKey and v.count > 0 then
      local x = i - ui.FirstGetKey + 1
      table.insert(toggleindex, x)
    end
    if i >= ui.FirstSetKey and i <= ui.LastSetKey and v.count > 0 then
      ui.RechargeRecord[i] = i
    end
  end
  table.sort(toggleindex, function(a, b)
    return a < b
  end)
  return toggleindex
end

function Recharge_FirstChargeUI:Refresh()
  self:RefreshData()
  self.TogRechargeContainer:SetData(self.ReceiveShowdata)
  if self.ShowToggerData ~= nil and self.ShowToggerData._ == self.Showindex then
    self:OnToggleChangedFirst(self.ShowToggerData, true)
  end
  if self.specialDispose then
    self:SetSprite("Atlas_Language", "img_titile_rec_1", self.img_title_rec, true)
  else
    self:SetSprite("Atlas_Language", "img_titile_rec", self.img_title_rec, true)
  end
end

function Recharge_FirstChargeUI:RefreshBagModle()
  self.ShowBigModel = {}
  for i = 1, #self.ReceiveShowdata do
    for k, v in pairs(self.ReceiveShowdata[i].BoxItem) do
      local BoxItem
      if string.isNullOrEmpty(v.condition) then
        BoxItem = v
      elseif RoleUtility.CareerJudge(self.career, v.condition[1][1][2][1]) then
        BoxItem = v
      end
      if not self.ShowBigModel[i] and BoxItem then
        self.ShowBigModel[i] = v
        break
      end
    end
  end
end

function Recharge_FirstChargeUI:RefreshData()
  self.RoleRechargeData = RefreshData.TotalRefreshTbl
  self.RechargeIndx = GetRechargeData(self.RoleRechargeData, self)
  local count = table.count(self.RechargeIndx)
  self.Showindex = count == 0 and 1 or count == #self.ReceiveShowdata and #self.ReceiveShowdata or nil
  if self.Showindex == nil then
    local acc = 1
    for i, v in pairs(self.RechargeIndx) do
      if acc == v then
        acc = acc + 1
      else
        self.Showindex = acc
        break
      end
    end
  end
  if self.Showindex == nil then
    self.Showindex = count + 1
  end
  local condition = ClientTable.cfg_Global_globalManager:TryGetValue(2800014)
  if condition then
    self.specialDispose = ConditionManager.Check4D(condition.effect)
  end
end
