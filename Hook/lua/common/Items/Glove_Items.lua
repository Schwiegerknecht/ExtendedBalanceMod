local Buff = import('/lua/sim/buff.lua')

--Increase Wyrmskin proc damage to 250, up from 60
Buffs.Item_Glove_040_SlowDD.Affects.Health.Add = -250
-- Increase Slayer's Wraps damage to 35 up from 30
Buffs.Item_Glove_070_Buff.Affects.DamageRating.Add = 35

# Schwieger: Removed
-- Increase Gloves of Despair drain to 525 up from 300
-- Buffs.Item_Glove_030_Drain.Affects.Energy.Add = -400

# REMOVED. Doomspite gets new passive
# See below. - Schwiegerknecht
--[[ Increase Doomspite cleave chance to 50% up from 25%
Ability.Item_Glove_050_WeaponProc.WeaponProcChance = 50
-- Increase doomspite weapon cleave size to 3 up from 1.5
Ability.Item_Glove_050_WeaponProc.CleaveSize = 3
-- Increase Doomspite Ranged proc chance to 33% up from 16%
Ability.Item_Glove_050_WeaponProc.WeaponProcChanceRanged = 33]]


-- Schwiegerknecht start
-- Add 200 Armor and 5% Weapon Damage to Gladiator Gloves, update discription
Buffs.Item_Glove_020.Affects.Armor = {Add = 200}
Buffs.Item_Glove_020.Affects.DamageRating = {Add = 5}
Items.Item_Glove_020.GetArmorBonus = function(self) return Buffs['Item_Glove_020'].Affects.Armor.Add end
Items.Item_Glove_020.GetWeaponDamage = function(self) return Buffs['Item_Glove_020'].Affects.DamageRating.Add end
table.insert(Items.Item_Glove_020.Tooltip.Bonuses, '+[GetArmorBonus] Armor')
table.insert(Items.Item_Glove_020.Tooltip.Bonuses, '+[GetWeaponDamage] Weapon Damage')

-- Add 10% Attack Speed to Wyrmskin Handguards and update description
Buffs.Item_Glove_040.Affects.RateOfFire = {Mult = 0.10}
Items.Item_Glove_040.GetAttackSpeedBonus = function(self) return math.floor( Buffs['Item_Glove_040'].Affects.RateOfFire.Mult * 100) end
table.insert(Items.Item_Glove_040.Tooltip.Bonuses, '+[GetAttackSpeedBonus]% Attack Speed')
-- Make Wyrmskin Handguards' description of Proc chance more specific
Items.Item_Glove_040.GetProcChanceRanged = function(self) return Ability['Item_Glove_040_WeaponProc'].WeaponProcChanceRanged end
Items.Item_Glove_040.Tooltip.ChanceOnHit = '[GetProcChance]% chance on hit to eviscerate the target dealing [GetProcDrain] damage and reducing their Attack Speed and Movement Speed [GetSlowBuff]%. ([GetProcChanceRanged]% chance for ranged attacks)'

-- Gauntlets of Despair: Increase Attack Speed to 15% (from 8%)
Buffs.Item_Glove_030.Affects.RateOfFire.Mult = 0.15
-- Gauntlets of Despair: Add 10% Mana Leech, remove the weapon proc
-- For Mana leech see BuffAffects.lua (and ForgeUnit.lua, HeroUnit.lua)
Buffs.Item_Glove_030.Affects.EnergyLeech = {Add = 0.1}
-- Remove proc, adjust description
Ability.Item_Glove_030_WeaponProc = nil
Items.Item_Glove_030.Tooltip.ChanceOnHit = nil
Items.Item_Glove_030.GetManaLeech = function(self) return math.floor(Buffs['Item_Glove_030'].Affects.EnergyLeech.Add * 100) end
table.insert( Items.Item_Glove_030.Tooltip.Bonuses, '+[GetManaLeech]% Mana Leech' )
-- Gauntlets of Despair: Add 5% lifesteal for melee Demigods only
BuffBlueprint {
    Name = 'Item_Glove_030_Melee',
    BuffType = 'ENCHANTCRITMULT',
    Debuff = false,
    EntityCategory = 'ALLUNITS',
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        LifeSteal = {Add = 0.05},
    },
    Effects = 'Lifesteal02',
}

