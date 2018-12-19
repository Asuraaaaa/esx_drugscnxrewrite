-- Variable initialization
ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersSellingCoke       = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersSellingMeth       = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersSellingWeed       = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersSellingOpium      = {}
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local selling = false
local success = false
local copscalled = false
local notintrested = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- If used, Count online cops for Event Triggers
function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

-- Weed functions
-- Harvesting functions/Events
local function HarvestWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weed', Config.CollectAmount)
				HarvestWeed(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startHarvestWeed')
AddEventHandler('esx_drugscnxrewrite:startHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopHarvestWeed')
AddEventHandler('esx_drugscnxrewrite:stopHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = false

end)

-- Weed Processing functions/Events
local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local pouchQuantity = xPlayer.getInventoryItem('weed_pouch').count

			if pouchQuantity > weed_pouch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif weedQuantity < Config.ExchangeTake then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weed', Config.ExchangeTake)
				xPlayer.addInventoryItem('weed_pouch', Config.ExchangeGive)
				
				TransformWeed(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startTransformWeed')
AddEventHandler('esx_drugscnxrewrite:startTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeed(_source)

end)

-- stop Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopTransformWeed')
AddEventHandler('esx_drugscnxrewrite:stopTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = false

end)

-- Weed Selling to Dealer functions/Events
local function SellWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local pouchQuantity = xPlayer.getInventoryItem('weed_pouch').count

			if pouchQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('weed_pouch', 1)
				xPlayer.addAccountMoney('black_money', Config.WeedSellDealer)
				TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
				
				SellWeed(source)
			end

		end
	end)
end

-- start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startSellWeed')
AddEventHandler('esx_drugscnxrewrite:startSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellWeed(_source)

end)

-- Stop Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopSellWeed')
AddEventHandler('esx_drugscnxrewrite:stopSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = false

end)

-- Coke Functions
-- Coke collection functions/events
local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_coke'))
			else
				xPlayer.addInventoryItem('coke', Config.CollectAmount)
				HarvestCoke(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startHarvestCoke')
AddEventHandler('esx_drugscnxrewrite:startHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCoke(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopHarvestCoke')
AddEventHandler('esx_drugscnxrewrite:stopHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false

end)

-- Coke Processing Functions/Events
local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local pouchQuantity = xPlayer.getInventoryItem('coke_pouch').count

			if pouchQuantity > coke_pouch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif cokeQuantity < Config.ExchangeTake then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_coke'))
			else
				xPlayer.removeInventoryItem('coke', Config.ExchangeTake)
				xPlayer.addInventoryItem('coke_pouch', Config.ExchangeGive)
			
				TransformCoke(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startTransformCoke')
AddEventHandler('esx_drugscnxrewrite:startTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCoke(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopTransformCoke')
AddEventHandler('esx_drugscnxrewrite:stopTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = false

end)

-- Coke Selling to Dealer Functions/Events
local function SellCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local pouchQuantity = xPlayer.getInventoryItem('coke_pouch').count

			if pouchQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('coke_pouch', 1)
				xPlayer.addAccountMoney('black_money', Config.CokeSellDealer)
				TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
				
				SellCoke(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startSellCoke')
AddEventHandler('esx_drugscnxrewrite:startSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellCoke(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopSellCoke')
AddEventHandler('esx_drugscnxrewrite:stopSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = false

end)

-- Meth Functions
-- Meth collecting functions/Events
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end
	
	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local meth = xPlayer.getInventoryItem('meth')

			if meth.limit ~= -1 and meth.count >= meth.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_meth'))
			else
				xPlayer.addInventoryItem('meth', Config.CollectAmount)
				HarvestMeth(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startHarvestMeth')
AddEventHandler('esx_drugscnxrewrite:startHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestMeth(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopHarvestMeth')
AddEventHandler('esx_drugscnxrewrite:stopHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = false

end)

-- Meth Processing Functions/Events
local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local methQuantity = xPlayer.getInventoryItem('meth').count
			local pouchQuantity = xPlayer.getInventoryItem('meth_pouch').count

			if pouchQuantity > meth_pouch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif methQuantity < Config.ExchangeTake then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_meth'))
			else
				xPlayer.removeInventoryItem('meth', Config.ExchangeTake)
				xPlayer.addInventoryItem('meth_pouch', Config.ExchangeGive)
				
				TransformMeth(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startTransformMeth')
AddEventHandler('esx_drugscnxrewrite:startTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformMeth(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopTransformMeth')
AddEventHandler('esx_drugscnxrewrite:stopTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

-- Meth Sell to Dealer Functions/Events
local function SellMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local pouchQuantity = xPlayer.getInventoryItem('meth_pouch').count

			if pouchQuantity == 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('meth_pouch', 1)
				xPlayer.addAccountMoney('black_money', Confif.MethSellDealer)
				TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
				
				SellMeth(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startSellMeth')
AddEventHandler('esx_drugscnxrewrite:startSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellMeth(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopSellMeth')
AddEventHandler('esx_drugscnxrewrite:stopSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = false

end)

-- Opium Functions
-- Opium Collecting Functions/Events
local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingOpium[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local opium = xPlayer.getInventoryItem('opium')

			if opium.limit ~= -1 and opium.count >= opium.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_opium'))
			else
				xPlayer.addInventoryItem('opium', Config.CollectAmount)
				HarvestOpium(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startHarvestOpium')
AddEventHandler('esx_drugscnxrewrite:startHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestOpium(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopHarvestOpium')
AddEventHandler('esx_drugscnxrewrite:stopHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = false

end)

-- Opium Processing Functions/Events
local function TransformOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local pouchQuantity = xPlayer.getInventoryItem('opium_pouch').count

			if pouchQuantity > opium_pouch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif opiumQuantity < Config.ExchangeTake then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('opium', Config.ExchangeTake)
				xPlayer.addInventoryItem('opium_pouch', Config.ExchangeGive)
			
				TransformOpium(source)
			end

		end
	end)
end

-- Start Trigger
RegisterServerEvent('esx_drugscnxrewrite:startTransformOpium')
AddEventHandler('esx_drugscnxrewrite:startTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformOpium(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopTransformOpium')
AddEventHandler('esx_drugscnxrewrite:stopTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = false

end)

-- Opium Sell to Dealer Functions/Events
local function SellOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local pouchQuantity = xPlayer.getInventoryItem('opium_pouch').count

			if pouchQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('opium_pouch', 1)
				xPlayer.addAccountMoney('black_money', Config.OpiumSellDealer)
				TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
				
				SellOpium(source)
			end

		end
	end)
end

-- Start trigger
RegisterServerEvent('esx_drugscnxrewrite:startSellOpium')
AddEventHandler('esx_drugscnxrewrite:startSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellOpium(_source)

end)

-- End Trigger
RegisterServerEvent('esx_drugscnxrewrite:stopSellOpium')
AddEventHandler('esx_drugscnxrewrite:stopSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = false

end)

-- Get and return # items in players Inventory
RegisterServerEvent('esx_drugscnxrewrite:GetUserInventory')
AddEventHandler('esx_drugscnxrewrite:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_drugscnxrewrite:ReturnInventory', 
		_source, 
		xPlayer.getInventoryItem('coke').count, 
		xPlayer.getInventoryItem('coke_pouch').count,
		xPlayer.getInventoryItem('meth').count, 
		xPlayer.getInventoryItem('meth_pouch').count, 
		xPlayer.getInventoryItem('weed').count, 
		xPlayer.getInventoryItem('weed_pouch').count, 
		xPlayer.getInventoryItem('opium').count, 
		xPlayer.getInventoryItem('opium_pouch').count,
		currentZone
	)
end)

-- Flag Weed usable and Send to High effects
ESX.RegisterUsableItem('weed', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('esx_drugscnxrewrite:onPot', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('used_one_weed'))
end)

-- Selling to NPC Functions
-- Drug Selling to NPC Trigger event
RegisterNetEvent('drugs:trigger')
AddEventHandler('drugs:trigger', function()
selling = true
    if selling == true then
		TriggerEvent('pass_or_fail')
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 1)
		TriggerClientEvent("pNotify:SendNotification", source, {
	        text = _U('convince_npc'),
	        type = "error",
	        queue = "lmao",
	        timeout = 2500,
	        layout = "Centerleft"
    	})
 	end
end)

-- Pass Player Job
RegisterServerEvent('fetchjob')
AddEventHandler('fetchjob', function()
    local xPlayer  = ESX.GetPlayerFromId(source)
    TriggerClientEvent('getjob', source, xPlayer.job.name)
end)

-- Sell to NPC Functions/Events
RegisterNetEvent('drugs:sell')
AddEventHandler('drugs:sell', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local weedp = xPlayer.getInventoryItem('weed_pouch').count
	local cokep 	  = xPlayer.getInventoryItem('coke_pouch').count
	local methp = xPlayer.getInventoryItem('meth_pouch').count
	local opiump = xPlayer.getInventoryItem('opium_pouch').count
	local sellbags = math.random (Config.SellNPCMin,Config.SellNPCMax)
	local blackMoneyMade = 0

	if weedp >= 1 and success == true then -- Selling Weed
		blackMoneyMade = sellbags * Config.WeedSellNPC
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = _U('sold_weed_npc') .. blackMoneyMade ,
			type = "success",
			progressBar = false,
			queue = "lmao",
			timeout = 2000,
			layout = "CenterLeft"
		})
		TriggerClientEvent("animation", source)
		TriggerClientEvent("test", source)
		xPlayer.removeInventoryItem('weed_pouch', 1)
		xPlayer.addAccountMoney('black_money', blackMoneyMade)
		selling = false
	elseif cokep >= 1 and success == true then --Selling Coke
		blackMoneyMade = sellbags * Config.CokeSellNPC
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = _U('sold_coke_npc') .. blackMoneyMade ,
			type = "success",
			progressBar = false,
			queue = "lmao",
			timeout = 2000,
			layout = "CenterLeft"
		})
		TriggerClientEvent("animation", source)
		xPlayer.removeInventoryItem('coke_pouch', 1)
		xPlayer.addAccountMoney('black_money', blackMoneyMade)
		selling = false
	elseif methp >= 1 and success == true then -- Selling Meth
		blackMoneyMade = sellbags * Config.MethSellNPC
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = _U('sold_meth_npc') .. blackMoneyMade ,
			type = "success",
			progressBar = false,
			queue = "lmao",
			timeout = 2000,
			layout = "CenterLeft"
		})
		TriggerClientEvent("animation", source)
		xPlayer.removeInventoryItem('meth_pouch', 1)
		xPlayer.addAccountMoney('black_money', blackMoneyMade)
		selling = false
	elseif opiump >= 1 and success == true then -- Selling Opium
		blackMoneyMade = sellbags * Config.OpiumSellNPC
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = _U('sold_opium_npc') .. blackMoneyMade ,
			type = "success",
			progressBar = false,
			queue = "lmao",
			timeout = 2000,
			layout = "CenterLeft"
		})
		TriggerClientEvent("animation", source)
		xPlayer.removeInventoryItem('opium_pouch', 1)
		xPlayer.addAccountMoney('black_money', blackMoneyMade)
		selling = false
	elseif selling == true and success == false and notintrested == true then -- NPC not interested
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = _U('npc_not_interested'),
			type = "error",
			progressBar = false,
			queue = "lmao",
			timeout = 2000,
			layout = "CenterLeft"
		})
			selling = false
	elseif methp < 1 and cokep < 1 and weedp < 1 and opiump < 1 then -- No baggies
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = _U('no_drugs'),
			type = "error",
			progressBar = false,
			queue = "lmao",
			timeout = 2000,
			layout = "CenterLeft"
		})
	elseif copscalled == true and success == false then -- NPC Texts Cops
		TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
		TriggerClientEvent("pNotify:SendNotification", source, {
			text = _U('text_cops'),
			type = "error",
			progressBar = false,
			queue = "lmao",
			timeout = 2000,
			layout = "CenterLeft"
		})
		TriggerClientEvent("notifyc", source)
		selling = false
	end
