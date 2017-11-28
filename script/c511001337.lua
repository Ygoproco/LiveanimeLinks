--Kragen Spawn
function c511001337.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c511001337.destg)
	e1:SetOperation(c511001337.desop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511001337,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c511001337.sumcon)
	e2:SetTarget(c511001337.sumtg)
	e2:SetOperation(c511001337.sumop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c511001337.op)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c511001337.desfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c511001337.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511001337.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511001337.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511001337.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,g:GetFirst():GetControler(),0)
end
function c511001337.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Damage(tc:GetControler(),atk,REASON_EFFECT)
		end
	end
end
function c511001337.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
end
function c511001337.spfilter(c,e,tp)
	return c:IsCode(511001336,511001337) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001337.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c511001337.rescon(sg,e,tp,mg)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	return Duel.GetLocationCountFromEx(tp)>=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=sg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_EXTRA)
		and Duel.GetUsableMZoneCount(tp)>=sg:GetCount()
		and (not ect or sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect) 
end
function c511001337.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	local ct=g:GetCount()
	local sg=Duel.GetMatchingGroup(c511001337.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	if chk==0 then return ct>0 and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct<=1) 
		and aux.SelectUnselectGroup(sg,e,tp,nil,nil,c511001337.rescon,0) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,nil)
end
function c511001337.sumop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=mg:GetCount()
	if ct<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c511001337.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,ct,ct,c511001337.rescon,1,tp,HINTMSG_SPSUMMON)
	if sg:GetCount()<=0 then return end
	aux.MainAndExtraSpSummonLoop(c511001337.ovop(mg),0,0,0,false,false)(e,tp,eg,ep,ev,re,r,rp,sg)
end
function c511001337.ovop(mg)
	return	function(e,tp,eg,ep,ev,re,r,rp,tc)
				local og=mg:Select(tp,1,1,nil)
				Duel.Overlay(tc,og)
				mg:Sub(og)
			end
end
