--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
--------------------------------------

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'mysql-async'

server_scripts {
    "server.lua",
    "config.lua",
    "@mysql-async/lib/MySQL.lua",
}
client_scripts {
    "config.lua",
    "client.lua",
    "locations/zones.lua",
}
files {
    "locations/new-postals.json",
    "locations/old-postals.json",
    "locations/ocrp-postals.json"
}