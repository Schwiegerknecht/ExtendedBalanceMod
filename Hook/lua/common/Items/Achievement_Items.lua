--(Reduce Amulet of Teleport cooldown to 30 from 45)
-- Schwiegerknecht: Increase cooldown to 35 secs
Ability.AchievementTeleport.Cooldown = 35
-- Reduce Blood Soaked wand castingtime to 1 down from 2
Ability.AchievementAEHeal.CastingTime = 1 
--Switch blood soaked wand cast animation to 1 second (because we reduced it from 2)
Ability.AchievementAEHeal.CastAction = 'CastItem1sec' 
-- Increase Saam-El's clock speed bonus to 10%, up from 5%
Buffs.AchievementMovement.Affects.MoveMult.Mult = 0.10 
-- Decrease diamond Pendant cooldown by 13%, up from 10%
Buffs.AchievementCooldown.Affects.Cooldown.Mult = -.13 
-- Increase diamond pendant mana bonus to 525 up from 250 (this item was way out of balance whack compared to Staff of renewal, and is even now still weaker)
Buffs.AchievementCooldown.Affects.MaxEnergy.Add = 525 
-- Increase Charm of Life health regeneration to 12 up from 5 (10 from BalMod 1.31) -- Schwiegerknecht
Buffs.AchievementDeathReduction.Affects.Regen.Add = 12 
-- Increase Furious Blade health bonus to 250 up from 100
Buffs.AchievementFlurryPassive.Affects.MaxHealth.Add = 250 
-- Increase pendant of grace demigod dodge to 20% up from 10%
Buffs.AchievementMinionDodge.Affects.Evasion.Add = 20 
-- Increase pendant of grace minion dodge to 20% up from 15%
Buffs.AchievementMinionEvasionBuff.Affects.Evasion.Add = 20 
-- Decrease Cloak of Night cooldown to 45 down from 60
Ability.AchievementMinionInvis.Cooldown = 45 
-- Reduce Blood of the Fallen to 600 health down from 800
Buffs.AchievementHealth.Affects.MaxHealth.Add = 600 
-- Staff of the Warmage, increase mana to 1050 up from 800
Buffs.AchievementMana.Affects.MaxEnergy.Add = 1050 
-- Cape of Plentiful Mana: Increase affect radius from 8 to 15, so this item is easier to use
Ability.AchievementAEMana.AffectRadius = 15
--Increase Wings of the Seraphim affect radius from 8 to 15 so this item is easier to use on teams     
Ability.AchievementAERegen.AffectRadius = 15
-- Poison Dagger attack speed 10% up from 5%,
Buffs.AchievementSnarePassive.Affects.RateOfFire.Mult = .10 
--Essence of Magic reduce cooldown timer to 30
Ability.AchievementFreeSpells.Cooldown = 30 

--Add +250 health and +175 mana to BrillIant Bauble and update description
Buffs.AchievementXPIncome.Affects.MaxHealth = {Add = 250, AdjustEnergy = true}
Buffs.AchievementXPIncome.Affects.MaxEnergy = {Add = 175}
Items.AchievementXPIncome.GetHealthBonus = function(self) return Buffs.AchievementXPIncome.Affects.MaxHealth.Add end
Items.AchievementXPIncome.GetManaBonus = function(self) return Buffs.AchievementXPIncome.Affects.MaxEnergy.Add end
if not Items.AchievementXPIncome.Tooltip.Bonuses then 
	Items.AchievementXPIncome.Tooltip.Bonuses = {}
end
table.insert(Items.AchievementXPIncome.Tooltip.Bonuses, '+[GetHealthBonus] Health')
table.insert(Items.AchievementXPIncome.Tooltip.Bonuses, '+[GetManaBonus] Mana')
-- Increase XP Bonus to 12% (from 10%) -- Schwiegerknecht EBM-0.3
Buffs.AchievementXPIncome.Affects.Experience.Add = 0.12

--Horn of battle +100 life over 10 seconds / normally 50 over 20 seconds
Buffs.AchievementMinionInvulnBuff.Affects.Regen.Add = 100
Buffs.AchievementMinionInvulnBuff.Duration = 10

--Bejeweled Goggle; Crit: 10% chance to do 1.5 damage
--Prepend the crit chance and proc adjustment to the description
local critpassive = '[GetCritChance]% chance to deal a critical strike for [GetCritDamage]x damage.'
Items.AchievementVision.Tooltip.Passives = critpassive .. '\n\n' .. Items.AchievementVision.Tooltip.Passives

