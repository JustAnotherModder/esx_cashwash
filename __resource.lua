-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependency 'essentialmode'

client_script {
    'client/main.lua',
	'client/GUI.lua'
}

server_scripts {
	'server/main.lua'
}