--Number 19: Freezerdon (anime)
function c511001779.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--reattach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001779,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c511001779.cost)
	e1:SetTarget(c511001779.target)
	e1:SetOperation(c511001779.operation)
	c:RegisterEffect(e1,false,1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x48)))
	c:RegisterEffect(e2)
	aux.CallToken(55067058)
end
c511001779.xyz_number=19
function c511001779.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511001779.filter(c)
	local g=c:GetMaterial():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and g:GetCount()>0
end
function c511001779.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001779.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c511001779.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c511001779.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local mat=tc:GetMaterial():Filter(aux.NecroValleyFilter(Card.IsLocation),nil,LOCATION_GRAVE)
		if not tc:IsImmuneToEffect(e) then
			Duel.Overlay(tc,mat)
		end
	end
end
