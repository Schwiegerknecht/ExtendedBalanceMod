--Increase Compost Shambler Damage 4,6,8,10,15,20 (normally 4,6,8,10,12,14)
-- level 1 = 4-10 (6 point spread) level 2 = 6-15 (9 point spread), level 3 = 8-20 (12 point spread)
Buffs.HQueenCompostPowerBuffMinion01.Affects.DamageRating.Add = 4
Buffs.HQueenCompostPowerBuffMinion02.Affects.DamageRating.Add = 6
Buffs.HQueenCompostPowerBuffMinion03.Affects.DamageRating.Add = 8
Buffs.HQueenCompostPowerBuffMinion04.Affects.DamageRating.Add = 10
Buffs.HQueenCompostPowerBuffMinion05.Affects.DamageRating.Add = 15
Buffs.HQueenCompostPowerBuffMinion06.Affects.DamageRating.Add = 20

-- Restore Compopst buff levels to increase QoT range, as seen in beta
-- Buffs.HQueenCompostPowerBuff01.Affects.MaxRadius = {Add = 1}
-- Buffs.HQueenCompostPowerBuff02.Affects.MaxRadius = {Add = 2}
-- Buffs.HQueenCompostPowerBuff03.Affects.MaxRadius = {Add = 3}
-- Buffs.HQueenCompostPowerBuff04.Affects.MaxRadius = {Add = 4}
-- Buffs.HQueenCompostPowerBuff05.Affects.MaxRadius = {Add = 5}
-- Buffs.HQueenCompostPowerBuff06.Affects.MaxRadius = {Add = 6}

-- Compost buffs give 5/10/15/20/30/40 HP regen (Schwiegerknecht)
# CHANGE THE BUFF DESCRIPTION IF YOU CHANGE THESE VALUES!
Buffs.HQueenCompostPowerBuff01.Affects.Regen = {Add = 5}
Buffs.HQueenCompostPowerBuff02.Affects.Regen = {Add = 10}
Buffs.HQueenCompostPowerBuff03.Affects.Regen = {Add = 15}
Buffs.HQueenCompostPowerBuff04.Affects.Regen = {Add = 20}
Buffs.HQueenCompostPowerBuff05.Affects.Regen = {Add = 30}
Buffs.HQueenCompostPowerBuff06.Affects.Regen = {Add = 40}
--Update Skill Descriptions (Schwiegerknecht)
# TODO: Find a way to insert the HP regen values into HQueenCompostPowerBuff01.Description as [GetRegen] or similar.
# Does not seem to work like with Ability descriptions.
for i = 1, 6 do
    Buffs['HQueenCompostPowerBuff0'..i].GetRegen = function(self) return Buffs['HQueenCompostPowerBuff0'..i].Affects.Regen.Add end
end
Buffs.HQueenCompostPowerBuff02.Description = 'Shambler and Uproot damage increased. 10 Health Per Second.'
Buffs.HQueenCompostPowerBuff03.Description = 'Shambler and Uproot damage increased. 15 Health Per Second.'
Buffs.HQueenCompostPowerBuff04.Description = 'Shambler and Uproot damage increased. 20 Health Per Second.'
Buffs.HQueenCompostPowerBuff05.Description = 'Shambler and Uproot damage increased. 30 Health Per Second.'
Buffs.HQueenCompostPowerBuff06.Description = 'Shambler and Uproot damage increased. 40 Health Per Second.'
for i = 1,3 do
    local pwrbuff = i + 3
    Ability['HQueenCompost0'..i].GetRegen = function(self) return Buffs['HQueenCompostPowerBuff0'..pwrbuff].Affects.Regen.Add end
    Ability['HQueenCompost0'..i].Description = 'As nearby enemies die, their bodies nourish Queen of Thorns. For every 3 enemies killed, her Health Per Second increases (up to [GetRegen]) and Uproot increases in damage or healing done to towers. Her Shamblers gain Weapon Damage and Health. The effects cap at 9 enemies killed, and the effects diminish over time.'
