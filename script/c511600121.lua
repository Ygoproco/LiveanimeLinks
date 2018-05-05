--EMカレイドスコーピオン (Anime)
--Performapal Kaleidoscorp (Anime)
--scripted by Larry126
function c511600121.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78835747,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c511600121.condition)
	e1:SetTarget(c511600121.target)
	e1:SetOperation(c511600121.operation)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c511600121.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
end
function c511600121.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c511600121.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
		and Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_PENDULUM)
end
function c511600121.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c511600121.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511600121.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511600121.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511600121.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511600121.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end