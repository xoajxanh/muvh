Action_HitMove = class(Action_Base)
local this = Action_HitMove
this.moveMap = {}

function Action_HitMove:Init(caster, actionHitData, speed)
  self.base.Init(self, caster, actionHitData, speed)
  self.moveTarget = caster
  if self.moveTarget == nil then
    self:Break()
    return
  end
  self.moveHandlerPath = actionHitData.hitMoveHandler
  self.handlerModelName = "moveHandler_" .. self.moveTarget.id
  self.targetId = self.moveTarget.id
  self:LoadHandler(self.OnHandlerLoaded)
end

function Action_HitMove:OnStartProcess()
  self:BeginMove()
end

function Action_HitMove:BeginMove()
  local callBack = bind(self, self.OnMoveEnd)
  if self.moveHandler and self.moveTarget and not IsNil(self.moveTarget.transform) then
    local targetPos = Scene.GetPosByCell(self.moveTarget.serverCoord)
    self.moveHandler:BeginMove(self.moveTarget.transform, targetPos.x, targetPos.y, targetPos.z, 0, callBack)
  end
end

function Action_HitMove:LoadHandler(onLoaded)
  self.handlerModelGo = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_Skill, self.moveHandlerPath)
  if IsNil(self.handlerModelGo) then
    local callBack = bind(self, onLoaded)
    local handlerModel = CS.Framework.GameModel(self.handlerModelName, nil, callBack)
    self.handlerModelGo = handlerModel.gameObject
    handlerModel:LoadAsync(self.moveHandlerPath)
  else
    onLoaded(self)
  end
end

function Action_HitMove:OnHandlerLoaded(go, _)
  if not self.moveTarget or IsNil(self.moveTarget.transform) or IsNil(self.handlerModelGo) then
    self:Interrupted()
    return
  end
  self.moveHandler = self.handlerModelGo:GetComponentInChildren(typeof(CS.SkillHitMove))
  if not self.moveHandler then
    return
  end
  if self.actionStatus >= ESkillActionStatus.Processing and self.actionStatus < ESkillActionStatus.Interrupted then
    self:BeginMove()
  end
end

function Action_HitMove:OnMoveEnd()
  self:HandleMoveEnd()
  self:Finish()
end

function Action_HitMove:HandleMoveEnd(syncServerPos)
  if self.moveTarget and not IsNil(self.moveTarget.transform) then
    local pos = self.moveTarget.transform.position
    local curCell = Scene.GetCellByPos(pos)
    self.moveTarget:SetPosition(pos.x, pos.y, pos.z)
    self.moveTarget:SetCell(curCell.x, curCell.y)
    if curCell ~= self.moveTarget.serverCoord and syncServerPos then
      self.moveTarget:FlashTo(self.moveTarget.serverCoord.x, self.moveTarget.serverCoord.y)
    end
  end
end

function Action_HitMove:OnInterrupted()
  if self.moveHandler then
    self.moveHandler:StopMove(true)
  end
  if self.handlerModel then
    self.handlerModel:StopLoad()
  end
  self:HandleMoveEnd(true)
end

function Action_HitMove:OnDestroy()
  if self.handlerModelGo then
    PoolManagerTest.Recycle(ResourceTypeEnum.Effect_Skill, self.moveHandlerPath, self.handlerModelGo)
    self.handlerModelGo = nil
  end
  self:HandleMoveEnd()
end