end

-- BalMod 1.31: Increase uproot range from 20 to match Rook's Treb Hat (range 35)
-- Schwieger: Increase uproot range to 20/22/24/26 (from 20)
Ability.HQueenUproot01.RangeMax = 20
Ability.HQueenUproot02.RangeMax = 22
Ability.HQueenUproot03.RangeMax = 24
Ability.HQueenUproot04.RangeMax = 26

-- Entourage increase damage to 10 (from 6) 
Buffs.HQueenEntourageBuff01.Affects.DamageRating.Add = 10
Buffs.HQueenEntourageBuff02.Affects.DamageRating.Add = 20
Buffs.HQueenEntourageBuff03.Affects.DamageRating.Add = 30

--Reduce Spikewave III to 10 second cooldown from 15
Ability.HQueenSpikeWave03.Cooldown = 10

--Reduce Groundspike I to 425 mana down from 500 mana (so mana cost per level scales now 425,500,675,750)
Ability.HQueenGroundSpikes01.EnergyCost = 425

--Reduce consume delay to damage (0.5 seconds down from 2)
#################################################################################################################
# CE: Consume Shambler
#################################################################################################################
function Consume(abilityDef, unit, params)
    local target = params.Targets[1]
    if not target:IsDead() then
        target.Mulch = true
        if not target.KillData then
            target.KillData = {}
        end
        target:Kill()
        Buff.ApplyBuff(unit, abilityDef.RegenBuffName, unit)

        # Temp consume effects at target
        AttachEffectAtBone( target, 'Queenofthorns', 'MulchTarget01', -2 )

        # Create uproot cast effects at Queen
        AttachEffectAtBone( unit, 'Queenofthorns', 'MulchCast01', -2 )
    
        local pos = target:GetPosition()
        local data = {
            Instigator = unit,
            InstigatorBp = unit:GetBlueprint(),
            InstigatorArmy = unit:GetArmy(),
            Amount = abilityDef.DamageAmt,
            Type = 'Spell',
            DamageAction = abilityDef.Name,
            Radius = abilityDef.DamageArea,
            DamageSelf = false,
            Origin = pos,
            CanDamageReturn = false,
            CanCrit = false,
            CanBackfire = false,
            CanBeEvaded = false,
            CanMagicResist = true,
            ArmorImmune = true,
            NoFloatText = false,
            Group = "UNITS",
        }
        WaitSeconds(0.5) -- Normally 2
        DamageArea(data)
    end
end


-- Schwiegerknecht start

-- Decrease Mana cost of Bramble Shield to 400/550/650/700 (normally 400/560/720/840)
Ability.HQueenBrambleShield02.EnergyCost = 550
Ability.HQueenBrambleShield03.EnergyCost = 650
Ability.HQueenBrambleShield04.EnergyCost = 700

-- Adjust Summon Shambler 2-4 descriptions to clarify how much stronger Shamblers get.
for i = 2,4 do
    Ability['HQueenShambler0'..i].GetDamageRating = function(self) return math.floor( Buffs['HQueenShamblerBuff0'..i].Affects.DamageRating.Add ) end
    Ability['HQueenShambler0'..i].GetMaxHealth = function(self) return math.floor( Buffs['HQueenShamblerBuff0'..i].Affects.MaxHealth.Add ) end
    Ability['HQueenShambler0'..i].Description = 'Queen of Thorns summons [GetShamblersSummoned] Shamblers from her thorns to protect her. She may have [GetMaxShamblers] Shamblers active. Shamblers gain [GetDamageRating] Weapon Damage and [GetMaxHealth] Health.'
end


