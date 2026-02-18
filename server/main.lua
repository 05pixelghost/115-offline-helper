local QBCore = exports['qb-core']:GetCoreObject()

local function Notify(src, msg, type)
    TriggerClientEvent('QBCore:Notify', src, msg, type or 'error')
end

-- ================= SELL CALLBACK =================
QBCore.Functions.CreateCallback('qb-farmmarket:server:getSellItems', function(source, cb, shopType)
    local src = source
    local items = {}

    if not Config.SellItems[shopType] then
        cb({})
        return
    end

    for item, price in pairs(Config.SellItems[shopType]) do
        local count = exports.ox_inventory:GetItemCount(src, item)

        if count > 0 then
            local data = exports.ox_inventory:Items(item)

            items[#items + 1] = {
                name   = item,
                label  = data and data.label or item,
                image  = 'nui://ox_inventory/web/images/' .. item .. '.png',
                amount = count,
                price  = price
            }
        end
    end

    cb(items)
end)

-- ================= BUY / SELL ACTION =================
RegisterNetEvent('qb-farmmarket:server:action', function(data)
    local src  = source
    local item = data.item
    local qty  = tonumber(data.qty) or 1
    local type = data.type

    if qty < 1 then return end

    -- ===== BUY =====
    if type == 'buy' then
        local price = GetBuyPrice(item)
        if not price then return end

        local total = price * qty

        if not exports.ox_inventory:RemoveItem(src, 'money', total) then
            Notify(src, 'Uang tidak cukup', 'error')
            return
        end

        exports.ox_inventory:AddItem(src, item, qty)
        Notify(src, 'Berhasil membeli item', 'success')
        return
    end

    -- ===== SELL =====
    if type == 'sell' then
        local price = GetSellPrice(item)
        if not price then return end

        local owned = exports.ox_inventory:GetItemCount(src, item)

        if owned < qty then
            Notify(src, 'Jumlah item tidak mencukupi', 'error')
            return
        end

        exports.ox_inventory:RemoveItem(src, item, qty)
        exports.ox_inventory:AddItem(src, 'money', price * qty)

        Notify(src, 'Item berhasil dijual', 'success')

        -- 🔥 REALTIME REFRESH
        TriggerClientEvent('qb-farmmarket:client:refreshSell', src)
    end
end)

-- ================= PRICE HELPERS =================
function GetSellPrice(item)
    for _, list in pairs(Config.SellItems) do
        if list[item] then
            return list[item]
        end
    end
    return nil
end

function GetBuyPrice(item)
    for _, list in pairs(Config.BuyItems) do
        for _, v in pairs(list) do
            if v.name == item then
                return v.price
            end
        end
    end
    return nil
end
