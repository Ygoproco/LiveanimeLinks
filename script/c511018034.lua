--Gorgon
function c511018034.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,511018031,511018032,511018033)
	aux.AddContactFusion(c,c511018034.contactfil,c511018034.contactop,c511018034.splimit,aux.TRUE,1)
end
function c511018034.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c511018034.contactop(g,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function c511018034.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end