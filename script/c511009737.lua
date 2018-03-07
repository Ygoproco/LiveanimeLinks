--Drop Draco
function c511009737.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,511009737)
	e1:SetCondition(c511009737.spcon)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009738,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,511009738)
	e1:SetCondition(c99315585.damcon)
	e2:SetOperation(c511009737.damop)
	c:RegisterEffect(e2)
end
function c511009737.spfilter(c)
	return c:IsFaceup() and c:IsLinkAbove(3) 
end
function c511009737.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511009737.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009737.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c511009737.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511009737.filter,1,nil,tp)
end
function c511009737.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c511009737.filter,nil,tp)
	Duel.Damage(tp,ct*500,REASON_EFFECT,true)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT,true)
	Duel.RDComplete()
end
