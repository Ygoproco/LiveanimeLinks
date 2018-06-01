--鉄の騎士 (Anime)
--Iron Knight (Anime)
--Jackpro 1.3
function c511001415.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c511001415.sdcon)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
end
c511001415.listed_names={41916534}
function c511001415.filter(c)
	return c:IsFaceup() and c:IsCode(41916534)
end
function c511001415.sdcon(e)
	return Duel.IsExistingMatchingCard(c511001415.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end