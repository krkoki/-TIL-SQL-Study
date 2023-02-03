from tkinter import *

root = Tk()
root.title("기태 GUI 연습")
root.geometry("400x200") # 초기 활성화되는 창의 크기를 설정

label1 = Label(root, text="혼공 SQL은")
label2 = Label(root, text="쉽습니다.", font=("궁서체", 30), bg='blue', fg='yellow')

label1.pack()
label2.pack()

root.mainloop()