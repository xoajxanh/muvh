Action_Audio = class(Action_Base)

function Action_Audio:Init(caster, actionData, speed)
  self.base.Init(self, caster, actionData, speed)
  local randomAudios = string.stringToNumberArray(actionData.randomAudios, "#")
  self.audioId = Mathf.RandomTableValue(randomAudios)
  self.stopOnFinish = actionData.stopOnFinish
end

function Action_Audio:OnStartProcess()
  self.audioObject = AudioManager.PlayMusicClipById(self.audioId)
end

function Action_Audio:OnFinish()
  self:Stop()
end

function Action_Audio:OnBreak()
  self:Stop()
end

function Action_Audio:Stop()
  if self.stopOnFinish and self.audioObject then
    AudioManager.Stop(self.audioObject)
  end
end
