local prevClass = HQueen
local stanceSwitchTime = 0.8

HQueen = Class(prevClass) {
    
    PackedState = State(prevClass.PackedState) {


        Main = function(self)

            #Buff.ApplyBuff(self, 'Immobile')
            
            if Buff.HasBuff( self, 'HQueenPrimaryWeaponEnable') then
                Buff.RemoveBuff( self, 'HQueenPrimaryWeaponEnable' )
            end            
            Buff.ApplyBuff(self, 'HQueenPrimaryWeaponDisable', self)
            
            self.TransitionImmobilityActive = true
            self.Character:SetCharacter('Queen', true)
            AbilFile.ShowAbilities(self, 'HQUEENPACKED') AbilFile.HideAbilities(self, 'HQUEENUNPACKED')
            self.Character:PlayAction('Close')
            self.AbilityData.Queen.IsPacked = true
            #self:GetNavigator():AbortMove()
            #self.Character.IsMoving = false
            self.Sync.AvatarState = 1
            WaitSeconds(stanceSwitchTime)

            self.Character:PlayIdle()
            
            if Buff.HasBuff( self, 'HQueenPackedWeaponDisable' ) then
                Buff.RemoveBuff( self, 'HQueenPackedWeaponDisable' )
                Buff.ApplyBuff( self, 'HQueenPackedWeaponEnable' )
            end
            
            #Buff.RemoveBuff(self, 'Immobile')
            self.TransitionImmobilityActive = false
            Buff.ApplyBuff(self, 'HQueenPackedBuffs', self)

            if Buff.HasBuff(self, 'HQueenAbilityDisable') then
                Buff.RemoveBuff(self, 'HQueenAbilityDisable')
            end
            self:DestroyAmbientEffects()
        end,
    },

    UnpackedState = State(prevClass.UnpackedState) {

        Main = function(self)
            #Buff.ApplyBuff(self, 'Immobile')
            
            if Buff.HasBuff( self, 'HQueenPackedWeaponEnable') then
                Buff.RemoveBuff( self, 'HQueenPackedWeaponEnable' )
            end
            Buff.ApplyBuff( self, 'HQueenPackedWeaponDisable', self )
            
            self.TransitionImmobilityActive = true
            self.AbilityData.Queen.IsPacked = true
            self.Character:SetCharacter('Queen_Unpacked', true)
            AbilFile.ShowAbilities(self, 'HQUEENUNPACKED') AbilFile.HideAbilities(self, 'HQUEENPACKED')
            self.Character:PlayMove()
            self.Character:PlayAction('Open')
            self.Sync.AvatarState = 2
            WaitSeconds(stanceSwitchTime)
            #self.Character:PlayIdle()
            if Buff.HasBuff(self, 'HQueenPackedBuffs') then
                Buff.RemoveBuff(self, 'HQueenPackedBuffs')
            end

            self.AbilityData.Queen.IsPacked = false
            self:CreateAmbientEffects()
            
            if Buff.HasBuff( self, 'HQueenPrimaryWeaponDisable' ) then
                Buff.RemoveBuff( self, 'HQueenPrimaryWeaponDisable' )
                Buff.ApplyBuff( self, 'HQueenPrimaryWeaponEnable' )
            end
            
            #Buff.RemoveBuff(self, 'Immobile')
            self.TransitionImmobilityActive = false
            if Buff.HasBuff(self, 'HQueenAbilityDisable') then
                Buff.RemoveBuff(self, 'HQueenAbilityDisable')
            end
        end,
    },

}
TypeClass = HQueen