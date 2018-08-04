--ワルキューレ・ドリット (Anime)
--Valkyrie Dritte (Anime)
function c100000534.initial_effect(c)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c100000534.atkvalue)
	c:RegisterEffect(e1)
end
function c100000534.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c100000534.atkvalue(e,c)
	return Duel.GetMatchingGroupCount(c100000534.rmfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end