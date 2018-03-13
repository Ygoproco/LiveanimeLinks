--デストーイ・マイスター (Anime)
--Frightfur Meister (Anime)
--scripted by Larry126
function c511600064.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(c511600064.atkcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4013,9))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c511600064.target)
	e2:SetOperation(c511600064.operation)
	c:RegisterEffect(e2)
	--special summon ex
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4013,10))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c511600064.excost)
	e3:SetTarget(c511600064.extg)
	e3:SetOperation(c511600064.exop)
	c:RegisterEffect(e3)
end
function c511600064.spcheck(sg,tp,exg,e)
	return Duel.IsExistingMatchingCard(c511600064.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
end
function c511600064.exfilter(c,e,tp,sg)
	return c:IsSetCard(0xad) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_FUSION)
		and c:IsLevel(sg:GetSum(Card.GetLevel)) and Duel.GetLocationCountFromEx(tp,tp,sg,c)>0
end
function c511600064.cgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xad)
end
function c511600064.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c511600064.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupCost(tp,c511600064.cgfilter,0,false,c511600064.spcheck,nil,e)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=Duel.SelectReleaseGroupCost(tp,c511600064.cgfilter,1,99,false,c511600064.spcheck,nil,e)
	e:SetLabel(mg:GetSum(Card.GetLevel))
	Duel.Release(mg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511600064.sefilter(c,e,tp,lv)
	return c:IsSetCard(0xad) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_FUSION)
end
function c511600064.exop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511600064.sefilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c511600064.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xad) and c:IsType(TYPE_MONSTER)
end
function c511600064.atkcon(e)
	return Duel.IsExistingMatchingCard(c511600064.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c511600064.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c511600064.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsSetCard(0xad) or c:IsSetCard(0xa9) or c:IsSetCard(0xc3))
		and Duel.IsExistingMatchingCard(c511600064.cfilter,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c511600064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511600064.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511600064.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511600064.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end