Activity_WolffortPreUI = class(BaseUI)
Activity_WolffortPreUI.layer = UILayer.Panel
Activity_WolffortPreUI.orderInLayer = 3
Activity_WolffortPreUI.hideType = UIHideType.Hide
Activity_WolffortPreUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_WolffortPreUI.escClose = UIEscClose.DontClose

function Activity_WolffortPreUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.lab_costNum = self:GetControl("img_bg/go_top/lab_costNum")
  self.lab_timeNum = self:GetControl("img_bg/go_top/lab_timeNum")
  self.lab_summonNum = self:GetControl("img_bg/go_top/lab_summonNum")
  self.go_archer = self:GetControl("img_bg/mask_middle/grid_archer/go_archer")
  self.mask_middle = self:GetControl("img_bg/mask_middle")
end

function Activity_WolffortPreUI:OnPreLoad()
end

function Activity_WolffortPreUI:Init()
  self.employContainer = {}
  self.timeSchedule = nil
end

function Activity_WolffortPreUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnEmployCreate(ctr)
  ctr.img_archer = UIControl(ctr.transform, "img_archer")
  ctr.btn_archer = UIControl(ctr.transform, "btn_archer")
  ctr.go_model = UIControl(ctr.transform, "btn_3DItem/go_model")
  ctr.lab_archer = UIControl(ctr.transform, "btn_archer/lab_archer")
end

local function LoadBossModel(modelName, parent)
  local modelPath = string.format("Model/Monster/%s.prefab", modelName)
  local req = CS.Framework.ResourceManager.InstantiateAsync(modelPath, parent, false)
  Coroutine.Yield(req)
  if not req or req.isError then
    Coroutine.Break()
  end
  req = req.gameObject
  local renderers = req:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renderers.Length - 1 do
    renderers[i].gameObject.layer = 5
  end
  req.transform.localScale = Vector3.one * 30
  req.transform.localPosition = Vector3.up * -90 + Vector3.forward * -50
  req.transform.forward = -parent.forward
end

local function OnEmployRefresh(ctr, _, info, ui)
end

function Activity_WolffortPreUI:InitUI()
  self.employContainer = {}
  local container = self.mask_middle.transform
  for i = 0, container.childCount - 1 do
    local item = UIControl(container:GetChild(i))
    item.btn_archer = UIControl(item.transform, "go_archer/btn_archer")
    item.go_model = UIControl(item.transform, "go_archer/btn_3DItem/go_model")
    item.lab_archer = UIControl(item.transform, "go_archer/btn_archer/lab_archer")
    table.insert(self.employContainer, item)
  end
end

function Activity_WolffortPreUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiQueryUnionCoin)
end

function Activity_WolffortPreUI:OnHide()
  if self.timeSchedule then
    Timer.Stop(self.timeSchedule)
    self.timeSchedule = nil
  end
end

function Activity_WolffortPreUI:OnDestroy()
end

local countDown = 0

function Activity_WolffortPreUI:Update()
  if 0 < countDown then
    countDown = countDown - UnityEngineLua.Time.deltaTime
    if countDown < 0 then
      countDown = 0
    end
    self.lab_timeNum:SetText(TimeUtility.ShowTime(math.floor(countDown)))
  end
end

function Activity_WolffortPreUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Activity_WolffortPreUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.WolffortPreUI)
end

function Activity_WolffortPreUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.WolffortPreUI)
end

function Activity_WolffortPreUI:btn_employOnClick(ctr)
  if 5 - Activity_LangHunYaoSaiData.yongBing < 1 then
    return
  end
  if BagInfoData.CoinInfos[ECoinsType.warAllianceMoney] < tonumber(ctr.info.cost) then
    FloatingTipUtility.QuickMsg("Qu\225\187\185 Guild kh\195\180ng \196\145\225\187\167")
    return
  end
  NetManager.Send(UnionMessage.ReqUnionItemUse, {
    useType = 1,
    itemId = ECoinsType.warAllianceMoney,
    count = ctr.info.cost,
    clientParams = {
      [1] = ctr.info.employId .. ""
    }
  })
end

function Activity_WolffortPreUI:RegistEvents()
  self:RegistEvent(Event.WarAlliance_Money, self.RefreshWarAlliance, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBag_ResBagChange, self)
  self:RegistEvent(Event.RefreshLangHunYaoSaiTaskInfor, self.OnRefresh, self)
end

function Activity_WolffortPreUI:OnBag_ResBagChange(id, msg)
  if msg.logType == 0 then
    self.lab_costNum:SetText(tostring(BagInfoData.CoinInfos[ECoinsType.warAllianceMoney]))
  end
end

function Activity_WolffortPreUI:Refresh()
  self:OnRefresh()
  if not self.timeSchedule then
    self:TimeScheduleInit()
  end
end

local function RefreshItem(item, data, ui)
  local img_archer = UIControl(item, "go_archer/img_archer")
  item.btn_archer.info = data
  item.btn_archer:SetOnClick(ui, ui.btn_employOnClick)
  item.lab_archer:SetText("Qu\225\187\185 Guild: " .. data.cost)
  local employTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(data.employId)
  if item.go_model.transform.childCount < 1 then
    Coroutine.Start(LoadBossModel, employTbl.model, item.go_model.transform)
  end
end

function Activity_WolffortPreUI:OnRefresh()
  for i = 1, #self.employContainer do
    local item = self.employContainer[i]
    RefreshItem(item, Activity_LangHunYaoSaiData.EmployInfo[i], self)
  end
  logPurple("Qu\225\187\185 Guild...", BagInfoData.GetItemCountByItemConfigId(1000090))
  self.lab_summonNum:SetText(string.format("%d/5", Activity_LangHunYaoSaiData.yongBing))
  self:RefreshDownTime()
end

function Activity_WolffortPreUI:TimeScheduleInit()
  local longTime = ETimeSec.day
  self.timeSchedule = Timer.StartLoop(1, longTime, self.RefreshDownTime, self)
end

function Activity_WolffortPreUI:RefreshDownTime()
  countDown = (Activity_LangHunYaoSaiData.initTime + Activity_LangHunYaoSaiData.prepareTime - Time.GetServerTime()) * 0.001
end

function Activity_WolffortPreUI:RefreshWarAlliance(id, count)
  self.lab_costNum:SetText(count)
end
