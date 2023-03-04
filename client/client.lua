RebornCore = nil

Citizen.CreateThread(function() 
    while RebornCore == nil do
        TriggerEvent("RebornCore:GetObject", function(obj) RebornCore = obj end)
        Citizen.Wait(200)
    end
end)

RegisterCommand('dispatch',function(source,args,rawCommand)
     RebornCore.Functions.GetPlayerData(function(PlayerData)
          if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'doctor' or PlayerData.job.name == 'mechanic' then
               local jogador1 = PlayerPedId()
               SendNUIMessage({
                    action = "AbrirAlertas"
               })
               SetNuiFocus(true,true)
               TriggerEvent('reborn-hud:toggle')
          end
    end)
end)

RegisterNetEvent('RebornCore:Client:OnPlayerLoaded')
AddEventHandler('RebornCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('Reborn:Dispatch:NovoAlertaOpen')
AddEventHandler('Reborn:Dispatch:NovoAlertaOpen', function(alertData)
     if isLoggedIn then
          RebornCore.Functions.GetPlayerData(function(PlayerData)
               if PlayerData.job.name == 'police' and PlayerData.job.onduty then
                    SendNUIMessage({
                    action = "UpdateAlertas",
                    alerta = alertData,
                    })
               end
          end)
     end 
end)

RegisterNetEvent('Reborn:Dispatch:NovoPush')
AddEventHandler('Reborn:Dispatch:NovoPush', function(alertData)
     if isLoggedIn then
          RebornCore.Functions.GetPlayerData(function(PlayerData)
               if PlayerData.job.name == 'police' and PlayerData.job.onduty then
                    SendNUIMessage({
                         action = "PushAlerta",
                         alerta = alertData,
                    })
                    --  SendNUIMessage({
                    --      action = "UpdateAlertas",
                    --      alerta = alertData,
                    --  })
               end
          end)
     end
end)

RegisterNetEvent('Reborn:Dispatch:NovoPush:Mecanico')
AddEventHandler('Reborn:Dispatch:NovoPush:Mecanico', function(alertData)
     if isLoggedIn then
          RebornCore.Functions.GetPlayerData(function(PlayerData)
               if PlayerData.job.name == 'mechanic' and PlayerData.job.onduty then
                    SendNUIMessage({
                         action = "PushAlerta",
                         alerta = alertData,
                    })
               end
          end)
     end
end)


RegisterNetEvent('Reborn:Dispatch:NovoPush:Emergencia')
AddEventHandler('Reborn:Dispatch:NovoPush:Emergencia', function(alertData)
     if isLoggedIn then
          RebornCore.Functions.GetPlayerData(function(PlayerData)
               if (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'doctor') and PlayerData.job.onduty then
                    SendNUIMessage({
                         action = "PushAlerta",
                         alerta = alertData,
                    })
               end
          end)
      end
end)

RegisterNetEvent('Reborn:Mecanico:Dispatch:Chamado')
AddEventHandler('Reborn:Mecanico:Dispatch:Chamado', function(titulo,message,idjogador)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    TriggerEvent("police:client:CallAnim")
    Wait(1500)
    TriggerServerEvent("Reborn:Mecanico:Send:Chamado", coords,titulo, message,idjogador)
end)

RegisterNetEvent('Reborn:Emergencia:Dispatch:Chamado')
AddEventHandler('Reborn:Emergencia:Dispatch:Chamado', function(titulo,message,idjogador)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    TriggerEvent("police:client:CallAnim")
    Wait(1500)
    TriggerServerEvent("Reborn:Hospital:Send:Pedidos", coords,titulo, message,idjogador)
end)


RegisterNUICallback('SetarWaypoint', function(data)
     TriggerEvent('Reborn:Dispatch:SetWaypoint',data)
     TriggerServerEvent('Reborn:Chamados:Send:Resultado',data.alert.idjogador)
end)

RegisterNUICallback('FecharDispatch', function()
     SetNuiFocus(false,false)
     TriggerEvent('reborn-hud:toggle')
end)