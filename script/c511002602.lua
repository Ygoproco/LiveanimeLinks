--BF－極光のアウロラ
function c511002602.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c511002602.spcon)
	e1:SetOperation(c511002602.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4068622,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c511002602.target)
	e2:SetOperation(c511002602.operation)
	c:RegisterEffect(e2)
	--special summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
end
function c511002602.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c511002602.spfilter2(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c511002602.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c511002602.chk,1,nil,sg,Group.CreateGroup(),c511002602.spfilter1,c511002602.spfilter2)
end
function c511002602.chk(c,sg,g,f,...)
	if not f(c) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c511002602.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c511002602.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c511002602.spfilter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c511002602.spfilter2,tp,LOCATION_MZONE,0,nil)
	local g=g1:Clone()
	g:Merge(g2)
	return ft>-2 and g1:GetCount()>0 and g2:GetCount()>0 and aux.SelectUnselectGroup(g,e,tp,2,2,c511002602.rescon,0)
end
function c511002602.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c511002602.spfilter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c511002602.spfilter2,tp,LOCATION_MZONE,0,nil)
	g1:Merge(g2)
	local sg=aux.SelectUnselectGroup(g1,e,tp,2,2,c511002602.rescon,1,tp,HINTMSG_REMOVE)
	local lv=sg:GetSum(Card.GetLevel)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c511002602.filter(c,lv)
	return c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove() and c:IsLevel(lv)
end
function c511002602.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511002602.filter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_EXTRA)
end
function c511002602.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c511002602.filter,tp,LOCATION_EXTRA,0,1,1,nil,c:GetLevel()):GetFirst()
	if tc and c:IsFaceup() and c:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		local code=tc:GetOriginalCode()
		local ba=tc:GetBaseAttack()
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN, 1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(ba)
		c:RegisterEffect(e2)
	end
end
