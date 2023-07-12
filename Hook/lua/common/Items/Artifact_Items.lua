-- Used later in CallRain function -- Schwiegerknecht
local Utils = import('/lua/utilities.lua')
local Buff = import('/lua/sim/buff.lua')
local Entity = import('/lua/sim/entity.lua').Entity
local GetRandomFloat = Utils.GetRandomFloat
-- Necessary ito nerf Unmaker for UB only:
local Validate = import('/lua/common/ValidateAbility.lua')

-- Increase clock of elfinkind dodge to 20, up from 15
Buffs.Item_Artifact_050.Affects.Evasion.Add = 20 


-- Schwiegerknecht start
-- Decrease Ashkandor crit damage to x3, down from x4
Ability.Item_Artifact_100_Crit.CritMult = 3.0

-- Decrease damage mitigation of Bulwark of the Ages to 15%, down from 25%
Buffs.Item_Artifact_120.Affects.DamageTakenMult = {Add = -0.15}

-- Orb of Veiled Storms: lower cooldown to 30 (from 45), increase range to 15 (from 10) and add 12 Mana regen (from 0)
Ability.Item_Artifact_110.Cooldown = 30
Ability.Item_Artifact_110.AffectRadius = 15
Buffs.Item_Artifact_110_2.Affects.EnergyRegen = {Add = 12}
-- Update description
Items.Item_Artifact_110.GetEnergyRegen = function(self) return Buffs['Item_Artifact_110_2'].Affects.EnergyRegen.Add end
table.insert(Items.Item_Artifact_110.Tooltip.Bonuses, '+[GetEnergyRegen] Mana Per Second')

-- Cloak of Flames: Increase Fire Circle radius to 9 and Dmg/tick to 120
Ability.Item_Artifact_040_2.AffectRadius = 9 -- (normally 8)
Ability.Item_Artifact_040_2.DamageAmt = 120 -- (normally 80)


-- Girdle of Giants: CleaveSize 5 (normally 2.5), WeaponDamage 100 (from 50 in vanilla / 150 in v0.2+v0.1)
Ability.Item_Artifact_090_WeaponProc.CleaveSize = 5
Buffs.Item_Artifact_090.Affects.DamageRating.Add = 100


#################################################################################################################
#  Shield of the Undead - NEW ITEM
#################################################################################################################

