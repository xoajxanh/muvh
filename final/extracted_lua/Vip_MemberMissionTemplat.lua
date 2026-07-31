local Vip_MemberMissionTemplat = {}

function Vip_MemberMissionTemplat:GetMemberMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function Vip_MemberMissionTemplat:Init(data)
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function Vip_MemberMissionTemplat:InitParams()
  self.parentTbl = nil
  self.way = nil
end

function Vip_MemberMissionTemplat:InitControls()
  self.lab_mission = self:GetControl("lab_mission")
  self.lab_unfinish = self:GetControl("lab_unfinish")
  self.lab_finish = self:GetControl("lab_finish")
  self.btn_go = self:GetControl("btn_go")
end

function Vip_MemberMissionTemplat:BindUIEvent()
  self.btn_go:SetOnClick(self, self.BtnGoClickCalBack)
end

function Vip_MemberMissionTemplat:BtnGoClickCalBack()
  self:DoFor()
end

function Vip_MemberMissionTemplat:Refresh(data, ui)
  self.taskData = data
  self.parentTbl = ui
  self.way = self.taskData ~= nil and table.count(self.taskData.allWay) > 0 and self.taskData.allWay[1] or nil
  self:RefreshView()
end

function Vip_MemberMissionTemplat:RefreshView()
  if self.taskData == nil then
    return
  end
  local paramStr = ""
  if self.taskData.state == EMemberTaskState.unfinsh then
    paramStr = string.GetColorText(self.taskData.curNum, ItemQuality2ColorDic[27])
    paramStr = paramStr .. "/"
  elseif self.parentTbl ~= nil and self.parentTbl.dailyRewardState == EMemberRewardState.NotGet then
    paramStr = string.GetColorText(self.taskData.curNum, ItemQuality2ColorDic[5])
    paramStr = paramStr .. "/"
  end
  self.lab_mission:SetText(string.format(self.taskData.taskStr, paramStr))
  self.lab_unfinish:SetActive(false)
  self.lab_finish:SetActive(self.taskData.state == EMemberTaskState.finish)
  self.btn_go:SetActive(self.taskData.state == EMemberTaskState.unfinsh and (self.way == nil or self.way.type ~= 0))
end

function Vip_MemberMissionTemplat:DoFor()
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
end

return Vip_MemberMissionTemplat
