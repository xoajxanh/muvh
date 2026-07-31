HUDController = {}

function HUDController.OnEnterGame()
  CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:OnEnterGame()
end

function HUDController.OnLeaveGame()
  CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:OnLeaveGame()
end

function HUDController.RegisterTitle(tf, fOffsetY, bIsMain)
  CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:RegisterTitle(tf, fOffsetY, bIsMain)
end

function HUDController.GetTitle(nTitleID)
  CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:GetTitle(nTitleID)
end

function HUDController.ReleaseTitle(nTitleID)
  CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:ReleaseTitle(nTitleID)
end
