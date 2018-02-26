--D - doom dance
--fixed by MLD
function c511004415.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511004415.condition)
	e1:SetCost(c511004415.cost)
	e1:SetTarget(c511004415.target)
	e1:SetOperation(c511004415.operation)
	c:RegisterEffect(e1)
end
function c511004415.filter(c,e,tp)
	return c:IsControler(1-tp) and c:IsCanBeEffectTarget(e)
end
function c511004415.condition(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c511004415.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511004415.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c511004415.target(e,tp,eg,ev,ep,re,r,rp,chk,chkc)
	if chkc then return c511004415.filter(chkc,e,tp) and eg:IsContains(chkc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return eg:IsExists(c511004415.filter,1,nil,e,tp) 
			and Duel.IsExistingMatchingCard(c511004415.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=eg:FilterSelect(tp,c511004415.filter,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,c511004415.cfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.SetTargetCard(tg)
	Duel.SetTargetParam(rc:GetAttack())
	Duel.Remove(rc,POS_FACEUP,REASON_COST)
end
function c511004415.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008) and c:GetAttackedCount()~=0
end
function c511004415.operation(e,tp,eg,ev,ep,re,r,rp)
	local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE then
			local ag=Duel.SelectMatchingCard(tp,c511004415.afilter,tp,LOCATION_MZONE,0,1,1,nil)
			local ac=ag:GetFirst()
			if not ac then return end
			Duel.HintSelection(ag)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE)
			ac:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e3:SetLabelObject(tc)
			e3:SetValue(c511004415.atlimit)
			ac:RegisterEffect(e3)
		end
	end
end
function c511004415.atlimit(e,c)
	return c~=e:GetLabelObject()
end
