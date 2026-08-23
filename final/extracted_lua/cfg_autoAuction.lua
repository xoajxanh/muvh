local cfg_autoAuction = {
  {
    id = 1,
    type = 1000030,
    cell = "2#3",
    number = "2#3",
    price = "40#45",
    itemWeight = "1000020#100"
  },
  {
    id = 2,
    type = 1000030,
    cell = "3#5",
    number = "3#5",
    price = "40#45",
    itemWeight = "1000020#100",
    canRelease = "901#3&903#5"
  },
  {
    id = 3,
    type = 1000030,
    cell = "6#8",
    number = "5#5",
    price = "30#45",
    itemWeight = "1000020#100",
    canRelease = "901#6&903#10"
  },
  {
    id = 4,
    number = "10#10",
    price = "1200#1200",
    itemWeight = "6000090#100"
  },
  {
    id = 5,
    price = "1100#1100",
    itemWeight = "6000090#100",
    canRelease = "901#3&903#5"
  },
  {
    id = 6,
    cell = "5#8",
    price = "1000#1000",
    itemWeight = "6000090#100",
    canRelease = "901#6&903#10"
  },
  {
    id = 7,
    number = "10#10",
    price = "1200#1200",
    itemWeight = "6000100#100"
  },
  {
    id = 8,
    price = "1100#1100",
    itemWeight = "6000100#100",
    canRelease = "901#3&903#5"
  },
  {
    id = 9,
    cell = "5#8",
    price = "1000#1000",
    itemWeight = "6000100#100",
    canRelease = "901#6&903#10"
  },
  {
    id = 10,
    cell = "2#3",
    number = "1#1",
    price = "30000#30000",
    itemWeight = "6000120#100"
  },
  {
    id = 11,
    cell = "2#8",
    number = "1#2",
    price = "28000#28000",
    itemWeight = "6000120#100",
    canRelease = "901#3&903#5"
  },
  {
    id = 12,
    cell = "5#8",
    number = "1#2",
    price = "25000#25000",
    itemWeight = "6000120#100",
    canRelease = "901#6&903#10"
  }
}
local defaults = {
  type = 1000020,
  cell = "5#5",
  number = "10#15",
  cd = 7200000,
  cutCd = 3600000,
  canRelease = "901#2&903#2"
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_autoAuction) do
  setmetatable(v, mt)
end
return cfg_autoAuction
