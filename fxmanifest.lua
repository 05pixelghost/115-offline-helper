fx_version 'cerulean'
game 'gta5'

author 'Farm Market'
description 'Farming & Livestock Market (BUY / SELL)'
lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/app.js'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qb-core',
    'qb-target',
    'ox_inventory'
}

lua54 'yes'