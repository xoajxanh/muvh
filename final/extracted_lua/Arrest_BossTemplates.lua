local Arrest_BossTemplates = {}

function Arrest_BossTemplates:Init()
  self:InitControls()
end

function Arrest_BossTemplates:InitControls()
  self.lab_bossName = self:GetControl("lab_bossName")
  self.btn_goKill = self:GetControl("btn_goKill")
  self.lab_goKill = self:GetControl("btn_goKill/lab_goKill")
  self.lab_killNum = self:GetControl("lab_killNum")
  self.Img_finish = self:GetControl("lab_killNum/Img_finish")
  self.monsterModel = self:GetControl("monsterModel")
  self.img_choose = self:GetControl("img_choose")
  self.monsterEff = UIEffectUtility.SetUIEffect("Eff_UI_annuikuang07", self.img_choose, true, Vector3(1.5, 1.25, 1), Vector3(0, 0, 0))
end

function Arrest_BossTemplates:Refresh(_templateData)
  self.templateData = _templateData
  local isKilled = self.templateData.GetCurFinishCount == self.templateData.GetCount
  local isChosen = self.templateData.curGoalTbl and tonumber(self.templateData.curGoalTbl.goalParam) == self.templateData.cfg_monster.id
  self.img_choose:SetActive(isChosen)
  self.lab_bossName:SetText(self.templateData.cfg_monster.name)
  local param = {
    curGoalTbl = self.templateData.curGoalTbl,
    isKilled = isKilled,
    goalTbl = self.templateData.goalTbl
  }
  self.btn_goKill:SetOnClickParam(self, self.btn_goKillOnClick, param)
  self.lab_goKill:SetText(isKilled and "\196\144\195\163 ti\195\170u di\225\187\135t " or "\196\144\225\186\191n di\225\187\135t")
  self.lab_killNum:SetText("")
  self.Img_finish:SetActive(isKilled)
  self.btn_goKill:SetActive(not isKilled)
end

function Arrest_BossTemplates:btn_goKillOnClick(control)
  if control.param.isKilled then
    FloatingTipUtility.QuickMsg("Boss \196\145\195\163 ti\195\170u di\225\187\135t ")
    return
  end
  UIManager.Hide(UIID.Arrest_BossUI)
  local cfg_goal = control.param.goalTbl
  local taskGoal = TaskGoal(cfg_goal.goalId)
  if taskGoal:GetTarget() == TaskTargetType.NpcTarget then
    PathFinderManager.JumpMapMoveToNpc({
      npcId = taskGoal:GetNpc()
    }, nil, Purpose.ClickNpc)
  end
  if taskGoal:GetTarget() == TaskTargetType.SingleMap or taskGoal:GetTarget() == TaskTargetType.MultiMap then
    local monsterId = taskGoal.monster[1].monsterTbl.id
    if monsterId then
      UIManager.Show(UIID.Instance_BossUI, {Monsterid = monsterId})
    end
  end
end

return Arrest_BossTemplates
