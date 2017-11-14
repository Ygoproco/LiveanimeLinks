--シャイニング・リバース
function c511001019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001019.target)
	e1:SetOperation(c511001019.activate)
	c:RegisterEffect(e1)
end
function c511001019.filter(c,e)
	local tpe=c.synchro_type
	if not tpe then return false end
	local t=c.synchro_parameters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(aux.SynCondition(table.unpack(t)))
	e1:SetTarget(aux.SynTarget(table.unpack(t)))
	e1:SetOperation(aux.SynOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local res=c:IsSynchroSummonable(nil)
	e1:Reset()
	return res
end
function c511001019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511001019.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(c511001019.filter,tp,LOCATION_GRAVE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511001019.filter,tp,LOCATION_GRAVE,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511001019.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c511001019.filter(tc,e) then
		local tpe=c.synchro_type
		local t=c.synchro_parameters
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCondition(aux.SynCondition(table.unpack(t)))
		e1:SetTarget(aux.SynTarget(table.unpack(t)))
		e1:SetOperation(aux.SynOperation)
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SynchroSummon(tp,tc,nil)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e3)
	end
end
