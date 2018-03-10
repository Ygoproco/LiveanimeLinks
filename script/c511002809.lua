--ルーンアイズ・ペンデュラム・ドラゴン
function c511002809.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10f2),aux.FilterBoolFunctionEx(Card.IsRace,RACE_SPELLCASTER))
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511002809.condition)
	e1:SetOperation(c511002809.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c511002809.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
c511002809.material_setcode={0xf2,0x10f2}
function c511002809.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c511002809.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=e:GetLabel()
	if bit.band(flag,0x7)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		if flag==0x4 then
			e1:SetValue(4)
		elseif flag==0x2 then
			e1:SetDescription(aux.Stringid(1516510,1))
			e1:SetValue(2)
		else
			e1:SetDescription(aux.Stringid(1516510,0))
			e1:SetValue(1)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c511002809.matfilter(c,sc)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(sc:GetControler())
		and c:IsRace(RACE_SPELLCASTER,c,SUMMON_TYPE_FUSION) and c:IsLevelBelow(2147483647)
end
function c511002809.valcheck(e,c)
	local mg=c:GetMaterial():Filter(c511002809.matfilter,nil,c)
	local flag=0
	if mg:GetCount()>0 then
		local mc=mg:GetFirst():GetOriginalLevel()
		if lv>=7 then
			flag=0x4
		elseif lv>=5 then
			flag=0x2
		elseif lv>=0 then
			flag=0x1
		end
	end
	e:GetLabelObject():SetLabel(flag)
end