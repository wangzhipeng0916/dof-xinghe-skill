// ---------------------codeStart---------------------// 

/**
 * 添加功能名稱
 * @param {object} appendage - 附加狀態對象
 */
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_zhengyichengjie")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_zhengyichengjie")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_zhengyichengjie")
}

/**
 * 添加效果（空函數）
 * @param {object} appendage - 附加狀態對象
 */
function sq_AddEffect(appendage)
{
}

/**
 * 正義懲戒附加狀態處理函數
 * @param {object} appendage - 附加狀態對象
 */
function proc_appendage_zhengyichengjie(appendage)
{
	if(!appendage) return;
	local parentObj = appendage.getParent();
}

/**
 * 正義懲戒附加狀態開始函數
 * @param {object} appendage - 附加狀態對象
 */
function onStart_appendage_zhengyichengjie(appendage)
{
	if(!appendage) return;
	local parentObj = appendage.getParent();
	local sqrCharacter = sq_GetCNRDObjectToSQRCharacter(parentObj);
	local skillLevel = sqrCharacter.sq_GetSkillLevel(SKILL_ZHENG_YI_QIAN_NENG);
	local stuckValue = sq_GetLevelData(sqrCharacter, SKILL_ZHENG_YI_QIAN_NENG, 0, skillLevel);
	local changeAppendage = appendage.sq_getChangeStatus("zhengyichengjie");
	if(!changeAppendage)
	{
		changeAppendage = appendage.sq_AddChangeStatus("zhengyichengjie", parentObj, parentObj, 0, CHANGE_STATUS_TYPE_STUCK, false, -stuckValue);
	}
	if(changeAppendage)
	{
		changeAppendage.clearParameter();
		changeAppendage.addParameter(CHANGE_STATUS_TYPE_STUCK, false, -stuckValue.tofloat());
	}
}

/**
 * 正義懲戒附加狀態結束函數
 * @param {object} appendage - 附加狀態對象
 */
function onEnd_appendage_zhengyichengjie(appendage)
{
	if(!appendage) return;
	local parentObj = appendage.getParent();
	if(!parentObj) 
	{
		appendage.setValid(false);
		return;
	}
}

// ---------------------codeEnd---------------------//