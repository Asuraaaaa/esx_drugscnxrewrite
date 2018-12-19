local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Variable initialization 
local cokeQTE       			= 0
ESX 			    			= nil
local coke_pouchQTE 			= 0
local weedQTE					= 0
local weed_pouchQTE 			= 0
local methQTE					= 0
local meth_pouchQTE 			= 0
local opiumQTE					= 0
local opium_pouchQTE 			= 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local selling       = false
local has       = false
local copsc     = false

-- Get player info
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
  TriggerServerEvent('fetchjob')
end)

-- RETURN NUMBER OF ITEMS FROM SERVER
RegisterNetEvent('getjob')
AddEventHandler('getjob', function(jobName)
  myJob = jobName
end)

-- RETURN NUMBER OF ITEMS FROM SERVER & Job
RegisterNetEvent('esx_drugscnxrewrite:ReturnInventory')
AddEventHandler('esx_drugscnxrewrite:ReturnInventory', function(cokeNbr, cokepNbr, methNbr, methpNbr, weedNbr, weedpNbr, opiumNbr, opiumpNbr, currentZone)
	cokeQTE	   = cokeNbr
	coke_pouchQTE = cokepNbr
	methQTE 	  = methNbr
	meth_pouchQTE = methpNbr
	weedQTE 	  = weedNbr
	weed_pouchQTE = weedpNbr
	opiumQTE	   = opiumNbr
	opium_pouchQTE = opiumpNbr
	TriggerEvent('esx_drugscnxrewrite:hasEnteredMarker', currentZone)
end)

-- Events on Entering World Marker
AddEventHandler('esx_drugscnxrewrite:hasEnteredMarker', function(zone)
	-- Hard code disable for EMS
	for k,v in pairs(Config.JobsBlacklist) do
		if myJob == v then
			return
		end
	end

	ESX.UI.Menu.CloseAll()
	
	if zone == 'exitMarker' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('exit_marker')
		CurrentActionData = {}
	end
	
	if zone == 'CokeField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeProcessing' then
		if cokeQTE >= Config.ExchangeTake then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'CokeDealer' then
		if coke_pouchQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'MethField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_meth')
		CurrentActionData = {}
	end

	if zone == 'MethProcessing' then
		if methQTE >= Config.ExchangeTake then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'MethDealer' then
		if meth_pouchQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedProcessing' then
		if weedQTE >= Config.ExchangeTake then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedDealer' then
		if weed_pouchQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumProcessing' then
		if opiumQTE >= Config.ExchangeTake then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_opium')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumDealer' then
		if opium_pouchQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_opium')
			CurrentActionData = {}
		end
	end
end)

-- Stop events on leaving world marker
AddEventHandler('esx_drugscnxrewrite:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

	TriggerServerEvent('esx_drugscnxrewrite:stopHarvestCoke')
	TriggerServerEvent('esx_drugscnxrewrite:stopTransformCoke')
	TriggerServerEvent('esx_drugscnxrewrite:stopSellCoke')
	TriggerServerEvent('esx_drugscnxrewrite:stopHarvestMeth')
	TriggerServerEvent('esx_drugscnxrewrite:stopTransformMeth')
	TriggerServerEvent('esx_drugscnxrewrite:stopSellMeth')
	TriggerServerEvent('esx_drugscnxrewrite:stopHarvestWeed')
	TriggerServerEvent('esx_drugscnxrewrite:stopTransformWeed')
	TriggerServerEvent('esx_drugscnxrewrite:stopSellWeed')
	TriggerServerEvent('esx_drugscnxrewrite:stopHarvestOpium')
	TriggerServerEvent('esx_drugscnxrewrite:stopTransformOpium')
	TriggerServerEvent('esx_drugscnxrewrite:stopSellOpium')
end)

