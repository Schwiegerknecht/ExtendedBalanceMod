Buffs.HRookPoison.Affects.MoveMult.Mult = -0.15 -- increase slow to 15% from 10%, so 6.3 base speed demigods are slowed to Rook's 5.4 Base Speed.


-- Schwiegerknecht start

-- Power of the Tower mana cost: 400/400/400/400 (normally 400/400/400/200)
Ability.HRookTower04.EnergyCost = 400

-- Add invincibility to Energizer while channeling.
BuffBlueprint {
    Name = 'HRookEnergizerImmune',
    DisplayName = '<LOC ABILITY_HROOK_0060>Energizer',
    Description = '<LOC ABILITY_HROOK_0061>Debuff Immunity.',
    BuffType = 'HROOKENERGIZERIMMUNE',
    Debuff = false,
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        DebuffImmune = {Bool = true},
        Invincible = { Bool = true },
    },
    Icon = '/DGRookAbilities/NewRookEnergizer01',
    OnBuffAffect = function(self, unit, instigator)
        Buff.RemoveBuffsByDebuff(unit, true)
        if not Buff.HasBuff(unit, 'Item_Consumable_150_Use') and not Buff.HasBuff(unit, 'HOAKShield01') and not Buff.HasBuff(unit, 'HOAKShield02') and not Buff.HasBuff(unit, 'HOAKShield03') and not Buff.HasBuff(unit, 'HOAKShield04') then
            unit:SetInvulnerableMesh(true)
        end
    end,
    OnBuffRemove = function(self, unit )
        unit:PlaySound('Forge/DEMIGODS/Oak/snd_dg_oak_shield_end')
        if not Buff.HasBuff(unit, 'Item_Consumable_150_Use') and not Buff.HasBuff(unit, 'HOAKShield01') and not Buff.HasBuff(unit, 'HOAKShield02') and not Buff.HasBuff(unit, 'HOAKShield03') and not Buff.HasBuff(unit, 'HOAKShield04') then
            unit:SetInvulnerableMesh(false)
        end
    end,
}

-- Add stun immunity via StartTransfer
function StartTransfer(def, unit, params)
    local target = params.Targets[1]
    local thd = ForkThread(TransferThread, def, unit, target)
    unit.TrashOnKilled:Add(thd)
    unit.Trash:Add(thd)
    target.Trash:Add(thd)
    if not unit.AbilityData.Rook then
        unit.AbilityData.Rook = {}
    end
    unit.AbilityData.Rook.StructTransThread = thd
    Buff.ApplyBuff(target, 'WeaponDisable', unit)
    Buff.ApplyBuff(unit, 'HRookWeaponDisablePrimary', unit)
    if(Validate.HasAbility(unit, 'HRookArchers01')) then
        for i = 1, 6 do
            local wdbuff = 'HRookWeaponDisableArrow0'..i
            Buff.ApplyBuff(unit, wdbuff, unit)
        end
    end
    unit:GetNavigator():AbortMove()
    Buff.ApplyBuff(unit, 'Immobile', unit)
    if Validate.HasAbility(unit, 'HRookEnergizer') then         -- Schwiegerknecht
        Buff.ApplyBuff(unit, 'HRookEnergizerImmune', unit)
    end
    unit.Character:PlayAction('CastDrainStart')
end

-- Remove the stun immunity in the EndTransfer functions (of which there are two
-- identical ones with different names for some reason)

