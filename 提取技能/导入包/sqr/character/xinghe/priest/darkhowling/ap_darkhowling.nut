// ---------------------codeStart---------------------// 

// 附加效果：暗黑咆哮（祭司技能）
// 作者：GCT60 QQ506807329
// 說明：此腳本處理祭司暗黑咆哮技能的附加效果，包含動畫顯示、傷害處理等邏輯

/**
 * 添加函數名稱映射
 * @param {object} appendage - 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("onStart", "onStart_appendage_priest_darkhowling");
    appendage.sq_AddFunctionName("onDamageParent", "onDamageParent_appendage_priest_darkhowling");
    appendage.sq_AddFunctionName("drawAppend", "drawAppend_appendage_priest_darkhowling");
}

/**
 * 附加效果開始時的回調函數
 * @param {object} appendageObj - 附加效果對象
 */
function onStart_appendage_priest_darkhowling(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    local sourceObj = sq_GetCNRDObjectToSQRCharacter(appendageObj.getSource());
    
    if (!parentObj || !sourceObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    appendageObj.getVar().clear_vector();
    
    // 根據目標類型設置不同的傷害值
    if (sq_IsBoss(parentObj))
        appendageObj.getVar().push_vector(sourceObj.sq_GetLevelData(136, 9, sq_GetSkillLevel(sourceObj, 136)));
    else if (sq_IsNamed(parentObj))
        appendageObj.getVar().push_vector(sourceObj.sq_GetLevelData(136, 8, sq_GetSkillLevel(sourceObj, 136)));
    else
        appendageObj.getVar().push_vector(sourceObj.sq_GetLevelData(136, 7, sq_GetSkillLevel(sourceObj, 136)));
    
    // 初始化狀態變量
    appendageObj.getVar("state").clear_vector();
    appendageObj.getVar("state").push_vector(1);
    
    // 初始化布爾標誌
    appendageObj.getVar().setBool(0, false);
    appendageObj.getVar().setBool(1, false);
    appendageObj.getVar().setBool(2, false);
}

/**
 * 繪製附加效果
 * @param {object} appendageObj - 附加效果對象
 * @param {object} effectLayer - 效果圖層
 * @param {number} posX - X座標
 * @param {number} posY - Y座標
 * @param {number} posZ - Z座標
 */
function drawAppend_appendage_priest_darkhowling(appendageObj, effectLayer, posX, posY, posZ)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    if (!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    if (!effectLayer) return;
    
    local animationObj = null;
    local currentState = appendageObj.getVar("state").get_vector(0);
    
    switch (currentState)
    {
        case 1: // 命中狀態
            animationObj = appendageObj.getVar().GetAnimationMap("hit_debuff", "character/priest/effect/animation/darkhowling/hit_debuff.ani");
            if (sq_IsEnd(animationObj))
            {
                sq_Rewind(animationObj);
                appendageObj.getVar("state").clear_vector();
                appendageObj.getVar("state").push_vector(2);
                return;
            }
            else if (appendageObj.getVar().getBool(0) == false)
            {
                if (sq_GetAnimationFrameIndex(animationObj) >= 4)
                {
                    local sourceObj = appendageObj.getSource();
                    if (!sourceObj)
                    {
                        appendageObj.setValid(false);
                        return;
                    }
                    
                    appendageObj.getVar().setBool(0, true);
                    
                    if (sq_IsMyControlObject(sourceObj))
                    {
                        sq_BinaryStartWrite();
                        sq_BinaryWriteDword(136);
                        sq_BinaryWriteDword(2);
                        sq_BinaryWriteDword(appendageObj.getVar().get_vector(0));
                        sq_SendCreatePassiveObjectPacketPos(sourceObj, 24374, 0, parentObj.getXPos(), parentObj.getYPos(), parentObj.getZPos() + sq_GetObjectHeight(parentObj) + 20);
                    }
                }
            }
            break;
            
        case 2: // 循環狀態
            animationObj = appendageObj.getVar().GetAnimationMap("loop_debuff", "character/priest/effect/animation/darkhowling/loop_debuff.ani");
            local currentTime = appendageObj.getTimer().Get();
            local endTime = appendageObj.getVar("endTime").get_vector(0);
            
            if (currentTime >= endTime)
            {
                appendageObj.getVar("state").clear_vector();
                appendageObj.getVar("state").push_vector(3);
                return;
            }
            
            if (appendageObj.getVar().getBool(1) == false)
            {
                if (currentTime > endTime / 2)
                {
                    appendageObj.getVar().setBool(0, false);
                    appendageObj.getVar().setBool(1, true);
                }
            }
            break;
            
        case 3: // 消失狀態
            animationObj = appendageObj.getVar().GetAnimationMap("disappear_debuff", "character/priest/effect/animation/darkhowling/disappear_debuff.ani");
            if (sq_IsEnd(animationObj))
            {
                appendageObj.setValid(false);
                return;
            }
            break;
    }
    
    if (animationObj != null)
    {
        // 根據父對象方向設置動畫方向
        if (parentObj.getDirection() == ENUM_DIRECTION_RIGHT)
            animationObj.setImageRateFromOriginal(-1.0, 1.0);
        else
            animationObj.setImageRateFromOriginal(1.0, 1.0);
            
        sq_AnimationProc(animationObj);
        sq_drawCurrentFrame(animationObj, posX, posY - sq_GetObjectHeight(parentObj) - 20, posZ);
    }
}

/**
 * 父對象受到傷害時的回調函數
 * @param {object} appendageObj - 附加效果對象
 * @param {object} attacker - 攻擊者對象
 * @param {object} damageInfo - 傷害信息
 * @param {boolean} isCritical - 是否為暴擊
 */
function onDamageParent_appendage_priest_darkhowling(appendageObj, attacker, damageInfo, isCritical)
{
    if (!appendageObj) return;
    
    if (isCritical || appendageObj.getVar("state").get_vector(0) != 2 || appendageObj.getVar().getBool(1) == false) return;
    
    local parentObj = appendageObj.getParent();
    if (!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    if (appendageObj.getVar().getBool(2) == false)
    {
        appendageObj.getVar().setBool(2, true);
        appendageObj.getVar("state").clear_vector();
        appendageObj.getVar("state").push_vector(1);
    }
}

// ---------------------codeEnd---------------------//