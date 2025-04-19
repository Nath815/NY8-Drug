ESX = exports['es_extended']:getSharedObject()

local menuOpened = false
local cam = nil
local mainPNJ = nil

CreateThread(function()
    local firstDrug = next(Config.Drogues)
    local pedCoords = Config.Drogues[firstDrug].zones.vente

    RequestModel(Config.PNJ.model)
    while not HasModelLoaded(Config.PNJ.model) do Wait(10) end
    mainPNJ = CreatePed(4, Config.PNJ.model, pedCoords.x, pedCoords.y, pedCoords.z - 1, Config.PNJ.heading, false, true)
    FreezeEntityPosition(mainPNJ, true)
    SetEntityInvincible(mainPNJ, true)
    SetBlockingOfNonTemporaryEvents(mainPNJ, true)
    TaskStartScenarioInPlace(mainPNJ, Config.PNJ.scenario, 0, true)

    exports.ox_target:addLocalEntity(mainPNJ, {
        {
            label = "💬 Parler au vendeur",
            icon = "fas fa-comment",
            onSelect = function(data)
                if not menuOpened then
                    StartCinematicCam(mainPNJ)
                    TriggerServerEvent("ny8_drogue:demandeReputation")
                end
            end
        }
    })
end)

RegisterNetEvent("ny8_drogue:openMenuVente", function(level, progress)
    menuOpened = true

    local options = {
        {
            title = ('🧠 XP / NIVEAU : %s (%s/10000)'):format(level, progress),
            disabled = true
        },
        {
            title = "🧪 Meth (feuille)",
            icon = "leaf",
            onSelect = function(data)
                local input = lib.inputDialog("Combien veux-tu vendre ?", {
                    {type = "number", label = "Quantité", default = 1}
                })
                if input and tonumber(input[1]) then
                    StopCinematicCam()
                    menuOpened = false
                    TriggerServerEvent("ny8_drogue:donneItem", "meth", "vente_feuille", tonumber(input[1]))
                end
            end
        },
        {
            title = "⚗️ Meth (traitée)",
            icon = "flask",
            onSelect = function(data)
                local input = lib.inputDialog("Combien veux-tu vendre ?", {
                    {type = "number", label = "Quantité", default = 1}
                })
                if input and tonumber(input[1]) then
                    StopCinematicCam()
                    menuOpened = false
                    TriggerServerEvent("ny8_drogue:donneItem", "meth", "vente", tonumber(input[1]))
                end
            end
        },
        {
            title = "🌿 Weed (feuille)",
            icon = "leaf",
            onSelect = function(data)
                local input = lib.inputDialog("Combien veux-tu vendre ?", {
                    {type = "number", label = "Quantité", default = 1}
                })
                if input and tonumber(input[1]) then
                    StopCinematicCam()
                    menuOpened = false
                    TriggerServerEvent("ny8_drogue:donneItem", "weed", "vente_feuille", tonumber(input[1]))
                end
            end
        },
        {
            title = "💨 Weed (traitée)",
            icon = "flask",
            onSelect = function(data)
                local input = lib.inputDialog("Combien veux-tu vendre ?", {
                    {type = "number", label = "Quantité", default = 1}
                })
                if input and tonumber(input[1]) then
                    StopCinematicCam()
                    menuOpened = false
                    TriggerServerEvent("ny8_drogue:donneItem", "weed", "vente", tonumber(input[1]))
                end
            end
        },
        {
            title = "📱 Coke (feuille)",
            icon = "leaf",
            onSelect = function(data)
                local input = lib.inputDialog("Combien veux-tu vendre ?", {
                    {type = "number", label = "Quantité", default = 1}
                })
                if input and tonumber(input[1]) then
                    StopCinematicCam()
                    menuOpened = false
                    TriggerServerEvent("ny8_drogue:donneItem", "coke", "vente_feuille", tonumber(input[1]))
                end
            end
        },
        {
            title = "💎 Coke (traitée)",
            icon = "flask",
            onSelect = function(data)
                local input = lib.inputDialog("Combien veux-tu vendre ?", {
                    {type = "number", label = "Quantité", default = 1}
                })
                if input and tonumber(input[1]) then
                    StopCinematicCam()
                    menuOpened = false
                    TriggerServerEvent("ny8_drogue:donneItem", "coke", "vente", tonumber(input[1]))
                end
            end
        }
    }

    lib.registerContext({
        id = 'ny8_drogue_menu',
        title = 'Vendeur de Drogues',
        options = options,
        onExit = function()
            menuOpened = false
            StopCinematicCam()
        end
    })

    lib.showContext('ny8_drogue_menu')
end)

function StartCinematicCam(entity)
    if cam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)
        cam = nil
    end

    local bone = GetPedBoneCoords(entity, 31086, 0.0, 0.0, 0.2)
    local camCoords = GetOffsetFromEntityInWorldCoords(entity, 0.8, 0.8, 0.7)

    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtCoord(cam, bone.x, bone.y, bone.z)
    SetCamFov(cam, 50.0)
    RenderScriptCams(true, false, 0, true, true)
end

function StopCinematicCam()
    if cam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
end

-- (Les fonctions plus haut sont inchangées)

local function SpawnZoneProps()
    for drug, data in pairs(Config.Drogues) do
        if data.zones.recolte then
            local plant = CreateObject(GetHashKey("prop_plant_01a"), data.zones.recolte.x, data.zones.recolte.y, data.zones.recolte.z - 1.0, false, false, false)
            SetEntityHeading(plant, data.zones.recolte.w)
            FreezeEntityPosition(plant, true)

            exports.ox_target:addLocalEntity(plant, {
                {
                    label = "🌿 Récolter " .. data.label,
                    icon = "leaf",
                    onSelect = function(data)
                        local quantity = math.random(3, 10)
                        TaskStartScenarioInPlace(PlayerPedId(), Config.Animation.Recolte, 0, true)
                        Wait(1500)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("ny8_drogue:donneItem", drug, "recolte", quantity)
                        lib.notify({
                            title = "Récolte",
                            description = "Tu as récolté " .. quantity .. " feuilles de " .. drug,
                            type = "success"
                        })
                    end
                }
            })
        end

        if data.zones.traitement then
            local table = CreateObject(GetHashKey("prop_table_03b"), data.zones.traitement.x, data.zones.traitement.y, data.zones.traitement.z - 1.0, false, false, false)
            SetEntityHeading(table, data.zones.traitement.w)
            FreezeEntityPosition(table, true)

            exports.ox_target:addLocalEntity(table, {
                {
                    label = "⚗️ Traiter " .. data.label,
                    icon = "flask",
                    onSelect = function(data)
                        local quantity = math.random(10, 20)
                        TaskStartScenarioInPlace(PlayerPedId(), Config.Animation.Traitement, 0, true)
                        Wait(1500)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("ny8_drogue:donneItem", drug, "traitement", quantity)
                        lib.notify({
                            title = "Traitement",
                            description = "Tu as traité " .. quantity .. " feuilles de " .. drug,
                            type = "success"
                        })
                    end
                }
            })
        end
    end
end

CreateThread(function()
    Wait(1000)
    SpawnZoneProps()
end)