--EMビッグバイトタートル (Anime)
--Performapal Bit Bite Turtle (Anime)
--scripted by Larry126
function c511600123.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89113320,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c511600123.lvcost)
	e1:SetTarget(c511600123.lvtg)
	e1:SetOperation(c511600123.lvop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(89113320,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetTarget(c511600123.target)
	e3:SetOperation(c511600123.operation)
	c:RegisterEffect(e3)
end
function c511600123.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c511600123.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c511600123.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c511600123.cfilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c511600123.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
end
function c511600123.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c511600123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local bc=e:GetHandler():GetBattleTarget()
	if chkc then return chkc==bc end
	if chk==0 then return true end
	if bc and bc:IsRelateToBattle() and bc:IsOnField() and bc:IsCanBeEffectTarget(e) then
		Duel.SetTargetCard(bc)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
	end
end
function c511600123.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetFirstTarget()
	if bc and bc:IsRelateToBattle() and bc:IsRelateToEffect(e) then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end