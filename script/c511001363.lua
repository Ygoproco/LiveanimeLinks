--CX 冀望皇バリアン (Anime)
--CXyz Barian Hope (Anime)
--fixed by Larry126
function c511001363.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3,nil,nil,5)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67926903,0))
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c511001363.xyzcon)
	e0:SetOperation(c511001363.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c511001363.atkval)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67926903,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c511001363.copycon)
	e2:SetTarget(c511001363.copytg)
	e2:SetOperation(c511001363.copyop)
	c:RegisterEffect(e2)
	if not c511001363.global_check then
		c511001363.global_check=true
		--Copy
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c511001363.op)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511001363.cfilter(c)
	return c:IsHasEffect(511002571) and #{c:GetCardEffect(5110013630)}==0
end
function c511001363.op(e)
	local g=Duel.GetMatchingGroup(c511001363.cfilter,0,0xff,0xff,nil)
	for c in aux.Next(g) do
		local effs={c:GetCardEffect(511002571)}
		for _,eff in ipairs(effs) do
			local resetflag,resetcount=eff:GetLabelObject():GetReset()
			local prop1,prop2=eff:GetProperty()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_XMATERIAL)
			e1:SetCode(511001363)
			e1:SetProperty(prop1,prop2)
			e1:SetLabel(c:GetOriginalCode())
			e1:SetLabelObject(eff:GetLabelObject())
			if resetflag and resetcount then
				e1:SetReset(resetflag,resetcount)
			elseif resetflag then
				e1:SetReset(resetflag)
			end
			c:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(5110013630)
			e2:SetProperty(prop1,prop2)
			if resetflag and resetcount then
				e2:SetReset(resetflag,resetcount)
			elseif resetflag then
				e2:SetReset(resetflag)
			end
			c:RegisterEffect(e2,true)
		end
	end
end
function c511001363.ovfilter(c)
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil then return false end
	local no=class.xyz_number
	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x1048)
end
function c511001363.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c511001363.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return mg:GetCount()>0 and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c511001363.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	og=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c511001363.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	og:Merge(mg)
	local tc=mg:GetFirst()
	while tc do
		local ov=tc:GetOverlayGroup()
		if ov:GetCount()>0 then
			Duel.Overlay(c,ov)
			og:Merge(ov)
		end
		tc=mg:GetNext()
	end
	c:SetMaterial(og)
	Duel.Overlay(c,og)
end
function c511001363.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c511001363.copycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511001363.filter(c,e,tp)
	if not c:IsCanBeEffectTarget(e) then return false end
	local effs={e:GetHandler():GetCardEffect(511001363)}
	for _,teh in ipairs(effs) do
		local te=teh:GetLabelObject()
		local tg=te:GetTarget()
		if te:GetHandler()==c and te:GetHandler():GetFlagEffect(511001363)==0 and (not tg or tg(e,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) then return true end
	end
	return false
end
function c511001363.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local a=c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b=Duel.CheckLPCost(tp,400)
	local ov=c:GetOverlayGroup()
	if chkc then return false end
	if chk==0 then return (a or b) and #{c:GetCardEffect(511001363)}>0 and ov:IsExists(c511001363.filter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=ov:FilterSelect(tp,c511001363.filter,1,1,nil,e,tp):GetFirst()
	tc:RegisterFlagEffect(511001363,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	e:SetProperty(0)
	Duel.SetTargetCard(tc)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76922029,0))
	if a and b then
		op=Duel.SelectOption(tp,aux.Stringid(81330115,0),aux.Stringid(21454943,1))
	elseif a and not b then
		Duel.SelectOption(tp,aux.Stringid(81330115,0))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(21454943,1))
		op=1
	end
	if op==0 then
		Duel.SendtoGrave(tc,REASON_COST) 
	else
		Duel.PayLPCost(tp,400)
	end
end
function c511001363.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		local eff={tc:GetCardEffect(511002571)}
		local tes={e:GetHandler():GetCardEffect(511001363)}
		for _,te in ipairs(tes) do
			if te:GetLabelObject():GetHandler()==tc then
				table.insert(eff,te)
			end
		end
		local te=nil
		local acd={}
		local ac={}
		for _,teh in ipairs(eff) do
			local temp=teh:GetLabelObject()
			local tg=temp:GetTarget()
			if temp:GetHandler():GetFlagEffect(511001363)==0 and (not tg or tg(e,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) then
				table.insert(ac,teh)
				table.insert(acd,temp:GetDescription())
			end
		end
		if #ac==1 then te=ac[1] elseif #ac>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			op=Duel.SelectOption(tp,table.unpack(acd))
			op=op+1
			te=ac[op]
		end
		if not te then return end
		local teh=te
		te=teh:GetLabelObject()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if tg then tg(e,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,1) end
		Duel.BreakEffect()
		tc:CreateEffectRelation(e)
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(e)
				etc=g:GetNext()
			end
		end
		if op then op(e,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,1) end
		tc:ReleaseEffectRelation(e)
		if etc then 
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(e)
				etc=g:GetNext()
			end
		end
	end
end