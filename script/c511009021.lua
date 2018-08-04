--EMオッドアイズ・バトラー (Manga)
--Performapal Odd-Eyes Butler (Manga)
--scripted by Larry126
function c511009021.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511009021.condition)
	e1:SetCost(c511009021.target)
	e1:SetOperation(c511009021.operation)
	c:RegisterEffect(e1)
end
function c511009021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c511009021.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x99) and not c:IsForbidden()
end
function c511009021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009021.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c511009021.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,c511009021.filter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT) and tc:IsFaceup()
		and tc:GetAttack()>0 and Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)>0 then
		Duel.NegateAttack()
	end
end