--Increase Wyrmskin proc damage to 250, up from 60
Buffs.Item_Glove_040_SlowDD.Affects.Health.Add = -250
-- Increase Gloves of Despair drain to 400 up from 300 -- EBMv0.2 (down from 525 in BalMod 1.31)
Buffs.Item_Glove_030_Drain.Affects.Energy.Add = -400
-- Increase Slayer's Wraps damage to 35 up from 30
Buffs.Item_Glove_070_Buff.Affects.DamageRating.Add = 35

# REMOVED. Doomspite cleave goes to Fell-Darkur, Doomspite get new passive. 
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

-- Add 15% Attack Speed to Wyrmskin Handguards and update description
Buffs.Item_Glove_040.Affects.RateOfFire = {Mult = 0.15}
Items.Item_Glove_040.GetAttackSpeedBonus = function(self) return math.floor( Buffs['Item_Glove_040'].Affects.RateOfFire.Mult * 100) end
table.insert(Items.Item_Glove_040.Tooltip.Bonuses, '+[GetAttackSpeedBonus]% Attack Speed')

-- Make Gauntlet's of Despair's mana drain a mana leech (gives as much as is drained).
BuffBlueprint {
    Name = 'Item_Glove_030_Leech',
    BuffType = 'ITEM_GLOVE_030_LEECH',
    Debuff = false,
    CanBeDispelled = true,
    Stacks = 'REPLACE',
    Duration = 0,
    Affects = {
        Energy = {Add = -(Buffs.Item_Glove_030_Drain.Affects.Energy.Add)},
    },
    Effects = 'Manadrain01',
    EffectsBone = -2,
}
Ability.Item_Glove_030_WeaponProc.OnWeaponProc = function(self, unit, target, damageData)
    if not target:IsDead() then
        Buff.ApplyBuff(target, 'Item_Glove_030_Drain', unit)
        Buff.ApplyBuff(unit, 'Item_Glove_030_Leech', unit)
        AttachEffectsAtBone( unit, EffectTemplates.Items.Glove.GauntletsOfDespairProc, -2 )
    end
end
-- Update description
Items.Item_Glove_030.GetProcChanceRanged = function(self) return Ability['Item_Glove_030_WeaponProc'].WeaponProcChanceRanged end
Items.Item_Glove_030.Tooltip.ChanceOnHit = '[GetProcChance]% chance on hit ([GetProcChanceRanged]% for ranged attacks) to drain [GetProcDrain] Mana and restoring it to the attacker.'
--FOR TESTING
# Ability.Item_Glove_030_WeaponProc.WeaponProcChance = 100
# Ability.Item_Glove_030_WeaponProc.WeaponProcChanceRanged = 100

-- Add 10% Attack Speed to Slayer's Wraps
Buffs.Item_Glove_070_Buff.Affects.RateOfFire = {Mult = 0.1}
Items.Item_Glove_070.GetAttackSpeedBonus = function(self) return math.floor(Buffs['Item_Glove_070_Buff'].Affects.RateOfFire.Mult * 100) end
table.insert( Items.Item_Glove_070.Tooltip.Bonuses, '+[GetAttackSpeedBonus]% Attack Speed')

-- Gloves of Fell-Darkur: Use Doomspite WeaponProc with increased ProcChance
Ability.Item_Glove_060_WeaponProc.WeaponProcChance = 75
Ability.Item_Glove_060_WeaponProc.WeaponProcChanceRanged = 50
Ability.Item_Glove_060_WeaponProc.CleaveSize = 3
Ability.Item_Glove_060_WeaponProc.OnWeaponProc = function(self, unit, target, damageData)
    AttachEffectsAtBone( unit, EffectTemplates.Items.Glove.DoomSpiteGripsProc, -2 )
    local wepbp = unit:GetWeaponByLabel( damageData.DamageAction ):GetBlueprint()
    local damageAmt = wepbp.Damage + unit.Sync.DamageRating
    
    local data = {
        Instigator = unit,
        InstigatorBp = unit:GetBlueprint(),
        InstigatorArmy = unit:GetArmy(),
        Origin = target:GetPosition(),
        Amount = damageAmt,
        Type = 'Hero',
        DamageAction = self.Name,
        IgnoreTargets = { target },
        Radius = self.CleaveSize,
        DamageFriendly = false,
        DamageSelf = false,
        Group = 'UNITS',
        CanBeEvaded = true,
        CanCrit = false,
        CanBackfire = false,
        CanMagicResist = false,
        CanOverKill = true,
        ArmorImmune = false,
        NoFloatText = false,
    }
    DamageArea(data)
end
-- Update description
Items.Item_Glove_060.GetProcChanceRanged = function(self) return Ability['Item_Glove_060_WeaponProc'].WeaponProcChanceRanged end
Items.Item_Glove_060.Tooltip.ChanceOnHit = '[GetProcChance]% chance on hit to perform a cleaving attack, damaging nearby enemies ([GetProcChanceRanged]% for ranged attacks).'
-- Gloves of Fell-Darkur: Add 15% Attack Speed 
Buffs.Item_Glove_060.Affects.RateOfFire = {Mult = 0.15}
Items.Item_Glove_060.GetAttackSpeedBonus = function(self) return math.floor(Buffs['Item_Glove_060'].Affects.RateOfFire.Mult * 100) end
table.insert(Items.Item_Glove_060.Tooltip.Bonuses, '+[GetAttackSpeedBonus] Attack Speed')


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
        Health = {MaxHealthPercent = -0.015},
    },
    Effects = 'Manadrain01',
    EffectsBone = -2,
}
Ability.Item_Glove_050_WeaponProc.CleaveSize = nil
Ability.Item_Glove_050_WeaponProc.WeaponProcChance = 100
Ability.Item_Glove_050_WeaponProc.WeaponProcChanceRanged = 100
Ability.Item_Glove_050_WeaponProc.OnWeaponProc = function(self, unit, target, damageData)
    if not target:IsDead() then
        Buff.ApplyBuff(target, 'Item_Glove_050_Drain', unit)
    end
end
-- Update Tooltip
Items.Item_Glove_050.GetHealthDrain = function(self) return string.format("%.1f", Buffs.Item_Glove_050_Drain.Affects.Health.MaxHealthPercent * 100 * -1) end
Items.Item_Glove_050.Tooltip.ChanceOnHit = '[GetProcChance]% chance on hit to make enemy demigods lose [GetHealthDrain]% of their maximum health'

-- Doomspite Grips: Increase Attack Speed to 20% (normally 10)
Buffs.Item_Glove_050.Affects.RateOfFire.Mult = 0.20
