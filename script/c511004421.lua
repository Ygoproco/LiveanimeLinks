--Rank-Up-Magic Cipher Shock
--fixed by MLD
function c511004421.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511004421.target)
	e1:SetOperation(c511004421.operation)
	c:RegisterEffect(e1)
end
function c511004421.filter(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return pg:GetCount()<=1 and c:IsSetCard(0xe5) and c:IsCanBeEffectTarget(e) and (c:GetRank()>0 or c:IsStatus(STATUS_NO_LEVEL)) 
		and Duel.IsExistingMatchingCard(c511004421.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1,pg)
end
function c511004421.spfilter(c,e,tp,mc,rk,pg)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return c:IsType(TYPE_XYZ) and mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsSetCard(0xe5) and c:IsRank(rk) and mc:IsCanBeXyzMaterial(c,tp) 
		and (pg:GetCount()<=0 or pg:IsContains(mc)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c511004421.target(e,tp,eg,ev,ep,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if a and a:IsControler(tp) then g:AddCard(a) end
	if d and d:IsControler(tp) then g:AddCard(d) end
	if chkc then return g:IsContains(chkc) and c511004421.filter(chkc,e,tp) end
	if chk==0 then return g:IsExists(c511004421.filter,1,nil,e,tp) end
	local fid=e:GetHandler():GetFieldID()
	local sg=g:FilterSelect(tp,c511004421.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(sg)
	local fg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=fg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(51104421,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1,fid)
		tc=fg:GetNext()
	end
	Duel.SetTargetParam(fid)
end
function c511004421.disfilter(c,fid)
	return c:GetFlagEffect(51104421)>0 and c:GetFlagEffectLabel(51104421)==fid
end
function c511004421.operation(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local fid=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) 
		or Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c511004421.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,fid)
	local dc=g:GetFirst()
	while dc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		dc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		dc:RegisterEffect(e2)
		dc=g:GetNext()
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c511004421.sumcon)
	e3:SetOperation(c511004421.sumop)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e3:SetLabelObject(tc)
	Duel.RegisterEffect(e3,tp)
end
function c511004421.sumcon(e,tp,eg,ev,ep,re,r,rp)
	return e:GetLabelObject():GetBattledGroupCount()~=0
end
function c511004421.sumop(e,tp,eg,ev,ep,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
	Duel.BreakEffect()
	local sg=Duel.SelectMatchingCard(tp,c511004421.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,pg)
	local sc=sg:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
