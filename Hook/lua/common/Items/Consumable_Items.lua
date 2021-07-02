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
-- Increase Sludge Slinger attack speed reduction to 40% (from 30)
Buffs.Item_Consumable_040.Affects.RateOfFire = {Mult = -0.4}

-- Decrease Capture Lock duration to 30 seconds
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
