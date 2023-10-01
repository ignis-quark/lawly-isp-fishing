LAWLYFISH = LAWLYFISH or {}

LAWLYFISH.FishList = {
    --Common (90)
    {Name="Anchovy",        Weight = 90,  Worth = 10, MaxLength = 25, Mdl = "anchovy" },
    {Name="Atlantic Mackerel",Weight=90,  Worth = 25, MaxLength = 66, Mdl = "mackerel" },
    {Name="Wells Catfish",  Weight = 90,  Worth = 20, MaxLength = 120,Mdl = "catfish" },
    {Name="Common Tench",   Weight = 90,  Worth = 20, MaxLength = 70, Mdl = "gilt_grouper" },
    {Name="Mottled Eel",    Weight = 90,  Worth = 10, MaxLength = 121,Mdl = "FUCK" },
    {Name="Sardine",        Weight = 90,  Worth = 5,  MaxLength = 40, Mdl = "sword_scad" },
    {Name="Pink Shrimp",    Weight = 90,  Worth = 3,  MaxLength = 3,  Mdl = "FUCK" },
    {Name="Tiger Prawn",    Weight = 90,  Worth = 3,  MaxLength = 3,  Mdl = "FUCK" },
    {Name="Smallmouth Bass",Weight = 90,  Worth = 20, MaxLength = 65, Mdl = "perch" },
    {Name="River Trout",    Weight = 90,  Worth = 25, MaxLength = 80, Mdl = "FUCK" },
    {Name="Sea Trout",      Weight = 90,  Worth = 30, MaxLength = 90, Mdl = "FUCK" },
    {Name="White Bass",     Weight = 90,  Worth = 20, MaxLength = 70, Mdl = "FUCK" },
    {Name="Carp",           Weight = 90,  Worth = 20, MaxLength = 105,Mdl = "carp" },
    {Name="Perch",          Weight = 90,  Worth = 20, MaxLength = 105,Mdl = "perch" }, --Yes, I know it's supposed to be one "s"
    --Uncommon (80)
    {Name="Bluegill",       Weight = 85,  Worth = 80, MaxLength = 30, Mdl = "FUCK" },
    {Name="Cod",            Weight = 85,  Worth = 120, MaxLength = 200,Mdl = "carp" },
    {Name="Salmon",         Weight = 85,  Worth = 70, MaxLength = 76, Mdl = "salmon" },
    {Name="Brook Trout",    Weight = 80,  Worth = 120, MaxLength = 90, Mdl = "FUCK" },
    {Name="Albacore Tuna",  Weight = 80,  Worth = 125, MaxLength = 140,Mdl = "bluefin_tuna" },
    {Name="Sea Turtle",     Weight = 80,  Worth = 120, MaxLength = 120,Mdl = "FUCK" },
    {Name="Slimy Eel",      Weight = 80,  Worth = 120, MaxLength = 127,Mdl = "FUCK" },
    --Rare (60)
    {Name="Herring",        Weight = 70,  Worth = 200, MaxLength = 45, Mdl = "salmon" },
    {Name="Pike",           Weight = 70,  Worth = 400, MaxLength = 150,Mdl = "FUCK" },
    {Name="Lobster",        Weight = 60,  Worth = 350, MaxLength = 60, Mdl = "FUCK" },
    {Name="Rainbow Fish",   Weight = 60,  Worth = 200, MaxLength = 10, Mdl = "arowana" },
    {Name="Silver Carp",    Weight = 60,  Worth = 350, MaxLength = 110,Mdl = "carp" },
    --Very Rare (40)
    {Name="Boxer Shrimp",   Weight = 45,  Worth = 500, MaxLength = 4,  Mdl = "FUCK" },
    {Name="Leaping Sturgeon",Weight= 50,  Worth = 500, MaxLength = 720,Mdl = "red_drum" },
    {Name="Largemouth Bass",Weight = 40,  Worth = 550, MaxLength = 75, Mdl = "perch" },
    {Name="Leaping Trout",  Weight = 40,  Worth = 500, MaxLength = 80, Mdl = "ayu" },
    {Name="Leaping Salmon", Weight = 40,  Worth = 500, MaxLength = 150,Mdl = "salmon" },
    --Epic (10)
    {Name="Cave Eel",       Weight = 25,  Worth = 600, MaxLength = 400,Mdl = "FUCK" },
    {Name="Greater Siren",  Weight = 15,  Worth = 800, MaxLength = 97, Mdl = "siames_fighting_fish" },
    {Name="Monkfish",       Weight = 10,  Worth = 800, MaxLength = 150,Mdl = "FUCK" },
    {Name="Swordfish",      Weight = 10,  Worth = 1100,MaxLength = 455,Mdl = "sword_fish" },
    {Name="Karambwan",      Weight = 10,  Worth = 1500,MaxLength = 20, Mdl = "FUCK" },
    --Mythical (1)
    {Name="Atlantic Bluefin Tuna",Weight=8,Worth= 2000,MaxLength = 460,Mdl = "bluefin_tuna" },
    {Name="King Mackerel",  Weight = 7,  Worth = 2000, MaxLength = 184,Mdl = "mackerel" },
    {Name="Shark",          Weight = 5,  Worth = 2500, MaxLength = 67, Mdl = "FUCK" },
    {Name="Dark Crab",      Weight = 1,  Worth = 5000, MaxLength = 400,Mdl = "FUCK" },
    {Name="Manta Ray",      Weight = 1,  Worth = 8000, MaxLength = 700,Mdl = "FUCK" },
    {Name="Pufferfish",     Weight = 1,  Worth = 3000, MaxLength = 120,Mdl = "FUCK" },
    {Name="Lau Lau",        Weight = 1,  Worth = 4000, MaxLength = 280,Mdl = "FUCK" },
    --Relic (0.1)
    {Name="Anglerfish",     Weight = 0.1,Worth = 12400, MaxLength = 150,Mdl = "FUCK" },
    {Name="Golden Trout",   Weight = 0.1,Worth = 13000, MaxLength = 30, Mdl = "snapper" },
    {Name="Holy Mackerel",  Weight = 0.1,Worth = 25200, MaxLength = 250,Mdl = "mackerel" },
    {Name="Southern Bluefin Tuna",Weight = 0.1,  Worth = 28200, MaxLength = 245,Mdl = "bluefin_tuna" },
}
LAWLIB:TableApplyWeights(LAWLYFISH.FishList)

