LAWLYFISH = LAWLYFISH or {}

--Lengths, in CM, min and max
LAWLYFISH.FishList = {
    {Name="Carp", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Catfish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Anchovy", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Grouper", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Arowana", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Bluegill", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Anabas", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Snapper", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Atlantic Mackerel", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Scad", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Rainbow Trout", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Clownfish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Atlantic Salmon", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Red Drum", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Neon Tetra", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Perch", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Basa", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Gilt-Head Bream", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Pterophyllum Scalare", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Garfish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Zander", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Atlantic Bluefin Tuna", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="White Bass", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Zebrafish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Siames Fighting Fish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Goldfish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Guppy", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Tilapia", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Ayu", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Blue Tang", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" },
    {Name="Swordfish", Weight = 10, Worth = 20, Lengths = {40, 78}, Mdl = "FUCK" }
}
LAWLYFISH:ApplyWeights(LAWLYFISH.FishList)

LAWLYFISH.TrashList = {
    {Name="Baby", Worth = 1, Mdl = "FUCK"},
    {Name="Melon", Worth = 1, Mdl = "FUCK"},
    {Name="Bone", Worth = 1, Mdl = "FUCK"},
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
    {List = LAWLYFISH.TrashList, Weight = 500},
    {List = LAWLYFISH.WeaponList, Weight = 1},
    {List = LAWLYFISH.UsableList, Weight = 5},
}
LAWLYFISH:ApplyWeights(LAWLYFISH.Catches)

LAWLYFISH.Rarities = {
    {Color=Color(255,255,255), Weight = 1000},
    {Color=Color(0,255,0), Weight = 30},
    {Color=Color(0,255,255), Weight = 20},
    {Color=Color(255,94,0), Weight = 10},
    {Color=Color(255,0,212), Weight = 5},
    {Color=Color(255,0,0), Weight = 1},
    {Color=Color(255,230,0), Weight = 0.1}
}
LAWLYFISH:ApplyWeights(LAWLYFISH.Rarities)