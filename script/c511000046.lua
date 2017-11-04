--Amphibian Angel - Frog-Hael
function c511000046.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c511000046.spcon)
	e1:SetOperation(c511000046.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000046,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c511000046.con)
	e2:SetTarget(c511000046.tg)
	e2:SetOperation(c511000046.op)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c511000046.atcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c511000046.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and rg:GetCount()>1 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0)
end
function c511000046.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp)
	local sg=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
end
function c511000046.filter(c,e,tp)
	return c:IsSetCard(0x12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511000046.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function c511000046.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c511000046.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c511000046.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000046.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c511000046.atcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
