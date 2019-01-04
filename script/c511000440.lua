--ガーディアン・フォーメーション
--Guardian Formation
--re-scripted by Larry126
function c511000440.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetTarget(c511000440.target)
	e1:SetOperation(c511000440.activate)
	c:RegisterEffect(e1)
end
function c511000440.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c511000440.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c511000440.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c511000440.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return d:IsFaceup() and d:IsSetCard(0x52) and Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingMatchingCard(c511000440.filter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(d)
end
function c511000440.activate(e,tp,eg,ep,ev,re,r,rp)
	local td=Duel.GetAttackTarget()
	if td and td:IsFaceup() and td:IsRelateToEffect(e) and td:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.MoveSequence(td,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2))
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,c511000440.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=Duel.SelectMatchingCard(tp,c511000440.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp):GetFirst()
			ec:CancelToGrave()
			Duel.Equip(tp,ec,tc)
		end
	end
end