-- Weed Effect
RegisterNetEvent('esx_drugscnxrewrite:onPot')
AddEventHandler('esx_drugscnxrewrite:onPot', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Render markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		-- Create Weed World Markers
		for k,v in pairs(Config.Zones.Weed) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

		-- Create Coke World Markers
		for k,v in pairs(Config.Zones.Coke) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

		-- Create Meth World Markers
		for k,v in pairs(Config.Zones.Meth) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

		-- Create Opium World Markers
		for k,v in pairs(Config.Zones.Opium) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	--Check for and Display Weed Blips for Whitelisted Jobs only
	for k,v in pairs(Config.WeedWhitelist) do
		if myJob == v then
			for k,v in pairs(Config.Zones.Weed) do
				local blip = AddBlipForCoord(v.x, v.y, v.z)

				SetBlipSprite (blip, v.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.9)
				SetBlipColour (blip, v.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.name)
				EndTextCommandSetBlipName(blip)
			end
		end
	end

	--Check for and Display Coke Blips for Whitelisted Jobs only
	for k,v in pairs(Config.CokeWhitelist) do
		if myJob == v then
			for k,v in pairs(Config.Zones.Coke) do
				local blip = AddBlipForCoord(v.x, v.y, v.z)

				SetBlipSprite (blip, v.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.9)
				SetBlipColour (blip, v.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.name)
				EndTextCommandSetBlipName(blip)
			end
		end
	end

	--Check for and Display Meth Blips for Whitelisted Jobs only
	for k,v in pairs(Config.MethWhitelist) do
		if myJob == v then
			for k,v in pairs(Config.Zones.Meth) do
				local blip = AddBlipForCoord(v.x, v.y, v.z)

				SetBlipSprite (blip, v.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.9)
				SetBlipColour (blip, v.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.name)
				EndTextCommandSetBlipName(blip)
			end
		end
	end

	--Check for and Display Opium Blips for Whitelisted Jobs only
	for k,v in pairs(Config.OpiumWhitelist) do
		if myJob == v then
			for k,v in pairs(Config.Zones.Opium) do
				local blip = AddBlipForCoord(v.x, v.y, v.z)

				SetBlipSprite (blip, v.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.9)
				SetBlipColour (blip, v.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.name)
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Activate menu when player is inside marker and check for job whitelist 
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if v == Weed then
				for k,v in pairs(Config.WeedWhitelist) do -- Check for Weed jobs
					if myjob == v then
						for k,v in pairs(Config.Zones.Weed) do -- Run through Weed Zones
							if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
								isInMarker  = true
								currentZone = k
							end
						end
					end
			elseif v == Coke then
				for k,v in pairs(Config.CokeWhitelist) do -- Check for Coke jobs
					if myjob == v then
						for k,v in pairs(Config.Zones.Coke) do -- Run through Coke Zones
							if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
								isInMarker  = true
								currentZone = k
							end
						end
					end
				end
			elseif v == Meth then
				for k,v in pairs(Config.MethWhitelist) do -- Check for Meth jobs
					if myjob == v then
						for k,v in pairs(Config.Zones.Meth) do -- Run through Meth Zones
							if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
								isInMarker  = true
								currentZone = k
							end
						end
					end
				end
			elseif v == Opium then
				for k,v in pairs(Config.OpiumWhitelist) do -- Check for Opium jobs
					if myjob == v then
						for k,v in pairs(Config.Zones.Opium) do -- Run through opium Zones
							if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
								isInMarker  = true
								currentZone = k
							end
						end
					end
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('esx_drugscnxrewrite:GetUserInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_drugscnxrewrite:hasExitedMarker', lastZone)
		end

		if isInMarker and isInZone then
			TriggerEvent('esx_drugscnxrewrite:hasEnteredMarker', 'exitMarker')
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, Keys['E']) then
				isInZone = true -- unless we set this boolean to false, we will always freeze the user
				if CurrentAction == 'exitMarker' then
					isInZone = false -- do not freeze user
					TriggerEvent('esx_drugscnxrewrite:freezePlayer', false)
					TriggerEvent('esx_drugscnxrewrite:hasExitedMarker', lastZone)
					Citizen.Wait(15000)
				elseif CurrentAction == 'CokeField' then
					TriggerServerEvent('esx_drugscnxrewrite:startHarvestCoke')
				elseif CurrentAction == 'CokeProcessing' then
					TriggerServerEvent('esx_drugscnxrewrite:startTransformCoke')
				elseif CurrentAction == 'CokeDealer' then
					TriggerServerEvent('esx_drugscnxrewrite:startSellCoke')
				elseif CurrentAction == 'MethField' then
					TriggerServerEvent('esx_drugscnxrewrite:startHarvestMeth')
				elseif CurrentAction == 'MethProcessing' then
					TriggerServerEvent('esx_drugscnxrewrite:startTransformMeth')
				elseif CurrentAction == 'MethDealer' then
					TriggerServerEvent('esx_drugscnxrewrite:startSellMeth')
				elseif CurrentAction == 'WeedField' then
					TriggerServerEvent('esx_drugscnxrewrite:startHarvestWeed')
				elseif CurrentAction == 'WeedProcessing' then
					TriggerServerEvent('esx_drugscnxrewrite:startTransformWeed')
				elseif CurrentAction == 'WeedDealer' then
					TriggerServerEvent('esx_drugscnxrewrite:startSellWeed')
				elseif CurrentAction == 'OpiumField' then
					TriggerServerEvent('esx_drugscnxrewrite:startHarvestOpium')
				elseif CurrentAction == 'OpiumProcessing' then
					TriggerServerEvent('esx_drugscnxrewrite:startTransformOpium')
				elseif CurrentAction == 'OpiumDealer' then
					TriggerServerEvent('esx_drugscnxrewrite:startSellOpium')
				else
					isInZone = false -- not a esx_drugscnxrewrite zone
				end
				
				if isInZone then
					TriggerEvent('esx_drugscnxrewrite:freezePlayer', true)
				end
				
				CurrentAction = nil
			end
		end
	end
