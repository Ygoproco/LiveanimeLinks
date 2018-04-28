--Salamangreat Foxy
function c511009917.initial_effect(c)
	--special summon 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009917,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c511009917.spcost)
	e1:SetTarget(c511009917.sptg)
	e1:SetOperation(c511009917.spop)
	c:RegisterEffect(e1)
end
function c511009927.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009007.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) 
end
function c511009917.costfilter(c)
	return c:IsSetCard(0x578) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c511009917.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c511009917.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511009917.costfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c511009917.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_SZONE)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c511009917.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceUp()
end
function c511009917.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c511009917.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)

		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end