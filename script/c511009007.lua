--Mystic Factor Caspar
function c511009007.initial_effect(c)
	--level up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009007,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c511009007.lvtg)
	e1:SetOperation(c511009007.lvop)
	c:RegisterEffect(e1)
end
function c511009007.lvfilter(c)
	return c:IsFaceup() and not c:IsLevel(1)
end
function c511009007.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLevelAbove(3) and Duel.IsExistingMatchingCard(c511009007.lvfilter,tp,LOCATION_MZONE,0,1,c) end
end
function c511009007.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(c511009007.lvfilter,tp,LOCATION_MZONE,0,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-2)
	e1:SetReset(RESET_EVENT+0xfe0000)
	c:RegisterEffect(e1)

	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end		
end