Activity_Sport3V3Map = class(BaseUI)
Activity_Sport3V3Map.layer = UILayer.Panel
Activity_Sport3V3Map.orderInLayer = 0
Activity_Sport3V3Map.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Map.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_Sport3V3Map.escClose = UIEscClose.DontClose

function Activity_Sport3V3Map:InitControls()
  self.btn_rank = self:GetControl("btn_rank")
  self.EnemyList = self:GetControl("EnemyList")
  self.btn_surrender = self:GetControl("btn_surrender")
  self.btn_say = self:GetControl("btn_say")
  self.sayBg = self:GetControl("sayBg")
  self.mePoint = self:GetControl("btn_map/sp_mapMask/mePoint")
  self.sp_map = self:GetControl("btn_map/sp_mapMask/sp_map")
  self.bg = self:GetControl("btn_map/sp_mapMask/sp_map/bg")
  self.sp_player = self:GetControl("btn_map/sp_mapMask/sp_player")
end

local mapWidthScale, mapHeightScale
local mapScale = 1
local halfMapSpWidth, halfMapSpHeight
local rotateParam = 0.4

function Activity_Sport3V3Map:Init()
end

function Activity_Sport3V3Map:OnCreate()
  self:InitControls()
  self:InitUI()
  self:InitTemplate()
  self:RegistUIEvents()
end

function Activity_Sport3V3Map:InitUI()
end

function Activity_Sport3V3Map:InitTemplate()
  self.ScoreCompareTemplate = luaTemplateManager.GetNewTemplate(self.btn_rank, LuaComponentTemplates.ScoreCompareTemplate)
  self.EnemyListTemplate = luaTemplateManager.GetNewTemplate(self.EnemyList, LuaComponentTemplates.EnemyListTemplate)
  self.SurrenderTemplate = luaTemplateManager.GetNewTemplate(self.btn_surrender, LuaComponentTemplates.SurrenderTemplate)
  self.sayBgTempkate = luaTemplateManager.GetNewTemplate(self.sayBg, LuaComponentTemplates.SayCommandListTemplate)
  self.PlayerPointTemplate = UIUtility.BindUIContainerTemp(self.sp_player, LuaComponentTemplates.PlayerPointTemplate, self)
end

function Activity_Sport3V3Map:RegistUIEvents()
  self.btn_say:SetOnClick(self, self.OnClickBtn_say)
  self.btn_rank:SetOnClick(self, self.OnBtn_rank)
end

function Activity_Sport3V3Map:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Map:RegistEvents()
  self:RegistEvent(Event.ThreeVSThreeCampInfoChange, self.ThreeVSThreeCampInfoChangeOnChange, self)
  self:RegistEvent(Event.ThreeVSThreeSingleCampInfoChange, self.ThreeVSThreeSingleCampInfoChangeOnChange, self)
  self:RegistEvent(Event.ThreeVSThreeSinglePlayerInfoChange, self.ThreeVSThreeSinglePlayerInfoChangeOnChange, self)
  self:RegistEvent(Event.ThreeVSThreeScoreChange, self.ThreeVSThreeScoreChangeOnChangeOnChange, self)
  self:RegistEvent(Event.ThreeVSThreeEnemyEnterView, self.ThreeVSThreeEnemyEnterViewOnChange, self)
  self:RegistEvent(Event.ThreeVSThreeEnemyExitView, self.ThreeVSThreeEnemyExitViewOnChange, self)
  self:RegistEvent(Event.ThreeVSThreeSurrenderDataChange, self.ThreeVSThreeSurrenderDataChangeOnChange, self)
  self:RegistEvent(Event.ThreeVsThreeChooseTarget, self.ThreeVsThreeChooseTargetOnChange, self)
end

function Activity_Sport3V3Map:ThreeVSThreeCampInfoChangeOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self:RefreshScoreTemplate(msg)
  self:RefreshEnemyListTemplate(msg:GetSingleEnemyCampInfo())
end

function Activity_Sport3V3Map:ThreeVSThreeSingleCampInfoChangeOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  local isMainPlayerCamp = msg:IsContainMainPlayer()
  if isMainPlayerCamp then
    self.ScoreCompareTemplate:RefreshOurScore(msg.KillNum)
  else
    self.ScoreCompareTemplate:RefreshEnemyScore(msg.KillNum)
    self:RefreshEnemyListTemplate(msg)
  end
end

function Activity_Sport3V3Map:ThreeVSThreeSinglePlayerInfoChangeOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self:RefreshEnemy(msg)
end