ItemBlueprint {
    Name = 'Item_Artifact_200',
    DisplayName = '<LOC ITEM_Artifact_2000>Shield of the Undead',
    GetArmorBonus = function(self) return Buffs['Item_Artifact_200_Quiet'].Affects.Armor.Add end,
    GetHealthBonus = function(self) return Buffs['Item_Artifact_200_Quiet'].Affects.MaxHealth.Add end,
    GetProcMoveSlow_1 = function(self) return math.floor(Buffs['Item_Artifact_200_ArmorProcDebuff_1'].Affects.RateOfFire.Mult * 100 * (-1)) end,
    GetProcMoveSlow_2 = function(self) return math.floor(Buffs['Item_Artifact_200_ArmorProcDebuff_2'].Affects.RateOfFire.Mult * 100 * (-1)) end,
    GetProcMoveSlow_3 = function(self) return math.floor(Buffs['Item_Artifact_200_ArmorProcDebuff_3'].Affects.RateOfFire.Mult * 100 * (-1)) end,
    GetProcAttackSlow_1 = function(self) return math.floor(Buffs['Item_Artifact_200_ArmorProcDebuff_1'].Affects.MoveMult.Mult * 100 * (-1)) end,
    GetProcAttackSlow_2 = function(self) return math.floor(Buffs['Item_Artifact_200_ArmorProcDebuff_2'].Affects.MoveMult.Mult * 100 * (-1)) end,
    GetProcAttackSlow_3 = function(self) return math.floor(Buffs['Item_Artifact_200_ArmorProcDebuff_3'].Affects.MoveMult.Mult * 100 * (-1)) end,
    GetArmorProcDuration = function(self) return Ability['Item_Artifact_200_ArmorProc'].ArmorProcDuration end,
    Tooltip = {
        Bonuses = {
            '<LOC ITEM_Artifact_2001>[GetArmorBonus] Armor',
            '<LOC ITEM_Artifact_2002>[GetHealthBonus] Health',
        },
        ChanceOnHit = '<LOC ITEM_Artifact_2003> Enemies attacking you have their Attack Speed and Movement Speed reduced for [GetArmorProcDuration] seconds. This can stack up to 3 times.\nAttack Speed Reduction: 10/20/30%.\nMove Speed Reduction: 5/10/15%',
        --ChanceOnHit = '<LOC ITEM_Artifact_2003> Enemies attacking you have their Attack Speed and Movement Speed reduced for [GetArmorProcDuration] seconds. This can stack up to 3 times. \nAttack Speed Reduction: [GetProcAttackSlow_1], [GetProcAttackSlow_2], [GetProcAttackSlow_3]%. Move Speed Reduction: [GetProcMoveSlow_1], [GetProcMoveSlow_2], [GetProcMoveSlow_3]%',
    },
    Mesh = '/meshes/items/chest/chest_mesh',
    Animation = '/meshes/items/chest/Animations/chest_Idle_anim.gr2',
    MeshScale = 0.10,
    Icon = '../../../../../textures/ui/common/BuffFlags/buff_flag_valor',
    Abilities = {
        AbilityBlueprint {
            Name = 'Item_Artifact_200',
            AbilityType = 'Quiet',
            FromItem = 'Item_Artifact_200',
            Icon = '../../../../../textures/ui/common/BuffFlags/buff_flag_valor',
            Buffs = {
                BuffBlueprint {
                    Name = 'Item_Artifact_200_Quiet',
                    BuffType = 'SHIELDPASSIVE',
                    Debuff = false,
                    EntityCategory = 'ALLUNITS',
                    Stacks = 'ALWAYS',
                    Duration = -1,
                    Affects = {
                        Armor = {Add = 1200},
                        MaxHealth = {Add = 800},
                    },
                }
            },
        },
        AbilityBlueprint {
            Name = 'Item_Artifact_200_ArmorProc',
            AbilityType = 'ArmorProc',
            FromItem = 'Item_Artifact_200',
            Icon = '../../../../../textures/ui/common/BuffFlags/buff_flag_valor',
            ArmorProcChance = 100,
            ArmorProcDuration = 5,
            OnArmorProc = function(self, unit, data) -- See Ability.lua and ForgeUnit.lua
                local instigator = data.Instigator

                -- Since we want to debuff the same attackers as with DamageReturn, check for that
                if data.CanDamageReturn == true and not instigator:IsDead() then
                    if Buff.HasBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_3') then
                        Buff.ApplyBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_3', unit)
                    elseif Buff.HasBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_2') then
                        Buff.RemoveBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_2')
                        Buff.ApplyBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_3', unit)
                    elseif Buff.HasBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_1') then
                        Buff.RemoveBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_1')
                        Buff.ApplyBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_2', unit)
                    else
                        Buff.ApplyBuff(instigator, 'Item_Artifact_200_ArmorProcDebuff_1', unit)
                    end
                end
            end,
        }
    },
}

BuffBlueprint {
    Name = 'Item_Artifact_200_ArmorProcDebuff_1',
    DisplayName = '<LOC ITEM_Artifact_2004>Shield of the Undead - 1 stack',
    BuffType = 'SHIELDARMORPROC',
    Icon = '../../../../../textures/ui/common/BuffFlags/buff_flag_valor',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    Duration = Ability.Item_Artifact_200_ArmorProc.ArmorProcDuration,
    DoNotPulseIcon = true,
    Affects = {
        RateOfFire = {Mult = -0.1},
        MoveMult = {Mult = -0.05}
    },
    Effects = 'Slow01',
    EffectsBone = -2,
}
BuffBlueprint {
    Name = 'Item_Artifact_200_ArmorProcDebuff_2',
    DisplayName = '<LOC ITEM_Artifact_2005>Shield of the Undead - 2 stacks',
    BuffType = 'SHIELDARMORPROC',
    Icon = '../../../../../textures/ui/common/BuffFlags/buff_flag_valor',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    Duration = Ability.Item_Artifact_200_ArmorProc.ArmorProcDuration,
    DoNotPulseIcon = true,
    Affects = {
        RateOfFire = {Mult = -0.2},
        MoveMult = {Mult = -0.1}
    },
    Effects = 'Slow01',
    EffectsBone = -2,
}
BuffBlueprint {
    Name = 'Item_Artifact_200_ArmorProcDebuff_3',
    DisplayName = '<LOC ITEM_Artifact_2006>Shield of the Undead - 3 stacks',
    BuffType = 'SHIELDARMORPROC',
    Icon = '../../../../../textures/ui/common/BuffFlags/buff_flag_valor',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    Duration = Ability.Item_Artifact_200_ArmorProc.ArmorProcDuration,
    DoNotPulseIcon = true,
    Affects = {
        RateOfFire = {Mult = -0.3},
        MoveMult = {Mult = -0.15}
    },
    Effects = 'Slow01',
    EffectsBone = -2,
}

