--Conduction Warrior Linear Magnum Plus Minus
function c170000116.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c170000116.spcon)
	e1:SetOperation(c170000116.spop)
	c:RegisterEffect(e1)
	--Increase ATK
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c170000116.atkgtg)
	e2:SetOperation(c170000116.atkgop)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetCondition(c170000116.becon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c170000116.becon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_BE_ATTACKED)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c170000116.atkval)
	e5:SetTarget(c170000116.atktg)
	c:RegisterEffect(e5)
	aux.CallToken(419)
end
function c170000116.spfilter(c,tpe)
	return c:IsType(tpe) and c:IsAbleToGraveAsCost()
end
function c170000116.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c170000116.chk,1,nil,sg)
end
function c170000116.chk(c,sg)
	return c:IsType(TYPE_PLUS) and sg:IsExists(Card.IsType,1,c,TYPE_MINUS)
end
function c170000116.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c170000116.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_PLUS)
	local g2=Duel.GetMatchingGroup(c170000116.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MINUS)
	local g=g1:Clone()
	g:Merge(g2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g1:GetCount()>0 and g2:GetCount()>0 and g:GetCount()>1 
		and aux.SelectUnselectGroup(g,e,tp,2,2,c170000116.rescon,0)
end
function c170000116.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c170000116.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_PLUS+TYPE_MINUS)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c170000116.rescon,1,tp,HINTMSG_TOGRAVE)
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoGrave(sg,REASON_COST)
	c:SetMaterial(sg)
end
function c170000116.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PLUS+TYPE_MINUS)
end
function c170000116.atkgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c170000116.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c170000116.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c170000116.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c170000116.atkgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=tc:GetAttack()/2
		if atk<0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c170000116.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PLUS+TYPE_MINUS)
end
function c170000116.becon(e)
	return e:GetHandler():IsAttackable() 
		and Duel.IsExistingMatchingCard(c170000116.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c170000116.atktg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_PLUS+TYPE_MINUS)
end
function c170000116.atkval(e,c)
	return not c:IsImmuneToEffect(e) and c==e:GetHandler()
end
