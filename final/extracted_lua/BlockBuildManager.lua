require("GameConst/BlockTypeEnum")
require("GamePlay/BlockBuilding/BlockBuilding")
require("GamePlay/BlockBuilding/UnionFightBlock")
require("GamePlay/BlockBuilding/BloodCastleBlock")
require("GamePlay/BlockBuilding/RedFortBlock")
BlockBuildManager = {}
local this = BlockBuildManager
local blockBuilds = {}

function BlockBuildManager.Init()
  this.InitBlockBuildRootGo()
end

function BlockBuildManager.InitBlockBuildRootGo()
  this.root = CS.UnityEngine.GameObject("BlockBuildManager").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
end

function BlockBuildManager.OnEnterGame()
  this.RegistEvents()
end

function BlockBuildManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyBlockBuilds()
end

function BlockBuildManager.RefreshUnionBlockBuilding()
  local unionFightBlock = this.GetBlockBuildingsByType(BlockTypeEnum.UnionFight).list
  for k, v in pairs(unionFightBlock) do
    if not Activity_LuoLanSiegeData.IsWinUnionAreMeUnion() then
      v:SetCellType(SceneTileType.Block)
    else
      v:SetCellType(SceneTileType.Normal)
    end
  end
end

function BlockBuildManager.CreateUnionBlock(blockData)
  if blockBuilds[blockData.id] then
    return
  end
  local blockBuilding = UnionFightBlock(blockData)
  if not Activity_LuoLanSiegeData.IsWinUnionAreMeUnion() then
    blockBuilding:SetCellType(SceneTileType.Block)
  else
    blockBuilding:SetCellType(SceneTileType.Normal)
  end
  blockBuilds[blockData.id] = blockBuilding
  return blockBuilds[blockData.id]
end

function BlockBuildManager.CreateBloodCastle(blockData)
  if blockBuilds[blockData.id] then
    return
  end
  local blockBuilding = BloodCastleBlock(blockData)
  blockBuilding:SetCellType(SceneTileType.Block)
  blockBuilds[blockData.id] = blockBuilding
  return blockBuilds[blockData.id]
end

function BlockBuildManager.CreateRedFortBlock(blockData)
  if blockBuilds[blockData.id] then
    return
  end
  local blockBuilding = RedFortBlock(blockData)
  blockBuilding:SetCellType(SceneTileType.Block)
  blockBuilds[blockData.id] = blockBuilding
  return blockBuilds[blockData.id]
end

function BlockBuildManager.DestroyBlockBuild(id)
  local blockBuilding = blockBuilds[id]
  blockBuilds[id] = nil
  if blockBuilding then
    blockBuilding:Destroy()
  end
end

function BlockBuildManager.DestroyBlockBuilds()
  for k, v in pairs(blockBuilds) do
    v:Destroy()
  end
  blockBuilds = {}
end

function BlockBuildManager.GetBlockBuildingById(blockBuildId)
  return blockBuilds[blockBuildId]
end

function BlockBuildManager.GetBlockBuildingsByType(blockBuildType)
  local targetGroup = List:New()
  for _, v in pairs(blockBuilds) do
    if v and v.blockType == blockBuildType then
      targetGroup:Add(v)
    end
  end
  return targetGroup
end

function BlockBuildManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Block_OnBlockBuildingEnterView, this.OnBlockBuildingEnterView)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnBlockBuildingLeaveView)
  this.eventContainer:Regist(Event.Block_OnRefreshBlockBuildingData, this.OnRefreshBlockBuildingData)
end

function BlockBuildManager.OnBlockBuildingEnterView(_, blockData)
  if blockData == nil then
    return
  end
  if blockData.blockType == BlockTypeEnum.UnionFight then
    this.CreateUnionBlock(blockData)
  elseif blockData.blockType == BlockTypeEnum.BloodCastle then
    this.CreateBloodCastle(blockData)
  elseif blockData.blockType == BlockTypeEnum.RedFort then
    this.CreateRedFortBlock(blockData)
  end
end

function BlockBuildManager.OnBlockBuildingLeaveView(_, blockData)
  if blockData == nil then
    return
  end
  this.DestroyBlockBuild(blockData.id)
end

function BlockBuildManager.OnRefreshBlockBuildingData(_, blockData)
  local blockBuilding = this.GetBlockBuildingById(blockData.id)
  if blockBuilding then
    blockBuilding:RefreshBlockBuildInfo(blockData)
  end
end

BlockBuildManager.Init()
