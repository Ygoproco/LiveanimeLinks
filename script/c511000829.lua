--Re-Xyz
function c511000829.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000829.target)
	e1:SetOperation(c511000829.operation)
	c:RegisterEffect(e1)
end
function c511000829.rescon(pg)
	return	function(sg,e,tp,mg)
				return sg:Includes(pg) and sg:GetClassCount(Card.GetLevel)==1
			end
end
function c511000829.filter(c,e,tp,g,pg)
	local ct=c.minxyzct
	local sg=g:Clone()
	sg:RemoveCard(c)
	return ct and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) and c:IsType(TYPE_XYZ)
		and aux.SelectUnselectGroup(sg,e,tp,ct,ct,c511000829.rescon(pg),0)
end
function c511000829.matfilter(c,e)
	return c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
end
function c511000829.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c511000829.matfilter,tp,LOCATION_GRAVE,0,nil,e)
	local pg=aux.GetMustBeMaterialGroup(tp,g,tp,nil,nil,REASON_XYZ)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c511000829.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,g,pg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,c511000829.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	local ct=tc.minxyzct
	local ct2=tc.maxxyzct
	g:RemoveCard(tc)
	local g=aux.SelectUnselectGroup(g,e,tp,ct,ct2,c511000829.rescon(pg),1,tp,HINTMSG_XMATERIAL,c511000829.rescon(pg))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511000829.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,tc,e)
	local pg=aux.GetMustBeMaterialGroup(tp,g,tp,nil,nil,REASON_XYZ)
	if tc and tc:IsRelateToEffect(e) and sg:GetCount()>0 and sg:Includes(pg) then
		tc:SetMaterial(sg)
		Duel.Overlay(tc,sg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
