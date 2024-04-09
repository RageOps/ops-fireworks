local showCoords = {}

RegisterNetEvent('ops-fireworks:server:addCoordToShow', function()
    local src = source

end)

RegisterCommand('lockdownfireworks', function(source, args, raw)
    TriggerClientEvent('ops-fireworks:client:ReceiveLockdownStatus', -1, true)
end, true)

RegisterCommand('unlockfireworks', function(source, args, raw)
    TriggerClientEvent('ops-fireworks:client:ReceiveLockdownStatus', -1, false)
end, true)

RegisterCommand('addcoordtoshow', function(source, args, raw)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    table.insert(showCoords, coords)
    TriggerClientEvent('ops-fireworks:client:addCoordToShow', -1, coords)
end, true)

RegisterCommand('startbigshow', function(source, args, raw)
    TriggerClientEvent('ops-fireworks:client:startBigShow', -1, showCoords)
end, true)

RegisterCommand('stopbigshow', function(source, args, raw)
    TriggerClientEvent('ops-fireworks:client:stopBigShow', -1)
end, true)

RegisterCommand('clearshow', function(source, args, raw)
    showCoords = {}
end, true)