end)

-- Freeze player while in World Marker
RegisterNetEvent('esx_drugscnxrewrite:freezePlayer')
AddEventHandler('esx_drugscnxrewrite:freezePlayer', function(freeze)
	FreezeEntityPosition(GetPlayerPed(-1), freeze)
end)

-- Sell to NPC Client side
currentped = nil
Citizen.CreateThread(function()

-- Check for available NPC and give prompt to sell
while true do
  Wait(0)
  local player = GetPlayerPed(-1)
  local playerloc = GetEntityCoords(player, 0)
  local handle, ped = FindFirstPed()
  repeat
    success, ped = FindNextPed(handle)
    local pos = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
      if DoesEntityExist(ped)then
        if IsPedDeadOrDying(ped) == false then
          if IsPedInAnyVehicle(ped) == false then
            local pedType = GetPedType(ped)
            if pedType ~= 28 and IsPedAPlayer(ped) == false then
              currentped = pos
              if distance <= 2 and ped  ~= GetPlayerPed(-1) and ped ~= oldped then
                TriggerServerEvent('checkD')
                if has == true then
                  drawTxt(0.90, 1.40, 1.0,1.0,0.4, _U('sell_npc'), 255, 255, 255, 255)
                  if IsControlJustPressed(1, 86) then
                      oldped = ped
                      SetEntityAsMissionEntity(ped)
                      TaskStandStill(ped, 9.0)
                      pos1 = GetEntityCoords(ped)
                      TriggerServerEvent('drugs:trigger')
                      Citizen.Wait(2850)
                      TriggerEvent('sell')
                      SetPedAsNoLongerNeeded(oldped)
                  end
                end
              end
            end
          end
        end
      end
    end
  until not success
  EndFindPed(handle)
end
end)

-- Selling to NPC Event trigger
RegisterNetEvent('sell')
AddEventHandler('sell', function()
    local player = GetPlayerPed(-1)
    local playerloc = GetEntityCoords(player, 0)
    local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

    if distance <= 2 then
      TriggerServerEvent('drugs:sell')
    elseif distance > 2 then
      TriggerServerEvent('sell_dis')
    end
end)

-- Has baggies to sell check
RegisterNetEvent('checkR')
AddEventHandler('checkR', function(test)
  has = test
end)

-- NPC refused drugs, and will text Cops
RegisterNetEvent('notifyc')
AddEventHandler('notifyc', function()

    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
    local streetName, crossing = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local streetName, crossing = GetStreetNameAtCoord(x, y, z)
    streetName = GetStreetNameFromHashKey(streetName)
	crossing = GetStreetNameFromHashKey(crossing)
	
    if crossing ~= nil then

      local coords      = GetEntityCoords(GetPlayerPed(-1))

      TriggerServerEvent('esx_phone:send', "police", _U('sell_npc') .. streetName .. _U('and').. crossing, true, {
        x = coords.x,
        y = coords.y,
        z = coords.z
      })
    else
      TriggerServerEvent('esx_phone:send', "police", _U('sell_npc') .. streetName, true, {
        x = coords.x,
        y = coords.y,
        z = coords.z
      })
    end
end)

-- Animation for Selling to NPC
RegisterNetEvent('animation')
AddEventHandler('animation', function()
  local pid = PlayerPedId()
  RequestAnimDict("amb@prop_human_bum_bin@idle_b")
  while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do Citizen.Wait(0) end
    TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    Wait(750)
    StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
end)

-- Selling to NPC Notification display
function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
