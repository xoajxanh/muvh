Tip_BagItemTipsUI = class(BaseUI)
Tip_BagItemTipsUI.layer = UILayer.Tip
Tip_BagItemTipsUI.orderInLayer = 8
Tip_BagItemTipsUI.hideType = UIHideType.WaitDestroy
Tip_BagItemTipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_BagItemTipsUI.escClose = UIEscClose.DontClose

function Tip_BagItemTipsUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_closeBagItem = self:GetControl("go_bagItem/btn_closeBagItem")
  self.sw_bagItem = self:GetControl("go_bagItem/img_smallBg/sw_bagItem")
  self.btn_3DItem = self:GetControl("go_bagItem/img_smallBg/sw_bagItem/Viewport/Content/btn_3DItem")
  self.btn_select = self:GetControl("go_bagItem/img_smallBg/btn_select")
  self.lab_equipdemand = self:GetControl("go_bagItem/img_smallBg/Text/lab_equipdemand")
end

function Tip_BagItemTipsUI:Init()
  self.curSelectWing = nil
  self.CellTbl = {}
end

function Tip_BagItemTipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_BagItemTipsUI:InitUI()
  self.btn_3DItemTemp = UIContainer(self.btn_3DItem, self, self.On3DItemTempCreat, self.OnDItemTempRefreshItem)
  self.itemData = BagInfoController:GetCurSelectItemInfo()
end

function Tip_BagItemTipsUI.On3DItemTempCreat(ctr)
  ctr.go_modelData = ItemCellData()
  ctr.nowControl = ctr
  ctr.img_select = UIControl(ctr.transform, "img_select")
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ctr.nowControl:SetOnClick(self, function()
    if ctr.InfoItem == nil then
      return
    end
    BagInfoController:SetCurSelectWingInfo(ctr.InfoItem)
    EventManager.Dispatch(Event.Tip_SelectChange)
  end)
end

local function SetNowSelect(ctr)
  local isShowSelectEffect = false
  if ctr.InfoItem ~= nil then
    local nowSelectTable = BagInfoController:GetCurSelectWingInfo()
    if nowSelectTable ~= nil then
      isShowSelectEffect = nowSelectTable.id == ctr.InfoItem.id
    end
  end
  ctr.img_select:SetActive(isShowSelectEffect)
end

function Tip_BagItemTipsUI.OnDItemTempRefreshItem(ctr, _, data, ui)
  if data == nil then
    return
  end
  ctr.InfoItem = data
  Coroutine.Start(ui.DoLoadModel, ui, ctr)
  SetNowSelect(ctr)
end

function Tip_BagItemTipsUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
  self.btn_select:SetOnClick(self, self.btn_selectOnClick)
end

function Tip_BagItemTipsUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.BagItemTipsUI)
end

function Tip_BagItemTipsUI:DoLoadModel(tips)
  local itemData = tips.InfoItem
  local path
  if tips.loadModel ~= nil and table.contains(self.CellTbl, tips) then
    return
  end
  table.insert(self.CellTbl, tips)
  if itemData.subType == 20 then
    path = string.format("Model/Charactor/Wing/%s.prefab", itemData.tblItem.model)
  end
  local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
  Coroutine.Yield(request)
  if request.isError then
    print("\232\175\165\232\163\133\229\164\135\230\154\130\230\151\160\230\168\161\229\158\139")
    Coroutine.Break()
  else
    local go = Instantiate(request.res)
    tips.loadModel = go
    go.transform:SetParent(tips.go_model.transform, false)
    if customInfo ~= nil and customInfo.Position ~= "" then
      local xyStr = string.split(customInfo.Position, "#")
      local xy = string.split(xyStr[1], "|")
      go.transform.localPosition = Vector3(tonumber(xy[1]), tonumber(xy[2]), -500)
      go.transform.localEulerAngles = Vector3(0, 0, 0)
      local size = tonumber(xyStr[2]) * 0.3
      go.transform.localScale = Vector3(size, size, size)
    else
      go.transform.localPosition = Vector3(0, 0, 0)
      go.transform.localEulerAngles = Vector3(0, 0, 0)
      go.transform.localScale = Vector3(10, 10, 10)
    end
    go:SetLayer(UI_LAYER)
    local orderLayer = 500
    if self then
      orderLayer = self.root.canvas.sortingOrder
    end
    local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
    for i = 0, renders.Length - 1 do
      local rend = renders[i]
      rend.sortingOrder = orderLayer + 100
    end
    local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    for i = 0, sys.Length - 1 do
      local par = sys[i]
      par.gameObject.layer = 5
      par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = orderLayer + 50
    end
  end
