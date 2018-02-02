--Crush Card Virus (Anime)
function c513000009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c513000009.target)
	e1:SetOperation(c513000009.activate)
	c:RegisterEffect(e1)
end
function c513000009.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetAttack()<=1000 and c:IsFaceup()
end
function c513000009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return c:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c513000009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c513000009.filter,tp,LOCATION_MZONE,0,1,nil) end
	local tg=Duel.SelectTarget(tp,c513000009.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c513000009.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local c=e:GetHandler()
		--Activate
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabelObject(tc)
		e1:SetCondition(c513000009.descon)
		e1:SetTarget(c513000009.destg)
		e1:SetOperation(c513000009.desop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DESTROY)
		e2:SetLabelObject(e1)
		e2:SetOperation(c513000009.checkop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c513000009.checkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:SetLabel(1)
end
function c513000009.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	return c:GetPreviousAttributeOnField()&ATTRIBUTE_DARK==ATTRIBUTE_DARK and e:GetLabel()==1
		and c:GetPreviousAttackOnField()<=1000 and c:GetPreviousControler()==tp
end
function c513000009.tgfilter(c)
	return c:IsFaceup() and c:GetAttack()>=1500 and c:IsDestructable()
end
function c513000009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c513000009.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c513000009.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackAbove(1500)
end
function c513000009.desop(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)
	if conf:GetCount()>0 then
		Duel.ConfirmCards(tp,conf)
		local dg=conf:Filter(c513000009.desfilter,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	e:SetLabel(0)
	e:Reset()
end