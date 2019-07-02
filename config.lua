Config        = {}
Config.Locale = 'sv'

Config.VehicleSpawnpoint = { x = 586.71, y = 2735.8, z = 42.02, h = 180.0}
Config.MSPos = { x = 594.43, y = 2742.2, z = 42.03}
-- Ped list ---- https://wiki.gtanet.work/index.php?title=Peds
Config.Zones = {

    MissionStarter = {
        Marker  = {
            DrawD    = 20.0, 
            Size    = {x = 2.0, y = 2.0, z = 1.5},
            Type    = 23,
            Opacity = 150,
            Color   = {r = 0, g = 169, b = 100}
        },
        Blip = {
            Coords  = vector3(Config.MSPos.x, Config.MSPos.y, Config.MSPos.z),
            Sprite  = 386,
            Display = 4,
            Scale   = 0.8,
            Colour  = 29,
            Name    = 'Mats'
        },
        MatsPed = {
            SpawningPos = {x = 594.28, y = 2744.45, z = 42.02, h = 160.0},
            Ped         = 1841036427 -- Agent14Cutscene in wiki
        },
        Pos     = Config.MSPos,
        text    = '[~b~E~w~] Hjälp Mats',
    },
}