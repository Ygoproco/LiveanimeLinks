--暗黒騎士ガイアロード (Anime)
--Lord Gaia the Fierce Knight (Anime)
--scripted by Larry126
function c511600047.initial_effect(c)
	aux.CallToken(419)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(511001762)
	e1:SetCondition(c511600047.condition)
	e1:SetOperation(c511600047.activate)
	c:RegisterEffect(e1)
end
function c511600047.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsFaceup() and c:IsControler(1-tp) and c:GetAttack()~=val
end
function c511600047.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511600047.cfilter,1,nil,tp)
end
function c511600047.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end