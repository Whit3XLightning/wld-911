--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
--------------------------------------

--Webhook and 911 command handler
RegisterServerEvent("911:call")
AddEventHandler("911:call", function(postal, street, zone, area, message, coords)
  local so = source
  TriggerClientEvent("911:sendMessage", -1, "911", {255, 0, 0}, "\n^8| Caller ID: ^0"..GetPlayerName(so).."\n^8 | Location: ^0"..postal.." "..street..", "..zone..", "..area..", [SERVER] \n ^8 | Message:^0"..message.."")
  TriggerClientEvent("chatMessage", source, "[DISPATCH]", {255, 0, 0}, "Please stand by, authorities are on the way to your current location.")
  webhook = Config.webhook
  if webhook ~= "" then
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
      username = "911 Caller",
      avatar = "https://cdn.whitelightning.dev/scripts/wld-esx-911/assets/images/avatar.png",
        embeds = {{
            color = 16711680,
            footer = {
              icon_url = "https://whitelightning.dev/assets/logos/wld.png",
              text = "Made for FiveM, with ❤️ by Whit3XLightning | https://whitelightning.dev" --Please don't change :), It makes me happy...
            },
            fields = {
              {
                name = "Discord User",
                value = GetDiscordUserTag(so),
                inline = true
              },
              {
                name = "Player Name",
                value = GetPlayerName(so),
                inline = true
              },
              {
                name = "Location",
                value = "```"..postal.." "..street..", "..zone..", "..area..", "..Config.serverName.."```"
              },
              {
                name = "Message",
                value = "```"..message.."```"
              }
            }
          }},
        content = "<@&"..Config.dispatchRoleId..">"
      })
    ,{ ['Content-Type'] = 'application/json' })
  end
end)

--Check if the player is a cop on join to recive 911 calls
RegisterServerEvent('911:checkcop')
--[[
This event handler is responsible for checking if the player is 
a cop or not, The current emplmentation is the check of the user
has a existing record in a Cops Fivem Database. If that's not what
you use, you will have to modify the script to suit your needs.
During your event handler user TriggerClientEvent("911:PlayerIsCop", so)
to allow the client to recive 911 calls.
]]--
AddEventHandler('911:checkcop', function()
  if config.copWhitelist then
    local so = source
    local steam = GetPlayerIdentifiers(so)[1]
    MySQL.Async.fetchAll('SELECT identifier FROM `police` WHERE `identifier`=@id', {['@id'] = steam}, function(result)
      if result[1] ~= nil then
        TriggerClientEvent("911:PlayerIsCop", so)
      end
    end)
  else 
    TriggerClientEvent("911:PlayerIsCop", so)
  end
end)


--Get the discord username of a player.
function GetDiscordUserTag(source)
	local ids = GetPlayerIdentifiers(source)
	  for i = 1, #ids do
		  if string.find(ids[i], "discord", 1) then
        local discordIdentifier = ids[i]
        local splitId = string.gsub(discordIdentifier, "discord:", "")
        return "<@"..splitId..">"
		end
	end
	return nil
end