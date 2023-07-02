local Buff = import('/lua/sim/buff.lua') -- Needed for Building Strength Buff

-- Troop armor put on Building Strength price track
Upgrades.Tree.CTroopArmor01.Cost = 500 -- normally 600
Upgrades.Tree.CTroopArmor02.Cost = 1500 -- normally 1800	
Upgrades.Tree.CTroopArmor03.Cost = 2500 --  normally 3000
Upgrades.Tree.CTroopArmor04.Cost = 3500 -- normally 4800

-- Death Reduction put on Building Strength price track
Upgrades.Tree.CDeathPenalty01.Cost = 500 --Reduced from 600
Upgrades.Tree.CDeathPenalty02.Cost = 1500 -- Reduced form 1800
Upgrades.Tree.CDeathPenalty03.Cost = 3500 --Reduced from 5400 

-- Siege put on Building Strength price track
Upgrades.Tree.CUpgradeStructure01.Cost = 2500 --Reduced from 3200 to normalize price curve
Upgrades.Tree.CUpgradeStructure02.Cost = 3500 --Reduced from 4000 to normalize price curve

-- Schwiegerknecht start

-- Fortified Structure gives 0/15/35/55% more Health to towers (normally 10/25/40/55%)
Buffs.CBuildingHealth01.Affects.MaxHealth = nil
Buffs.CBuildingHealth02.Affects.MaxHealth.Mult = .15
Buffs.CBuildingHealth03.Affects.MaxHealth.Mult = .35
-- Update FS 1 description
ArmyBonuses.CBuildingHealth01.Description = 'Buildings gain +[GetRegenBonus] Health Per Second.'

-- Blacksmith put on Building Strength price track
Upgrades.Tree.CTroopStrength01.Cost = 500 --Reduced from 1200 to normalize price curve
Upgrades.Tree.CTroopStrength02.Cost = 1500 --Reduced from 2400 to normalize price curve
Upgrades.Tree.CTroopStrength03.Cost = 2500 --Reduced from 3000 to normalize price curve
Upgrades.Tree.CTroopStrength04.Cost = 3500 --Reduced from 5400 to normalize price curve
-- Increase Blacksmith Damage Bonus to 20/40/60/80% (normally 20/35/50/65%)
Buffs.CTroopStrength02.Affects.DamageBonus.Mult = 0.4
Buffs.CTroopStrength03.Affects.DamageBonus.Mult = 0.6
Buffs.CTroopStrength04.Affects.DamageBonus.Mult = 0.8
-- Give Blacksmith IV 25% Attack Speed Bonus
Buffs.CTroopStrength04.Affects.RateOfFire = {Mult = 0.25}
-- Update description
ArmyBonuses.CTroopStrength04.GetAttackSpeedBonus = function(self) return math.floor( Buffs['CTroopStrength04'].Affects.RateOfFire.Mult * 100 ) end
ArmyBonuses.CTroopStrength04.Description = 'Constructs a blacksmith, increasing reinforcement damage by +[GetDamageBonus]% and reinforcement attack speed by [GetAttackSpeedBonus]%.'


-- Lower currency gold income to 3/6/9 (from 4/8/12) to remove absolute necessity for Cur3 
Buffs.CGoldIncome01.Affects.GoldProduction.Add = 3
Buffs.CGoldIncome02.Affects.GoldProduction.Add = 6
Buffs.CGoldIncome03.Affects.GoldProduction.Add = 9

-- Increase Armory MaxHealth bonus to 10/25/50/75% (normally 10/20/30/40%)
Buffs.CTroopArmor02.Affects.MaxHealth.Mult = .25
Buffs.CTroopArmor03.Affects.MaxHealth.Mult = .5
Buffs.CTroopArmor04.Affects.MaxHealth.Mult = .75
-- Increase Armory Armor bonus to 150/300/450/600 (normally 100/200/300/400)
Buffs.CTroopArmor01.Affects.Armor.Add = 150
Buffs.CTroopArmor02.Affects.Armor.Add = 300
Buffs.CTroopArmor03.Affects.Armor.Add = 450
Buffs.CTroopArmor04.Affects.Armor.Add = 600

