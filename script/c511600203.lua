--転生炎獣フォクサー
--Salamangreat Foxer
--scripted by Larry126
function c511600203.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(122520,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c511600203.condition)
	e1:SetCost(c511600203.cost)
	e1:SetTarget(c511600203.target)
	e1:SetOperation(c511600203.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(122520,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c511600203.spcon)
	e2:SetTarget(c511600203.sptg)
	e2:SetOperation(c511600203.spop)
	c:RegisterEffect(e2)
end
function c511600203.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK) and c:IsSetCard(0x119)
end
function c511600203.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511600203.cfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c511600203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c511600203.filter(c)
	return c:GetSequence()<5
end
function c511600203.tdfilter(c)
	return c511600203.cfilter(c) and c:IsAbleToExtra()
end
function c511600203.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and c511600203.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511600203.filter,tp,0,LOCATION_SZONE,1,nil)
		and Duel.IsExistingMatchingCard(c511600203.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,c511600203.filter,tp,0,LOCATION_SZONE,1,1,nil)
	local lg=Duel.GetMatchingGroup(c511600203.tdfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,lg,1,tp,LOCATION_GRAVE) 
end
function c511600203.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local lg=Duel.SelectMatchingCard(tp,c511600203.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=Duel.GetFirstTarget()
	if #lg>0 and Duel.SendtoDeck(lg,nil,2,REASON_EFFECT)>0 and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c511600203.spfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_SZONE)
		and c:GetPreviousControler()~=tp and c:GetPreviousSequence()<5
end
function c511600203.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511600203.spfilter,1,nil,tp)
end
function c511600203.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c511600203.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end