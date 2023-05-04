lib.locale()

RegisterServerEvent('dajitem', function(dani, tablice, price, money)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE owned_vehicles SET date_expiried = @date_expiried, registered = 'yes' WHERE plate = @plate", {
		['@date_expiried'] = os.date("%Y-%m-%d", os.time() + (dani * 24 * 60 * 60)),
		['@plate'] = tablice
	}, function()
	end)
	xPlayer.removeAccountMoney(money, price)
	if not Config.OxInventory then
	xPlayer.addInventoryItem(Config.Item, 1)
	    else
	exports.ox_inventory:AddItem(source, Config.Item, 1,
	{vlasnik = xPlayer.getName(), tablice = tablice, dani = dani, datum = os.date("%Y-%m-%d"), istek = os.date("%Y-%m-%d", os.time() + (dani * 24 * 60 * 60))})
	end
end)

Citizen.CreateThread(function()
	local count = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM owned_vehicles WHERE `registered` = 'yes'")
  
	if count > 0 then 
	print("[^1"..GetCurrentResourceName().."^7] Script successfully run | Loaded registered : " ..count.. " vehicles")
	else 
	  print("[^1"..GetCurrentResourceName().."^7] Script successfully run | There are no registered vehicles")
	end
  end)




ESX.RegisterServerCallback('sarmingo-registrationsystem:checkOwnerShip', function(source, cb, plate) 
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT registered FROM owned_vehicles WHERE plate = @plate', { ['@plate'] = plate }, function(data)
		if(data[1] ~= nil and data[1]['registered'] == 'not') then
			cb(true) 
		else
			cb(false)
		end
	end)
end)


Citizen.CreateThread(function()
    while true do
		MySQL.Async.execute("UPDATE owned_vehicles SET registered = 'not', date_expiried = NULL WHERE registered != 'not' AND date_expiried IS NOT NULL AND date_expiried <= CURDATE()", {}, function()
		end)
        Citizen.Wait(10000)
    end
end)
