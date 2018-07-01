--融合解除 (Manga)
--De-Fusion (Manga)
--updated by Larry126
function c511000987.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c511000987.target)
	e1:SetOperation(c511000987.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_SPELL)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c511000987.handcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	c:RegisterEffect(e4)
end
function c511000987.handcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c511000987.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return at:IsFaceup() and at:IsType(TYPE_FUSION) and at:IsAbleToExtra()
		and at:IsOnField() and at:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,at,1,0,0)
end
function c511000987.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(c:GetOwner()) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c)
end
function c511000987.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	local p=tc:GetControler()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		if tc:IsSummonType(SUMMON_TYPE_FUSION) and ct>0 and ct<=Duel.GetLocationCount(p,LOCATION_MZONE)
			and mg:FilterCount(aux.NecroValleyFilter(c511000987.mgfilter),nil,e,p,tc,mg)==ct
			and (ct<=1 or not Duel.IsPlayerAffectedByEffect(p,59822133)) then
			Duel.SpecialSummon(mg,0,tp,p,false,false,POS_FACEUP)
		end
	end
end