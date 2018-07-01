--Toon Mask
function c511000915.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c511000915.cost)
	e1:SetCondition(c511000915.condition)
	e1:SetTarget(c511000915.target)
	e1:SetOperation(c511000915.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
-- [Toon]=original 
c511000915.list={
[53183600]=89631139,
[38369349]=2964201,
[31733941]=74677422,
[7171149]=83104731,
[28112535]=81480460,
[61190918]=78193831,
[79875176]=11384280,
[83629030]=70095154,
[21296502]=46986414,
[90960358]=38033121,
[42386471]=69140098,
[15270885]=78658564,
[16392422]=10189126,
[65458948]=65570596,
[91842653]=70781052
}
function c511000915.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsType,1,false,nil,nil,TYPE_TOON) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsType,1,1,false,nil,nil,TYPE_TOON)
	Duel.Release(g,REASON_COST)
end
function c511000915.toonfilter(c,code,e,tp)
	return (c.toonVersion==code or c511000915.list[c:GetCode()]==code ) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c511000915.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0	
end
function c511000915.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:GetCount()==1 
		and Duel.IsExistingTarget(c511000915.toonfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tc:GetCode(),e,tp) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511000915.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000915.toonfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tc:GetCode(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
