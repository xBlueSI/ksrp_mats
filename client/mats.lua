local TransportVehicle = nil
local AlreadyStarted = false
local InMission = false
local InMission2 = false
local BoxMenu = false
local BoxMenu2 = false

local Carrying = false
local Carrying2 = false
local BoxCarring = 0

local FlyttBox = nil
local FlyttBox2 = nil
local FlyttBox3 = nil
local FlyttBox4 = nil
local FlyttBox5 = nil
local FlyttBox6 = nil
local count = 0

local OutsideHospital = { x = 286.98, y = -612.44, z = 43.38}

local RouteBlip = nil
local SetorRemoveBlip = false

RegisterNetEvent('ksrp_mats:StartMenu')
AddEventHandler('ksrp_mats:StartMenu', function(status)
	if AlreadyStarted == false then
		StartMenu()
	else
		sendNotification('Du är redan i ett uppdrag!', 'info')
	end
end)

function StartMenu()
	local elements = {}

	table.insert(elements, {label = 'Transportera Tryckförband', value = 'tryckforband'})
	table.insert(elements, {label = 'Kommer snart...'})
	-- table.insert(elements, {label = '--- Låst ---'})
	-- table.insert(elements, {label = '--- Låst ---'})
	-- table.insert(elements, {label = '--- Låst ---'})

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'Mats_Mission',
		{
			title    = 'Mats',
			align    = 'center',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'tryckforband' then
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'MakeSure1',
					{
						title	= 'Är du säker på att du vill starta uppdraget?',
						align	= 'center',
						elements = {
							{label = 'Nej',	value = 'no'},
							{label = 'Ja',	value = 'yes'}
						},
					},
					function(data, menu)
						if data.current.value == 'no' then
							ESX.UI.Menu.CloseAll()
							sendNotification('Du <span style="color:red;"><strong>nekade</strong></span> uppdraget!', 'info')
						elseif data.current.value == 'yes' then
							ESX.UI.Menu.CloseAll()
							AlreadyStarted = true
							CanCancel = true
							InMission = true
							BoxMenu = true
							Missionstarter()
						end
					end,
					function(data, menu)
						menu.close()
					end	
				)
			end
		end,
	function(data, menu)
		menu.close()
	end)
end

function Missionstarter()
	SpawnVehicle('burrito3')
	SpawnBoxes('prop_paper_box_02')
end

function SpawnBoxes(prop)
	SpawnBox(prop)
	SpawnBox2(prop)
	SpawnBox3(prop)
	SpawnBox4(prop)
	SpawnBox5(prop)
	SpawnBox6(prop)
end

function SpawnVehicle(vehicle)
	if DoesEntityExist(TransportVehicle) then
		DeleteEntity(TransportVehicle)
	end
    if not DoesEntityExist(TransportVehicle) then
        local model = GetHashKey(vehicle)
        RequestModel(model)

        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end

        TransportVehicle = CreateVehicle(model, Config.VehicleSpawnpoint.x, Config.VehicleSpawnpoint.y, Config.VehicleSpawnpoint.z, Config.VehicleSpawnpoint.h, true, true)

        local props = ESX.Game.GetVehicleProperties(TransportVehicle)

        props.plate = 'FUL  ' .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)

        ESX.Game.SetVehicleProperties(TransportVehicle, props)
        SetVehicleColours(TransportVehicle, 148, 0)
		SetVehicleFuelLevel(TransportVehicle, 100.0)
		SetVehicleOilLevel(TransportVehicle, 100.0)
		FreezeEntityPosition(TransportVehicle, true)
		SetVehicleDoorOpen(TransportVehicle, 2, false, false)
		SetVehicleDoorOpen(TransportVehicle, 3, false, false)
		SetVehicleEngineOn(TransportVehicle, true, true, true)
		SetVehicleDirtLevel(TransportVehicle, 15.0)
        TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(TransportVehicle), GetDisplayNameFromVehicleModel(GetEntityModel(TransportVehicle)))
    end
end

