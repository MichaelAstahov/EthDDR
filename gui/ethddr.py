import serial
import time
import threading
#The tkinter package (“Tk interface”) 
#is the standard Python interface to the Tk GUI toolkit.
import tkinter
from tkinter import ttk
from tkinter import *

# ----------------------------------------------------------------
# Global Variables
# ----------------------------------------------------------------
serial_data = ''
filter_data = []
update_period = 5
rxdata = False
serial_object = None

# The gui widget has to be created before any other widgets 
# and there can only be one gui widget
gui = Tk()
gui.title("FPGA Interface")

# ----------------------------------------------------------------
# UART Functions
# ----------------------------------------------------------------
def connect():
# The function initiates the Connection to the UART device with the Port and Buad fed through the Entry
# boxes in the application.
# The radio button selects the platform, as the serial object has different key phrases 
# for Linux and Windows. Some Exceptions have been made to prevent the app from crashing,
# such as blank entry fields and value errors, this is due to the state-less-ness of the 
# UART device, the device sends data at regular intervals irrespective of the master's state.
# The other Parts are self explanatory.

    version_ = var_OS.get()
    if version_ == 1: 
        write(">> Windows operation system selected")
    elif version_ == 2:
        write(">> Linux operation system selected")
    else:
        write(">> Please select operation system")

    global serial_object
    global rxdata
    port = e_port.get()
    baud = e_baud.get()
    print(serial_object)
    try:
        if version_ == 2:
            try:
                serial_object = serial.Serial('/dev/tty' + str(port), baud, timeout=0)
                rxdata = True
                write(">> CONNECTED! :)")
            except:
                print (">> Cant Open Specified Port")

        elif version_ == 1:
            serial_object = serial.Serial('COM' + str(port), baud, timeout=0)
            rxdata = True
            write(">> CONNECTED! :)")
            print(serial_object)

    except ValueError:
        rxdata = False
        write(">> Enter Baud and Port")
        return

    t1 = threading.Thread(target = get_data)
    t1.daemon = True
    t1.start()


def get_data():
# This function serves the purpose of collecting data from the serial object and storing 
# the filtered data into a global variable.
# The function has been put into a thread since the serial event is a blocking function.

    global serial_object
    global serial_data
    global filter_data
    global rxdata
    i = 0

    while(rxdata):  
        serial_data = serial_object.read()
        if len(serial_data) > 0: 
            if (serial_data.hex()) != hex(0XFF):
                try:
                    filter_data[i] = serial_data.hex()
                    i += 1
                    print(filter_data[i]) 
                    print(filter_data) 
                    time.sleep(2)
                except:
                    pass
            else:
                i = 0
                print(filter_data) 


# This functions is for sending data from the computer to the host controller.
# The data can be of any format, since the data is always converted into ASCII, 
# the receiving device has to convert the data into the required format.
    # --- Used till now ---
    # send_data = "fpga uart reset"
    # send_data = send_data.decode("hex")
    # serial_object.write(send_data.encode())
    # ----------------------
def send_reset():
    global filter_data
    packet = bytearray()
    packet.append(0xaa)
    packet.append(0x01)
    packet.append(0x00)
    packet.append(0xff)
    serial_object.write(packet)
    write(">> Reset command sent to FPGA")
    # time.sleep(2)
    # print("send function: " + filter_data)
    # if (filter_data == 'fpga uart reset'):
    #     print("DONE")
    # else:
    #     print("NOT GOOD")


def send_ledson():
    send_data = "fpga uart ledson"
    serial_object.write(send_data.encode())
    write(">> LedsOn command sent to FPGA")

def send_ledsoff():
    send_data = "fpga uart ledsoff"
    serial_object.write(send_data.encode())
    write(">> LedsOff command sent to FPGA")


def disconnect():
# This function is for disconnecting and quitting the application.
# Sometimes the application throws a couple of errors while it is being shut down, 
# the fix isn't out yet but will be pushed to the repo once done.
# simple GUI.quit() calls.
    global rxdata
    try:
        serial_object.close() 
        rxdata = False
        write("Disconnected")
    except AttributeError:
        write("Disconnected without using it")


def write(*message, end = "\n", sep = " "):
# This functions is for write data on the gui console.
    e_console.configure(state='normal')
    text = ""
    for item in message:
        text += "{}".format(item)
        text += sep
    text += end
    e_console.insert(INSERT, text)
    e_console.see(END)
    e_console.configure(state='disabled')


# ----------------------------------------------------------------
# GUI
# ---------------------------------------------------------------- 
# Title section
# ----------------------------------
canvas = Canvas(gui, width=300, height=220)      
canvas.pack()      
img = PhotoImage(file="logo.gif")      
canvas.create_image(20,20, anchor=NW, image=img) 
l_title = Label(gui, text="EthDDR FPGA Project Interface", font='sans 16 bold underline').place(x=80, y=230)
# UART section
# ----------------------------------
f_uart        = Frame(height=250, width=250, bd=3, relief='groove').place(x=10, y=270)
l_titleUART   = Label(gui, text="UART Channel", font='sans 11 bold').place(x=80, y=280)
# e_console     = Entry(gui, width=26, borderwidth=3, bg="#C5C5C5", fg="black", font="bold")
e_console     = Text(gui, bg="black", fg="#00FF00", font='sans 9', width=33, height=3, state='disabled')
l_baud        = Label(gui, text="Baud").place(x=27, y=310)
e_baud        = Entry(width=7)
e_baud.place(x=27, y=330)
l_port        = Label(gui, text="Port").place(x=107, y=310)
e_port        = Entry(width=7)
e_port.place(x=107, y=330)
var_OS        = IntVar()
rb_windows    = Radiobutton(text="Windows", variable=var_OS, value=1).place(x=170, y=315)
rb_linux      = Radiobutton(text="Linux", variable=var_OS, value=2).place(x=170, y=335)
b_connect     = Button(text="Connect", command=connect).place(x=15, y=360)
b_disconnect  = Button(text="Disconnect", command=disconnect).place(x=100, y=360)
l_choose_cmd  = Label(gui, text="Choose an FPGA command:", font='sans 11').place(x=20, y=400)
e_console.place(x=17, y=460)
b_rst_cmd     = Button(text="Reset", command=send_reset, width=6).place(x=20, y=425)
b_ledson_cmd  = Button(text="LedsON", command=send_ledson, width=6).place(x=100, y=425)
b_ledsoff_cmd = Button(text="LedsOFF", command=send_ledsoff, width=6).place(x=180, y=425)

b_exit = Button(gui, text="Exit", font='sans 11 bold', command=gui.quit, bg="red").place(x=450, y=500)
gui.geometry('500x550')
# The window won't appear until we enter the Tkinter event loop
gui.mainloop()