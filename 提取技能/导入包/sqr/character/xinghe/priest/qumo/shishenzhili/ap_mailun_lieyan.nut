// ---------------------codeStart---------------------// 

/**
 * 添加函數名稱到附加組件
 * @param {object} appendage - 附加組件對象
 */
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_mailun_lieyan");
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_mailun_lieyan");
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_mailun_lieyan");
}

/**
 * 添加效果到附加組件（目前為空實現）
 * @param {object} appendage - 附加組件對象
 */
function sq_AddEffect(appendage)
{
}

/**
 * 處理附加組件邏輯
 * @param {object} appendage - 附加組件對象
 */
function proc_appendage_mailun_lieyan(appendage)
{
	if(!appendage) return;
	local parentObj = appendage.getParent();
	local isAppendApd = CNSquirrelAppendage.sq_IsAppendAppendage(parentObj, "character/xinghe/priest/qumo/shishenzhili/ap_mailun_shengguang.nut");
	if(isAppendApd)
	{
		appendage.setValid(false);
		return;
	}
}

/**
 * 附加組件開始時執行
 * @param {object} appendage - 附加組件對象
 */
function onStart_appendage_mailun_lieyan(appendage)
{
	if(!appendage) return;
	appendage.sq_DeleteEffectFront(); // 刪除前效果
	appendage.sq_AddEffectFront("character/xinghe/priest/qumo/shishenzhili/fire/loopred_red_f.ani"); // 添加前效果
	local parentObj = appendage.getParent();
}

/**
 * 附加組件結束時執行
 * @param {object} appendage - 附加組件對象
 */
function onEnd_appendage_mailun_lieyan(appendage)
{
	if(!appendage) return;
	local parentObj = appendage.getParent();
}

// ---------------------codeEnd---------------------//