--Troop armor put on Building Strength price track
Upgrades.Tree.CTroopArmor01.Cost = 500 -- normally 600
Upgrades.Tree.CTroopArmor02.Cost = 1500 -- normally 1800	
Upgrades.Tree.CTroopArmor03.Cost = 2500 --  normally 3000
Upgrades.Tree.CTroopArmor04.Cost = 3500 -- normally 4800

--Death Reduction put on Building Strength price track
Upgrades.Tree.CDeathPenalty01.Cost = 500 --Reduced from 600
Upgrades.Tree.CDeathPenalty02.Cost = 1500 -- Reduced form 1800
Upgrades.Tree.CDeathPenalty03.Cost = 3500 --Reduced from 5400 

--Siege put on Building Strength price track
Upgrades.Tree.CUpgradeStructure01.Cost = 2500 --Reduced from 3200 to normalize price curve
Upgrades.Tree.CUpgradeStructure02.Cost = 3500 --Reduced from 4000 to normalize price curve

--Restore beta gold income to normalize cost/benefit ratios - Removed - Schwiegerknecht
-- Schwiegerknecht start
--Instead use a regular progression to remove absolute necessity for Cur3 
Buffs.CGoldIncome01.Affects.GoldProduction.Add = 3
Buffs.CGoldIncome02.Affects.GoldProduction.Add = 6
Buffs.CGoldIncome03.Affects.GoldProduction.Add = 9

--Give Building Firepower some range, so it can counter Siege Demolishers and cause the damage bonus is paltry.
Buffs.CBuildingStrength02.Affects.MaxRadius = {Add = 3}
Buffs.CBuildingStrength03.Affects.MaxRadius = {Add = 6}
Buffs.CBuildingStrength04.Affects.MaxRadius = {Add = 9}
--Update descriptions
ArmyBonuses.CBuildingStrength02.GetMaxRadius = function(self) return Buffs.CBuildingStrength02.Affects.MaxRadius.Add end
ArmyBonuses.CBuildingStrength03.GetMaxRadius = function(self) return Buffs.CBuildingStrength03.Affects.MaxRadius.Add end
ArmyBonuses.CBuildingStrength04.GetMaxRadius = function(self) return Buffs.CBuildingStrength04.Affects.MaxRadius.Add end
ArmyBonuses.CBuildingStrength02.Description = 'Buildings gain +[GetDamageBonus]% damage and splash damage. Tower range increased by [GetMaxRadius].'
ArmyBonuses.CBuildingStrength03.Description = 'Buildings gain +[GetDamageBonus]% damage and splash damage. Tower range increased by another [GetMaxRadius].'
ArmyBonuses.CBuildingStrength04.Description = 'Buildings gain +[GetDamageBonus]% damage and splash damage. Tower range increased by another [GetMaxRadius].'

__moduleinfo.auto_reload = true