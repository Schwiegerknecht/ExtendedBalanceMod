Buffs.HRookPoison.Affects.MoveMult.Mult = -0.15 -- increase slow to 15% from 10%, so 6.3 base speed demigods are slowed to Rook's 5.4 Base Speed.


-- Schwiegerknecht start

-- Add stun immunity to Energizer while channeling.
BuffBlueprint {
    Name = 'HRookEnergizerDebuffImmune',
    DisplayName = '<LOC ABILITY_HROOK_0060>Energizer',
    Description = '<LOC ABILITY_HROOK_0061>Debuff Immunity.',
    BuffType = 'HROOKENERGIZERIMMUNE',
    Debuff = false,
    Stacks = 'ALWAYS',
    Duration = -1,
    Affects = {
        DebuffImmune = {Bool = true},
    },
    Icon = '/DGRookAbilities/NewRookEnergizer01',
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
        Buff.ApplyBuff(unit, 'HRookEnergizerDebuffImmune', unit)
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
    if Buff.HasBuff(unit, 'HRookEnergizerDebuffImmune') then  -- Schwiegerknecht
        Buff.RemoveBuff(unit, 'HRookEnergizerDebuffImmune')
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
    if Buff.HasBuff(unit, 'HRookEnergizerDebuffImmune') then  -- Schwiegerknecht
        Buff.RemoveBuff(unit, 'HRookEnergizerDebuffImmune')
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
Ability.HRookEnergizer.Description = 'The Rook drains the energy of structures. When he uses Structural Transfer, his Mana Per Second is increased by [GetManaRegen]% for [GetDuration] seconds. He also gains a debuff immunity while channeling.'

-- Clarify Stun Immunities in Boulder Roll descriptions
Ability.HRookBoulderRoll01.GetImmuneDuration = function(self) return Buffs['HRookBoulderRoll01Immune'].Duration end
Ability.HRookBoulderRoll02.GetImmuneDuration = function(self) return Buffs['HRookBoulderRoll02Immune'].Duration end
Ability.HRookBoulderRoll03.GetImmuneDuration = function(self) return Buffs['HRookBoulderRoll03Immune'].Duration end
Ability.HRookBoulderRoll01.Description = 'The Rook rips a chunk of the earth and hurls it at enemies ahead of him, dealing [GetAmount] damage, stunning for [GetDuration] seconds, and throwing smaller units into the air. Enemy Demigods hit receive Stun Immunity for [GetImmuneDuration] seconds afterwards.'
Ability.HRookBoulderRoll02.Description = 'The Rook rips a chunk of the earth and hurls it at enemies ahead of him, dealing [GetAmount] damage, stunning for [GetDuration] seconds, and throwing smaller units into the air. Enemy Demigods hit receive Stun Immunity for [GetImmuneDuration] seconds afterwards.'
Ability.HRookBoulderRoll03.Description = 'The Rook rips a chunk of the earth and hurls it at enemies ahead of him, dealing [GetAmount] damage, stunning for [GetDuration] seconds, and throwing smaller units into the air. Enemy Demigods hit receive Stun Immunity for [GetImmuneDuration] seconds afterwards.'
__moduleinfo.auto_reload = true