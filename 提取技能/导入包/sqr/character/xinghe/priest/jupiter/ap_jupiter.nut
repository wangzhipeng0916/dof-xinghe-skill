// ---------------------codeStart---------------------// 

// 此代碼為祭司技能"Jupiter"的附加效果處理
// 作者：GCT60 QQ506807329
// 功能：包含技能開始、處理和結束三個階段的函數

/**
 * 註冊附加效果的回調函數
 * @param {object} appendage - 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("onStart", "onStart_appendage_priest_jupiter") 
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_jupiter") 
    appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_priest_jupiter") 
}

/**
 * 附加效果開始時執行的函數
 * @param {object} appendageObj - 附加效果對象
 */
function onStart_appendage_priest_jupiter(appendageObj)
{
    if(!appendageObj) return;
} 

/**
 * 附加效果處理過程中的函數
 * @param {object} appendageObj - 附加效果對象
 */
function proc_appendage_priest_jupiter(appendageObj)
{
    if(!appendageObj) return;
    
    local parentObj = appendageObj.getParent(); 
    if(!parentObj)
    {
        appendageObj.setValid(false); 
        return;
    }
} 

/**
 * 附加效果結束時執行的函數
 * @param {object} appendageObj - 附加效果對象
 */
function onEnd_appendage_priest_jupiter(appendageObj)
{
    if(!appendageObj) return;
} 

// ---------------------codeEnd---------------------//