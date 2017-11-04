--眠れる巨人ズシン 
function c100000110.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c100000110.spcon)
	e4:SetOperation(c100000110.spop)
	c:RegisterEffect(e4)
	--atk/def up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_CALCULATING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c100000110.atkup)
	c:RegisterEffect(e5)
	--unaffectable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(c100000110.efilter)
	c:RegisterEffect(e7)
	if not c100000110.global_check then
		c100000110.global_check=true
		--spsummon proc
		local e2=Effect.CreateEffect(c)	
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetOperation(c100000110.endop)
		Duel.RegisterEffect(e2,0)
	end
end
function c100000110.spfilter1(c)
	return c:IsFaceup() and c:IsLevel(1) and c:IsType(TYPE_NORMAL)
end
function c100000110.endop(e,tp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100000110.spfilter1,Duel.GetTurnPlayer(),LOCATION_MZONE,0,nil)
	local rc=g:GetFirst()
	while rc do
		if rc:GetFlagEffect(100000110)==0 then 
			local e1=Effect.CreateEffect(rc)	
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCondition(c100000110.ctcon)
			e1:SetLabel(0)
			e1:SetOperation(c100000110.ctop)
			rc:RegisterEffect(e1)			
			rc:RegisterFlagEffect(100000110,RESET_EVENT+0x1fe0000,0,1) 	
		end
		rc=g:GetNext()
	end
end
function c100000110.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000110.ctop(e,tp,c)
	local c=e:GetHandler()
	if not c:IsControler(Duel.GetTurnPlayer()) then return end
	local ct=e:GetLabel()
	if c:GetFlagEffect(100000110)~=0 and ct==8 then 
		c:RegisterFlagEffect(100000111,RESET_EVENT+0x1fe0000,0,1) 	
	else	
		e:SetLabel(ct+1)
	end
end
function c100000110.filter(c,ft,tp)
	return  c:IsFaceup() and c:IsLevel(1) and c:IsType(TYPE_NORMAL) and c:GetFlagEffect(100000111)~=0 and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c100000110.spcon(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c100000110.filter,1,nil,ft,tp)
end
function c100000110.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c100000110.filter,1,1,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp)
	Duel.Release(g,REASON_COST)
end
function c100000110.atkup(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or (a~=c and d~=c) then return end
	local tc=c:GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc:GetAttack()+1000)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e4)
end
function c100000110.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
