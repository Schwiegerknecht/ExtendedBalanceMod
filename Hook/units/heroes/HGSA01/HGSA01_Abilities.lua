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

-- Vengeance gives Movement Speed to allies on activating Angelic Fury

-- Movement Speed buff
BuffBlueprint {
    Name = 'HGSA01VeangeanceAllyBuff',
    DisplayName = 'Vengeance',
    Description = 'Movement Speed increased.',
    BuffType = 'HGSA01FURYALLY',
    Debuff = false,
    Stacks = 'ALWAYS',
    Duration = 10,
    Affects = {
        MoveMult = {Mult = .25},
    },
    Icon = '/DGRegulus/NewRegulusAngelicFury01',
}
Ability.HGSA01AngelicFuryOn.VengBuffAffectRadius = 15
-- Apply the buff when activating Angelic Fury
Ability.HGSA01AngelicFuryOn.OnStartAbility = function(self, unit, params)
    # Manages adding the proper buff and proc
    AngelicFuryFunctionalityEntrance(unit)
    # Determines if we should do the damaging mode change or the normal.
    if Validate.HasAbility(unit,'HGSA01Vengeance01') then
        local thd = ForkThread(VengeanceThread, self, unit, params)
        unit.Trash:Add(thd)

        Buff.ApplyBuff(unit, 'HGSA01VeangeanceAllyBuff', unit)
        
        -- Add Buff to allies, taken from Surge of Faith -- Schwiegerknecht
        local pos = table.copy(unit:GetPosition())
        #local aiBrain = unit:GetAIBrain()
        #local army = unit:GetArmy()

        local entities = GetEntitiesInSphere("UNITS", table.copy(unit:GetPosition()), self.VengBuffAffectRadius)
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