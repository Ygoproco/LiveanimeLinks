--ブレイク＆リバース
--Break & Reverse
--scripted by Larry126
function c511600111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511600111.target)
	e1:SetOperation(c511600111.activate)
	c:RegisterEffect(e1)
end
function c511600111.spfilter(c,e,tp,atk)
	return c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c511600111.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c511600111.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetAttack())
end
function c511600111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511600111.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511600111.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,c511600111.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,0)
end
function c511600111.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c511600111.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp,tc:GetPreviousAttackOnField()) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c511600111.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetPreviousAttackOnField()):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end