-- Add gold income buff to Entourage (1/2/3 gold/sec), ramping up to Tribute.
for i = 1,3 do
    local currentEntourageBuff = 'HQueenEntourageBuff0'..i
    local currentTributeBuff = 'HQueenEntourageTribute0'..i
    BuffBlueprint {
        Name = currentTributeBuff,
        BuffType = 'HQUEENTRIBUTE',
        DisplayName = '<LOC ABILITY_Queen_0201>Entourage I Tribute',
        Description = '<LOC ABILITY_Queen_0202>Gold production increased.',
        Debuff = false,
        Stacks = 'REPLACE',
        Duration = -1,
        Affects = {
            GoldProduction = {Add = i},
        },
    }
    -- Apply the buffs when adding Entourage
    Ability['HQueenEntourage0'..i].OnAbilityAdded = function(self, unit)
        Entourage(self, currentEntourageBuff, unit)
        Buff.ApplyBuff(unit, currentTributeBuff, unit)
    end
    --Change Entourage descriptions
    Ability['HQueenEntourage0'..i].GetEntourageGoldBuff = function(self) return math.floor( Buffs[currentTributeBuff].Affects.GoldProduction.Add ) end
    Ability['HQueenEntourage0'..i].Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff].'
end

-- Spike Wave: Buffing a bit with Boulder Roll/Mark of Betrayer as reference
-- Decrease Spike Wave mana costs to 500/650/800 (750/1000/1250)
Ability.HQueenSpikeWave01.EnergyCost = 500
Ability.HQueenSpikeWave02.EnergyCost = 650
Ability.HQueenSpikeWave03.EnergyCost = 800
-- Increase Spike Wave slow to 15/30/45% (from 15/20/25)
Buffs.HQueenSpikeWave02.Affects.MoveMult.Mult = -0.30
Buffs.HQueenSpikeWave03.Affects.MoveMult.Mult = -0.45
-- Increase Spike Wave damage to 350/600/850 (from 350/500/650)
Ability.HQueenSpikeWave02.DamageAmt = 600
Ability.HQueenSpikeWave03.DamageAmt = 850

#################################################################################################################
# Packed/Unpacked States
#################################################################################################################
-- Adjust the way Queen's packed and unpacked states work:
-- Queen gains 10% Attack Speed and cleave auto attacks in open state but loses
-- the cleave in packed state.
-- The buffs persist while in that state and also a while after she leaves it
-- (similar to Torch Bearer). This is handled mostly in HQueen_Script.lua.

-- This buff is gained in open state, see HQueen_Script.lua
BuffBlueprint {
    Name = 'HQueenUnpackedBuffs',
    Debuff = false,
    DisplayName = '<LOC ABILITY_Queen_0205>Open',
    Description = '<LOC ABILITY_Queen_0206>Attack Speed increased.\nAttacks do cleave damage.',
    BuffType = 'HQUEENREGEN',
    Stacks = 'IGNORE',  
    Duration = -1,
    Affects = {
        RateOfFire = {Mult = 0.1},
        MoveMult = {Mult = 0},
    },
    Icon = '/dgqueenofthorns/NewQueenOpen01',
}
-- These two buffs persist for 10 seconds after queen leaves the closed/open
-- state, see HQueen_Script.lua
#TODO: Not working yet!

local tempStateBuffDuration = 10
BuffBlueprint {
    Name = 'HQueenPackedBuffsTemp',
    Debuff = false,
    DisplayName = '<LOC ABILITY_Queen_0207>Recently Closed',
    Description = '<LOC ABILITY_Queen_0208>Armor increased.\nMana Per Second increased.\nHealth Per Second increased.',
    BuffType = 'HQUEENREGEN',
    Stacks = 'IGNORE',
    Duration = tempStateBuffDuration,
    Affects = {
        Armor = {Mult = 0.1},
        EnergyRegen = {Mult = 0.5},
        Regen = {Add = 10},
        RateOfFire = {Mult = 0},
        MoveMult = {Mult = 0},
    },
    Icon = '/dgqueenofthorns/NewQueenClose',
}
BuffBlueprint {
    Name = 'HQueenUnpackedBuffsTemp',
    Debuff = false,
    DisplayName = '<LOC ABILITY_Queen_0209>Recently Open',
    Description = '<LOC ABILITY_Queen_0210>Atack Speed increased.\nAttacks do cleave damage.',
    BuffType = 'HQUEENREGEN',
    Stacks = 'IGNORE',  
    Duration = tempStateBuffDuration,
    Affects = {
        RateOfFire = {Mult = 0.1},
        MoveMult = {Mult = 0},
    },
    Icon = '/dgqueenofthorns/NewQueenOpen01',
}

