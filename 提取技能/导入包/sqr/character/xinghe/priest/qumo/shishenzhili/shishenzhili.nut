// ---------------------codeStart---------------------// 

/**
 * 牧師技能使用後處理函數
 * @param {對象} obj - 技能使用者對象
 * @param {整數} skillIndex - 技能索引
 * @param {整數} consumeMp - 消耗魔法值
 * @param {整數} consumeItem - 消耗物品
 * @param {浮點數} oldSkillMpRate - 舊技能魔法消耗比率
 * @return {布林值} 處理結果
 */
function useSkill_after_Priest(obj, skillIndex, consumeMp, consumeItem, oldSkillMpRate)
{
	if(!obj) return false;
	
	local skillLevel = sq_GetSkillLevel(obj, SKILL_CHAKRAOFGOD);
	if(skillLevel > 0)
	{
		// 技能索引47:烈焰
		// 技能索引48:聖光
		if(skillIndex == 47)
		{
			local lieYanLevel = sq_GetSkillLevel(obj, 47);
			local duration = sq_GetLevelData(obj, 47, 0, lieYanLevel);
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, 47, false, "character/xinghe/priest/qumo/shishenzhili/ap_mailun_lieyan.nut", false);
			appendage.sq_SetValidTime(duration);
			CNSquirrelAppendage.sq_Append(appendage, obj, obj);
		}
		else if(skillIndex == 48)
		{
			local shengGuangLevel = sq_GetSkillLevel(obj, 48);
			local duration = sq_GetLevelData(obj, 48, 0, shengGuangLevel);
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, 48, false, "character/xinghe/priest/qumo/shishenzhili/ap_mailun_shengguang.nut", false);
			appendage.sq_SetValidTime(duration);
			CNSquirrelAppendage.sq_Append(appendage, obj, obj);
		}
	}
	return true;
}

// ---------------------codeEnd---------------------//