WarAllianceUtility = {}
local this = WarAllianceUtility
WarAllianceUtility.UnionBadgeTex2D = {}

function WarAllianceUtility.GetUnionBadgeTex2D(unionId)
  if this.UnionBadgeTex2D[unionId] then
    return this.UnionBadgeTex2D[unionId]
  end
  local logo = WarAllianceData.GetUnionLogoById(unionId)
  if not logo then
    return nil
  end
  local texture = Texture2D(8, 8)
  local index = 0
  for i = 1, 8 do
    for j = 1, 8 do
      index = index + 1
      local logoNum = ColorUtility.IntToColor(logo[index])
      texture:SetPixel(i - 1, j - 1, logoNum)
    end
  end
  texture:Apply()
  texture.filterMode = FilterMode.Point
  this.UnionBadgeTex2D[unionId] = texture
  return texture
end

function WarAllianceUtility.IsEnemyUnion(role)
  return TranScriptData.InTranscriptType ~= TranScriptType.BloodCastle and TranScriptData.InTranscriptType ~= TranScriptType.DemonPlaza and WarAllianceData.GetIsEnemyUnion(role.unionId)
end
