--Divine Hierarchy Token
--scripted by Larry126
function c421.initial_effect(c)
	if not c421.global_check then
		c421.global_check=true
	--rank
		local rank=Effect.CreateEffect(c)
		rank:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		rank:SetCode(EVENT_ADJUST)
		rank:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
		rank:SetCondition(c421.hrcon)
		rank:SetOperation(c421.rank)
		Duel.RegisterEffect(rank,0) 
	--immunes
		local immunity=Effect.CreateEffect(c)
		immunity:SetType(EFFECT_TYPE_FIELD)
		immunity:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		immunity:SetCode(EFFECT_IMMUNE_EFFECT)
		immunity:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		immunity:SetTarget(c421.hrtg)
		immunity:SetValue(c421.hrfilter)
		Duel.RegisterEffect(immunity,0)
		local control=Effect.CreateEffect(c)
		control:SetType(EFFECT_TYPE_FIELD)
		control:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		control:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		control:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
		control:SetTarget(c421.control)
		Duel.RegisterEffect(control,0)
		local last=Effect.CreateEffect(c)
		last:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		last:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		last:SetCode(EVENT_ADJUST)
		last:SetTarget(c421.lastcon)
		last:SetOperation(c421.lastop)
		Duel.RegisterEffect(last,0)
	end
end
function c421.rank1(c)
	local code1,code2=c:GetOriginalCodeRule() 
	return c:GetFlagEffect(513000065)==0
		and (code1==10000000 or code1==10000010 or code1==10000020
		or code1==62180201 or code1==57793869 or code1==21208154
		or code2==10000000 or code2==10000010 or code2==10000020
		or code2==62180201 or code2==57793869 or code2==21208154)
end
function c421.rank2(c)
	local code1,code2=c:GetOriginalCodeRule() 
	return code1==10000010 or code1==21208154 or code2==10000010 or code2==21208154
end
function c421.hrcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.IsExistingMatchingCard(c421.rank1,tp,0xff,0xff,1,nil)
end
function c421.rank(e,tp,eg,ev,ep,re,r,rp)
	local g=Duel.GetMatchingGroup(c421.rank1,tp,0xff,0xff,nil)
	for c in aux.Next(g) do
		c:RegisterFlagEffect(513000065,0,0,0,1)
	end
	for c in aux.Next(g:Filter(c421.rank2,nil)) do
		c:ResetFlagEffect(513000065)
		c:RegisterFlagEffect(513000065,0,0,0,2)
	end
end
function c421.hrtg(e,c)
	return c:GetFlagEffect(513000065)>0 and c:IsFaceup()
end
function c421.hrfilter(e,te,c)
	if not te then return false end
	local tc=te:GetOwner()
	return (te:IsActiveType(TYPE_MONSTER) and c~=tc
		and (not tc:GetFlagEffectLabel(513000065) or c:GetFlagEffectLabel(513000065)>tc:GetFlagEffectLabel(513000065)))
		or (te:IsHasCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_TOGRAVE+CATEGORY_FUSION_SUMMON)
		and te:IsActiveType(TYPE_SPELL+TYPE_TRAP))
end
function c421.control(e,c)
	return c:GetFlagEffect(513000065)>0 and c:IsFaceup() and not c:IsHasEffect(513000134)
end
function c421.lfilter(c)
	return c:GetFlagEffect(513000065)>0 and c:IsFaceup()
end
function c421.lastfilter(c)
	local effs={c:GetCardEffect(EFFECT_UNRELEASABLE_SUM)}
	for _,eff in ipairs(effs) do
		if eff:GetLabel()==513000065 then
		return false end
	end
	return true
end
function c421.lastcon(e,tp,eg,ev,ep,re,r,rp)
	local g=Duel.GetMatchingGroup(c421.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:IsExists(c421.lastfilter,1,nil)
end
function c421.lastop(e,tp,eg,ev,ep,re,r,rp)
	local g=Duel.GetMatchingGroup(c421.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:Filter(c421.lastfilter,nil)
	tg:ForEach(function(c)
	--last 1 turn
		local ep=Effect.CreateEffect(c)
		ep:SetDescription(aux.Stringid(4011,0))
		ep:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ep:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ep:SetCountLimit(1)
		ep:SetRange(LOCATION_MZONE)
		ep:SetCode(EVENT_PHASE+PHASE_END)
		ep:SetReset(RESET_EVENT+0x1fe0000)
		ep:SetCondition(c421.stgcon)
		ep:SetOperation(c421.stgop)
		c:RegisterEffect(ep)
	 --release limit
		local r1=Effect.CreateEffect(c)
		r1:SetType(EFFECT_TYPE_SINGLE)
		r1:SetCode(EFFECT_UNRELEASABLE_SUM)
		r1:SetLabel(513000065)
		r1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		r1:SetRange(LOCATION_MZONE)
		r1:SetReset(RESET_EVENT+0x1fe0000)
		r1:SetValue(c421.recon)
		c:RegisterEffect(r1)
		local r2=r1:Clone()
		r2:SetCondition(c421.recon2)
		r2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(r2)
	--battle
		local dg=r1:Clone()
		dg:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		dg:SetValue(c421.tglimit)
		c:RegisterEffect(dg)
		local bt=dg:Clone()
		bt:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(bt)
	end)
end
function c421.tglimit(e,c)
	return c:GetFlagEffectLabel(513000065) and e:GetHandler():GetFlagEffectLabel(513000065)>c:GetFlagEffectLabel(513000065) or false
end
function c421.recon(e,c)
	return e:GetHandler():GetFlagEffect(513000065)>0 and c:GetControler()~=e:GetHandler():GetControler()
end
function c421.recon2(e)
	return e:GetHandler():GetFlagEffect(513000065)>0 and Duel.GetTurnPlayer()~=e:GetOwnerPlayer()
end
function c421.stgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(513000065)>0
end
function c421.stgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local effs={c:GetCardEffect()}
	for _,eff in ipairs(effs) do
		if eff:GetOwner()~=c and not eff:GetOwner():IsCode(421)
			and not eff:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			and (eff:GetTarget()==aux.PersistentTargetFilter or not eff:IsHasType(EFFECT_TYPE_GRANT+EFFECT_TYPE_FIELD)) then
			eff:Reset()
		end
	end
	if c:IsSummonType(SUMMON_TYPE_SPECIAL) then
		if c:IsPreviousLocation(LOCATION_GRAVE) then
			Duel.SendtoGrave(c,REASON_EFFECT)
		elseif c:IsPreviousLocation(LOCATION_DECK) then
			Duel.SendtoDeck(c,nil,2,REASON_RULE)
		elseif c:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(c,nil,REASON_RULE)
		elseif c:IsPreviousLocation(LOCATION_REMOVED) then
			Duel.Remove(c,c:GetPreviousPosition(),REASON_RULE)
		end
	end
end