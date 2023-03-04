RebornCore = nil
TriggerEvent('RebornCore:GetObject', function(obj) RebornCore = obj end)

RebornCore.Commands.Add("911", "Chamar Policial", {{name="Mensagem", help="Descreva seu Chamado"}}, true, function(source, args)
     local Player = RebornCore.Functions.GetPlayer(source)
     local titulo = "Chamado Policial"
     local message = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname..' - '..table.concat(args, " ")
     local idjogador = source

     if Player.Functions.GetItemByName("phone") ~= nil then
          TriggerClientEvent("Reborn:Policial:Reforco", source, titulo,message,idjogador)
          -- TriggerEvent("Reborn:Logs:EnviandoLogs", "911", "911 Report", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..message, false)
          TriggerClientEvent('reborn:notify:send',source, "Policia", "Você chamou a Policia","sucesso", 6000)
     else
          -- TriggerClientEvent('RebornCore:Notify', source, 'You dont have a phone', 'error')
          TriggerClientEvent('reborn:notify:send',source, "Sistema", "Precisa de um Celular","erro", 6000)
     end

 end)

 RebornCore.Commands.Add("901", "Chamar um Paramédico", {{name="Mensagem", help="Descreva seu Chamado"}}, true, function(source, args)
     local Player = RebornCore.Functions.GetPlayer(source)
     local titulo = "Prestar Socorro"
     local idjogador = source
     local message = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname..' - '..table.concat(args, " ")
     -- local message = 'Policial '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname..' Esta ferido e precisando de ajuda'

     if Player.Functions.GetItemByName("phone") ~= nil then
          TriggerClientEvent("Reborn:Emergencia:Dispatch:Chamado", source, titulo,message,idjogador)
          -- TriggerEvent("Reborn:Logs:EnviandoLogs", "911", "911 Report", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..message, false)
          TriggerClientEvent('reborn:notify:send',source, "Hospital", "Você chamou um Paramédico","sucesso", 6000)
     else
          -- TriggerClientEvent('RebornCore:Notify', source, 'You dont have a phone', 'error')
          TriggerClientEvent('reborn:notify:send',source, "Sistema", "Precisa de um Celular","erro", 6000)
     end
 end)



 RebornCore.Commands.Add("cmec", "Chamar Mecanico", {{name="Mensagem", help="Descreva seu Chamado"}}, true, function(source, args)
     local Player = RebornCore.Functions.GetPlayer(source)
     local titulo = "Chamado"
     local idjogador = source
     local message = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname..' - '..table.concat(args, " ")
     -- local message = 'Policial '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname..' Esta ferido e precisando de ajuda'

     if Player.Functions.GetItemByName("phone") ~= nil then
          TriggerClientEvent("Reborn:Mecanico:Dispatch:Chamado", source, titulo,message,idjogador)
          -- TriggerEvent("Reborn:Logs:EnviandoLogs", "911", "911 Report", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..message, false)
          TriggerClientEvent('reborn:notify:send',source, "Sistema", "Você chamou um Mecânico","sucesso", 6000)
     else
          -- TriggerClientEvent('RebornCore:Notify', source, 'You dont have a phone', 'error')
          TriggerClientEvent('reborn:notify:send',source, "Sistema", "Precisa de um Celular","erro", 6000)
     end
 end)

RegisterServerEvent('Reborn:Mecanico:Send:Chamado')
AddEventHandler('Reborn:Mecanico:Send:Chamado', function(coords,titulo,message,idjogador)
    local src = source
    local MainPlayer = RebornCore.Functions.GetPlayer(src)
    local alertData = {
        title = titulo,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        idjogador = idjogador,
        description = message,
    }
    TriggerClientEvent("Reborn:Dispatch:NovoPush:Mecanico", -1, alertData)
    TriggerClientEvent('hospital:server:SendMecanicoMessageCheck', -1, MainPlayer, message, coords)
end)

RegisterServerEvent('Reborn:Chamados:Send:Resultado')
AddEventHandler('Reborn:Chamados:Send:Resultado', function(id)
     TriggerClientEvent('reborn:notify:send',id, "Chamado Atendido", "Aguarde no Local","sucesso", 6000)
end)

RegisterServerEvent('Reborn:Hospital:Send:Pedidos')
AddEventHandler('Reborn:Hospital:Send:Pedidos', function(coords,titulo,message,idjogador)
    local src = source
    local MainPlayer = RebornCore.Functions.GetPlayer(src)
    local alertData = {
        title = titulo,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        idjogador = idjogador,
        description = message,
    }
    TriggerClientEvent("Reborn:Dispatch:NovoPush:Emergencia", -1, alertData)
    TriggerClientEvent('hospital:server:SendEmergencyMessageCheck', -1, MainPlayer, message, coords)
end)