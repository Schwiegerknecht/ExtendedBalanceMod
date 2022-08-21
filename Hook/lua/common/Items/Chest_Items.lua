# ExtendedBalanceMod IMPORTANT NOTE:
# Before each new release, enter the folder name of the current mod version here.
local modfolder = 'ExtendedBalanceMod-main' -- ExtendedBalanceMod-0.3
# So far I have found no way to automate this. Might have to search for where logs are produced, the folder path is contained there:
--[[
info: 00:00:14: Hooked /lua/common/items/artifact_items.lua with /mods/uberfix/hook/lua/common/items/artifact_items.lua
info: 00:00:14: Hooked /lua/common/items/artifact_items.lua with /mods/extendedbalancemod-main/hook/lua/common/items/artifact_items.lua
]]
# Going via debug.getinfo(1).source does not actually help, since it does not get info on the file being hooked.
# The alternative is giving up the possibility to have multiple versions of the mod installed at the same time.

-- Increase Groffling armor proc chance to 5% up from 1%
Ability.Item_Chest_070_WeaponProc.ArmorProcChance = 5


-- Increase Platemail of the Crusader proc chance to 3% from 1%
Ability.Item_Chest_060_WeaponProc.ArmorProcChance = 3
-- Add 200 HP to Platemail of the Crusader (from 0) - Schwiegerknecht
Buffs.Item_Chest_060.Affects.MaxHealth = {Add = 200, AdjustEnergy = false}
-- Add Tooltip
Items.Item_Chest_060.GetHealthBonus = function(self) return Buffs['Item_Chest_060'].Affects.MaxHealth.Add end
table.insert(Items.Item_Chest_060.Tooltip.Bonuses, '+[GetHealthBonus] Health')

--Schwiegerknecht start

--Armor of Vengeance
--[[ Add +10 health per second to Armor of Vengance and adjust description
Buffs.Item_Chest_050.Affects.Regen = {Add = 10}
Items.Item_Chest_050.GetRegenBonus = function(self) return Buffs['Item_Chest_050'].Affects.Regen.Add end
table.insert(Items.Item_Chest_050.Tooltip.Bonuses, '+[GetRegenBonus] Health Per Second')
]] -- Removed

-- Added 400 HP to Armor of Vengeance (from 0)
Buffs.Item_Chest_050.Affects.MaxHealth = {Add = 400}
-- Increase Armor of Vengeance base damage reflect to 75 (from 35)
Buffs.Item_Chest_050.Affects.DamageReturn = {Add = 75}
-- Add Tooltip
Items.Item_Chest_050.GetHealthBonus = function(self) return Buffs['Item_Chest_050'].Affects.MaxHealth.Add end
table.insert(Items.Item_Chest_050.Tooltip.Bonuses, '+[GetHealthBonus] Health')
--Add ArmorProc that increases the damage being reflected
BuffBlueprint {
    Name = 'Item_Chest_050_Reflect',
    DisplayName = '<LOC ITEM_Chest_0014>Armor of Vengeance',
    Description = '<LOC ITEM_Chest_0017>Reflecting damage.',
    BuffType = 'ITEM_CHEST_050_REFLECT', # Use 'ENCHANTPOWER' to only have DamageReturn on the proc
    Debuff = false,
    EntityCategory = 'ALLUNITS',
    Stacks = 'REPLACE',
    Duration = 6,
    Affects = {
        DamageReturn = { Add = 75 },
    },
    # IgnoreDamageRangePercent = true,
    # CanBeEvaded = false,
    # CanBackfire = false,
    # ArmorImmune = true,
    # CanCrit = false,
    # CanMagicResist = false,
    Icon = 'NewIcons/Chest/Chest2',
}
table.insert(Items.Item_Chest_050.Abilities, AbilityBlueprint {
    Name = 'Item_Chest_050_ArmorProc',
    AbilityType = 'ArmorProc',
    FromItem = 'Item_Chest_050',
    Icon = 'NewIcons/Chest/Chest2',
    ArmorProcChance = 5,
    OnArmorProc = function(self, unit)
        Buff.ApplyBuff(unit, 'Item_Chest_050_Reflect', unit)
        # AttachEffectsAtBone( unit, EffectTemplates.Items.Breastplate.NuadusWarplateProc, -2 )
    end,
})
-- Add Tooltip for ArmorProc
Items.Item_Chest_050.GetProcChance = function(self) return Ability['Item_Chest_050_ArmorProc'].ArmorProcChance end
Items.Item_Chest_050.GetThornsProcDmg = function(self) return Buffs['Item_Chest_050_Reflect'].Affects.DamageReturn.Add end
Items.Item_Chest_050.GetArmorProcDuration = function(self) return Buffs['Item_Chest_050_Reflect'].Duration end
if not Items.Item_Chest_050.Tooltip.ChanceOnHit then 
    Items.Item_Chest_050.Tooltip.ChanceOnHit = '<LOC ITEM_Chest_0012>[GetProcChance]% chance on being hit to increase the damage reflected by [GetThornsProcDmg] damage for [GetArmorProcDuration] seconds.'
end


