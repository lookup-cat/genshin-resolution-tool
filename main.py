import winreg

height_key = "Screenmanager Resolution Height_h2627697771"
wight_key = "Screenmanager Resolution Width_h182942802"


def main():
    key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Software\miHoYo\原神", 0, winreg.KEY_ALL_ACCESS)
    (height_value, height_type) = winreg.QueryValueEx(key, height_key)
    (wight_value, wight_type) = winreg.QueryValueEx(key, wight_key)
    print(f"当前分辨率 高度: {height_value} 宽度: {wight_value}")

    new_height_value = input_number("高度", height_value)
    new_wight_value = input_number("宽度", wight_value)
    print(f"高度: {new_height_value} 宽度: {new_wight_value}")

    winreg.SetValueEx(key, height_key, 0, height_type, new_height_value)
    winreg.SetValueEx(key, wight_key, 0, wight_type, new_wight_value)
    print("修改完成")


def input_number(name: str, default_value: int) -> int:
    while True:
        number: str = input(f"请输入{name}(不修改请直接按回车):\n")
        if number == "":
            return default_value
        else:
            try:
                return int(number)
            except Exception:
                print("请输入有效数字")
                continue


if __name__ == "__main__":
    main()