#################################################################################################################
# Stormbringer Rework
#################################################################################################################

-- Remove old description variables
Items.Item_Artifact_080.GetCooldownBonus = nil
Items.Item_Artifact_080.GetManaBonus = nil
Items.Item_Artifact_080.GetManaRegenBonus = nil
Items.Item_Artifact_080.GetProcManaGain = nil


# Lightning Weapon Proc
#################################################################################################################
-- What do storms have? Correct: lightning! Add Nature's Reckoning effect
-- instead of of current proc.
-- Add variables and effects used by lightning function
Ability.Item_Artifact_080_WeaponProc.Chains = 4
Ability.Item_Artifact_080_WeaponProc.ChainTime = 0.1
Ability.Item_Artifact_080_WeaponProc.ChainAffectRadius = 5
Ability.Item_Artifact_080_WeaponProc.DamageAmt = 125
Ability.Item_Artifact_080_WeaponProc.Effects = {
    Base = 'Items',
    Group = 'Runes',
    Beams = 'LightningBeam01',
}
-- Adjust Proc Chance
Ability.Item_Artifact_080_WeaponProc.WeaponProcChance = 50
-- Add lightning function to AbilityBlueprint
Ability.Item_Artifact_080_WeaponProc.LightningThread = function(self, unit, target, damageData)
    local weapon = unit:GetWeaponByLabel( damageData.DamageAction )
    
    #Only Affect weapons that are not tagged with NoItemEffect = true,
    local wepbp = weapon:GetBlueprint()
    if wepbp.NoItemEffect then
        return
    end
    
    local radius = self.ChainAffectRadius
    local beamTrash = TrashBag()
    local chainedUnits = {}
    
    #### Impact Emitters
    local emitIds = AttachEffectsAtBone(target, EffectTemplates.Items.Runes.LightningImpact01, -1)
    
    #### Beam Emitters
    emitIds = AttachBeamEffectOnEntities( self.Effects.Base, self.Effects.Group, self.Effects.Beams, unit, -1, target, -1, unit:GetArmy(), self.unit.TrashOnKilled, target.Trash )
    if emitIds then
        for kEffect, vEffect in emitIds do
            beamTrash:Add(vEffect)
        end
    end
    
    for i = 1, self.Chains do
        
        if target:IsDead() then
            target = unit
        end
        local pos = target:GetPosition()
        local rect = Rect(pos[1] - radius, pos[3] - radius, pos[1] + radius, pos[3] + radius)
        local targets = GetUnitsInRect( rect )
        if not targets then
            break
        end
        
        targets = EntityCategoryFilterDown(categories.ALLUNITS - categories.UNTARGETABLE, targets)
        local noTarget = true
        
        WaitSeconds(self.ChainTime or 0)
        
        for k, v in targets do
            
            if not v:IsDead() then
                
                local allied = IsAlly(unit:GetArmy(), v:GetArmy())
                
                if not allied then
                    local notchained = true
                    
                    for key, chndunit in chainedUnits do
                        if chndunit == v then
                            notchained = false
                        end
                    end
                    
                    if notchained or (self.ChainSameTarget and (target != v or table.getn(targets) <= 1) ) then
                        noTarget = false
                        
                        #### Impact Emitters
                        emitIds = AttachEffectsAtBone(v, EffectTemplates.Items.Runes.LightningImpact01, -1)
                        
                        #### Beam Emitters
                        emitIds = AttachBeamEffectOnEntities( self.Effects.Base, self.Effects.Group, self.Effects.Beams, target, -1, v, -1, target:GetArmy(), self.target.TrashOnKilled, v.Trash )
                        if emitIds then
                            for kEffect, vEffect in emitIds do
                                beamTrash:Add(vEffect)
                            end
                        end
                        
                        local data = {
                            Instigator = unit,
                            InstigatorBp = unit:GetBlueprint(),
                            InstigatorArmy = unit:GetArmy(),
                            Amount = self.DamageAmt,
                            Origin = unit:GetPosition(),
                            IgnoreDamageRangePercent = true,
                            CanBackfire = false,
                            CanLifeSteal = false,
                            CanCrit = false,
                            CanBeEvaded = false,
                            Type = 'Spell',
                            CanMagicResist = true,
                            ArmorImmune = true,
                        }
                        DealDamage(data, v)
                        
                        
                        target = v
                        
                        table.insert(chainedUnits, v)
                        
                        break
                    end
                end
            end
            
        end
        
        if noTarget then
            break
        end
        
    end
    beamTrash:Destroy()
    beamTrash = nil
