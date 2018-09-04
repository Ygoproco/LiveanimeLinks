--Metal Baboon, Ruffian of the Forest
function c511009303.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511009303.matfilter,2,2)
end
function c511009303.matfilter(c,lc,sumtype,tp)
	return c:IsLevelAbove(5) and c:IsRace(RACE_BEAST,lc,sumtype,tp)
end
