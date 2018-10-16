--ライデント・ハイドライブ・ロード
--Trident Hydradrive Lord
--fixed by Larry126
function c511009717.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c511009717.mfilter,3)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009717,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c511009717.attcon)
	e1:SetTarget(c511009717.atttg)
	e1:SetOperation(c511009717.attop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c511009717.distg)
	c:RegisterEffect(e2)	
	--att
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511009717,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c511009717.target)
	e3:SetOperation(c511009717.operation)
	c:RegisterEffect(e3)
end
function c511009717.mfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function c511009717.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c511009717.cfilter(c,e,tp)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_GRAVE)
		and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
end
function c511009717.mgfilter(sg,e,tp,mg)
	return sg:IsExists(aux.NOT(Card.IsAttribute),1,nil,e:GetHandler():GetAttribute())
end
function c511009717.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetMaterial():Filter(c511009717.cfilter,nil,e,tp)
	if chkc then return mg:IsContains(chkc) end
	if chk==0 then return aux.SelectUnselectGroup(mg,e,tp,1,3,c511009717.mgfilter,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=aux.SelectUnselectGroup(mg,e,tp,1,3,c511009717.mgfilter,1,tp,HINTMSG_TARGET,c511009717.mgfilter)
	Duel.SetTargetCard(g)
end
function c511009717.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local att=0
	for tc in aux.Next(g) do
		att=att|tc:GetAttribute()
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) and att>0 and att~=c:GetAttribute() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c511009717.distg(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute())
end
function c511009717.filter(c,p)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c511009717.attfilter,p,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c511009717.attfilter(c,att)
	return c:IsFaceup() and not c:IsAttribute(att)
end
function c511009717.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c511009717.filter(chkc,1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c511009717.filter,tp,0,LOCATION_MZONE,1,nil,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511009717.filter,tp,0,LOCATION_MZONE,1,1,nil,1-tp)
end
function c511009717.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c511009717.attfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		for gc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(tc:GetAttribute())
			gc:RegisterEffect(e1)
		end
	end
end
