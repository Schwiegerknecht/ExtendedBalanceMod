local MinionUnit = import('/lua/sim/MinionUnit.lua').MinionUnit
local DefaultMeleeWeapon = import('/lua/sim/MeleeWeapon.lua').DefaultMeleeWeapon

EliteCrawler = Class(MinionUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        MinionUnit.OnStopBeingBuilt(self,builder,layer)

        CreateTemplatedEffectAtPos( 'Vampire', nil, 'Spawn01', self:GetArmy(), self:GetPosition() ) 
    end,

    Weapons = {
        MeleeWeapon = Class(DefaultMeleeWeapon) {
        },
    },
}
TypeClass = EliteCrawler