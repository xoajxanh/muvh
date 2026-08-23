MountUtility = {}
local this = MountUtility

function MountUtility.GetMainPlayerMountSkill()
  local mounts = RoleManager.me.data.mountData.Mounts
  if mounts == nil then
    return
  end
  local skillList = {}
  for i = 1, #mounts do
    if mounts[i].tblSkill then
      local skillInfo = {}
      skillInfo.skillName = mounts[i].tblSkill.name
      skillInfo.name = mounts[i].name
      table.insert(skillList, skillInfo)
    end
  end
  return skillList
end

function MountUtility.GetMainPlayerFightProperty()
  local mounts = RoleManager.me.data.mountData.Mounts
  if mounts == nil then
    return
  end
  local fight = 0
  for i = 1, #mounts do
    fight = fight + mounts[i].fight
  end
  return fight
end

function MountUtility.GetMainPlayerAllProperty()
  local mounts = RoleManager.me.data.mountData.Mounts
  if mounts == nil then
    return
  end
  local tblEquip = {}
  tblEquip.disable_minimumPhysBaseDmg = 0
  tblEquip.disable_maximumPhysBaseDmg = 0
  tblEquip.disable_defenseBase = 0
  tblEquip.disable_attackDistanceIncrease = 0
  tblEquip.minimumPhysBaseDmg = 0
  tblEquip.attackSpeed = 0
  tblEquip.defenseBase = 0
  tblEquip.defenseRatePvm_mul = 0
  tblEquip.attackDamageIncrease = 0
  tblEquip.damageReceiveDecrement = 0
  tblEquip.maximumHealth = 0
  tblEquip.iceResistance = 0
  tblEquip.fireResistance = 0
  tblEquip.waterResistance = 0
  tblEquip.earthResistance = 0
  tblEquip.windResistance = 0
  tblEquip.poisonResistance = 0
  tblEquip.lightningResistance = 0
  tblEquip.defenseIgnoreChanceResistance = 0
  tblEquip.shieldBypassChanceResistance = 0
  tblEquip.doubleDamageChanceResistance = 0
  tblEquip.excellentDamageChanceResistance = 0
  tblEquip.criticalDamageBonusResistance = 0
  tblEquip.attackDistanceIncrease = 0
  for i = 1, #mounts do
    tblEquip.disable_minimumPhysBaseDmg = tblEquip.disable_minimumPhysBaseDmg + mounts[i].tblEquip.disable_minimumPhysBaseDmg
    tblEquip.disable_maximumPhysBaseDmg = tblEquip.disable_maximumPhysBaseDmg + mounts[i].tblEquip.disable_maximumPhysBaseDmg
    tblEquip.disable_defenseBase = tblEquip.disable_defenseBase + mounts[i].tblEquip.disable_defenseBase
    tblEquip.disable_attackDistanceIncrease = tblEquip.disable_attackDistanceIncrease + mounts[i].tblEquip.disable_attackDistanceIncrease
    if mounts[i].valid then
      tblEquip.minimumPhysBaseDmg = tblEquip.minimumPhysBaseDmg + mounts[i].tblEquip.minimumPhysBaseDmg
      tblEquip.attackSpeed = tblEquip.attackSpeed + mounts[i].tblEquip.attackSpeed
      tblEquip.defenseBase = tblEquip.defenseBase + mounts[i].tblEquip.defenseBase
      tblEquip.defenseRatePvm_mul = tblEquip.defenseRatePvm_mul + mounts[i].tblEquip.defenseRatePvm_mul
      tblEquip.attackDamageIncrease = tblEquip.attackDamageIncrease + mounts[i].tblEquip.attackDamageIncrease
      tblEquip.damageReceiveDecrement = tblEquip.damageReceiveDecrement + mounts[i].tblEquip.damageReceiveDecrement
      tblEquip.maximumHealth = tblEquip.maximumHealth + mounts[i].tblEquip.maximumHealth
      tblEquip.iceResistance = tblEquip.iceResistance + mounts[i].tblEquip.iceResistance
      tblEquip.fireResistance = tblEquip.fireResistance + mounts[i].tblEquip.fireResistance
      tblEquip.waterResistance = tblEquip.waterResistance + mounts[i].tblEquip.waterResistance
      tblEquip.earthResistance = tblEquip.earthResistance + mounts[i].tblEquip.earthResistance
      tblEquip.windResistance = tblEquip.windResistance + mounts[i].tblEquip.windResistance
      tblEquip.poisonResistance = tblEquip.poisonResistance + mounts[i].tblEquip.poisonResistance
      tblEquip.lightningResistance = tblEquip.lightningResistance + mounts[i].tblEquip.lightningResistance
      tblEquip.defenseIgnoreChanceResistance = tblEquip.defenseIgnoreChanceResistance + mounts[i].tblEquip.defenseIgnoreChanceResistance
      tblEquip.shieldBypassChanceResistance = tblEquip.shieldBypassChanceResistance + mounts[i].tblEquip.shieldBypassChanceResistance
      tblEquip.doubleDamageChanceResistance = tblEquip.doubleDamageChanceResistance + mounts[i].tblEquip.doubleDamageChanceResistance
      tblEquip.excellentDamageChanceResistance = tblEquip.excellentDamageChanceResistance + mounts[i].tblEquip.excellentDamageChanceResistance
      tblEquip.criticalDamageBonusResistance = tblEquip.criticalDamageBonusResistance + mounts[i].tblEquip.criticalDamageBonusResistance
      tblEquip.attackDistanceIncrease = tblEquip.attackDistanceIncrease + mounts[i].tblEquip.attackDistanceIncrease
    end
  end
  return this.GetItemDesc(tblEquip, true)
