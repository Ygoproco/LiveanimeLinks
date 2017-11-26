--Nightmare Xyz
function c511000700.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c511000700.condition)
	e1:SetTarget(c511000700.target)
	e1:SetOperation(c511000700.activate)
	c:RegisterEffect(e1)
	if not c511000700.global_check then
		c511000700.global_check=true
		c511000700[0]=true
		c511000700[1]=true
		--check
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		ge1:SetOperation(c511000700.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c511000700.clear)
		Duel.RegisterEffect(ge2,0)
	end
end	
function c511000700.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and c511000700[tp]
end
function c511000700.cfilter(c)
	return c:IsSetCard(0x48) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) 
		and bit.band(c:GetReason(),REASON_DESTROY)==REASON_DESTROY
end
function c511000700.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511000700.cfilter,nil)
	local tc=g:GetFirst()
	while tc do
		c511000700[tc:GetPreviousControler()]=true
		tc=g:GetNext()
	end
end
function c511000700.clear(e,tp,eg,ep,ev,re,r,rp)
	c511000700[0]=false
	c511000700[1]=false
end
function c511000700.filter(c,e,tp,ft,g,pg)
	local ct=c.minxyzct
	return ft>=ct and c:IsRankBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
		and aux.SelectUnselectGroup(g,e,tp,ct,ct,aux.FilterBoolFunction(Group.Includes,pg),0)
end
function c511000700.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511000700.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c511000700.spfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local pg=aux.GetMustBeMaterialGroup(tp,g,tp,nil,nil,REASON_XYZ)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c511000700.filter(chkc,e,tp,ft,g,pg) end
	if chk==0 then return ft>0 and Duel.GetLocationCountFromEx(tp)>0 
		and Duel.IsExistingTarget(c511000700.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ft,g,pg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511000700.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ft,g,pg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511000700.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCountFromEx(tp)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=tc.minxyzct
		local ct2=tc.maxxyzct
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then if ct>1 then return end ct2=math.min(ct2,1) end
		if ft<ct then return end
		if ft<ct2 then ct2=ft end
		local g=Duel.GetMatchingGroup(c511000700.spfilter,tp,LOCATION_GRAVE,0,nil)
		local pg=aux.GetMustBeMaterialGroup(tp,g,tp,nil,nil,REASON_XYZ)
		local sg=aux.SelectUnselectGroup(g,e,tp,ct,ct2,aux.FilterBoolFunction(Group.Includes,pg),1,tp,HINTMSG_SPSUMMON)
		if sg:GetCount()<=0 then return end
		local sc=sg:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetRank())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		tc:SetMaterial(sg)
		Duel.Overlay(tc,sg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