function EndTransfer(def, unit, target)
    Buff.RemoveBuff(unit, 'Immobile')
    unit.Character:PlayAction('CastDrainEnd')
    local target = unit.AbilityData.Rook.StructTransTarget
    if target and not target:IsDead() then
        if Buff.HasBuff(target, 'WeaponDisable') then
            Buff.RemoveBuff(target, 'WeaponDisable')
        end
    end
    if unit.AbilityData.Rook.StructTransBeam then
        unit.AbilityData.Rook.StructTransBeam:Destroy()
        unit.AbilityData.Rook.StructTransBeam = nil
    end
    if unit.AbilityData.Rook.StructTransThread then
        unit.AbilityData.Rook.StructTransThread:Destroy()
        unit.AbilityData.Rook.StructTransThread = nil
    end
    if Buff.HasBuff(unit, 'HRookWeaponDisablePrimary') then
        Buff.RemoveBuff(unit, 'HRookWeaponDisablePrimary')
    end
    if Buff.HasBuff(unit, 'HRookEnergizerImmune') then  -- Schwiegerknecht
        Buff.RemoveBuff(unit, 'HRookEnergizerImmune')
    end
    if(Validate.HasAbility(unit, 'HRookArchers01')) then
        for i = 1, 6 do
            local wdbuff = 'HRookWeaponDisableArrow0'..i
            if Buff.HasBuff(unit, wdbuff) then
                Buff.RemoveBuff(unit, wdbuff)
            end
        end
    end
    unit.Callbacks.OnKilled:Remove(EndTransfer)
    unit.Callbacks.OnMotionHorzEventChange:Remove(EndTransfer)
    unit.Callbacks.OnStunned:Remove(EndTransfer)
    unit.Callbacks.OnFrozen:Remove(EndTransfer)
    unit.Callbacks.OnAbilityBeginCast:Remove(EndTransferCancel)

    # cleanup effects
    if unit.AbilityData.StructTransEffects then
        for kEffect, vEffect in unit.AbilityData.StructTransEffects do
            vEffect:Destroy()
        end
        unit.AbilityData.StructTransEffects = nil
    end
end

function EndTransferCancel(def, ability, unit)
    Buff.RemoveBuff(unit, 'Immobile')
    unit.Character:PlayAction('CastDrainEnd')
    local target = unit.AbilityData.Rook.StructTransTarget
    if target and not target:IsDead() then
        if Buff.HasBuff(target, 'WeaponDisable') then
            Buff.RemoveBuff(target, 'WeaponDisable')
        end
    end
    if unit.AbilityData.Rook.StructTransBeam then
        unit.AbilityData.Rook.StructTransBeam:Destroy()
        unit.AbilityData.Rook.StructTransBeam = nil
    end
    if unit.AbilityData.Rook.StructTransThread then
        unit.AbilityData.Rook.StructTransThread:Destroy()
        unit.AbilityData.Rook.StructTransThread = nil
    end
    if Buff.HasBuff(unit, 'HRookWeaponDisablePrimary') then
        Buff.RemoveBuff(unit, 'HRookWeaponDisablePrimary')
    end
    if Buff.HasBuff(unit, 'HRookEnergizerImmune') then  -- Schwiegerknecht
        Buff.RemoveBuff(unit, 'HRookEnergizerImmune')
    end
    if(Validate.HasAbility(unit, 'HRookArchers01')) then
        for i = 1, 6 do
            local wdbuff = 'HRookWeaponDisableArrow0'..i
            if Buff.HasBuff(unit, wdbuff) then
                Buff.RemoveBuff(unit, wdbuff)
            end
        end
    end
    unit.Callbacks.OnKilled:Remove(EndTransfer)
    unit.Callbacks.OnMotionHorzEventChange:Remove(EndTransfer)
    unit.Callbacks.OnStunned:Remove(EndTransfer)
    unit.Callbacks.OnFrozen:Remove(EndTransfer)
    unit.Callbacks.OnAbilityBeginCast:Remove(EndTransferCancel)

    # cleanup effects
    if unit.AbilityData.StructTransEffects then
        for kEffect, vEffect in unit.AbilityData.StructTransEffects do
            vEffect:Destroy()
        end
        unit.AbilityData.StructTransEffects = nil
    end
end
-- Adjust description
Ability.HRookEnergizer.Description = 'The Rook drains the energy of structures. When he uses Structural Transfer, his Mana Per Second is increased by [GetManaRegen]% for [GetDuration] seconds. He also gains a damage immunity while channeling.'

