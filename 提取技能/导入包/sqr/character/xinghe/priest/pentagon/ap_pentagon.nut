
/**
 * 添加函數名稱
 * @param {對象} appendage - 附加對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_pentagon");
    appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_priest_pentagon");
}

/**
 * 處理五芒星附加效果
 * @param {對象} appendageObj - 附加對象
 */
function proc_appendage_priest_pentagon(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    local sourceObj = appendageObj.getSource();
    
    if (!parentObj || !sourceObj || sourceObj.getVar("end").getBool(0) == true)
    {
        appendageObj.setValid(false);
        return;
    }
    
    if (sourceObj.getVar("state").get_vector(0) < 12 || appendageObj.getVar("isMove").getBool(0) == true)
    {
        if (appendageObj.getVar().size_vector() <= 0)
        {
            appendageObj.getVar().clear_vector();
            appendageObj.getVar().push_vector(sq_GetXPos(parentObj));
            appendageObj.getVar().push_vector(sq_GetYPos(parentObj));
            return;
        }
        else
        {
            sq_setCurrentAxisPos(parentObj, 0, appendageObj.getVar().get_vector(0));
            sq_setCurrentAxisPos(parentObj, 1, appendageObj.getVar().get_vector(1));
        }
    }
}

/**
 * 五芒星附加效果結束處理
 * @param {對象} appendageObj - 附加對象
 */
function onEnd_appendage_priest_pentagon(appendageObj)
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

// ---------------------codeEnd---------------------
