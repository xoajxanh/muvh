RedFortBlock = class(BlockBuilding)
RedFortBlock.blockType = BlockTypeEnum.RedFort

function RedFortBlock:ctor(data)
  BlockBuilding.ctor(self, data)
end
