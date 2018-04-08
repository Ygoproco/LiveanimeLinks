--デストーイ・チェンジ・オブ・メモリー
--Frightfur Change of Memory
--scripted by Larry126
function c511600095.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511600095.condition)
	e1:SetTarget(c511600095.target)
	e1:SetOperation(c511600095.activation)
	c:RegisterEffect(e1)
end
function c511600095.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	return g:GetFirst():IsControler(tp)
end
function c511600095.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c511600095.spfilter(c,e,tp,re)
	return (c:IsSetCard(0xad) or c:IsSetCard(0xa9) or c:IsSetCard(0xc3)) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(re)
end
function c511600095.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsCanBeEffectTarget(re) end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c511600095.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511600095.activation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c511600095.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,re):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end