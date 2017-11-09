--バックリンカー
--Backlinker (Anime)
--Scripted by Larry126
function c511600033.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c511600033.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511600033,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c511600033.tdcost)
	e2:SetTarget(c511600033.tdtg)
	e2:SetOperation(c511600033.tdop)
	c:RegisterEffect(e2)
end
function c511600033.filter(c)
	return c:GetSequence()>=5
end
function c511600033.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511600033.filter,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c511600033.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c511600033.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c511600033.tdfilter(c)
	return c:GetSequence()>=5 and c:IsAbleToGrave()
end
function c511600033.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600033.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c511600033.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c511600033.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511600033.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
