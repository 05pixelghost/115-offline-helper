Config = {}

-- ================= NPC =================
Config.NPC = {
    {
        shopType = 'farming_buy',
        uiType   = 'buy',
        label    = 'Beli Keperluan Pertanian',
        ped      = `a_m_m_farmer_01`,
        coords   = vec4(2416.28, 4994.03, 46.24, 141.2)
    },
    {
        shopType = 'farming_sell',
        uiType   = 'sell',
        label    = 'Jual Hasil Tani',
        ped      = `a_m_m_fatlatin_01`,
        coords   = vec4(2335.52, 4859.84, 41.81, 224.64)
    },
    {
        shopType = 'livestock_buy',
        uiType   = 'buy',
        label    = 'Beli Keperluan Peternakan',
        ped      = `a_m_m_hillbilly_01`,
        coords   = vec4(-17.25, 6303.49, 31.37, 32.52)
    },
    {
        shopType = 'livestock_sell',
        uiType   = 'sell',
        label    = 'Jual Hasil Ternak',
        ped      = `a_m_m_salton_02`,
        coords   = vec4(-114.38, 6213.08, 31.46, 54.28)
    }
}

-- ================= BUY ITEMS =================
Config.BuyItems = {
    farming_buy = {
        { name = 'wheat_seed', label = 'Wheat Seed', price = 15 },
        { name = 'carrot_seed',label = 'Carrot Seed', price = 20 },
        { name = 'corn_seed',  label = 'Corn Seed',  price = 18 },
        { name = 'wateringcan',label = 'Watering Can',     price = 20 },
        { name = 'fertilizer', label = 'Fertilizer', price = 25 },
        { name = 'shovel',     label = 'Shovel',     price = 20 },
        { name = 'sickle',     label = 'Sickle',     price = 20 },
    },
    livestock_buy = {
        { name = 'chicken',         label = 'Chicken',       price = 200 },
        { name = 'cow',             label = 'Cow',           price = 500 },
        { name = 'cow_feed', label = 'Cow Feed', price = 60 },
        { name = 'chicken_feed',    label = 'Chicken Feed',  price = 40 },
        { name = 'milking_machine',    label = 'Milking Machine',  price = 150 },
    }
}

-- ================= SELL ITEMS =================
Config.SellItems = {
    farming_sell = {
        wheat = 35,
        corn  = 30,
        carrot = 42
    },
    livestock_sell = {
        fresh_milk = 150,
        cow_meat = 250,
        chicken_meat = 100,
        chicken_egg = 45,
    }
}

-- ================= BLIPS =================
Config.Blips = {
    farming_buy = {
        label  = 'Market Pertanian',
        sprite = 469,
        color  = 2,
        scale  = 0.8
    },
    farming_sell = {
        label  = 'Jual Hasil Tani',
        sprite = 108,
        color  = 2,
        scale  = 0.8
    },
    livestock_buy = {
        label  = 'Market Peternakan',
        sprite = 141,
        color  = 5,
        scale  = 0.8
    },
    livestock_sell = {
        label  = 'Jual Hasil Ternak',
        sprite = 108,
        color  = 5,
        scale  = 0.8
    }
}