end

function MountUtility.GetItemDesc(tblEquip, isValid)
  this.LocalInit()
  local arrtibuteTable = {}
  if tblEquip.disable_minimumPhysBaseDmg ~= 0 and tblEquip.disable_maximumPhysBaseDmg ~= 0 then
    local disable_strengthStr = string.format(this.gongjili, "", tblEquip.disable_minimumPhysBaseDmg, tblEquip.disable_maximumPhysBaseDmg)
    table.insert(arrtibuteTable, disable_strengthStr)
  end
  if tblEquip.disable_defenseBase ~= 0 then
    local disable_defenseBase = string.format(this.fangyuli, tblEquip.disable_defenseBase)
    table.insert(arrtibuteTable, disable_defenseBase)
  end
  if tblEquip.disable_attackDistanceIncrease ~= 0 then
    local disable_attackDistanceIncrease = string.format(this.tipsgongjijulizengjia, tblEquip.disable_attackDistanceIncrease)
    table.insert(arrtibuteTable, disable_attackDistanceIncrease)
  end
  if isValid then
    if tblEquip.minimumPhysBaseDmg ~= 0 and tblEquip.maximumPhysBaseDmg ~= 0 then
      local strengthStr = string.format(this.gongjili, "", tblEquip.minimumPhysBaseDmg, tblEquip.maximumPhysBaseDmg)
      table.insert(arrtibuteTable, strengthStr)
    end
    if tblEquip.attackSpeed ~= 0 then
      local attackSpeed = string.format(this.gongjisudu, tblEquip.attackSpeed)
      table.insert(arrtibuteTable, attackSpeed)
    end
    if tblEquip.defenseBase ~= 0 then
      local defenseBase = string.format(this.fangyuli, tblEquip.defenseBase)
      table.insert(arrtibuteTable, defenseBase)
    end
    if tblEquip.defenseRatePvm_mul ~= 0 then
      local defenseRatePvm_mul = string.format(this.fangyulv, tblEquip.defenseRatePvm_mul / 100, "%")
      table.insert(arrtibuteTable, defenseRatePvm_mul)
    end
    if tblEquip.attackDamageIncrease ~= 0 then
      local attackDamageIncrease = string.format(this.shanghaitisheng, tblEquip.attackDamageIncrease / 100, "%")
      table.insert(arrtibuteTable, attackDamageIncrease)
    end
    if tblEquip.damageReceiveDecrement ~= 0 then
      local damageReceiveDecrement = string.format(this.shanghaixuejian, tblEquip.damageReceiveDecrement / 100, "%")
      table.insert(arrtibuteTable, damageReceiveDecrement)
    end
    if tblEquip.maximumHealth ~= 0 then
      local maximumHealth = string.format(this.shengmingzuidazhizengjia, tblEquip.maximumHealth)
      table.insert(arrtibuteTable, maximumHealth)
    end
    if tblEquip.iceResistance ~= 0 then
      local iceResistance = string.format(this.bingdikangli, tblEquip.iceResistance / 100, "%")
      table.insert(arrtibuteTable, iceResistance)
    end
    if tblEquip.fireResistance ~= 0 then
      local fireResistance = string.format(this.huodikangli, tblEquip.fireResistance / 100, "%")
      table.insert(arrtibuteTable, fireResistance)
    end
    if tblEquip.waterResistance ~= 0 then
      local waterResistance = string.format(this.shuidikangli, tblEquip.waterResistance / 100, "%")
      table.insert(arrtibuteTable, waterResistance)
    end
    if tblEquip.earthResistance ~= 0 then
      local earthResistance = string.format(this.didikangli, tblEquip.earthResistance / 100, "%")
      table.insert(arrtibuteTable, earthResistance)
    end
    if tblEquip.windResistance ~= 0 then
      local windResistance = string.format(this.fengdikangli, tblEquip.windResistance / 100, "%")
      table.insert(arrtibuteTable, windResistance)
    end
    if tblEquip.poisonResistance ~= 0 then
      local poisonResistance = string.format(this.dudikangli, tblEquip.poisonResistance / 100, "%")
      table.insert(arrtibuteTable, poisonResistance)
    end
    if tblEquip.lightningResistance ~= 0 then
      local lightningResistance = string.format(this.leidikangli, tblEquip.lightningResistance / 100, "%")
      table.insert(arrtibuteTable, lightningResistance)
    end
    if tblEquip.defenseIgnoreChanceResistance ~= 0 then
      local defenseIgnoreChanceResistance = string.format(this.tipsdikangwushifangyujilv, tblEquip.defenseIgnoreChanceResistance / 100, "%")
      table.insert(arrtibuteTable, defenseIgnoreChanceResistance)
    end
    if tblEquip.shieldBypassChanceResistance ~= 0 then
      local shieldBypassChanceResistance = string.format(this.tipsdikangSDwushijilv, tblEquip.shieldBypassChanceResistance / 100, "%")
      table.insert(arrtibuteTable, shieldBypassChanceResistance)
    end
    if tblEquip.doubleDamageChanceResistance ~= 0 then
      local doubleDamageChanceResistance = string.format(this.tipsdikangshuangbeishanghaijilv, tblEquip.doubleDamageChanceResistance / 100, "%")
      table.insert(arrtibuteTable, doubleDamageChanceResistance)
    end
    if tblEquip.excellentDamageChanceResistance ~= 0 then
      local excellentDamageChanceResistance = string.format(this.tipsdikangzhuoyueyijijilv, tblEquip.excellentDamageChanceResistance / 100, "%")
      table.insert(arrtibuteTable, excellentDamageChanceResistance)
    end
    if tblEquip.criticalDamageBonusResistance ~= 0 then
      local criticalDamageBonusResistance = string.format(this.tipsdikangzhimingyijijilv, tblEquip.criticalDamageBonusResistance / 100, "%")
      table.insert(arrtibuteTable, criticalDamageBonusResistance)
    end
    if tblEquip.attackDistanceIncrease ~= 0 then
      local attackDistanceIncrease = string.format(this.tipsgongjijulizengjia, tblEquip.attackDistanceIncrease)
      table.insert(arrtibuteTable, attackDistanceIncrease)
    end
  end
  return arrtibuteTable
