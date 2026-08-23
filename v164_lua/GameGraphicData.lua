GameGraphicModelType = {
  Player = 1,
  Pet = 2,
  Other = 3
}
GameGraphicLimitConfig = {
  [1] = {
    [1] = {MaxHigh = 0, MaxMid = 1},
    [2] = {MaxHigh = 1, MaxMid = 5},
    [3] = {MaxHigh = 5, MaxMid = 20}
  },
  [2] = {
    [1] = {MaxHigh = 0, MaxMid = 1},
    [2] = {MaxHigh = 1, MaxMid = 5},
    [3] = {MaxHigh = 5, MaxMid = 20}
  },
  [3] = {
    [1] = {MaxHigh = 0, MaxMid = 1},
    [2] = {MaxHigh = 1, MaxMid = 5},
    [3] = {MaxHigh = 5, MaxMid = 20}
  }
}
GameGraphicData = {}
local this = GameGraphicData

function GameGraphicData.Init()
  this.counts = {
    [1] = {
      [1] = 0,
      [2] = 0,
      [3] = 0
    },
    [2] = {
      [1] = 0,
      [2] = 0,
      [3] = 0
    },
    [3] = {
      [1] = 0,
      [2] = 0,
      [3] = 0
    }
  }
end

function GameGraphicData.GetQualityLevel(isMe, type)
  if GameSettingsData.performQuality == nil then
    return 3
  end
  local level = GameSettingsData.performQuality
  if isMe and level <= 2 then
    level = level + 1
    return level
  end
  local max = GameGraphicLimitConfig[type][level]
  if max ~= nil then
    local countData = this.counts[type]
    if countData[3] < max.MaxHigh then
      level = 3
    elseif countData[2] < max.MaxMid then
      level = 2
    else
      level = 1
    end
  end
  return level
end

function GameGraphicData.AddCount(type, level)
  this.counts[type][level] = this.counts[type][level] + 1
end

function GameGraphicData.SubCount(type, level)
  this.counts[type][level] = this.counts[type][level] - 1
end

GameGraphicData.Init()
