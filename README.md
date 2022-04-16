# solax_monitor

This QuickApp monitors your Solax managed Solar Panels
The QuickApp has (child) devices for Solarpower/m², Today production, Total production, Total Power to Grid, Total Energy to Grid, Energy from Grid, Total Power/m², Battery Energy, AC Power R, AC Power S, AC Power T, Battery Power, Power DC1, Power DC2, Power DC3 and Power DC4
The rateType interface of child device Today Energy is automatically set to "production"
The readings from the child device Today Energy will be shown in the new energy panel 
The readings from the child device Total Energy is automatically set to the right Wh unit (Wh, kWh, MWh or GWh) 

See API documentation on https://www.eu.solaxcloud.com/phoebus/resource/files/userGuide/Solax_API_for_End-user_V1.0.pdf
User can get a specific range of information through the granted tokenID. Please obtain your tokenID on the API page of Solaxcloud for free.
The tokenID can be used to obtain real-time data of your inverter system. The obtain frequency need to be lower than 10 times/min and 10,000 times/day.


Version 2.0 (16th April 2022)
- Added Child Devices for feedinpower, feedinenergy, consumeenergy, feedinpowerM2, soc, peps1, peps2, peps3, batPower, powerdc1, powerdc2, powerdc3, powerdc4
- Added all values returned from the Solax Cloud to the labels
- Changed all the device types to the most current ones
- Changed the handling of bad responses from the Solax Cloud
- Replaced null values in responses with 0.0
- Optimized some code

Changes version 1.0 (17th November 2021)
- First version


Variables (mandatory): 
- tokenId = token ID of your Solax Inverter, obtain your tokenID on the API page of Solaxcloud for free
- inverterSN = Unique identifier (Serial No.) of your Solax inverter
- solarM2 = The amount of m2 Solar Panels (use . for decimals) for calculating Solar Power m² (default = 0)
- interval = The daily API limitiation is 300 requests (default = 300 seconds (5 minutes), maximum 10 times/min and 10,000 times/day)
- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)
