// ---------------------codeStart---------------------// 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 作者：GCT60 QQ506807329   聲明：NUT腳本使用規定 禁止修改 1500點券購買1000點券可獲得永久使用權，如果違反規定將永久停止 NPC NPK 地圖 act obj  UI腳本功能，並且無法再次使用。
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * 添加功能名稱到附屬物件
 * @param {object} appendage - 附屬物件
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_thebest7hit");
    appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_priest_thebest7hit");
}

/**
 * 處理附屬物件的邏輯
 * @param {object} appendageObj - 附屬物件
 */
function proc_appendage_priest_thebest7hit(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    local sourceObj = appendageObj.getSource();
    
    if (!parentObj || !sourceObj || sourceObj.getState() != 239 || sq_GetCNRDObjectToSQRCharacter(sourceObj).getSkillSubState() == 6)
    {
        appendageObj.setValid(false);
        return;
    }
}

/**
 * 附屬物件結束時的處理
 * @param {object} appendageObj - 附屬物件
 */
function onEnd_appendage_priest_thebest7hit(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    
    if (!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    sq_SimpleMoveToNearMovablePos(parentObj, 200);
}

// ---------------------codeEnd---------------------//