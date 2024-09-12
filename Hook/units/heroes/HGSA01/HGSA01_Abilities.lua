-- Add angelic fury mode 5% speed
Buffs.HGSA01AngelicFuryBuff01.Affects.MoveMult = {Mult = 0.05}
Buffs.HGSA01AngelicFuryBuff02.Affects.MoveMult = {Mult = 0.05}
Buffs.HGSA01AngelicFuryBuff03.Affects.MoveMult = {Mult = 0.05}
Buffs.HGSA01AngelicFuryBuff04.Affects.MoveMult = {Mult = 0.05}

--update angelic fury skill description
Ability.HGSA01AngelicFury01.GetFurySpeed1 = function(self) return math.floor( Buffs['HGSA01AngelicFuryBuff01'].Affects.MoveMult.Mult * 100 ) end
Ability.HGSA01AngelicFury02.GetFurySpeed2 = function(self) return math.floor( Buffs['HGSA01AngelicFuryBuff02'].Affects.MoveMult.Mult * 100 ) end
Ability.HGSA01AngelicFury03.GetFurySpeed3 = function(self) return math.floor( Buffs['HGSA01AngelicFuryBuff03'].Affects.MoveMult.Mult * 100 ) end
Ability.HGSA01AngelicFury04.GetFurySpeed4 = function(self) return math.floor( Buffs['HGSA01AngelicFuryBuff04'].Affects.MoveMult.Mult * 100 ) end

Ability.HGSA01AngelicFury01.Description = 'Regulus enters a divine rage increasing his speed by [GetFurySpeed1]%. His bolts deal [GetDamage] extra damage and explode on contact. Costs [GetCostPerShot] Mana per shot.'
Ability.HGSA01AngelicFury02.Description = 'Regulus enters a divine rage increasing his speed by [GetFurySpeed2]%. His bolts deal [GetDamage] extra damage and explode on contact. Costs [GetCostPerShot] Mana per shot.'
Ability.HGSA01AngelicFury03.Description = 'Regulus enters a divine rage increasing his speed by [GetFurySpeed3]%. His bolts deal [GetDamage] extra damage and explode on contact. Costs [GetCostPerShot] Mana per shot.'
Ability.HGSA01AngelicFury04.Description = 'Regulus enters a divine rage increasing his speed by [GetFurySpeed4]%. His bolts deal [GetDamage] extra damage and explode on contact. Costs [GetCostPerShot] Mana per shot.'

--Update angelic fury buff description
Buffs.HGSA01AngelicFuryBuff01.Description = 'Movement Speed increased. Damage increased. Each shot drains Mana.'
Buffs.HGSA01AngelicFuryBuff02.Description = 'Movement Speed increased. Damage increased. Each shot drains Mana.'
Buffs.HGSA01AngelicFuryBuff03.Description = 'Movement Speed increased. Damage increased. Each shot drains Mana.'
Buffs.HGSA01AngelicFuryBuff04.Description = 'Movement Speed increased. Damage increased. Each shot drains Mana.'

--Increase Maim 2 and 3 to 10% and 15% snare (normally 7 and 10)
Buffs.HGSA01Maim02.Affects.MoveMult.Mult = -0.10
Buffs.HGSA01Maim03.Affects.MoveMult.Mult = -0.15

# REMOVED - Schwiegerknecht
--Increase Deadeye Proc Chance to 10% normally 3
--Ability.HGSA01Deadeye01.WeaponProcChance = 10


-- Schwiegerknecht start

-- Increase Vengeance Damage radius from 10 to 15 to better match the animation
Ability.HGSA01AngelicFuryOn.VengAffectRadius = 15

