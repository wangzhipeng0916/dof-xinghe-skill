// ---------------------codeStart---------------------// 

/**
 * @brief 為附加效果添加函數名稱映射
 * @param appendage 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("drawAppend", "drawAppend_appendage_priest_doomcrush_atk")
}

/**
 * @brief 繪製聖職者毀滅重擊攻擊效果的附加組件
 * @param appendageInstance 附加效果實例
 * @param isScreen 是否為屏幕坐標系
 * @param posX 繪製位置的X坐標
 * @param posY 繪製位置的Y坐標
 * @param direction 方向參數
 */
function drawAppend_appendage_priest_doomcrush_atk(appendageInstance, isScreen, posX, posY, direction)
{
    if(!appendageInstance) return;
    
    local parentObj = appendageInstance.getParent(); 
    local sourceObj = appendageInstance.getSource(); 
    
    if(!parentObj || !sourceObj)
    {
        appendageInstance.setValid(false);
        return;
    }
    
    if(!isScreen) return; 
    
    local animation = appendageInstance.getVar().GetAnimationMap("doomcrush_f_01attack", "character/priest/effect/animation/doomcrush/doomcrush_f_01attack.ani");
    sq_AnimationProc(animation);
    sq_drawCurrentFrame(animation, posX, posY - 15, direction);
} 

// ---------------------codeEnd---------------------//