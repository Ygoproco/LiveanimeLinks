--Blackwing - Delta Union
function c511000775.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000775.target)
	e1:SetOperation(c511000775.activate)
	c:RegisterEffect(e1)
end
function c511000775.spfilter(c,e,tp,tid)
	return c:IsSetCard(0x33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetTurnID()==tid and c:IsReason(REASON_DESTROY)
end
function c511000775.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33)
end
function c511000775.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(c511000775.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tid)
	local sg=Duel.GetMatchingGroup(c511000775.eqfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 and (g:GetCount()>1 or sg:GetCount()>0)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() and Duel.GetLocationCount(tp,LOCATION_SZONE)>=g:GetCount()+sg:GetCount()-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,sg:GetCount()+g:GetCount()-1,tp,0)
end
function c511000775.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(c511000775.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tid)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local sg=Duel.GetMatchingGroup(c511000775.eqfilter,tp,LOCATION_MZONE,0,nil)
		if sg:GetCount()>1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=sg:GetCount()-1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=sg:Select(tp,1,1,nil):GetFirst()
			sg:RemoveCard(ec)
			sg:ForEach(function(tc)
				Duel.Equip(tp,tc,ec,false,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c511000775.eqlimit)
				e1:SetLabelObject(ec)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(500)
				tc:RegisterEffect(e2)
			end)
			Duel.EquipComplete()
		end
	end
end
function c511000775.eqlimit(e,c)
	return e:GetLabelObject()==c
end
