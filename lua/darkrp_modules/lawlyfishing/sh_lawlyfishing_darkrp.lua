TEAM_ANGLER = DarkRP.createJob("Angler", {
    color = Color(204, 156, 223),
    description = [[You like fish. You like to catch. You like to catch fish.]],
    weapons = {"lawly_fishingrod"},
    command = "lawlyfish_angler",
    max = 5,
    model = {
        "models/ppm/player_default_base_new_nj.mdl",
        "models/ppm/player_default_base_new.mdl"
    },
    salary = 25,
    admin = 0,
    vote = false,
    category = "Civilians",
    hasLicense = false
})

DarkRP.createCategory{
    name = "Fishing",
    categorises = "entities",
    startExpanded = true,
    color = Color(217, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 101
}

DarkRP.createEntity("Fishing Bucket", {
    ent = "lawly_fishing_bucket",
    model = "models/props_junk/MetalBucket01a.mdl",
    price = 500,
    max = 2,
    cmd = "buybucket",
    allowed = {TEAM_ANGLER},
    category = "Fishing",
    spawn = function(ply, tr, tblEnt)
        local newEnt = ents.Create("lawly_fishing_bucket")
        local pos = tr.HitPos + tr.HitNormal * 5
        newEnt:SetPos(pos)
        newEnt:Spawn()
        newEnt:DropToFloor()
        newEnt:PhysWake()
        newEnt:SetNWEntity("Owner", ply)
        return newEnt
    end
})