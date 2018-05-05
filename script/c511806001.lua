--D－HERO Dreadmaster (Anime)
--Ｄ－ＨＥＲＯ ドレッドガイ
--fixed by MLD
function c511806001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40591390,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c511806001.sptg)
	e1:SetOperation(c511806001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c511806001.indop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SET_ATTACK)
	e7:SetValue(c511806001.val)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e8)
end
function c511806001.desfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xc008)
end
function c511806001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c511806001.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511806001.spfilter(c,e,tp)
	return c:IsSetCard(0xc008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511806001.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511806001.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=math.min(ft,1) end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c511806001.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40591390,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=sg:Select(tp,1,ft,nil)
		Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c511806001.filter(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc008)
end
function c511806001.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPosition(POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc008))
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		Duel.RegisterEffect(e3,tp)
	end
end
function c511806001.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc008)
end
function c511806001.val(e,c)
	local g=Duel.GetMatchingGroup(c511806001.atfilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetAttack)
end
