Config              = {}

-- World markers for interaction
Config.MarkerType   = 27
Config.DrawDistance = 5.0
Config.ZoneSize     = {x = 5.0, y = 5.0, z = 5.0}
Config.MarkerColor  = {r = 0, g = 255, b = 255}

-- Jobs that cannot Access drug locations/blips
Config.JobsBlacklist = {
	police,
	ambulance
}

-- Jobs that can Access Weed locations/blips
Config.WeedWhitelist = {
	cartel
}

-- Jobs that can Access Coke locations/blips
Config.CokeWhitelist = {
	cartel
}

-- Jobs that can Access Meth locations/blips
Config.MethWhitelist = {
	cartel
}

-- Jobs that can Access Opium locations/blips
Config.OpiumWhitelist = {
	cartel
}

-- Cops online to access Drug Services
Config.RequiredCops  = 0

-- Time to take in seconds [first #]
Config.TimeToFarm    = 5 * 1000
Config.TimeToProcess = 10 * 1000
Config.TimeToSell    = 2  * 1000

-- Amount to collect in 1 cycle [could do per drug, would have to add a CollectAmount for each and update in the server.lua]
Config.CollectAmount = 1
--[[Config.WeedCollectAmount = 1
Config.CokeCollectAmount = 1
Config.MethCollectAmount = 1
Config.OpiumCollectAmount = 1]]

-- Exchange amount for 1 cycle [could do per drug, would have to add a Take/Give for each and update in the server.lua]
Config.ExchangeTake = 1
--[[Config.WeedExchangeTake = 1
Config.CokeExchangeTake = 1
Config.MethExchangeTake = 1
Config.OpiumExchangeTake = 1]]
Config.ExchangeGive = 5
--[[Config.WeedExchangeGive = 5
Config.CokeExchangeGive = 5
Config.MethExchangeGive = 5
Config.OpiumExchangeGive = 5]]

-- Selling Cash values
Config.WeedSellNPC = 100
Config.WeedSellDealer = 75
Config.CokeSellNPC = 350
Config.CokeSellDealer = 250
Config.MethSellNPC = 150
Config.MethSellDealer = 100
Config.OpiumSellNPC = 200
Config.OpiumSellDealer = 150

-- NPC selling randomization
Config.SellNPCMin = 1
Config.SellNPCMax = 3

-- Default locale
Config.Locale = 'en'

-- Drug Type and Zones info
Config.Zones = {
	Weed = {
		WeedField =			{x = 1609.12,	y = 6663.59,	z = 20.96,	name = _U('weed_field'),		sprite = 496,	color = 52},
		WeedProcessing =	{x = 91.06,		y = 3750.03,	z = 39.77,	name = _U('weed_processing'),	sprite = 496,	color = 52},
		WeedDealer =		{x = -54.24,	y = -1443.36,	z = 31.06,	name = _U('weed_dealer'),		sprite = 500,	color = 75}
	},
	Coke =	{
		CokeField =			{x = 2448.92,	y = -1836.80,	z = 51.95,	name = _U('coke_field'),		sprite = 501,	color = 40},
		CokeProcessing =	{x = -458.13,	y = -2278.61,	z = 7.51,	name = _U('coke_processing'),	sprite = 478,	color = 40},
		CokeDealer =		{x = -1756.19,	y = 427.31,		z =126.68,	name = _U('coke_dealer'),		sprite = 500,	color = 75}
	},
	Meth = {
		MethField =			{x = 1525.29,	y = 1710.02,	z = 109.00,	name = _U('meth_field'),		sprite = 499,	color = 26},
		MethProcessing =	{x = -1001.41,	y = 4848.00,	z = 274.00,	name = _U('meth_processing'),	sprite = 499,	color = 26},
		MethDealer =		{x = -63.59,	y = -1224.07,	z = 27.76,	name = _U('meth_dealer'),		sprite = 500,	color = 75}
	},
	Opium = {
		OpiumField =		{x = 1972.78,	y = 3819.39,	z = 32.50,	name = _U('opium_field'),		sprite = 51,	color = 60},
		OpiumProcessing =	{x = 971.86,	y = -2157.00,	z = 28.47,	name = _U('opium_processing'),	sprite = 51,	color = 60},
		OpiumDealer =		{x = 2331.08,	y = 2570.22,	z = 46.68,	name = _U('opium_dealer'),		sprite = 500,	color = 75}
	}
}
