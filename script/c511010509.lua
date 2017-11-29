--決戦融合－ファイナル・フュージョン
function c511010509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511010509.condition)
	e1:SetTarget(c511010509.target)
	e1:SetOperation(c511010509.activate)
	c:RegisterEffect(e1)
end
function c511010509.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsFaceup() and d:IsFaceup()
end
function c511010509.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return a:IsOnField() and d:IsOnField() end
	local g=Group.FromCards(a,d)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,a:GetAttack()+d:GetAttack())
end
function c511010509.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if g:GetCount()<=1 then return end
	local dam=0
	local tc=g:GetFirst()
	while tc do
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		dam=dam+atk
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,dam,REASON_EFFECT,true)
	Duel.Damage(tp,dam,REASON_EFFECT,true)
	Duel.RDComplete()
end
