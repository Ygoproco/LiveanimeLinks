--Trickstar Mandrake
function c511009628.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22219822,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,22219822)
	e1:SetCondition(c511009628.spcon)
	e1:SetTarget(c511009628.sptg)
	e1:SetOperation(c511009628.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22219822,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,22219823)
	e2:SetCondition(c511009628.descon)
	e2:SetTarget(c511009628.destg)
	e2:SetOperation(c511009628.desop)
	c:RegisterEffect(e2)
end
function c511009628.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c511009628.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c511009628.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c511009628.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0xfb)
end
function c511009628.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511009628.desfilter(c,g)
	return g:IsContains(c)
end
function c511009628.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(c511009628.lkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		tg:Merge(tc:GetLinkedGroup())
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511009628.desfilter(chkc,tg) end
	if chk==0 then return Duel.IsExistingTarget(c511009628.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009628.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511009628.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
