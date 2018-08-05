--Amatsu, Okami of the Divine Peaks
function c501000087.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c501000087.filter,3)
	--match kill
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATCH_KILL)
	e1:SetCondition(c501000087.con)
	c:RegisterEffect(e1)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.lnklimit)
	c:RegisterEffect(e3)
end
function c501000087.con(e)
	return e:GetHandler():IsExtraLinked()
end
function c501000087.filter(c,lc,sumtype,tp)
	return c:IsType(TYPE_EFFECT,lc,sumtype,tp) and c:IsRace(RACE_DRAGON,lc,sumtype,tp)
end