--キュア・コンバージョン
--Cure Conversion
--scripted by Larry126
function c511600148.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCost(c511600148.cost)
	e1:SetTarget(c511600148.target)
	e1:SetOperation(c511600148.activate)
	c:RegisterEffect(e1)
end
function c511600148.costfilter(c)
	return c:IsControler(tp) and c==Duel.GetAttackTarget()
end
function c511600148.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c511600148.costfilter,1,false,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,c511600148.costfilter,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c511600148.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511600148.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	Duel.BreakEffect()
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
