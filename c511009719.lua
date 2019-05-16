--Hydradrive Mutation
--Scripted by Rundas
local s,id=GetID()
function c511009719.initial_effect(c)
	--special summon + set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)	
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.summoncost)
	e1:SetTarget(s.summontarget)
	e1:SetOperation(s.summonoperation)
	c:RegisterEffect(e1)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)	
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.attributetarget)
	e2:SetOperation(s.attributeoperation)
	c:RegisterEffect(e2)
end

--special summon + set

function s.bouncefilter(c)
	return c:IsAbleToHandAsCost() and c:GetType()==0x20004 and c:IsFaceup()
end

function s.setfilter(c)
	return c:GetType()==0x20004 and c:IsSSetable()
end

function s.summoncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.bouncefilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.bouncefilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end

function s.summontarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.summonoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	if Duel.SelectYesNo(tp,97) and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND,0,1,nil) then
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,g)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			end
			end
	end

--change attribute

function s.attributefilter(c)
	return c:IsCanBeEffectTarget()
end
	
function s.attributetarget(e,tp,eg,ep,ev,re,r,rp,chk,chck)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(s.attributefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	Duel.SelectTarget(tp,s.attributefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function s.attributeoperation(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetLocationCount(tp,LOCATION_MZONE) and Duel.GetLocationCount(1-tp,LOCATION_MZONE))<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(Card.GetAttribute(tc))
		e:GetHandler():RegisterEffect(e1)
	end
	end