#################################################################################################################
# Uproot
#################################################################################################################
-- Change Uproot to target friendly structures, healing them, and also enemies,
-- rooting/immobilizing them.

-- Allow other targets than enemy structures
for i = 1,4 do
    Ability['HQueenUproot0'..i].TargetAlliance = 'Any'
    Ability['HQueenUproot0'..i].TargetCategory = 'ALLUNITS - UNTARGETABLE' -- Meaning allunits minus the untargetable ones
    Ability['HQueenUproot0'..i].TargetingMethod = 'HOSTILETARGETED + ALLYSTRUCTURE' -- See TargetingMethod.lua
end
-- Check who we targeted and pick appropriate Uproot function
for i = 1,4 do
    Ability['HQueenUproot0'..i].OnStartAbility = function(self, unit, params)
        local target = params.Targets[1]
        
        if IsAlly(unit:GetArmy(), target:GetArmy()) then
            -- The only allies we can target are structures, due to custom TargetingMethod
            local thd = ForkThread(UprootAllyStructure, self, unit, params)
        elseif EntityCategoryContains(categories.MOBILE, target) then
            -- It's enemy mobile unit
            local thd = ForkThread(UprootMobile, self, unit, params)
        else
            -- Else normal Uproot function
            local thd = ForkThread(Uproot, self, unit, params)
            -- And apply dummy buff for description, has same name as ability
            Buff.ApplyBuff(target, self.Name, unit)
            
            -- And add Tower stun/Atk Spd slow
            if self.Name == 'HQueenUproot03' then
                Buff.ApplyBuff(target, 'HQueenUprootStun03', unit)
            elseif self.Name == 'HQueenUproot04' then
                Buff.ApplyBuff(target, 'HQueenUprootStun04', unit)
            end
        end
    end
end
-- Set ally tower heal amount to 200/400/600/800 (UprootBonus from Compost is also added)
Ability.HQueenUproot01.HealAmt = 20
Ability.HQueenUproot02.HealAmt = 40
Ability.HQueenUproot03.HealAmt = 60
Ability.HQueenUproot04.HealAmt = 80


function UprootAllyStructure(self, unit, params)
    # Create uproot effects at target
    local target = params.Targets[1]
    local pos = table.copy(target:GetPosition())
    pos[2] = 100
    local UprootEffects = {}
    local emitters = CreateTemplatedEffectAtPos( 'Buff', 'Uproot01', target:GetEffectBuffClassification(), unit:GetArmy(), pos )
    for k, v in emitters do
        table.insert( UprootEffects, v )
    end

    # Create uproot cast effects at Queen
    AttachEffectAtBone( unit, 'Queenofthorns', 'UprootCast02', -2 )

    local data = {
        Instigator = unit,
        InstigatorBp = unit:GetBlueprint(),
        InstigatorArmy = unit:GetArmy(),
        Amount = (self.HealAmt + unit.AbilityData.UprootBonus) * -1,
        Type = 'Spell',
        Radius = 0,
        DamageAction = self.Name,
        DamageSelf = true,
        DamageFriendly = true,
        CanDamageReturn = false,
        CanCrit = false,
        CanBackfire = false,
        CanBeEvaded = false,
        CanMagicResist = true,
        ArmorImmune = true,
        IgnoreDamageRangePercent = true,
        Group = "STRUCTURE",
    }
    
    for i = 1, self.Pulses do
        if not target:IsDead() then
            DealDamage(data, params.Targets[1])
        end
        WaitSeconds(1)
    end

    if UprootEffects then
        for kEffect, vEffect in UprootEffects do
            vEffect:Destroy()
        end
    end
