local particleDict = 'scr_indep_fireworks'
local startedFireworks = false
local fireworksLockdown = false
local dicts = {
    'proj_indep_firework',
    'proj_indep_firework_v2',
    'proj_xmas_firework',
    'scr_rcpaparazzo1',
}

-- Load all of the particle dicts
Citizen.CreateThread(function()
    for k,v in pairs(Config.FireworkTypes) do
        RequestNamedPtfxAsset(k)
        while not HasNamedPtfxAssetLoaded(k) do
            Wait(1)
        end
    end
    print('All particle dicts are loaded!')
end)

RegisterCommand('startfireworks', function(src, args)
    if not startedFireworks and not fireworksLockdown then
        startedFireworks = true
        StartCooldown()

        local currCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.0)
        ExecuteCommand('e mechanic4')
        Wait(3000)
        ExecuteCommand('e c')

        CreateSyncedFirework(currCoords, particleDict, 6, 0.1)
        Wait(4500)

        -- Create the fountain
        Citizen.CreateThread(function()
            for i=0, 14 do
                CreateSyncedFirework(currCoords, particleDict, 6, 0.4)
                Wait(4500)
            end
        end)

        -- Send out the first firework to start her off
        CreateSyncedFirework(currCoords, 'scr_indep_fireworks', math.random(1, 2), math.random(5, 12) * 0.1)
        Wait(1500)

        -- Create the shooters
        Citizen.CreateThread(function()
            for i=0, 60 do
                CreateSyncedFirework(currCoords, 'scr_indep_fireworks', math.random(1, 2), math.random(5, 12) * 0.1)

                local newCoords = vector3(currCoords.x + Randomize(), currCoords.y + Randomize(), currCoords.z + Config.BurstHeight + Randomize())
                local newDict = dicts[math.random(1, #dicts)]
                CreateSyncedFirework(newCoords, newDict, math.random(1, #Config.FireworkTypes[newDict]), math.random(5, 12) * 0.1)
                
                Wait(math.random(600, 1000))
            end
        end)
    end
end)

-- Handler for the big show
StartBigShow = function(currCoords)
    -- Run the function async so big show can happen at multiple locations
    Citizen.CreateThread(function()
        if bigShowRunning then
            -- Create the fountain
            Citizen.CreateThread(function()
                for i=0, 3 do
                    CreateFirework(currCoords, particleDict, 6, 0.4)
                    Wait(4500)
                end
            end)

            -- Send out the first firework to start her off
            CreateFirework(currCoords, 'scr_indep_fireworks', math.random(1, 2), math.random(5, 12) * 0.1)
            Wait(1500)

            -- Run these fireworks in sync so we don't start spamming fireworks everywhere
            for i=0, 12 do
                CreateFirework(currCoords, 'scr_indep_fireworks', math.random(1, 2), math.random(5, 12) * 0.1)

                for i=0,1 do
                    local newCoords = vector3(currCoords.x + Randomize(), currCoords.y + Randomize(), currCoords.z + Config.BurstHeight + Randomize())
                    local newDict = dicts[math.random(1, #dicts)]
                    CreateFirework(newCoords, newDict, math.random(1, #Config.FireworkTypes[newDict]), math.random(5, 12) * 0.1)
                    Wait(math.random(30,70))
                end

                Wait(math.random(600, 1000))
            end

            StartBigShow(currCoords)
        else
            -- Grand Finale
            Citizen.CreateThread(function()
                for i=0, 5 do
                    CreateFirework(currCoords, particleDict, 6, 0.4)
                    Wait(4500)
                end
            end)

            -- Run these fireworks in sync so we don't start spamming fireworks everywhere
            for i=0, 110 do
                CreateFirework(currCoords, 'scr_indep_fireworks', math.random(1, 2), math.random(5, 12) * 0.1)

                for i=0,1 do
                    local newCoords = vector3(currCoords.x + Randomize(), currCoords.y + Randomize(), currCoords.z + Config.BurstHeight + Randomize())
                    local newDict = dicts[math.random(1, #dicts)]
                    CreateFirework(newCoords, newDict, math.random(1, #Config.FireworkTypes[newDict]), math.random(5, 12) * 0.1)
                    Wait(math.random(30,70))
                end

                Wait(math.random(50, 150))
            end
        end
    end)
end

-- Function to create firework to simplify things

CreateSyncedFirework = function(coords, lib, num, size)
    UseParticleFxAssetNextCall(lib)
    SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle = StartNetworkedParticleFxNonLoopedAtCoord(Config.FireworkTypes[lib][num], coords, 0.0, 0.0, 0.0, size, false, false, false)
end

CreateFirework = function(coords, lib, num, size)
    UseParticleFxAssetNextCall(lib)
    SetParticleFxNonLoopedColour(math.random(), math.random(), math.random())
    local particle = StartParticleFxNonLoopedAtCoord(Config.FireworkTypes[lib][num], coords, 0.0, 0.0, 0.0, size, false, false, false)
end

StartCooldown = function()
    Citizen.CreateThread(function()
        Wait(Config.CooldownTime * 60 * 1000)
        startedFireworks = false
    end)
end

Randomize = function()
    local num = math.random(4,12)

    -- Chance to make it odd
    local chance = math.random(0,1)
    if chance == 0 then
        num = num * -1
    end

    return num
end

RegisterNetEvent('ops-fireworks:client:ReceiveLockdownStatus', function(status)
    fireworksLockdown = status
end)

RegisterNetEvent('ops-fireworks:client:ReceiveLockdownStatus', function(status)
    fireworksLockdown = status
end)

RegisterNetEvent('ops-fireworks:server:startBigShow', function(coordsTable)
    bigShowRunning = true

    for k,v in pairs(coordsTable) do
        Wait(math.random(1,10))
        CreateFirework(v, particleDict, 6, 0.1)
    end

    Wait(4500)

    for k,v in pairs(coordsTable) do
        Wait(math.random(1,10))
        StartBigShow(v)
    end
end)

RegisterNetEvent('ops-fireworks:server:addCoordToShow', function(coords)
    if bigShowRunning then
        CreateFirework(coords, particleDict, 6, 0.1)
        Wait(4500)
        StartBigShow(coords)
    end
end)

RegisterNetEvent('ops-fireworks:server:stopBigShow', function()
    bigShowRunning = false
end)

AddEventHandler('onResourceStop', function()
    for k,v in pairs(Config.FireworkTypes) do
        RemoveNamedPtfxAsset(k)
    end
end)