--Add the crit chance display functions (the string.format parameter '%.2f' rounds floating point numbers to 2 decimals)
Items.AchievementVision.GetCritChance = function(self) return Ability['AchievementVision_Crit'].CritChance end
Items.AchievementVision.GetCritDamage = function(self) return Ability['AchievementVision_Crit'].CritMult end

--Add the crit ability
table.insert(Items.AchievementVision.Abilities, AbilityBlueprint {
	Name = 'AchievementVision_Crit',
	AbilityType = 'WeaponCrit',
	CritChance = 10,
	CritMult = 1.5,
	Icon = '/NewIcons/AchievementRewards/PolishedCrystalGoggles',
})

--Increase Charred Totem of War damage bonus to 30 up from 15 
Buffs.AchievementMinionDamage.Affects.DamageRating.Add = 30
--add 5% Attack Bonus to Charred Totem of War minions and update description
Buffs.AchievementMinionDamageBuff.Affects.RateOfFire = {Mult = 0.05}
Items.AchievementMinionDamage.GetMinionAttackSpeedBonus = function(self) return math.floor( Buffs['AchievementMinionDamageBuff'].Affects.RateOfFire.Mult * 100 ) end
table.insert(Items.AchievementMinionDamage.Tooltip.MBonuses, '+[GetMinionAttackSpeedBonus]% Minion Attack Speed')


##############################################################################
-- Schwiegerknecht start
##############################################################################

-- Give Staff of the Warmage Mana Regen scaling over time: 4+(0.5*herolevel)
-- Change Ability.AchievementMana_Aura.LevelEnergyRegen to change value
BuffBlueprint{
	Name = 'AchievementMana_LevelEnergyRegen',
	BuffType = 'AchievementMana_LevelEnergyRegen',
	DisplayName = '<LOC ITEM_Achievement_0090>Staff of the Warmage',
	Description = '<LOC ITEM_Achievement_0091>Increasing Mana Regen per level',
	Icon = '/NewIcons/AchievementRewards/StaffoftheWarmage',
	Debuff = false,
	Stacks = 'REPLACE',
	Duration = -1,
	Affects = {
		EnergyRegen = {Add = 0.5}, -- Dummy value, buff gets calculated in OnAuraPulse below
	},
}
-- Add Aura to check hero level, calculate and apply buff
table.insert(Items.AchievementMana.Abilities, AbilityBlueprint {
	Name = 'AchievementMana_Aura',
	AbilityType = 'Aura',
	AffectRadius = 1,
	AuraPulseTime = 1,
	LevelEnergyRegen = 0.5,
	Icon = 'NewIcons/Helm/Helm1',
	TargetAlliance = 'Ally',
	TargetCategory = 'HERO - UNTARGETABLE',
	OnAuraPulse = function(self, unit)
		local aiBrain = unit:GetAIBrain()
		local hero = aiBrain:GetHero()
		local herolvl = hero:GetLevel()
		local addMana = herolvl * self.LevelEnergyRegen

		Buffs['AchievementMana_LevelEnergyRegen'].Affects.EnergyRegen.Add = addMana
		Buff.ApplyBuff(unit, 'AchievementMana_LevelEnergyRegen', unit)
	end,
})
Buffs.AchievementMana.Affects.EnergyRegen = {Add = 4}
-- Add description
Items.AchievementMana.GetManaRegenBonus = function(self) return Buffs['AchievementMana'].Affects.EnergyRegen.Add end
Items.AchievementMana.GetManaLevelRegen = function(self) return string.format("%.1f", Ability['AchievementMana_Aura'].LevelEnergyRegen) end
table.insert(Items.AchievementMana.Tooltip.Bonuses, '+[GetManaRegenBonus] Mana Per Second')
table.insert(Items.AchievementMana.Tooltip.Bonuses, '+[GetManaLevelRegen] Mana Per Second per hero level')
-- End of Staff of the Warmage change

