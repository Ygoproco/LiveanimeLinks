--Rage Resynchro
function c511000900.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000900.target)
	e1:SetOperation(c511000900.activate)
	c:RegisterEffect(e1)
end
function c511000900.filter(c,e,tp)
	local tpe=c.synchro_type
	if not c:IsType(TYPE_SYNCHRO) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		or not tpe then return false end
	local lv=c:GetLevel()
	local t=c.synchro_parameters
	if tpe==1 then
		local f1,min1,max1,f2,min2,max2,sub1,sub2,req1,reqct1,req2,reqct2,reqm=table.unpack(t)
		local tg=Duel.GetMatchingGroup(c511000900.matfilter,tp,LOCATION_MZONE,0,nil,f1,sub1,false)
		local ntg=Duel.GetMatchingGroup(c511000900.matfilter,tp,LOCATION_MZONE,0,nil,f2,sub2,true)
		return (not req1 or tg:IsExists(req1,reqct1,nil,tp)) and (not req2 or tg:IsExists(req2,reqct2,nil,tp)) and tg:GetCount()>=min1 and ntg:GetCount()>=min2 
			and aux.SelectUnselectGroup(tg,e,tp,min1,max1,c511000900.trescon(ntg,min2,max2,req1,reqct1,req2,reqct2,reqm,lv),0)
	elseif tpe==2 then
		local f1,cbt1,f2,cbt2,f3,cbt3=table.unpack(t)
		local reqmt={table.unpack(t,7)}
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		return mg:IsExists(c511000900.majesticfilter,1,nil,mg,Group.CreateGroup(),tp,false,0,lv,f1,cbt1,f2,cbt2,f3,cbt3,#reqmt,table.unpack(reqmt))
	elseif tpe==3 then
		local f1,f2=table.unpack(t)
		local reqmt={table.unpack(t,5)}
		local ntg=Duel.GetMatchingGroup(c511000900.dmatfilter,tp,LOCATION_MZONE,0,nil,f1,true)
		local tg=Duel.GetMatchingGroup(c511000900.dmatfilter,tp,LOCATION_MZONE,0,nil,f2,false)
		return ntg:IsExists(c511000900.darksyncfilter,1,nil,nil,tg,tp,lv,table.unpack(reqmt))
	else
		return false
	end
end
function c511000900.darksyncfilter(c,ntc,g,tp,lv,...)
	if g then
		return g:IsExists(c511000900.darksyncfilter,1,c,c,nil,tp,lv,...)
	else
		if ntc:GetLevel()-c:GetLevel()~=-lv then return false end
		local sg=Group.FromCards(c,ntc)
		for _,reqm in ipairs({...}) do
			if reqm and not sg:IsExists(reqm,1,nil,tp) then return false end
		end
		return aux.ChkfMMZ(1)(sg,nil,tp)
	end
end
function c511000900.majesticfilter(c,g,sg,tp,hastuner,lv,sumlv,f,cbt,chk,...)
	if not f(c) then return false end
	local hastuner=hastuner or (cbt and c:IsType(TYPE_TUNER))
	local lv=lv+c:GetLevel()
	if lv>sumlv then return false end
	local res
	if type(chk)=='function' then
		sg:AddCard(c)
		res=mg:IsExists(c511000900.majesticfilter,1,sg,mg,sg,tp,hastuner,lv,sumlv,chk,...)
		sg:RemoveCard(c)
	else
		for _,reqm in ipairs({...}) do
			if reqm and not sg:IsExists(reqm,1,nil,tp) then return false end
		end
		res=hastuner and lv==sumlv and aux.ChkfMMZ(1)(sg,nil,tp)
	end
	return res
end
function c511000900.dmatfilter(c,f,nontuner)
	return c:IsFaceup() and (nontuner or c:IsType(TYPE_TUNER)) and (not f or f(c))
end
function c511000900.matfilter(c,f,sub,nontuner)
	return c:IsFaceup() and (nontuner or c:IsType(TYPE_TUNER)) and ((not f or f(c)) or (sub and sub(c)))
end
function c511000900.trescon(ntg,min2,max2,req1,reqct1,req2,reqct2,reqm,lv)
	return	function(sg,e,tp,mg)
				if sg:GetSum(Card.GetLevel)>lv then return false end
				local tempg=ntg:Filter(aux.TRUE,sg)
				return (not req1 or sg:IsExists(req1,reqct1,nil,tp)) and aux.SelectUnselectGroup(tempg,e,tp,min2,max2,c511000900.ntrescon(req2,reqct2,reqm,sg,lv),0)
			end
end
function c511000900.trescon(req2,reqct2,reqm,tg,lv)
	return	function(sg,e,tp,mg)
				local tempg=sg:Clone()
				tempg:Merge(tg)
				return aux.ChkfMMZ(1)(tempg,e,tp,mg) and tempg:GetSum(Card.GetLevel)==lv and (not req2 or sg:IsExists(req2,reqct2,nil,tp)) and (not reqm or tempg:IsExists(reqm,1,nil,tp))
			end
end
function c511000900.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511000900.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511000900.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511000900.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511000900.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c511000900.filter(tc,e,tp) then
		local lv=tc:GetLevel()
		local t=tc.synchro_parameters
		local sg=Group.CreateGroup()
		if tpe==1 then
			local f1,min1,max1,f2,min2,max2,sub1,sub2,req1,reqct1,req2,reqct2,reqm=table.unpack(t)
			local tg=Duel.GetMatchingGroup(c511000900.matfilter,tp,LOCATION_MZONE,0,nil,f1,sub1,false)
			local ntg=Duel.GetMatchingGroup(c511000900.matfilter,tp,LOCATION_MZONE,0,nil,f2,sub2,true)
			sg=aux.SelectUnselectGroup(tg,e,tp,min1,max1,c511000900.trescon(ntg,min2,max2,req1,reqct1,req2,reqct2,reqm,lv),1,tp,HINTMSG_TOGRAVE,c511000900.trescon(ntg,min2,max2,req1,reqct1,req2,reqct2,reqm,lv))
			ntg:Sub(sg)
			local sg2=aux.SelectUnselectGroup(ntg,e,tp,min2,max2,c511000900.ntrescon(req2,reqct2,reqm,sg,lv),1,tp,HINTMSG_TOGRAVE,c511000900.ntrescon(req2,reqct2,reqm,sg,lv))
			sg:Merge(sg2)
		elseif tpe==2 then
			local f1,cbt1,f2,cbt2,f3,cbt3=table.unpack(t)
			local reqmt={table.unpack(t,7)}
			local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			local ishastuner=false
			local slv=0
			local tab={f1,cbt1,f2,cbt2,f3,cbt3,#reqmt,table.unpack(reqmt)}
			for i=1,3 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=mg:FilterSelect(tp,c511000900.majesticfilter,1,1,sg,mg,sg,tp,ishastuner,slv,lv,table.unpack(tab))
				hastuner=hastuner or (cbt and g:GetFirst():IsType(TYPE_TUNER))
				slv=slv+g:GetFirst():GetLevel()
				sg:Merge(g)
				table.remove(tab,2)
				table.remove(tab,1)
			end
		elseif tpe==3 then
			local f1,f2=table.unpack(t)
			local reqmt={table.unpack(t,5)}
			local ntg=Duel.GetMatchingGroup(c511000900.dmatfilter,tp,LOCATION_MZONE,0,nil,f1,true)
			local tg=Duel.GetMatchingGroup(c511000900.dmatfilter,tp,LOCATION_MZONE,0,nil,f2,false)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			sg=ntg:FilterSelect(tp,c511000900.darksyncfilter,1,1,nil,nil,tg,tp,lv,table.unpack(reqmt))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=tg:FilterSelect(tp,c511000900.darksyncfilter,1,1,sg,sg:GetFirst(),nil,tp,lv,table.unpack(reqmt))
			sg:Merge(sg2)
		end
		if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)>0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetOperation(c511000900.desop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			e2:SetLabel(0)
			e2:SetCountLimit(1)
			tc:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete()
		end
	end
end
function c511000900.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
