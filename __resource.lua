resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

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