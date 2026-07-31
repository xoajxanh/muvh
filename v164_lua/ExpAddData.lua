ExpAddData = {}
local this = ExpAddData
ExpAddData.AddExpNum = 0
ExpAddData.AddHurtNum = 0
ExpAddData.AddAllExpNum = 0
ExpAddData.AddAllHurtNum = 0
ExpAddData.refreshTime = 7
ExpAddData.refreshHurtTime = 3
ExpAddData.refreshUITime = 7
ExpAddData.NoreFreshCount = 2
ExpAddData.IsMultiple = false
ExpAddData.ExpThree = 200
ExpAddData.IsEfficient = false
ExpAddData.ExpEfficient = 100
ExpAddData.WorldExp = 0
ExpAddData.MultipleTime = 0
ExpAddData.MultipleTimeStamp = 0
ExpAddData.EfficientTime = 0
ExpAddData.ExpconditionTime = {}
ExpAddData.HolidayExp = 0
ExpAddData.MonsterConfigId = 0

function ExpAddData.Init()
  local Three = ClientTable.cfg_Unit_unitManager:TryGetValue(100101, "id").param
  ExpAddData.ExpThree = math.floor(Three.attribute.experienceRate / 100)
  local Efficient = ClientTable.cfg_Unit_unitManager:TryGetValue(100601, "id").param
  ExpAddData.ExpEfficient = math.floor(Efficient.attribute.experienceRate / 100)
end

function ExpAddData.AddExp(Exp)
  this.AddExpNum = this.AddExpNum + Exp
  this.AddAllExpNum = this.AddAllExpNum + Exp
end

function ExpAddData.AddHurt(hurtData)
  if not hurtData or hurtData.attackerId ~= RoleManager.me.id then
    return
  end
  this.isSecretBossCountKey()
  for k, v in pairs(hurtData.hurtList) do
    if v.MonsterConfigId ~= 0 then
      this.MonsterConfigId = v.monsterConfigId
    end
    this.AddHurtNum = this.AddHurtNum + v.showHurt
    this.AddAllHurtNum = this.AddAllHurtNum + v.showHurt
  end
end

function ExpAddData.isSecretBossCountKey()
  if TranScriptData.InTranscript and TranScriptData.InTranscriptType == TranScriptType.SecretBoss and TranScriptData.InTranscriptData.instanceType == 1106 then
    local levelRestrict = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.groupId, "id").enterCondition
    local countKey = levelRestrict[1][2][2][1]
    local count = RefreshData.GetInstanceCount(tonumber(countKey))
    if count <= 0 then
      FloatingTipUtility.QuickMsg("S\225\187\145 l\225\186\167n c\195\178n l\225\186\161i kh\195\180ng \196\145\225\187\167, kh\195\180ng th\225\187\131 g\195\162y s\195\161t th\198\176\198\161ng")
    end
  end
end

function ExpAddData.AddPetHurt(hurtData)
  if not hurtData then
    return
  end
  if hurtData.targetId ~= ViewData.meData.id then
    local targetData = RoleManager.GetRoleById(hurtData.attackerId)
    if targetData and targetData.master and targetData.master == ViewData.meData.id then
      for k, v in pairs(hurtData.hurtList) do
        this.AddHurtNum = this.AddHurtNum + v.showHurt
        this.AddAllHurtNum = this.AddAllHurtNum + v.showHurt
      end
    end
  end
end

function ExpAddData.ResetData()
  this.AddExpNum = 0
  this.AddHurtNum = 0
  this.HolidayExp = 0
end

ExpAddData.Init()
