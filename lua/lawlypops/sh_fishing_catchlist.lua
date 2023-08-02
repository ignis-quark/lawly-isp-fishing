LAWLYFISH = LAWLYFISH or {}

--Lengths, in CM, min and max
LAWLYFISH.FishList = {
    {Name="Anabas", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Anchovy", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Angelfish", Weight = 80, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Arowana", Weight = 80, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Atlantic Bluefin Tuna", Weight = 0.1, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Atlantic Mackerel", Weight = 40, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Atlantic Salmon", Weight = 70, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Ayu", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Basa", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Blue Tang", Weight = 50, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Bluegill", Weight = 7, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Carp", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Catfish", Weight = 75, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Clownfish", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Garfish", Weight = 40, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Gilt-Head Bream", Weight = 20, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Goldfish", Weight = 100, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Grouper", Weight = 100, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Guppy", Weight = 100, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Holy Mackerel", Weight = 0.1, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Koi", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Neon Tetra", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Perch", Weight = 13, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Rainbow Trout", Weight = 3, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Red Drum", Weight = 45, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Red Snapper", Weight = 80, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Scad", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Siames Fighting Fish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Snapper", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Swordfish", Weight = 3, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Tilapia", Weight = 70, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="White Bass", Weight = 14, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Zander", Weight = 2, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Zebrafish", Weight = 90, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
}
LAWLYFISH:ApplyWeights(LAWLYFISH.FishList)

LAWLYFISH.TrashList = {
    {Name="Baby", Worth = 1, Mdl = "models/props_c17/doll01.mdl"},
    {Name="Melon", Worth = 1, Mdl = "models/props_junk/watermelon01.mdl"},
    {Name="Bone", Worth = 1, Mdl = "models/Gibs/HGIBS_rib.mdl"},
    {Name="Skull", Worth = 1, Mdl = "models/Gibs/HGIBS.mdl"},
    {Name="Clock", Worth = 1, Mdl = "models/props_c17/clock01.mdl"},
    {Name="Keyboard", Worth = 1, Mdl = "models/props_c17/computer01_keyboard.mdl"},
    {Name="HulaDoll", Worth = 1, Mdl = "models/props_lab/huladoll.mdl"},
    {Name="Chinese", Worth = 1, Mdl = "models/props_junk/garbage_takeoutcarton001a.mdl"},
    {Name="Bleach", Worth = 1, Mdl = "models/props_junk/garbage_plasticbottle001a.mdl"},
    {Name="Bottle", Worth = 1, Mdl = "models/props_junk/garbage_plasticbottle003a.mdl"},
    {Name="Sign", Worth = 1, Mdl = "models/props_c17/streetsign001c.mdl"},
    {Name="Radio", Worth = 1, Mdl = "models/props_lab/reciever01a.mdl"},
    {Name="Lamp", Worth = 1, Mdl = "models/props_lab/desklamp01.mdl"},
    {Name="Cone", Worth = 1, Mdl = "models/props_junk/TrafficCone001a.mdl"},
    {Name="Boot", Worth = 1, Mdl = "models/props_junk/Shoe001a.mdl"},
    {Name="Can", Worth = 1, Mdl = "models/props_junk/PopCan01a.mdl"},
    {Name="Tick Tack Toe Block", Worth = 1, Mdl = "models/props_c17/playgroundTick-tack-toe_block01a.mdl"},
}

LAWLYFISH.WeaponList = {
    {Name="Pistol", Weight = 1, Wep = "weapon_pistol"}
}
LAWLYFISH:ApplyWeights(LAWLYFISH.WeaponList)

LAWLYFISH.UsableList = {
    {Name="Pot", Worth = 1, Class = "FUCK"},
    {Name="Oven", Worth = 1, Class = "FUCK"},
    {Name="Fridge", Worth = 1, Class = "FUCK"}
}

LAWLYFISH.Catches = {
    {List = LAWLYFISH.FishList, Weight = 100},
    {List = LAWLYFISH.TrashList, Weight = 100},
    {List = LAWLYFISH.WeaponList, Weight = 1},
    {List = LAWLYFISH.UsableList, Weight = 5},
}
LAWLYFISH:ApplyWeights(LAWLYFISH.Catches)

LAWLYFISH.Rarities = {
    {Color=Color(255,255,255), Weight = 100, Name="Worthless"},
    {Color=Color(0,255,0), Weight = 90, Name="Common"},
    {Color=Color(0,255,255), Weight = 80, Name="Uncommon"},
    {Color=Color(191,89,30), Weight = 60, Name="Rare"},
    {Color=Color(255,0,212), Weight = 40, Name="Epic"},
    {Color=Color(199,0,0), Weight = 10, Name="Legendary"},
    {Color=Color(81,0,255), Weight = 1, Name="Mythical"},
    {Color=Color(236,236,71), Weight = 0.1, Name="Relic"},
    {Color=Color(255,200,0), Weight = 0.01, Name="Eternal"}
}
LAWLYFISH:ApplyWeights(LAWLYFISH.Rarities)