-- Make Bejeweled Goggles a useable item
Items.AchievementVision.Useable = true
-- Add useable ability to place Wards (EBM-0.3)
-- Insert the ability at beginning of the Abilities Table
table.insert(Items.AchievementVision.Abilities, 1, AbilityBlueprint {
	Name = 'AchievementVision_Use',
	DisplayName = '<LOC ITEM_Achievement_0010>Bejeweled Goggles',
	AbilityType = 'TargetedArea',
	AbilityCategory = 'USABLEITEM',
	TargetAlliance = 'Any',
	TargetCategory = 'ALLUNITS - UNTARGETABLE',
	TargetingMethod = 'AREAARGETED',
	Icon = '/NewIcons/AchievementRewards/PolishedCrystalGoggles', # 'NewIcons/Gadget/Totemofrevelation'
	AffectRadius = 8,
	Cooldown = 60,
	RangeMax = 7,
	RangeMin = 1,
	CastingTime = 1,
	InventoryType = 'Achievement',
	CastAction = 'CastItem1sec',
	Audio = {
		 OnStartCasting = {Sound = 'Forge/ITEMS/snd_item_conjure',},
		 OnFinishCasting = {Sound = 'Forge/ITEMS/Consumable/snd_item_consumable_Item_Consumable_020',},
		 OnAbortCasting = {Sound = 'Forge/ITEMS/snd_item_abort',},
	},
	ErrorMessage = '<LOC error_0030>Cannot place that here.',
	ErrorVO = 'Noplace',
	FromItem = 'AchievementVision',
	Reticule = 'AoE_Revelation',
	OnStartAbility = function(self, unit, params)
		local x = params.Target.Position[1]
		local z = params.Target.Position[3]
		local tower = CreateUnitHPR( 'UGBShop01Ward01', unit:GetArmy(), x, GetSurfaceHeight(x, z), z, 0, 0, 0)

		AttachEffectsAtBone( tower, EffectTemplates.Items.Consumable.TotemOfRevelationActivate, -2 )
	end,
})
-- Adapt description
Items.AchievementVision.GetCooldown = function(self) return Ability.AchievementVision_Use.Cooldown end
Items.AchievementVision.Description = 'On Use: Place Wards that last for 120 seconds. [GetCooldown] seconds Cooldown.'
--End of goggle change

-- Make Totem of War an useable item
Items.AchievementMinionDamage.Useable = true
-- On use give minions +25 Weapon Damage, +15% Movement Speed and +15% Attack Speed.
table.insert(Items.AchievementMinionDamage.Abilities, 1, AbilityBlueprint {
	Name = 'AchievementMinionDamageUseBuff',
	AbilityType = 'Instant',
	AbilityCategory = 'USABLEITEM',
	TargetAlliance = 'Ally',
	TargetCategory = 'ALLUNITS - UNTARGETABLE',
	ReengageTargetAfterUse = true,
	Cooldown = 45,
	EnergyCost = 0,
	Icon = '/NewIcons/AchievementRewards/CharredTotemofWar',
	Audio = {
		OnStartCasting = {Sound = 'Forge/ITEMS/snd_item_conjure',},
		OnFinishCasting = {Sound = 'Forge/ITEMS/Artifact/snd_item_artifact_Item_Artifact_060',}, # Wand of Speed: Forge/ITEMS/Consumable/snd_item_consumable_Item_Consumable_050
		OnAbortCasting = {Sound = 'Forge/ITEMS/snd_item_abort',},
	},
	FromItem = 'AchievementMinionDamage',
	OnStartAbility = function(self, unit, params)
		AttachEffectsAtBone( unit, EffectTemplates.Items.Artifacts.UnmakerActivate, -2 ) # EffectTemplates.Items.Achievement.PurifiedEssenceOfMagicActivate
		local aiBrain = unit:GetAIBrain()
		local minions = aiBrain:GetListOfUnits(categories.MINION, false)
		for _,minion in minions do
			Buff.ApplyBuff(minion, 'AchievementMinionDamageUseBuff', unit)
		end
	end,
})
ArmyBonusBlueprint {
    Name = 'AchievementMinionDamageUseBuff',
    DisplayName = '<LOC ITEM_Achievement_0048>Totem of War',
    ApplyArmies = 'Single',
    UnitCategory = 'MINION',
    InventoryType = 'Achievement',
    RemoveOnUnitDeath = true,
    Buffs = {
        BuffBlueprint {
            Name = 'AchievementMinionDamageUseBuff',
            DisplayName = '<LOC ITEM_Achievement_0048>Totem of War',
            Description = '<LOC ITEM_Achievement_0049>Increased Damage, Movement and Attack Speed.',
            BuffType = 'ACHIEVEMENTMINIONDAMAGEUSEBUFF',
            Debuff = false,
            Stacks = 'REPLACE',
            EntityCategory = 'MINION',
            Duration = 10,
            Icon = '/NewIcons/AchievementRewards/CharredTotemofWar',
            Affects = {
                DamageRating = {Add = 10},
                MoveMult = {Mult = 0.15},
                RateOfFire = {Mult = 0.15},
            },
        }
    }
}
-- Update Totem of War description
Items.AchievementMinionDamage.GetDamageRating = function(self) return Buffs.AchievementMinionDamageUseBuff.Affects.DamageRating.Add end
Items.AchievementMinionDamage.GetMoveMult = function(self) return math.floor( Buffs.AchievementMinionDamageUseBuff.Affects.MoveMult.Mult * 100 ) end
Items.AchievementMinionDamage.GetRateOfFire = function(self) return math.floor( Buffs.AchievementMinionDamageUseBuff.Affects.RateOfFire.Mult * 100 ) end
Items.AchievementMinionDamage.GetDuration = function(self) return Buffs.AchievementMinionDamageUseBuff.Duration end
Items.AchievementMinionDamage.Description = 'Use: Minions gain +[GetDamageRating] Weapon Damage, +[GetMoveMult]% Movement Speed and +[GetRateOfFire]% Attack Speed for [GetDuration] seconds.'
-- End of Totem change

