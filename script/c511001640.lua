--Accel Synchro
function c511001640.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001640.sctg)
	e1:SetOperation(c511001640.scop)
	c:RegisterEffect(e1)
end
function c511001640.matfilter(c,e,tp)
	if not c:IsType(TYPE_SYNCHRO) then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(c:GetLevel()/2)
	e2:SetReset(RESET_CHAIN)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_MUST_BE_MATERIAL)
	e3:SetValue(REASON_SYNCHRO)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	if c:IsControler(tp) then
		e3:SetTargetRange(1,0)
	else
		e3:SetTargetRange(0,1)
	end
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
	table.insert(c511001640.Reset,e1)
	table.insert(c511001640.Reset,e2)
	table.insert(c511001640.Reset,e3)
	return true
end
c511001640.Reset={}
function c511001640.filter(c,e,tp)
	if not c:IsType(TYPE_SYNCHRO) then return false end
	c511001640.Reset={}
	local g=Duel.GetMatchingGroup(c511001640.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local res=c:IsSynchroSummonable(nil,g)
	for i,eff in ipairs(c511001640.Reset) do
		eff:Reset()
	end
	c511001640.Reset={}
	return res
end
function c511001640.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001640.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511001640.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511001640.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local sg=Duel.GetMatchingGroup(c511001640.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
		Duel.SynchroSummon(tp,tc,nil,sg)
	end
end
