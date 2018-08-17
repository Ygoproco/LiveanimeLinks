--決闘竜の飛翔
--Flight of the Duel Dragons
--re-scripted by Larry126
function c511009144.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511009144.cost)
	e1:SetTarget(c511009144.target)
	e1:SetOperation(c511009144.activate)
	c:RegisterEffect(e1)
end
function c511009144.cfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2))  and c:IsAbleToGraveAsCost()
end
function c511009144.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009144.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511009144.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c511009144.filter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c511009144.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009144.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
end
function c511009144.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511009144.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if #g>0 then
		Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end