-- Increase Wings of the Seraphim Cooldown to 60 (from 45)
Ability.AchievementAERegen.Cooldown = 60
-- Decrease Seraphim Regen to 170 (from 200)
Buffs.AchievementAERegen.Affects.Regen.Add = 170
-- Have Seraphim only interrupt when stunned or frozen
Buffs.AchievementAERegen.OnApplyBuff = function(self, unit, instigator)
	unit.Callbacks.OnStunned:Add(self.SeraphimStunned, self)
	unit.Callbacks.OnFrozen:Add(self.SeraphimStunned, self)
end
Buffs.AchievementAERegen.OnBuffRemove = function(self,unit)
	unit.Callbacks.OnStunned:Remove(self.SeraphimStunned)
	unit.Callbacks.OnFrozen:Remove(self.SeraphimStunned)
end
Buffs.AchievementAERegen.SeraphimStunned = function(self, unit, data)
	if Buff.HasBuff(unit, 'AchievementAERegen') then
		Buff.RemoveBuff(unit, 'AchievementAERegen')
	end
	unit.Callbacks.OnStunned:Remove(self.SeraphimStunned)
	unit.Callbacks.OnFrozen:Remove(self.SeraphimStunned)
end
-- Adjust description
Items.AchievementAERegen.GetAffectRadius = function(self) return Ability['AchievementAERegen'].AffectRadius end
Items.AchievementAERegen.Description = 'Use: Ally Demigods in Radius [GetAffectRadius] receive +[GetRegenBonus] Health Per Second for [GetDuration] seconds. Stuns, Freezes or Interrupts will break this effect.\n\nThe effect works only on Demigods.'

-- Add minion HP regeneration to Tome of Endurance
Buffs.AchievementMinionHealthBuff.Affects.Regen = {Add = 5}
Items.AchievementMinionHealth.GetMinionRegenBonus = function(self) return Buffs['AchievementMinionHealthBuff'].Affects.Regen.Add end
table.insert(Items.AchievementMinionHealth.Tooltip.MBonuses, '+[GetMinionRegenBonus] Minion Health Per Second')

-- Increase Dark Crimson Vial Cooldown to 60 seconds
Ability.AchievementPotion.Cooldown = 60
-- Decrease Dark Crimson Vial heal to 30% (from 33%)
Ability.AchievementPotion.RegenAmount = 0.3

