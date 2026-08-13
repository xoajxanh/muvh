local SingleUnionTemplate = {}

function SingleUnionTemplate:Init()
  self:InitComponent()
  self:BindOnClick()
end

function SingleUnionTemplate:InitComponent()
  self.lab_name_u = self:GetControl("lab_name_u")
  self.Btn_del = self:GetControl("Btn_del")
end

function SingleUnionTemplate:BindOnClick()
  self.Btn_del:SetOnClick(self, self.Btn_delOnClick)
end

function SingleUnionTemplate:Btn_delOnClick()
  if self.data ~= nil and self.data.unionId ~= nil then
    networkRequest.ReqKickUnionKuaFuMember(self.data.unionId)
  end
end

function SingleUnionTemplate:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.lab_name_u:SetText(data.unionName)
  self.Btn_del:SetActive(gameMgr:GetCoalitionManager():CheckMainPlayerIsLookLeader() and not gameMgr:GetAvatarManager():GetMainPlayer():GetWarAllianceData():IsMeUnion(data.unionId) and self.data.isCanKickPlayer == true)
end

return SingleUnionTemplate
