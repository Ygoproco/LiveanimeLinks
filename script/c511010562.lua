--Dark Wave (Anime)
function c511010562.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(c511010562.target)
	e1:SetOperation(c511010562.activate)
	c:RegisterEffect(e1)
end
function c511010562.filter(c)
	return c:IsFaceup()
end
function c511010562.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511010562.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c511010562.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c511010562.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c511010562.filter,tp,LOCATION_MZONE,0,nil)	   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tdg=dg:Select(tp,1,1,nil)
	local tc=tdg:GetFirst()
	local val=-1
	if tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ALLOW_NEGATIVE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(tc:GetLevel()*val)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end