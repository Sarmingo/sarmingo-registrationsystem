Config = {}

Config.OxInventory = false -- put true if you using ox inventory

Config.Ped = {
    {
        model = 's_m_m_dockwork_01',
        coords = vector3(123.8, -1083.92, 28.2), -- position ped and blip
        id = 291, --id of blip
        scale = 0.8, -- blip scale
        colour = 5, -- blip colour
        title = 'Registration', -- blip title
        scenario = 'WORLD_HUMAN_CLIPBOARD_FACILITY',
        heading = 358.88
    },
}

Config.Item = 'registrationdocument'

Config.Registration = {
    values = {
        {label = 'Registration 1 days', price = 100, days = 1,  money = 'money'}, 
        {label = 'Registration 10 days', price = 5000, days = 10,  money = 'money'}, 
        {label = 'Registration 20 days', price = 10000, days = 20, money = 'money'},
        {label = 'Registration 50 days', price = 25000, days = 50, money = 'money'},
        {label = 'Registration 100 days', price = 35000, days = 100, money = 'money'},
        {label = 'Registration 365 days', price = 55000, days = 365, money = 'money'},
    }
}

Config.Notify = {
    TargetLabel = 'Registration',
    TargetIcon = 'fas fa-registered',
    Days = 'Days : ',
    Days2 = 'Days',
    Date = 'Date',
    Plate = 'Plate',
    Owner = 'Owner',
    Expiration = 'Expiration date',
    Price = '\nPrice : ',
    Registrations = 'Registrations :',

    NotInCarTitle = 'Not in a car!',
    NotInCarDesc = 'You have to be in car to acces',
    NotInCarType = 'error',

    NotValidTitle = 'Not valid!',
    NotValidDesc = 'This car is not valid for registration!',
    NotValidType = 'error',

    DontHaveMoney = 'You dont have enough money!'
}
