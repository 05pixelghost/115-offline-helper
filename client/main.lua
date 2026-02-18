local QBCore = exports['qb-core']:GetCoreObject()

local currentShop = nil
local currentType = nil

-- ================= SPAWN NPC + TARGET =================
CreateThread(function()
    for _, v in pairs(Config.NPC) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do Wait(0) end

        local ped = CreatePed(
            0,
            v.ped,
            v.coords.x, v.coords.y, v.coords.z - 1,
            v.coords.w,
            false, true
        )

        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports['qb-target']:AddTargetEntity(ped, {
            options = {{
                label = v.label,
                action = function()
                    OpenMarket(v.shopType, v.uiType)
                end
            }},
            distance = 2.0
        })
    end
end)

-- ================= CREATE BLIPS =================
CreateThread(function()
    for _, v in pairs(Config.NPC) do
        local blipCfg = Config.Blips[v.shopType]
        if blipCfg then
            local blip = AddBlipForCoord(
                v.coords.x,
                v.coords.y,
                v.coords.z
            )

            SetBlipSprite(blip, blipCfg.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, blipCfg.scale or 0.8)
            SetBlipColour(blip, blipCfg.color or 0)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipCfg.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)



-- ================= OPEN MARKET =================
function OpenMarket(shopType, uiType)
    currentShop = shopType
    currentType = uiType

    SetNuiFocus(true, true)

    if uiType == 'buy' then
        SendNUIMessage({
            action = 'open',
            type = 'buy',
            items = BuildBuyItems(shopType)
        })
    else
        RefreshSellItems()
    end
end

-- ================= BUILD BUY ITEMS =================
function BuildBuyItems(shopType)
    local items = {}

    for _, v in pairs(Config.BuyItems[shopType] or {}) do
        items[#items + 1] = {
            name  = v.name,
            label = v.label,
            price = v.price,
            image = 'nui://ox_inventory/web/images/' .. v.name .. '.png'
        }
    end

    return items
end

-- ================= REFRESH SELL ITEMS (REALTIME) =================
function RefreshSellItems()
    if currentType ~= 'sell' or not currentShop then return end

    QBCore.Functions.TriggerCallback(
        'qb-farmmarket:server:getSellItems',
        function(items)
            SendNUIMessage({
                action = 'open',
                type = 'sell',
                items = items or {}
            })
        end,
        currentShop
    )
end

RegisterNetEvent('qb-farmmarket:client:refreshSell', RefreshSellItems)

-- ================= NUI CALLBACK =================
RegisterNUICallback('actionItem', function(data, cb)
    TriggerServerEvent('qb-farmmarket:server:action', {
        item = data.item,
        qty  = tonumber(data.qty) or 1,
        type = data.type
    })
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
