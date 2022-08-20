--Increase Theurgist's Hat regen to 70% up from 35%
Buffs.Item_Helm_070.Affects.EnergyRegen.Mult = 0.7
-- Increase Theurgist's Hat proc chance to 10 up from 5
Ability.Item_Helm_070_WeaponProc.WeaponProcChance = 10
--Increase Vinling Proc Chance to 5% up from 3%
Ability.Item_Helm_050_WeaponProc.ArmorProcChance = 5
--Increase Mana gain on Vinling proc to 500  - Schwiegerknecht
Buffs.Item_Helm_050_Restore.Affects.Energy.Add = 500
--Make Vinling's Mana gain a buff instead of debuff - Schwiegerknecht
Buffs.Item_Helm_050_Restore.Debuff = false

--Add 260 mana to Plate visor and adjust description
Buffs.Item_Helm_020.Affects.MaxEnergy = {Add = 260, AdjustEnergy = false}
Items.Item_Helm_020.GetManaBonus = function(self) return Buffs['Item_Helm_020'].Affects.MaxEnergy.Add end
table.insert(Items.Item_Helm_020.Tooltip.Bonuses, '+[GetManaBonus] Mana')

-- Schwiegerknecht below
-- Reduce base Mana of Plenor Battlecrown by 225
Buffs.Item_Helm_030.Affects.MaxEnergy.Add = 1350

-- Add 300 Mana to Theurgists Cap
Buffs.Item_Helm_070.Affects.MaxEnergy = {Add = 300}
Items.Item_Helm_070.GetManaBonus = function(self) return Buffs['Item_Helm_070'].Affects.MaxEnergy.Add end
table.insert(Items.Item_Helm_070.Tooltip.Bonuses, 1, ' +[GetManaBonus] Mana')

-- Add Mana regen buff on WeaponProc, increasing your regen by 50%
BuffBlueprint {
    Name = 'Item_Helm_070_RegenBuff',
    DisplayName = 'Theurgist\'s Cap',
    Description = 'Increased Mana Per Second.',
    BuffType = 'ITEM_HELM_050_RESTORE',
    Debuff = false,
    CanBeDispelled = true,
    Stacks = 'REPLACE',
    Duration = Buffs.Item_Helm_070_RegenDebuff.Duration,
    Icon = 'NewIcons/Helm/Helm7',
    Affects = {
        #Regen = {Mult = -.50},
        EnergyRegen = {Mult = .50},
    },
}
Ability.Item_Helm_070_WeaponProc.OnWeaponProc = function(self, unit, target, damageData)
    Buff.ApplyBuff(target, 'Item_Helm_070_RegenDebuff', unit)
    Buff.ApplyBuff(unit, 'Item_Helm_070_RegenBuff', unit)
end
-- Update description
Items.Item_Helm_070.GetProcManaRegenBuff = function(self) return math.floor( Buffs['Item_Helm_070_RegenBuff'].Affects.EnergyRegen.Mult * 100 ) end
Items.Item_Helm_070.Tooltip.ChanceOnHit ='[GetProcChance]% chance on auto attack to reduce the target\'s Health Per Second by [GetProcRegenDebuff]% and Mana Per Second by [GetProcManaRegenDebuff]% for [GetDuration] seconds, while increasing your own Mana Per Second by [GetProcManaRegenBuff]% for the same duration.'