Buffs.Item_Glove_030.OnBuffAffect = function(self, unit)
    local wep = unit:GetWeapon(1)
    local wepbp = wep:GetBlueprint()
    if wepbp.IsMelee == true then
        Buff.ApplyBuff(unit, 'Item_Glove_030_Melee', unit)
        if Buff.HasBuff(unit, 'Item_Glove_030_Melee') then
            LOG("*DEBUG: Gloves of Despair - Applied melee buff.")
        end
    else
        LOG("*DEBUG: Gloves of Despair - Not melee, did not apply melee buff.")
    end
end
Buffs.Item_Glove_030.OnBuffRemove = function(self, unit)
    if Buff.HasBuff(unit, 'Item_Glove_030_Melee') then
        Buff.RemoveBuff(unit, 'Item_Glove_030_Melee')
    end
end
-- Update Description
Items.Item_Glove_030.GetLifeStealBonus = function(self) return math.floor(Buffs['Item_Glove_030_Melee'].Affects.LifeSteal.Add * 100) end
Items.Item_Glove_030.Tooltip.Passives = '+[GetLifeStealBonus]% Life Steal for Demigods using melee attacks'


-- Add 10% Attack Speed to Slayer's Wraps
Buffs.Item_Glove_070_Buff.Affects.RateOfFire = {Mult = 0.1}
Items.Item_Glove_070.GetAttackSpeedBonus = function(self) return math.floor(Buffs['Item_Glove_070_Buff'].Affects.RateOfFire.Mult * 100) end
table.insert( Items.Item_Glove_070.Tooltip.Bonuses, '+[GetAttackSpeedBonus]% Attack Speed')

# Doomspite Grips
#################
-- Doomspite Grips: Overwrite WeaponProc so it drains a % value of enemy's max HP on every hit.
BuffBlueprint {
    Name = 'Item_Glove_050_Drain',
    BuffType = 'ITEM_GLOVE_050_DRAIN',
    EntityCategory = 'HERO',
    IgnoreDamageRangePercent = true,
    Debuff = true,
    Stacks = 'ALWAYS',
    Duration = 0,
    Affects = {
        Health = {MaxHealthPercent = -0.01},
    },
    Effects = 'Manadrain01',
    EffectsBone = -2,
}
Ability.Item_Glove_050_WeaponProc.CleaveSize = nil
Ability.Item_Glove_050_WeaponProc.WeaponProcChance = 100
Ability.Item_Glove_050_WeaponProc.WeaponProcChanceRanged = 50
Ability.Item_Glove_050_WeaponProc.OnWeaponProc = function(self, unit, target, damageData)
    if not target:IsDead() and EntityCategoryContains(categories.HERO, target) then
        Buff.ApplyBuff(target, 'Item_Glove_050_Drain', unit)
    end
end
-- Update Tooltip
Items.Item_Glove_050.GetHealthDrain = function(self) return string.format("%.1f", Buffs['Item_Glove_050_Drain'].Affects.Health.MaxHealthPercent * 100 * -1) end
Items.Item_Glove_050.GetProcChanceRanged = function(self) return Ability['Item_Glove_050_WeaponProc'].WeaponProcChanceRanged end
Items.Item_Glove_050.Tooltip.ChanceOnHit = '[GetProcChance]% chance on hit ([GetProcChanceRanged]% for ranged attacks) to make enemy demigods lose [GetHealthDrain]% of their maximum health'

-- Doomspite Grips: Increase Attack Speed to 20% (normally 10)
Buffs.Item_Glove_050.Affects.RateOfFire.Mult = 0.20

# Gloves of Fell-Darkur
#######################

