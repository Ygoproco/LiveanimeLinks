--Ground Erosion
function c511000090.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000090.target)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000090,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c511000090.atkcost)
	e2:SetTarget(c511000090.atktg)
	e2:SetOperation(c511000090.atkop)
	c:RegisterEffect(e2)
	--turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511000090.turncon)
	e3:SetOperation(c511000090.turnop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(1082946)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c511000090.turnop)
	c:RegisterEffect(e4)
end
function c511000090.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511000090.turnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(51100090)>0 then
		local ct=c:GetTurnCounter()+1
		c:SetTurnCounter(ct)
	end
end
function c511000090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local zones=0xff
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	g:ForEach(function(tc)
		local seq=tc:GetSequence()
		zones=zones&~(1<<seq)
	end)
	zones=zones<<16
	local zone=Duel.SelectFieldZone(tp,1,0,LOCATION_MZONE,zones)>>16
	local seq=0
	if zone==0x1 then seq=0
	elseif zone==0x2 then seq=1
	elseif zone==0x4 then seq=2
	elseif zone==0x8 then seq=3
	elseif zone==0x10 then seq=4
	elseif zone==0x20 then seq=5+6*0x100
	elseif zone==0x40 then seq=6+5*0x100
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_SZONE) then
		e:GetHandler():RegisterFlagEffect(51100090,RESET_EVENT+0x1fe0000,0,0,seq)
		e:GetHandler():SetTurnCounter(0)
	end
end
function c511000090.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	if chk==0 then return c:GetFlagEffect(51100090)>0 and ct>0 and c:IsAbleToGraveAsCost() end
	local seq=c:GetFlagEffectLabel(51100090)
	Duel.SendtoGrave(c,REASON_COST)
	e:SetLabel(ct+seq*0x100)
end
function c511000090.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local seq=e:GetHandler():GetFlagEffectLabel(51100090)
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq&0xff)
		if not tc then
			local seq2=seq>>8
			if seq2>0 then
				tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq2)
			end
		end
		return tc and tc:IsFaceup()
	end
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
end
function c511000090.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct=label&0xff
	local seq=label>>8
	local seq1=seq&0xff
	local seq2=seq>>8
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq1)
	if not tc and seq2>0 then
		tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq2)
	end
	if tc and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(ct*-500)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end
