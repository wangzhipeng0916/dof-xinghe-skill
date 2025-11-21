// ---------------------codeStart---------------------// 

/**
 * 附加功能名稱設置
 * @param {object} appendage - 附加物件
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_devilfist") 
}

/**
 * 處理祭司惡魔之拳附加效果
 * @param {object} appendageObj - 附加物件實例
 */
function proc_appendage_priest_devilfist(appendageObj)
{
    if(!appendageObj) return;
    
    local parentObj = appendageObj.getParent(); 
    local sourceObj = appendageObj.getSource(); 
    
    if(!parentObj || !sourceObj || sourceObj.getState() != 135)
    {
        appendageObj.setValid(false);
        return;
    }
} 

// ---------------------codeEnd---------------------//