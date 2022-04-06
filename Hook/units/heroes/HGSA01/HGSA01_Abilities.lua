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
 
--Increase Deadeye Proc Chance to 10% normally 3
Ability.HGSA01Deadeye01.WeaponProcChance = 10


-- Schwiegerknecht start

-- Vengeance gives 25% Movement Speed to allies on activating Angelic Fury and decreases enemy Attack Speed by 20%

-- Ally Movement Speed buff
BuffBlueprint {
    Name = 'HGSA01VeangeanceAllyBuff',
    DisplayName = 'Vengeance',
    Description = 'Movement Speed increased.',
    BuffType = 'HGSA01FURYALLY',
    Debuff = false,
    Stacks = 'REPLACE',
    Duration = 10,
    Affects = {
        MoveMult = {Mult = .25},
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
        RateOfFire = {Mult = -0.20},
    },
    Icon = '/DGRegulus/NewRegulusvengence01',
}

-- Set Range to be the same for both allied buff and enemy debuff
Ability.HGSA01Vengeance01.VengBuffAffectRadius = 150
Ability.HGSA01AngelicFuryOn.VengAllyBuffAffectRadius = Ability.HGSA01Vengeance01.VengBuffAffectRadius
Ability.HGSA01AngelicFuryOff.VengEnemyBuffAffectRadius = Ability.HGSA01Vengeance01.VengBuffAffectRadius
-- Setting common duration doesn't work, BuffName.Duration only seems to take integers.
-- Ability.HGSA01Vengeance01.VengBuffDuration = 5
-- Ability.HGSA01AngelicFuryOn.VengAllyBuffDuration = Ability.HGSA01Vengeance01.VengBuffDuration
-- Ability.HGSA01AngelicFuryOff.VengEnemyBuffDuration = Ability.HGSA01Vengeance01.VengBuffDuration

-- Apply the ally buff when activating Angelic Fury
Ability.HGSA01AngelicFuryOn.OnStartAbility = function(self, unit, params)
    # Manages adding the proper buff and proc
    AngelicFuryFunctionalityEntrance(unit)
    # Determines if we should do the damaging mode change or the normal.
    if Validate.HasAbility(unit,'HGSA01Vengeance01') then
        local thd = ForkThread(VengeanceThread, self, unit, params)
        unit.Trash:Add(thd)

        Buff.ApplyBuff(unit, 'HGSA01VeangeanceAllyBuff', unit)
        
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

-- Add description
Ability.HGSA01Vengeance01.GetAllySpeed = function(self) return math.floor( Buffs['HGSA01VeangeanceAllyBuff'].Affects.MoveMult.Mult * 100) end
Ability.HGSA01Vengeance01.GetEnemyAtkDebuff = function(self) return math.floor( Buffs['HGSA01VeangeanceEnemyDebuff'].Affects.RateOfFire.Mult * 100 * -1) end

Ability.HGSA01Vengeance01.GetVengBuffRadius = function(self) return math.floor( Ability['HGSA01Vengeance01'].VengBuffAffectRadius) end
-- Ability.HGSA01Vengeance01.GetVengBuffDuration = function(self) return math.floor( Ability['HGSA01Vengeance01'].VengBuffDuration) end
Ability.HGSA01Vengeance01.GetVengAllyBuffDuration = function(self) return math.floor( Buffs['HGSA01VeangeanceAllyBuff'].Duration) end
Ability.HGSA01Vengeance01.GetVengEnemyBuffDuration = function(self) return math.floor( Buffs['HGSA01VeangeanceEnemyDebuff'].Duration) end
Ability.HGSA01Vengeance01.Description = 'When Regulus uses Angelic Fury, he unleashes a nova of holy power around him, dealing [GetDamage] damage and sending nearby enemies flying. He also increases his and allies\' Movement Speed by [GetAllySpeed]% for [GetVengAllyBuffDuration] seconds when entering this state and decreases enemies\' Attack Speed by [GetEnemyAtkDebuff]% for [GetVengEnemyBuffDuration] seconds when leaving the state. These effects are applied in range [GetVengBuffRadius].'