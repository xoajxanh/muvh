SceneClientUpdateView = {}
local this = SceneClientUpdateView

function SceneClientUpdateView.OnEnterGame()
  this.RegistEvents()
end

function SceneClientUpdateView.OnLeaveGame()
  this.UnregistEvents()
end

function SceneClientUpdateView.Update()
  if not RoleManager.me then
    return
  end
  this:UpdateNpcView()
end

function SceneClientUpdateView.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Scene_SceneLoaded, this.OnChangeMapSuccess, _, 1)
end

function SceneClientUpdateView.UnregistEvents()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
    this.eventContainer = nil
  end
end

function SceneClientUpdateView.OnChangeMapSuccess(_)
  this.ResetNpcInfo()
end

local ClientViewRange = 256

function SceneClientUpdateView.ResetNpcInfo()
  this.HideAllNpcs()
  this.activeNpcs = {}
  this.curMapNpcs = {}
  local cfg = ClientTable.cfg_Npc_npcManager:GetDic()
  for _, v in pairs(cfg) do
    if tonumber(v.groupId) == SceneData.groupId and tonumber(v.handleType) == NpcLoadType.ClientLoad then
      local coords = string.stringToNumberArray(v.position, "#")
      local npcConfig = {
        id = v.npcId,
        coord = Vector2Int(coords[1], coords[2]),
        config = v
      }
      this.curMapNpcs[v.npcId] = npcConfig
    end
  end
end

function SceneClientUpdateView.ShowNpc(npcId)
  if this.activeNpcs[npcId] then
    return
  end
  local dataa = {id = npcId, configId = npcId}
  local npcData = ViewData.AddNPC(dataa)
  this.activeNpcs[npcId] = npcData
end

function SceneClientUpdateView.HideNpc(npcId)
  if not this.activeNpcs[npcId] then
    return
  end
  ViewData.RemoveGameObject(npcId)
  this.activeNpcs[npcId] = nil
end

function SceneClientUpdateView.HideAllNpcs()
  if this.activeNpcs then
    for k, _ in pairs(this.activeNpcs) do
      ViewData.RemoveGameObject(k)
    end
  end
  this.activeNpcs = {}
end

function SceneClientUpdateView.UpdateNpcView()
  if this.curMapNpcs then
    for i, v in pairs(this.curMapNpcs) do
      if Vector2Int.DistancePow(RoleManager.me.cellPos, v.coord) <= ClientViewRange then
        this.ShowNpc(i)
      else
        this.HideNpc(i)
      end
    end
  end
end
