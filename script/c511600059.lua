--リンク・サージ・カウンター (Anime)
--Link Surge Counter (Anime)
--scripted by Larry126
function c511600059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511600059.condition)
	e1:SetCost(c511600059.cost)
	e1:SetOperation(c511600059.activate)
	c:RegisterEffect(e1)
end
function c511600059.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if not tc or c:IsFacedown() or tc:IsFacedown() then return false end
	if c:IsControler(1-tp) then c,tc=tc,c end
	e:SetLabelObject(c)
	return c:IsType(TYPE_LINK) and tc:IsType(TYPE_LINK) and tc:GetLink()>c:GetLink()
end
function c511600059.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c511600059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600059.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c511600059.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511600059.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetBattleTarget():GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
	end
end