;说明
;  用于捉弄的小脚本，使桌面图标无法点击
;    1.切换到桌面
;    2.桌面截图
;    3.隐藏桌面图标
;    4.设置桌面壁纸
;    5.切换回工作场景
;使用方法
;  运行脚本，按键F1
;解决方法
;  鼠标右键-->查看-->显示桌面图标


;========================= 环境配置 =========================
#Include lib\Gdip_All.ahk
#SingleInstance, Force


F1::
    Send #d   ;显示桌面
    Sleep 1000
    WinGetClass, className, A
    if className not in Shell_TrayWnd,Progman,WorkerW
    {
        MsgBox, 检查代码，未成功切换到系统桌面
        return
    }
    
    imgPath := A_Temp "\" A_ScriptName ".png"
    createPic(imgPath) ;截图
    hideDeskIcon() ;隐藏桌面图标
    setWallPaper(imgPath) ;设置壁纸
    Sleep 1500
    Send #d   ;退回原来工作场景
ExitApp







;========================= functions =========================
createPic(imgPath)
{
	pToken := Gdip_Startup() ; Start gdi+
        ; pBitmapAlpha := Gdip_CreateBitmapFromFile(PicPath)
        pBitmapAlpha := Gdip_BitmapFromScreen(0, "")
		;pBitmapAlpha := Gdip_BitmapFromScreen(x "|" y "|" width "|" height)
        ;pBitmapAlpha := Gdip_CreateBitmapFromClipboard()
        imgWidth := Gdip_GetImageWidth(pBitmapAlpha)  ; 获取宽度，高度，可省略
        imgHeight := Gdip_GetImageHeight(pBitmapAlpha)
 
        Gdip_SaveBitmapToFile(pBitmapAlpha, imgPath, "255") ;第三个参数控制图片质量
        Gdip_DisposeImage(pBitmapAlpha)
	Gdip_Shutdown(pToken) ; close gdi+
}

setWallPaper(imgPath)
{
    if (imgPath and FileExist(imgPath)) {
        DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, imgPath, UInt, 1)
    }
}

hideDeskIcon()
{
    send {RButton}VD
}