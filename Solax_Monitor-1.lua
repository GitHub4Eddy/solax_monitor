-- QUICKAPP Solax Monitor

-- This QuickApp monitors your Solax managed Solar Panels
-- The QuickApp has (child) devices for Solarpower/m², Today production and Total production 
-- The rateType interface of child device today is automatically set to "production"
-- The readings from the child device Today will be shown in the new energy panel 
-- The readings from the child device Total is automatically set to the right Wh unit (Wh, kWh, MWh or GWh) 

-- See API documentation on https://www.eu.solaxcloud.com/phoebus/resource/files/userGuide/Solax_API_for_End-user_V1.0.pdf
-- User can get a specific range of information through the granted tokenID. Please obtain your tokenID on the API page of Solaxcloud for free.
-- The tokenID can be used to obtain real-time data of your inverter system. The obtain frequency need to be lower than 10 times/min and 10,000 times/day.


-- Version 0.1 (17th November 2021)
-- Tested, ready for release

-- Version 0.2 (15th November 2021)
-- Changed json response

-- Version 0.1 (13th November 2021)
-- First (test) version


-- Variables (mandatory): 
-- tokenId = token ID of your Solax Inverter, obtain your tokenID on the API page of Solaxcloud for free
-- inverterSN = Unique identifier (Serial No.) of your Solax inverter
-- solarM2 = The amount of m2 Solar Panels (use . for decimals) for calculating Solar Power m² (default = 0)
-- interval = The daily API limitiation is 300 requests (default = 300 seconds (5 minutes), maximum 10 times/min and 10,000 times/day)
-- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)


