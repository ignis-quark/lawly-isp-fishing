LAWLYFISH = LAWLYFISH or {}

--Item Configs
//Multiplier of base item cost to subtract based on length. (at 0.75, MinLength will reduce item price to 25% base value)
LAWLYFISH.LengthCostMod = 0.2
//Units away a bucket can sell to a bait and tackle shop.
LAWLYFISH.SellDistance = 200
//Max items a bucket can hold. BEWARE: NETWORKING LIMITS.
LAWLYFISH.BucketCapacity = 100
//Minimum random length for fish to be caught (cm).
LAWLYFISH.MinLength = 2

--Fishing Rod Configs
//How long before a fish may nibble in seconds {min, max}
LAWLYFISH.WaitTime = {2, 4}
//How long after a nibble the player can catch the fish.
LAWLYFISH.CatchWindow = 1
//How long it takes to reach maximum throw charge in seconds.
LAWLYFISH.ChargeTime = 3
//Strength to throw at maximum charge
LAWLYFISH.ThrowStrength = 800
//How long to wait for landing in water before auto-pulling in.
LAWLYFISH.CastTime = 4
