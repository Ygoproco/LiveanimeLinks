--転生炎獣 Ｊジャガー
--Salamangreat Jack Jaguar
--scripted by Larry126
function c511600124.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(168917,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,511600124)
	e2:SetTarget(c511600124.sptg)
	e2:SetOperation(c511600124.spop)
	c:RegisterEffect(e2)
end
function c511600124.spfilter(c,e,tp,sc)
	return c:IsSetCard(0x119) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsType(TYPE_LINK)
		and sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,c:GetFreeLinkedZone()&0x1f)
end
function c511600124.rfilter(c)
	return c:IsSetCard(0x119) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c511600124.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c511600124.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
		and Duel.IsExistingTarget(c511600124.rfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511600124.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c511600124.rfilter,tp,LOCATION_GRAVE,0,1,1,c)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c511600124.spop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()~=rc and g:GetFirst() or g:GetNext()
	if rc and rc:IsRelateToEffect(e) and Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)~=0
		and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local zone=tc:GetFreeLinkedZone()&0x1f
		if c:IsRelateToEffect(e) and zone~=0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
