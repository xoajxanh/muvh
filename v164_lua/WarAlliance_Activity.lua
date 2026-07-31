WarAlliance_Activity = class(BaseUI)
WarAlliance_Activity.layer = UILayer.Panel
WarAlliance_Activity.orderInLayer = 2
WarAlliance_Activity.hideType = UIHideType.Destroy
WarAlliance_Activity.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Activity.escClose = UIEscClose.DontClose

function WarAlliance_Activity:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.TwoTierCloseBtn = self:GetControl("img_bg/TwoTierCloseBtn")
  self.ActivityItem = self:GetControl("Scroll View/Viewport/Content/ActivityItem")
  self.img_open = self:GetControl("Scroll View/Viewport/Content/ActivityItem/img_open")
end

function WarAlliance_Activity:Init()
  self.UnionActiveMapID = 103500101
end

function WarAlliance_Activity:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Activity:InitUI()
  self:InitContent()
end

function WarAlliance_Activity:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Activity:OnHide()
end

function WarAlliance_Activity:OnDestroy()
end

function WarAlliance_Activity:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.TwoTierCloseBtn:SetOnClick(self, self.btn_closeBgOnClick)
end

function WarAlliance_Activity:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Activity)
end

function WarAlliance_Activity:RegistEvents()
  self:RegistEvent(Event.WarAlliance_Activity, self.WarAlliance_ActivityRank, self)
end

function WarAlliance_Activity:Refresh()
  self:WarAllianceActivityUI()
end

local function ActivityItemCreate(control)
  control.ActivityImg = UIControl(control.transform, "ActivityImg")
  control.ActivityText = UIControl(control.transform, "ActivityTitle")
  control.timeText = UIControl(control.transform, "bg/begin_time_tag/begin_time_text")
  control.requireText = UIControl(control.transform, "bg/require_tag/require_text")
  control.img_open = UIControl(control.transform, "img_open")
end

function WarAlliance_Activity:InitContent()
  self.ActivityItemTemp = UIContainer(self.ActivityItem, self, ActivityItemCreate)
end

function WarAlliance_Activity:WarAllianceActivityUI()
  local cfg = ClientTable.cfg_Activity_overviewManager:GetDic()
  local activeTbl = {}
  for k, v in pairs(cfg) do
    local activityIn = string.split(v.activityIn, "#")
    if activityIn[1] == "101" then
      v.sort = activityIn[2]
      table.insert(activeTbl, v)
    end
  end
  local condition = ClientTable.cfg_Function_functionManager:TryGetValue(2610019).condition
  local isOpen = ConditionManager.Check4D(condition)
  local index = -1
  if isOpen == false then
    for i, v in ipairs(activeTbl) do
      if v.activityId == 5003 then
        index = i
        break
      end
    end
    if index ~= -1 then
      table.remove(activeTbl, index)
    end
  end
  table.sort(activeTbl, function(a, b)
    return a.sort < b.sort
  end)
  for k, v in ipairs(activeTbl) do
    local obj = self.ActivityItemTemp:GetOrCreateItem(v.sort)
    local openTimeText = ""
    if ConditionManager.Check4D(v.condition) then
      obj.img_open:SetActive(true)
      openTimeText = string.GetColorText(v.showTime, ItemQuality2ColorDic[5])
    else
      obj.img_open:SetActive(false)
      openTimeText = string.GetColorText(v.showTime, ItemQuality2ColorDic[7])
    end
    obj.ActivityText:SetText(v.activityName)
    obj.timeText:SetText(openTimeText)
    obj.requireText:SetText(v.showLevel)
    self.cor = Coroutine.Start(function()
      local name = string.format("Texture/%s.png", v.showPic)
      local request = self:LoadAssetAsync(name, typeof(CS.UnityEngine.Texture2D))
      Coroutine.Yield(request)
      if request.isError then
        Coroutine.Break()
      end
      obj.ActivityImg:SetTexture(request.res)
      self.cor = nil
    end)
    obj.ActivityImg:SetOnClick(self, function()
      WarAllianceData.TryEnterActivity(v.activityId, self, function()
        self:WarAllianceActivityItemOnClick(obj, tonumber(v.activityId))
      end)
    end)
  end
end

local AllActivity = {
  [1001] = function()
    WarAlliance_Activity:OpenWarAllianceBossActivity()
  end,
  [2002] = function()
    WarAlliance_Activity:OpenMissionReward()
  end,
  [1003] = function()
    WarAlliance_Activity:OpenWarAllianceSiegeActivity()
  end,
  [1004] = function()
    WarAlliance_Activity:OpenBloodCastleActivity()
  end,
  [1005] = function()
    WarAlliance_Activity:OpenRedHoodActivity()
  end,
  [1006] = function()
    WarAlliance_Activity:OpenWolfSpiritFortressActivity()
  end,
  [1007] = function()
    WarAlliance_Activity:OpenDevilSquareActivity()
  end,
  [1008] = function()
    WarAlliance_Activity:OpenFireDragonStrikesActivity()
  end,
  [2001] = function()
    WarAlliance_Activity:OpenUnionTerritory()
  end,
  [5002] = function()
    WarAlliance_Activity:OpenUnionDuoQi()
  end,
  [5003] = function()
    WarAlliance_Activity:OpenSpaceCrack()
  end
}

function WarAlliance_Activity:WarAllianceActivityItemOnClick(obj, activityId)
  local openActivity = AllActivity[activityId]
  if openActivity then
    openActivity()
  end
end

function WarAlliance_Activity:OpenWarAllianceBossActivity()
  UIManager.Show(UIID.WarAlliance_BossUI)
  self.btn_closeBgOnClick()
end

function WarAlliance_Activity:OpenMissionReward()
  UIManager.Show(UIID.WarAlliance_Task)
  self.btn_closeBgOnClick()
end

function WarAlliance_Activity:OpenWarAllianceSiegeActivity()
  logPurple("M\225\187\159 s\225\187\177 ki\225\187\135n C\195\180ng Th\195\160nh Chi\225\186\191n")
  NetManager.Send(ActivityMessage.ReqGetLuoLanXiaGuGongChengActivityWinUnion)
end

function WarAlliance_Activity:OpenBloodCastleActivity()
  logPurple("M\225\187\159 s\225\187\177 ki\225\187\135n Huy\225\186\191t L\195\162u")
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

function WarAlliance_Activity:OpenRedHoodActivity()
  logPurple("M\225\187\159 s\225\187\177 ki\225\187\135n Ph\195\161o \196\144\195\160i \196\144\225\187\143")
end

function WarAlliance_Activity:OpenWolfSpiritFortressActivity()
  local mapData = {
    mapId = self.UnionActiveMapID
  }
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

function WarAlliance_Activity:OpenDevilSquareActivity()
  logPurple("M\225\187\159 s\225\187\177 ki\225\187\135n Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183")
end

function WarAlliance_Activity:OpenFireDragonStrikesActivity()
  logPurple("M\225\187\159 s\225\187\177 ki\225\187\135n H\225\187\143a Long T\225\186\173p K\195\173ch")
end

function WarAlliance_Activity:OpenUnionTerritory()
  local mapData = {
    mapId = self.UnionActiveMapID
  }
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

function WarAlliance_Activity:OpenUnionDuoQi()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.DuoQiCross
  })
end

function WarAlliance_Activity:OpenSpaceCrack()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.SpaceCrack
  })
end

local function sort(a, b)
  if a.hurt == b.hurt then
    return a.hurt > b.hurt
  else
    return a.hurt < b.hurt
  end
end

local hurtRank = {}

function WarAlliance_Activity:WarAlliance_ActivityRank(id, msg)
end
