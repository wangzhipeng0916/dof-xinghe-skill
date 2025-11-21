// ---------------------codeStart---------------------// 

// 作者：GCT60 QQ506807329   本腳本為NUT腳本開發範例，適用於1500種以上客戶端版本。如果發現任何問題（如NPC、NPK、動作、物件、UI等相關問題），歡迎隨時聯繫。
// 此為祭司BUFF"冷靜之查克拉"的附加腳本

/**
 * 添加函數名稱映射
 * @param {object} appendage - 附加物件
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("onStart", "onStart_appendage_priest_buff_chakraofcalmness");
    appendage.sq_AddFunctionName("onVaildTimeEnd", "onVaildTimeEnd_appendage_priest_buff_chakraofcalmness");
}

/**
 * 附加效果開始時的處理函數
 * @param {object} appendageObj - 附加物件實例
 */
function onStart_appendage_priest_buff_chakraofcalmness(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent(); 
    if(!parentObj) {
        appendageObj.setValid(false);
        return;
    }
    
    parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);
    if(parentObj)
        parentObj.setSkillCommandEnable(241, true);
} 

/**
 * 附加效果時間結束時的處理函數
 * @param {object} appendageObj - 附加物件實例
 */
function onVaildTimeEnd_appendage_priest_buff_chakraofcalmness(appendageObj)
{
    if(!appendageObj) return;
    
    local parentObj = appendageObj.getParent(); 
    if(!parentObj) {
        appendageObj.setValid(false);
        return;
    }
    
    parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);
    if(parentObj)
        parentObj.setSkillCommandEnable(241, false);
} 

// ---------------------codeEnd---------------------//