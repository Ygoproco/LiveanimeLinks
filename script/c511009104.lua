--Rank-Up-Magic Cipher Ascension
function c511009104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41201386,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511009104.target)
	e1:SetOperation(c511009104.activate)
	c:RegisterEffect(e1)
end
function c511009104.filter1(c,e,tp)
	local rk=c:GetRank()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return pg:GetCount()<=1 and c:IsFaceup() and c:IsSetCard(0xe5) and (rk>0 or c:IsStatus(STATUS_NO_LEVEL)) 
		and Duel.IsExistingMatchingCard(c511009104.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,pg)
end
function c511009104.filter2(c,e,tp,mc,rk,pg)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return pg:GetCount()<=1 and c:IsType(TYPE_XYZ) and mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and c:IsSetCard(0xe5) and mc:IsCanBeXyzMaterial(c,tp) 
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and (pg:GetCount()<=0 or pg:IsContains(mc)) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c511009104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511009104.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511009104.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511009104.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511009104.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(4)
end
function c511009104.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511009104.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,pg)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if Duel.GetMatchingGroupCount(c511009104.filter,tp,LOCATION_MZONE,0,nil)>0 then
			Duel.BreakEffect()
		end
		if sc:IsFaceup() then
			local val=Duel.GetMatchingGroupCount(c511009104.filter,tp,LOCATION_MZONE,0,nil)*500
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(val)
			sc:RegisterEffect(e1)
		end
	end
end
