lib.locale()

Ped = {}
AddEventHandler("onResourceStop", function(res)
  if GetCurrentResourceName() == res then
    for i = 1, #Ped do
      DeletePed(Ped[i])
    end
  end
end)

if Config.OxInventory then
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
        displayMetadata()
end)

function displayMetadata()
    exports.ox_inventory:displayMetadata({
        vlasnik  = Config.Notify.Owner,
        tablice = Config.Notify.Plate,
        dani    = Config.Notify.Days2,
        datum  = Config.Notify.Date,
        istek    = Config.Notify.Expiration,
    })
end
end

Citizen.CreateThread(function()
	for _,v in pairs(Config.Ped) do
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
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(v.title)
      EndTextCommandSetBlipName(v.blip)
	  Pedic = CreatePed(4, v.model, v.coords , v.heading, false, true)
	  FreezeEntityPosition(Pedic, true) 
      table.insert(Ped, Pedic)
	  SetEntityInvincible(Pedic, true)
	  SetBlockingOfNonTemporaryEvents(Pedic, true)
      TaskStartScenarioInPlace(Pedic, v.scenario, 0, true)
      exports.qtarget:AddBoxZone('kastm', v.coords, 1, 1, {
        name="kastm",
        heading=0.0,
        debugPoly=false,
        minZ=v.coords.z -1,
        maxZ=v.coords.z +2,
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
if IsPedInAnyVehicle(PlayerPedId(), false) then 
    ESX.TriggerServerCallback('sarmingo-registrationsystem:checkOwnerShip', function(jeste) 
        if jeste then
    local table = {} 
    for k, v in pairs(Config.Registration.values) do
        table[#table + 1] = {
            title = v.label,
            description = Config.Notify.Days.. '' ..v.days.. '' ..Config.Notify.Price.. '' ..v.price.. '$',
			event = "registruj",
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
else
    lib.notify({
        title = Config.Notify.NotValidTitle,
        description = Config.Notify.NotValidDesc,
        type = Config.Notify.NotValidType
    })
end
end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
else
    lib.notify({
        title = Config.Notify.NotInCarTitle,
        description = Config.Notify.NotInCarDesc,
        type = Config.Notify.NotInCarType
    })
end
end)

RegisterNetEvent('registruj', function(sve)
TriggerServerEvent('dajitem', sve.dani, sve.tablice, sve.cijena, sve.money)
end)
