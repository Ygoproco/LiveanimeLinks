--Dark Mummy Infuser
function c511009656.initial_effect(c)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009656,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c511009656.target)
	e1:SetCondition(c511009656.condition)
	e1:SetOperation(c511009656.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c511009656.incon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c511009656.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_ZOMBIE)
end
function c511009656.condition(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c511009656.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone())
	end
	return eg:IsContains(e:GetHandler())
end
function c511009656.filter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_LINK)  and c:GetLinkedGroup():IsContains(ec)
	-- ((ec==c and c:GetFlagEffect(55063681)==0) or (ec~=c and not ec:IsHasCardTarget(c)))
end
function c511009656.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511009656.filter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c511009656.filter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511009656.filter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
end
function c511009656.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
			c:SetCardTarget(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c511009656.efilter)
			e1:SetCondition(c511009656.atkcon)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
	end
end
function c511009656.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c511009656.atkcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c511009656.incon(e)
	return e:GetHandler():IsLinkState()
end
