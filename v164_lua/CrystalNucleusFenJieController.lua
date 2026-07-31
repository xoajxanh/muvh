require("GameModel/CrystalNucleus/CrystalNucleusFenJieData")
CrystalNucleusFenJieController = {}
local this = CrystalNucleusFenJieController

function CrystalNucleusFenJieController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function CrystalNucleusFenJieController.RegistEvent()
end

function CrystalNucleusFenJieController.OnResCrystalNucleusFenJieChange(_id, _msg)
end

function CrystalNucleusFenJieController.GetFenJieList()
  return CrystalNucleusFenJieData.FenJieList
end

function CrystalNucleusFenJieController.SetFenJieList(dataTbl)
  CrystalNucleusFenJieData.FenJieList = dataTbl
end

function CrystalNucleusFenJieController.RemoveFenJieItem(itemData)
  if itemData == nil then
    return
  end
  for i, v in ipairs(CrystalNucleusFenJieData.FenJieList) do
    if v == itemData then
      table.remove(CrystalNucleusFenJieData.FenJieList, i)
      break
    end
  end
  EventManager.Dispatch(Event.CrystalNucleusDecomposeRemoveItem, itemData)
end

function CrystalNucleusFenJieController.AddFenJieItem(itemData)
  if itemData == nil then
    return
  end
  table.insert(CrystalNucleusFenJieData.FenJieList, itemData)
  EventManager.Dispatch(Event.CrystalNucleusDecomposeAddItem, itemData)
end
