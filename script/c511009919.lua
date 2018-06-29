--転生炎獣の聖域
--Salamangreat Sanctuary
function c511009919.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511009919,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c511009919.linkcon)
	e2:SetTarget(c511009919.linktg)
	e2:SetOperation(c511009919.linkop)
	e2:SetValue(SUMMON_TYPE_LINK)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c511009919.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99427357,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,101006051)
	e4:SetCondition(c511009919.condition)
	e4:SetCost(c511009919.cost)
	e4:SetTarget(c511009919.target)
	e4:SetOperation(c511009919.operation)
	c:RegisterEffect(e4)
end
function c511009919.matfilter(c,lc,tp)
	return c:IsFaceup() and c:IsCode(lc:GetCode()) and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0
		and c:IsType(TYPE_LINK) and c:IsCanBeLinkMaterial(lc,tp) and c:IsSetCard(0x220)
end
function c511009919.linkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mustg=aux.GetMustBeMaterialGroup(tp,nil,tp,c,nil,REASON_LINK)
	if mustg:IsExists(aux.NOT(Card.IsCanBeLinkMaterial),1,nil,c,tp) then return false end
	local mg=Duel.GetMatchingGroup(c511009919.matfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	return mg:GetCount()>0 and Duel.GetFlagEffect(tp,1010060510)==0
		and Duel.IsPlayerAffectedByEffect(tp,511009919) and c:IsSetCard(0x220) and c:IsType(TYPE_LINK)
		and (mustg:GetCount()==0 or (mustg:GetCount()==1 and mg:Includes(mustg)))
end
function c511009919.linktg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Group.CreateGroup()
	local mustg=aux.GetMustBeMaterialGroup(tp,nil,tp,c,nil,REASON_LINK)
	g:Merge(mustg)
	while g:GetCount()<1 do
		local tc=nil
		if g:GetCount()==0 then
			tc=Group.SelectUnselect(Duel.GetMatchingGroup(c511009919.matfilter,tp,LOCATION_MZONE,0,nil,c,tp),g,tp,true,true,1,1)
		end
		if not tc then return false end
		if not g:IsContains(tc) then
			g:AddCard(tc)
		else
			g:RemoveCard(tc)
		end
	end
	if g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		Duel.RegisterFlagEffect(tp,1010060510,RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function c511009919.linkop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
end
function c511009919.mattg(e,c)
	return c:IsSetCard(0x220) and c:IsType(TYPE_LINK)
end
function c511009919.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0 and (Duel.GetAttacker():IsSetCard(0x220) or Duel.GetAttackTarget():IsSetCard(0x220))
end
function c511009919.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c511009919.filter(c)
	return aux.nzatk(c) and c:IsType(TYPE_LINK) and c:IsSetCard(0x220)
end
function c511009919.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511009919.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009919.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectTarget(tp,c511009919.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tg:GetFirst(),1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tg:GetFirst():GetAttack())
end
function c511009919.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.nzatk(tc) and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if not tc:IsImmuneToEffect(e1) then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end