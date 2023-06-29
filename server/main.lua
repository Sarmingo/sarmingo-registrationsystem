RegisterServerEvent('dajitem', function(dani, tablice, price, money)
            local xPlayer = ESX.GetPlayerFromId(source)
    local updateQuery = 'UPDATE owned_vehicles SET date_expiried = ?, registered = ? WHERE plate = ?'
    local updateRegistration = MySQL.update.await(updateQuery,
        {
            os.date('%Y-%m-%d', os.time() + (dani * 24 * 60 * 60)),
            'yes',
            tablice
        })

    if not updateRegistration and Config.Debug then
        print('[^1' .. GetCurrentResourceName() .. '^7] Failed to update registration for plate: ' .. tablice)
        return
    end

    xPlayer.removeAccountMoney(money, price)

    if not Config.OxInventory then
        xPlayer.addInventoryItem(Config.Item, 1)
        return
    end

        exports.ox_inventory:AddItem(xPlayer.source, Config.Item, 1, {vlasnik = xPlayer.getName(), tablice = tablice, dani = dani, datum = os.date('%Y-%m-%d'), istek = os.date('%Y-%m-%d', os.time() + (dani * 24 * 60 * 60))})
end)

ESX.RegisterServerCallback('provjeri:reg', function(source, cb, tablice)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @tablice AND registered = "yes"', {
        ['@tablice'] = tablice
    }, function(result)
        if result and #result > 0 then
            local dateExpired = os.date('%Y-%m-%d', tonumber(result[1].date_expiried) / 1000)
            cb({datum = dateExpired})
        else
            cb(false)
        end
    end)
end)


CreateThread(function()
    local registeredVehiclesCount = MySQL.scalar.await('SELECT COUNT(*) FROM owned_vehicles WHERE `registered` = ?', {'yes'})
    registeredVehiclesCount = registeredVehiclesCount and tonumber(registeredVehiclesCount) or 0

    if registeredVehiclesCount == 0 then
        print('[^1' .. GetCurrentResourceName() .. '^7] Script successfully run! There are no registered vehicles.')
        return
    end

    print('[^1' .. GetCurrentResourceName() .. '^7] Script successfully run! Loaded ' .. registeredVehiclesCount .. ' registered vehicles.')
end)

ESX.RegisterServerCallback('sarmingo-registrationsystem:checkOwnerShip', function(source, cb, plate)
    MySQL.query('SELECT registered FROM owned_vehicles WHERE plate = ?', {plate}, function(result)
        if result then
            for i = 1, #result do
                local row = result[i]
                if row.registered == 'not' then
                    cb(true)
                else
                    cb(false)
                end
            end
        end
    end)
end)

CreateThread(function()
    while true do
        local success = MySQL.update.await('UPDATE owned_vehicles SET registered = ?, date_expiried = ? WHERE registered != ? AND date_expiried IS NOT NULL AND date_expiried <= CURDATE()', {'not', nil, 'not'})
        if success and Config.Debug then
            print('[^1' .. GetCurrentResourceName() .. '^7] Successfully updated.')
        end
        Wait(10000)
    end
end)
