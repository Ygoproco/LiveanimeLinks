--Trickstars Bella Madonna
function c511009651.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfb),2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511009651.imcon)
	e1:SetValue(c511009651.efilter)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004038,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,511009651)
	e2:SetCondition(c511009651.damcon)
	e2:SetTarget(c511009651.damtg)
	e2:SetOperation(c511009651.damop)
	c:RegisterEffect(e2)
end

function c511009651.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetLinkedGroupCount()==0
end
function c511009651.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c511009651.damcon(e)
	return e:GetHandler():GetLinkedGroupCount()==0
end
function c511009651.damfilter(c)
	return c:IsSetCard(0xfb) and c:IsType(TYPE_MONSTER)
end
function c511009651.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009651.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroupCount(c511009651.damfilter,tp,LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c511009651.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroupCount(c511009651.damfilter,tp,LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.Damage(p,dam,REASON_EFFECT)
end