end

function UprootMobile(self, unit, params)
    # Create uproot effects at target
    local target = params.Targets[1]
    local pos = table.copy(target:GetPosition())
    pos[2] = 100
    local UprootEffects = {}
    local emitters = CreateTemplatedEffectAtPos( 'Buff', 'Uproot01', target:GetEffectBuffClassification(), unit:GetArmy(), pos )
    for k, v in emitters do
        table.insert( UprootEffects, v )
    end

    # Create uproot cast effects at Queen
    AttachEffectAtBone( unit, 'Queenofthorns', 'UprootCast02', -2 )

    local areadata = {}
    
    if Validate.HasAbility(unit, 'HQueenViolentSiege') then
        areadata = {
            Instigator = unit,
            InstigatorBp = unit:GetBlueprint(),
            InstigatorArmy = unit:GetArmy(),
            Amount = self.ViolentSiegeAmt,
            Type = 'Spell',
            DamageAction = 'HQueenViolentSiege',
            Radius = self.ViolentSiegeRadius,
            DamageSelf = false,
            Origin = pos,
            CanDamageReturn = false,
            CanCrit = false,
            CanBackfire = false,
            CanBeEvaded = false,
            CanMagicResist = true,
            ArmorImmune = true,
            NoFloatText = false,
            IgnoreTargets = {},
            Group = "UNITS",
        }
    end

    local rootDebuff = self.Name..'Root'
    if not target:IsDead() then
        Buff.ApplyBuff(target, rootDebuff, unit)
        WaitSeconds(0.5) -- For some unholy reason you need this line for UprootEffects to be played. Compare EffectUtilities.lua??
        if Validate.HasAbility(unit, 'HQueenViolentSiege') then
            for i = 1, self.Pulses do
                DamageArea(areadata)
                WaitSeconds(1)
            end
        end
    end

    if UprootEffects then
        for kEffect, vEffect in UprootEffects do
            vEffect:Destroy()
        end
    end
end

-- Modify Uproot Buffs
-- Remove dummy buffs which have wrong description for ally towers/mobile units
for i = 1,4 do
    Ability['HQueenUproot0'..i].Buffs = nil
    -- New dummy buffs for attacked enemy structures
    BuffBlueprint {
        Name = 'HQueenUproot0'..i,
        Debuff = true,
        CanBeDispelled = false,
        DisplayName = '<LOC ABILITY_Queen_0307>Uproot',
        Description = '<LOC ABILITY_Queen_0308>Taking severe damage.',
        BuffType = 'UPROOTDUMMY',
        Stacks = 'REPLACE',
        Icon = '/dgqueenofthorns/NewQueenUproot01',
        Duration = Ability['HQueenUproot0'..i].Pulses,
        Affects = {
        },
        Effects = 'Uproot01',
    }
end
-- Uproot Root against mobile enemies
for i = 1,4 do
    local RootTime = 0.5 + (0.5 * i) -- 1.0/1.5/2.0/2.5

    BuffBlueprint {
        Name = 'HQueenUproot0'..i..'Root',
        Debuff = true,
        CanBeDispelled = true,
        DisplayName = '<LOC ABILITY_Queen_0309>Uproot',
        Description = '<LOC ABILITY_Queen_0310>Immobilized.',
        BuffType = 'UPROOTROOT',
        Stacks = 'REPLACE',
        Icon = '/dgqueenofthorns/NewQueenUproot01',
        Duration = RootTime,
        Affects = {
            UnitImmobile = {Bool = true},
        },
    }
