--ショートヴァレル・ドラゴン
--Miniborrel Dragon
--fixed by Larry126
--cleaned up by MLD
function c511009704.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x102),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1357146,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c511009704.condition)
	e1:SetCost(c511009704.cost)
	e1:SetTarget(c511009704.target)
	e1:SetOperation(c511009704.operation)
	c:RegisterEffect(e1)
end
function c511009704.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f) and c:IsType(TYPE_LINK)
end
function c511009704.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009704.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009704.cfilter(c)
	return c:IsLink(3)
end
function c511009704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c511009704.cfilter,1,false,aux.ReleaseCheckMMZ,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local cg=Duel.SelectReleaseGroupCost(tp,c511009704.cfilter,1,1,false,aux.ReleaseCheckMMZ,nil)
	Duel.Release(cg,REASON_COST)
end
function c511009704.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511009704.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
