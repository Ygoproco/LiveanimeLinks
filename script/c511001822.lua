--RUM－バリアンズ・フォース
function c511001822.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511001822.target)
	e1:SetOperation(c511001822.activate)
	c:RegisterEffect(e1)
	aux.CallToken(420)
end
function c511001822.filter1(c,e,tp)
	local rk=c:GetRank()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return pg:GetCount()<=1 and c:IsFaceup() and (rk>0 or c:IsStatus(STATUS_NO_LEVEL)) 
		and Duel.IsExistingMatchingCard(c511001822.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,pg)
end
function c511001822.filter2(c,e,tp,mc,rk,pg)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return c:IsType(TYPE_XYZ) and mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and mc:IsCanBeXyzMaterial(c,tp) and c:IsC() 
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and mc:IsCanBeXyzMaterial(c) and (pg:GetCount()<=0 or pg:IsContains(mc)) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c511001822.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511001822.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511001822.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c511001822.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511001822.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511001822.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,pg)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetTarget(c511001822.distg)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetTarget(c511001822.dettg)
		e2:SetOperation(c511001822.detop)
		e2:SetLabelObject(sc)
		e2:SetReset(RESET_CHAIN)
		c:RegisterEffect(e2)
	end
end
function c511001822.distg(e,c)
	return c~=e:GetHandler() and c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
end
function c511001822.detfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c511001822.dettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c511001822.detfilter(chkc) end
	if chk==0 then return sc and Duel.IsExistingTarget(c511001822.detfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511001822.detfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c511001822.detop(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and sc then
		local og=tc:GetOverlayGroup()
		if og:GetCount()==0 then return end
		if Duel.SendtoGrave(og,REASON_EFFECT)>0 then
			Duel.Overlay(sc,og)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(og:GetCount()*-300)
			tc:RegisterEffect(e1)
		end
	end
end
