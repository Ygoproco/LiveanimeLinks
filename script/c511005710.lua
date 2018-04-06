--Starlight Force
function c511005710.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511005710.condition)
	e1:SetTarget(c511005710.target)
	e1:SetOperation(c511005710.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511005710.dcondition)
	e2:SetTarget(c511005710.dtarget)
	e2:SetOperation(c511005710.doperation)
	c:RegisterEffect(e2)
end
function c511005710.afilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c511005710.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511005710.afilter,1,nil)
end
function c511005710.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c511005710.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetTargetCard(g)
end
function c511005710.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c511005710.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(4)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(511005710,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	sg:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabelObject(sg)
	e1:SetCondition(c511005710.lvcon)
	e1:SetOperation(c511005710.lvop)
	Duel.RegisterEffect(e1,tp)
end
function c511005710.lvfilter(c)
	return c:GetFlagEffect(511005710)~=0
end
function c511005710.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()~=tp then return false end
	local sg=e:GetLabelObject()
	if sg:FilterCount(c511005710.lvfilter,nil)>0 then
		return true
	else
		sg:DeleteGroup()
		e:Reset()
		return false
	end
end
function c511005710.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local sg=g:Filter(c511005710.lvfilter,nil)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c511005710.dcondition(e,tp,eg,ep,ev,re,r,rp)
	local lv1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetLevel)
	local lv2=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil):GetSum(Card.GetLevel)
	return lv1<=lv2
end
function c511005710.dtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c511005710.doperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
