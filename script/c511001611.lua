--Numbers Evaille
function c511001611.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001611.target)
	e1:SetOperation(c511001611.activate)
	c:RegisterEffect(e1)
end
function c511001611.filter(c)
	return c:IsSetCard(0x48) and c:IsType(TYPE_XYZ) and c.xyz_number
end
function c511001611.spfilter(c,e,tp,g)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and c.xyz_number and g:CheckWithSumEqual(function(c) return c.xyz_number end,c.xyz_number,g:GetCount(),g:GetCount())
end
function c511001611.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(c511001611.spfilter,tp,LOCATION_EXTRA,0,1,sg,e,tp,sg)
end
function c511001611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c511001611.filter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then
		local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
		return pg:GetCount()<=0 and Duel.GetLocationCountFromEx(tp)>0 and aux.SelectUnselectGroup(mg,e,tp,nil,nil,c511001611.rescon,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c511001611.activate(e,tp,eg,ep,ev,re,r,rp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
	if pg:GetCount()>0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	local mg=Duel.GetMatchingGroup(c511001611.filter,tp,LOCATION_EXTRA,0,nil)
	local xg=aux.SelectUnselectGroup(mg,e,tp,nil,nil,c511001611.rescon,1,tp,HINTMSG_XMATERIAL,c511001611.rescon)
	if xg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spc=Duel.SelectMatchingCard(tp,c511001611.spfilter,tp,LOCATION_EXTRA,0,1,1,xg,e,tp,xg):GetFirst()
	if Duel.SpecialSummon(spc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Overlay(spc,xg)
		spc:CompleteProcedure()
	end
end
