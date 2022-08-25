-- Needed to give enemy an aura (Sludge Slinger)
local Abil = import('/lua/sim/ability.lua')


-- Make warpstone an instant cast down from 0.5 second cast time
Ability.Item_Consumable_070.CastingTime = 0
-- Increase Warlord punisher range to 20 up from 15
Ability.Item_Consumable_130.RangeMax = 20
-- Decrease Warlord Punisher casting time to 0.3 from 1
Ability.Item_Consumable_130.CastingTime = 0.3
--Decrease Warlord Punisher Cast action animation from 2 seconds 
Ability.Item_Consumable_130.CastAction = 'CastItem1sec'
-- Increase Warlord Punisher chain radius to 10 from 5
Ability.Item_Consumable_130.ChainAffectRadius = 8

-- Schwiegerknecht start
-- Set Warpstone Cooldown to 30 (from 45)
Ability.Item_Consumable_070.Cooldown = 30

-- Increase Sludge Slinger Attack Speed reduction to 40% (from 30)
Buffs.Item_Consumable_040.Affects.RateOfFire = {Mult = -0.4}
-- Increase Sludge Slinger Cooldown to 45 (from 30)
Ability.Item_Consumable_040.Cooldown = 45
--[[ Add 40% HP regen reduction (from 0)
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
-- Counterheal aura added to enemies
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
                AbilityEnable = {Bool = true,},
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


-- Have Sludge Slinger reset Priest heal Cooldown
# ISSUE: Not a debuff = not cleansable = bad
--[[
Buffs.Item_Consumable_040.OnApplyBuff = function(self, unit)
    Buff.ApplyBuff(unit, 'RPriest01HealCooldown01')
    for i = 1,4 do
        Buff.ApplyBuff(unit, 'HighPriest0'..i..'HealCooldown01')
    end
end
-- Increase Sludge Slinger Cooldown to 35 (from 30)
Ability.Item_Consumable_040.Cooldown = 35
-- Adapt description
Items.Item_Consumable_040.Description = 'Use: Decreases target\'s Attack Speed by [GetAttackSpeedReduction]% for [GetDuration] seconds. Also resets the target\'s Countdown for all kinds of Priest heals.'
]]



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
            WaitSeconds(Buffs.Item_Consumable_030.Duration)
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