end
-- Uproot 3 and 4 appliy fire rate debuff / stun to enemy structures.
for i = 1,3 do
    local RateOfFireMult = -0.25 * i
    
    BuffBlueprint {
        Name = 'HQueenUprootStun0'..i,
        Debuff = true,
        CanBeDispelled = false,
        DisplayName = '<LOC ABILITY_Queen_0311>Uproot',
        Description = '<LOC ABILITY_Queen_0312>Rate of fire reduced.',
        BuffType = 'UPROOTSTUN',
        Stacks = 'REPLACE',
        Icon = '/dgqueenofthorns/NewQueenUproot01',
        Duration = Ability.HQueenUproot03.Pulses,
        Affects = {
            RateOfFire = {Mult = RateOfFireMult},
        },
    }
end

BuffBlueprint {
    Name = 'HQueenUprootStun04',
    Debuff = true,
    CanBeDispelled = false,
    DisplayName = '<LOC ABILITY_Queen_0313>Uproot',
    Description = '<LOC ABILITY_Queen_0314>Stunned.',
    BuffType = 'UPROOTSTUN',
    Stacks = 'REPLACE',
    Icon = '/dgqueenofthorns/NewQueenUproot01',
    Duration = Ability.HQueenUproot04.Pulses,
    Affects = {
        Stun = {Add = 0},
    },
}
-- Update Uproot descriptions
for i = 1,4 do
    local uproot = 'HQueenUproot0'..i
    Ability[uproot].GetHeal = function(self) return math.floor( Ability[uproot].HealAmt * Ability[uproot].Pulses) end
    Ability[uproot].GetRootDuration = function(self) return Buffs[uproot..'Root'].Duration end
end
for i = 1,3 do
    local uproot = 'HQueenUproot0'..i
    local uprootStun = 'HQueenUprootStun0'..i
    Ability[uproot].GetRateOfFire = function(self) return math.floor( Buffs[uprootStun].Affects.RateOfFire.Mult * 100 * -1) end
end
Ability.HQueenUproot04.GetStunDuration = function(self) return math.floor( Buffs['HQueenUprootStun04'].Duration) end
Ability.HQueenUproot01.Description = 'Queen of Thorns sends her vines deep beneath the earth. Enemy target structures are damaged for [GetDamage] damage over [GetDuration] seconds. The structure\'s rate of fire is reduced by [GetRateOfFire]%.\n\n Allied stuctures are healed for [GetHeal] (improved by Compost).\n\n Enemy Demigods and reinforcements are immobilized by the roots for [GetRootDuration] second.'
Ability.HQueenUproot02.Description = 'Queen of Thorns sends her vines deep beneath the earth. Enemy target structures are damaged for [GetDamage] damage over [GetDuration] seconds. The structure\'s rate of fire is reduced by [GetRateOfFire]%.\n\n Allied stuctures are healed for [GetHeal] (improved by Compost).\n\n Enemy Demigods and reinforcements are immobilized by the roots for [GetRootDuration] seconds.'
Ability.HQueenUproot03.Description = 'Queen of Thorns sends her vines deep beneath the earth. Enemy target structures are damaged for [GetDamage] damage over [GetDuration] seconds. The structure\'s rate of fire is reduced by [GetRateOfFire]%.\n\n Allied stuctures are healed for [GetHeal] (improved by Compost).\n\n Enemy Demigods and reinforcements are immobilized by the roots for [GetRootDuration] seconds.'
Ability.HQueenUproot04.Description = 'Queen of Thorns sends her vines deep beneath the earth. Enemy target structures are damaged for [GetDamage] damage over [GetDuration] seconds. The structure is disabled for [GetStunDuration] seconds.\n\n Allied stuctures are healed for [GetHeal] (improved by Compost).\n\n Enemy Demigods and reinforcements are immobilized by the roots for [GetRootDuration] seconds.'

