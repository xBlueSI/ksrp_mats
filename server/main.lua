ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(1000)
-- 		local time		= os.time()
-- 		local h         = tonumber(os.date('%H', timestamp))
-- 		local m         = tonumber(os.date('%M', timestamp))
-- 		local s         = tonumber(os.date('%S', timestamp))

-- 		if h == 21 and m == 00 and s == 0 then

-- 			print('^3ksrp_mats:Toggled TimeToggle to true => Deactivated Mats^7')
-- 			TriggerClientEvent('ksrp_mats:TimeToggle', -1, true)
-- 		end

-- 		if h == 20 and m == 00 and s == 0 then
-- 			TriggerClientEvent('chat:addMessage', -1, 'Mats stänger sina uppdrag om 1 timme!')
-- 		end

-- 		if h == 8 and m == 00 and s == 0 or h == 13 and m == 00 and s == 0 or h == 16 and m == 00 and s == 0 or h == 18 and m == 00 and s == 0 then
-- 			print('^3ksrp_mats:Toggled TimeToggle to true => Activated Mats^7')
-- 			TriggerClientEvent('ksrp_mats:TimeToggle', -1, false)
-- 		end
-- 	end
-- end)

--TriggerClientEvent('chat:addMessage', source, { args = { '^1Du aktiverade biltjuv' } })

RegisterServerEvent('ksrp_mats:teleportentity')
AddEventHandler('ksrp_mats:teleportentity', function(object, x, y, z)
	local xPlayers = ESX.GetPlayers()
	TriggerClientEvent('ksrp_mats:teleportentity', source, x, y, z)
	print('tp')
end)

function getIdentity(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.fetchAll("SELECT identifier, name, firstname, lastname, dateofbirth, sex, height, lastdigits FROM `users` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if result[1].firstname ~= nil then
      local data = {
        identifier  = result[1].identifier,
        name = result[1].name,
        firstname  = result[1].firstname,
        lastname  = result[1].lastname,
        dateofbirth  = result[1].dateofbirth,
        sex      = result[1].sex,
        height    = result[1].height,
        lastdigits = result[1].lastdigits
      }
      callback(data)
    else
      local data = {
        identifier   = '',
        name = '',
        firstname   = '',
        lastname   = '',
        dateofbirth = '',
        sex     = '',
        height     = ''
      }
      callback(data)
    end
  end)
end

RegisterServerEvent('ksrp_mats:GiveMoney')
AddEventHandler('ksrp_mats:GiveMoney', function(money)
  local xPlayer = ESX.GetPlayerFromId(source)
  getIdentity(source, function( data )
  	print(data.firstname .. ' ' .. data.lastname .. ' [' .. data.name .. '] gjorde klart Mats uppdrag. Fick en belöning på '.. money .. 'kr')
  end)
    
  xPlayer.addMoney(money)
	-- xPlayer.addMoney(money)
end)