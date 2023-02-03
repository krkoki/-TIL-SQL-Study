from tkinter import *
from tkinter import messagebox

root = Tk()

def clickButton():
    messagebox.showinfo('혼자야?','SOLO 공부')
def yoyoyo():
    messagebox.showwarning("경고","OMG!!!")
def clickButton2():
    messagebox.showerror("컴퓨터는 잘못이 없다.","Holy Shit!!")

button1 = Button(root, text = '혼공1', command=clickButton)
button2 = Button(root, text = '혼공2', command=yoyoyo)
button3 = Button(root, text = '혼공3', command=clickButton2)

# button1.pack(side=LEFT, fill=X)
# button2.pack(side=TOP, fill=X)
# button3.pack(side=RIGHT, fill=X)

button1.pack(side=TOP, fill=X, padx=5, pady=5)
button2.pack(side=TOP, fill=X, padx=5, pady=5)
button3.pack(side=TOP, fill=X, padx=5, pady=5)

root.mainloop()