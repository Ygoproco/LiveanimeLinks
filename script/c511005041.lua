--Traplin
--  By Shad3
--fixed and cleaned up by MLD
function c511005041.initial_effect(c)
	--SpSummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c511005041.spcon)
	e1:SetOperation(c511005041.spop)
	c:RegisterEffect(e1)
end
function c511005041.spfilter(c,ft,tp)
	return c:GetType()&(TYPE_TRAP+TYPE_CONTINUOUS)==(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsFaceup() and c:IsReleasable() 
		and (ft>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function c511005041.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(c511005041.spfilter,tp,LOCATION_ONFIELD,0,1,nil,ft,tp)
end
function c511005041.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c511005041.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp)
	Duel.Release(g,REASON_COST)
end
