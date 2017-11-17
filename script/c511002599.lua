--Ｎｏ.３９ 希望皇ホープ
function c511002599.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84013237,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511002599.atkcost)
	e1:SetTarget(c511002599.atktg)
	e1:SetOperation(c511002599.atkop)
	c:RegisterEffect(e1,false,1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x48)))
	c:RegisterEffect(e2)
	aux.CallToken(84013237)
end
c511002599.xyz_number=39
function c511002599.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511002599.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(511002599)==0 and not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function c511002599.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then
		Duel.NegateAttack()
	else
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ATTACK_ANNOUNCE)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_MZONE)
			e1:SetOperation(c511002599.disop)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(511002599,RESET_EVENT+0x1ff0000,0,0)
		end
	end
end
function c511002599.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,511002599)
	Duel.NegateAttack()
end