Citizen.CreateThread(function()
	while true do

		Wait(0)
		  local TryToStartBlip = false

		SetPedMotionBlur(GetPlayerPed(-1), true)

		if CanCancel then
			drawTxt(1.43, 1.45, 1.0, 1.0, 0.2, '[~b~F10~w~] Avryt uppdraget!', 255, 255, 255, 255)
			if IsControlJustReleased(0, 57) then
				CancelMission()
			end
		end
		if InMission then
		  local VehicleCoords = GetOffsetFromEntityInWorldCoords(TransportVehicle, 0.0, -3.6, 0.0)
		  local TextPosCoord = { x = VehicleCoords.x, y = VehicleCoords.y, z = VehicleCoords.z}
		  local Size = { x = 1.5, y = 1.5, z = 1.5, range = 10.0}
		  local rgb = {r = 0, g = 169, b = 100}
			if IsVehicleDoorFullyOpen(TransportVehicle, 2) and IsVehicleDoorFullyOpen(TransportVehicle, 3) then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z) < Size.range then
					if Carrying then
						DrawMarker(27, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z - 0.84, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Size.x, Size.y, Size.z, rgb.r, rgb.g, rgb.b, 200, false, false, 2, false, false, false, false)
						ESX.Game.Utils.DrawText3D(TextPosCoord, '[~b~E~w~] Lämna av låda', 0.8)
						if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), TextPosCoord.x, TextPosCoord.y, TextPosCoord.z) < 1.0 and IsControlJustReleased(0, 38) then
							local VehicleInsideCoords = GetOffsetFromEntityInWorldCoords(TransportVehicle, 0.0, 0.0, 0.0)
							if BoxCarring == 1 then
								DetachEntity(FlyttBox6)
								SetEntityCoords(FlyttBox6, VehicleInsideCoords.x + 0.5, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z - 0.1, 1, 1, 1)
								FreezeEntityPosition(FlyttBox6, true)
								SetEntityHeading(FlyttBox6, 360.0)
							end
							if BoxCarring == 2 then
								DetachEntity(FlyttBox5)
								SetEntityCoords(FlyttBox5, VehicleInsideCoords.x + 0.05, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z - 0.1, 1, 1, 1)
								FreezeEntityPosition(FlyttBox5, true)
								SetEntityHeading(FlyttBox5, 360.0)
							end
							if BoxCarring == 3 then
								DetachEntity(FlyttBox4)
								SetEntityCoords(FlyttBox4, VehicleInsideCoords.x - 0.40, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z - 0.1, 1, 1, 1)
								FreezeEntityPosition(FlyttBox4, true)
								SetEntityHeading(FlyttBox4, 360.0)
							end
							if BoxCarring == 4 then
								DetachEntity(FlyttBox3)
								SetEntityCoords(FlyttBox3, VehicleInsideCoords.x + 0.5, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z + 0.27, 1, 1, 1)
								FreezeEntityPosition(FlyttBox3, true)
								SetEntityHeading(FlyttBox3, 360.0)
							end
							if BoxCarring == 5 then
								DetachEntity(FlyttBox2)
								SetEntityCoords(FlyttBox2, VehicleInsideCoords.x + 0.05, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z + 0.27, 1, 1, 1)
								FreezeEntityPosition(FlyttBox2, true)
								SetEntityHeading(FlyttBox2, 360.0)
							end
							if BoxCarring == 6 then
								DetachEntity(FlyttBox)
								SetEntityCoords(FlyttBox, VehicleInsideCoords.x - 0.40, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z + 0.27, 1, 1, 1)
								FreezeEntityPosition(FlyttBox, true)
								SetEntityHeading(FlyttBox, 360.0)
								BoxCarring = BoxCarring + 1
							end
							BoxMenu = true
							Carrying = false
							ClearPedTasks(PlayerPedId())
						end
					end
				end
			end
		end
		if Carrying then
			if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
				LoadAnim("anim@heists@box_carry@")
				TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
			end
		end
		if BoxMenu then
			local PedCoords = GetEntityCoords(GetPlayerPed(-1))
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 586.35, 2742.67, 42.08) < 10.0 then
				local Coords = { x = 586.35, y = 2742.67, z = 42.08}
				ESX.Game.Utils.DrawText3D(Coords, '[~b~E~w~] Plocka upp låda', 0.8)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 586.35, 2742.67, 42.08) < 1.5 then
					if IsControlJustReleased(0, 38) then
						if BoxCarring == 0 then
							AttachEnt(FlyttBox6)
						end
						if BoxCarring == 1 then
							AttachEnt(FlyttBox5)
						end
						if BoxCarring == 2 then
							AttachEnt(FlyttBox4)
						end
						if BoxCarring == 3 then
							AttachEnt(FlyttBox3)
						end
						if BoxCarring == 4 then
							AttachEnt(FlyttBox2)
						end
						if BoxCarring == 5 then
							AttachEnt(FlyttBox)
						end
						BoxCarring = BoxCarring + 1
						Carrying = true
						BoxMenu = false
					end
				end
			end
		end
		if BoxCarring == 7 then
			BoxMenu = false
			local VehicleInsideCoords = GetOffsetFromEntityInWorldCoords(TransportVehicle, 0.0, 0.0, 0.0)
			FreezeEntityPosition(TransportVehicle, false)
			DeleteAllBoxes()
			SetVehicleDoorShut(TransportVehicle, 2, 0)
			SetVehicleDoorShut(TransportVehicle, 3, 0)
			SetRuteBlip(OutsideHospital.x, OutsideHospital.y, OutsideHospital.z)
			BoxCarring = BoxCarring + 1
		end
		if BoxCarring == 8 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), OutsideHospital.x, OutsideHospital.y, OutsideHospital.z) < 30.0 then
				local Size = { x = 1.5, z = 1.5, y = 1.5}
				local RGB = {r = 0, g = 169, b = 100}
				local Opacity = 200
				local CamRotate = false
				DrawMarker(27, OutsideHospital.x, OutsideHospital.y, OutsideHospital.z - 0.97, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2.5, RGB.r, RGB.g, RGB.b, Opacity, false, false, 2, false, false, false, false)
			else
				local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), OutsideHospital.x, OutsideHospital.y, OutsideHospital.z)
				drawTxt(0.92, 0.604, 1.0, 1.0, 0.4, 'Kör till angivna ~y~GPS~w~ punkten! ~b~' .. math.ceil(distance) .. '~w~ Meter', 255, 255, 255, 255)
			end

			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), OutsideHospital.x, OutsideHospital.y, OutsideHospital.z) < 2.5 then
				ESX.Game.Utils.DrawText3D(OutsideHospital, '[~b~E~w~] Parkera', 0.8)
				if IsControlJustReleased(0, 38) and IsPedInVehicle(GetPlayerPed(-1), TransportVehicle, true) then
					RemoveBlip(RouteBlip)
					BoxCarring = BoxCarring + 1
					ESX.ShowNotification('Du har parkerat')
				end
			end
		end
		if BoxCarring == 9 then
			FreezeEntityPosition(TransportVehicle, true)
			SetVehicleEngineOn(TransportVehicle, false, false, false)
			SetVehicleDoorOpen(TransportVehicle, 2, false, false)
			SetVehicleDoorOpen(TransportVehicle, 3, false, false)
			SetEntityHeading(TransportVehicle, 180.0)

			if IsPedInVehicle(GetPlayerPed(-1), TransportVehicle, true) then
				drawTxt(0.92, 0.604, 1.0, 1.0, 0.4, 'Hoppa ut ur bilen!', 255, 255, 255, 255)
			else
				local VehicleInsideCoords = GetOffsetFromEntityInWorldCoords(TransportVehicle, 0.0, 0.0, 0.0)
				SpawnBoxes('prop_paper_box_02')
				SetEntityCoords(FlyttBox6, VehicleInsideCoords.x + 0.5, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z - 0.1, 1, 1, 1)
				SetEntityCoords(FlyttBox5, VehicleInsideCoords.x + 0.05, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z - 0.1, 1, 1, 1)
				SetEntityCoords(FlyttBox4, VehicleInsideCoords.x - 0.40, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z - 0.1, 1, 1, 1)
				SetEntityCoords(FlyttBox3, VehicleInsideCoords.x + 0.5, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z + 0.27, 1, 1, 1)
				SetEntityCoords(FlyttBox2, VehicleInsideCoords.x + 0.05, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z + 0.27, 1, 1, 1)
				SetEntityCoords(FlyttBox, VehicleInsideCoords.x - 0.40, VehicleInsideCoords.y + 0.3, VehicleInsideCoords.z + 0.27, 1, 1, 1)
				SetEntityHeading(FlyttBox, 360.0)
				SetEntityHeading(FlyttBox2, 360.0)
				SetEntityHeading(FlyttBox3, 360.0)
				SetEntityHeading(FlyttBox4, 360.0)
				SetEntityHeading(FlyttBox5, 360.0)
				SetEntityHeading(FlyttBox6, 360.0)
				BoxMenu2 = true
				BoxCarring = BoxCarring + 1 -- Detta gör att BoxCarring blir 10
			end
		end
		if BoxMenu2 then
			local VehicleCoords = GetOffsetFromEntityInWorldCoords(TransportVehicle, 0.0, -3.6, 0.0)
			local TextPosCoord = { x = VehicleCoords.x, y = VehicleCoords.y, z = VehicleCoords.z}
			local Size = { x = 1.5, y = 1.5, z = 1.5, range = 10.0}
			local rgb = {r = 0, g = 169, b = 100}
			drawTxt(0.92, 0.604, 1.0, 1.0, 0.4, 'Plocka upp en låda', 255, 255, 255, 255)
			DrawMarker(27, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z - 0.84, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Size.x, Size.y, Size.z, rgb.r, rgb.g, rgb.b, 200, false, false, 2, false, false, false, false)
			ESX.Game.Utils.DrawText3D(TextPosCoord, '[~b~E~w~] Bär låda', 0.8)
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z) < 1.5 then
				if IsControlJustReleased(0, 38) then
					if BoxCarring == 10 then
						AttachEnt(FlyttBox)
					end
					if BoxCarring == 12 then
						AttachEnt(FlyttBox2)
					end
					if BoxCarring == 14 then
						AttachEnt(FlyttBox3)
					end
					if BoxCarring == 16 then
						AttachEnt(FlyttBox4)
					end
					if BoxCarring == 18 then
						AttachEnt(FlyttBox5)
					end
					if BoxCarring == 20 then
						AttachEnt(FlyttBox6)
					end
					BoxCarring = BoxCarring + 1
					Carrying = true -- For animation
					BoxMenu2 = false
					InMission = false
					InMission2 = true
					Carrying2 = true
				end
			end
		end
		if InMission2 and Carrying2 then
			local Size = { x = 1.5, y = 1.5, z = 1.5, range = 10.0}
			local rgb = {r = 0, g = 169, b = 100}
			local TextPosCoord = {x = 303.48, y = -597.19, z = 43.29}
			DrawMarker(27, 303.48, -597.19, 43.29 - 0.97, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Size.x, Size.y, Size.z, rgb.r, rgb.g, rgb.b, 200, false, false, 2, false, false, false, false)
			ESX.Game.Utils.DrawText3D(TextPosCoord, '[~b~E~w~] Lämna av låda', 0.8)
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), TextPosCoord.x, TextPosCoord.y, TextPosCoord.z) < 1.0 and IsControlJustReleased(0, 38) then
				if BoxCarring == 11 then
					DetachEntity(FlyttBox)
					DeleteEntity(FlyttBox)
				end
				if BoxCarring == 13 then
					DetachEntity(FlyttBox2)
					DeleteEntity(FlyttBox2)
				end
				if BoxCarring == 15 then
					DetachEntity(FlyttBox3)
					DeleteEntity(FlyttBox3)
				end
				if BoxCarring == 17 then
					DetachEntity(FlyttBox4)
					DeleteEntity(FlyttBox4)
				end
				if BoxCarring == 19 then
					DetachEntity(FlyttBox5)
					DeleteEntity(FlyttBox5)
				end
				if BoxCarring == 21 then
					DetachEntity(FlyttBox6)
					DeleteEntity(FlyttBox6)
				end
				BoxCarring = BoxCarring + 1
				Carrying = false
				BoxMenu2 = true
				InMission2 = false
				carring2 = false
				ClearPedTasks(PlayerPedId())
			end
		end
		if BoxCarring == 22 then
			BoxMenu2 = false
			SetVehicleDoorShut(TransportVehicle, 2, 0)
			SetVehicleDoorShut(TransportVehicle, 3, 0)
			FreezeEntityPosition(TransportVehicle, false)
			BoxCarring = BoxCarring + 1
		end
		if BoxCarring == 23 then
			local LeaveVehiclePoint = { x = 601.43, y = 2737.11, z = 41.99}
			SetRuteBlip(LeaveVehiclePoint.x, LeaveVehiclePoint.y, LeaveVehiclePoint.z)
			BoxCarring = BoxCarring + 1
		end
		if BoxCarring == 24 then
			local LeaveVehiclePoint = { x = 601.43, y = 2737.11, z = 41.99}
			local Size = { x = 1.5, z = 1.5, y = 1.5}
			local RGB = {r = 0, g = 169, b = 100}
			local Opacity = 200
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), LeaveVehiclePoint.x, LeaveVehiclePoint.y, LeaveVehiclePoint.z) < 50.0 then
				ESX.Game.Utils.DrawText3D(LeaveVehiclePoint, 'Lämna tillbaka bilen till Mats', 0.8)
				DrawMarker(27, LeaveVehiclePoint.x, LeaveVehiclePoint.y, LeaveVehiclePoint.z - 0.97, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2.5, RGB.r, RGB.g, RGB.b, Opacity, false, false, 2, false, false, false, false)
				drawTxt(0.92, 0.604, 1.0, 1.0, 0.4, 'Lämna tillbaka bilen till Mats', 255, 255, 255, 255)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), LeaveVehiclePoint.x, LeaveVehiclePoint.y, LeaveVehiclePoint.z) < 1.5 then
					if IsControlJustReleased(0, 38) then
						DeleteEntity(TransportVehicle)
						local MoneyReward = math.random(1, 2) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)
						TriggerServerEvent('ksrp_mats:GiveMoney', MoneyReward)
						sendNotification("Du fick " .. MoneyReward, "info")
						CancelMission()
					end
				end
			else
				drawTxt(0.92, 0.604, 1.0, 1.0, 0.4, 'Lämna tillbaka bilen till Mats', 255, 255, 255, 255)
			end
		end
	end
