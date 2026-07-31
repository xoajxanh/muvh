UnionFightBlock = class(BlockBuilding)
UnionFightBlock.blockType = BlockTypeEnum.UnionFight

function UnionFightBlock:ctor(data)
  BlockBuilding.ctor(self, data)
end
