--Salamangreat Emerald Eagle
function c511009730.initial_effect(c)
	c:EnableReviveLimit()
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(511009730,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c511009730.atcost)
	e4:SetOperation(c511009730.atop)
	c:RegisterEffect(e4)
end
function c511009730.cfilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x578) 
end
function c511009730.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c511009730.cfilter,1,false,nil,nil)
	and e:GetHandler():GetFlagEffect(511009730)==0	end
	local g=Duel.SelectReleaseGroupCost(tp,c511009730.cfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end

function c511009730.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:GetFlagEffect(511009730)==0 then
			tc:RegisterFlagEffect(511009730,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BATTLE_START)
			e1:SetOwnerPlayer(tp)
			e1:SetCondition(c511009730.descon)
			e1:SetOperation(c511009730.desop)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)NT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
	end
function c511009730.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tp==e:GetOwnerPlayer() and tc and tc:IsControler(1-tp)
end
function c511009730.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	local atk=0
	if tc:IsFaceup() then atk=tc:GetAttack() end
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end

