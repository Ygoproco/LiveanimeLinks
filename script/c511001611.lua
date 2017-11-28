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
function c511001611.filter(c,zero)
	if not c:IsSetCard(0x48) or not c:IsType(TYPE_XYZ) or not c.xyz_number then return false end
	if zero then
		return c.xyz_number==0
	else
		return c.xyz_number>0
	end
end
function c511001611.spfilterdefequal(c,e,tp,sum)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and c.xyz_number and c.xyz_number==sum
end
function c511001611.spfilterchk(c,ct)
	return c.xyz_number==ct
end
function c511001611.spfilterchkmoreeq(c,ct)
	return c.xyz_number>=ct
end
function c511001611.spfilterchkmore(c,ct)
	return c.xyz_number>ct
end
function c511001611.xyz(c)
	return c.xyz_number
end
function c511001611.numchk(c,sg,g,max,sum,spg)
	if spg:GetCount()<=0 or sum>max then return false end
	sg:AddCard(c)
	sum=sum+c.xyz_number
	local res=spg:IsExists(c511001611.spfilterchk,1,sg,sum)
	if not res then
		local tspg=spg:Filter(c511001611.spfilterchkmore,sg,sum)
		if tspg:GetCount()>0 then
			local newmax=c511001611.xyz(tspg:GetMaxGroup(c511001611.xyz):GetFirst())
			res=g:IsExists(c511001611.numchk,1,sg,sg,g,newmax,sum,tspg)
		end
	end
	sg:RemoveCard(c)
	sum=sum-c.xyz_number
	return res
end
function c511001611.filter0(c,e,tp,sum,g,spg)
	g:AddCard(c)
	local res
	if spg then
		res=spg:IsExists(c511001611.spfilterchk,1,g,sum)
	else
		res=Duel.IsExistingMatchingCard(c511001611.spfilterdefequal,tp,LOCATION_EXTRA,0,1,g,e,tp,sum)
	end
	g:RemoveCard(c)
	return res
end
function c511001611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c511001611.filter,tp,LOCATION_EXTRA,0,nil,false)
		local mg0=Duel.GetMatchingGroup(c511001611.filter,tp,LOCATION_EXTRA,0,nil,true)
		local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
		if pg:GetCount()>0 or Duel.GetLocationCountFromEx(tp)<=0 then return false end
		if mg0:IsExists(c511001611.filter0,1,nil,e,tp,0,Group.CreateGroup()) then return true end
		if mg:GetCount()<=1 then return false end
		local spg=Duel.GetMatchingGroup(c511001611.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if spg:GetCount()<=0 then return false end
		local max=c511001611.xyz(spg:GetMaxGroup(c511001611.xyz):GetFirst())
		return mg:IsExists(c511001611.numchk,1,nil,Group.CreateGroup(),mg,max,0,spg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c511001611.activate(e,tp,eg,ep,ev,re,r,rp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
	if pg:GetCount()>0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	local mg=Duel.GetMatchingGroup(c511001611.filter,tp,LOCATION_EXTRA,0,nil,false)
	local mg0=Duel.GetMatchingGroup(c511001611.filter,tp,LOCATION_EXTRA,0,nil,true)
	local xg=Group.CreateGroup()
	local sum=0
	local spg=Duel.GetMatchingGroup(c511001611.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if spg:GetCount()<=0 then return end
	local max=c511001611.xyz(spg:GetMaxGroup(c511001611.xyz):GetFirst())
	while true do
		local cancel=xg:GetCount()>0 and spg:IsExists(c511001611.spfilterchk,1,xg,sum)
		local tspg=spg:Filter(c511001611.spfilterchkmoreeq,xg,sum)
		local selg=mg:Filter(c511001611.numchk,xg,xg,mg,max,sum,tspg)
		if xg:GetCount()==0 then
			selg:Merge(mg0:Filter(c511001611.filter0,xg,e,tp,sum,xg,tspg))
		else
			selg:Merge(mg0:Filter(aux.TRUE,xg))
		end
		if selg:GetCount()<=0 then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=selg:SelectUnselect(xg,tp,cancel,cancel)
		if not tc then break end
		if xg:IsContains(tc) then
			xg:RemoveCard(tc)
			sum=sum-tc.xyz_number
			if spg:IsContains(tc) then
				tspg:AddCard(tc)
			end
		else
			xg:AddCard(tc)
			sum=sum+tc.xyz_number
			if tspg:IsContains(tc) then
				tspg:RemoveCard(tc)
			end
		end
		if tspg:GetCount()>0 then
			max=c511001611.xyz(tspg:GetMaxGroup(c511001611.xyz):GetFirst())
		end
	end
	if xg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spc=spg:FilterSelect(tp,c511001611.spfilterchk,1,1,xg,sum):GetFirst()
	if spc and Duel.SpecialSummon(spc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Overlay(spc,xg)
		spc:CompleteProcedure()
	end
end