end)

function AttachEnt(object)
	AttachEntityToEntity(object, PlayerPedId(),  GetPedBoneIndex(PlayerPedId(),  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 1, 1, 0, 1)
end

function SetRuteBlip(x, y, z)
	RouteBlip = AddBlipForCoord(x, y, z)
	SetBlipRoute(RouteBlip, true)
	SetBlipColour(RouteBlip, 46)
	SetBlipRouteColour(RouteBlip, 46)
end

function CancelMission()
	AlreadyStarted = false
	CanCancel = false
	InMission = false
	InMission2 = false
	BoxMenu = false
	Carrying = false
	Carrying = false
	BoxMenu2 = false
	ClearPedTasks(PlayerPedId())
	DeleteVehicle(TransportVehicle)
	DeleteAllBoxes()
	RemoveBlip(RouteBlip)
	BoxCarring = 0
end

function DeleteAllBoxes()
	-- Removes All Boxes
	if DoesEntityExist(FlyttBox) then
		DeleteEntity(FlyttBox)
	end
	if DoesEntityExist(FlyttBox2) then
		DeleteEntity(FlyttBox2)
	end
	if DoesEntityExist(FlyttBox3) then
		DeleteEntity(FlyttBox3)
	end
	if DoesEntityExist(FlyttBox4) then
		DeleteEntity(FlyttBox4)
	end
	if DoesEntityExist(FlyttBox5) then
		DeleteEntity(FlyttBox5)
	end
	if DoesEntityExist(FlyttBox6) then
		DeleteEntity(FlyttBox6)
	end
end


function SpawnBox(object)
    local model = GetHashKey(object)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end

	FlyttBox = CreateObject(model, 587.38, 2743.16, 42.07 - 0.99, true, false, true)
	SetEntityHeading(FlyttBox, 180.0)
	FreezeEntityPosition(FlyttBox, false)
end

function SpawnBox2(object)
    local model = GetHashKey(object)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end

	FlyttBox2 = CreateObject(model, 587.84, 2743.16, 42.07 - 0.99, true, false, true)
	SetEntityHeading(FlyttBox2, 180.0)
	FreezeEntityPosition(FlyttBox2, false)
end

function SpawnBox3(object)
    local model = GetHashKey(object)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end

	FlyttBox3 = CreateObject(model, 588.33, 2743.16, 42.06 - 0.99, true, false, true)
	SetEntityHeading(FlyttBox3, 180.0)
	FreezeEntityPosition(FlyttBox3, false)
end

function SpawnBox4(object)
    local model = GetHashKey(object)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end

	FlyttBox4 = CreateObject(model, 587.38, 2743.16, 42.07 - 0.62, true, false, true)
	SetEntityHeading(FlyttBox4, 180.0)
	FreezeEntityPosition(FlyttBox4, false)
end

function SpawnBox5(object)
    local model = GetHashKey(object)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end

	FlyttBox5 = CreateObject(model, 587.84, 2743.16, 42.07 - 0.62, true, false, true)
	SetEntityHeading(FlyttBox5, 180.0)
	FreezeEntityPosition(FlyttBox5, false)
end

function SpawnBox6(object)
    local model = GetHashKey(object)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end

	FlyttBox6 = CreateObject(model, 588.33, 2743.16, 42.06 - 0.62, true, false, true)
	SetEntityHeading(FlyttBox6, 180.0)
	FreezeEntityPosition(FlyttBox6, false)
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end
end

