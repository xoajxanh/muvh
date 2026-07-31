CampData = {}

function CampData.RefreshMyCampData(data)
  CampData.mMyCampData = data
  CampData.mMyCampData.configData = ClientTable.cfg_Camp_detailManager:TryGetValue(data.camp, "id")
end

function CampData.RefreshUICampData(data)
  CampData.mUICampData = data
end
