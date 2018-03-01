--Mirror Imagine Catadioptricker 7
function c511009644.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32485518,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c511009644.cost)
	e2:SetTarget(c511009644.target)
	e2:SetOperation(c511009644.operation)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79185500,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c511009644.target)
	e3:SetOperation(c511009644.operation)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20366274,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c511009644.atkcon)
	e4:SetOperation(c511009644.atkop)
	c:RegisterEffect(e4)
	
end

function c511009644.spcfilter1(c,tp)
	return c:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c511009644.spcfilter2,tp,LOCATION_GRAVE,0,2,c,c:GetCode()) and c:IsAbleToHand()
end
function c511009644.spcfilter2(c,code)
	return c:IsType(TYPE_SPELL) and c:IsCode(code) and c:IsAbleToHand()
end
function c511009644.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511009644.spcfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c511009644.spcfilter1,tp,LOCATION_GRAVE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c511009644.spcfilter1,tp,LOCATION_GRAVE,0,1,1,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c511009644.spcfilter2,tp,LOCATION_GRAVE,0,2,2,g:GetFirst(),g:GetFirst():GetCode())
	g:Merge(g2)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c511009644.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

function c511009644.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511009644.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end


function c511009644.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and c:GetCardTarget():IsContains(bc)
end

function c511009644.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(bc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end