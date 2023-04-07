-- Needed to give enemy an aura (see Sludge Slinger)
local Abil = import('/lua/sim/ability.lua')


-- Make warpstone an instant cast down from 0.5 second cast time
Ability.Item_Consumable_070.CastingTime = 0
-- Increase Warlord punisher range to 20 up from 15
Ability.Item_Consumable_130.RangeMax = 20
-- Decrease Warlord Punisher casting time to 0.3 from 1
Ability.Item_Consumable_130.CastingTime = 0.3
--Decrease Warlord Punisher Cast action animation from 2 seconds 
Ability.Item_Consumable_130.CastAction = 'CastItem1sec'
-- Increase Warlord Punisher chain radius to 8 from 5
Ability.Item_Consumable_130.ChainAffectRadius = 8

-- Schwiegerknecht start

-- Give Magus Rod 900 Mana (normally 0)
Buffs.Item_Consumable_140_Buff.Affects.MaxEnergy = {Add = 900}
Items.Item_Consumable_140.GetManaBonus = function(self) return Buffs['Item_Consumable_140_Buff'].Affects.MaxEnergy.Add end
table.insert(Items.Item_Consumable_140.Tooltip.Bonuses, '+[GetManaBonus] Mana')

-- Set Warpstone Cooldown to 30 (from 45)
Ability.Item_Consumable_070.Cooldown = 30
-- Give Warpstone 10% base evasion (from 0%)
table.insert( Items.Item_Consumable_070.Abilities, AbilityBlueprint {
    Name = 'Item_Consumable_070_Passive',
    AbilityType = 'Quiet',
    FromItem = 'Item_Consumable_070',
    Icon = 'NewIcons/Gadget/Warpstone',
    Buffs = {
        BuffBlueprint {
            Name = 'Item_Consumable_070_Passive',
            BuffType = 'ITEMCONSUMABLE070PASSIVE',
            Debuff = false,
            EntityCategory = 'ALLUNITS',
            Stacks = 'ALWAYS',
            Duration = -1,
            Affects = {
                Evasion = {Add = 10},
            },
        }
    },
})
-- Add Tooltip
Items.Item_Consumable_070.GetDodgeBonus = function(self) return Buffs['Item_Consumable_070_Passive'].Affects.Evasion.Add end
if not Items.Item_Consumable_070.Tooltip then
    Items.Item_Consumable_070.Tooltip = {}
end
if not Items.Item_Consumable_070.Tooltip.Bonuses then
    Items.Item_Consumable_070.Tooltip.Bonuses = {}
end
table.insert(Items.Item_Consumable_070.Tooltip.Bonuses, '+[GetDodgeBonus]% Dodge')

-- Decrease Capture Lock duration to 30 seconds (from 45)
Buffs.Item_Consumable_030.Duration = 30
Ability.Item_Consumable_030.OnStartAbility = function(self, unit, params)
    ForkThread(
        function()
            local blueprint = params.Targets[1]:GetBlueprint()
            params.Targets[1].CanBeCaptured = false
            params.Targets[1]:ShowBone(blueprint.Display.CaptureLockBone, true)
            # Start Can Not Capture Flag Effect
            AttachEffectsAtBone( params.Targets[1], EffectTemplates.Items.Consumable.DefenseOfVayikraActivate, -2 )
            WaitSeconds(Buffs.Item_Consumable_030.Duration) -- Refer to duration in BuffBlueprint
            if not params.Targets[1]:IsDead() then
                params.Targets[1]:HideBone(blueprint.Display.CaptureLockBone, true)
                params.Targets[1].CanBeCaptured = true
            end
            # End Can Not Capture Flag Effect
            #AttachEffectsAtBone( params.Targets[1], EffectTemplates.Items.Achievement.PurifiedEssenceOfMagicActivate, -2 )
        end
    )
end

-- Decrease Capture Lock cooldown to 40 seconds
Ability.Item_Consumable_030.Cooldown = 40


# Twig of Life
##############
-- Add 15 Health Per Second to Twig of Life
table.insert(Items.Item_Consumable_120.Abilities, AbilityBlueprint {
    Name = 'Item_Consumable_120_Quiet',
    AbilityType = 'Quiet',
    FromItem = 'Item_Consumable_120',
    Icon = 'NewIcons/Wand/Wand4',
    Buffs = {
        BuffBlueprint {
            Name = 'Item_Consumable_120_Quiet',
            BuffType = 'CONSUMABLE120PASSIVE',
            Debuff = false,
            EntityCategory = 'ALLUNITS',
            Stacks = 'ALWAYS',
            Duration = -1,
            Affects = {
                Regen = {Add = 15},
            },
        },
    },
})
Items.Item_Consumable_120.GetRegenBonus = function(self) return Buffs['Item_Consumable_120_Quiet'].Affects.Regen.Add end
if not Items.Item_Consumable_120.Tooltip.Bonuses then
    Items.Item_Consumable_120.Tooltip.Bonuses = {'+[GetRegenBonus] Health Per Second',}
