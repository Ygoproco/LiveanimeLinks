--Demolition Drone
function c511009748.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511009748.cost)
	e1:SetOperation(c511009748.activate)
	c:RegisterEffect(e1)
	aux.CallToken(420)
end
c511009748[0]=0
c511009748[1]=0
function c511009748.cfilter(c)
	return c:IsDrone()
end
function c511009748.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c511009748.cfilter,1,false,aux.ReleaseCheckMMZ,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupCost(tp,c511009748.cfilter,1,1,false,aux.ReleaseCheckMMZ,nil)
	Duel.Release(g,REASON_COST)
end
function c511009748.activate(e,tp,eg,ep,ev,re,r,rp)
	c511009748[tp]=1
	if Duel.GetFlagEffect(tp,511009748)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c511009748.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,511009748,RESET_PHASE+PHASE_END,0,1)
end
function c511009748.val(e,re,dam,r,rp,rc)
	if c511009748[e:GetOwnerPlayer()]==1 or bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
