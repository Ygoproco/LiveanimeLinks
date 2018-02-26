--Mirage Ruler
function c511001132.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511001132.condition)
	c:RegisterEffect(e1)
   	--Special Summon destroyed monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27769400,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511001132.retcon)
	e2:SetCost(c511001132.retcost)
	e2:SetTarget(c511001132.rettg)
	e2:SetOperation(c511001132.retop)
	c:RegisterEffect(e2)
	if not c511001132.global_check then
		c511001132.global_check=true
		c511001132[0]=0
		c511001132[1]=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
		ge1:SetCountLimit(1)
		ge1:SetOperation(c511001132.startop)
		Duel.RegisterEffect(ge1,0)
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_DESTROYED)
		ge4:SetOperation(c511001132.checkop)
		Duel.RegisterEffect(ge4,0)
	end
end
function c511001132.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c511001132.startop(e,tp,eg,ep,ev,re,r,rp)
	c511001132[0]=Duel.GetLP(0)
	c511001132[1]=Duel.GetLP(1)
end
function c511001132.checkop(e,tp,eg,ep,ev,re,r,rp)
	eg:ForEach(function(tc)
		if rp~=tc:GetPreviousControler() then
			tc:RegisterFlagEffect(511001132+tc:GetPreviousControler(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
		end
	end)
end
function c511001132.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c511001132.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c511001132.filter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetFlagEffect(511001132+c:GetPreviousControler())>0
end
function c511001132.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c511001132.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() and c511001132[tp]>=1000 end
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,sg:GetCount(),0,0)
end
function c511001132.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511001132.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()<=0 or ft<g:GetCount() then return end
	g:ForEach(function(tc)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,tc:GetPreviousPosition(),true)
		tc:SetStatus(STATUS_FORM_CHANGED,true)
	end)
	if Duel.GetLP(tp)~=c511001132[tp] then
		Duel.SetLP(tp,c511001132[tp],REASON_EFFECT)
		Duel.BreakEffect()
		Duel.PayLPCost(tp,1000)
	end
end
