--遅れた召喚劇
--Delayed Summon
--Scripted by Snrk
--fixed by Larry126
function c511008021.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511008021.condition)
	e1:SetTarget(c511008021.target)
	e1:SetOperation(c511008021.activate)
	c:RegisterEffect(e1)
	if not c511008021.global_check then
		c511008021.global_check=true
		c511008021[0]=0
		c511008021[1]=0
		sv=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c511008021.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_FLIP_SUMMON)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge4:SetOperation(c511008021.clear)
		Duel.RegisterEffect(ge4,0)
	end
end
function c511008021.checkop(e,tp,eg,ep,ev,re,r,rp)
	c511008021[ep]=1
end
function c511008021.clear(e,tp,eg,ep,ev,re,r,rp)
	self=e:GetHandler():GetOwner()
	if c511008021[self]==1 then sv=1 else sv=0 end
	c511008021[0]=0 c511008021[1]=0
end
function c511008021.hfilter(c,e)
	local mi,ma=c:GetTributeRequirement()
	return c:IsSummonable(true,nil,1+mi) or c:IsMSetable(true,nil,1+mi)
end
function c511008021.condition(e,tp,eg,ep,ev,re,r,rp)
	return sv==0 and Duel.GetAttacker():IsControler(1-tp)
end
function c511008021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(Card.IsSummonableCard,tp,LOCATION_HAND,0,nil)
	local effs={}
	for hc in aux.Next(hg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e1:SetCondition(c511008021.con)
		e1:SetOperation(c511008021.op)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		hc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_LIMIT_SET_PROC)
		hc:RegisterEffect(e2,true)
		table.insert(effs,e1)
		table.insert(effs,e2)
	end
	local chkc=Duel.IsExistingMatchingCard(c511008021.hfilter,tp,LOCATION_HAND,0,1,nil)
	for _,eff in ipairs(effs) do
		eff:Reset()
	end
	if chk==0 then return chkc end
	local g=Duel.GetMatchingGroup(c511008021.hfilter,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,g,1,tp,LOCATION_HAND)
end
function c511008021.activate(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(Card.IsSummonableCard,tp,LOCATION_HAND,0,nil)
	local effs={}
	for hc in aux.Next(hg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e1:SetCondition(c511008021.con)
		e1:SetOperation(c511008021.op)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		hc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_LIMIT_SET_PROC)
		hc:RegisterEffect(e2,true)
		table.insert(effs,e1)
		table.insert(effs,e2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c511008021.hfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local mi,ma=tc:GetTributeRequirement()
		local s1=tc:IsSummonable(true,e,1+mi)
		local s2=tc:IsMSetable(true,e,1+mi)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1+mi)
		else
			Duel.MSet(tp,tc,true,nil,1+mi)
		end
	end
	for _,eff in ipairs(effs) do
		eff:Reset()
	end
end
function c511008021.con(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	return minc<=mi+1 and Duel.CheckTribute(c,mi+1)
end
function c511008021.op(e,tp,eg,ep,ev,re,r,rp,c)
	local mi,ma=c:GetTributeRequirement()
	local g=Duel.SelectTribute(tp,c,mi+1,mi+1)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end