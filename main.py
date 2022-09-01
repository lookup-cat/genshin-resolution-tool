import base64
import sys
import winreg
import ctypes
from tkinter import *
from tkinter import ttk
from tkinter import messagebox

import sv_ttk

app_name = '原神分辨率助手'
height_key = "Screenmanager Resolution Height_h2627697771"
wight_key = "Screenmanager Resolution Width_h182942802"
min_height = 300
min_width = 320

logo = b'iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAABmJLR0QA/wD/AP+gvaeTAAABQElEQVRIie2Vv07DMBCHv1QVDAyFHQgSQSAG2rm0vCD0QYC+AEOnSn0ExFZgYkBFGZjLEDs9LP8plrOg/KQbTrnzl599caBVq/+mzPMsBy6AS+BE5cdADzgA9lTdN/AFlMA78Aa8As/Ai8qD2gUmwApYJ4oVcAfs+MCThEAzbl3QTmKnNucdG/isQaiOQrrU6ru2IqFqhgRfWQqvgXEEwNVXg7sB8CICCpUh26dq3dUlm7MYWp6PCJ/h0Kgz86V8M6guhdx4Y1O+y0b2ZZ48B/Zlw9jhQOuv02s6lXEjnbkmekTccLnOuGbp4Ro4iuYR0FBfH8KOm9AvVknzt5aOEjaOt5nYVFpL8MxT+EF1x2ZbRqF6XHqSyTn2P9Mn7sHzaaB6besdmsVHwAPVGZTAI3AaAdUqgKlY794GbdUquX4AzhzG4UZINFkAAAAASUVORK5CYII='

# 尝试高分屏适配
try:  # >= win 8.1
    ctypes.windll.shcore.SetProcessDpiAwareness(2)
except Exception:  # win 8.0 or less
    ctypes.windll.user32.SetProcessDPIAware()

root = Tk()
# root.tk.call('tk', 'scaling', 2)
screen_height = root.winfo_screenheight()
screen_width = root.winfo_screenwidth()
# 读取配置
try:
    key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Software\miHoYo\原神", 0, winreg.KEY_ALL_ACCESS)
    (current_height, height_type) = winreg.QueryValueEx(key, height_key)
    (current_width, wight_type) = winreg.QueryValueEx(key, wight_key)
    print(f"当前分辨率 高度: {current_height} 宽度: {current_width}")
except Exception:
    messagebox.showerror(title=app_name, message='读取游戏配置失败')
    sys.exit()


def set_value(height: int, width: int):
    winreg.SetValueEx(key, height_key, 0, height_type, height)
    winreg.SetValueEx(key, wight_key, 0, wight_type, width)


def int_validator(content) -> bool:
    """
    校验文本为空字符串或数字
    :param content:
    :return:
    """
    return content == '' or str.isdigit(content)


def save(height: str, width: str):
    """
    保存输入的分辨率
    :param height:
    :param width:
    :return:
    """
    if height == '':
        messagebox.showerror(title=app_name, message='请输入高度')
        return
    if width == '':
        messagebox.showerror(title=app_name, message='请输入宽度')
        return

    height_number = int(height)
    width_number = int(width)

    if height_number > screen_height:
        messagebox.showerror(title=app_name, message=f'高度不能大于屏幕分辨率高度: {screen_height}')
        return
    if height_number < min_height:
        messagebox.showerror(title=app_name, message=f'高度不能低于{min_height}')
        return
    if width_number > screen_width:
        messagebox.showerror(title=app_name, message=f'宽度不能大于屏幕分辨率: {screen_width}')
        return
    if height_number < min_width:
        messagebox.showerror(title=app_name, message=f'宽度不能低于{min_width}')
        return

    set_value(height_number, width_number)
    messagebox.showinfo(message='保存成功')


def app():
    logo_bytes = base64.b64decode(logo)
    root.iconphoto(True, PhotoImage(data=logo_bytes))
    sv_ttk.use_light_theme()
    # 数字输入校验
    validator_cmd = (root.register(int_validator), '%P')

    frame = ttk.Frame(root, width=300, height=300)
    frame.place(anchor=CENTER, relx=0.5, rely=0.5)

    root.minsize(300, 300)
    root.maxsize(300, 300)
    root.title(app_name)

    height_label = ttk.Label(frame, text="高度")
    height_label.grid(row=0, column=0, padx=10)

    height_entry = ttk.Entry(frame, validate='key', validatecommand=validator_cmd)
    height_entry.grid(row=0, column=1, pady=4)
    height_entry.insert(0, str(current_height))

    width_label = ttk.Label(frame, text="宽度")
    width_label.grid(row=1, column=0, padx=10)

    width_entry = ttk.Entry(frame, validate='key', validatecommand=validator_cmd)
    width_entry.grid(row=1, column=1, pady=4)
    width_entry.insert(0, str(current_width))

    def reset():
        height_entry.delete(0, 'end')
        width_entry.delete(0, 'end')
        height_entry.insert(0, str(screen_height))
        width_entry.insert(0, str(screen_width))

    reset_button = ttk.Button(frame, text="重置为屏幕分辨率", command=reset)
    reset_button.grid(row=2, columnspan=2, pady=(24, 4))

    save_button = ttk.Button(frame, text="保存", command=lambda: save(height_entry.get(), width_entry.get()))
    save_button.grid(row=3, columnspan=3, pady=4)

    root.mainloop()


if __name__ == "__main__":
    app()
