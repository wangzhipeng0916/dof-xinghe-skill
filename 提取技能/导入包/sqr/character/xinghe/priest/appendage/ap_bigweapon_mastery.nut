// ---------------------codeStart---------------------// 

/**
 * 添加功能名稱到附加效果
 * @param {object} appendage - 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_BigWeaponMastery")
	appendage.sq_AddFunctionName("isDrawAppend", "isDrawAppend_appendage_BigWeaponMastery")
}

/**
 * 添加效果到附加效果
 * @param {object} appendage - 附加效果對象
 */
function sq_AddEffect(appendage)
{

}

/**
 * 處理大武器精通附加效果
 * @param {object} appendage - 附加效果對象
 */
function proc_appendage_BigWeaponMastery(appendage)
{

}

/**
 * 檢查是否繪製附加效果
 * @param {object} appendage - 附加效果對象
 * @return {boolean} 是否繪製附加效果
 */
function isDrawAppend_appendage_BigWeaponMastery(appendage)
{
	if(!appendage) {
		return false;
	}
	
	local parentObj = appendage.getParent();	
	
	return true;
}

// ---------------------codeEnd---------------------//