-- Update Violent Siege description
Ability.HQueenViolentSiege.Description = 'When Queen of Thorns uses Uproot, the vines grow ever wilder. Enemies standing near the targeted structure or unit take [GetDamage] damage per second while Uproot is active.'

# End of Uproot changes
#################################################################################################################

-- Make Entourage gold buff dependent on having Summon Shambler.
-- The level of Summon Shambler needs to be at least as high as the Entourage level to grant its gold bonus.
-- E.g. if you have Entourage II and Summon Shambler III or vice versa, you would only gain the Entourage II buff.
--[[TASKS:
    - Check whether to apply buff whenever Summon Shambler (SS) or Entourage (Ent) is leveled (via OnAbilityAdded).
      Always apply the buff corresponding to the smaller of the levels.
      One possibility below, although you can also do it the other way round.
    - leveling SS:
        + For each SS level: Check whether current SS lvl <= Ent lvl.
            - If yes, we can apply buff according to SS lvl.
            - If not (so if SS > Ent), we apply buff according to Ent lvl.
    - leveling Ent:
        + For each Ent level: Check whether current Ent lvl <= SS lvl.
            - If yes, we can apply buff according to Ent lvl.
            - If not (so if Ent > SS), we apply buff according to SS lvl.
]]

--[[
# NOT WORKING! Having Summon Shambler III or IV and then skilling Entourage I or II gives Entourage 3 buff.
# So currently dependant only on Summon Shambler level.
for i=1,3 do
    Ability['HQueenEntourage0'..i].OnAbilityAdded = function(self, unit)
        Entourage(self, 'HQueenEntourageBuff0'..i, unit)
        for x=1,4 do
            if Validate.HasAbility(unit, 'HQueenShambler0'..x) and x <= i then -- Check if Shambler lvl <= current Entourage lvl
                Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..x, unit) -- Add Entourage buff matching Shambler lvl
            elseif Validate.HasAbility(unit, 'HQueenShambler0'..x) and x > i then -- Check if Shambler lvl > current Entourage lvl
                Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..i, unit) -- Add Entourage buff matching Entourage lvl
            end
        end
    end
end

# This is working properly somehow
Ability['HQueenEntourage0'..1].OnAbilityAdded = function(self, unit)
    Entourage(self, 'HQueenEntourageBuff0'..1, unit)
    for x=1,1 do -- Check for all Shambler lvls which are <= current Entourage lvl
        if Validate.HasAbility(unit, 'HQueenShambler0'..x) then
            Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..x, unit) -- Add Entourage buff matching Shmabler lvl
        end
    end
    for x=2,4 do -- Check for all Shambler lvls which are > current Entourage lvl
        if Validate.HasAbility(unit, 'HQueenShambler0'..x) then
            Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..1, unit) -- Add buff of current Entourage lvl
        end
    end
end
Ability['HQueenEntourage0'..2].OnAbilityAdded = function(self, unit)
    Entourage(self, 'HQueenEntourageBuff0'..2, unit)
    for x=1,2 do -- Check for all Shambler lvls which are <= current Entourage lvl
        if Validate.HasAbility(unit, 'HQueenShambler0'..x) then
            Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..x, unit) -- Add Entourage buff matching Shmabler lvl
        end
    end
    for x=3,4 do -- Check for all Shambler lvls which are > current Entourage lvl
        if Validate.HasAbility(unit, 'HQueenShambler0'..x) then
            Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..2, unit) -- Add buff of current Entourage lvl
        end
    end
end
Ability['HQueenEntourage0'..3].OnAbilityAdded = function(self, unit)
    Entourage(self, 'HQueenEntourageBuff0'..3, unit)
    for x=1,3 do -- Check for all Shambler lvls which are <= current Entourage lvl
        if Validate.HasAbility(unit, 'HQueenShambler0'..x) then
            Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..x, unit) -- Add Entourage buff matching Shmabler lvl
        end
    end
    for x=4,4 do -- Check for all Shambler lvls which are > current Entourage lvl
        if Validate.HasAbility(unit, 'HQueenShambler0'..x) then
            Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..3, unit) -- Add buff of current Entourage lvl
        end
    end
