--Mirror Imagine Prism Coat 8
function c511009645.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c511009645.atkcost)
	e2:SetTarget(c511009645.atktg)
	e2:SetOperation(c511009645.atkop)
	c:RegisterEffect(e2)
end

function c511009645.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c511009645.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler())
	and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(34016756,0))
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(34016756,1))
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,g1:GetFirst())
end
function c511009645.atkop(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local op=Duel.SelectOption(tp,aux.Stringid(511009645,0),aux.Stringid(511009645,1),aux.Stringid(511009645,2))
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(511009645,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c511009645.efilterS)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		hc:RegisterEffect(e1)
	elseif op==1 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(511009645,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c511009645.efilterT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		hc:RegisterEffect(e2)
	elseif op==2 then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(511009645,2))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c511009645.efilterM)
		hc:RegisterEffect(e3)
	end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(tc:GetAttack()/2)
		e4:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		hc:RegisterEffect(e4)
end
function c511009645.efilterS(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c511009645.efilterT(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c511009645.efilterM(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetOwner():IsSetCard(0x572)
end
