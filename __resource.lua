resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_script {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locates/sv.lua',
	'locates/en.lua',
	'config.lua',
	'server/main.lua'
}

client_script {
	'@es_extended/locale.lua',
	'locates/sv.lua',
	'locates/en.lua',
	'config.lua',
	'client/main.lua',
	'client/mats.lua'
}