-- Clarify Stun Immunities in Boulder Roll descriptions
Ability.HRookBoulderRoll01.GetImmuneDuration = function(self) return Buffs['HRookBoulderRoll01Immune'].Duration end
Ability.HRookBoulderRoll02.GetImmuneDuration = function(self) return Buffs['HRookBoulderRoll02Immune'].Duration end
Ability.HRookBoulderRoll03.GetImmuneDuration = function(self) return Buffs['HRookBoulderRoll03Immune'].Duration end
Ability.HRookBoulderRoll01.Description = 'The Rook rips a chunk of the earth and hurls it at enemies ahead of him, dealing [GetAmount] damage, stunning for [GetDuration] seconds, and throwing smaller units into the air. Enemy Demigods hit receive Stun Immunity for [GetImmuneDuration] seconds afterwards.'
Ability.HRookBoulderRoll02.Description = 'The Rook rips a chunk of the earth and hurls it at enemies ahead of him, dealing [GetAmount] damage, stunning for [GetDuration] seconds, and throwing smaller units into the air. Enemy Demigods hit receive Stun Immunity for [GetImmuneDuration] seconds afterwards.'
Ability.HRookBoulderRoll03.Description = 'The Rook rips a chunk of the earth and hurls it at enemies ahead of him, dealing [GetAmount] damage, stunning for [GetDuration] seconds, and throwing smaller units into the air. Enemy Demigods hit receive Stun Immunity for [GetImmuneDuration] seconds afterwards.'

# FIX: Structural Transfer
############################################################################

-- There is a bug where if you cast Structural Transfer (ST) and within less than
-- about 0.3-0.5 seconds you cast another ability without needing to move away,
-- ST continues channeling, but the other ability still gets cast.
-- This fix moves most of the callbacks for aborting ST to after the initial
-- 1 second waiting time.

