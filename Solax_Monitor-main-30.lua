-- QUICKAPP Solax Monitor main


local function getChildVariable(child,varName) -- Fetch child class names
 for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
    self:debug(text)
  end
end


function QuickApp:solarPower(power, m2) -- Calculate Solar Power per m²
  self:logging(3,"Start solarPower() - Calculate Solar Power per m²")
  if m2 > 0 and power > 0 then
    solarPower = power / m2
  else
    solarPower = 0
  end
  return solarPower
end


function QuickApp:unitCheckWh(measurement) -- Set the measurement and unit to kWh, MWh or GWh
  self:logging(3,"Start unitCheckWh() - Set the measurement and unit to kWh, MWh or GWh")
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


function QuickApp:inverterStatus(status) -- Set the inverter status (API manual Appendix Table 5) 
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


function QuickApp:inverterType(type) -- Set the inverter type (API manual Appendix Table 4)
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
  self:logging(3,"updateProperties() - Update the properties")
  self:updateProperty("value", tonumber(data.acpower))
  self:updateProperty("power", tonumber(data.acpower))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", data.uploadTime)
end


function QuickApp:updateLabels() -- Update the labels
  self:logging(3,"updateLabels() - Update the labels")
  local labelText = ""
  
  if debugLevel == 4 then
    labelText = labelText ..translation["SIMULATION MODE"]  .."\n\n"
  end
  
  labelText = labelText ..translation["Current Power"] ..": " ..data.acpower .." Watt" .."\n\n"
  
  labelText = labelText ..translation["Solar Power/m²"] ..": " ..data.solarPower .." Watt/m² (" ..solarM2 .." m²)" .."\n"
  labelText = labelText ..translation["Today Energy"] ..": " ..data.yieldtoday .." kWh" .."\n"
  labelText = labelText ..translation["Total Energy"] ..": " ..data.yieldtotal .." " ..data.yieldtotalUnit .."\n"
  labelText = labelText ..translation["Total Power/m²"] ..": " ..data.feedinpowerM2 .." Watt/m²" .."\n\n"
  
  labelText = labelText ..translation["Total Power to Grid"] ..": " ..data.feedinpower .." Watt" .."\n"
  labelText = labelText ..translation["Total Energy to Grid"] ..": " ..data.feedinenergy .." kWh" .."\n"
  labelText = labelText ..translation["Energy from Grid"] ..": " ..data.consumeenergy .." kWh" .."\n\n"
  
  labelText = labelText ..translation["Battery Energy"] ..": " ..data.soc .." %" .."\n"
  labelText = labelText ..translation["Battery Power"] ..": " ..data.batPower .." Watt" .."\n\n"
  
  labelText = labelText ..translation["AC Power R"] ..": " ..data.peps1 .." Watt" .."\n"
  labelText = labelText ..translation["AC Power S"] ..": " ..data.peps2 .." Watt" .."\n"
  labelText = labelText ..translation["AC Power T"] ..": " ..data.peps3 .." Watt" .."\n\n"
  
  labelText = labelText ..translation["Power DC1"] ..": " ..data.powerdc1 .." Watt" .."\n"
  labelText = labelText ..translation["Power DC2"] ..": " ..data.powerdc2 .." Watt" .."\n"
  labelText = labelText ..translation["Power DC3"] ..": " ..data.powerdc3 .." Watt" .."\n"
  labelText = labelText ..translation["Power DC4"] ..": " ..data.powerdc4 .." Watt" .."\n\n"
  
  labelText = labelText ..translation["Inverter Type"] ..": " ..data.inverterType .."\n"
  labelText = labelText ..translation["Inverter Status"] ..": " ..data.inverterStatus .."\n"
  labelText = labelText ..translation["Last update"] ..": " ..data.uploadTime .."\n" 
  self:updateView("label", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:getValues(table) -- Get the values from json file 
  self:logging(3,"getValues() - Get the values from json file ")
  local jsonTable = table
  data.acpower = string.format("%.0f", jsonTable.result.acpower or "0")
  data.solarPower = string.format("%.2f",self:solarPower(tonumber(data.acpower), tonumber(solarM2)))
  data.yieldtoday = string.format("%.1f",jsonTable.result.yieldtoday or "0")
  data.yieldtotal = jsonTable.result.yieldtotal*1000 or "0"
  data.yieldtotal, data.yieldtotalUnit = self:unitCheckWh(tonumber(data.yieldtotal))-- Set measurement and unit to kWh, MWh or GWh  
  data.feedinpower = string.format("%.0f",jsonTable.result.feedinpower or "0")
  data.feedinpower = string.format("%.2f",-tonumber(data.feedinpower)) -- Convert positive to negative, negative to positive
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
  self:logging(3,"simData() - Simulate Solax Monitor")
  local apiResult = '{"success":true,"exception":"Query success!","result":{"inverterSN":"H3UE*********","sn":"SW********","acpower":575.0,"yieldtoday":2.5,"yieldtotal":445.3,"feedinpower":-44.0,"feedinenergy":6.23,"consumeenergy":1292.27,"feedinpowerM2":0.0,"soc":15.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"5","inverterStatus":"102","uploadTime":"2022-04-16 07:55:03","batPower":355.0,"powerdc1":0.0,"powerdc2":213.0,"powerdc3":0.0,"powerdc4":0.0}}'
  --local apiResult = '{"success":false,"exception":"Query success!","result":"this sn did not access!"}'
 
  local jsonTable = json.decode(apiResult) 
  if jsonTable == nil or jsonTable == "" or jsonTable == "[]" or not jsonTable.success then -- Check for empty or faulty result
    self:warning("Temporarily no production data from Solax Cloud")
    self:updateProperty("log", "No data from Cloud")
    return
  end
  
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
  self:logging(3,"getData() - Get the data from the API")
  local url = "https://www.solaxcloud.com:9443/proxy/api/getRealtimeInfo.do?tokenId="..self:getVariable('tokenId').."&sn=" ..self:getVariable('inverterSN')
  self:logging(2,"URL: " ..url)
  http:request(url, {
    options={headers = {Accept = "application/json"},method = 'GET'},   
      success = function(response)
        self:logging(3,"response status: " ..response.status)
        self:logging(3,"headers: " ..response.headers["Content-Type"])
        self:logging(2,"Response data: " ..response.data)

        response.data = response.data:gsub("null", "0.0") -- clean up the response.data by replacing null with 0.0
        local jsonTable = json.decode(response.data) 
        
        if jsonTable == nil or jsonTable == "" or jsonTable == "[]" or response.status > 200 or jsonTable.success == "false" or not jsonTable.success then -- Check for empty or faulty result
          self:warning("Temporarily no production data from Solax Cloud")
          self:updateProperty("log", "No data from Cloud")
          return
        end

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
  self:logging(3,"createVariables() - Create all Variables ")
  translation = i18n:translation(string.lower(self:getVariable("language"))) -- Initialise the translation
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
  local language = string.lower(self:getVariable("language"))
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
  if language == "" or language == nil or type(i18n:translation(string.lower(self:getVariable("language")))) ~= "table" then
    language = "en" 
    self:setVariable("language",language)
    self:trace("Added QuickApp variable language")
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
        {className="feedinenergy", name="Energy to Grid", type="com.fibaro.energyMeter", value=0},
        {className="consumeenergy", name="Energy from Grid", type="com.fibaro.energyMeter", value=0},
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