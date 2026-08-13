RoleMoveActionMgr = {}
local this = RoleMoveActionMgr

function RoleMoveActionMgr.Init()
  this.runningActions = {}
  this.messageContainer = EventContainer(NetManager)
  this.messageContainer:Regist(FightMessage.ResPlayerUseSkill, this.ResPlayerUseSkill)
end

function RoleMoveActionMgr.AddAction(casterId, action)
  this.runningActions[casterId] = action
end

function RoleMoveActionMgr.GetMoveAction(casterId)
  return this.runningActions[casterId]
end

function RoleMoveActionMgr.RemoveAction(casterId)
  this.runningActions[casterId] = nil
end

function RoleMoveActionMgr.ResPlayerUseSkill(_, msg)
  local action = this.GetMoveAction(msg.attackerId)
  if action and action.actionStatus <= ESkillActionStatus.Processing then
    action:FixPlayerTargetCell(msg.attackerX, msg.attackerY)
  else
  end
end

Action_RoleMove = class(Action_Base)

function Action_RoleMove:Init(caster, actionData, speed, targetCell)
  self.base.Init(self, caster, actionData, speed)
  if self.caster then
    self.targetCell = targetCell:Clone()
    self.targetPos = Scene.GetPosByCell(targetCell)
    self.startPos = self.caster.pos:Clone()
    self.deltaPos = self.targetPos - self.startPos
  end
end

function Action_RoleMove:OnProcessing()
  if not self.caster or not self.targetPos then
    self.actionStatus = ESkillActionStatus.Finish
    return
  end
  self.processedRatio = self.processingTime / self.duration
  if self.processedRatio > 1 then
    self.processedRatio = 1
  end
  local curPos = self.startPos + self.deltaPos * self.processedRatio
  local cell = Scene.GetCellByPos(curPos)
  self.caster:SetCell(cell.x, cell.y)
  self.caster:SetPosition(curPos.x, curPos.y, curPos.z)
  self.actionStatus = ESkillActionStatus.Processing
end

function Action_RoleMove:OnFinish()
  if self.caster and self.caster.serverCoord ~= self.caster.cellPos then
    if CS.Framework.ResourceManager.editorMode then
      logError("[Action_RoleMove] K\225\186\191t th\195\186c k\225\187\185 n\196\131ng d\225\187\139ch chuy\225\187\131n, v\225\187\139 tr\195\173 client v\195\160 server kh\195\180ng \196\145\225\187\147ng b\225\187\153, \196\145\195\163 c\198\176\225\187\161ng ch\225\186\191 k\195\169o l\225\186\161i", "V\225\187\139 tr\195\173 mong \196\145\225\187\163i", self.targetCell, "V\225\187\139 tr\195\173 client", self.caster.cellPos, "V\225\187\139 tr\195\173 server", self.caster.serverCoord)
    end
    self.caster:SetCellAndPos(self.caster.serverCoord.x, self.caster.serverCoord.y)
  end
end

function Action_RoleMove:FixPlayerTargetCell(x, y)
  if self.targetCell then
    self.targetCell:Set(x, y)
    self.targetPos = Scene.GetPosByCell(self.targetCell)
    self.deltaPos = self.targetPos - self.startPos
  end
end