-- Give Mard's Hammer Weapon Damage scaling with level
-- Add 3 Weapon Damage per level (Change Ability.AchievementDamage_Aura.LevelDamageRating to change value)
BuffBlueprint{
	Name = 'AchievementDamage_LevelDamageRating',
	BuffType = 'AchievementDamage_LevelDamageRating',
	DisplayName = '<LOC ITEM_Achievement_0067>Mard\'s Hammer',
	Description = '<LOC ITEM_Achievement_0068>Increasing Damage per level',
	Icon = '/NewIcons/AchievementRewards/HammerofDestruction',
	Debuff = false,
	Stacks = 'REPLACE',
	Duration = -1,
	Affects = {
		DamageRating = {Add = 3}, -- Dummy value, buff gets calculated in OnAuraPulse, below
	},
}
-- Add Aura to check hero level, calculate and apply buff
table.insert(Items.AchievementDamage.Abilities, AbilityBlueprint {
	Name = 'AchievementDamage_Aura',
	AbilityType = 'Aura',
	AffectRadius = 1,
	AuraPulseTime = 1,
	LevelDamageRating = 3,
	Icon = 'NewIcons/AchievementRewards/HammerofDestruction',
	TargetAlliance = 'Ally',
	TargetCategory = 'HERO - UNTARGETABLE',
	OnAuraPulse = function(self, unit)
		local aiBrain = unit:GetAIBrain()
		local hero = aiBrain:GetHero()
		local herolvl = hero:GetLevel()
		local addDamage = herolvl * self.LevelDamageRating

		Buffs['AchievementDamage_LevelDamageRating'].Affects.DamageRating.Add = addDamage
		Buff.ApplyBuff(unit, 'AchievementDamage_LevelDamageRating', unit)
	end,
})
-- Add Tooltip
Items.AchievementDamage.GetLevelDamageRating = function(self) return Ability['AchievementDamage_Aura'].LevelDamageRating end
table.insert(Items.AchievementDamage.Tooltip.Bonuses, '+[GetLevelDamageRating] Damage Rating per hero level')

-- Add WeaponProc that reduces Armor by 40 per level
-- Create Debuff
BuffBlueprint{
	Name = 'AchievementDamage_LevelArmorReduction',
	BuffType = 'AchievementDamage_LevelArmorReduction',
	DisplayName = '<LOC ITEM_Achievement_0069>Mard\'s Hammer',
	Description = '<LOC ITEM_Achievement_0071>Armor Reduced',
	Icon = '/NewIcons/AchievementRewards/HammerofDestruction',
	Debuff = true,
	Stacks = 'REPLACE',
	Duration = 3,
	Affects = {
		Armor = {Add = -40}, -- Dummy value, buff gets calculated in OnWeaponProc, below
	},
}
-- Add WeaponProc
table.insert(Items.AchievementDamage.Abilities, 1, AbilityBlueprint {
	Name = 'AchievementDamage_Proc',
	AbilityType = 'WeaponProc',
	LevelArmorReduction = 40,
	Icon = 'NewIcons/AchievementRewards/HammerofDestruction',
	FromItem = 'AchievementDamage',
	WeaponProcChance = 100,
    WeaponProcChanceRanged = 100,
	OnWeaponProc = function(self, unit, target, damageData)
		local aiBrain = unit:GetAIBrain()
		local hero = aiBrain:GetHero()
		local herolvl = hero:GetLevel()
		local addDamage = herolvl * self.LevelArmorReduction * -1

		Buffs['AchievementDamage_LevelArmorReduction'].Affects.Armor.Add = addDamage
		Buff.ApplyBuff(target, 'AchievementDamage_LevelArmorReduction', unit)
	end,
})
-- Add Tooltip
Items.AchievementDamage.GetLevelArmorReduction = function(self) return Ability['AchievementDamage_Proc'].LevelArmorReduction end
Items.AchievementDamage.GetArmorReductionDuration = function(self) return Buffs['AchievementDamage_LevelArmorReduction'].Duration end
Items.AchievementDamage.Tooltip.ChanceOnHit = 'Autoattacks apply [GetLevelArmorReduction] Armor Reduction per hero level to the target for [GetArmorReductionDuration] seconds.'
-- End of Mard's Hammer change

-- Make Symbol of Purity an Area of Effect affecting allied Demigods.
-- Increase Cooldown to 45 seconds (from 30)
Ability.AchievementPure.Cooldown = 45
-- Set Radius to 15 (from 0)
Ability.AchievementPure.AffectRadius = 15
-- Use modified RemoveBuffsByDebuff so that Stuns (and Interrupts) are still not cleansed.
--[[ unit.Buffs.BuffTable has the structure:
{
	BUFFTYPE1 ={
		SomeSpecificBuff01={ BuffName="SomeSpecificBuff01", Count=Z, Trash={ } }
		SomeSpecificBuff02={ BuffName="SomeSpecificBuff02", Count=Z, Trash={ } }
	},
	BUFFTYPE2 ={
		SomeSpecificBuff01={ BuffName="SomeSpecificBuff01", Count=Z, Trash={ } }
		SomeSpecificBuffn={ BuffName="SomeSpecificBuffn", Count=Z, Trash={ } }
	},
}
]]
function RemoveDebuffsExceptStuns(unit, debuff)
    local removeBuffs = {}
	-- Go through buffTbl, equal to BUFFTYPEX
    for buffType, buffTbl in unit.Buffs.BuffTable do
		-- Go through buffName, equal to SomeSpecificBuff01, equal to buffDef.BuffName
        for buffName, buffDef in buffTbl do
            if(Buffs[buffName].Debuff == debuff) then
                if(Buffs[buffName].CanBeDispelled == true) and not (Buffs[buffName].Affects.Stun or Buffs[buffName].Affects.Interrupt) then
                    table.insert( removeBuffs, buffName )
                end
            end
        end
    end
	-- Uncomment to see your Bufftable in the log:
	--LOG(repr(unit.Buffs.BuffTable))
    for _,buffName in removeBuffs do
        Buff.RemoveBuff(unit, buffName, true)
    end
