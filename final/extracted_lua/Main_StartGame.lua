Main_StartGame = class(BaseUI)
Main_StartGame.layer = UILayer.Tooltip
Main_StartGame.orderInLayer = 24
Main_StartGame.hideType = UIHideType.Destroy
Main_StartGame.hideFunc = UIHideFunc.MoveOutOfScreen
Main_StartGame.escClose = UIEscClose.DontClose

function Main_StartGame:InitControls()
  self.img_bg = self:GetControl("img_bg")
  self.btn_startGame = self:GetControl("btn_startGame")
end

function Main_StartGame:OnPreLoad()
end

function Main_StartGame:Init()
end

function Main_StartGame:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_StartGame:InitUI()
  self.left = false
  self.position = self.btn_startGame.transform.localPosition
  self.time = Timer.StartLoopForever(1, function()
    self.btn_startGame.transform:DOLocalMove(self.left and Vector2(self.position.x - 10, self.position.y) or Vector2(self.position.x + 10, self.position.y), 1)
    self.left = not self.left
  end)
end

function Main_StartGame:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_StartGame:RemoveTime()
  if self.time then
    Timer.Stop(self.time)
    self.time = nil
  end
end

function Main_StartGame:OnHide()
  self:RemoveTime()
end

function Main_StartGame:OnDestroy()
  self:RemoveTime()
end

function Main_StartGame:RegistUIEvents()
  self.btn_startGame:SetOnClick(self, self.btn_startGameOnClick)
  self.img_bg:SetOnClick(self, self.btn_startGameOnClick)
end

function Main_StartGame:btn_startGameOnClick(control)
  AutoTaskManage.ImmediatelyAutoTask()
  UIManager.Hide(self.name)
end

function Main_StartGame:RegistEvents()
end

function Main_StartGame:Refresh()
end
