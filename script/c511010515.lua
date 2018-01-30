--DDD超死偉王ダークネス・ヘル・アーマゲドン
function c511010515.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x10af),8,2)
	--xyz indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--xyz cannot be target
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--attach
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(511010515,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c511010515.xyzcon)
	e4:SetTarget(c511010515.xyztg)
	e4:SetOperation(c511010515.xyzop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c511010515.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--pendulum indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetDescription(aux.Stringid(511010515,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c511010515.cost)
	e7:SetTarget(c511010515.target)
	e7:SetOperation(c511010515.operation)
	c:RegisterEffect(e7)
end
function c511010515.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,47198668) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c511010515.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function c511010515.xyzfilter(c)
	return c:IsFaceup() and c:GetLocation()==LOCATION_EXTRA and c:IsCode(47198668)
end
function c511010515.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511010515.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c511010515.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.GetMatchingGroup(c511010515.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>=1 then
		local og=g:Select(tp,1,1,nil)
		Duel.Overlay(c,og)
	end
end
function c511010515.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)	
end
function c511010515.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c511010515.dfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
function c511010515.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c511010515.filter,tp,LOCATION_MZONE,0,nil)<=Duel.GetMatchingGroupCount(c511010515.dfilter,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER) end
	local ct=Duel.GetMatchingGroupCount(c511010515.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,c511010515.dfilter,tp,0,LOCATION_MZONE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c511010515.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c511010515.filter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c511010515.dfilter,tp,0,LOCATION_MZONE,nil)
	if ct>g:GetCount() then return end
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(dg,REASON_EFFECT)
end