--Increased armor of Duelist's Cuirass to 800 (from 700; normally 500)
Buffs.Item_Chest_090.Affects.Armor = {Add = 800}
--Increased health of Duelist's Cuirass to 500 (from 350)
Buffs.Item_Chest_090.Affects.MaxHealth = {Add = 500, AdjustEnergy = false}
--Correct Description
Items.Item_Chest_090.Tooltip.Bonuses = {
    '+[MaxHealth] Health',
    '+[GetArmorBonus] Armor',
}

-- Add +10 minion HP regen to Godplate
Buffs.Item_Chest_080_Minion_Buff.Affects.Regen = {Add = 10}
Items.Item_Chest_080.GetMinionRegenBonus = function(self) return Buffs['Item_Chest_080_Minion_Buff'].Affects.Regen.Add end
table.insert(Items.Item_Chest_080.Tooltip.MBonuses, '+[GetMinionRegenBonus] Minion Health Per Second')


-- Godplate: Add proc on stun/freeze/interrupt
-- Give 500 Armor and 100 HP regen for 5 seconds
BuffBlueprint {
    Name = 'Item_Chest_080_ProcBuff',
    BuffType = 'GODPLATEPROC',
    DisplayName = 'Godplate',
    Description = 'Godplate armor proc',
    Debuff = false,
    EntityCategory = 'ALLUNITS',
    Stacks = 'IGNORE',
    Duration = 5,
    Affects = {
        Armor = {Add = 500},
        Regen = {Add = 100},
    },
    Icon = 'NewIcons/Chest/Chest9',
    OnBuffRemove = function(self, unit)
        Buff.ApplyBuff(unit, 'Item_Chest_080_OnCooldown', unit)
    end,
}
-- Dummy buff to prevent new procs
BuffBlueprint {
    Name = 'Item_Chest_080_OnCooldown',
    BuffType = 'GODPLATEPROC',
    DisplayName = 'Godplate',
    Description = 'Godplate proc on Cooldown',
    Debuff = false,
    EntityCategory = 'ALLUNITS',
    Stacks = 'REPLACE',
    Duration = 25, -- Dummy value. Real value calculated by Ability.Item_Chest_080_Proc.CooldownBuffDur
    Affects = {
        Dummy = {Add = 1},
    },
    Icon = '../../../../../mods/' .. modfolder .. '/Icons/Chest9_dis',
}

GodplateProc = function(self, unit)
    Buff.ApplyBuff(unit, 'Item_Chest_080_ProcBuff', unit)
end
-- Add callbacks via Ability
table.insert(Items.Item_Chest_080.Abilities, AbilityBlueprint {
    Name = 'Item_Chest_080_Proc',
    AbilityType = 'Aura',
    AffectRadius = 1,
    AuraPulseTime = 1,
    CooldownTime = 30,
    TargetAlliance = 'Ally',
    TargetCategory = 'HERO',
    #FromItem = 'Item_Chest_080',
    Icon = 'NewIcons/Chest/Chest9',
    Buffs = {
        BuffBlueprint {
            Name = 'Item_Chest_080_Dummy',
            BuffType = 'GODPLATEDUMMY',
            Debuff = false,
            EntityCategory = 'ALLUNITS',
            Stacks = 'REPLACE',
            Duration = 1,
            Affects = {
                Dummy = {Add = 1},
            },
        },
    },
    OnAbilityAdded = function(self, unit)
        local ProcDuration = Buffs.Item_Chest_080_ProcBuff.Duration
        local TotalCooldown = Ability.Item_Chest_080_Proc.CooldownTime
        local CooldownBuffDur = TotalCooldown - ProcDuration

        Buffs.Item_Chest_080_OnCooldown.Duration = CooldownBuffDur

        if not unit:IsDead() then
            unit.Callbacks.OnStunned:Add(GodplateProc, self)
            unit.Callbacks.OnFrozen:Add(GodplateProc, self)
        end
    end,
    OnRemoveAbility = function(self, unit)
        Buff.RemoveBuff(unit, 'Item_Chest_080_Dummy')
        unit.Callbacks.OnStunned:Remove(GodplateProc)
        unit.Callbacks.OnFrozen:Remove(GodplateProc)
    end,
})
-- Adjust Tooltip
Items.Item_Chest_080.GetProcDuration = function(self) return Buffs.Item_Chest_080_ProcBuff.Duration end
Items.Item_Chest_080.GetProcArmor = function(self) return Buffs.Item_Chest_080_ProcBuff.Affects.Armor.Add end
Items.Item_Chest_080.GetProcRegen = function(self) return Buffs.Item_Chest_080_ProcBuff.Affects.Regen.Add end
Items.Item_Chest_080.GetProcCooldown = function(self) return Ability.Item_Chest_080_Proc.CooldownTime end
if not Items.Item_Chest_080.Tooltip.Passives then
    Items.Item_Chest_080.Tooltip.Passives = '+[GetProcRegen] Health per second and +[GetProcArmor] Armor for [GetProcDuration] seconds when stunned, frozen or interrupted. This can only occur once every [GetProcCooldown] seconds.'
end