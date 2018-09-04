--G Golem Invalid Dolmen
function c511009429.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c60292055.matfilter,2,2)
end
function c60292055.matfilter(c,lc,sumtype,tp)
	return c:IsLevelAbove(5) and c:IsRace(RACE_BEAST,lc,sumtype,tp)
end