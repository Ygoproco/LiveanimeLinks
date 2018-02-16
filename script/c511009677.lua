--Sunavalon Force
function c511009677.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--no damage & spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511009677.damcon)
	e2:SetTarget(c511009677.damtg)
	e2:SetOperation(c511009677.damop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c511009677.descon)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x474))
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c511009677.thcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c511009677.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLink()>0
end
function c511009677.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c511009677.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	local sg=g:GetMaxGroup(Card.GetLevel)
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=sg:Select(tp,1,1,nil)
	end
	local tc=sg:GetFirst()
	local dam=tc:GetLink()*100
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c511009677.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511009677.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local sg=g:GetMaxGroup(Card.GetLevel)
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=sg:Select(tp,1,1,nil)
	end
	local tc=sg:GetFirst()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=tc:GetLink()*100
	Duel.Damage(p,dam,REASON_EFFECT)
end
function c511009677.descon(c)
	return c:IsFaceup() and c:IsSetCard(0x474) and c:IsType(TYPE_LINK)
end
function c511009677.descon(e)
	return not Duel.IsExistingMatchingCard(c511009677.desfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end