end
-- Make WeaponProc call lightning function, thereby deleting old Proc
Ability.Item_Artifact_080_WeaponProc.OnWeaponProc = function(self, unit, target, damageData)
    # New Proc
    ForkThread(self.LightningThread, self, unit, target, damageData)
end
-- Update description
Items.Item_Artifact_080.GetDamageBonus = function(self) return Ability['Item_Artifact_080_WeaponProc'].DamageAmt end
Items.Item_Artifact_080.Tooltip.ChanceOnHit = '[GetProcChance]% chance on hit to strike nearby enemies with lightning for [GetDamageBonus] damage.'


# New Active Ability Rain of Ice
#################################################################################################################
-- New active ability that summons a hail storm
-- Rain of Ice function
function CallRain( abilityDef, unit, params, projectile )
    if unit:IsDead() then
        return
    end
    
    # Number of waves of ice/fire to drop
    for j = 1, abilityDef.NumWaves or 1 do
        local balls = abilityDef.NumFireBalls or 10
        local radius = abilityDef.AffectRadius
        for i = 1, balls do
            local tpos = VDiff(params.Target.Position, unit:GetPosition())
            #local tpos = table.copy(params.Target.Position)
            tpos[2] = 16 + Random(2,8)
            
            local horizontal_angle = (2*math.pi) / balls
            local angleInitial = GetRandomFloat( 0, horizontal_angle )
            local xVec, zVec
            local angleVariation = 0.5
            local px, pz

            xVec = math.sin(angleInitial + (i*horizontal_angle) + GetRandomFloat(-angleVariation, angleVariation) )
            zVec = math.cos(angleInitial + (i*horizontal_angle) + GetRandomFloat(-angleVariation, angleVariation) )
            px = GetRandomFloat( 0.0, radius ) * xVec
            pz = GetRandomFloat( 0.0, radius ) * zVec

            local proj = unit:CreateProjectile( projectile, px+tpos[1] - 9, tpos[2], pz+tpos[3], 0, -1, 0)
            proj:TrackTarget(false)
            proj:SetVelocity( 9, Random(-20, -15), 0)
            proj:SetLifetime(20)

            # Create effects at projectile spawn point
            AttachEffectsAtBone( proj, EffectTemplates.Projectiles.FrostBallLaunch02, -2 )
        end
        local pos = params.Target.Position
        local data = {
            Instigator = unit,
            InstigatorBp = unit:GetBlueprint(),
            InstigatorArmy = unit:GetArmy(),
            Origin = pos,
            Amount = abilityDef.DamageAmt,
            Type = abilityDef.DamageType or 'Spell',
            DamageAction = abilityDef.Name,
            Radius = abilityDef.AffectRadius,
            DamageFriendly = false,
            DamageSelf = false,
            Group = "UNITS",
            CanBeEvaded = false,
            CanCrit = false,
            CanBackfire = false,
            CanDamageReturn = false,
            CanMagicResist = true,
            ArmorImmune = true,
        }

        WaitSeconds(1)

        if unit:IsDead() then
            return
        end

        DamageArea(data)
        
        if abilityDef.SlowDebuff == true then
            local entities = GetEntitiesInSphere("UNITS", pos, abilityDef.AffectRadius)
            if j < 5 then
                for k,entity in entities do
                    if IsEnemy(unit:GetArmy(),entity:GetArmy()) and not entity:IsDead() and EntityCategoryContains(categories.MOBILE, entity) and not EntityCategoryContains(categories.NOBUFFS, entity) and not EntityCategoryContains(categories.UNTARGETABLE, entity) then
                        Buff.ApplyBuff(entity, 'Item_Artifact_080_Slow_0'..j, unit)
                        Buff.ApplyBuff(entity, 'Item_Artifact_080_FreezeSlowFx01', unit)
                    end
                end
            elseif j >= 5 then
                for k,entity in entities do
                    if IsEnemy(unit:GetArmy(),entity:GetArmy()) and not entity:IsDead() and EntityCategoryContains(categories.MOBILE, entity) and not EntityCategoryContains(categories.NOBUFFS, entity) and not EntityCategoryContains(categories.UNTARGETABLE, entity) then
                        Buff.ApplyBuff(entity, 'Item_Artifact_080_Slow_Immobile', unit)
                        Buff.ApplyBuff(entity, 'Item_Artifact_080_FreezeSlowFx01', unit)
                    end
                end
            end
        end

        # Wait before dropping next wave
        if j != abilityDef.NumWaves or 1 then
            WaitSeconds(0.75)
        end
    end
