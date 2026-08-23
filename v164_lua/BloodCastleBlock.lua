BloodCastleBlock = class(BlockBuilding)
BloodCastleBlock.blockType = BlockTypeEnum.UnionFight

function BloodCastleBlock:ctor(data)
  BlockBuilding.ctor(self, data)
end

function BloodCastleBlock:Destroy()
  self:SetCellType(SceneTileType.Normal)
  BlockBuilding.Destroy(self)
end
