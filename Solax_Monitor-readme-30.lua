--[[ Solax Monitor readme


This QuickApp monitors your Solax managed Solar Panels
The QuickApp has (child) devices for Solarpower/m², Today production, Total production, Total Power to Grid, Total Energy to Grid, Consumed Energy, Energy from Grid, Total Power/m², Battery Energy, AC Power R, AC Power S, AC Power T, Battery Power, Power DC1, Power DC2, Power DC3 and Power DC4
The rateType interface of child device Today Energy is automatically set to "production"
The readings from the child device Today Energy will be shown in the new energy panel 
The readings from the child device Total Energy is automatically set to the right Wh unit (Wh, kWh, MWh or GWh) 

See API documentation on https://www.eu.solaxcloud.com/phoebus/resource/files/userGuide/Solax_API.pdf
User can get a specific range of information through the granted tokenID. Please obtain your tokenID on the API page of Solaxcloud for free.
The tokenID can be used to obtain real-time data of your inverter system. The obtain frequency need to be lower than 10 times/min and 10,000 times/day.

TODO: 
- change to standard ratetypes

Version 3.0 (11th January 2023)
- Changed the descriptions of the Solax Cloud values
- Converted the feedinpower value from positive to negative or from negative to positive
- Added translation for English, Dutch and Portugese
- Added child device for consumeenergy

Version 2.1 (4th December 2022)
- Prevented almost empty responses like these: {"success":false,"exception":"Query success!","result":"this sn did not access!"}
- Added log text to main device if no data from Solax Cloud 

Version 2.0 (16th April 2022)
- Added Child Devices for feedinpower, feedinenergy, consumeenergy, feedinpowerM2, soc, peps1, peps2, peps3, batPower, powerdc1, powerdc2, powerdc3, powerdc4
- Added all values returned from the Solax Cloud to the labels
- Changed all the device types to the most current ones
- Changed the handling of bad responses from the Solax Cloud
- Replaced null values in responses with 0.0
- Optimized some code

Version 1.0 (17th November 2021)
- Tested, ready for release

Version 0.2 (15th November 2021)
- Changed json response

Version 0.1 (13th November 2021)
- First (test) version


Variables (mandatory and created automatically): 
- tokenId = token ID of your Solax Inverter, obtain your tokenID on the API page of Solaxcloud for free
- inverterSN = Unique identifier (Serial No.) of your Solax inverter
- solarM2 = The amount of m2 Solar Panels (use . for decimals) for calculating Solar Power m² (default = 0)
- interval = The default is 300 seconds (5 minutes), the daily API limitation is maximum 10 times/min and 10,000 times/day
- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)


Example json string (https://www.solaxcloud.com:9443/proxy/api/getRealtimeInfo.do?tokenId={tokenId}&sn={sn}):
{"exception":"Query success!","result":{"inverterSN":"XBT422Fnnnnnnn","sn":"SNWERTYUIO","acpower":480.0,"yieldtoday":876.0,"yieldtotal":99860.6,"feedinpower":0.0,"feedinenergy":0.0,"consumeenergy":0.0,"feedinpowerM2":0.0,"soc":0.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"4","inverterStatus":"102","uploadTime":"2021-11-15 10:54:36","batPower":0.0,"powerdc1":26.0,"powerdc2":29.0,"powerdc3":null,"powerdc4":null},"success":true}

{"success":true,"exception":"Query success!","result":{"inverterSN":"H3UE*********","sn":"SW********","acpower":575.0,"yieldtoday":2.5,"yieldtotal":445.3,"feedinpower":-44.0,"feedinenergy":6.23,"consumeenergy":1292.27,"feedinpowerM2":0.0,"soc":15.0,"peps1":0.0,"peps2":0.0,"peps3":0.0,"inverterType":"5","inverterStatus":"102","uploadTime":"2022-04-16 07:55:03","batPower":-355.0,"powerdc1":0.0,"powerdc2":213.0,"powerdc3":null,"powerdc4":null}}


API items: Description (Accuracy) (Unit) 
- inverterSN: Unique identifier of inverter (Serial No.)
- sn: Unique identifier of communication module (Registration No.)
- acpower: Inverter.AC.power.total (1) (W)
- yieldtoday: Inverter.AC.energy.out.daily (0.1) (KWh)
- yieldtotal: Inverter.AC.energy.out.total (0.1) (KWh) 
- feedinpower: Grid.power.total (1) (W)
- feedinenergy: Grid.energy.toGrid.total (0.01) (KWh) 
- consumeenergy: Grid.energy.fromGrid.total (0.01) (KWh) 
- feedinpowerM2: Inverter.Meter2.AC.power.total (1) (W) 
- soc: inverter.DC.battery.energy.SOC (1) (%)
- peps1: Inverter.AC.EPS.power.R (1) (W)
- peps2: Inverter.AC.EPS.power.S (1) (W)
- peps3: Inverter.AC.EPS.power.T (1) (W)
- inverterType: Inverter type, details refer to Table 4 in appendix
- inverterStatus: Inverter status, details refer to Table 5 in appendix
- uploadTime: Update time (format 2016-10-26 17:33:01)
- batPower: Inverter.DC.Battery.power.total (1) (W)
- powerdc1: Inverter.DC.PV.power.MPPT1 (1) (W)
- powerdc2: Inverter.DC.PV.power.MPPT2 (1) (W)
- powerdc3: Inverter.DC.PV.power.MPPT3 (1) (W)
- powerdc4: Inverter.DC.PV.power.MPPT4 (1) (W)
]]

-- EOF