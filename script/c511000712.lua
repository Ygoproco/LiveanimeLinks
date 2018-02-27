--Greandier
function c511000712.initial_effect(c)
	--damage monster
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetDescription(aux.Stringid(10000020,1))
	e1:SetCondition(c511000712.con)
	e1:SetTarget(c511000712.tg)
	e1:SetOperation(c511000712.op)
	c:RegisterEffect(e1)
end
function c511000712.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker()
end
function c511000712.chkfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(500) and c:GetAttack()>0
end
function c511000712.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c511000712.chkfilter,tp,0,LOCATION_MZONE,Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511000712.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,Duel.GetAttackTarget())
	local sg=Duel.GetMatchingGroup(c511000712.chkfilter,tp,0,LOCATION_MZONE,Duel.GetAttackTarget())
	g:ForEach(function(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end)
	sg=sg:Filter(Card.IsAttackBelow,nil,0)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
