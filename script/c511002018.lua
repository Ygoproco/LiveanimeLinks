--デストーイ・シザー・ベアー
function c511002018.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,30068120,3841833)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95100080,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c511002018.eqcon)
	e1:SetTarget(c511002018.eqtg)
	e1:SetOperation(c511002018.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,function(ec,_,tp) return ec:GetOriginalType()&TYPE_MONSTER>0 end,c511002018.equipop,e1)
	--aux.AddEREquipLimit(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),c511002018.equipop,e1)
end
c511002018.material_setcode={0xc3,0xa9}
function c511002018.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function c511002018.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c511002018.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc) then return end
	local atk=tc:GetTextAttack()
	if atk>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function c511002018.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		c511002018.equipop(c,e,tp,tc)
	end
end
