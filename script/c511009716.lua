--Twin Hydradrive Knight
function c511009716.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c511009716.mfilter,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009716,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c511009716.attcon)
	e1:SetTarget(c511009716.atttg)
	e1:SetOperation(c511009716.attop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c511009716.distg)
	c:RegisterEffect(e2)
end
function c511009716.mfilter(c,lc,sumtype,tp)
	return c:IsLinkSetCard(0x577) and c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function c511009716.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c511009716.filter(c,rc)
	return c:IsLinkSetCard(0x577) and c:IsType(TYPE_LINK) 
	and c:IsReason(REASON_SUMMON) and c:GetReasonCard()==rc
end
function c511009716.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511009716.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009716.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler())	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c511009716.filter,tp,LOCATION_GRAVE,0,1,2,nil,e:GetHandler())
	e:SetLabelObject(g)
end
function c511009716.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local att=nil
	local tc=g:GetFirst()
	while tc do
		att=att+tc:GetAttribute()
		tc=g:GetNext()
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c511009716.distg(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute())
end