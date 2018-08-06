--パワー・ロード
--coded by Lyris
function c511007031.initial_effect(c)
	aux.AddEquipProcedure(c,0,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE))
	--The equipped monster gains 400 ATK for each attack your other Machine monsters can make.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c511007031.atkval)
	c:RegisterEffect(e2)
	--All your monsters cannot attack, except the equipped monster.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c511007031.ftarget)
	c:RegisterEffect(e3)
end
function c511007031.atkfilter(c)
	return c:IsRace(RACE_MACHINE) and (c:IsAttackPos() or (c:IsHasEffect(EFFECT_DEFENSE_ATTACK) and not c:IsDisabled()))
end
function c511007031.atkval(e,c)
	local g=Duel.GetMatchingGroup(c511007031.atkfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,e:GetHandler():GetEquipTarget())
	local atkct,ev=g:GetCount()
	g:ForEach(function(tc)
		local atkctad,ex,ev=0,{tc:GetCardEffect(EFFECT_EXTRA_ATTACK)}
		for i=1,2 do
			for _,ef in ipairs(ex) do
				if ef~=nil then
					ev=ef:GetValue()
					if type(ev)=='function' then ev=ef:GetValue()(ef,tc) end
					atkctad=math.max(atkctad,ev-tc:GetAttackedCount())
					if atkctad<0 then atkctad=0 end
				end
			end
			ex={tc:GetCardEffect(EFFECT_EXTRA_ATTACK_MONSTER)}
		end
		if not c:IsAttackable() then atkctad=-1 end
		atkct=atkct+atkctad
	end)
	return 400*atkct
end
function c511007031.ftarget(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
