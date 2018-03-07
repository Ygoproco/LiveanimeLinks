--Morph King Stygi-Cell
function c511000763.initial_effect(c)
	--change lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000763,0))
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511000763.lvcon)
	e1:SetTarget(c511000763.lvtg)
	e1:SetOperation(c511000763.lvop)
	c:RegisterEffect(e1)
end

function c511000763.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c511000763.lvfilter(c,lv)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()~=lv
end
function c511000763.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511000763.lvfilter(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(c511000763.lvfilter,tp,LOCATION_MZONE,0,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511000763.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,lv)
end
function c511000763.lvop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetHandler():GetLevel()
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		if lv~=tc:GetLevel() then
			if lv>tc:GetLevel() then
				local rec=(lv-tc:GetLevel())*200
				Duel.Recover(tp,rec,REASON_EFFECT)
			else
				local rec=(tc:GetLevel()-lv)*200
				Duel.Recover(tp,rec,REASON_EFFECT)
			end
		end
	end
end
