// ---------------------codeStart---------------------// 

// 這是一個奇蹟分裂者的附加效果代碼
// 作者：GCT60 QQ506807329
// 功能：處理牧師奇蹟分裂者技能的附加效果，包含移動效果和結束處理

/**
 * 添加函數名稱映射
 * @param {對象} appendage - 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_miraclespliter");
    appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_priest_miracespliter");
}

/**
 * 處理奇蹟分裂者附加效果
 * @param {對象} appendageObj - 附加效果對象
 */
function proc_appendage_priest_miraclespliter(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    local sourceObj = appendageObj.getSource();
    
    // 檢查父對象、源對象和技能狀態是否有效
    if (!parentObj || !sourceObj || sourceObj.getState() != 247 || sq_GetCNRDObjectToSQRCharacter(sourceObj).getSkillSubState() == 1)
    {
        appendageObj.setValid(false);
        return;
    }
    
    // 初始化變量向量
    if (appendageObj.getVar().size_vector() <= 0)
    {
        appendageObj.getVar().clear_vector();
        appendageObj.getVar().push_vector(parentObj.getXPos());
        appendageObj.getVar().push_vector(parentObj.getYPos());
        appendageObj.getVar().push_vector(parentObj.getZPos());
        return;
    }
    else
    {
        local currentTime = appendageObj.getTimer().Get();
        local totalTime = 100;
        local positionVar = appendageObj.getVar();
        
        // 計算目標位置
        local targetX = sq_GetDistancePos(sourceObj.getXPos(), sq_GetDirection(sourceObj), 120);
        local targetY = sourceObj.getYPos() + 1;
        local targetZ = sourceObj.getZPos();
        
        // 計算平滑移動位置
        local newX = sq_GetUniformVelocity(positionVar.get_vector(0), targetX, currentTime, totalTime);
        local newY = sq_GetUniformVelocity(positionVar.get_vector(1), targetY, currentTime, totalTime);
        local newZ = sq_GetUniformVelocity(positionVar.get_vector(2), targetZ, currentTime, totalTime);
        
        // 設置新的位置
        parentObj.setCurrentPos(newX, newY, newZ);
    }
}

/**
 * 結束奇蹟分裂者附加效果
 * @param {對象} appendageObj - 附加效果對象
 */
function onEnd_appendage_priest_miraclespliter(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    
    if (!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    // 將父對象移動到最近的可移動位置
    sq_SimpleMoveToNearMovablePos(parentObj, 200);
}

// ---------------------codeEnd---------------------//