end
         
-- Movement Slow Buff
BuffBlueprint {
    Name = 'Item_Artifact_080_Slow_01',
    DisplayName = 'Stormbringer',
    Description = 'Movement Speed reduced.',
    BuffType = 'Item_Artifact_080_SLOWUNITRAIN',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE', -- use 'ALWAYS' for slow that stacks for each wave, 'REPLACE' for singular slow
    Duration = Items.Item_Artifact_080.Abilities.SlowDuration,
    Affects = {
        MoveMult = {Mult = -0.2},
    },
    Icon = '/dgtorchbearer/NewTorchBearRainofIce01',
}
BuffBlueprint {
    Name = 'Item_Artifact_080_Slow_02',
    DisplayName = 'Stormbringer',
    Description = 'Movement Speed reduced.',
    BuffType = 'Item_Artifact_080_SLOWUNITRAIN',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    Duration = Items.Item_Artifact_080.Abilities.SlowDuration,
    Affects = {
        MoveMult = {Mult = -0.4},
    },
    Icon = '/dgtorchbearer/NewTorchBearRainofIce01',
}
BuffBlueprint {
    Name = 'Item_Artifact_080_Slow_03',
    DisplayName = 'Stormbringer',
    Description = 'Movement Speed reduced.',
    BuffType = 'Item_Artifact_080_SLOWUNITRAIN',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    Duration = Items.Item_Artifact_080.Abilities.SlowDuration,
    Affects = {
        MoveMult = {Mult = -0.6},
    },
    Icon = '/dgtorchbearer/NewTorchBearRainofIce01',
}
BuffBlueprint {
    Name = 'Item_Artifact_080_Slow_04',
    DisplayName = 'Stormbringer',
    Description = 'Movement Speed reduced.',
    BuffType = 'Item_Artifact_080_SLOWUNITRAIN',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    Duration = Items.Item_Artifact_080.Abilities.SlowDuration,
    Affects = {
        MoveMult = {Mult = -0.8},
    },
    Icon = '/dgtorchbearer/NewTorchBearRainofIce01',
}
BuffBlueprint {
    Name = 'Item_Artifact_080_Slow_Immobile',
    DisplayName = 'Stormbringer',
    Description = 'Immobilized.',
    BuffType = 'Item_Artifact_080_IMMOBILIZEUNITRAIN',
    Debuff = true,
    CanBeDispelled = true,
    EntityCategory = 'MOBILE',
    Stacks = 'REPLACE',
    
    Duration = 5,
    Affects = {
        UnitImmobile = {Bool = true},
    },
    Effects = 'Impedance01',
    EffectsBone = -2,
    Icon = '/dgtorchbearer/NewTorchBearRainofIce01',
}
BuffBlueprint {
    Name = 'Item_Artifact_080_FreezeSlowFx01',
    DisplayName = 'Deep Freeze',
    BuffType = 'SLOWUNITFX',
    Debuff = true,
    CanBeDispelled = true,
    Stacks = 'REPLACE',
    Duration = Items.Item_Artifact_080.Abilities.SlowDuration,
    Affects = {
        Dummy = {},
    },
    Effects = 'Slow01',
    EffectsBone = -2,
}


-- Make Stormbringer a clickable item
Items.Item_Artifact_080.Useable = true
Items.Item_Artifact_080.SlotLimit = 1
Items.Item_Artifact_080.InventoryType = 'Clickables'

