--Increase bloodtone ring lifesteal to 4% up from 3%
Buffs.Item_Ring_020.Affects.LifeSteal.Add = 0.04 

-- Add 10% Attack Speed bonus Ring of the Ancients and adjust description
Buffs.Item_Ring_040.Affects.RateOfFire = {Mult = 0.10}
Items.Item_Ring_040.GetAttackSpeedBonus = function(self) return math.floor( Buffs['Item_Ring_040'].Affects.RateOfFire.Mult * 100 ) end,
table.insert(Items.Item_Ring_040.Tooltip.Bonuses, '+[GetAttackSpeedBonus]% Attack Speed')

-- Schwiegerknecht start
-- Add 5% Lifesteal to Ring of the Ancients 
Buffs.Item_Ring_040.Affects.LifeSteal = {Add = 0.05}
Items.Item_Ring_040.GetLifeStealBonus = function(self) return math.floor( Buffs['Item_Ring_040'].Affects.LifeSteal.Add * 100 ) end,
table.insert(Items.Item_Ring_040.Tooltip.Bonuses, '+[GetLifeStealBonus]% Life Steal')
-- Increase Armor of Ring of the Ancients to 600 (from 400)
Buffs.Item_Ring_040.Affects.Armor.Add = 600

-- Add 10 minion HP regen to Forest Band
Buffs.Item_Ring_060_Minion.Affects.Regen = {Add = 10}
-- Add 150 Minion Health
Buffs.Item_Ring_060_Minion.Affects.MaxHealth = {Add = 150}
-- Update description
Items.Item_Ring_060.GetRegenBonus = function(self) return Buffs['Item_Ring_060_Minion'].Affects.Regen.Add end
Items.Item_Ring_060.GetMaxHealthBonus = function(self) return Buffs['Item_Ring_060_Minion'].Affects.MaxHealth.Add end
table.insert(Items.Item_Ring_060.Tooltip.MBonuses, '+[GetMaxHealthBonus] Minion Health')
table.insert(Items.Item_Ring_060.Tooltip.MBonuses, '+[GetRegenBonus] Minion Health Per Second')
-- Change Forest Band's WeaponProc to 5% ArmorProc
Ability.Item_Ring_060.AbilityType = 'ArmorProc'
Ability.Item_Ring_060.WeaponProcChance = nil
Ability.Item_Ring_060.OnWeaponProc = nil
Ability.Item_Ring_060.OnArmorProc = function(self, unit, target, damageData)
    unit:GetAIBrain():AddArmyBonus( 'Item_Ring_060_Minion_Buff', unit )
end
Ability.Item_Ring_060.ArmorProcChance = 5
Items.Item_Ring_060.Tooltip.ChanceOnHit = '[GetProcChance]% on being hit to heal your army for [GetHealth] health.'
Items.Item_Ring_060.GetProcChance = function(self) return Ability['Item_Ring_060'].ArmorProcChance end
-- Decrease Heal on Proc to 150 Health (from 250)
Buffs.Item_Ring_060_Minion_Buff.Affects.Health.Add = 150