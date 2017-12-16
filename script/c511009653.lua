--Dark mummy Probe
function c511009653.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23571046,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c511009653.sptg)
	e1:SetOperation(c511009653.spop)
	c:RegisterEffect(e1)
end

function c511009653.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (Duel.GetFieldCard(tp,LOCATION_SZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_SZONE,5))
		end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if tc or tc2 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c511009653.dfilter(c)
	return c:IsDestructable() and c:IsLocation(LOCATION_SZONE) and c:GetSequence()==5
end
function c511009653.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=Duel.SelectMatchingCard(tp,c511009653.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if tc:GetCount()>0 then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end