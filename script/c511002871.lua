--CNo.104 仮面魔踏士アンブラル (Anime)
--Number C104: Umbral Horror Masquerade (Anime)
--fixed by Larry126
function c511002871.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,4)
	c:EnableReviveLimit()
	--Rank Up Check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c511002871.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabelObject(e0)
	e1:SetOperation(c511002871.rankupregop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49456901,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c511002871.destg)
	e2:SetOperation(c511002871.desop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x48)))
	c:RegisterEffect(e3)
	--negate activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49456901,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c511002871.condition)
	e4:SetCost(c511002871.cost)
	e4:SetTarget(c511002871.target)
	e4:SetOperation(c511002871.operation)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4,false,1)
	aux.CallToken(49456901)
end
c511002871.xyz_number=104
c511002871.listed_names={2061963}
function c511002871.rumfilter(c)
	return c:IsCode(2061963) and not c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c511002871.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:IsExists(c511002871.rumfilter,1,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c511002871.rankupregop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and (rc:IsSetCard(0x95)
		or rc:IsCode(100000581) or rc:IsCode(111011002) or rc:IsCode(511000580)
		or rc:IsCode(511002068) or rc:IsCode(511002164) or rc:IsCode(93238626))
		and e:GetLabelObject():GetLabel()==1 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c511002871.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c511002871.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c511002871.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511002871.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511002871.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511002871.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c511002871.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c511002871.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and e:GetLabelObject():GetLabel()==1 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511002871.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c511002871.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,1,nil)
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
		end
	end
end