-- Quickapp Solax Monitor childs


class 'solarpower'(QuickAppChild)
function solarpower:__init(dev)
  QuickAppChild.__init(self,dev)
end
function solarpower:updateValue(data) 
  self:updateProperty("value", tonumber(data.solarPower))
  self:updateProperty("unit", "Watt/m²")
  self:updateProperty("log", solarM2 .." m²")
end

class 'yieldtoday'(QuickAppChild)
function yieldtoday:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
  self:warning("Changed rateType interface of Solax lastDayData child device (" ..self.id ..") to production")
  end
end
function yieldtoday:updateValue(data) 
  self:updateProperty("value", tonumber(data.yieldtoday))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end

class 'yieldtotal'(QuickAppChild)
function yieldtotal:__init(dev)
  QuickAppChild.__init(self,dev)
end
function yieldtotal:updateValue(data) 
  self:updateProperty("value", tonumber(data.yieldtotal))
  self:updateProperty("unit", data.yieldtotalUnit)
  self:updateProperty("log", "")
end

class 'feedinpower'(QuickAppChild)
function feedinpower:__init(dev)
  QuickAppChild.__init(self,dev)
end
function feedinpower:updateValue(data) 
  self:updateProperty("value", tonumber(data.feedinpower))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'feedinenergy'(QuickAppChild)
function feedinenergy:__init(dev)
  QuickAppChild.__init(self,dev)
end
function feedinenergy:updateValue(data) 
  self:updateProperty("value", tonumber(data.feedinenergy))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end

class 'consumeenergy'(QuickAppChild)
function consumeenergy:__init(dev)
  QuickAppChild.__init(self,dev)
end
function consumeenergy:updateValue(data) 
  self:updateProperty("value", tonumber(data.consumeenergy))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end

class 'feedinpowerM2'(QuickAppChild)
function feedinpowerM2:__init(dev)
  QuickAppChild.__init(self,dev)
end
function feedinpowerM2:updateValue(data) 
  self:updateProperty("value", tonumber(data.feedinpowerM2))
  self:updateProperty("unit", "Watt/m²")
  self:updateProperty("log", "")
end

class 'soc'(QuickAppChild)
function soc:__init(dev)
  QuickAppChild.__init(self,dev)
end
function soc:updateValue(data) 
  self:updateProperty("value", tonumber(data.soc))
  self:updateProperty("unit", "%")
  self:updateProperty("log", "")
end

class 'peps1'(QuickAppChild)
function peps1:__init(dev)
  QuickAppChild.__init(self,dev)
end
function peps1:updateValue(data) 
  self:updateProperty("value", tonumber(data.peps1))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'peps2'(QuickAppChild)
function peps2:__init(dev)
  QuickAppChild.__init(self,dev)
end
function peps2:updateValue(data) 
  self:updateProperty("value", tonumber(data.peps2))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'peps3'(QuickAppChild)
function peps3:__init(dev)
  QuickAppChild.__init(self,dev)
end
function peps3:updateValue(data) 
  self:updateProperty("value", tonumber(data.peps3))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'batPower'(QuickAppChild)
function batPower:__init(dev)
  QuickAppChild.__init(self,dev)
end
function batPower:updateValue(data) 
  self:updateProperty("value", tonumber(data.batPower))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'powerdc1'(QuickAppChild)
function powerdc1:__init(dev)
  QuickAppChild.__init(self,dev)
end
function powerdc1:updateValue(data) 
  self:updateProperty("value", tonumber(data.powerdc1))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'powerdc2'(QuickAppChild)
function powerdc2:__init(dev)
  QuickAppChild.__init(self,dev)
end
function powerdc2:updateValue(data) 
  self:updateProperty("value", tonumber(data.powerdc2))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'powerdc3'(QuickAppChild)
function powerdc3:__init(dev)
  QuickAppChild.__init(self,dev)
end
function powerdc3:updateValue(data) 
  self:updateProperty("value", tonumber(data.powerdc3))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

class 'powerdc4'(QuickAppChild)
function powerdc4:__init(dev)
  QuickAppChild.__init(self,dev)
end
function powerdc4:updateValue(data) 
  self:updateProperty("value", tonumber(data.powerdc4))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end

-- EOF