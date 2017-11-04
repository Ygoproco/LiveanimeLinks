--チェンジ！ ジェット・アイアン号
function c100000220.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c100000220.cost)
	e1:SetTarget(c100000220.target)
	e1:SetOperation(c100000220.operation)
	c:RegisterEffect(e1)
end
function c100000220.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c100000220.chk,1,nil,sg,Group.CreateGroup(),80208158,16796157,43791861,79185500)
end
function c100000220.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c100000220.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c100000220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rg=Duel.GetReleaseGroup(tp)
	local g1=rg:Filter(Card.IsCode,nil,80208158)
	local g2=rg:Filter(Card.IsCode,nil,16796157)
	local g3=rg:Filter(Card.IsCode,nil,43791861)
	local g4=rg:Filter(Card.IsCode,nil,79185500)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	g:Merge(g4)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4 and g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,4,4,c100000220.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,4,4,c100000220.rescon,1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
end
function c100000220.filter(c,e,tp)
	return c:IsCode(15574615) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c100000220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100000220.filter,tp,0x13,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c100000220.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100000220.filter),tp,0x13,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
end
