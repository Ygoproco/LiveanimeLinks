--Instant Tune
function c511000759.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000759.condition)
	e1:SetTarget(c511000759.target)
	e1:SetOperation(c511000759.activate)
	c:RegisterEffect(e1)
	if not c511000759.global_check then
		c511000759.global_check=true
		c511000759[0]=true
		c511000759[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c511000759.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c511000759.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511000759.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsControler,1,nil,1-tp) then
		c511000759[tc:GetControler()]=true
	end
end
function c511000759.clear(e,tp,eg,ep,ev,re,r,rp)
	c511000759[0]=false
	c511000759[1]=false
end
function c511000759.condition(e,tp,eg,ep,ev,re,r,rp)
	return c511000759[tp]
end
function c511000759.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) 
		and Duel.IsExistingMatchingCard(c511000759.matfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler(),c)
end
function c511000759.matfilter(c,mc,sc)
	local g=Group.FromCards(c,mc)
	local e1=Effect.CreateEffect(mc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
	e1:SetReset(RESET_CHAIN)
	mc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(1)
	mc:RegisterEffect(e2)
	local res=sc:IsSynchroSummonable(nil,g)
	e1:Reset()
	e2:Reset()
	return res
end
function c511000759.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c511000759.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511000759.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local g=Duel.GetMatchingGroup(c511000759.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=Duel.SelectMatchingCard(tp,c511000759.matfilter,tp,LOCATION_MZONE,0,1,1,nil,c,sc)
		sg:AddCard(c)
		Duel.SynchroSummon(tp,sc,nil,sg)
	end
end