end
-- Remove old OnStartAbility.
-- It will become OnApplyBuff, since the effect needs to be applied to several units.
Ability.AchievementPure.OnStartAbility = nil
-- Make the ability affect Demigods
Ability.AchievementPure.TargetCategory = 'HERO - UNTARGETABLE'
-- Apply a dummy buff to Allies
Ability.AchievementPure.Buffs = { }
table.insert(Ability.AchievementPure.Buffs,	BuffBlueprint {
		Name = 'AchievementPure_Aoe',
		DisplayName = 'Symbol of Purity',
		Description = 'All debuffs except stuns removed.',
		BuffType = 'PURITYBUFFAOE',
		Icon = '/NewIcons/AchievementRewards/HolysymbolofPurity',
		Debuff = false,
		EntityCategory = 'ALLUNITS',
		Stacks = 'ALWAYS',
		Duration = 0.5,
		Affects = {
			Dummy = {Add = 0.1},
		},
		# Effects = 'HolySymbolActivate',
		# EffectsBone = -2,
		OnApplyBuff = function(self, unit, params)
			-- Replace Buff.RemoveBuffsByDebuff with the modified function
			RemoveDebuffsExceptStuns(unit, true)
			AttachEffectsAtBone( unit, EffectTemplates.Items.Achievement.HolySymbolActivate, -2 )
		end,
	}
)
-- Adjust description
Items.AchievementPure.GetMaxRange = function(self) return Ability['AchievementPure'].AffectRadius end
Items.AchievementPure.Description = 'Use: Purge all negative effects except stuns and interrupts. Affects all allied Demigods in range [GetMaxRange]. Cannot use while stunned or frozen.'
-- End of Symbol of Purity change


-- Give Cape of Plentiful 300 base Mana and 5 Mana Regeneration (from 0/0)
table.insert(Items.AchievementAEMana.Abilities, AbilityBlueprint {
	Name = 'AchievementAEMana_Base',
	AbilityType = 'Quiet',
	FromItem = 'AchievementAEMana',
	Icon = '/NewIcons/AchievementRewards/CapeofPlentifulMana',
	Buffs = {
		BuffBlueprint {
			Name = 'AchievementAEMana_Base',
			BuffType = 'ACHIEVEMENTAEManaBASE',
			Debuff = false,
			EntityCategory = 'ALLUNITS',
			Stacks = 'ALWAYS',
			Duration = -1,
			Affects = {
				MaxEnergy = {Add = 300, AdjustEnergy = false},
				EnergyRegen = {Add = 5},
			},
		}
	},
})
-- Add Tooltip
if not Items.AchievementAEMana.Tooltip then
	Items.AchievementAEMana.Tooltip = {}
end
if not Items.AchievementAEMana.Tooltip.Bonuses then
	Items.AchievementAEMana.Tooltip.Bonuses = {}
end
Items.AchievementAEMana.GetBaseMana = function(self) return Buffs.AchievementAEMana_Base.Affects.MaxEnergy.Add end
Items.AchievementAEMana.GetBaseEnergyRegen = function(self) return Buffs.AchievementAEMana_Base.Affects.EnergyRegen.Add end
table.insert(Items.AchievementAEMana.Tooltip.Bonuses, '+[GetBaseMana] Mana')
table.insert(Items.AchievementAEMana.Tooltip.Bonuses, '+[GetBaseEnergyRegen] Mana Per Second')
-- Make description of Cape of Plentiful Mana more accurate
Items.AchievementAEMana.GetAffectRadius = function(self) return Ability['AchievementAEMana'].AffectRadius end
Items.AchievementAEMana.Description = 'Use: Ally Demigods in Radius [GetAffectRadius] receive +[GetRegenBonus]% Mana Per Second for [GetDuration] seconds.'
-- End of Cape of Plentiful Mana change