function Activity_Sport3V3Map:ThreeVSThreeScoreChangeOnChangeOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  local isMainPlayerCamp = msg:IsContainMainPlayer()
  if isMainPlayerCamp then
    self.ScoreCompareTemplate:RefreshOurScore(msg.KillNum)
  else
    self.ScoreCompareTemplate:RefreshEnemyScore(msg.KillNum)
  end
end

function Activity_Sport3V3Map:ThreeVSThreeEnemyEnterViewOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self:RefreshEnemy(msg)
  self:RefreshAllPlayerPosition()
end

function Activity_Sport3V3Map:ThreeVSThreeEnemyExitViewOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self:RefreshEnemy(msg)
  self:RefreshAllPlayerPosition()
end

function Activity_Sport3V3Map:ThreeVSThreeSurrenderDataChangeOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self.SurrenderTemplate:Refresh(msg, self)
end

function Activity_Sport3V3Map:ThreeVsThreeChooseTargetOnChange(_, msg)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self.EnemyListTemplate:RefreshChoose()
end

function Activity_Sport3V3Map:Refresh()
  if self.args then
    if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
      return
    end
    self.SurrenderTemplate:SetPanelState(false)
    self:RefreshScoreTemplate(self.args)
    self:RefreshAllPlayerPosition()
    self:RefreshAllPlayerPoint()
  end
end

function Activity_Sport3V3Map:RefreshAllPlayerPosition()
  self:RefreshEnemyListTemplate(self.args:GetSingleEnemyCampInfo())
end

function Activity_Sport3V3Map:RefreshAllPlayerPoint()
  local exceptMePlayerCampInfoList = self.args:GetExceptMePlayerCampInfoList()
  if exceptMePlayerCampInfoList and table.count(exceptMePlayerCampInfoList) > 0 then
    self.PlayerPointTemplate:SetData(exceptMePlayerCampInfoList, self)
  end
end

function Activity_Sport3V3Map:RefreshScoreTemplate(data)
  self.ScoreCompareTemplate:Refresh({
    ourScore = data:GetMainPlayerCampInfo().KillNum,
    enemyScore = data:GetSingleEnemyCampInfo().KillNum,
    endTime = data:GetEndTime()
  })
end

function Activity_Sport3V3Map:RefreshEnemyListTemplate(data)
  self.EnemyListTemplate:Refresh(data, self)
end

function Activity_Sport3V3Map:RefreshEnemy(data)
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self.EnemyListTemplate:RefreshSinglePlayer(data)
end

local tempMePos = {}
local updatePos = Vector3.zero

function Activity_Sport3V3Map:Update()
  if self.EnemyListTemplate ~= nil then
    self.EnemyListTemplate:Update()
  end
  if self.SurrenderTemplate ~= nil then
    self.SurrenderTemplate:Update()
  end
  if UIManager.IsVisible("Main_MiniMapUI") then
    EventManager.Dispatch(Event.ThreeVSThree3V3BeginBgHide)
  end
  self:RefreshPlayerPosition()
end

function Activity_Sport3V3Map:RefreshPlayerPosition()
  if self.PlayerPointTemplate == nil then
    return
  end
  local playerPointTemplateItemList = self.PlayerPointTemplate.items
  if table.count(playerPointTemplateItemList) > 0 then
    for i, v in pairs(playerPointTemplateItemList) do
      if v.itemTemp and SceneData.mapId == 1095 then
        v.itemTemp:Update()
      end
    end
  end
end

function Activity_Sport3V3Map:OnHide()
  self.ScoreCompareTemplate:Destroy()
end

function Activity_Sport3V3Map:OnDestroy()
  self.ScoreCompareTemplate:Destroy()
  self.sayBgTempkate:Destroy()
end

function Activity_Sport3V3Map:OnClickBtn_say()
  local toOpen = not self.sayBg:GetActive()
  if toOpen then
    if self.sayBgTempkate.lastClickTime + self.sayBgTempkate.cdTime > Time.GetServerTime() then
      FloatingTipUtility.QuickMsg("Kho\225\186\163ng c\195\161ch gi\225\187\175a hai l\225\186\167n ph\195\161t ng\195\180n qu\195\161 ng\225\186\175n")
      return
    end
    self.sayBg:SetActive(true)
    self.sayBgTempkate:Refresh()
    return
  end
  self.sayBg:SetActive(false)
end

function Activity_Sport3V3Map:OnBtn_rank()
  UIManager.Show(UIID.Activity_Sport3V3Score)
end
