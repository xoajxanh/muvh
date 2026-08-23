NpcTaskTag = class()

function NpcTaskTag:ctor(npcData)
  self.npcData = npcData
  self.tagState = acceptTaskMove
  self.grayColor = Color.New(0.28627450980392155, 0.28627450980392155, 0.28627450980392155, 225)
  self.defaultPos = self.npcData.model:GetModelNode("taskTarget")
  self.CreateTaskTag = {
    [0] = function()
      self:CreateAcceptableModer()
    end,
    [1] = function()
      self:CreateAcceptModer()
    end,
    [2] = function()
      self:CreateCompletedModer()
    end
  }
  self.AcceptableModer = nil
  self.AcceptModer = nil
  self.CompletedModer = nil
  self:RefushNpcTaskTag()
end

function NpcTaskTag:RefushNpcTaskTag()
  local npcTask = TaskData.FindNpcTaskForNpcId(self.npcData.data.configID)
  self.defaultPos = self.npcData.model:GetModelNode("taskTarget")
  if self.defaultPos == nil then
    return
  end
  if self.npcData.data.config_Npc.specialNPC == SpaceCrackMapData.SpecialNPC or self.npcData.data.config_Npc.specialNPC == SpaceCrackMapData.TransferNPC then
    return
  end
  if TranScriptData.InTranscript and not TranScriptData.IsTranscriptSuccess then
    local create = self.CreateTaskTag[2]
    if create then
      create()
    end
    return
  end
  if npcTask == nil then
    if self.AcceptableModer then
      self.AcceptableModer.gameObject:SetActive(false)
    end
    if self.AcceptModer then
      self.AcceptModer.gameObject:SetActive(false)
    end
    if self.CompletedModer then
      self.CompletedModer.gameObject:SetActive(false)
    end
    return
  end
  local create = self.CreateTaskTag[npcTask:GetState()]
  if create then
    create()
  end
end

function NpcTaskTag:CreateAcceptableModer()
  if self.AcceptableModer ~= nil then
    self.AcceptableModer.gameObject:SetActive(true)
  else
    local acceptablemoder = self.npcData.transform:Find("acceptablemoder")
    if not acceptablemoder then
      self.AcceptableModer = CS.Framework.GameModel("acceptablemoder", self.defaultPos.transform or self.npcData.transform, function(go, name)
        self:OnLoadAcceptableModer(go, name)
      end)
      self.AcceptableModer.transform.localPosition = Vector3(0, 0, 0)
      self.AcceptableModer:LoadAsync("Model/Symbol/tanhao.prefab")
    else
      self.AcceptableModer = CS.Framework.GameModel(acceptablemoder.gameObject, function(go, name)
        self:OnLoadAcceptableModer(go, name)
      end)
    end
  end
  if self.AcceptModer then
    self.AcceptModer.gameObject:SetActive(false)
  end
  if self.CompletedModer then
    self.CompletedModer.gameObject:SetActive(false)
  end
end

function NpcTaskTag:CreateAcceptModer()
  if self.AcceptModer ~= nil then
    self.AcceptModer.gameObject:SetActive(true)
  else
    local acceptmoder = self.npcData.transform:Find("acceptmoder")
    if not acceptmoder then
      self.AcceptModer = CS.Framework.GameModel("acceptmoder", self.defaultPos.transform or self.npcData.transform, function(go, name)
        self:OnLoadAcceptModer(go, name)
      end)
      self.AcceptModer.transform.localPosition = Vector3(0, 0, 0)
      self.AcceptModer:LoadAsync("Model/Symbol/wenhao.prefab")
    else
      self.AcceptModer = CS.Framework.GameModel(acceptmoder.gameObject, function(go, name)
        self:OnLoadAcceptModer(go, name)
      end)
    end
  end
  if self.AcceptableModer then
    self.AcceptableModer.gameObject:SetActive(false)
  end
  if self.CompletedModer then
    self.CompletedModer.gameObject:SetActive(false)
  end
end

function NpcTaskTag:CreateCompletedModer()
  if self.CompletedModer ~= nil then
    self.CompletedModer.gameObject:SetActive(true)
  else
    local completedmoder = self.npcData.transform:Find("completedmoder")
    if not completedmoder then
      self.CompletedModer = CS.Framework.GameModel("completedmoder", self.defaultPos.transform or self.npcData.transform, function(go, name)
        self:OnLoadCompletedModer(go, name)
      end)
      self.CompletedModer.transform.localPosition = Vector3(0, 0, 0)
      self.CompletedModer:LoadAsync("Model/Symbol/wenhao.prefab")
    else
      self.CompletedModer = CS.Framework.GameModel(completedmoder.gameObject, function(go, name)
        self:OnLoadCompletedModer(go, name)
      end)
    end
  end
  if self.AcceptableModer then
    self.AcceptableModer.gameObject:SetActive(false)
  end
  if self.AcceptModer then
    self.AcceptModer.gameObject:SetActive(false)
  end
end

function NpcTaskTag:OnLoadAcceptableModer(go, name)
  if not self.AcceptableModer then
    return
  end
  if self.AcceptableModer then
  end
end

function NpcTaskTag:OnLoadAcceptModer(go, name)
  if not self.AcceptModer then
    return
  end
  if self.AcceptModer then
    local acceptModerMesh = self.AcceptModer.transform:GetChild(0):GetComponent(typeof(CS.UnityEngine.Renderer))
    if not acceptModerMesh then
      return
    end
    local material = acceptModerMesh.material
    local tintColor = material:GetColor("_TintColor")
    local color = material:GetColor("_FresnelColor")
    material:SetColor("_TintColor", Color(self.grayColor.r, self.grayColor.g, self.grayColor.b, tintColor.a))
    material:SetColor("_FresnelColor", Color(self.grayColor.r, self.grayColor.g, self.grayColor.b, color.a))
    local particle = self.AcceptModer.transform:GetChild(0):GetChild(0):GetComponent(typeof(CS.UnityEngine.ParticleSystem)).main
    local startColor = particle.startColor
    startColor.color = Color.New(self.grayColor.r, self.grayColor.g, self.grayColor.b, startColor.color.a)
    particle.startColor = startColor
  end
end

function NpcTaskTag:OnLoadCompletedModer(go, name)
  if not self.CompletedModer then
    return
  end
  if self.CompletedModer then
  end
end

function NpcTaskTag:Destroy()
  if self.AcceptableModer then
    self.AcceptableModer.gameObject:SetActive(false)
    self.AcceptableModer = nil
  end
  if self.AcceptModer then
    self.AcceptModer.gameObject:SetActive(false)
    self.AcceptModer = nil
  end
  if self.CompletedModer then
    self.CompletedModer.gameObject:SetActive(false)
    self.CompletedModer = nil
  end
end
