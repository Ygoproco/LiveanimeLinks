--Dragonic Unit Ritual
function c511000350.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000350.cost)
	e1:SetTarget(c511000350.target)
	e1:SetOperation(c511000350.activate)
	c:RegisterEffect(e1)
end
function c511000350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c511000350.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c511000350.chk,1,nil,sg,Group.CreateGroup(),511002171,511002255)
end
function c511000350.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c511000350.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c511000350.filter(c,...)
	return c:IsCode(...) and c:IsFaceup() and c:IsAbleToGrave()
end
function c511000350.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c511000350.filter,tp,LOCATION_MZONE,0,nil,511002171)
	local g2=Duel.GetMatchingGroup(c511000350.filter,tp,LOCATION_MZONE,0,nil,511002255)
	local g=g1:Clone()
	g:Merge(g2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g1:GetCount()>0 and g2:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,2,2,c511000350.rescon,0)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,38109772,0,0x21,2800,2300,7,RACE_DRAGON,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c511000350.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,38109772,0,0x21,2800,2300,7,RACE_DRAGON,ATTRIBUTE_FIRE) then return end
	local g=Duel.GetMatchingGroup(c511000350.filter,tp,LOCATION_MZONE,0,nil,511002171,511002255)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c511000350.rescon,1,tp,HINTMSG_TOGRAVE)
	if sg:GetCount()>1 and Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
		local tc=Duel.CreateToken(tp,38109772)
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
