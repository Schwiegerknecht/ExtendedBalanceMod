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

--Update Skill Derscriptions
Buffs.HQueenCompostPowerBuff01.Description = 'Shambler and Uproot damage increased.'
Buffs.HQueenCompostPowerBuff02.Description = 'Shambler and Uproot damage increased.'
Buffs.HQueenCompostPowerBuff03.Description = 'Shambler and Uproot damage increased.'
Buffs.HQueenCompostPowerBuff04.Description = 'Shambler and Uproot damage increased.'
Buffs.HQueenCompostPowerBuff05.Description = 'Shambler and Uproot damage increased.'
Buffs.HQueenCompostPowerBuff06.Description = 'Shambler and Uproot damage increased.'

-- Ability.HQueenCompost01.Description = 'As nearby enemies die, their bodies nourish Queen of Thorns. For every 3 enemies killed, Uproot increases in damage. Queen of Thorns Weapon Range increases. Shamblers gain Weapon Damage and Health. The effects cap at 9 enemies killed, and the effects diminish over time.'
-- Ability.HQueenCompost02.Description = 'As nearby enemies die, their bodies nourish Queen of Thorns. For every 3 enemies killed, Uproot increases in damage. Queen of Thorns Weapon Range increases. Shamblers gain Weapon Damage and Health. The effects cap at 9 enemies killed, and the effects diminish over time.'
-- Ability.HQueenCompost03.Description = 'As nearby enemies die, their bodies nourish Queen of Thorns. For every 3 enemies killed, Uproot increases in damage. Queen of Thorns Weapon Range increases. Shamblers gain Weapon Damage and Health. The effects cap at 9 enemies killed, and the effects diminish over time.'

-- Increase uproot range from 20 to match Rook's Treb Hat (range 35)
Ability.HQueenUproot01.RangeMax = 20
Ability.HQueenUproot02.RangeMax = 25
Ability.HQueenUproot03.RangeMax = 30
Ability.HQueenUproot04.RangeMax = 35

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
-- Uproot 3 and 4 appliy fire rate debuff / stun to target.
BuffBlueprint {
    Name = 'HQueenUprootStun03',
    Debuff = true,
    CanBeDispelled = false,
    DisplayName = 'Uproot',
    Description = 'Rate of fire reduced.',
    BuffType = 'UPROOTSTUN',
    Stacks = 'REPLACE',
    Icon = '/dgqueenofthorns/NewQueenUproot01',
    Duration = 10,
    Affects = {
        RateOfFire = {Mult = -0.5},
    },
}
Ability.HQueenUproot03.OnStartAbility = function(self, unit, params)
    local thd = ForkThread(Uproot, self, unit, params)
    local target = params.Targets[1]
    Buff.ApplyBuff(target, 'HQueenUprootStun03', unit)
end
Ability.HQueenUproot03.GetRateOfFire = function(self) return math.floor( Buffs['HQueenUprootStun03'].Affects.RateOfFire.Mult * 100 * -1) end
Ability.HQueenUproot03.Description = 'Queen of Thorns sends her vines deep beneath the earth to destroy target structure\'s foundation, dealing [GetDamage] damage over [GetDuration] seconds. The structure\'s rate of fire is reduced by [GetRateOfFire]%.'

BuffBlueprint {
    Name = 'HQueenUprootStun04',
    Debuff = true,
    CanBeDispelled = false,
    DisplayName = 'Uproot',
    Description = 'Stunned.',
    BuffType = 'UPROOTSTUN',
    Stacks = 'REPLACE',
    Icon = '/dgqueenofthorns/NewQueenUproot01',
    Duration = 10,
    Affects = {
        Stun = {Add = 0},
    },
}
Ability.HQueenUproot04.OnStartAbility = function(self, unit, params)
    local thd = ForkThread(Uproot, self, unit, params)
    local target = params.Targets[1]
    Buff.ApplyBuff(target, 'HQueenUprootStun04', unit)
end
Ability.HQueenUproot04.GetStunDuration = function(self) return math.floor( Buffs['HQueenUprootStun04'].Duration) end
Ability.HQueenUproot04.Description = 'Queen of Thorns sends her vines deep beneath the earth to destroy target structure\'s foundation, dealing [GetDamage] damage over [GetDuration] seconds. The structure is disabled for [GetStunDuration] seconds.'

--[[Incomplete idea:
--Add gold income buff to Entourage, ramping up to Tribute
BuffBlueprint {
    Name = 'HQueenEntourageTribute01',
    BuffType = 'HQUEENENTOURAGEBUFF',
    DisplayName = '<LOC ABILITY_Queen_0110>Entourage I Tribute',
    Description = '<LOC ABILITY_Queen_0111>Gold production increased.',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        GoldProduction = {Add = 1},
    },
}
BuffBlueprint {
    Name = 'HQueenEntourageTribute02',
    BuffType = 'HQUEENENTOURAGEBUFF',
    DisplayName = '<LOC ABILITY_Queen_0112>Entourage II Tribute',
    Description = '<LOC ABILITY_Queen_0113>Gold production increased.',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        GoldProduction = {Add = 2},
    },
}
BuffBlueprint {
    Name = 'HQueenEntourageTribute03',
    BuffType = 'HQUEENENTOURAGEBUFF',
    DisplayName = '<LOC ABILITY_Queen_0114>Entourage III Tribute',
    Description = '<LOC ABILITY_Queen_0115>Gold production increased.',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        GoldProduction = {Add = 3},
    },
}
--Change Entourage descriptions
Ability.HQueenEntourage01.GetEntourageGoldBuff1 = function(self) return math.floor( Buffs['HQueenEntourageTribute01'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage02.GetEntourageGoldBuff2 = function(self) return math.floor( Buffs['HQueenEntourageTribute02'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage03.GetEntourageGoldBuff3 = function(self) return math.floor( Buffs['HQueenEntourageTribute03'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage01.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff1] while Shamblers are alive.'
Ability.HQueenEntourage02.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff2] while Shamblers are alive.'
Ability.HQueenEntourage03.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff3] while Shamblers are alive.'
]]