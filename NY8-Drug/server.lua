
ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent("ny8_drogue:donneItem")
AddEventHandler("ny8_drogue:donneItem", function(drug, action, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = Config.Drogues[drug]
    if not data then return end

    local items = data.items
    local prix_feuille = data.prix.feuille or 15
    local prix_traitee = data.prix.traitee or 45
    count = count or 1

    if action == "recolte" then
        xPlayer.addInventoryItem(items.feuille, count)

    elseif action == "traitement" then
        if xPlayer.getInventoryItem(items.feuille).count >= count then
            xPlayer.removeInventoryItem(items.feuille, count)
            xPlayer.addInventoryItem(items.traitee, count)
        end

    elseif action == "vente" then
        if xPlayer.getInventoryItem(items.traitee).count >= count then
            xPlayer.removeInventoryItem(items.traitee, count)
            local total = prix_traitee * count
            if count >= 200 then
                total = math.floor(total * 1.10)
            end
            xPlayer.addAccountMoney('black_money', total)

            local rep = xPlayer.get("reputation_drogues") or 0
            rep = rep + count
            xPlayer.set("reputation_drogues", rep)
            exports.oxmysql:update('UPDATE users SET reputation_drogues = ? WHERE identifier = ?', {rep, xPlayer.identifier})
        end

    elseif action == "vente_feuille" then
        if xPlayer.getInventoryItem(items.feuille).count >= count then
            xPlayer.removeInventoryItem(items.feuille, count)
            local total = prix_feuille * count
            if count >= 200 then
                total = math.floor(total * 1.10)
            end
            xPlayer.addAccountMoney('black_money', total)

            local rep = xPlayer.get("reputation_drogues") or 0
            rep = rep + count
            xPlayer.set("reputation_drogues", rep)
            exports.oxmysql:update('UPDATE users SET reputation_drogues = ? WHERE identifier = ?', {rep, xPlayer.identifier})
        end
    end
end)

RegisterServerEvent("ny8_drogue:demandeReputation")
AddEventHandler("ny8_drogue:demandeReputation", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier

    exports.oxmysql:query('SELECT reputation_drogues FROM users WHERE identifier = ?', {identifier}, function(result)
        local rep = result[1] and result[1].reputation_drogues or 0
        local level = math.floor(rep / 10000)
        local xp = rep % 10000
        xPlayer.set("reputation_drogues", rep)
        TriggerClientEvent("ny8_drogue:openMenuVente", src, level, xp)
    end)
end)
