--Sunvine Healer
function c511009671.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),1,1)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c511009671.descon)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3954901,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c511009671.lptg)
	e2:SetOperation(c511009671.lpop)
	c:RegisterEffect(e2)
end
function c511009671.desfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK)  and c:GetLinkedGroup():IsContains(e:GetHandler())
end
function c511009671.descon(e)
	return not Duel.IsExistingMatchingCard(c511009671.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
end
function c511009671.filter(c,card)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(card)
end
function c511009671.lptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511009671.filter(chkc,e:GetHandler()) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511009671.filter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
end
function c511009671.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetLink()*300,REASON_EFFECT)
	end
end
