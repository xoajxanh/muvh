require("GameModel/Role/PlayerData")
require("GameModel/Role/MonsterData")
require("GameModel/Role/NPCData")
require("GameModel/Role/DropItemData")
require("GameModel/BlockBuilding/BlockBuildingData")
require("GameModel/Trap/TrapData")
require("GameModel/Trans/TransData")
require("GameModel/Grave/GraveData")
ViewData = {
  meData
}
local this = ViewData
local gameObjectDataCollection = {}

function ViewData.AddMe(meData)
  this.meData = meData
  gameObjectDataCollection[meData.id] = meData
end

function ViewData.AddPlayer(playerMsg)
  if gameObjectDataCollection[playerMsg.info.roleId] then
    return
  end
  local roleData = PlayerData()
  roleData:Init(playerMsg)
  gameObjectDataCollection[roleData.id] = roleData
  EventManager.Dispatch(Event.Role_OnRoleEnterView, roleData)
  return roleData
end

function ViewData.AddPlayerShop(RoundAuction)
  if gameObjectDataCollection[RoundAuction.id] then
    return
  end
  local shopPlayerData = {}
  local equipData = RoleEquipData(RoundAuction.equips)
  shopPlayerData.equipsData = equipData
  shopPlayerData.career = RoundAuction.career
  shopPlayerData.modelType = EModelType.Charactor
  shopPlayerData.model = 1003
  shopPlayerData.position = RoundAuction.position
  shopPlayerData.id = RoundAuction.id
  shopPlayerData.roleId = RoundAuction.roleId
  shopPlayerData.unionName = "Ti\225\187\135m"
  shopPlayerData.name = RoundAuction.name
  shopPlayerData.title = RoundAuction.title
  shopPlayerData.serverCoord = Vector2Int(RoundAuction.x, RoundAuction.y)
  shopPlayerData.roleType = ERoleType.Shop
  shopPlayerData.titleData = RoleTitleData(RoundAuction.equips)
  
  function shopPlayerData:Destroy()
    if self.equipsData then
      self.equipsData:Destroy()
    end
  end
  
  gameObjectDataCollection[RoundAuction.id] = shopPlayerData
  EventManager.Dispatch(Event.Role_OnAuctionEnterView, shopPlayerData)
end

function ViewData.AddMonster(monsterMsg)
  if gameObjectDataCollection[monsterMsg.id] then
    return
  end
  if monsterMsg.hp <= 0 then
    return
  end
  local roleData = MonsterData(monsterMsg)
  roleData:Init(monsterMsg)
  gameObjectDataCollection[roleData.id] = roleData
  EventManager.Dispatch(Event.Role_OnRoleEnterView, roleData)
  return roleData
end

function ViewData.AddNPC(npcMsg)
  if gameObjectDataCollection[npcMsg.id] then
    return
  end
  local roleData = NpcData(npcMsg)
  roleData:Init(npcMsg)
  gameObjectDataCollection[roleData.id] = roleData
  EventManager.Dispatch(Event.Role_OnRoleEnterView, roleData)
  return roleData
end

function ViewData.AddItem(itemMsg, isMonsterDeath)
  if gameObjectDataCollection[itemMsg.item.id] then
    return
  end
  if itemMsg.wholeOwner ~= 0 and ViewData.meData and ViewData.meData.id ~= itemMsg.wholeOwner then
    return
  end
  local itemData = DropItemData(itemMsg)
  itemData:Init(itemMsg)
  itemData.isMonsterDeath = isMonsterDeath
  gameObjectDataCollection[itemData.id] = itemData
  EventManager.Dispatch(Event.DropItem_OnDropItemEnterView, itemData)
  return itemData
end

function ViewData.AddBlockBuilding(blockBuildingMsg)
  if gameObjectDataCollection[blockBuildingMsg.id] then
    return
  end
  local blockBuildingData = BlockBuildingData(blockBuildingMsg)
  blockBuildingData:Init(blockBuildingMsg)
  gameObjectDataCollection[blockBuildingData.id] = blockBuildingData
  EventManager.Dispatch(Event.Block_OnBlockBuildingEnterView, blockBuildingData)
  return blockBuildingData
end

function ViewData.AddTrap(trapMsg)
  if gameObjectDataCollection[trapMsg.id] then
    return
  end
  local trapData = TrapData(trapMsg)
  trapData:Init(trapMsg)
  gameObjectDataCollection[trapData.id] = trapData
  EventManager.Dispatch(Event.Trap_OnTrapEnterView, trapData)
  return trapData
