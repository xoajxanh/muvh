local Vip_MemberDailyMissionTemplat = {}

function Vip_MemberDailyMissionTemplat:GetMemberMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function Vip_MemberDailyMissionTemplat:Init(data)
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function Vip_MemberDailyMissionTemplat:InitParams()
  self.parentTbl = nil
  self.way = nil
end

function Vip_MemberDailyMissionTemplat:InitControls()
  self.lab_task = self:GetControl("lab_task")
  self.lab_memberExp = self:GetControl("lab_memberExp")
  self.lab_finish = self:GetControl("lab_finish")
  self.lab_unfinish = self:GetControl("lab_unfinish")
  self.btn_go = self:GetControl("btn_go")
end

function Vip_MemberDailyMissionTemplat:BindUIEvent()
  self.btn_go:SetOnClick(self, self.BtnGoClickCalBack)
end

function Vip_MemberDailyMissionTemplat:BtnGoClickCalBack()
  self:DoFor()
end

function Vip_MemberDailyMissionTemplat:Refresh(data, ui)
  self.taskData = data
  self.parentTbl = ui
  self.way = self.taskData ~= nil and table.count(self.taskData.allWay) > 0 and self.taskData.allWay[1] or nil
  self:RefreshView()
end

function Vip_MemberDailyMissionTemplat:RefreshView()
  if self.taskData == nil then
    return
  end
  self.lab_task:SetText(self.taskData.taskStr)
  local curNum = self.taskData.curNum * self.taskData.vipExp
  local targetNum = self.taskData.targetNum * self.taskData.vipExp
  self.lab_memberExp:SetText("EXP VIP: " .. curNum .. " / " .. targetNum)
  self.lab_unfinish:SetActive(false)
  self.lab_finish:SetActive(curNum == targetNum)
  self.btn_go:SetActive(true)
end

function Vip_MemberDailyMissionTemplat:DoFor()
  if self:GetMemberMgr() == nil then
    return
  end
  if self.way == nil then
    return
  end
  if self.way.type == EMemberTaskJumpType.FindMonster and self.way.main ~= nil then
    local taskGoal = self:GetMemberMgr():GetMemberTaskGoalTempByTaskId(tonumber(self.way.main))
    if taskGoal then
      local mul, groundId, pos, transferId = taskGoal:GetPosition()
      PathFinderManager.JumpMapToMoveToPos(groundId, PathFinderManager.GetCalcPosData(pos), transferId, nil, nil, nil, function()
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      end)
      UIManager.Hide(UIID.Vip_MemberUI)
    end
  elseif self.way.type == EMemberTaskJumpType.FindNpc and self.way.main ~= nil then
    PathFinderManager.JumpMapMoveToNpc({
      npcId = tonumber(self.way.main)
    }, nil, Purpose.ClickNpc)
    UIManager.Hide(UIID.Vip_MemberUI)
  elseif self.way.type == EMemberTaskJumpType.Navigation then
    local navTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(tonumber(self.way.main))
    if navTbl ~= nil and GradData.GoToNavi(navTbl) then
      NavigationUtility.OpenPanel(navTbl)
    end
  end
  UIManager.Hide(UIID.Vip_NewMemberTaskUI)
  UIManager.Hide(UIID.Vip_NewMemberMainUI)
end

return Vip_MemberDailyMissionTemplat
