-- Assassin's footguards; add 10% chance to do 1.5X crit, modify description
Items.Item_Boot_030.GetCritChance = function(self) return Ability['Item_Boot_030_Crit'].CritChance end
Items.Item_Boot_030.GetCritDamage = function(self) return Ability['Item_Boot_030_Crit'].CritMult end
if not Items.Item_Boot_030.Tooltip.Passives then 
	Items.Item_Boot_030.Tooltip.Passives = '[GetCritChance]% chance to deal a critical strike for [GetCritDamage]x damage.'
end
table.insert(Items.Item_Boot_030.Abilities, AbilityBlueprint {
	Name = 'Item_Boot_030_Crit',
	AbilityType = 'WeaponCrit',
	CritChance = 10,
	CritMult = 1.5,
})
-- Add 10% Movement Speed to Assassins's Footguards (from 5 in EBM-0.2) -- Schwiegerknecht
Buffs.Item_Boot_030.Affects.MoveMult = {Mult = 0.1}
Items.Item_Boot_030.GetMoveSpeedBonus = function(self) return math.floor( Buffs['Item_Boot_030'].Affects.MoveMult.Mult * 100 ) end
table.insert(Items.Item_Boot_030.Tooltip.Bonuses, '+[GetMoveSpeedBonus]% Movement Speed')
-- Apply Movement Speed buff to minions
Ability.Item_Boot_030.OnAbilityAdded = function(self, unit)
    unit:GetAIBrain():AddArmyBonus( 'Item_Boot_030Army', unit )
end
Ability.Item_Boot_030.OnRemoveAbility = function(self, unit)
    unit:GetAIBrain():RemoveArmyBonus( 'Item_Boot_030Army', unit )
end
ArmyBonusBlueprint {
    Name = 'Item_Boot_030Army',
    ApplyArmies = 'Single',
    UnitCategory = 'MINION',
    RemoveOnUnitDeath = true,
    Buffs = {
        BuffBlueprint {
            Name = 'Item_Boot_030Army',
            BuffType = 'BOOTEVADE2',
            Debuff = false,
            Stacks = 'REPLACE',
            Duration = -1,
            Affects = {
                MoveMult = {Mult = Buffs.Item_Boot_030.Affects.MoveMult.Mult},
            },
        }
    }
}


-- Desperate boots increase trigger % to 50, up from 30 and increase dodge amount to 30% up from 20
Ability.Item_Boot_060_Desperation.HealthPercentTrigger = 0.65 -- EBM-0.3
Buffs.Item_Boot_060_Desperation.Affects.Evasion.Add = 30
-- Add 13% Movement Speed to Desperate Boots -- Schwiegerknecht
Buffs.Item_Boot_060.Affects.MoveMult = {Mult = 0.13}
Items.Item_Boot_060.GetMoveSpeedBonus = function(self) return math.floor( Buffs['Item_Boot_060'].Affects.MoveMult.Mult * 100 ) end
table.insert(Items.Item_Boot_060.Tooltip.Bonuses, '+[GetMoveSpeedBonus]% Movement Speed')
-- Apply Movement Speed buff to minions
Ability.Item_Boot_060.OnAbilityAdded = function(self, unit)
    unit:GetAIBrain():AddArmyBonus( 'Item_Boot_060Army', unit )
end
Ability.Item_Boot_060.OnRemoveAbility = function(self, unit)
    unit:GetAIBrain():RemoveArmyBonus( 'Item_Boot_060Army', unit )
end
ArmyBonusBlueprint {
    Name = 'Item_Boot_060Army',
    ApplyArmies = 'Single',
    UnitCategory = 'MINION',
    RemoveOnUnitDeath = true,
    Buffs = {
        BuffBlueprint {
            Name = 'Item_Boot_060Army',
            BuffType = 'ITEM_BOOT_060_BASE',
            Debuff = false,
            Stacks = 'REPLACE',
            Duration = -1,
            Affects = {
                MoveMult = {Buffs.Item_Boot_060.Affects.MoveMult.Mult},
            },
        }
    }
}


-- Add 450 base armor and 1050 base mana to iron walkers and adjust description
table.insert(Items.Item_Boot_070.Abilities, AbilityBlueprint {
            Name = 'Item_Boot_070_Base',
            AbilityType = 'Quiet',
            FromItem = 'Item_Boot_070',
            Icon = 'NewIcons/Boots/Boot4',
            Buffs = {
               BuffBlueprint {
			Name = 'Item_Boot_070_Base',
			BuffType = 'ITEM_BOOT_070_BASE',
			Debuff = false,
			EntityCategory = 'ALLUNITS',
			Stacks = 'ALWAYS',
			Duration = -1,
			Affects = {
				Armor = {Add = 450},
				MaxEnergy = {Add = 1050, AdjustEnergy = false},
			}
		}
	}
})
Items.Item_Boot_070.GetBaseArmor = function(self) return Buffs['Item_Boot_070_Base'].Affects.Armor.Add end
Items.Item_Boot_070.GetBaseMana = function(self) return Buffs['Item_Boot_070_Base'].Affects.MaxEnergy.Add end
if not Items.Item_Boot_070.Tooltip.Bonuses then 
	Items.Item_Boot_070.Tooltip.Bonuses = {}
end
table.insert(Items.Item_Boot_070.Tooltip.Bonuses, '+[GetBaseArmor] Armor')
table.insert(Items.Item_Boot_070.Tooltip.Bonuses, '+[GetBaseMana] Mana')
-- Add 50 Health per second to the proc and adjust description -- Schwiegerknecht
Buffs.Item_Boot_070_Armor.Affects.Regen = {Add = 50}
Buffs.Item_Boot_070_Armor.Description = 'Armor and Health per second increased.'
Items.Item_Boot_070.GetRegenBonus = function(self) return math.floor( Buffs['Item_Boot_070_Armor'].Affects.Regen.Add ) end
Items.Item_Boot_070.Tooltip.ChanceOnHit = 'Whenever Movement Speed is under [GetTriggerAmount], gain [GetArmorBonus] Armor and [GetRegenBonus] Health per second.'

-- Decrease the speedboost of Journeyman Treads from +50% down to +35% for hero and minions -- Schwiegerknecht
Buffs.Item_Boot_050_Wind.Affects.MoveMult = {Mult = 0.35}
Buffs.Item_Boot_050_WindArmy.Affects.MoveMult = {Buffs.Item_Boot_050_Wind.Affects.MoveMult.Mult}