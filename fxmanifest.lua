fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
author 'Sarmingooo#0850'

shared_script {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'shared/config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_script 'client/main.lua'

dependencies {
    'ox_lib',
    'oxmysql'
}
