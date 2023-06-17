Ped = {}
AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() == res then
        for i = 1, #Ped do
            DeletePed(Ped[i])
        end
    end
end)

if Config.OxInventory then
CreateThread(function()
        exports.ox_inventory:displayMetadata({
            vlasnik = Config.Notify.Owner,
            tablice = Config.Notify.Plate,
            dani    = Config.Notify.Days2,
            datum   = Config.Notify.Date,
            istek   = Config.Notify.Expiration,
        })
    end)
end

CreateThread(function()
    for _, v in pairs(Config.Ped) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1)
        end
        v.blip = AddBlipForCoord(v.coords)
        SetBlipSprite(v.blip, v.id)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, v.scale)
        SetBlipColour(v.blip, v.colour)
        SetBlipAsShortRange(v.blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.title)
        EndTextCommandSetBlipName(v.blip)
        Pedic = CreatePed(4, v.model, v.coords, v.heading, false, true)
        FreezeEntityPosition(Pedic, true)
        table.insert(Ped, Pedic)
        SetEntityInvincible(Pedic, true)
        SetBlockingOfNonTemporaryEvents(Pedic, true)
        TaskStartScenarioInPlace(Pedic, v.scenario, 0, true)
        exports.qtarget:AddBoxZone('sarmingo-registracija', v.coords, 1, 1, {
            name = 'sarmingo-registracija',
            heading = 0.0,
            debugPoly = false,
            minZ = v.coords.z - 1,
            maxZ = v.coords.z + 2,
        }, {
            options = {
                {
                    event = 'registracija',
                    icon = Config.Notify.TargetIcon,
                    label = Config.Notify.TargetLabel,
                },
            },
            distance = 3.5
        })
    end
end)

RegisterNetEvent('registracija', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        lib.notify({
            title = Config.Notify.NotInCarTitle,
            description = Config.Notify.NotInCarDesc,
            type = Config.Notify.NotInCarType
        })
        return
    end

    ESX.TriggerServerCallback('sarmingo-registrationsystem:checkOwnerShip', function(jeste)
        if not jeste then
            lib.notify({
                title = Config.Notify.NotValidTitle,
                description = Config.Notify.NotValidDesc,
                type = Config.Notify.NotValidType
            })
            return
        end

        local table = {}
        for k, v in pairs(Config.Registration.values) do
            table[#table + 1] = {
                title = v.label,
                description = Config.Notify.Days .. '' .. v.days .. '' ..
                Config.Notify.Price .. '' .. v.price .. '$',
                event = 'registruj',
                args = {
                    dani = v.days,
                    cijena = v.price,
                    money = v.money,
                    tablice = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)),
                }
            }
            lib.registerContext({
                id = 'example_menu1',
                title = Config.Notify.Registrations,
                options = table
            })
            lib.showContext('example_menu1')
        end
    end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
end)

RegisterNetEvent('registruj', function(sve)
    TriggerServerEvent('dajitem', sve.dani, sve.tablice, sve.cijena, sve.money)
end)

RegisterCommand(Config.CommandForCheckRegistration, function ()
    local coords    = GetEntityCoords(PlayerPedId())

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        tablice = GetVehicleNumberPlateText(GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71))
        ESX.TriggerServerCallback('provjeri:reg', function(registrovano)
            if registrovano then
                ESX.ShowNotification(Config.Notify.VehicleRegisteredTo.. '' ..registrovano.datum)
            else
                ESX.ShowNotification(Config.Notify.VehicleNotFoundOrNotRegistered)
            end
        end, tablice)
    else
        ESX.ShowNotification(Config.Notify.NotVehicleInNearby)
    end
end)

