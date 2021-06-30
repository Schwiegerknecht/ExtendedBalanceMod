-- Increase Groffling armor proc chance to 5% up from 1%
Ability.Item_Chest_070_WeaponProc.ArmorProcChance = 5


-- Increase Platemail of the Crusader proc chance to 3% from 1%
Ability.Item_Chest_060_WeaponProc.ArmorProcChance = 3
-- Add 200 HP to Platemail of the Crusader (from 0) - Schwiegerknecht
Buffs.Item_Chest_060.Affects.MaxHealth = {Add = 200, AdjustEnergy = false}
-- Add Tooltip
Items.Item_Chest_060.GetHealthBonus = function(self) return Buffs['Item_Chest_060'].Affects.MaxHealth.Add end
table.insert(Items.Item_Chest_060.Tooltip.Bonuses, '+[GetHealthBonus] Health')


--Armor of Vengeance
--[[ Add +10 health per second to Armor of Vengance and adjust description
Buffs.Item_Chest_050.Affects.Regen = {Add = 10}
Items.Item_Chest_050.GetRegenBonus = function(self) return Buffs['Item_Chest_050'].Affects.Regen.Add end
table.insert(Items.Item_Chest_050.Tooltip.Bonuses, '+[GetRegenBonus] Health Per Second')
]] -- Removed - Schwiegerknecht

-- Added 200 HP to Armor of Vengeance (from 0) - Schwiegerknecht
Buffs.Item_Chest_050.Affects.MaxHealth = {Add = 250}
-- Add Tooltip
Items.Item_Chest_050.GetHealthBonus = function(self) return Buffs['Item_Chest_050'].Affects.MaxHealth.Add end
table.insert(Items.Item_Chest_050.Tooltip.Bonuses, '+[GetHealthBonus] Health')
--Add ArmorProc that increases the damage being reflected - Schwiegerknecht
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


--Increased armor of Duelist's Cuirass to 700 (from 500) - Schwiegerknecht
Buffs.Item_Chest_090.Affects.Armor = {Add = 700}
--Correct Description
Items.Item_Chest_090.Tooltip.Bonuses = {
    '+[MaxHealth] Health',
    '+[GetArmorBonus] Armor',
}

-- Add +10 minion HP regen to Godplate - Schwiegerknecht
Buffs.Item_Chest_080_Minion_Buff.Affects.Regen = {Add = 10}
Items.Item_Chest_080.GetMinionRegenBonus = function(self) return Buffs['Item_Chest_080_Minion_Buff'].Affects.Regen.Add end
table.insert(Items.Item_Chest_080.Tooltip.MBonuses, '+[GetMinionRegenBonus] Minion Health Per Second')
