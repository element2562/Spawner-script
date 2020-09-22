--[[
    Author: Thunderstorm441
    https://github.com/Thunderstorm441/ts_spawnselect
]]--
--CONFIG
-- spawnX, spawnY, spawnZ are the coordinates at which the player will spawn. camX, camY, camZ are the coordinates at which the camera will be. 

local spawnPoints = {
    {name="Mission Row PD", spawnX = 455.82, spawnY = -991.22, spawnZ = 30.69},
    {name="Sandy Shores PD", spawnX = 1850.15, spawnY = 3693.66, spawnZ = 34.26},
    {name="Paleto Bay PD", spawnX = -452.68, spawnY = 6010.41, spawnZ = 31.84},
    {name="Vespucci PD", spawnX = -1097.89, spawnY = -832.04, spawnZ = 14.28},
}

local openOnPlayerSpawned = true --set to false if you do not want the menu to open on first spawn
local hasPlayerAlreadySpawned = false
--END OF CONFIG

--_menuPool = NativeUI.CreatePool()
spawnSelectMenu = RageUI.CreateMenu("Spawn", "Select a spawnpoint")
--_menuPool:Add(spawnSelectMenu)
--_menuPool:ControlDisablingEnabled(true)
-- _menuPool:MouseControlsEnabled(true)

function addLocations(menu)
    for i=1, #spawnPoints do
        --local locationItem = RageUI.Button(spawnPoints[i].name, "Spawn at the " .. spawnPoints[i].name)
        --menu:AddItem(locationItem)
        --menu.OnItemSelect = function(sender, item, index)
        --    if locationItem == item then
        --        spawnPlayer(index)
        --    end
        --end
        RageUI.Button(spawnPoints[i].name , "Spawn at the " .. spawnPoints[i].name, {
            LeftBadge = nil,
            RightBadge = nil,
            RightLabel = nil
        }, true, function(Hovered, Active, Selected)
            if Selected then
               spawnPlayer(i)
            end
        end)
    end
end

function setupPlayer()
    SetEntityVisible(GetPlayerPed(-1), false)
    SetPlayerInvincible(PlayerId(), true)
    FreezeEntityPosition(GetPlayerPed(-1), true) 
    RageUI.Visible(spawnSelectMenu, not spawnSelectMenu:Visible())
end

function spawnPlayer(index)
    hasPlayerAlreadySpawned = true
    local playerPed = GetPlayerPed(-1)
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end
    SetEntityCoords(playerPed, spawnPoints[index].spawnX, spawnPoints[index].spawnY, spawnPoints[index].spawnZ)
    SetEntityVisible(GetPlayerPed(-1), true)
    SetPlayerInvincible(PlayerId(), false)
    FreezeEntityPosition(GetPlayerPed(-1), false) 
    RageUI.CloseAll()
    DoScreenFadeIn(800)
end
RageUI.DrawContent({ header = true, instructionalButton = true }, function()
    addLocations()   
 end)
 RageUI.Menus:RefreshIndex()
--addLocations(spawnSelectMenu)
--_menuPool:RefreshIndex()

AddEventHandler('playerSpawned', function(spawn)
    if openOnPlayerSpawned then
        setupPlayer()
    end
end)
RegisterCommand("spawn", function()
    setupPlayer()
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        --_menuPool:ProcessMenus()
    end
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end