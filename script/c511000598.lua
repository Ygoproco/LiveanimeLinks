--Fallout
function c511000598.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511000598.condition)
	e1:SetTarget(c511000598.target)
	e1:SetOperation(c511000598.activate)
	c:RegisterEffect(e1)
	if not c511000598[0] then c511000598[0]={} end
end
function c511000598.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c511000598.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511000598.cfilter,nil,tp)
	if g:GetCount()==1 and g:GetFirst():IsFaceup() then
		e:SetLabelObject(g:GetFirst())
		return true
	end
	return false
end
function c511000598.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return true end
	Duel.SetTargetCard(tc)
	e:SetLabelObject(nil)
end
function c511000598.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(4000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetCode(EFFECT_SKIP_SP)
		e3:SetCondition(c511000598.skipcon)
		e3:SetLabel(Duel.GetTurnCount())
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,6)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_SKIP_M1)
		Duel.RegisterEffect(e4,tp)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_SKIP_DP)
		Duel.RegisterEffect(e5,tp)
		local e6=e3:Clone()
		e6:SetCode(EFFECT_SKIP_M2)
		Duel.RegisterEffect(e6,tp)
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_PHASE+PHASE_END)
		e7:SetCountLimit(1)
		e7:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,6)
		e7:SetCondition(c511000598.turncon)
		e7:SetOperation(c511000598.turnop)
		e7:SetLabel(-1)
		Duel.RegisterEffect(e7,tp)
		local descnum=tp==c:GetOwner() and 0 or 1
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetDescription(aux.Stringid(4931121,descnum))
		e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e8:SetCode(1082946)
		e8:SetLabelObject(e7)
		e8:SetOwnerPlayer(tp)
		e8:SetLabel(Duel.GetTurnCount())
		e8:SetCondition(c511000598.skipcon)
		e8:SetOperation(c511000598.reset)
		e8:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,6)
		c:RegisterEffect(e8)
		table.insert(c511000598[0],e8)
		c511000598[0][e8]={e3,e4,e5,e6}
	end
end
function c511000598.reset(e,tp,eg,ep,ev,re,r,rp)
	c511000598.turnop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function c511000598.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c511000598.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511000598.turnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()+1
	e:SetLabel(ct)
	c:SetTurnCounter(ct)
	if ct==5 then
		local e3,e4,e5,e6=table.unpack(c511000598[0][e])
		e:Reset()
		if e3 then e3:Reset() end
		if e4 then e4:Reset() end
		if e5 then e5:Reset() end
		if e6 then e6:Reset() end
		c511000598[0][e]=nil
		for i,te in ipairs(c511000598[0]) do
			if te==e then
				table.remove(c511000598[0],i)
				break
			end
		end
		if re then re:Reset() end
	end
end