end

function MountUtility.LocalInit()
  if not this.zhiyebufuhe then
    this.zhiyebufuhe = LocalizationUtility.GetContentByKey("zhiyebufuhe")
  end
  if not this.dengjibufuhe then
    this.dengjibufuhe = LocalizationUtility.GetContentByKey("dengjibufuhe")
  end
  if not this.shuxingbufuhe then
    this.shuxingbufuhe = LocalizationUtility.GetContentByKey("shuxingbufuhe")
  end
  if not this.yizhuangbei then
    this.yizhuangbei = LocalizationUtility.GetContentByKey("yizhuangbei")
  end
  if not this.shuxingbufuhe then
    this.shuxingbufuhe = LocalizationUtility.GetContentByKey("shiyong")
  end
  if not this.zhuangbei then
    this.zhuangbei = LocalizationUtility.GetContentByKey("zhuangbei")
  end
  if not this.tuoxia then
    this.tuoxia = LocalizationUtility.GetContentByKey("tuoxia")
  end
  if not this.fangru then
    this.fangru = LocalizationUtility.GetContentByKey("fangru")
  end
  if not this.quchu then
    this.quchu = LocalizationUtility.GetContentByKey("quchu")
  end
  if not this.gengduo then
    this.gengduo = LocalizationUtility.GetContentByKey("gengduo")
  end
  if not this.diuqi then
    this.diuqi = LocalizationUtility.GetContentByKey("diuqi")
  end
  if not this.quxiao then
    this.quxiao = LocalizationUtility.GetContentByKey("quxiao")
  end
  if not this.gongjili then
    this.gongjili = LocalizationUtility.GetContentByKey("gongjili")
  end
  if not this.shaungshou then
    this.shaungshou = LocalizationUtility.GetContentByKey("shaungshou")
  end
  if this.danshou then
    this.danshou = LocalizationUtility.GetContentByKey("danshou")
  end
  if not this.gongjisudu then
    this.gongjisudu = LocalizationUtility.GetContentByKey("gongjisudu")
  end
  if not this.fangyuli then
    this.fangyuli = LocalizationUtility.GetContentByKey("fangyuli")
  end
  if not this.fangyulv then
    this.fangyulv = LocalizationUtility.GetContentByKey("fangyulv")
  end
  if not this.shanghaitisheng then
    this.shanghaitisheng = LocalizationUtility.GetContentByKey("shanghaitisheng")
  end
  if not this.shanghaixuejian then
    this.shanghaixuejian = LocalizationUtility.GetContentByKey("shanghaixuejian")
  end
  if not this.shengmingzuidazhizengjia then
    this.shengmingzuidazhizengjia = LocalizationUtility.GetContentByKey("shengmingzuidazhizengjia")
  end
  if not this.bingdikangli then
    this.bingdikangli = LocalizationUtility.GetContentByKey("bingdikangli")
  end
  if not this.huodikangli then
    this.huodikangli = LocalizationUtility.GetContentByKey("huodikangli")
  end
  if not this.shuidikangli then
    this.shuidikangli = LocalizationUtility.GetContentByKey("shuidikangli")
  end
  if not this.didikangli then
    this.didikangli = LocalizationUtility.GetContentByKey("didikangli")
  end
  if not this.fengdikangli then
    this.fengdikangli = LocalizationUtility.GetContentByKey("fengdikangli")
  end
  if not this.dudikangli then
    this.dudikangli = LocalizationUtility.GetContentByKey("dudikangli")
  end
  if not this.leidikangli then
    this.leidikangli = LocalizationUtility.GetContentByKey("leidikangli")
  end
  if not this.tipsdikangwushifangyujilv then
    this.tipsdikangwushifangyujilv = LocalizationUtility.GetContentByKey("tipsdikangwushifangyujilv")
  end
  if not this.tipsdikangSDwushijilv then
    this.tipsdikangSDwushijilv = LocalizationUtility.GetContentByKey("tipsdikangSDwushijilv")
  end
  if not this.tipsdikangshuangbeishanghaijilv then
    this.tipsdikangshuangbeishanghaijilv = LocalizationUtility.GetContentByKey("tipsdikangshuangbeishanghaijilv")
  end
  if not this.tipsdikangzhuoyueyijijilv then
    this.tipsdikangzhuoyueyijijilv = LocalizationUtility.GetContentByKey("tipsdikangzhuoyueyijijilv")
  end
  if not this.tipsdikangzhimingyijijilv then
    this.tipsdikangzhimingyijijilv = LocalizationUtility.GetContentByKey("tipsdikangzhimingyijijilv")
  end
  if not this.tipsgongjijulizengjia then
    this.tipsgongjijulizengjia = LocalizationUtility.GetContentByKey("tipsgongjijulizengjia")
  end
  if not this.mofagongjili then
    this.mofagongjili = LocalizationUtility.GetContentByKey("mofagongjili")
  end
  if not this.chongwugongjilitigao then
    this.chongwugongjilitigao = LocalizationUtility.GetContentByKey("chongwugongjilitigao")
  end
  if not this.suoxuliliang then
    this.suoxuliliang = LocalizationUtility.GetContentByKey("suoxuliliang")
  end
  if not this.haixu then
    this.haixu = LocalizationUtility.GetContentByKey("haixu")
  end
  if not this.suoxuminjie then
    this.suoxuminjie = LocalizationUtility.GetContentByKey("suoxuminjie")
  end
  if not this.suoxuzhili then
    this.suoxuzhili = LocalizationUtility.GetContentByKey("suoxuzhili")
  end
  if not this.suoxudengji then
    this.suoxudengji = LocalizationUtility.GetContentByKey("suoxudengji")
  end
  if not this.keyishiyong then
    this.keyishiyong = LocalizationUtility.GetContentByKey("keyishiyong")
  end
  if not this.shoudianjiage then
    this.shoudianjiage = LocalizationUtility.GetContentByKey("shoudianjiage")
  end
  if not this.naijiudu then
    this.naijiudu = LocalizationUtility.GetContentByKey("naijiudu")
  end
  if not this.lilianghaicha then
    this.lilianghaicha = LocalizationUtility.GetContentByKey("liliang")
  end
  if not this.minjiehaicha then
    this.minjiehaicha = LocalizationUtility.GetContentByKey("minjie")
  end
  if not this.zhilihaicha then
    this.zhilihaicha = LocalizationUtility.GetContentByKey("zhili")
  end
  if not this.zidongfenpeidianshu then
    this.zidongfenpeidianshu = LocalizationUtility.GetContentByKey("zidongfenpeidianshu")
  end
  if not this.xingyunlinghunbaoshizhichenggongjilv then
    this.xingyunlinghunbaoshizhichenggongjilv = LocalizationUtility.GetContentByKey("xingyunlinghunbaoshizhichenggongjilv")
  end
  if not this.xingyunhuixinyijilv then
    this.xingyunhuixinyijilv = LocalizationUtility.GetContentByKey("xingyunhuixinyijilv")
  end
  if not this.zhuoyuegongjijilvzengjia then
    this.zhuoyuegongjijilvzengjia = LocalizationUtility.GetContentByKey("zhuoyuegongjijilvzengjia")
  end
  if not this.gongjilizengjiadengji then
    this.gongjilizengjiadengji = LocalizationUtility.GetContentByKey("gongjilizengjiadengji")
  end
  if not this.mofagongjilizengjiadengji then
    this.mofagongjilizengjiadengji = LocalizationUtility.GetContentByKey("mofagongjilizengjiadengji")
  end
  if not this.gongjilizegnjia then
    this.gongjilizegnjia = LocalizationUtility.GetContentByKey("gongjilizegnjia")
  end
  if not this.mofagongjilizegnjia then
    this.mofagongjilizegnjia = LocalizationUtility.GetContentByKey("mofagongjilizegnjia")
  end
  if not this.gongjimofasuduzengjia then
    this.gongjimofasuduzengjia = LocalizationUtility.GetContentByKey("gongjimofasuduzengjia")
  end
  if not this.shasiguaiwushisuohuoshengmingzhizengjia then
    this.shasiguaiwushisuohuoshengmingzhizengjia = LocalizationUtility.GetContentByKey("shasiguaiwushisuohuoshengmingzhizengjia")
  end
  if not this.shasiguaiwushisuohuomofazhizengjia then
    this.shasiguaiwushisuohuomofazhizengjia = LocalizationUtility.GetContentByKey("shasiguaiwushisuohuomofazhizengjia")
  end
  if not this.zuidashengmingzhi then
    this.zuidashengmingzhi = LocalizationUtility.GetContentByKey("zuidashengmingzhi")
  end
  if not this.zuidamofazhi then
    this.zuidamofazhi = LocalizationUtility.GetContentByKey("zuidamofazhi")
  end
  if not this.shanghaifanshe then
    this.shanghaifanshe = LocalizationUtility.GetContentByKey("shanghaifanshe")
  end
  if not this.fangyuchengglv then
    this.fangyuchengglv = LocalizationUtility.GetContentByKey("fangyuchengglv")
  end
  if not this.shasiguaiwushisuohuojinzengjia then
    this.shasiguaiwushisuohuojinzengjia = LocalizationUtility.GetContentByKey("shasiguaiwushisuohuojinzengjia")
  end
  if not this.shanghaijianshao then
    this.shanghaijianshao = LocalizationUtility.GetContentByKey("shanghaijianshao")
  end
  if not this.suitstrength then
    this.suitstrength = LocalizationUtility.GetContentByKey("strength")
  end
  if not this.suitagility then
    this.suitagility = LocalizationUtility.GetContentByKey("agility")
  end
  if not this.suitvitality then
    this.suitvitality = LocalizationUtility.GetContentByKey("vitality")
  end
  if not this.suitenergy then
    this.suitenergy = LocalizationUtility.GetContentByKey("energy")
  end
  if not this.suitleadership then
    this.suitleadership = LocalizationUtility.GetContentByKey("leadership")
  end
end
