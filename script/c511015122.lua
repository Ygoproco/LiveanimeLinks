--Phantom Effect
--cleaned up by MLD
function c511015122.initial_effect(c)
	--negate daamge
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511015122.condition)
	e1:SetTarget(c511015122.target)
	e1:SetOperation(c511015122.operation)
	c:RegisterEffect(e1)
end
function c511015122.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function c511015122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511015123,0,0,-2,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c511015122.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID))
	e1:SetValue(c511015122.damcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511015123,0,0,-1,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	Duel.BreakEffect()
	local token=Duel.CreateToken(tp,511015123)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(e:GetLabel())
	e2:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e3,true)
	Duel.SpecialSummonComplete()
end
function c511015122.damcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cc==0 or r&REASON_EFFECT==0 or cid~=e:GetLabel() then return val end
	e:SetLabel(val)
	return 0
end
