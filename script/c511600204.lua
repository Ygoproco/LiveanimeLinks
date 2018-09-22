--クロック・リザード
--Clock Lizard
--scripted by Larry126
function c511600204.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_CYBERSE),2,2)
	c:EnableReviveLimit()
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11228035,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c511600204.spcost)
	e1:SetTarget(c511600204.sptg)
	e1:SetOperation(c511600204.spop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37038993,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c511600204.atkcon)
	e2:SetTarget(c511600204.atktg)
	e2:SetOperation(c511600204.atkop)
	c:RegisterEffect(e2)
end
function c511600204.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c511600204.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function c511600204.tdfilter(c,e,tp,mg,f,mgc,mf)
	return c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and (c:CheckFusionMaterial(mg,nil,tp) and (not f or f(c))
		or c:CheckFusionMaterial(mgc,nil,tp) and (not mf or mf(c)))
end
function c511600204.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(c511600204.mfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local ce=Duel.GetChainMaterial(tp)
	local mgc=Group.CreateGroup()
	local mf=nil
	if ce~=nil then
		mgc=ce:GetTarget()(ce,e,tp)
		mf=ce:GetValue()
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511600204.tdfilter(chkc,e,tp,mg,nil,mgc,mf) end
	if chk==0 then return Duel.IsExistingTarget(c511600204.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg,nil,mgc,mf) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c511600204.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg,nil,mgc,mf)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_FUSION_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511600204.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		local mg=Duel.GetMatchingGroup(c511600204.mfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
		local mgc=Group.CreateGroup()
		local mf=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			mgc=ce:GetTarget()(ce,e,tp)
			mf=ce:GetValue()
		end
		local nf=tc:CheckFusionMaterial(mg,nil,tp) and (not f or f(tc))
		local cef=tc:CheckFusionMaterial(mgc,nil,tp) and (not mf or mf(tc))
		if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
			and (nf or cef) then
			Duel.BreakEffect()
			if nf and (not cef or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg,nil,tp)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mgc,nil,tp)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end
function c511600204.filter(c,p)
	return c:IsControler(p) and c:IsFaceup()
end
function c511600204.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()==Duel.GetTurnCount()
end
function c511600204.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511600204.filter,1,nil,1-tp) end
	local g=eg:Filter(c511600204.filter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,#g,1-tp,-Duel.GetMatchingGroupCount(Card.IsRace,e:GetOwnerPlayer(),LOCATION_GRAVE,0,nil,RACE_CYBERSE)*400)
end
function c511600204.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c511600204.val)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c511600204.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,e:GetOwnerPlayer(),LOCATION_GRAVE,0,nil,RACE_CYBERSE)*-400
end