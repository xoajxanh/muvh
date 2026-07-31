ActivityUtility = {}
local this = ActivityUtility
local AllActivity = {
  [1001] = function()
    this.OpenWarAllianceBossActivity()
  end,
  [2002] = function()
    this.OpenMissionReward()
  end,
  [1003] = function()
    this.OpenWarAllianceSiegeActivity()
  end,
  [1004] = function()
    this.OpenBloodCastleActivity()
  end,
  [1005] = function()
    this.OpenRedHoodActivity()
  end,
  [1006] = function()
    this.OpenWolfSpiritFortressActivity()
  end,
  [1007] = function()
    this.OpenDevilSquareActivity()
  end,
  [1008] = function(other)
    this.OpenFireDragonStrikesActivity(other)
  end,
  [1009] = function(other)
    this.OpenGoldComeActivity(other)
  end,
  [1010] = function()
    this.OpenRefineTowActivity()
  end,
  [2001] = function()
    this.OpenUnionTerritory()
  end,
  [2002] = function()
    this.OpenUnionTask()
  end,
  [3001] = function()
    this.OpenOnHook()
  end,
  [4001] = function()
    this.OpenAllGodsWar()
  end,
  [4002] = function()
    this.OpenOnKalunte()
  end,
  [4005] = function()
    this.OpenOnKunShouBattle()
  end,
  [5001] = function()
    this.OpenOn3V3()
  end,
  [5002] = function()
    this.OpenDuoQiCross()
  end,
  [5003] = function()
    this.OpenSpaceCrackCross()
  end,
  [5004] = function()
    this.OpenDuoQiZhangBa()
  end,
  [5005] = function()
    this.OpenSiFangZhangBa()
  end
}

local function ShowActivity(activityId, other)
  AllActivity[activityId](other)
end

function ActivityUtility.OpenWarAllianceBossActivity()
  logPurple("boss Guild")
  UIManager.Show(UIID.WarAlliance_BossUI)
end

function ActivityUtility.OpenMissionReward()
  logPurple("Tr\225\187\145ng")
end

function ActivityUtility.OpenWarAllianceSiegeActivity()
  logPurple("C\195\180ng Th\195\160nh Chi\225\186\191n")
  NetManager.Send(ActivityMessage.ReqGetLuoLanXiaGuGongChengActivityWinUnion)
end

function ActivityUtility.OpenBloodCastleActivity()
  logPurple("Huy\225\186\191t L\195\162u")
  PathFinderManager.JumpMapMoveToNpc({npcId = 1003009}, nil, Purpose.ClickNpc)
end

function ActivityUtility.OpenRedHoodActivity()
  logPurple("Ph\195\161o \196\144\195\160i \196\144\225\187\143")
  PathFinderManager.JumpMapMoveToNpc({npcId = 1001023}, nil, Purpose.ClickNpc)
end

function ActivityUtility.OpenRefineTowActivity()
  logPurple("Th\195\161p Tinh Luy\225\187\135n")
  PathFinderManager.JumpMapMoveToNpc({npcId = 1001026}, nil, Purpose.ClickNpc)
end

function ActivityUtility.OpenWolfSpiritFortressActivity()
  logPurple("Ph\195\161o \196\144\195\160i H\225\187\147n S\195\179i")
  UIManager.Show(UIID.WarAlliance_Activity)
end

function ActivityUtility.OpenDevilSquareActivity()
  logPurple("Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183")
  PathFinderManager.JumpMapMoveToNpc({npcId = 1004006}, nil, Purpose.ClickNpc)
end

function ActivityUtility.OpenFireDragonStrikesActivity(otherid)
  logPurple("H\225\187\143a Long T\225\186\173p K\195\173ch")
  if UIManager.IsVisible(UIID.Activity_IndexUI) then
    local mapId
    if not otherid then
      local mapCount = #Activity_DragonAttackData.mapList
      local randomIndex = Mathf.Random(1, mapCount)
      mapId = Activity_DragonAttackData.mapList[randomIndex]
    else
      mapId = otherid
    end
    local transferIds = {
      [1001] = 310101001,
      [1003] = 310101002,
      [1004] = 310101003
    }
    local mapData = {
      mapId = transferIds[mapId],
      line = 1
    }
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  else
    NetManager.Send(RoleMessage.ReqActiveAndFind)
    UIManager.Show(UIID.Activity_IndexUI, {openPanel = "btn_active"})
  end
end

function ActivityUtility.OpenGoldComeActivity(otherid)
  logPurple("V\195\160ng r\198\161i t\225\187\171 tr\225\187\157i")
  NetManager.Send(RoleMessage.ReqActiveAndFind)
  UIManager.Show(UIID.Activity_IndexUI, {openPanel = "btn_active"})
end

function ActivityUtility.OpenUnionTerritory()
  logPurple("L\195\163nh \196\145\225\187\139a Guild")
  local mapData = {mapId = 103500101}
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

function ActivityUtility.OpenUnionTask()
  logPurple("Nhi\225\187\135m v\225\187\165 Guild")
  UIManager.Show(UIID.WarAlliance_Task)
end

function ActivityUtility.OpenOnHook()
  logPurple("Treo m\195\161y m\225\187\151i ng\195\160y")
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.OnHook)
end

function ActivityUtility.OpenAllGodsWar()
  logPurple("Ch\198\176 Th\225\186\167n Gi\195\161ng L\195\162m")
  UIManager.Show(UIID.CrossServer_IntoUI, {
    openPanel = "btn_activeList1"
  })
end

function ActivityUtility.OpenOnKalunte()
  logPurple("Ph\225\186\191 T\195\173ch Current")
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.Kalunte
  })
end

function ActivityUtility.OpenOnKunShouBattle()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.Kunshou
  })
end

function ActivityUtility.OpenOn3V3()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.ThreeVsThree
  })
end

function ActivityUtility.OpenDuoQiCross()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.DuoQiCross
  })
end

function ActivityUtility.OpenSpaceCrackCross()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.SpaceCrack
  })
end

function ActivityUtility.OpenDuoQiZhangBa()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.DuoQiZhengBa
  })
end

function ActivityUtility.OpenSiFangZhangBa()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.SiFangZhengBa
  })
end

function ActivityUtility.OpenZoomSecretRealmCross()
  local mapData = {mapId = 280000}
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

ActivityUtility = {ShowActivity = ShowActivity}