-- Add Weapon Proc that actually creates a fiery blast.
Ability.Item_Glove_060_WeaponProc.WeaponProcChance = 25
Ability.Item_Glove_060_WeaponProc.WeaponProcChanceRanged = 10
Ability.Item_Glove_060_WeaponProc.ProcDamage = 200
Ability.Item_Glove_060_WeaponProc.DamageType = 'SpellFire'
Ability.Item_Glove_060_WeaponProc.AffectRadius = 3
-- Debuff for Fell-Darkur's Damage over time
BuffBlueprint {
    Name = 'Item_Glove_060_DoT',
    DisplayName = 'Gloves of Fell-Darkur',
    Description = 'Taking burn damage.',
    BuffType = 'ITEM_GLOVE_060_FIRESTRIKE',
    Debuff = true,
    CanBeDispelled = true,
    Stacks = 'REPLACE',
    Duration = 3,
    DurationPulse = 3,
    ArmorImmune = true,
    CanCrit = false,
    CanBackfire = false,
    IgnoreDamageRangePercent = true,
    Icon = 'NewIcons/Hand/Hand2',
    Affects = {
        Health = {Add = -50},
    },
    Effects = 'Burn01',
    EffectsBone = -2,
}
-- Implementation of WeaponProc
Ability.Item_Glove_060_WeaponProc.OnWeaponProc = function(self, unit, target, damageData)
    local pos = table.copy(target:GetPosition())
    local army = unit:GetArmy()
    
    # Use the custom effect template created in EffectTemplates.lua
    AttachEffectsAtBone( target, EffectTemplates.Items.Glove.GlovesOfFellDarkurProc, -2)

    pos[2] = GetSurfaceHeight(pos[1], pos[3]) - 0.25

	# Cache all entities in sphere
    local entities = GetEntitiesInSphere('UNITS', pos, self.AffectRadius )
    local affectedEntities = {}
    # Filter untargetables. -- Fire TB is immune, too
    for k, vEntity in entities do
        if not EntityCategoryContains(categories.UNTARGETABLE,vEntity) then -- and not( vEntity.Character.CharBP.Name == 'MageFire') then
            table.insert(affectedEntities, vEntity)
        end
    end

    local data = {
        Instigator = unit,
        InstigatorBp = unit:GetBlueprint(),
        InstigatorArmy = unit:GetArmy(),
        Origin = unit:GetPosition(),
        Amount = self.ProcDamage,
        Type = self.DamageType,
        DamageAction = self.Name,
        Radius = self.AffectRadius,
        DamageFriendly = false,
        DamageSelf = false,
        Group = "UNITS",
        CanBeEvaded = false,
        CanCrit = false,
        CanBackfire = false,
        CanDamageReturn = false,
        CanMagicResist = true,
        CanOverKill = false,
        ArmorImmune = true,
        NoFloatText = false,
    }
    DamageArea( data, affectedEntities )

    # Apply damage over time. --Fire TB is immune
    --if not (target.Character.CharBP.Name == 'MageFire') then
        Buff.ApplyBuff(target, 'Item_Glove_060_DoT', unit)
    --end
end
-- Update description
Items.Item_Glove_060.GetProcChanceRanged = function(self) return Ability['Item_Glove_060_WeaponProc'].WeaponProcChanceRanged end
Items.Item_Glove_060.GetProcDamage = function(self) return math.floor( Ability['Item_Glove_060_WeaponProc'].ProcDamage ) end
Items.Item_Glove_060.GetDotDuration = function(self) return Buffs['Item_Glove_060_DoT'].Duration end
Items.Item_Glove_060.GetDotDmg = function(self) return Buffs['Item_Glove_060_DoT'].Affects.Health.Add * (-1) * Buffs['Item_Glove_060_DoT'].DurationPulse end
Items.Item_Glove_060.Tooltip.ChanceOnHit = '[GetProcChance]% chance on hit ([GetProcChanceRanged]% for ranged attacks) to unleash a fiery blast, dealing [GetProcDamage] damage to nearby units. The target takes [GetDotDmg] burn damage over [GetDotDuration] seconds.'
-- Gloves of Fell-Darkur: Add 15% Attack Speed 
Buffs.Item_Glove_060.Affects.RateOfFire = {Mult = 0.15}
Items.Item_Glove_060.GetAttackSpeedBonus = function(self) return math.floor(Buffs['Item_Glove_060'].Affects.RateOfFire.Mult * 100) end
table.insert(Items.Item_Glove_060.Tooltip.Bonuses, '+[GetAttackSpeedBonus]% Attack Speed')