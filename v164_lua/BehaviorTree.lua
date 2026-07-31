BehaviorTree = class()

function BehaviorTree:ctor(root, owner)
  self.root = root
  self.root:SetOwner(owner)
end

function BehaviorTree:Update()
  self.root:Visit()
  self:HandleStatus()
  self.root:SaveStatus()
  self.root:Step()
end

function BehaviorTree:Reset()
  self.root:Reset()
end

function BehaviorTree:Stop()
  self.root:Stop()
end

function BehaviorTree:HandleStatus()
  if self.statusCallback and self.root.status == self.status then
    self.statusCallback()
  end
end

function BehaviorTree:SetStateCallback(callback, status)
  self.statusCallback = callback
  self.status = status
end

function BehaviorTree:Start()
  local function StartBehaviorTree()
    while true do
      self:Update()
      
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  self.loopBehavior = Coroutine.Start(StartBehaviorTree)
end

function BehaviorTree:Cancel()
  self:Reset()
  if self.loopBehavior then
    Coroutine.Stop(self.loopBehavior)
    self.loopBehavior = nil
  end
end

function BehaviorTree:IsUpdateIn()
  return self.loopBehavior and true or false
end
