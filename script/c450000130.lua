--遺言の札
function c450000130.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(511000883)
	e1:SetCondition(c450000130.condition)
	e1:SetTarget(c450000130.target)
	e1:SetOperation(c450000130.operation)
	c:RegisterEffect(e1)
	aux.CallToken(419)
end
c450000130.illegal=true
function c450000130.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsControler(tp) and val>0 and c:GetAttack()<=0
end
function c450000130.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511000883.cfilter,1,nil,tp)
end
function c450000130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return ct<5 and Duel.IsPlayerCanDraw(tp,5-ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5-ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-ct)
end
function c450000130.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct<5 then
		Duel.Draw(p,5-ct,REASON_EFFECT)
	end
end
