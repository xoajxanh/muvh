MapMonsterConfigInfo = {}
local this = MapMonsterConfigInfo

function MapMonsterConfigInfo.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.InitMonsterInfo()
  this.range = 8
end

function MapMonsterConfigInfo.OnRet()
  this.curMonsterSeekInfo = nil
end

function MapMonsterConfigInfo.InitPosIndex(position)
  if this.curMonsterSeekInfo ~= nil then
    local positionList = string.split(this.curMonsterSeekInfo.position, "#")
    this.posIndex = 1
    for k, v in pairs(positionList) do
      local monsterPosition = PathFinderManager.GetCalcPosData(v)
      if PathFinderManager.pathFinding.IsDetectionRangePoint(position, monsterPosition, this.range) then
        this.posIndex = k
        return
      end
    end
  end
end

function MapMonsterConfigInfo.SetPosIndex()
  if this.curMonsterSeekInfo ~= nil then
    this.posIndex = this.posIndex + 1
    local groupId = string.split(this.curMonsterSeekInfo.groupId, "#")
    if this.posIndex > table.count(groupId) or this.posIndex <= 0 then
      this.posIndex = 1
    end
  end
end

function MapMonsterConfigInfo.GetPosition()
  if this.curMonsterSeekInfo ~= nil then
    local groupId = string.split(this.curMonsterSeekInfo.groupId, "#")
    local position = string.split(this.curMonsterSeekInfo.position, "#")
    return tonumber(groupId[this.posIndex]), position[this.posIndex]
  end
end

function MapMonsterConfigInfo.GetCurMonsterSeekInfo()
  return this.curMonsterSeekInfo
end

function MapMonsterConfigInfo.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.OnRet)
end

function MapMonsterConfigInfo.RegistEvent()
end

function MapMonsterConfigInfo.InitMonsterInfo()
  this.mapIdInfo = {}
  local monsterInfo = ClientTable.cfg_Map_goldenMonsterSeekManager:GetDic()
  for k, v in pairs(monsterInfo) do
    if v ~= nil and v.map ~= nil then
      this.mapIdInfo[v.id] = {}
      this.mapIdInfo[v.id] = v
    end
  end
end

function MapMonsterConfigInfo.IsNeedFind()
  for k, v in pairs(this.mapIdInfo) do
    if v.map == SceneData.resName and TaskData.GetTaskById(tonumber(v.taskId)) and v.triggerType == 1 and not TranScriptData.InTranscript then
      this.curMonsterSeekInfo = v
      return true
    end
  end
  return false
end

function MapMonsterConfigInfo.NeedFind()
  if this.curMonsterSeekInfo ~= nil and TaskData.GetTaskById(tonumber(this.curMonsterSeekInfo.taskId)) and this.curMonsterSeekInfo.map == SceneData.resName and not TranScriptData.InTranscript then
    return true
  end
  for k, v in pairs(this.mapIdInfo) do
    if v.map == SceneData.resName and TaskData.GetTaskById(tonumber(v.taskId)) and v.triggerType == 2 and not TranScriptData.InTranscript then
      this.curMonsterSeekInfo = v
      return true
    end
  end
  return false
end

function MapMonsterConfigInfo.RemoveTime()
  if this.countDownTimer then
    Timer.Stop(this.countDownTimer)
    this.countDownTimer = nil
  end
end

MapMonsterConfigInfo.Init()
