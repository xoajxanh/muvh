ShowHundredCampaignController = {}
local this = ShowHundredCampaignController

function ShowHundredCampaignController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function ShowHundredCampaignController.RegistEvent()
  this.messageContainer:Regist(FightMessage.ResPlayerUseSkill, this.ResUseSkillShowTips)
end

function ShowHundredCampaignController.ResUseSkillShowTips(_, msg)
  if ViewData.meData.id ~= msg.attackerId then
    return
  end
  if not this.monsterId then
    this.monsterId = {}
    local info = ClientTable.cfg_Commerce_globalManager:TryGetValue(325002).effect
    local monster = string.split(info, "#")
    for i, v in pairs(monster) do
      if not this.monsterId[tonumber(v)] then
        this.monsterId[tonumber(v)] = tonumber(v)
      end
    end
  end
  local CountData = RefreshData.GetRefreshByKey(10600001)
  if CountData and CountData.count >= CountData.total then
    ShowHundredCampaignController:ShowTips(msg)
    ShowHundredCampaignController:SaveData(msg)
  end
end

function ShowHundredCampaignController:SaveData(msg)
  local istargetMonsterId = this.monsterId[msg.monsterConfigId]
  if not istargetMonsterId then
    return
  end
  if not this.TipsTable then
    this.TipsTable = {}
  end
  if not this.TipsTable[ViewData.meData.id] then
    this.TipsTable[ViewData.meData.id] = {}
  end
  if not this.TipsTable[ViewData.meData.id][msg.targetId] then
    this.TipsTable[ViewData.meData.id][msg.targetId] = true
  end
end

function ShowHundredCampaignController:ShowTips(msg)
  local isShow = true
  if this.TipsTable and this.TipsTable[ViewData.meData.id] and this.TipsTable[ViewData.meData.id][msg.targetId] then
    isShow = false
  end
  local istargetMonsterId = this.monsterId[msg.monsterConfigId]
  if not istargetMonsterId then
    return
  end
  if isShow then
    local text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("CommerceTips_1")
    local oldtime = FloatingTipUtility.MSG_Time
    FloatingTipUtility.MSG_Time = 5
    FloatingTipUtility.QuickMsg(text)
    FloatingTipUtility.MSG_Time = oldtime
  end
end
