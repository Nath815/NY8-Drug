Config = {}

Config.UseBlips = true

Config.Animation = {
    Recolte = 'world_human_gardener_plant',
    Traitement = 'PROP_HUMAN_BUM_BIN',
}

Config.PNJ = {
    model = 'u_m_m_streetart_01',
    scenario = 'WORLD_HUMAN_DRINKING_FACILITY',
    heading = 300.0
}

Config.Drogues = {
    weed = {
        label = "Weed",
        prix = {
            feuille = 20,
            traitee = 60
        },
        items = {
            feuille = 'weed_feuille',
            traitee = 'weed_traitee',
            pochon = 'weed_pochon'
        },
        zones = {
            recolte = vector4(1268.09, 5825.94, 489.34, 282.09), -- vector4(-472.10, 6159.74, 13.21, 72.23),
            traitement = vector4(-467.22, 6287.95, 13.61, 144.68), --vector4(-841.27, 5401.12, 34.62, 119.59),
            vente = vector4(100.86, 6332.15, 44.49, 295.03)
        }
    },
    coke = {
        label = "Coke",
        prix = {
            feuille = 35,
            traitee = 100
        },
        items = {
            feuille = 'coke_feuille',
            traitee = 'coke_traitee',
            pochon = 'coke_pochon'
        },
        zones = {
            recolte = vector4(643.81, 1694.01, 187.22, 133.12), -- vector4(1372.87, 2156.86, 97.35, 266.61),
            traitement = vector4(1539.75, 1704.13, 109.68, 88.67), -- vector4(2137.02, 1936.06, 93.93, 283.70),
            vente = vector4(100.86, 6332.15, 44.49, 295.03)
        }
    },
    meth = {
        label = "Meth",
        prix = {
            feuille = 30,
            traitee = 90
        },
        items = {
            feuille = 'meth_brute',
            traitee = 'meth_traitee',
            pochon = 'meth_pochon'
        },
        zones = {
            recolte = vector4(4197.00, -4356.21, 5.70, 92.27), -- vector4(4285.72, -4283.59, 3.13, 266.61),
            traitement = vector4(4525.67, -4550.45, 4.74, 288.54), -- vector4(4495.69, -4736.31, 10.75, 128.01),
            vente = vector4(100.86, 6332.15, 44.49, 295.03)
        }
    }
}