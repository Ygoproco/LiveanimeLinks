--転生炎獣サンライトウルフ
--Salamangreat Sunlight Wolf
--scripted by Larry126
function c511600198.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511600198.matfilter,2,2)
	--recycle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3987233,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511600198.thcon)
	e1:SetTarget(c511600198.thtg)
	e1:SetOperation(c511600198.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c511600198.valcheck)
	c:RegisterEffect(e3)
end
function c511600198.matfilter(c,lc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE,lc,sumtype,tp) and c:IsType(TYPE_EFFECT,lc,sumtype,tp)
end
function c511600198.cfilter(c,tp,zone)
	local seq=c:GetSequence()
	if c:IsControler(1-tp) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c511600198.filter(c)
	return c:IsSetCard(0x119) and c:IsAbleToHand()
end
function c511600198.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511600198.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c511600198.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c511600198.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c511600198.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c511600198.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,LOCATION_GRAVE)
end
function c511600198.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c511600198.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,511600198) and c:IsSummonType(SUMMON_TYPE_LINK) then
		c:RegisterFlagEffect(41463181,RESET_EVENT+0x6e0000,0,1)
	end
end