-- New AbilityBlueprint with RainOfIce
-- Simply inserting this (at last index) leads to only single targeting and
-- permanently applying the Quiet Affects from Buffs.Item_Artifact_080.
-- Index 1 works. Not sure why that is.
table.insert(Items.Item_Artifact_080.Abilities, 1, AbilityBlueprint {
    Name = 'Item_Artifact_080_Usable',
    AbilityType = 'TargetedArea',
    AbilityCategory = 'USABLEITEM',
    InventoryType = 'Clickables',
    FromItem = 'Item_Artifact_080',
    ReengageTargetAfterUse = true,
    TargetAlliance = 'Enemy',
    TargetCategory = 'ALLUNITS - UNTARGETABLE',
    TargetingMethod = 'AREAARGETED',
    EnergyCost = 0,
    RangeMax = 20,
    Cooldown = 40,
    DamageAmt = 200,
    AffectRadius = 10,
    NumFireBalls = 8,
    NumWaves = 5,
    DamageType = 'SpellFire',
    SlowDebuff = true,
    SlowDuration = 5,
    CastAction = 'CastFreeze',
    CastingTime = 0.1,
    FollowThroughTime = 0.2,
    Audio = {
        OnStartCasting = {Sound = 'Forge/ITEMS/snd_item_conjure',},
        OnFinishCasting = {Sound = 'Forge/DEMIGODS/Torch_Bearer/snd_dg_torch_rain_of_ice',},
        OnAbortCasting = {Sound = 'Forge/ITEMS/snd_item_abort',},
    },
    OnStartAbility = function(self, unit, params)
        ForkThread(CallRain, self, unit, params, '/projectiles/HailBall01/HailBall01_proj.bp' )
    end,
    Icon = 'NewIcons/Artifacts/Stormbringer',
    Reticule = 'AoE_Ice',
})

-- Update Tooltip and Description
Items.Item_Artifact_080.GetCooldown = function(self) return Ability.Item_Artifact_080_Usable.Cooldown end
Items.Item_Artifact_080.GetDamage = function(self) return Ability.Item_Artifact_080_Usable.DamageAmt end
Items.Item_Artifact_080.GetWaves = function(self) return Ability.Item_Artifact_080_Usable.NumWaves end
Items.Item_Artifact_080.GetMoveSlow01 = function(self) return math.floor(Buffs.Item_Artifact_080_Slow_01.Affects.MoveMult.Mult * 100 * (-1)) end
Items.Item_Artifact_080.GetMoveSlow02 = function(self) return math.floor(Buffs.Item_Artifact_080_Slow_02.Affects.MoveMult.Mult * 100 * (-1)) end
Items.Item_Artifact_080.GetMoveSlow03 = function(self) return math.floor(Buffs.Item_Artifact_080_Slow_03.Affects.MoveMult.Mult * 100 * (-1)) end
Items.Item_Artifact_080.GetMoveSlow04 = function(self) return math.floor(Buffs.Item_Artifact_080_Slow_04.Affects.MoveMult.Mult * 100 * (-1)) end
Items.Item_Artifact_080.GetMovementSlowDuration = function(self) return Ability.Item_Artifact_080_Usable.SlowDuration end
Items.Item_Artifact_080.Tooltip.Cooldown = Items.Item_Artifact_080.GetCooldown
Items.Item_Artifact_080.Description = 'Use: Summon [GetWaves] waves of hail, each doing [GetDamage] damage. The first 4 waves slow enemies by [GetMoveSlow01]/[GetMoveSlow02]/[GetMoveSlow04]/[GetMoveSlow04]%, the last wave immobilizes for [GetMovementSlowDuration] seconds.'
-- Items.Item_Artifact_080.Tooltip.Bonuses = {}
-- Items.Item_Artifact_080.Tooltip.ChanceOnHit = {}



# New Quiet Bonuses
#################################################################################################################

-- Replace old Quiet Bonuses with Attack Speed, adjust Tooltip
Buffs.Item_Artifact_080.Affects = {
    RateOfFire = {Mult = 0.20},
}
Items.Item_Artifact_080.GetRateOfFire = function(self) return math.floor(Buffs['Item_Artifact_080'].Affects.RateOfFire.Mult * 100) end
Items.Item_Artifact_080.Tooltip.Bonuses = {
    '+[GetRateOfFire]% Attack Speed',
}

# Tailwind Movement Speed Aura
#################################################################################################################

-- Healing Wind Fx for Movement Speed Aura
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