-- Vengeance gives 25% Movement Speed to allies on activating Angelic Fury
-- and decreases enemy Attack Speed by 20% when deactivating it.
-- Regulus also gains 25% Attack Speed and 45 Weapon Damage for himself.
-- Ally Movement Speed buff
local VeangeanceAlly_MoveSpeed = 0.25
local VeangeanceSelf_AtkSpeed = 0.25
local VeangeanceSelf_WepDamage = 35
local VeangeanceEnemy_AtkSpeed = -0.20
BuffBlueprint {
    Name = 'HGSA01VeangeanceAllyBuff',
    DisplayName = 'Vengeance',
    Description = 'Movement Speed increased.',
    BuffType = 'HGSA01FURYALLY',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = 10,
    Affects = {
        MoveMult = {Mult = VeangeanceAlly_MoveSpeed},
    },
    Icon = '/DGRegulus/NewRegulusvengence01',
}
-- Self Attack Speed and Weapon Damage buff
BuffBlueprint {
    Name = 'HGSA01VeangeanceSelfBuff',
    DisplayName = 'Vengeance',
    Description = 'Attack Speed and Weapon Damage increased.',
    BuffType = 'HGSA01FURYSELF',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = 10,
    Affects = {
        RateOfFire = {Mult = VeangeanceSelf_AtkSpeed},
        DamageRating = {Add = VeangeanceSelf_WepDamage},
    },
    Icon = '/DGRegulus/NewRegulusvengence01',
}
-- Enemy Attack Speed debuff
BuffBlueprint {
    Name = 'HGSA01VeangeanceEnemyDebuff',
    DisplayName = 'Vengeance',
    Description = 'Attack Speed decreased.',
    BuffType = 'HGSA01FURYENEMY',
    Debuff = true,
    Stacks = 'REPLACE',
    Duration = 10,
    Affects = {
        RateOfFire = {Mult = VeangeanceEnemy_AtkSpeed},
    },
    Icon = '/DGRegulus/NewRegulusvengence01',
}

-- Set Range to be the same for both allied buff and enemy debuff
Ability.HGSA01Vengeance01.VengBuffAffectRadius = 15
Ability.HGSA01AngelicFuryOn.VengAllyBuffAffectRadius = Ability.HGSA01Vengeance01.VengBuffAffectRadius
Ability.HGSA01AngelicFuryOff.VengEnemyBuffAffectRadius = Ability.HGSA01Vengeance01.VengBuffAffectRadius

-- Apply the ally buff when activating Angelic Fury
Ability.HGSA01AngelicFuryOn.OnStartAbility = function(self, unit, params)
    # Manages adding the proper buff and proc
    AngelicFuryFunctionalityEntrance(unit)
    # Determines if we should do the damaging mode change or the normal.
    if Validate.HasAbility(unit,'HGSA01Vengeance01') then
        local thd = ForkThread(VengeanceThread, self, unit, params)
        unit.Trash:Add(thd)

        Buff.ApplyBuff(unit, 'HGSA01VeangeanceAllyBuff', unit)
        Buff.ApplyBuff(unit, 'HGSA01VeangeanceSelfBuff', unit)
        
        -- Add Buff to allies, taken from Mass Charm -- Schwiegerknecht
        local pos = table.copy(unit:GetPosition())

        local entities = GetEntitiesInSphere("UNITS", table.copy(unit:GetPosition()), self.VengAllyBuffAffectRadius)
        for k,entity in entities do
            if IsAlly(unit:GetArmy(), entity:GetArmy()) and not entity:IsDead() and not EntityCategoryContains(categories.NOBUFFS, entity) and not EntityCategoryContains(categories.UNTARGETABLE, entity) then
                Buff.ApplyBuff(entity, 'HGSA01VeangeanceAllyBuff', unit)
            end
        end
    else
        local thd = ForkThread(AngelicFuryEnter, self, unit, params)
        unit.Trash:Add(thd)
    end
