-- QUICKAPP Solax Monitor

-- This QuickApp monitors your Solax managed Solar Panels
-- The QuickApp has (child) devices for Solarpower/m², Today production, Total production, Total Power to Grid, Total Energy to Grid, Energy from Grid, Total Power/m², Battery Energy, AC Power R, AC Power S, AC Power T, Battery Power, Power DC1, Power DC2, Power DC3 and Power DC4
-- The rateType interface of child device Today Energy is automatically set to "production"
-- The readings from the child device Today Energy will be shown in the new energy panel 
-- The readings from the child device Total Energy is automatically set to the right Wh unit (Wh, kWh, MWh or GWh) 

-- See API documentation on https://www.eu.solaxcloud.com/phoebus/resource/files/userGuide/Solax_API_for_End-user_V1.0.pdf
-- User can get a specific range of information through the granted tokenID. Please obtain your tokenID on the API page of Solaxcloud for free.
-- The tokenID can be used to obtain real-time data of your inverter system. The obtain frequency need to be lower than 10 times/min and 10,000 times/day.


-- Version 2.0 (16th April 2022)
-- Added Child Devices for feedinpower, feedinenergy, consumeenergy, feedinpowerM2, soc, peps1, peps2, peps3, batPower, powerdc1, powerdc2, powerdc3, powerdc4
-- Added all values returned from the Solax Cloud to the labels
-- Changed all the device types to the most current ones
-- Changed the handling of bad responses from the Solax Cloud
-- Replaced null values in responses with 0.0
-- Optimized some code


-- Version 1.0 (17th November 2021)
-- Tested, ready for release

-- Version 0.2 (15th November 2021)
-- Changed json response

-- Version 0.1 (13th November 2021)
-- First (test) version


-- Variables (mandatory and created automatically): 
-- tokenId = token ID of your Solax Inverter, obtain your tokenID on the API page of Solaxcloud for free
-- inverterSN = Unique identifier (Serial No.) of your Solax inverter
-- solarM2 = The amount of m2 Solar Panels (use . for decimals) for calculating Solar Power m² (default = 0)
-- interval = The default is 300 seconds (5 minutes), the daily API limitation is maximum 10 times/min and 10,000 times/day
-- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)


