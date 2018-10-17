--次元融合殺
--Dimension Fusion Destruction
--fixed by Larry126
function c100000365.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000365.target)
	e1:SetOperation(c100000365.activate)
	c:RegisterEffect(e1)
end
function c100000365.spfilter(c,e,tp)
	return c:IsCode(43378048) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000365.filter(c)
	return c:IsCode(6007213,32491822,69890967) and c:IsAbleToRemove()
end
function c100000365.fcheck(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c100000365.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c100000365.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c100000365.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c100000365.fcheck,1,g,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c100000365.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100000365.filter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:IsExists(c100000365.fselect,1,nil,tp,g,Group.CreateGroup(),6007213,32491822,69890967) 
		and Duel.IsExistingMatchingCard(c100000365.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100000365.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c100000365.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	local mg=Duel.GetMatchingGroup(c100000365.filter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c100000365.fselect,1,1,sg,tp,mg,sg,6007213,32491822,69890967)
		if not g or #g<=0 then return false end
		sg:Merge(g)
	end
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>2 and Duel.GetLocationCountFromEx(tp)>0 then
		local sc=Duel.SelectMatchingCard(tp,c100000365.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end