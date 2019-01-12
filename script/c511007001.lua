--coded by Lyris
--DDイービル
function c511007001.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--When your opponent Pendulum Summons monsters: You can negate the effects of those monsters, also they cannot attack.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetCondition(c511007001.atkcon)
	e1:SetOperation(c511007001.atkop)
	c:RegisterEffect(e1)
end
function c511007001.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c511007001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511007001.cfilter,1,nil,1-tp)
end
function c511007001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c511007001.cfilter,nil,1-tp)
	local tc=g:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_DISABLE)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e0)
		local e1=e0:Clone()
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		tc:RegisterEffect(e1)
		local e2=e0:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
