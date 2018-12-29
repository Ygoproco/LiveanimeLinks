--D/D/D Xyz
function c511015103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511015103.target)
	e1:SetOperation(c511015103.activate)
	c:RegisterEffect(e1)
end
function c511015103.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsSetCard(0x10af) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511015103.xyzfilter(c,sg,e)
	local ct=sg:GetCount()
	local mc=e:GetHandler()
	local e1=nil
	if sg:IsExists(Card.IsCode,1,nil,47198668) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e1=Effect.CreateEffect(mc)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(511002116)
		e1:SetReset(RESET_CHAIN)
		mc:RegisterEffect(e1)
		sg:AddCard(mc)
	end
	local res=c:IsXyzSummonable(sg,ct,ct)
	if e1 then e1:Reset() sg:RemoveCard(mc) end
	return res
end
function c511015103.rescon(mft,exft,ft)
	return	function(sg,e,tp,mg)
				local exct=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
				local mct=sg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_EXTRA)
				return exft>=exct and mft>=mct and ft>=sg:GetCount() 
					and Duel.IsExistingMatchingCard(c511015103.xyzfilter,tp,LOCATION_EXTRA,0,1,sg,sg,e)
			end
end
function c511015103.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c511015103.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	local ftex=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ftt=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]-1
	if ect then ftex=math.min(ftex,ect) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ftt=math.min(ftt,1) ftex=math.min(ftex,1) ft=math.min(ft,1) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and ftt>0 and (ft>0 or ftex>0)
		and aux.SelectUnselectGroup(mg,e,tp,nil,ftt,c511015103.rescon(ft,ftex,ftt),0) end
	local sg=aux.SelectUnselectGroup(mg,e,tp,nil,ftt,c511015103.rescon(ft,ftex,ftt),1,tp,HINTMSG_SPSUMMON,c511015103.rescon(ft,ftex,ftt))
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount()+1,tp,LOCATION_EXTRA)
end
function c511015103.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and g:GetCount()>1 then return end
	local ftex=Duel.GetLocationCountFromEx(tp)
	local ftt=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect then ftex=math.min(ftex,ect) end
	if ftt<g:GetCount() or g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)>ftex then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sg=aux.SelectUnselectGroup(g,e,tp,nil,ftt,c511015103.rescon(ft,ftex,ftt),1,tp,HINTMSG_SPSUMMON,c511015103.rescon(ft,ftex,ftt))
		if sg:GetCount()<=0 then return false end
		g=sg
	end
	if not aux.MainAndExtraSpSummonLoop(c511015103.disop,0,0,0,false,false)(e,tp,eg,ep,ev,re,r,rp,g) then return end
	local xyzg=Duel.GetMatchingGroup(c511015103.xyzfilter,tp,LOCATION_EXTRA,0,g,g,e)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and g:IsExists(Card.IsCode,1,nil,47198668) then
			e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(511002116)
			e1:SetReset(RESET_CHAIN)
			c:RegisterEffect(e1)
			g:AddCard(c)
		end
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c511015103.disop(e,tp,eg,ep,ev,re,r,rp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
end