-- Give Building Firepower some range, so it can counter Siege Demolishers.
Buffs.CBuildingStrength02.Affects.MaxRadius = {Add = 2}
Buffs.CBuildingStrength03.Affects.MaxRadius = {Add = 3}
Buffs.CBuildingStrength04.Affects.MaxRadius = {Add = 4}
-- Increase Building Firepower damage bonus to 10/25/50/75% (normally 10/15/20/25%)
Buffs.CBuildingStrength01.Affects.DamageBonus = {Mult = .1}
Buffs.CBuildingStrength02.Affects.DamageBonus = {Mult = .25}
Buffs.CBuildingStrength03.Affects.DamageBonus = {Mult = .5}
Buffs.CBuildingStrength04.Affects.DamageBonus = {Mult = .75}
-- Give Building Firepower IV 25% Tower Attack Speed bonus (normally none)
Buffs.CBuildingStrength04.Affects.RateOfFire = {Mult = .25}

-- Update descriptions
ArmyBonuses.CBuildingStrength02.GetMaxRadius = function(self) return Buffs['CBuildingStrength02'].Affects.MaxRadius.Add end
ArmyBonuses.CBuildingStrength03.GetMaxRadius = function(self) return Buffs['CBuildingStrength03'].Affects.MaxRadius.Add end
ArmyBonuses.CBuildingStrength04.GetMaxRadius = function(self) return Buffs['CBuildingStrength04'].Affects.MaxRadius.Add end
ArmyBonuses.CBuildingStrength04.GetAttackSpeedBonus = function(self) return math.floor(Buffs['CBuildingStrength04'].Affects.RateOfFire.Mult * 100) end
ArmyBonuses.CBuildingStrength02.Description = 'Buildings gain +[GetDamageBonus]% damage and increased splash damage. Tower range increased by [GetMaxRadius].'
ArmyBonuses.CBuildingStrength03.Description = 'Buildings gain +[GetDamageBonus]% damage and increased splash damage. Tower range increased by [GetMaxRadius].'
ArmyBonuses.CBuildingStrength04.Description = 'Buildings gain +[GetDamageBonus]% damage and increased splash damage. Tower range increased by [GetMaxRadius]. Tower Attack Speed increased by [GetAttackSpeedBonus]%.'

--[[ # Leaving this in, in case we wanna add debuffs to tower shots later
-- Add WeaponProc to Building Firepower IV that reduces Armor by 100 per shot (infinite stacks)
Buffs.CBuildingStrength04.OnBuffAffect = function(self, unit)
    unit.Callbacks.OnPostDamage:Add(self.ApplyTargetBuffs, self)
end
Buffs.CBuildingStrength04.ApplyTargetBuffs = function(self, unit, target, data)
    for k, buff in self.TargetBuffs do
        Buff.ApplyBuff(target, buff, unit)
    end
end
Buffs.CBuildingStrength04.TargetBuffs = {
    BuffBlueprint {
        Name = 'CBuildingStrength04_Proc',
        DisplayName = 'Building Firepower',
        Description = 'Armor reduced.',
        BuffType = 'BUILDINGSTRENGTH_PROC',
        EntityCategory = 'MOBILE - UNTARGETABLE',
        Debuff = true,
        CanBeDispelled = true,
        Stacks = 'ALWAYS',
        Duration = 3,
        Affects = {
            Armor = {Add = -100},
        },
        Effects = 'Impedance01',
        EffectsBone = -2,
        Icon = '/CitadelUpgrades/CitadelUpgrade_BuildingStrength02',
    },
}
--ArmyBonuses.CBuildingStrength04.GetArmorReduction = function(self) return Buffs.CBuildingStrength04_Proc.Affects.Armor.Add * -1 end
--ArmyBonuses.CBuildingStrength04.GetProcDuration = function(self) return Buffs.CBuildingStrength04_Proc.Duration end
]]

__moduleinfo.auto_reload = true