LAWLYFISH.TrashList = {
    {Name="Baby",       Mdl = "models/props_c17/doll01.mdl"},
    {Name="Bleach",     Mdl = "models/props_junk/garbage_plasticbottle001a.mdl"},
    {Name="Bone",       Mdl = "models/Gibs/HGIBS_rib.mdl"},
    {Name="Boot",       Mdl = "models/props_junk/Shoe001a.mdl"},
    {Name="Bottle",     Mdl = "models/props_junk/garbage_plasticbottle003a.mdl"},
    {Name="Can",        Mdl = "models/props_junk/PopCan01a.mdl"},
    {Name="Takeout Box",Mdl = "models/props_junk/garbage_takeoutcarton001a.mdl"},
    {Name="Clock",      Mdl = "models/props_c17/clock01.mdl"},
    {Name="Cone",       Mdl = "models/props_junk/TrafficCone001a.mdl"},
    {Name="HulaDoll",   Mdl = "models/props_lab/huladoll.mdl"},
    {Name="Keyboard",   Mdl = "models/props_c17/computer01_keyboard.mdl"},
    {Name="Lamp",       Mdl = "models/props_lab/desklamp01.mdl"},
    {Name="Melon",      Mdl = "models/props_junk/watermelon01.mdl"},
    {Name="Radio",      Mdl = "models/props_lab/reciever01a.mdl"},
    {Name="Sign",       Mdl = "models/props_c17/streetsign001c.mdl"},
    {Name="Skull",      Mdl = "models/Gibs/HGIBS.mdl"},
    {Name="Tic Tac Toe Block",Mdl = "models/props_c17/playgroundTick-tack-toe_block01a.mdl"},
}

LAWLYFISH.WeaponList = {
    {Name="Pistol", Weight = 1, Wep = "weapon_pistol"}
}
LAWLIB:TableApplyWeights(LAWLYFISH.WeaponList)

LAWLYFISH.UsableList = {
    {Name="Fridge", Worth = 100, Class = "FUCK"},
    {Name="Oven",   Worth = 100, Class = "FUCK"},
    {Name="Pot",    Worth = 10, Class = "FUCK"},
    {Name="Pan",    Worth = 10, Class = "FUCK"},
}

LAWLYFISH.PlushieList = {
    {Name="Alien", Mdl = "WIP"},
    {Name="Browny Electro", Mdl = "WIP"},
    {Name="Crimson Peak", Mdl = "WIP"},
    {Name="Kiwi", Mdl = "WIP"},
    {Name="Dawny", Mdl = "WIP"},
    {Name="Gorloss", Mdl = "WIP"},
    {Name="Kale Triton", Mdl = "WIP"},
    {Name="Luna", Mdl = "WIP"},
    {Name="Midnight Rain", Mdl = "WIP"},
    {Name="Mitten Kitten", Mdl = "WIP"},
    {Name="Ruby Madness", Mdl = "WIP"},
    {Name="Sora Kite", Mdl = "WIP"},
    {Name="Zeime", Mdl = "WIP"},
}

LAWLYFISH.Catches = {
    {List = LAWLYFISH.FishList, Weight = 100},
    {List = LAWLYFISH.TrashList, Weight = 100},
    {List = LAWLYFISH.UsableList, Weight = 5},
    //{List = LAWLYFISH.WeaponList, Weight = 1},
    //{List = LAWLYFISH.PlushieList, Weight = 0.01},
}
LAWLIB:TableApplyWeights(LAWLYFISH.Catches)

LAWLYFISH.Rarities = {
    {Color=Color(255,255,255), Weight = 100, Name="Worthless"},
    {Color=Color(109,255,109), Weight = 90, Name="Common"},
    {Color=Color(0,198,17), Weight = 80, Name="Uncommon"},
    {Color=Color(226,111,45), Weight = 60, Name="Rare"},
    {Color=Color(255,0,0), Weight = 40, Name="Very Rare"},
    {Color=Color(243,34,250), Weight = 10, Name="Epic"},
    {Color=Color(166,0,172), Weight = 1, Name="Mythical"},
    {Color=Color(0,247,255), Weight = 0.1, Name="Relic"},
    {Color=Color(255,200,0), Weight = 0.01, Name="Eternal"}
}
LAWLIB:TableApplyWeights(LAWLYFISH.Rarities)