local Actibity_EveryDayGrid = {}

function Actibity_EveryDayGrid:Init()
  print("\229\136\157\229\167\139\229\140\150" .. self.go.name)
end

function Actibity_EveryDayGrid:OnEnable()
  print("\230\152\190\231\164\186" .. self.go.name)
end

function Actibity_EveryDayGrid:OnDisable()
  print("\233\154\144\232\151\143" .. self.go.name)
end

function Actibity_EveryDayGrid:Refresh(params)
  print("\229\164\150\233\131\168\232\176\131\231\148\168\228\184\187\229\138\168\229\136\183\230\150\176")
end

return Actibity_EveryDayGrid
