--Mirror Prison
function c511000970.initial_effect(c)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(c511000970.atcost)
	e1:SetOperation(c511000970.atop)
	c:RegisterEffect(e1)
	--accumulate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+51100970)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
end
function c511000970.atcost(e,c,tp)
	local ct=Duel.GetFlagEffect(tp,51100970)
	return Duel.CheckReleaseGroup(tp,Card.IsRace,ct,c,c:GetRace())
end
function c511000970.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if Duel.IsAttackCostPaid()~=2 and tc:IsLocation(LOCATION_MZONE) then
		if tc:IsRace(RACE_MACHINE+RACE_ZOMBIE) then
			Duel.AttackCostPaid()
		else
			local minc=Duel.GetFlagEffect(tp,511000970)==0 and 0 or 1
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g=Duel.SelectReleaseGroup(tp,Card.IsRace,minc,1,tc,tc:GetRace())
			if g and g:GetCount()>0 then
				Duel.Release(g,REASON_COST)
				Duel.AttackCostPaid()
				Duel.RegisterFlagEffect(tp,511000970,RESET_PHASE+PHASE_DAMAGE,0,1)
			else
				Duel.AttackCostPaid(2)
			end
		end
	end
end