table.insert(Items.Item_Artifact_080.Abilities, AbilityBlueprint {
    Name = 'Item_Artifact_080_Aura',
    AbilityType = 'Aura',
    AffectRadius = 15,
    AuraPulseTime = 1,
    TargetAlliance = 'Ally',
    TargetCategory = 'MOBILE - UNTARGETABLE',
    Buffs = {
        BuffBlueprint {
            Name = 'Item_Artifact_080_Aura',
            Debuff = false,
            Duration = 1,
            DisplayName = 'Stormbringer Tailwind',
            Description = 'Movement Speed increased.',
            BuffType = 'STORMBRINGERTAILWIND',
            Icon = 'NewIcons/Artifacts/Stormbringer',
            Stacks = 'REPLACE',
            CanBeEvaded = false,
            Affects = {
                MoveMult = {Mult = 0.10},
            },
        },
    },
    CreateAbilityAmbients = function( self, unit, trash )
        FxHealingWind01( unit, trash )
        FxHealingWind02( unit, trash )
        FxHealingWind01( unit, trash )
        FxHealingWind02( unit, trash )
    end,
}
)

-- Update Tooltip for Aura
Items.Item_Artifact_080.GetMoveBuff = function(self) return math.floor( Buffs['Item_Artifact_080_Aura'].Affects.MoveMult.Mult * 100) end
Items.Item_Artifact_080.GetMoveBuffRange = function(self) return math.floor( Ability['Item_Artifact_080_Aura'].AffectRadius) end
Items.Item_Artifact_080.Tooltip.Auras = '+[GetMoveBuff]% Movement Speed Aura ([GetMoveBuffRange] range)'



#################################################################################################################
# Stormbringer Rework End
#################################################################################################################


#################################################################################################################
# Unmaker Rework
#################################################################################################################

# TODO: 
# Remove all old stats and ability
# Make it a non-clickable item
# BotS ability as Passive
# New stats: SpellDamageMult, Cooldown reduction, Base Mana
# Perhaps add SpellCostMult affectType (see BuffAffects.lua and ForgeUnit.lua and hero ability files)


-- Make it a non-clickable item
Items.Item_Artifact_060.Useable = false
Items.Item_Artifact_060.InventoryType = 'Equipment'

-- Remove old description variables
Items.Item_Artifact_060.GetProcChance = nil
Items.Item_Artifact_060.GetAttackSpeedBonus = nil
Items.Item_Artifact_060.GetProcDuration = nil
Items.Item_Artifact_060.GetUseDuration = nil
Items.Item_Artifact_060.GetDamageBonus = nil
Items.Item_Artifact_060.GetMaxRange = nil
Items.Item_Artifact_060.GetEnergyCost = nil
Items.Item_Artifact_060.GetCastTime = nil
Items.Item_Artifact_060.GetCooldown = nil
Items.Item_Artifact_060.GetDamageBonus = nil
Items.Item_Artifact_060.GetMinionDamageBonus = nil
Items.Item_Artifact_060.GetMinionROFBonus = nil

Items.Item_Artifact_060.Tooltip.MBonuses = nil
Items.Item_Artifact_060.Tooltip.ChanceOnHit = nil
Items.Item_Artifact_060.Description = nil
table.removeByValue(Items.Item_Artifact_060.Tooltip.Bonuses, '<LOC ITEM_Glove_0031>+[GetDamageBonus] Weapon Damage')


-- Mana regen function (taken from Blade of the Serpent)
Leech = function(self, unit, target, data)
    damage = data.Amount
    if(damage > 0) then
        local energyReturn = damage * self.EnergyReturnPercent
        local currentEnergy = (unit.Energy or unit:GetBlueprint().Energy.EnergyStart) or 0
        local newEnergy = energyReturn + currentEnergy

        if(newEnergy > unit.EnergyMax) then
            newEnergy = unit.EnergyMax
        end

        local energyBonus = newEnergy - currentEnergy
        if(energyBonus > 0) then
            unit:SetEnergy(newEnergy)
            energyBonus = math.ceil(energyBonus)
            FloatTextAt(unit:GetFloatTextPositionOffset(0, 1, 0), '+' .. tostring(energyBonus), 'EnergyRegen', unit:GetArmy())
        end
    end
end

-- Overwrite Abilities
if Ability.Item_Artifact_060 then
    Ability.Item_Artifact_060 = nil