-- Example json string (https://www.solaxcloud.com:9443/proxy/api/getRealtimeInfo.do?tokenId={tokenId}&sn={sn}):
-- {"exception":"Query success!","result":{"inverterSN":"XBT422Fnnnnnnn","sn":"SNWERTYUIO","acpower":480.0,"yieldtoday":876.0,"yieldtotal":99860.6,"feedinpower":0.0,"feedinenergy":0.0,"consumeenergy":0.0,"feedinpowerM2":0.0,"soc":0.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"4","inverterStatus":"102","uploadTime":"2021-11-15 10:54:36","batPower":0.0,"powerdc1":26.0,"powerdc2":29.0,"powerdc3":null,"powerdc4":null},"success":true}

--{"success":true,"exception":"Query success!","result":{"inverterSN":"H3UE*********","sn":"SW********","acpower":575.0,"yieldtoday":2.5,"yieldtotal":445.3,"feedinpower":-44.0,"feedinenergy":6.23,"consumeenergy":1292.27,"feedinpowerM2":0.0,"soc":15.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"5","inverterStatus":"102","uploadTime":"2022-04-16 07:55:03","batPower":-355.0,"powerdc1":0.0,"powerdc2":213.0,"powerdc3":null,"powerdc4":null}}


-- API items: Description (Accuracy) (Unit) 
-- inverterSN: Unique identifier of inverter (Serial No.)
-- sn: Unique identifier of communication module (Registration No.)
-- acpower: i[:].inverter.AC.power.total (1) (W)
-- yieldtoday: i[:].inverter.AC.energy.out.daily (0.1) (KWh)
-- yieldtotal: i[:].inverter.AC.energy.out.total (0.1) (KWh) 
-- feedinpower: GCP.power.total (1) (W)
-- feedinenergy: GCP.energy.toGrid.total (0.01) (KWh) 
-- consumeenergy: GCP.energy.fromGrid.total (0.01) (KWh) 
-- feedinpowerM2: i[:].address2meter.AC.power.total (1) (W) 
-- soc: i[:].inverter.DC.battery.energy.SOC (1) (%)
-- peps1: i[:].inverter.AC.EPS.power.R (1) (W)
-- peps2: i[:].inverter.AC.EPS.power.S (1) (W)
-- peps3: i[:].inverter.AC.EPS.power.T (1) (W)
-- inverterType: Inverter type, details refer to Table 4 in appendix
-- inverterStatus: Inverter status, details refer to Table 5 in appendix
-- uploadTime: Update time (format 2016-10-26 17:33:01)
-- batPower: Inverter.DC.Battery.power.total (1) (W)
-- powerdc1: Inverter.DC.PV.power.MPPT1 (1) (W)
-- powerdc2: Inverter.DC.PV.power.MPPT2 (1) (W)
-- powerdc3: Inverter.DC.PV.power.MPPT3 (1) (W)
-- powerdc4: Inverter.DC.PV.power.MPPT4 (1) (W)


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
    return string.format("%.1f",measurement/1000),"kWh"
  else
    return string.format("%.0f",measurement),"Wh"
  end
end


function QuickApp:inverterStatus(status) -- Set the inverter status
  if status == "100" then
    return "Wait Mode"
  elseif status == "101" then
    return "Check Mode"
  elseif status == "102" then
    return "Normal Mode"
  elseif status == "103" then
    return "Fault Mode"
  elseif status == "104" then
    return "Permanent Fault Mode"
  elseif status == "105" then
    return "Update Mode"
  elseif status == "106" then
    return "EPS Check Mode"
  elseif status == "107" then
    return "EPS Mode"
  elseif status == "108" then
    return "Self-Test Mode" 
  elseif status == "109" then
    return "Idle Mode"
  elseif status == "110" then
    return "Standby Mode"
  elseif status == "111" then
    return "Pv Wake Up Bat Mode"
  elseif status == "112" then
    return "Gen Check Mode"
  elseif status == "113" then
    return "Gen Run Mode"
  else 
    return "Unknown Mode"
  end
end


function QuickApp:inverterType(type) -- Set the inverter type
  if type == "1" then
    return "X1-LX"
  elseif type == "2" then
    return "X-Hybrid"
  elseif type == "3" then
    return "X1-Hybiyd/Fit"
  elseif type == "4" then
    return "X1-Boost/Air/Mini"
  elseif type == "5" then
    return "X3-Hybiyd/Fit"
  elseif type == "6" then
    return "X3-20K/30K"
  elseif type == "7" then
    return "X3-MIC/PRO"
  elseif type == "8" then
    return "X1-Smart"
  elseif type == "9" then
    return "X1-AC"
  elseif type == "10" then
    return "A1-Hybrid"
  elseif type == "11" then
    return "A1-Fit"
  elseif type == "12" then
    return "A1-Grid" 
  elseif type == "13" then
    return "J1-ESS"
  else
    return "unknown"
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
  labelText = labelText .."Current Power: " ..data.acpower .." Watt" .."\n\n"
  labelText = labelText .."Solar Power/m²: " ..data.solarPower .." Watt/m² (" ..solarM2 .." m²)" .."\n"
  labelText = labelText .."Today Energy: " ..data.yieldtoday .." kWh" .."\n"
  labelText = labelText .."Total Energy: " ..data.yieldtotal .." " ..data.yieldtotalUnit .."\n\n"
  labelText = labelText .."Total Power to Grid: " ..data.feedinpower .." Watt" .."\n"
  labelText = labelText .."Total Energy to Grid: " ..data.feedinenergy .." Watt" .."\n"
  labelText = labelText .."Energy from Grid: " ..data.consumeenergy .." kWh" .."\n"
  labelText = labelText .."Total Power/m²: " ..data.feedinpowerM2 .." Watt/m²" .."\n\n"
  labelText = labelText .."Battery Energy: " ..data.soc .." %" .."\n"
  labelText = labelText .."AC Power R: " ..data.peps1 .." Watt" .."\n"
  labelText = labelText .."AC Power S: " ..data.peps2 .." Watt" .."\n"
  labelText = labelText .."AC Power T: " ..data.peps3 .." Watt" .."\n"
  labelText = labelText .."Battery Power: " ..data.batPower .." Watt" .."\n"
  labelText = labelText .."Power DC1: " ..data.powerdc1 .." Watt" .."\n"
  labelText = labelText .."Power DC2: " ..data.powerdc2 .." Watt" .."\n"
  labelText = labelText .."Power DC3: " ..data.powerdc3 .." Watt" .."\n"
  labelText = labelText .."Power DC4: " ..data.powerdc4 .." Watt" .."\n\n"
  labelText = labelText .."Inverter Type: " ..data.inverterType .."\n"
  labelText = labelText .."Inverter Status: " ..data.inverterStatus .."\n"
  labelText = labelText .."Last update: " ..data.uploadTime .."\n" 
  self:updateView("label", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:getValues(table) -- Get the values from json file 
  self:logging(3,"getValues")
  local jsonTable = table
  data.acpower = string.format("%.0f", jsonTable.result.acpower or "0")
  data.solarPower = string.format("%.2f",self:solarPower(tonumber(data.acpower), tonumber(solarM2)))
  data.yieldtoday = string.format("%.1f",jsonTable.result.yieldtoday)
  data.yieldtotal = jsonTable.result.yieldtotal*1000 or "0"
  data.yieldtotal, data.yieldtotalUnit = self:unitCheckWh(tonumber(data.yieldtotal))-- Set measurement and unit to kWh, MWh or GWh  
  data.feedinpower = string.format("%.0f",jsonTable.result.feedinpower or "0")
  data.feedinenergy = string.format("%.2f",jsonTable.result.feedinenergy or "0")
  data.consumeenergy = string.format("%.2f",jsonTable.result.consumeenergy or "0")
  data.feedinpowerM2 = string.format("%.0f",jsonTable.result.feedinpowerM2 or "0")
  data.soc = string.format("%.0f",jsonTable.result.soc or "0")
  data.peps1 = string.format("%.0f",jsonTable.result.peps1 or "0")
  data.peps2 = string.format("%.0f",jsonTable.result.peps2 or "0")
  data.peps3 = string.format("%.0f",jsonTable.result.peps3 or "0")
  data.inverterType = jsonTable.result.inverterType
  data.inverterType = self:inverterType(data.inverterType)
  data.inverterStatus = jsonTable.result.inverterStatus
  data.inverterStatus = self:inverterStatus(data.inverterStatus)
  data.batPower = string.format("%.0f",jsonTable.result.batPower or "0")
  data.powerdc1 = string.format("%.0f",jsonTable.result.powerdc1 or "0")
  data.powerdc2 = string.format("%.0f",jsonTable.result.powerdc2 or "0")
  data.powerdc3 = string.format("%.0f",jsonTable.result.powerdc3 or "0")
  data.powerdc4 = string.format("%.0f",jsonTable.result.powerdc4 or "0")
  data.uploadTime = jsonTable.result.uploadTime
  local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local runyear, runmonth, runday, runhour, runminute, runseconds = data.uploadTime:match(pattern)
  local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
  data.uploadTime = os.date("%d-%m-%Y %H:%M", convertedTimestamp)
end


function QuickApp:simData() -- Simulate Solax Monitor
  self:logging(3,"simData")
  apiResult = '{"success":true,"exception":"Query success!","result":{"inverterSN":"H3UE*********","sn":"SW********","acpower":575.0,"yieldtoday":2.5,"yieldtotal":445.3,"feedinpower":-44.0,"feedinenergy":6.23,"consumeenergy":1292.27,"feedinpowerM2":0.0,"soc":15.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"5","inverterStatus":"102","uploadTime":"2022-04-16 07:55:03","batPower":-355.0,"powerdc1":0.0,"powerdc2":213.0,"powerdc3":0.0,"powerdc4":0.0}}'
 
  local jsonTable = json.decode(apiResult) 
  
  self:getValues(jsonTable)
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
  local url = "https://www.solaxcloud.com:9443/proxy/api/getRealtimeInfo.do?tokenId="..self:getVariable('tokenId').."&sn=" ..self:getVariable('inverterSN')
  self:logging(2,"URL: " ..url)
  http:request(url, {
    options={headers = {Accept = "application/json"},method = 'GET'},   
      success = function(response)
        self:logging(3,"response status: " ..response.status)
        self:logging(3,"headers: " ..response.headers["Content-Type"])
        self:logging(2,"Response data: " ..response.data)

        if response.data == nil or response.data == "" or response.data == "[]" or response.status > 200 then -- Check for empty result
          self:warning("Temporarily no production data from Solax Monitor")
          return
        end

        response.data = response.data:gsub("null", "0.0") -- clean up the response.data by replacing null with 0.0
        local jsonTable = json.decode(response.data) 

        self:getValues(jsonTable)
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
  data = {}
  data.acpower = "0"
  data.solarPower = "0" 
  data.yieldtoday = "0"
  data.yieldtotal = "0"
  data.yieldtotalUnit= "Wh"
  data.feedinpower = "0"
  data.feedinenergy = "0"
  data.consumeenergy = "0"
  data.feedinpowerM2 = "0"
  data.soc = "0"
  data.peps1 = "0"
  data.peps2 = "0"
  data.peps3 = "0"
  data.inverterType = ""
  data.inverterStatus = ""
  data.uploadTime = ""
  data.batPower = "0"
  data.powerdc1 = "0"
  data.powerdc2 = "0"
  data.powerdc3 = "0"
  data.powerdc4 = "0"
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
end


function QuickApp:setupChildDevices() -- Pick up all Child Devices
  local cdevs = api.get("/devices?parentId="..self.id) or {}
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
      local initChildData = { 
        {className="solarpower", name="Solar Power", type="com.fibaro.powerMeter", value=0},
        {className="yieldtoday", name="Today Energy", type="com.fibaro.energyMeter", value=0},
        {className="yieldtotal", name="Total Energy", type="com.fibaro.energyMeter", value=0},
        {className="feedinpower", name="Grid Power", type="com.fibaro.powerMeter", value=0},
        {className="feedinenergy", name="Grid Energy", type="com.fibaro.energyMeter", value=0},
        {className="feedinpowerM2", name="Power M2", type="com.fibaro.powerMeter", value=0},
        {className="soc", name="Battery Energy", type="com.fibaro.multilevelSensor", value=0},
        {className="peps1", name="peps1", type="com.fibaro.powerMeter", value=0},
        {className="peps2", name="peps2", type="com.fibaro.powerMeter", value=0},
        {className="peps3", name="peps3", type="com.fibaro.powerMeter", value=0},
        {className="batPower", name="Battery Power", type="com.fibaro.powerMeter", value=0},
        {className="powerdc1", name="powerdc1", type="com.fibaro.powerMeter", value=0},
        {className="powerdc2", name="powerdc2", type="com.fibaro.powerMeter", value=0},
        {className="powerdc3", name="powerdc3", type="com.fibaro.powerMeter", value=0},
        {className="powerdc4", name="powerdc4", type="com.fibaro.powerMeter", value=0},
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
  
  if not api.get("/devices/"..self.id).enabled then
    self:warning("Device", fibaro.getName(plugin.mainDeviceId), "is disabled")
    return
  end
  
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