end
-- Apply enemy debuff when deactivating Angelic Fury
Ability.HGSA01AngelicFuryOff.OnStartAbility = function(self, unit, params)
    # Manages ending the buff
    AngelicFuryFunctionalityEnd(unit)
    local thd = ForkThread(AngelicFuryExit, self, unit, params)
    unit.Trash:Add(thd)

    -- Add Debuff to enemies -- Schwiegerknecht
    if Validate.HasAbility(unit,'HGSA01Vengeance01') then
        local pos = table.copy(unit:GetPosition())

        local entities = GetEntitiesInSphere("UNITS", table.copy(unit:GetPosition()), self.VengEnemyBuffAffectRadius)
        for k,entity in entities do
            if IsEnemy(unit:GetArmy(), entity:GetArmy()) and not entity:IsDead() and not EntityCategoryContains(categories.NOBUFFS, entity) and not EntityCategoryContains(categories.UNTARGETABLE, entity) then
                Buff.ApplyBuff(entity, 'HGSA01VeangeanceEnemyDebuff', unit)
            end
        end
    end
end

-- Add Vengeance description
Ability.HGSA01Vengeance01.GetAllySpeed = function(self) return math.floor( Buffs['HGSA01VeangeanceAllyBuff'].Affects.MoveMult.Mult * 100) end
Ability.HGSA01Vengeance01.GetEnemyAtkDebuff = function(self) return math.floor( Buffs['HGSA01VeangeanceEnemyDebuff'].Affects.RateOfFire.Mult * 100 * -1) end

Ability.HGSA01Vengeance01.GetVengBuffRadius = function(self) return math.floor( Ability['HGSA01Vengeance01'].VengBuffAffectRadius) end
#Ability.HGSA01Vengeance01.GetVengAllyBuffDuration = function(self) return math.floor( Buffs['HGSA01VeangeanceAllyBuff'].Duration) end
#Ability.HGSA01Vengeance01.GetVengEnemyBuffDuration = function(self) return math.floor( Buffs['HGSA01VeangeanceEnemyDebuff'].Duration) end
Ability.HGSA01Vengeance01.GetVengSelfAttackBuff = function(self) return math.floor( Buffs['HGSA01VeangeanceSelfBuff'].Affects.RateOfFire.Mult * 100) end
Ability.HGSA01Vengeance01.GetVengSelfDamageBuff = function(self) return math.floor( Buffs['HGSA01VeangeanceSelfBuff'].Affects.DamageRating.Add) end
Ability.HGSA01Vengeance01.Description = 'Activating Angelic Fury unleashes a nova of holy power around Regulus, dealing [GetDamage] damage and sending nearby enemies flying. He and his nearby allies gain +[GetAllySpeed]% Movement Speed and Regulus himself gains [GetVengSelfDamageBuff] weapon damage and +[GetVengSelfAttackBuff]% Attack Speed. Deactivating Angelic Fury decreases nearby enemies\' Attack Speed by [GetEnemyAtkDebuff]%.'


-- Deadeye adds a stun to Snipe IV instead of being a weapon proc
# Modify Bolt02_script.lua to accept damageTable.Buff as a list

-- Create Debuff
BuffBlueprint {
    Name = 'HGSA01DeadeyeSnipeStun01',
    DisplayName = '<LOC ABILITY_HGSA01_0073>Deadeye Snipe',
    Description = '<LOC ABILITY_HGSA01_0077>Stunned.',
    BuffType = 'HGSA01DEADEYESNIPESTUN',
    EntityCategory = 'MOBILE - UNTARGETABLE',
    Debuff = true,
    CanBeDispelled = true,
    Stacks = 'REPLACE',
    Duration = 0.8,
    Affects = {
        Stun = {Add = 0},
    },
    Icon = '/DGRegulus/NewRegulusDeadeye01',
}