end
Items.Item_Artifact_060.Abilities = {
    AbilityBlueprint {
        Name = 'Item_Artifact_060',
        AbilityType = 'Quiet',
        FromItem = 'Item_Artifact_060',
        Icon = 'NewIcons/Artifacts/Unmaker',
        Buffs = {
            BuffBlueprint {
                Name = 'Item_Artifact_060_Quiet',
                BuffType = 'IARTCRIT2QUIET',
                Debuff = false,
                EntityCategory = 'ALLUNITS',
                Stacks = 'ALWAYS',
                Duration = -1,
                Affects = {
                    Cooldown = {Mult = -0.15},
                    MaxEnergy = {Add = 2100, AdjustEnergy = false},
                },
            },
        },
        #No Cooldown for UB
        #OnAbilityAdded = function(self, unit)
        #    if unit:GetBlueprint().Name == '<LOC UNIT_NAME_0014>Unclean Beast' then
        #        if Buff.HasBuff(unit, 'Item_Artifact_060_Quiet') then
        #            Buff.ApplyBuff(unit, 'Item_Artifact_060_UncleanBeast', unit)
        #        end
        #    end
        #end,
        #OnRemoveAbility = function(self, unit)
        #    if Buff.HasBuff(unit, 'Item_Artifact_060_Quiet') then
        #        Buff.RemoveBuff(unit, 'Item_Artifact_060_Quiet')
        #    end
        #    if Buff.HasBuff(unit, 'Item_Artifact_060_UncleanBeast') then
        #        Buff.RemoveBuff(unit, 'Item_Artifact_060_UncleanBeast')
        #    end
        #end,
    },
    AbilityBlueprint {
        Name = 'Item_Artifact_060_ManaLeech',
        AbilityType = 'Quiet',
        FromItem = 'Item_Artifact_060',
        Icon = 'NewIcons/Artifacts/Unmaker',
        Buffs = {
            BuffBlueprint {
                Name = 'Item_Artifact_060_ManaLeech',
                BuffType = 'IARTCRIT2MANALEECH',
                DisplayName = 'Unmaker',
                Description = 'Attacks return Mana.',
                Debuff = false,
                EntityCategory = 'ALLUNITS',
                EnergyReturnPercent = 0.30,
                Stacks = 'ALWAYS',
                Duration = -1,
                Icon = 'NewIcons/Artifacts/Unmaker',
                Affects = {
                },
                OnBuffAffect = function(self, unit, instigator)
                    unit.Callbacks.OnPostDamage:Add(Leech, self)
                end,
                OnBuffRemove = function(self, unit)
                    unit.Callbacks.OnPostDamage:Remove(Leech)
                end,
                Effects = 'Energize01',
                EffectsBone = -2,
            },
        },
    },
}

BuffBlueprint {
    Name = 'Item_Artifact_060_UncleanBeast',
    BuffType = 'IARTCRIT2UNCLEANBEAST',
    Debuff = false,
    EntityCategory = 'ALLUNITS',
    Stacks = 'REPLACE',
    Duration = -1,
    Affects = {
        Cooldown = {Mult = Buffs.Item_Artifact_060_Quiet.Affects.Cooldown.Mult * -1},
    },
}

-- Update description for Buff Item_Artifact_060
-- Items.Item_Artifact_060.GetSpellDamageBonus = function(self) return math.floor(Buffs['Item_Artifact_060'].Affects.SpellDamageMult.Add * 100) end
Items.Item_Artifact_060.GetCooldownBonus = function(self) return math.floor(Buffs['Item_Artifact_060_Quiet'].Affects.Cooldown.Mult * 100 * (-1)) end
Items.Item_Artifact_060.GetManaBonus = function(self) return Buffs['Item_Artifact_060_Quiet'].Affects.MaxEnergy.Add end
-- table.insert(Items.Item_Artifact_060.Tooltip.Bonuses, '+[GetSpellDamageBonus]% Spell Damage')
table.insert(Items.Item_Artifact_060.Tooltip.Bonuses, '-[GetCooldownBonus]% to Ability Cooldowns')
table.insert(Items.Item_Artifact_060.Tooltip.Bonuses, '+[GetManaBonus] Mana')
-- UB Nerf:
-- table.insert(Items.Item_Artifact_060.Tooltip.Bonuses, 'These bonuses do not apply to\nUnclean Beast with Venom Spit\nor Foul Grasp.')

-- Description for mana leech
Items.Item_Artifact_060.GetManaLeechBonus = function(self) return math.floor(Buffs['Item_Artifact_060_ManaLeech'].EnergyReturnPercent * 100) end
table.insert(Items.Item_Artifact_060.Tooltip.Bonuses, 'Gain [GetManaLeechBonus]% of your damage in Mana')