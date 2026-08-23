NpcInteraction = class(BaseUI)
NpcInteraction.layer = UILayer.Panel
NpcInteraction.orderInLayer = 0
NpcInteraction.hideType = UIHideType.Hide
NpcInteraction.hideFunc = UIHideFunc.MoveOutOfScreen
NpcInteraction.escClose = UIEscClose.DontClose

function NpcInteraction:InitControls()
  self.Interaction = self:GetControl("Interaction")
end

function NpcInteraction:OnPreLoad()
end

function NpcInteraction:Init()
  self.npc = {}
end

function NpcInteraction:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function NpcInteraction:InitUI()
  self:InitContent()
end

function NpcInteraction:OnShow()
  self:RegistEvents()
  self:Refresh()
end

local function InitInteractionItemControls(ctr)
end

local function ItemInteractionRefresh(ctr, _, npc, ui)
  ctr:SetOnClick(ui, function()
    ui:TouchNpc(npc)
  end)
end

function NpcInteraction:TouchNpc(npc)
  if RoleManager.me:IsStillState() then
    if npc.model and npc.model.modelObject then
      CS.Framework.MaterialChange.AttachOutLine(npc.model.modelObject, Color(0.5882, 1, 0.0157), 0.03, 3000, "FGQJ/Role/OutLine2")
    end
    RoleManager.me:SetTargetAvatar(npc)
    EventManager.Dispatch(Event.OpenNpcPanel, npc.data.config_Npc)
  end
end

function NpcInteraction:InitContent()
  self.interactionItemTemp = UIContainer(self.Interaction, self, InitInteractionItemControls, ItemInteractionRefresh)
end

function NpcInteraction:OnHide()
end

function NpcInteraction:OnDestroy()
end

function NpcInteraction:RegistUIEvents()
end

function NpcInteraction:OnClickInteraction()
end

function NpcInteraction:RegistEvents()
  self:RegistEvent(Event.OpenNpcInteractionPanel, self.OpenNpcInteractionPanel, self)
  self:RegistEvent(Event.CloseNpcInteractionPanel, self.CloseNpcInteractionPanel, self)
end

function NpcInteraction:OpenNpcInteractionPanel(_, npcList)
  self.interactionItemTemp:SetData(npcList)
end

function NpcInteraction:CloseNpcInteractionPanel(_, npcList)
  if npcList == nil then
    return
  end
  for k, v in pairs(npcList) do
    if not RoleManager.me then
      return
    end
    local MeTargetAvatar = RoleManager.me.TargetAvatar
    if MeTargetAvatar and MeTargetAvatar.RoleType == ERoleType.NPC and MeTargetAvatar.data.id == v.data.id then
      if v.model and v.model.modelObject then
        CS.Framework.MaterialChange.DisAttachOutLine(v.model.modelObject)
      end
      RoleManager.me:SetTargetAvatar(nil)
      EventManager.Dispatch(Event.CloseNpcPanel, v.data.config_Npc)
    end
  end
end

function NpcInteraction:Refresh()
end
