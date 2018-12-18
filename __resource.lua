description 'ESX Drugs CNX Rewrite'

version '0.0.1'

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'server/server.lua',
	'config.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'client/client.lua',
	'config.lua'
}
