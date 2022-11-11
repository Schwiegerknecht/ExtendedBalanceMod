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

-- Add 10 minion HP regen to Forest Band
Buffs.Item_Ring_060_Minion.Affects.Regen = {Add = 10}
-- Add 200 Minion Health
Buffs.Item_Ring_060_Minion.Affects.MaxHealth = {Add = 150}
-- Update description
Items.Item_Ring_060.GetRegenBonus = function(self) return Buffs['Item_Ring_060_Minion'].Affects.Regen.Add end
Items.Item_Ring_060.GetMaxHealthBonus = function(self) return Buffs['Item_Ring_060_Minion'].Affects.MaxHealth.Add end
table.insert(Items.Item_Ring_060.Tooltip.MBonuses, '+[GetMaxHealthBonus] Minion Health')
table.insert(Items.Item_Ring_060.Tooltip.MBonuses, '+[GetRegenBonus] Minion Health Per Second')