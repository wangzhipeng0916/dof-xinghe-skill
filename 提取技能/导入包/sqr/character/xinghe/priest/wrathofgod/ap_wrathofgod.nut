// ---------------------codeStart---------------------// 

// 此代碼為祭司技能"神之怒"的附加效果處理
// 創建時間：60 QQ506807329  功能說明：此附加效果用於處理技能釋放後的移動軌跡和結束處理，包含坐標插值計算和移動位置調整等操作

/**
 * 添加功能名稱到附加效果
 * @param {object} appendage - 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_wrathofgod");
    appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_priest_wrathofgod");
}

/**
 * 處理神之怒附加效果的主要邏輯
 * @param {object} appendageObj - 附加效果對象
 */
function proc_appendage_priest_wrathofgod(appendageObj)
{
    if(!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    local sourceObj = appendageObj.getSource();
    
    if(!parentObj || !sourceObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    if(appendageObj.getVar().size_vector() > 0)
    {
        local currentTime = appendageObj.getTimer().Get();
        local totalDuration = 500;
        local varObj = appendageObj.getVar();
        local startX = varObj.get_vector(0);
        local startY = varObj.get_vector(1);
        local startZ = varObj.get_vector(2);
        local endX = varObj.get_vector(3);
        local endY = varObj.get_vector(4);
        
        // 計算當前X坐標
        local currentX = sq_GetUniformVelocity(startX, endX, currentTime, totalDuration);
        // 計算當前Y坐標
        local currentY = sq_GetUniformVelocity(startY, endY, currentTime, totalDuration);
        // 計算當前Z坐標（包含正弦波動效果）
        local currentZ = (currentTime < totalDuration / 2)
            ? startZ + 100 * sq_SinTable(sq_GetUniformVelocity(0, 90, currentTime, totalDuration))
            : (startZ + 100) * sq_SinTable(sq_GetUniformVelocity(90, 180, currentTime, totalDuration));
        
        // 設置父對象的當前位置
        parentObj.setCurrentPos(currentX, currentY, currentZ.tointeger());
        
        // 如果超過持續時間，設置附加效果無效
        if(currentTime >= totalDuration)
            appendageObj.setValid(false);
    }
}

/**
 * 神之怒附加效果結束時的處理函數
 * @param {object} appendageObj - 附加效果對象
 */
function onEnd_appendage_priest_wrathofgod(appendageObj)
{
    if(!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    
    if(!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    // 將父對象移動到最近的可移動位置
    sq_SimpleMoveToNearMovablePos(parentObj, 200);
}

// ---------------------codeEnd---------------------//