end

function ViewData.UpdateTrans(transMsg)
  if gameObjectDataCollection[transMsg.id] then
    return
  end
  local transData = TransData(transMsg)
  transData:Init(transMsg)
  gameObjectDataCollection[transData.id] = transData
  EventManager.Dispatch(Event.Trans_OnTransUpdate, transData)
  return transData
end

function ViewData.AddTrans(transMsg)
  if gameObjectDataCollection[transMsg.id] then
    return
  end
  local transData = TransData(transMsg)
  transData:Init(transMsg)
  gameObjectDataCollection[transData.id] = transData
  EventManager.Dispatch(Event.Trans_OnTransEnterView, transData)
  return transData
end

function ViewData.AddGrave(graveMsg)
  if gameObjectDataCollection[graveMsg.id] then
    return
  end
  local graveData = GraveData(graveMsg)
  graveData:Init(graveMsg)
  gameObjectDataCollection[graveData.id] = graveData
  EventManager.Dispatch(Event.Grave_OnGraveEnterView, graveData)
  return graveData
end

function ViewData.UpdateGrave(graveMsg)
  if gameObjectDataCollection[graveMsg.id] then
    return
  end
  local graveData = GraveData(graveMsg)
  graveData:Init(graveMsg)
  gameObjectDataCollection[graveData.id] = graveData
  EventManager.Dispatch(Event.Grave_OnGraveUpdate, graveData)
  return graveData
end

function ViewData.UpdateRole(roleMsg)
  local id = roleMsg.info and roleMsg.info.roleId or roleMsg.id
  if id == this.meData.id then
    return
  end
  if not gameObjectDataCollection[id] then
    return
  end
  local roleData = this.GetGameObjectInViewById(id)
  roleData:Refresh(roleMsg)
  return roleData
end

function ViewData.UpdateBlockBuilding(blockBuildingMsg)
  if not gameObjectDataCollection[blockBuildingMsg.id] then
    return
  end
  local blockBuildingData = this.GetGameObjectInViewById(blockBuildingMsg.id)
  blockBuildingData:Refresh(blockBuildingMsg)
  return blockBuildingData
end

function ViewData.RemoveGameObject(id)
  local gameObjectData = this.GetGameObjectInViewById(id)
  EventManager.Dispatch(Event.GameObject_OnGameObjectLeaveView, gameObjectData)
  EventManager.Dispatch(Event.Map_RemoveMon, id)
  if gameObjectData and gameObjectData.Destroy then
    gameObjectData:Destroy()
  end
  gameObjectDataCollection[id] = nil
  return gameObjectData
end

function ViewData.RemoveAllOtherGameObjects()
  for i, _ in pairs(gameObjectDataCollection) do
    if i ~= this.meData.id then
      gameObjectDataCollection[i] = nil
    end
  end
end

function ViewData.ChangeRoleServerPos(id, x, y)
  local roleData = this.GetGameObjectInViewById(id)
  if not roleData then
    return false
  end
  if roleData.SetServerPos ~= nil then
    roleData:SetServerPos(x, y)
  end
  return true
end

function ViewData.ChangeRoleServerDir(dirMsg)
  local roleData = this.GetGameObjectInViewById(dirMsg.lid)
  if roleData ~= nil then
    roleData:SetServerDir(dirMsg.dir)
  end
end

function ViewData.ChangeRoleHp(id, hp)
  local roleData = this.GetGameObjectInViewById(id)
  if roleData ~= nil then
    if roleData.id == this.meData.id then
      QuickFind.LuaMainPlayerViewAttrData().hp = hp
    end
    if roleData.SetHp ~= nil then
      roleData:SetHp(hp)
    end
  end
end

function ViewData.ChangeRoleMp(id, mp)
  local roleData = this.GetGameObjectInViewById(id)
  if roleData ~= nil then
    roleData:SetMp(mp)
  end
end

function ViewData.ChangeRoleShield(id, shield)
  local roleData = this.GetGameObjectInViewById(id)
  if roleData ~= nil then
    roleData:SetShield(shield)
  end
end

function ViewData.GetGameObjectInViewById(id)
  return gameObjectDataCollection[id]
end

function ViewData.GetGameObjectsInView()
  return gameObjectDataCollection
end

function ViewData.Clear()
  gameObjectDataCollection = {}
end
