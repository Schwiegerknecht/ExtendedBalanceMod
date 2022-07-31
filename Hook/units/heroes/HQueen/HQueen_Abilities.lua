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
Buffs.HQueenCompostPowerBuff01.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff01.Affects.Regen.Add end
Buffs.HQueenCompostPowerBuff02.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff02.Affects.Regen.Add end
Buffs.HQueenCompostPowerBuff03.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff03.Affects.Regen.Add end
Buffs.HQueenCompostPowerBuff04.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff04.Affects.Regen.Add end
Buffs.HQueenCompostPowerBuff05.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff05.Affects.Regen.Add end
Buffs.HQueenCompostPowerBuff06.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff06.Affects.Regen.Add end
Buffs.HQueenCompostPowerBuff01.Description = 'Shambler and Uproot damage increased. 5 Health Per Second.'
Buffs.HQueenCompostPowerBuff02.Description = 'Shambler and Uproot damage increased. 10 Health Per Second.'
Buffs.HQueenCompostPowerBuff03.Description = 'Shambler and Uproot damage increased. 15 Health Per Second.'
Buffs.HQueenCompostPowerBuff04.Description = 'Shambler and Uproot damage increased. 20 Health Per Second.'
Buffs.HQueenCompostPowerBuff05.Description = 'Shambler and Uproot damage increased. 30 Health Per Second.'
Buffs.HQueenCompostPowerBuff06.Description = 'Shambler and Uproot damage increased. 40 Health Per Second.'
Ability.HQueenCompost01.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff04.Affects.Regen.Add end
Ability.HQueenCompost01.Description = 'As nearby enemies die, their bodies nourish Queen of Thorns. For every 3 enemies killed, her Health Per Second increases (up to [GetRegen]) and Uproot increases in damage. Her Shamblers gain Weapon Damage and Health. The effects cap at 9 enemies killed, and the effects diminish over time.'
Ability.HQueenCompost02.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff05.Affects.Regen.Add end
Ability.HQueenCompost02.Description = 'As nearby enemies die, their bodies nourish Queen of Thorns. For every 3 enemies killed, her Health Per Second increases (up to [GetRegen]) and Uproot increases in damage. Her Shamblers gain Weapon Damage and Health. The effects cap at 9 enemies killed, and the effects diminish over time.'
Ability.HQueenCompost03.GetRegen = function(self) return Buffs.HQueenCompostPowerBuff06.Affects.Regen.Add end
Ability.HQueenCompost03.Description = 'As nearby enemies die, their bodies nourish Queen of Thorns. For every 3 enemies killed, her Health Per Second increases (up to [GetRegen]) and Uproot increases in damage. Her Shamblers gain Weapon Damage and Health. The effects cap at 9 enemies killed, and the effects diminish over time.'

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

-- Adjust Summon Shambler 2-4 descriptions to clarify how much stronger Shamblers get.
Ability['HQueenShambler02'].GetDamageRating = function(self) return math.floor( Buffs['HQueenShamblerBuff02'].Affects.DamageRating.Add ) end
Ability['HQueenShambler02'].GetMaxHealth = function(self) return math.floor( Buffs['HQueenShamblerBuff02'].Affects.MaxHealth.Add ) end
Ability['HQueenShambler02'].Description = 'Queen of Thorns summons [GetShamblersSummoned] Shamblers from her thorns to protect her. She may have [GetMaxShamblers] Shamblers active. Shamblers gain [GetDamageRating] Weapon Damage and [GetMaxHealth] Health.'
Ability['HQueenShambler03'].GetDamageRating = function(self) return math.floor( Buffs['HQueenShamblerBuff03'].Affects.DamageRating.Add ) end
Ability['HQueenShambler03'].GetMaxHealth = function(self) return math.floor( Buffs['HQueenShamblerBuff03'].Affects.MaxHealth.Add ) end
Ability['HQueenShambler03'].Description = 'Queen of Thorns summons [GetShamblersSummoned] Shamblers from her thorns to protect her. She may have [GetMaxShamblers] Shamblers active. Shamblers gain [GetDamageRating] Weapon Damage and [GetMaxHealth] Health.'
Ability['HQueenShambler04'].GetDamageRating = function(self) return math.floor( Buffs['HQueenShamblerBuff04'].Affects.DamageRating.Add ) end
Ability['HQueenShambler04'].GetMaxHealth = function(self) return math.floor( Buffs['HQueenShamblerBuff04'].Affects.MaxHealth.Add ) end
Ability['HQueenShambler04'].Description = 'Queen of Thorns summons [GetShamblersSummoned] Shamblers from her thorns to protect her. She may have [GetMaxShamblers] Shamblers active. Shamblers gain [GetDamageRating] Weapon Damage and [GetMaxHealth] Health.'

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



-- Add gold income buff to Entourage (1/2/3 gold/sec), ramping up to Tribute.
-- This Entourage buff requires the corresponding Summon Shambler level.
BuffBlueprint {
    Name = 'HQueenEntourageTribute01',
    BuffType = 'HQUEENTRIBUTE',
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
    BuffType = 'HQUEENTRIBUTE',
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
    BuffType = 'HQUEENTRIBUTE',
    DisplayName = '<LOC ABILITY_Queen_0114>Entourage III Tribute',
    Description = '<LOC ABILITY_Queen_0115>Gold production increased.',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        GoldProduction = {Add = 3},
    },
}
BuffBlueprint {
    Name = 'HQueenEntourageTributeTest',
    BuffType = 'HQUEENTRIBUTE',
    DisplayName = '<LOC ABILITY_Queen_0114>Entourage III Tribute',
    Description = '<LOC ABILITY_Queen_0115>Gold production increased.',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        GoldProduction = {Add = 20},
        MaxHealth = {Add = 3000, AdjustHealth = true},
        Regen = {Add = 500},
        EnergyRegen = {Add = 500},
    },
}
-- Apply the buffs when adding Entourage
Ability.HQueenEntourage01.OnAbilityAdded = function(self, unit)
    Entourage(self, 'HQueenEntourageBuff01', unit)
    Buff.ApplyBuff(unit, 'HQueenEntourageTribute01', unit)
end
Ability.HQueenEntourage02.OnAbilityAdded = function(self, unit)
    Entourage(self, 'HQueenEntourageBuff02', unit)
    Buff.ApplyBuff(unit, 'HQueenEntourageTribute02', unit)
end
Ability.HQueenEntourage03.OnAbilityAdded = function(self, unit)
    Entourage(self, 'HQueenEntourageBuff03', unit)
    Buff.ApplyBuff(unit, 'HQueenEntourageTribute03', unit)
end
    

--Change Entourage descriptions
Ability.HQueenEntourage01.GetEntourageGoldBuff = function(self) return math.floor( Buffs['HQueenEntourageTribute01'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage02.GetEntourageGoldBuff = function(self) return math.floor( Buffs['HQueenEntourageTribute02'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage03.GetEntourageGoldBuff = function(self) return math.floor( Buffs['HQueenEntourageTribute03'].Affects.GoldProduction.Add ) end
Ability.HQueenEntourage01.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff].'
Ability.HQueenEntourage02.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff].'
Ability.HQueenEntourage03.Description = 'Increases Shambler Health by [GetShamblerHealth] and damage by [GetShamblerDamage]. Queen of Thorns demands tribute from her subjects. Gold production increased by [GetEntourageGoldBuff].'


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