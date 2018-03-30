--リンク・サージ・カウンター (Anime)
--Link Surge Counter (Anime)
--scripted by Larry126
--cleaned up by MLD
function c511600059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511600059.condition)
	e1:SetCost(c511600059.cost)
	e1:SetTarget(c511600059.target)
	e1:SetOperation(c511600059.activate)
	c:RegisterEffect(e1)
end
function c511600059.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or a:IsFacedown() or d:IsFacedown() then return false end
	if a:IsControler(1-tp) then a,d=d,a end
	e:SetLabelObject(a)
	return a:IsType(TYPE_LINK) and d:IsType(TYPE_LINK) and d:GetLink()>a:GetLink()
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
function c511600059.target(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return true end
	Duel.SetTargetCard(e:GetLabelObject())
	e:SetLabelObject(nil)
end
function c511600059.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local bc=tc:GetBattleTarget()
	if tc:IsFaceup() and tc:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(bc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
	end
end