end

function Tip_BagItemTipsUI:btn_3DItemOnClick(control)
end

function Tip_BagItemTipsUI:btn_selectOnClick(control)
  local mainBuckets = {}
  local bonusBuckets = {}
  local nowSelectTable = BagInfoController:GetCurSelectWingInfo()
  if nowSelectTable ~= nil and next(self.canCompoundComId) ~= nil and next(self.canCompoundWingId) ~= nil then
    local wingIds = {}
    for i = 1, #self.canCompoundWingId do
      if tonumber(self.canCompoundWingId[i]) == nowSelectTable.itemId then
        table.insert(wingIds, i)
      end
    end
    for i, v in pairs(wingIds) do
      local key = tonumber(self.canCompoundComId[v])
      local combTbl = ClientTable.cfg_Item_combineManager:TryGetValue(key)
      if combTbl ~= nil then
        local boxTbl = ClientTable.cfg_Box_boxManager:TryGetValue(combTbl.rewardBoxId, "boxId")
        if boxTbl ~= nil then
          local itemtbl = ClientTable.cfg_Item_itemManager:TryGetValue(boxTbl.itemId)
          if itemtbl ~= nil then
            for i, v in pairs(string.split(itemtbl.career, "#")) do
              local canEquipCareer = RoleUtility.GetBasicCareer(tonumber(v))
              if RoleUtility.GetBasicCareer(RoleManager.me.career) == canEquipCareer then
                if combTbl.costMainBuckets ~= nil then
                  mainBuckets[0] = tonumber(nowSelectTable.id)
                end
                ItemCombineController.ReqCombine(combTbl.id, mainBuckets, bonusBuckets, 1)
              end
            end
          end
        end
      end
    end
  end
end

function Tip_BagItemTipsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_BagItemTipsUI:RegistEvents()
  self:RegistEvent(Event.Tip_SelectChange, self.Refresh, self)
  self:RegistEvent(Event.Item_CombineRsp, self.OnItemCombineRsp, self)
end

function Tip_BagItemTipsUI:Refresh()
  local titleText = ClientTable.cfg_Ui_wordManager:TryGetValue("Wing_shengjishi1")
  if trtitleText ~= nil then
    self.lab_equipdemand:SetText(titleText.content or "")
  end
  self.itemData = BagInfoController:GetCurSelectItemInfo()
  if self.itemData == nil or self.itemData.tblItem == nil then
    return
  end
  self.haveWings = {}
  local canCompoundWingsStr = string.split(self.itemData.tblItem.compositestone, "&")
  self.canCompoundWingId = {}
  self.canCompoundComId = {}
  if canCompoundWingsStr == nil or next(canCompoundWingsStr) == nil then
    self.btn_3DItemTemp:SetData(nil)
    return
  end
  for k, v in pairs(canCompoundWingsStr) do
    local array = string.split(v, "#")
    self.canCompoundWingId[#self.canCompoundWingId + 1] = array[1]
    self.canCompoundComId[#self.canCompoundComId + 1] = array[2]
  end
  for k, v in pairs(BagInfoData.TotalItems) do
    if v ~= nil and v.tblItem.subType == 20 and table.contains(self.canCompoundWingId, tostring(v.itemId)) then
      table.insert(self.haveWings, v)
    end
  end
  self.btn_3DItemTemp:SetData(self.haveWings)
end

function Tip_BagItemTipsUI:OnItemCombineRsp(_, msg)
  if #msg.rewards > 0 then
    local combineMap = {}
    local showItems = {}
    for i = 1, msg.combineCount do
      combineMap[tostring(i)] = i
    end
    for i, v in pairs(combineMap) do
      if msg.rewards[v] then
        table.insert(showItems, msg.rewards[v])
      end
    end
    if 0 < table.count(showItems) then
      UIManager.Show(UIID.ObtainTipUI, {
        generalRewards = showItems,
        specialRewards = nil,
        isCombine = true
      })
    end
  end
  UIManager.Hide(UIID.BagItemTipsUI)
end

function Tip_BagItemTipsUI:OnHide()
  BagInfoController:SetCurSelectWingInfo(nil)
  self.itemData = nil
  self.canCompoundWingId = {}
  self.canCompoundComId = {}
  for _, v in pairs(self.CellTbl) do
    if v.loadModel then
      CS.UnityEngine.GameObject.Destroy(v.loadModel)
      v.loadModel = nil
    end
  end
end

function Tip_BagItemTipsUI:OnDestroy()
end
