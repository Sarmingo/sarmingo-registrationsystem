fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
author 'Sarmingooo#0850'

shared_script {
    '@es_extended/imports.lua',
    '@oxmysql/lib/MySQL.lua',
    'shared/*.lua',
    '@ox_lib/init.lua'
}

server_scripts{
'server/*.lua'
}

client_scripts{
'client/*.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}