function Snipe(abilityDef, unit, params, buffs, explosion)
    # create muzzle flash effects
    AttachEffectAtBone( unit, 'Projectiles', 'Bolt02Launch', 'sk_Sniper_Turret_Muzzle_REF', unit.TrashOnKilled )
    # create push back effects at Regulus feet
    AttachEffectAtBone( unit, 'Regulus', 'Snipe01PreLaunch03', -2, unit.TrashOnKilled )

    # shoot projectile
    local target = params.Targets[1]
    local dir = VNormal( VDiff(target:GetPosition(),unit:GetPosition()) )
    local proj = unit:CreateProjectileAtBone('/projectiles/Bolt02/Bolt02_proj.bp', 'sk_Sniper_Turret_Muzzle_REF')
    proj:SetOrientation(OrientFromDir(dir), true)
    proj:SetNewTarget(target)
    proj:SetVelocityVector(dir)
    proj:SetVelocity(200)

    local damageTable = {
            Radius = 0,
            Type = 'Spell',
            DamageAction = abilityDef.Name,
            DamageFriendly = false,
            CollideFriendly = false,
            Amount = abilityDef.DamageAmt,
            CanCrit = false,
            CanBeEvaded = false,
            CanBackfire = false,
            CanDamageReturn = false,
            CanMagicResist = false,
            ArmorImmune = true,
            IgnoreDamageRangePercent = true,
            LauncherPosition = unit:GetPosition(),
            Instigator = unit,
        }
    
    -- Pass the buffs into a list instead of having just one.
    if Validate.HasAbility(unit,'HGSA01Track') then
        damageTable.Buff = {'HGSA01Tracked'}
    elseif Validate.HasAbility(unit,'HGSA01Deadeye01') then
        damageTable.Buff = {'HGSA01DeadeyeSnipeStun01'}
    end
    if Validate.HasAbility(unit,'HGSA01Track') and Validate.HasAbility(unit,'HGSA01Deadeye01') then
        damageTable.Buff = {'HGSA01DeadeyeSnipeStun01','HGSA01Tracked'}
    end
    if proj and not proj:BeenDestroyed() then
        proj:PassDamageData(unit,damageTable)
    end
end

-- Remove former Deadeye functionality and update description
Ability.HGSA01Deadeye01.AbilityType = 'Quiet'
Ability.HGSA01Deadeye01.WeaponProcChance = nil
Ability.HGSA01Deadeye01.GetChance = nil
Ability.HGSA01Deadeye01.OnWeaponProc = nil
Ability.HGSA01Deadeye01.GetSnipeStunDuration = function(self) return string.format("%.1f", Buffs['HGSA01DeadeyeSnipeStun01'].Duration) end
Ability.HGSA01Deadeye01.Description = 'Regulus\' arrows stop his enemies dead in their tracks. Snipe now stuns enemies for [GetSnipeStunDuration] seconds, ignoring stun immunities.'


-- Impedance Bolt now immobilizes enemies for 0.5 seconds on WeaponProc
BuffBlueprint {
    Name = 'HGSA01MaimImmobile',
    DisplayName = '<LOC ABILITY_HGSA01_0051>Maim',
    Description = '<LOC ABILITY_HGSA01_0052>Immobilized.',
    BuffType = 'HGSA01IMPEDANCEROOT',
    EntityCategory = 'MOBILE - UNTARGETABLE',
    Debuff = true,
    CanBeDispelled = true,
    Stacks = 'REPLACE',
    Duration = 0.8,
    Affects = {
        UnitImmobile = {Bool = true},
    },
    Icon = '/DGRegulus/NewRegulusDeadeye01',
}
Ability.HGSA01ImpedanceBolt01.OnWeaponProc = function(self, unit, target, damageData)
    Buff.ApplyBuff(target, 'HGSA01ImpedanceBoltDebuff01', unit)
    Buff.ApplyBuff(target, 'HGSA01MaimImmobile', unit)

    # Play altered impact effects on top of normal effects, if the unit is a Hero
    if EntityCategoryContains(categories.HERO, target) then
        FxImpedanceImpact(unit:GetArmy(), damageData.Origin)
    end
end
-- Change Impedance Bolt Description
Ability.HGSA01ImpedanceBolt01.GetImmobileDuration = function(self) return string.format("%.1f", Buffs['HGSA01MaimImmobile'].Duration ) end
Ability.HGSA01ImpedanceBolt01.Description = 'Regulus\' bolts have a [GetChance]% chance to cripple the opponent, doubling the cost of abilities for [GetDuration] seconds and immobilizing them for [GetImmobileDuration] seconds.'


__moduleinfo.auto_reload = true