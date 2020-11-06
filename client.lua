--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
--------------------------------------

-- Sends message to server to see if the player is a cop (in database)
AddEventHandler('onClientMapStart', function()
    TriggerServerEvent('911:checkcop')
end)

RegisterCommand('911', function(source, args, RawCommand)
    local message = string.gsub(RawCommand, "911 ", "")
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(),true))
    local area = areas[tostring(GetHashOfMapAreaAtCoords(x, y, z))]
    local zone = zones[GetNameOfZone(x, y, z)]
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x, y, z))
    local coords = vector3(x, y, z)
    TriggerServerEvent("911:call", GetPostal(), street, zone, area, message, coords)
end)

RegisterNetEvent("911:PlayerIsCop")
AddEventHandler("911:PlayerIsCop", function()
    PlayerIsCop = true
end)

RegisterNetEvent('911:sendMessage')
AddEventHandler('911:sendMessage', function(sender, rgb, msg)
    if PlayerIsCop then
        TriggerEvent('chat:addMessage', {color = rgb, multiline = true, args = {sender, msg}})
    end
end)

local raw = LoadResourceFile(GetCurrentResourceName(), 'locations/'..Config.postals..'-postals.json')
local postals = json.decode( raw )
function GetPostal()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    local nearest = nil
    local nd = -1
    local ni = -1
        
    for i, p in ipairs(postals) do
        local d = math.sqrt((x - p.x)^2 + (y - p.y)^2)
            
        if nd == -1 or d < nd then
             ni = i
             nd = d
        end
    end

    if ni ~= -1 then
        nearest = {dist = nd, i = ni}
    end

    return postals[nearest.i].code
end