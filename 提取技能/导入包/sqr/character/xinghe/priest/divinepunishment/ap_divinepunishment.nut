// ---------------------codeStart---------------------// 

/**
 * @brief 神聖懲罰附加功能初始化
 * @param appendage 附加物對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_divinepunishment");
}

/**
 * @brief 神聖懲罰附加處理函數
 * @param appendageObj 附加物對象
 */
function proc_appendage_priest_divinepunishment(appendageObj)
{
    // 檢查附加物是否有效
    if (!appendageObj || !appendageObj.isValid()) {
        return;
    }
    
    // 獲取父對象（角色）
    local parentObj = appendageObj.getParent();
    
    // 檢查父對象狀態
    if (!parentObj || parentObj.getState() == STATE_DIE || parentObj.isDead()) {
        // 父對象無效或死亡時，設置附加物無效
        appendageObj.setValid(false);
        return;
    }
}

// ---------------------codeEnd---------------------//