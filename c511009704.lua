--Miniborrel Dragon
function c511009704.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x102),2,2)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1357146,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c511009704.cost)
	e2:SetCondition(c511009704.condition)
	e2:SetTarget(c511009704.target)
	e2:SetOperation(c511009704.operation)
	c:RegisterEffect(e2)
end
function c511009704.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f) and c:IsType(TYPE_LINK)
end
function c511009704.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009704.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsLink,1,false,nil,nil,3) end
	local sg=Duel.SelectReleaseGroupCost(tp,Card.IsLink,1,1,false,nil,nil,3)
	Duel.Release(sg,REASON_COST)
end
function c511009704.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511009704.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
