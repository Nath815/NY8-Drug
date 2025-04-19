fx_version 'cerulean'
lua54 'yes'
game 'gta5'

description 'Script drogue ESX avec PNJ unique, caméra cinématique, et système de réputation'
author 'nath_815'

shared_script 'config.lua'

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_script 'server.lua'

dependencies {
    'ox_lib',
    'es_extended'
}