end)

-- Sell success randomizer
RegisterNetEvent('pass_or_fail')
AddEventHandler('pass_or_fail', function()
	local percent = math.random(1, 11)
	if percent == 7 or percent == 8 or percent == 9 then -- Sell Fails on 7,8,9
		success = false
		notintrested = true
	elseif percent == 10 or percent == 11 then -- Call Cops on 10,11
		notintrested = false
		success = false
		copscalled = true
	else -- Sell on 1,2,3,4,5,6
		success = true
		notintrested = false
	end
end)

-- distance check while selling
RegisterNetEvent('sell_dis')
AddEventHandler('sell_dis', function()
	TriggerClientEvent("pNotify:SetQueueMax", source, "lmao", 5)
	TriggerClientEvent("pNotify:SendNotification", source, {
		text = _U('too_far'),
		type = "error",
		progressBar = false,
		queue = "lmao",
		timeout = 2000,
		layout = "CenterLeft"
	})
end)

-- Baggies to sell check
RegisterNetEvent('checkD')
AddEventHandler('checkD', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local methp = xPlayer.getInventoryItem('meth_pouch').count
	local cokep 	  = xPlayer.getInventoryItem('coke_pouch').count
	local weedp = xPlayer.getInventoryItem('weed_pouch').count
	local opiump = xPlayer.getInventoryItem('opium_pouch').count

	if methp >= 1 or cokep >= 1 or weedp >= 1 or opiump >= 1 then
		TriggerClientEvent("checkR", source, true)
	else
		TriggerClientEvent("checkR", source, false)
	end

end)