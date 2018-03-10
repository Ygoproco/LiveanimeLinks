--Sunavalon Dryanome
function c511009668.initial_effect(c)	
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),2)
	--material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c511009668.valcheck)
	c:RegisterEffect(e0)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetCondition(c511009668.matcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e0)
	e3:SetCountLimit(3)
	e3:SetCondition(c511009668.spcon)
	e3:SetTarget(c511009668.sptg)
	e3:SetOperation(c511009668.spop)
	c:RegisterEffect(e3)
	--move & negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c511009668.mvcon)
	e4:SetCost(c511009668.mvcost)
	e4:SetOperation(c511009668.mvop)
	c:RegisterEffect(e4)
end
function c511009668.matcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetTurnID()==Duel.GetTurnCount()
end
function c511009668.matfilter(c)
	return c:IsOriginalSetCard(0x574)
end
function c511009668.valcheck(e,c)
	if c:GetMaterial():IsExists(c511009668.matfilter,1,nil,tp) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c511009668.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r&REASON_BATTLE+REASON_EFFECT~=0 and e:GetLabelObject():GetLabel()==1
end
function c511009668.filter(c,e,tp,zone)
	return c:IsSetCard(0x575) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c511009668.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK)
end
function c511009668.zonefilter(tp)
	local lg=Duel.GetMatchingGroup(c511009668.lkfilter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	lg:ForEach(function(tc)
		zone=zone|tc:GetLinkedZone()
	end)
	return zone
end
function c511009668.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=c511009668.zonefilter(tp)
	if chk==0 then
		local zone=c511009668.zonefilter(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c511009668.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c511009668.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=c511009668.zonefilter(tp)
	if Duel.GetLocationCountFromEx(tp)<=0 and zone~=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511009668.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)>0 then
		Duel.Recover(tp,ev,REASON_EFFECT)
	end
end
function c511009668.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local d=Duel.GetAttackTarget()
	return d and lg:IsContains(d)
end
function c511009668.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetLocationCount(at:GetControler(),LOCATION_MZONE)>0 end
	local s
	if at:IsControler(tp) then
		s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
	else
		s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,nil)
	end
	local nseq=math.log(s,2)
	Duel.MoveSequence(at,nseq)
end
function c511009668.mvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