-- Example json string (https://www.solaxcloud.com:9443/proxy/api/getRealtimeInfo.do?tokenId={tokenId}&sn={sn}):
-- {"exception":"Query success!","result":{"inverterSN":"XBT422Fnnnnnnn","sn":"SNWERTYUIO","acpower":480.0,"yieldtoday":876.0,"yieldtotal":99860.6,"feedinpower":0.0,"feedinenergy":0.0,"consumeenergy":0.0,"feedinpowerM2":0.0,"soc":0.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"4","inverterStatus":"102","uploadTime":"2021-11-15 10:54:36","batPower":0.0,"powerdc1":26.0,"powerdc2":29.0,"powerdc3":null,"powerdc4":null},"success":true}


-- No editing of this code is needed 


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


local function getChildVariable(child,varName) -- Fetch child class names
 for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


-- QuickApp functions


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
    self:debug(text)
  end
end


function QuickApp:solarPower(power, m2) -- Calculate Solar Power per m²
  self:logging(3,"Start solarPower")
  if m2 > 0 and power > 0 then
    solarPower = power / m2
  else
    solarPower = 0
  end
  return solarPower
end


function QuickApp:unitCheckWh(measurement) -- Set the measurement and unit to kWh, MWh or GWh
  self:logging(3,"Start unitCheckWh")
  if measurement > 1000000000 then
    return string.format("%.3f",measurement/1000000000),"GWh"
  elseif measurement > 1000000 then
    return string.format("%.3f",measurement/1000000),"MWh"
  elseif measurement > 1000 then
    return string.format("%.3f",measurement/1000),"kWh"
  else
    return string.format("%.0f",measurement),"Wh"
  end
end


function QuickApp:updateProperties() -- Update the properties
  self:logging(3,"updateProperties")
  self:updateProperty("value", tonumber(data.acpower))
  self:updateProperty("power", tonumber(data.acpower))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", data.uploadTime)
end


function QuickApp:updateLabels() -- Update the labels
  self:logging(3,"updateLabels")
  local labelText = ""
  labelText = labelText .."Current power: " ..data.acpower .." Watt" .."\n\n"
  labelText = labelText .."Solar power: " ..data.solarPower .." Watt/m² (" ..solarM2 .." m²)" .."\n"
  labelText = labelText .."Lastday: " ..data.yieldtoday .." kWh" .."\n"
  labelText = labelText .."Total: " ..data.yieldtotal .." " ..data.yieldtotalUnit .."\n\n"
  labelText = labelText .."Last update: " ..data.uploadTime .."\n" 
  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:getValues() -- Get the values from json file 
  self:logging(3,"getValues")
  data.acpower = string.format("%.0f", jsonTable.result.acpower)
  data.solarPower = string.format("%.3f",self:solarPower(tonumber(data.acpower), tonumber(solarM2)))
  data.yieldtoday = string.format("%.3f",jsonTable.result.yieldtoday/1000)
  data.yieldtotal = string.format("%.3f",jsonTable.result.yieldtotal)
  data.yieldtotal, data.yieldtotalUnit = self:unitCheckWh(tonumber(data.yieldtotal)) -- Set measurement and unit to kWh, MWh or GWh
  data.inverterType = jsonTable.result.inverterType
  data.uploadTime = jsonTable.result.uploadTime
  local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local runyear, runmonth, runday, runhour, runminute, runseconds = data.uploadTime:match(pattern)
  local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
  data.uploadTime = os.date("%d-%m-%Y %H:%M", convertedTimestamp)
end


function QuickApp:simData() -- Simulate Solax Monitor
  self:logging(3,"simData")
  apiResult = '{"exception":"Query success!","result":{"inverterSN":"XBT422Fnnnnnnn","sn":"SNWERTYUIO","acpower":480.0,"yieldtoday":876.0,"yieldtotal":99860.6,"feedinpower":0.0,"feedinenergy":0.0,"consumeenergy":0.0,"feedinpowerM2":0.0,"soc":0.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"4","inverterStatus":"102","uploadTime":"2021-11-15 10:54:36","batPower":0.0,"powerdc1":26.0,"powerdc2":29.0,"powerdc3":null,"powerdc4":null},"success":true}'
 
  jsonTable = json.decode(apiResult) 
  
  self:getValues()
  self:updateLabels()
  self:updateProperties()

  for id,child in pairs(self.childDevices) do 
    child:updateValue(data,userID) 
  end
  
  self:logging(3,"SetTimeout " ..interval .." seconds")
  fibaro.setTimeout(interval*1000, function() 
     self:simData()
  end)
end


function QuickApp:getData() -- Get the data from the API
  self:logging(3,"getData")
  self:logging(2,"URL: " ..url)
  http:request(url, {
    options={headers = {Accept = "application/json"},method = 'GET'},   
      success = function(response)
        self:logging(3,"response status: " ..response.status)
        self:logging(3,"headers: " ..response.headers["Content-Type"])
        self:logging(2,"Response data: " ..response.data)

        if response.data == nil or response.data == "" or response.data == "[]" or response.status > 200 then -- Check for empty result
          self:warning("Temporarily no production data from Solax Monitor")
          self:logging(3,"SetTimeout " ..interval .." seconds")
          fibaro.setTimeout(interval*1000, function() 
            self:getdata()
          end)
        end

        jsonTable = json.decode(response.data) 

        self:getValues()
        self:updateLabels()
        self:updateProperties()

        for id,child in pairs(self.childDevices) do 
          child:updateValue(data,userID) 
        end

      end,
      error = function(error)
        self:error("error: " ..json.encode(error))
        self:updateProperty("log", "error: " ..json.encode(error))
      end
    }) 
  
  self:logging(3,"SetTimeout " ..interval .." seconds")
  fibaro.setTimeout(interval*1000, function() 
     self:getData()
  end)
end


function QuickApp:createVariables() -- Create all Variables 
  jsonTable = {}
  data = {}
  data.acpower = "0"
  data.solarPower = "0" 
  data.yieldtoday = "0"
  data.yieldtotal = "0"
  data.yieldtotalUnit= "Wh"
  data.uploadTime = ""
end


function QuickApp:getQuickAppVariables() -- Get all Quickapp Variables or create them
  local tokenId = self:getVariable("tokenId")
  local inverterSN = self:getVariable("inverterSN")
  solarM2 = tonumber(self:getVariable("solarM2"))
  interval = tonumber(self:getVariable("interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values
  if tokenId == "" or tokenId == nil then
    tokenId = "0" -- This siteID is just an example, it is not working 
    self:setVariable("tokenId",tokenId)
    self:trace("Added QuickApp variable tokenId")
  end
 if inverterSN == "" or inverterSN == nil then
    inverterSN = "0" -- This inverter ID is just an example, it is not working
    self:setVariable("inverterSN",inverterSN)
    self:trace("Added QuickApp variable inverterSN")
  end 
  if solarM2 == "" or solarM2 == nil then 
    solarM2 = "0" -- Default Solar/m²
    self:setVariable("solarM2",solarM2)
    self:trace("Added QuickApp variable solarM2")
  end 
  if interval == "" or interval == nil then
    interval = "300" -- Default interval
    self:setVariable("interval",interval)
    self:trace("Added QuickApp variable interval")
    interval = tonumber(interval)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default debug level
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if tokenId == nil or tokenId == ""  or tokenId == "0" then -- Check mandatory tokenId   
    self:error("tokenId is empty! Please obtain your tokenID on the API page of Solaxcloud for free and copy the tokenId to the quickapp variable")
    self:warning("No tokenId: Switched to Simulation Mode")
    debugLevel = 4 -- Simulation mode due to empty tokenId 
  end
  if inverterSN == nil or inverterSN == ""  or inverterSN == "0" then -- Check mandatory inverterSN 
    self:error("inverterSN is empty! Get your inverterSN from your inverter and copy the inverterSN to the quickapp variable")
    self:warning("No inverterSN: Switched to Simulation Mode")
    debugLevel = 4 -- Simulation mode due to empty inverterSN
  end
  
  url = "https://www.solaxcloud.com:9443/proxy/api/getRealtimeInfo.do?tokenId=" ..tokenId .."&sn=" ..inverterSN
end


function QuickApp:setupChildDevices() -- Pick up all Child Devices
  local cdevs = api.get("/devices?parentId="..self.id) or {}
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
      local initChildData = { 
        {className="solarpower", name="Solar Power", type="com.fibaro.powerSensor", value=0},
        {className="yieldtoday", name="Today", type="com.fibaro.energyMeter", value=0},
        {className="yieldtotal", name="Total", type="com.fibaro.multilevelSensor", value=0},
      }
    for _,c in ipairs(initChildData) do
      local child = self:createChildDevice(
        {name = c.name,
          type=c.type,
          value=c.value,
          unit=c.unit,
          initialInterfaces = {},
        },
        _G[c.className] -- Fetch class constructor from class name
      )
      child:setVariable("className",c.className)  -- Save class name so we know when we load it next time
    end   
  else 
    for _,child in ipairs(cdevs) do
      local className = getChildVariable(child,"className") -- Fetch child class name
      local childObject = _G[className](child) -- Create child object from the constructor name
      self.childDevices[child.id]=childObject
      childObject.parent = self -- Setup parent link to device controller 
    end
  end
end


function QuickApp:onInit()
  __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
  self:debug("onInit") 
  
  self:setupChildDevices()
  self:getQuickAppVariables() 
  self:createVariables()
  
  http = net.HTTPClient({timeout=5*1000})
  
  if tonumber(debugLevel) >= 4 then 
    self:simData() -- Go in simulation
  else
    self:getData() -- Get data from Solax Monitor
  end
end

-- EOF 
