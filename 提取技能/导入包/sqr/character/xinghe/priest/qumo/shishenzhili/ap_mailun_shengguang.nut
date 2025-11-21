// ---------------------codeStart---------------------// 

/**
 * 添加附體功能名稱
 * @param {object} appendage - 附體對象
 */
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_mailun_shengguang")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_mailun_shengguang")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_mailun_shengguang")
}

/**
 * 添加附體效果（空函數）
 * @param {object} appendage - 附體對象
 */
function sq_AddEffect(appendage)
{
}

/**
 * 處理附體邏輯
 * @param {object} appendage - 附體對象
 */
function proc_appendage_mailun_shengguang(appendage)
{
	if(!appendage) return;
	local parentObj = appendage.getParent();
	local isAppendApd = CNSquirrelAppendage.sq_IsAppendAppendage(parentObj, "character/xinghe/priest/qumo/shishenzhili/ap_mailun_lieyan.nut");
	if(isAppendApd)
	{
		appendage.setValid(false);
		return;
	}
}

/**
 * 附體開始時執行
 * @param {object} appendage - 附體對象
 */
function onStart_appendage_mailun_shengguang(appendage)
{
	if(!appendage) return;
	appendage.sq_DeleteEffectFront();
	appendage.sq_AddEffectFront("character/xinghe/priest/qumo/shishenzhili/light/loopyellow_yellow_f.ani");
	local parentObj = appendage.getParent();
}

/**
 * 附體結束時執行
 * @param {object} appendage - 附體對象
 */
function onEnd_appendage_mailun_shengguang(appendage)
{
	if(!appendage) return;
	local parentObj = appendage.getParent();
}

// ---------------------codeEnd---------------------//