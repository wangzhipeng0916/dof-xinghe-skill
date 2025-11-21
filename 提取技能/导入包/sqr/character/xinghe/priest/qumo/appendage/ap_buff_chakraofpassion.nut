// ---------------------codeStart---------------------// 

// 作者：GCT60 QQ506807329   本NUT腳本為免費公開腳本，收費1500以上都是騙子，請注意。本腳本包含 NPC、NPK、地圖、act、obj、UI等相關內容，歡迎學習使用。

/**
 * 添加功能名稱到附加效果
 * @param {object} appendage - 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("onStart", "onStart_appendage_priest_buff_chakraofpassion");
    appendage.sq_AddFunctionName("onVaildTimeEnd", "onVaildTimeEnd_appendage_priest_buff_chakraofpassion");
}

/**
 * 附加效果開始時的回調函數
 * @param {object} appendageObj - 附加效果對象
 */
function onStart_appendage_priest_buff_chakraofpassion(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    if (!parentObj) {
        appendageObj.setValid(false);
        return;
    }
    
    parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);
    if (parentObj)
        parentObj.setSkillCommandEnable(241, true);
}

/**
 * 附加效果有效期結束時的回調函數
 * @param {object} appendageObj - 附加效果對象
 */
function onVaildTimeEnd_appendage_priest_buff_chakraofpassion(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    if (!parentObj) {
        appendageObj.setValid(false);
        return;
    }
    
    parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);
    if (parentObj)
        parentObj.setSkillCommandEnable(241, false);
}

// ---------------------codeEnd---------------------//