end


-- Copy stuff from Uberfix so we don't overwrite it.
# ?! This actually gets overwritten by Uberfix 1.06, despite "after" option in mod_info.lua ?!
-- Summon Shambler applies Shambler buffs as army bonuses, so existing Shamblers will have their buffs upgraded with the ability increase.
for i=2, 4 do
    local abilShambler = Ability['HQueenShambler0'..i]
    local buffNameShambler = 'HQueenShamblerBuff0'..i
    if abilShambler and abilShambler.ShamblerBuff and Buffs[buffNameShambler] then -- always true
        abilShambler.ShamblerBuff = nil
        local armyBonusShambler = 'HQueenShamblerBonus0'..i
        ArmyBonusBlueprint {
            Name = armyBonusShambler,
            ApplyArmies = 'Single',
            UnitCategory = 'ENT',
            RemoveOnUnitDeath = true,
            Buffs = { buffNameShambler },
        }
        abilShambler.OnAbilityAdded = function(self, unit)
            unit:GetAIBrain():AddArmyBonus(armyBonusShambler, unit)
            -- Schwiegerknecht
            # NOT WORKING! Having Entourage III and lvling Summon Shambler II gives Entourage 3 buff
            # Also this gets overwritten by Uberfix 1.06. WHY?!?
            for x = 1,3 do
                if Validate.HasAbility(unit, 'HQueenEntourage0'..x) and x >= i then -- Check if Entourage lvl >= current Shambler lvl
                    Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..i, unit) -- If so, give buff according to Shambler lvl.
                elseif Validate.HasAbility(unit, 'HQueenEntourage0'..x) and x < i then -- Check if Entourage lvl < current Shambler lvl
                    Buff.ApplyBuff(unit, 'HQueenEntourageTribute0'..x, unit) -- If so, give buff according to Entourage lvl
                end
            end
        end
        abilShambler.OnRemoveAbility = function(self, unit)
            unit:GetAIBrain():RemoveArmyBonus(armyBonusShambler, unit)
        end
    end
end
-- Add the check for HQueenShambler01
Ability.HQueenShambler01.OnAbilityAdded = function(self, unit)
    for x = 1,3 do
        if Validate.HasAbility(unit, 'HQueenEntourage0'..x) and x >= 1 then -- Check if Entourage lvl >= current Shambler lvl
            Buff.ApplyBuff(unit, 'HQueenEntourageTribute01', unit) -- If so, give buff according to Shambler lvl
        end
    end
end

--Change Entourage descriptions
Ability.HQueenEntourage01.GetEntourageGoldBuff1 = function(self) return math.floor( Buffs['HQueenEntourageTribute01'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage02.GetEntourageGoldBuff2 = function(self) return math.floor( Buffs['HQueenEntourageTribute02'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage03.GetEntourageGoldBuff3 = function(self) return math.floor( Buffs['HQueenEntourageTribute03'].Affects.GoldProduction.Add ) end
# TODO: Use Pattern Matching to grab ability name only
Ability.HQueenEntourage01.GetSummonShambler01Name = function(self) return Ability['HQueenShambler01'].DisplayName end
Ability.HQueenEntourage02.GetSummonShambler02Name = function(self) return Ability['HQueenShambler02'].DisplayName end
Ability.HQueenEntourage03.GetSummonShambler03Name = function(self) return Ability['HQueenShambler03'].DisplayName end
Ability.HQueenEntourage01.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff1] if she has at least the ability [GetSummonShambler01Name].'
Ability.HQueenEntourage02.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff2] if she has at least the ability [GetSummonShambler02Name].'
Ability.HQueenEntourage03.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff3] if she has at least the ability [GetSummonShambler03Name].'
]]

__moduleinfo.auto_reload = true