function TransferThread(def, unit, target)
    if target:IsDead() then
        EndTransfer(def, unit, target)
    end
    if not unit:IsDead() then -- moved
        -- For OnMotionHorzEventChange callback see below
        unit.Callbacks.OnKilled:Add(EndTransfer, def)
        unit.Callbacks.OnStunned:Add(EndTransfer, def)
        unit.Callbacks.OnFrozen:Add(EndTransfer, def)
        unit.Callbacks.OnAbilityBeginCast:Add(EndTransferCancel, def)
    end
    WaitSeconds(1) -- moved
    unit.AbilityData.Rook.StructTransTarget = target
    
    # create struct transfer effects at target with a vector towards the Rook.
    local unitpos = table.copy(unit:GetPosition())
    unitpos[2] = unitpos[2]+3
    local dir = VDiff(unitpos,target:GetPosition())
    local dist = VLength( dir )
    dir = VNormal(dir)
    local unitbp = target:GetBlueprint()
    local unitheight = unitbp.SizeY
    local unitwidth = (unitbp.SizeX + unitbp.SizeZ) / 2
    local unitVol = (unitbp.SizeX + unitbp.SizeZ + unitheight) / 3
    local army = unit:GetArmy()
    
    #LOG (repr(dist))
    #LOG (repr(unitheight))
    #LOG (repr(unitwidth))

    local fx1 = EffectTemplates.Rook.StructuralTransfer01
    local fx2 = EffectTemplates.Rook.StructuralTransfer02
    local fx3 = EffectTemplates.Rook.StructuralTransfer03
    unit.AbilityData.StructTransEffects = {}
    # Dust and Bricks
    for k, v in fx1 do
        emit = CreateAttachedEmitter( target, -2, army, v )
        emit:SetEmitterCurveParam('EMITRATE_CURVE', unitVol*3.5, 0.0)
        emit:SetEmitterCurveParam('LIFETIME_CURVE', dist, dist*0.28)
        emit:SetEmitterCurveParam('XDIR_CURVE', dir[1], 0.3)
        emit:SetEmitterCurveParam('YDIR_CURVE', dir[2], 0.0)
        emit:SetEmitterCurveParam('ZDIR_CURVE', dir[3], 0.3)
        emit:SetEmitterCurveParam('X_POSITION_CURVE', 0.0, unitwidth)
        emit:SetEmitterCurveParam('Y_POSITION_CURVE', unitheight*0.4, unitheight)
        emit:SetEmitterCurveParam('Z_POSITION_CURVE', 0.0, unitwidth)
        table.insert( unit.AbilityData.StructTransEffects, emit )
    end
    # Sparks
    for k, v in fx2 do
        emit = CreateAttachedEmitter( target, -2, army, v )
        emit:SetEmitterCurveParam('EMITRATE_CURVE', unitVol*3.5, 0.0)
        emit:SetEmitterCurveParam('LIFETIME_CURVE', dist*0.5, dist*0.15)
        emit:SetEmitterCurveParam('XDIR_CURVE', dir[1], 0.6)
        emit:SetEmitterCurveParam('YDIR_CURVE', dir[2], 0.0)
        emit:SetEmitterCurveParam('ZDIR_CURVE', dir[3], 0.6)
        emit:SetEmitterCurveParam('X_POSITION_CURVE', 0.0, unitwidth)
        emit:SetEmitterCurveParam('Y_POSITION_CURVE', unitheight*0.4, unitheight)
        emit:SetEmitterCurveParam('Z_POSITION_CURVE', 0.0, unitwidth)
        table.insert( unit.AbilityData.StructTransEffects, emit )
    end
    # Orange wispy plasma energy
    for k, v in fx3 do
        emit = CreateAttachedEmitter( target, -2, army, v )
        emit:SetEmitterCurveParam('EMITRATE_CURVE', unitVol*0.4, 0.0)
        emit:SetEmitterCurveParam('LIFETIME_CURVE', dist, dist*0.28)
        emit:SetEmitterCurveParam('XDIR_CURVE', dir[1], 0.3)
        emit:SetEmitterCurveParam('YDIR_CURVE', dir[2], 0.0)
        emit:SetEmitterCurveParam('ZDIR_CURVE', dir[3], 0.3)
        emit:SetEmitterCurveParam('X_POSITION_CURVE', 0.0, unitwidth)
        emit:SetEmitterCurveParam('Y_POSITION_CURVE', unitheight*0.4, unitheight)
        emit:SetEmitterCurveParam('Z_POSITION_CURVE', 0.0, unitwidth)
        table.insert( unit.AbilityData.StructTransEffects, emit )
    end

    unit.Character:PlayAction('CastDrainLoop')
    if not unit:IsDead() then
        -- Keep this callback here, because otherwise Transfer gets
        -- aborted if you cast it while walking to the target.
        unit.Callbacks.OnMotionHorzEventChange:Add(EndTransfer, def)
    end

    local data = {
        Instigator = unit,
        InstigatorBp = unit:GetBlueprint(),
        InstigatorArmy = unit:GetArmy(),
        Type = 'Spell',
        DamageAction = def.Name,
        Radius = 0,
        DamageSelf = true,
        DamageFriendly = true,
        ArmorImmune = true,
        CanBackfire = false,
        CanBeEvaded = false,
        CanCrit = false,
        CanDamageReturn = false,
        CanMagicResist = false,
        CanOverKill = true,
        IgnoreDamageRangePercent = true,
        Group = "UNITS",
    }

    for i = 1, def.Pulses do
        if not target:IsDead() and not unit:IsDead() and not unit.Silenced then
            Leech( unit, target, data, def.Amount )
            WaitSeconds(0.5)
        else
            EndTransfer(def, unit, target)
        end
    end
    EndTransfer(def, unit, target)
end

__moduleinfo.auto_reload = true