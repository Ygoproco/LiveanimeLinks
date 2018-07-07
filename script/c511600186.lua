--リンク・レーション
--Link Ration
--scripted by Larry126
function c511600186.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(c511600186.target)
	e1:SetOperation(c511600186.activate)
	c:RegisterEffect(e1)
end
function c511600186.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and a:GetControler()~=d:GetControler()
		and a:IsType(TYPE_LINK) and d:IsType(TYPE_LINK)
		and (a:GetLink()+d:GetLink())>=5 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c511600186.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c511600186.tkcon)
	e1:SetTarget(c511600186.tktg)
	e1:SetOperation(c511600186.tkop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c511600186.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:GetPreviousControler()~=tp then
		tc=Duel.GetAttackTarget()
	end
	return tc:IsReason(REASON_DESTROY) and tc:IsReason(REASON_BATTLE) and tc:GetPreviousTypeOnField()&TYPE_LINK==TYPE_LINK
end
function c511600186.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600188,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511600186.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600188,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) then
		local token=Duel.CreateToken(tp,511600188)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end