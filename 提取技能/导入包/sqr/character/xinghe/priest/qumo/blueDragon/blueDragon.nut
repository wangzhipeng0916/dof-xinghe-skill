// ---------------------codeStart---------------------// 

/**
 * 蒼龍逐日技能狀態設置函數
 * @param {對象} obj - 技能施放者對象
 * @param {整數} state - 當前狀態值
 * @param {參數} param1 - 狀態參數1
 * @param {參數} param2 - 狀態參數2
 */
function onSetState_BlueDragon(obj, state, param1, param2)
{
    if (!obj || sq_GetSkillLevel(obj, 169) < 1) return;
    obj.sq_SetStaticSpeedInfo(SPEED_TYPE_MOVE_SPEED, SPEED_TYPE_MOVE_SPEED, 1000, 1000, 1.0, 10.0);
}


// ---------------------codeEnd---------------------//