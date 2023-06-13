fx_version 'cerulean'
games { 'gta5' }

author 'Reborn Dispatch'
version '1.0.0'

lua54 'yes'

files {
    'browser/*.html',
    'browser/*.js',
    'browser/*.css',
    'browser/img/*.png',
    'browser/sound/*.ogg',
}

client_scripts {
	'client/*.lua'
}

server_script {
    'server/*.lua',

}

ui_page 'browser/index.html'
