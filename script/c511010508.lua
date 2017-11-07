--Brave-Eyes Pendulum Dragon (Anime)
--Scripted By TheOnePharaoh
--fixed by MLD
function c511010508.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10f2),aux.FilterBoolFunctionEx(Card.IsRace,RACE_WARRIOR))
	--ATK Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetOperation(c511010508.atkop)
	c:RegisterEffect(e1)
	--always Battle destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(511010508)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c511010508.tg)
	e2:SetValue(c511010508.val)
	c:RegisterEffect(e2)
	aux.CallToken(419)
end
function c511010508.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if tg:GetCount()>0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,511010508)
		local atk=tg:GetCount()*100
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1)
	end
	--Duel.BreakEffect()
	Duel.Readjust()
end
function c511010508.tg(e,c)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc==c
end
function c511010508.val(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
