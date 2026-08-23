TransferCareerData = {}
local this = TransferCareerData
this.transferCareer = nil
this.transferCareerState = nil

function TransferCareerData.Init()
end

function TransferCareerData.SetTransferCareer(career)
  this.transferCareer = career
end

function TransferCareerData.GetTransferCareer()
  return this.transferCareer
end

function TransferCareerData.TransferState(msg)
  this.transferCareerState = msg.state
end
