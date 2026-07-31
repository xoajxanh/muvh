local AnniversaryActivityNewCharacterTemplate = {}

local function ShowModelCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function ShowModelRefresh(ctr, _, data, ui)
  local id = tonumber(data)
  local itemData = ItemUtility.GenerateItemData(id)
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui.root, true)
end

function AnniversaryActivityNewCharacterTemplate:Init()
  self:InitControls()
  self:InitUI()
  self:ResgistUIEvents()
end

function AnniversaryActivityNewCharacterTemplate:InitControls()
  self.img_rewardbg = self:GetControl("img_rewardbg")
  self.newCharacterItem = self:GetControl("img_rewardbg/reward_grid/btn_3DItem")
  self.btn_newCharacterTask = self:GetControl("btn_task")
  self.newlevelactivity_bg = self:GetControl("newlevelactivity_bg")
  self.btn_return = self:GetControl("newlevelactivity_bg/btn_return")
  self.level_reward = self:GetControl("newlevelactivity_bg/frame/Scroll View/Viewport/Content/level_reward")
  self.redPointEff = self:GetControl("btn_task/img_redPoint/Eff_UI_liuguang_kuang")
end

function AnniversaryActivityNewCharacterTemplate:InitUI()
  self.newCharacterContainer = UIContainer(self.newCharacterItem, self, ShowModelCreate, ShowModelRefresh)
  self.taskContainer = UIUtility.BindUIContainerTemp(self.level_reward, LuaComponentTemplates.AnniversaryActivityNewCharacterTaskTemplate, self.root)
end

function AnniversaryActivityNewCharacterTemplate:ResgistUIEvents()
  self.btn_newCharacterTask:SetOnClick(self, self.btn_newCharacterTaskOnClick)
  self.btn_return:SetOnClick(self, self.btn_returnOnClick)
end

function AnniversaryActivityNewCharacterTemplate:btn_newCharacterTaskOnClick(control)
  self:ChangePanelState(true)
end

function AnniversaryActivityNewCharacterTemplate:btn_returnOnClick(control)
  self:ChangePanelState(false)
end

function AnniversaryActivityNewCharacterTemplate:ChangePanelState(state)
  if self.newlevelactivity_bg:GetActive() ~= state then
    self.newlevelactivity_bg:SetActive(state)
    self.img_rewardbg:SetActive(not state)
  end
end

function AnniversaryActivityNewCharacterTemplate:ShowPanel()
  self:ChangePanelState(false)
end

function AnniversaryActivityNewCharacterTemplate:Refresh(data, ui)
  self.root = ui
  local showData = AnniversaryActivity_NewCharacterData.GetGiftItemData()
  self.newCharacterContainer:SetData(showData)
  if AnniversaryActivity_NewCharacterData.canGet == false then
    self.btn_newCharacterTask:SetActive(false)
    return
  else
    self.btn_newCharacterTask:SetActive(true)
  end
  self.redPointEff:SetActive(AnniversaryActivity_NewCharacterData.CheckRedPoint())
  self.taskContainer:SetData(AnniversaryActivity_NewCharacterData.taskInfoTbl)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.AnniversaryActivity_chuangjue
  })
end

return AnniversaryActivityNewCharacterTemplate
