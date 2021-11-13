# solax_monitor

This QuickApp monitors your Solax managed Solar Panels
The QuickApp has (child) devices for Solarpower/m², Today production and Total production 
The rateType interface of child device today is automatically set to "production"
The readings from the child device Today will be shown in the new energy panel 
The readings from the child device Total is automatically set to the right Wh unit (Wh, kWh, MWh or GWh) 

See API documentation on https://www.eu.solaxcloud.com/phoebus/resource/files/userGuide/Solax_API_for_End-user_V1.0.pdf
User can get a specific range of information through the granted tokenID. Please obtain your tokenID on the API page of Solaxcloud for free.
The tokenID can be used to obtain real-time data of your inverter system. The obtain frequency need to be lower than 10 times/min and 10,000 times/day.


Changes version 0.1 (11th April 2021)
- First (test) version


Variables (mandatory): 
- tokenId = token ID of your Solax Inverter
- inverterSN = Unique identifier of inverter (Serial No.) of your Solax Inverter 
- solarM2 = The amount of m2 Solar Panels (use . for decimals) for calculating Solar Power m² (default = 0)
- interval = The daily API limitiation is 300 requests. The default request interval is 360 seconds (6 minutes).
- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)
- icon = User defined icon number (add the icon via another device and lookup the number) (default = 0)
