require("GamePlay/Effect/EffectNew")
require("GamePlay/Effect/UnionFightEffect")
require("GamePlay/Effect/DAFireballEffect")
require("GamePlay/Effect/DragonFlyEffect")
require("GamePlay/Effect/LookEnemyCircleEffect")
require("GamePlay/Guide/GuideEffect")
Effect = class()
local this = Effect
this.root = CS.UnityEngine.GameObject("EffectManager").transform
CS.UnityEngine.Object.DontDestroyOnLoad(this.root)

function Effect:ctor(path, parent, pos, duration, onLoad)
  self.onLoad = onLoad
  self.duration = duration or 0
  self.model = CS.Framework.GameModel("Effect", parent or this.root, function(go)
    self:OnLoad(go)
  end)
  self.model.transform.localPosition = pos
  self.model:LoadAsync(path)
end

function Effect:OnLoad(go)
  if self.onLoad then
    self.onLoad(go)
  end
  if self.duration > 0 then
    Timer.Start(self.duration, self.Destroy, self)
  end
end

function Effect:Destroy()
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
end