else
    table.insert(Items.Item_Consumable_120.Tooltip.Bonuses, '+[GetRegenBonus] Health Per Second')
end

# Sludge Slinger
################

-- Increase Sludge Slinger Attack Speed reduction to 40% (from 30)
Buffs.Item_Consumable_040.Affects.RateOfFire = {Mult = -0.4}
-- Increase Sludge Slinger Cooldown to 45 (from 30)
Ability.Item_Consumable_040.Cooldown = 45
--[[ Add 50% HP regen reduction (from 0)
Buffs.Item_Consumable_040.Affects.Regen = {Mult = -0.5}
Items.Item_Consumable_040.GetRegen = function(self) return math.floor( Buffs['Item_Consumable_040'].Affects.Regen.Mult * -100 ) end
Buffs.Item_Consumable_040.Description = 'Attack Speed and Health per second reduced.'
Items.Item_Consumable_040.Description = 'Use: Decreases target\'s Attack Speed by [GetAttackSpeedReduction]% and Health per second by [GetRegen]% for [GetDuration] seconds.'
]]

-- FX for Counterheal aura
function FxHealingWind01( unit, trash )
    local fx = AttachCharacterEffectsAtBone( unit, 'leopard_rider', 'HealingWind01', -2, trash )
    for k, vEffect in fx do
        unit.TrashOnKilled:Add(vEffect)
    end
end
function FxHealingWind02( unit, trash )
    local fx = AttachCharacterEffectsAtBone( unit, 'leopard_rider', 'HealingWind02', -2, trash )
    for k, vEffect in fx do
        unit.TrashOnKilled:Add(vEffect)
    end
end
-- On use: Counterheal aura added to enemies
AbilityBlueprint {
    Name = 'Item_Consumable_040_Counterheal',
    DisplayName = '<LOC ITEM_Consumable_0090>Counter Healing',
    Description = '<LOC ITEM_Consumable_0091>You counter the healing of allied priests around you.',
    AbilityType = 'Aura',
    AffectRadius = 15,
    AuraPulseTime = 1,
    TargetAlliance = 'Ally',
    TargetCategory = 'PRIEST',
    Tooltip = {
        TargetAlliance = 'Ally',
    },
    Buffs = {
        BuffBlueprint {
            Name = 'SludgeCounterHealing01',
            Debuff = true,
            CanBeDispelled = true,
            DisplayName = '<LOC ITEM_Consumable_0092>Counter Healing',
            Description = '<LOC ITEM_Consumable_0093>Unable to heal.',
            BuffType = 'SLUDGECOUNTERHEALING',
            Stacks = 'REPLACE',
            Duration = 1,
            Icon = 'NewIcons/Scroll/Scroll2',
            DoNotPulseIcon = true,
            Affects = {
                AbilityEnable = {Bool = false,},
            },
            Effects = 'CounterHeal01',
            EffectsBone = -2,
        },
    },
    CreateAbilityAmbients = function( self, unit, trash )
        FxHealingWind01( unit, trash )
        FxHealingWind02( unit, trash )
    end,
}
--[[
Buffs.Item_Consumable_040.OnBuffAffect = function(self, unit, instigator)
    Abil.AddAbility(unit, 'Item_Consumable_040_Counterheal', true)
end
Buffs.Item_Consumable_040.OnBuffRemove = function(self, unit)
    if unit.Sync.Abilities['Item_Consumable_040_Counterheal'] and not unit.Sync.Abilities['Item_Consumable_040_Counterheal'].Removed then
        Abil.RemoveAbility(unit, 'Item_Consumable_040_Counterheal', true)
    end
end
]]
-- Dummy Buff giving opponent the Counterheal aura
table.insert( Ability.Item_Consumable_040.Buffs, 1, BuffBlueprint {
    Name = 'Item_Consumable_040_Dummy',
    DisplayName = '<LOC ITEM_Consumable_0094>Sludge Slinger',
    Description = '<LOC ITEM_Consumable_0095>Priest healing blocked.',
    BuffType = 'SLUDGEDUMMY',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    Duration = 10,
    Affects = {
        Dummy = {Add = 1},
    },
    Effects = 'Slow01',
    EffectsBone = -2,
    Icon = 'NewIcons/Scroll/Scroll2',
    OnBuffAffect = function(self, unit, instigator)
        Abil.AddAbility(unit, 'Item_Consumable_040_Counterheal', true)
    end,
    OnBuffRemove = function(self, unit)
        if unit.Sync.Abilities['Item_Consumable_040_Counterheal'] and not unit.Sync.Abilities['Item_Consumable_040_Counterheal'].Removed then
            Abil.RemoveAbility(unit, 'Item_Consumable_040_Counterheal', true)
        end
    end,
})
-- Adjust description
Items.Item_Consumable_040.GetAuraDuration = function(self) return Buffs['Item_Consumable_040_Dummy'].Duration end
Items.Item_Consumable_040.Description = 'Use: Decreases target\'s Attack Speed by [GetAttackSpeedReduction]% for [GetDuration] seconds. Also gives the target an aura that prevents priest healing for [GetAuraDuration] seconds.'