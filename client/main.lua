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

ESX               = nil

local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil

local TestCounter = 0

local TimeToggle = true
local Ped = nil
local PedIsSpawned = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('ksrp_mats:hasEnteredMarker', function(zone)
	if zone == 'MissionStarter' then
		CurrentAction = 'mstarter'
	end
end)

AddEventHandler('ksrp_mats:hasExitedMarker', function(zone)
	CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do

			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Marker.DrawD) then --and PlayerData.job.name == ThiefJob) then
				if TimeToggle == true then
					DrawMarker(v.Marker.Type, v.Pos.x, v.Pos.y, v.Pos.z - 0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Marker.Size.x, v.Marker.Size.y, v.Marker.Size.z, v.Marker.Color.r, v.Marker.Color.g, v.Marker.Color.b, v.Marker.Opacity, false, true, 2, false, false, false, false)
					ESX.Game.Utils.DrawText3D(v.Pos, v.text, 0.8)
				else
					ESX.Game.Utils.DrawText3D(v.Pos, 'Tillgänlig igen från 08:00 till 21:00', 0.8)
				end
			end
		end

		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Marker.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('ksrp_mats:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('ksrp_mats:hasExitedMarker', LastZone)
			ESX.UI.Menu.CloseAll()
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		Wait(0)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, Keys['E']) then
				TriggerEvent('ksrp_mats:StartMenu')
			end
		end
	end
end)

-- Create Blip
Citizen.CreateThread(function()

	for k,v in pairs(Config.Zones) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.Blip.Name)
		EndTextCommandSetBlipName(blip)
	end
end)

-- Mats
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if TimeToggle == true then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 594.28, 2744.45, 42.02) < 20.0 then
				if PedIsSpawned == false then
					SpawnPed(1841036427)
				end
			else
				if PedIsSpawned == true then
					RemovePed(Ped)
				end
			end
		end
	end
end)


function SpawnPed(hash)
    modelHash = hash
    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    Wait(200)
    if PedIsSpawned == false then
    	Ped = CreatePed(5, modelHash , 593.13, 2743.89, 42.03 - 0.99, 210.0, false, false)
    	PedIsSpawned = true
    end
    FreezeEntityPosition(Ped, true)
    Wait(200)
    TaskPlayAnim(Ped, "friends@frj@ig_1", "wave_a", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
    Wait(3500)
    TaskStartScenarioInPlace(Ped, 'WORLD_HUMAN_AA_SMOKE')
end

function RemovePed(ped)
	DeleteEntity(ped)
	PedIsSpawned = false
end

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

function sendNotification(message, messageType)
  TriggerEvent("pNotify:SendNotification", {
    text = message,
    type = messageType,
    queue = "esx_phone3",
    timeout = 3000,
    layout = "bottomCenter"
  })
end

RegisterNetEvent('ksrp_mats:TimeToggle')
AddEventHandler('ksrp_mats:TimeToggle', function(status)
	TimeToggle = status
end)

RegisterNetEvent('ksrp_mats:teleportentity')
AddEventHandler('ksrp_mats:teleportentity', function(object, x, y, z)
	SetEntityCoords(object, x, y, z)
end)

