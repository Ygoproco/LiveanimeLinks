--Gouki The Master Ogre (Anime)
--scripted by Larry126
function c511600019.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfc),2)
	c:EnableReviveLimit()
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c511600019.atkcon)
	e2:SetValue(c511600019.atktg)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33833230,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c511600019.distg)
	e3:SetOperation(c511600019.disop)
	c:RegisterEffect(e3)
end
function c511600019.disfilter(c)
	return c:IsSetCard(0xfc) and c:IsAbleToHand()
end
function c511600019.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup():Filter(c511600019.disfilter,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil)
		and lg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,0,1-tp,LOCATION_MZONE)
end
function c511600019.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup():Filter(c511600019.disfilter,nil)
	if lg:GetCount()>0 then
		Duel.SendtoHand(lg,nil,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
			local dg=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,og:GetCount(),nil)
			if dg:GetCount()>0 then
				for tc in aux.Next(dg) do
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e3)
					end
				end
			end
		end
	end
end
--------------------------------------------------
function c511600019.atkcon(e)
	return e:GetHandler():GetAttackAnnouncedCount()==0
end
function c511600019.atktg(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	local ag,atk=g:GetMaxGroup(Card.GetAttack)
	return c:GetAttack()~=atk
end