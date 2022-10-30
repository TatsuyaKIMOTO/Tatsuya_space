import math
import utime
import machine
import picounicorn

picounicorn.init()

# From CPython Lib/colorsys.py
def hsv_to_rgb(h, s, v):
    if s == 0.0:
        return v, v, v
    i = int(h*6.0)
    f = (h*6.0) - i
    p = v*(1.0 - s)
    q = v*(1.0 - s*f)
    t = v*(1.0 - s*(1.0-f))
    i = i%6
    if i == 0:
        return v, t, p
    if i == 1:
        return q, v, p
    if i == 2:
        return p, v, t
    if i == 3:
        return p, q, v
    if i == 4:
        return t, p, v
    if i == 5:
        return v, p, q

w = picounicorn.get_width()
h = picounicorn.get_height()


# Display a rainbow across Pico Unicorn
def rainbowdisplay():
    for x in range(w):
        for y in range(h):
            r, g, b = [int(c * 255) for c in hsv_to_rgb(x / w, y / h, 1.0)]
            picounicorn.set_pixel(x, y, r, g, b)


# Original program Raspberry by NOSUKE
# Function to clear display by setting pixels to black
def cleardisplay():
    for x in range(w):
        for y in range(h):
            picounicorn.set_pixel(x, y, 0, 0, 0)


# Set constant variables for Raspberry
velocity = 10  # Flying speed
delay = 200  # Delay between rows
g, r, n = [0, 127, 0]  # Green
m, a, g = [255, 0, 63]  # Magenta
udcount = 3  # UpDown times
dntime = 500  # Down time
uptime = 500  # Up time
vntime = 50  # Vanish time


# Function to appear the raspberry
def apraspberry():
    cleardisplay()
    
    # 1st row
    row = 1
    y = 6
    while y >= 0:
        x = 15
        if y == 3:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        else:
            while x >= row:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
                utime.sleep_ms(velocity)
                if x == row:  # Stop
                    break
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Vanish
                x -= 1
        y -= 1
    utime.sleep_ms(delay)
    
    # 2nd row
    row = 2
    y = 6
    while y >= 0:
        x = 15
        while x >= row:
            picounicorn.set_pixel(x, y, g, r, n)  # Green
            utime.sleep_ms(velocity)
            if x == row:  # Stop
                break
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Vanish
            x -= 1
        y -= 1
    utime.sleep_ms(delay)
    
    # 3rd row
    row = 3
    y = 6
    while y >= 0:
        x = 15
        if y == 6:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        elif y == 0:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        elif y == 3:
            while x >= row:
                picounicorn.set_pixel(x, y, m, a, g)  # Magenta
                utime.sleep_ms(velocity)
                if x == row:  # Stop
                    break
                picounicorn.set_pixel(x, y, 0, 0, 0) # Vanish
                x -= 1
        else:
            while x >= row:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
                utime.sleep_ms(velocity)
                if x == row:  # Stop
                    break
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Vanish
                x -= 1
        y -= 1
    utime.sleep_ms(delay)
    
    # 4th row
    row = 4
    y = 6
    while y >= 0:
        x = 15
        if y == 6:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        elif y == 0:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        else:
            while x >= row:
                picounicorn.set_pixel(x, y, m, a, g)  # Magenta
                utime.sleep_ms(velocity)
                if x == row:  # Stop
                    break
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Vanish
                x -= 1
        y -= 1
    utime.sleep_ms(delay)
    
    # 5th , 6th , 7th and 8th row
    row = 5
    while row <= 8:
        y = 6
        while y >= 0:
            x = 15
            while x >= row:
                picounicorn.set_pixel(x, y, m, a, g)  # Magenta
                utime.sleep_ms(velocity)
                if x == row:  # Stop
                    break
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Vanish
                x -= 1
            y -= 1
        utime.sleep_ms(delay)
        row += 1
    
    # 9th row
    row = 9
    y = 6
    while y >= 0:
        x = 15
        if y == 6:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        elif y == 0:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        else:
            while x >= 9:
                picounicorn.set_pixel(x, y, m, a, g)  # Magenta
                utime.sleep_ms(velocity)
                if x == 9:  # Stop
                    break
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Vanish
                x -= 1
        y -= 1
    utime.sleep_ms(delay)
    
    # 10th row
    row = 10
    y = 6
    while y >= 0:
        x = 15
        if y == 6:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        elif y == 5:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        elif y == 1:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        elif y == 0:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
        else:
            while x >= 10:
                picounicorn.set_pixel(x, y, m, a, g)  # Magenta
                utime.sleep_ms(velocity)
                if x == 10:  # Stop
                    break
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Vanish
                x -= 1
        y -= 1
    utime.sleep_ms(delay * 5)


# Function to down the raspberry
def dnraspberry():
    cleardisplay()
    y = 6
    while y >= 0:
        x = 11
        while x >= 2:
            if y == 6 and x == 11:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==5 and x == 11:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==1 and x == 11:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==0 and x == 11:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==6 and x == 10:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==0 and x == 10:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==6 and x == 5:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==0 and x == 5:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==6 and x == 4:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==5 and x == 4:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==4 and x == 4:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==2 and x == 4:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==1 and x == 4:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==0 and x == 4:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==3 and x == 2:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif x >=4:
                picounicorn.set_pixel(x, y, m, a, g)  # Magenta
            else:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            x -= 1
        y -= 1
    utime.sleep_ms(dntime)


# Function to Up the raspberry
def upraspberry():
    cleardisplay()
    y = 6
    while y >= 0:
        x = 10
        while x >= 1:
            if y == 6 and x == 10:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==5 and x == 10:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==1 and x == 10:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==0 and x == 10:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==6 and x == 9:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==0 and x == 9:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==6 and x == 4:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==0 and x == 4:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==6 and x == 3:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==5 and x == 3:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==4 and x == 3:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==2 and x == 3:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==1 and x == 3:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            elif y ==0 and x == 3:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif y ==3 and x == 1:
                picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            elif x >=3:
                picounicorn.set_pixel(x, y, m, a, g)  # Magenta
            else:
                picounicorn.set_pixel(x, y, g, r, n)  # Green
            x -= 1
        y -= 1
    utime.sleep_ms(uptime)


# Function to vanish the raspberry
def vnraspberry():
    x = 0
    while x <= 15:
        y = 6
        while y >= 0:
            picounicorn.set_pixel(x, y, 0, 0, 0)  # Blank
            y -= 1
            utime.sleep_ms(vntime)
        x += 1
        utime.sleep_ms(vntime * 5)


# Original program CPU Temperature by NOSUKE
# Set Pin No.
thermistor = machine.ADC(28)


# Set constant variables for temperature
ZERO = ["   ",
        "TTT",
        "T T",
        "T T",
        "T T",
        "TTT",
        "   "]
         
ONE = ["   ",
       " T ",
       "TT ",
       " T ",
       " T ",
       "TTT",
       "   "]
        
TWO = ["   ",
       "TTT",
       "  T",
       "TTT",
       "T  ",
       "TTT",
       "   "]
        
THREE = ["   ",
         "TTT",
         "  T",
         "TTT",
         "  T",
         "TTT",
         "   "]

FOUR = ["   ",
        "T T",
        "T T",
        "TTT",
        "  T",
        "  T",
        "   "]

FIVE = ["   ",
        "TTT",
        "T  ",
        "TTT",
        "  T",
        "TTT",
        "   "]

SIX = ["   ",
       "TTT",
       "T  ",
       "TTT",
       "T T",
       "TTT",
       "   "]

SEVEN = ["   ",
         "TTT",
         "  T",
         "  T",
         "  T",
         "  T",
         "   "]

EIGHT = ["   ",
         "TTT",
         "T T",
         "TTT",
         "T T",
         "TTT",
         "   "]

NINE = ["   ",
        "TTT",
        "T T",
        "TTT",
        "  T",
        "TTT",
        "   "]

DOT = [" ",
       " ",
       " ",
       " ",
       " ",
       " ",
       "W"]

LETTERC = ["W  ",
           " WW",
           "W  ",
           "W  ",
           "W  ",
           " WW",
           "   "]


# Create dictionaries to store numbers/text
tempdict={0:ZERO, 1:ONE, 2:TWO, 3:THREE, 4:FOUR, 5:FIVE, 6:SIX, 7:SEVEN, 8:EIGHT, 9:NINE}


# Original program Message by NOSUKE
# Set constant variables for message
ZRH=["      ",
      " MMM ",
      "M   M",
      "M   M",
      "M   M",
      " MMM ",
      "     "]

ONH=["      ",
      "  M  ",
      " MM  ",
      "  M  ",
      "  M  ",
      " MMM ",
      "     "]

TWH=["      ",
      " MMM ",
      "M   M",
      "  MM ",
      " M   ",
      "MMMMM",
      "     "]

THH=["     ",
     " MMM ",
     "M   M",
     "  MM ",
     "M   M",
     " MMM ",
     "     "]

FOH=["     ",
     " M M ",
     "M  M ",
     "M  M ",
     "MMMMM",
     "   M ",
     "     "]

FIH=["     ",
     "MMMM ",
     "M    ",
     "MMMM ",
     "    M",
     "MMMM ",
     "     "]

SXH=["     ",
     " MMM ",
     "M    ",
     "MMMM ",
     "M   M",
     " MMM ",
     "     "]

SVH=["     ",
     "MMMMM",
     "M   M",
     "   M ",
     "  M  ",
     "  M  ",
     "     "]

EIH=["     ",
     " MMM ",
     "M   M",
     " MMM ",
     "M   M",
     " MMM ",
     "     "]

INH=["     ",
     " MMM ",
     "M   M",
     " MMMM",
     "    M",
     " MMM ",
     "     "]

AAH=["     ",
     " MMM ",
     "M   M",
     "M   M",
     "MMMMM",
     "M   M",
     "     "]

BBH=["     ",
     "MMMM ",
     "M   M",
     "MMMM ",
     "M   M",
     "MMMM ",
     "     "]

CCH=["     ",
     " MMM ",
     "M   M",
     "M    ",
     "M   M",
     " MMM ",
     "     "]

DDH=["     ",
     "MMMM ",
     "M   M",
     "M   M",
     "M   M",
     "MMMM ",
     "     "]

EEH=["     ",
     "MMMMM",
     "M    ",
     "MMMM ",
     "M    ",
     "MMMMM",
     "     "]

FFH=["     ",
     "MMMMM",
     "M    ",
     "MMMM ",
     "M    ",
     "M    ",
     "     "]

GGH=["     ",
     " MMM ",
     "M   M",
     "M MM ",
     "M   M",
     " MMMM",
     "     "]

HHH=["     ",
     "M   M",
     "M   M",
     "MMMMM",
     "M   M",
     "M   M",
     "     "]

IIH=["     ",
     " MMM ",
     "  M  ",
     "  M  ",
     "  M  ",
     " MMM ",
     "     "]

JJH=["     ",
     "  MMM",
     "   M ",
     "   M ",
     "M  M ",
     " MM  ",
     "     "]

KKH=["     ",
     "M   M",
     "M  M ",
     "MMM  ",
     "M  M ",
     "M   M",
     "     "]

LLH=["     ",
     "M    ",
     "M    ",
     "M    ",
     "M    ",
     "MMMMM",
     "     "]

MMH=["     ",
     "M   M",
     "MM MM",
     "M M M",
     "M   M",
     "M   M",
     "     "]

NNH=["     ",
     "M   M",
     "MM  M",
     "M M M",
     "M  MM",
     "M   M",
     "     "]

OOH=["     ",
     " MMM ",
     "M   M",
     "M   M",
     "M   M",
     " MMM ",
     "     "]

PPH=["     ",
     "MMMM ",
     "M   M",
     "MMMM ",
     "M    ",
     "M    ",
     "     "]

QQH=["     ",
     " MMM ",
     "M   M",
     "M   M",
     "M  M ",
     " MM M",
     "     "]

RRH=["     ",
     "MMMM ",
     "M   M",
     "MMMM ",
     "M   M",
     "M   M",
     "     "]

SSH=["     ",
     " MMMM",
     "M    ",
     " MMM ",
     "    M",
     "MMMM ",
     "     "]

TTH=["     ",
     "MMMMM",
     "  M  ",
     "  M  ",
     "  M  ",
     "  M  ",
     "     "]

UUH=["     ",
     "M   M",
     "M   M",
     "M   M",
     "M   M",
     " MMM ",
     "     "]

VVH=["     ",
     "M   M",
     "M   M",
     "M   M",
     " M M ",
     "  M  ",
     "     "]

WWH=["     ",
     "M   M",
     "M   M",
     "M M M",
     "MM MM",
     "M   M",
     "     "]

XXH=["     ",
     "M   M",
     " M M ",
     "  M  ",
     " M M ",
     "M   M",
     "     "]

YYH=["     ",
     "M   M",
     " M M ",
     "  M  ",
     "  M  ",
     "  M  ",
     "     "]

ZZH=["     ",
     "MMMMM",
     "   M ",
     "  M  ",
     " M   ",
     "MMMMM",
     "     "]

EXCH=[" M M ",
      " M M ",
      " M M ",
      " M M ",
      "     ",
      " M M ",
      "     "]

QUEH=[" MMM ",
      "M   M",
      "M   M",
      "  MM ",
      "  M  ",
      "  M  ",
      "     "]

BAR=["     ",
     "     ",
     "     ",
     "MMMMM",
     "     ",
     "     ",
     "     "]

AH=["     ",
    "MMMMM",
    "    M",
    "  MM ",
    "  M  ",
    " M   ",
    "     "]

IH=["    M",
    "  MM ",
    "MMM  ",
    "  M  ",
    "  M  ",
    "  M  ",
    "     "]

UH=["  M  ",
    "MMMMM",
    "M   M",
    "    M",
    "    M",
    "  MM ",
    "     "]

EH=["     ",
    " MMM ",
    "  M  ",
    "  M  ",
    "  M  ",
    "MMMMM",
    "     "]

OH=["   M ",
    "MMMMM",
    "  MM ",
    " M M ",
    "M  M ",
    "   M ",
    "     "]

KAH=["  M  ",
     "MMMMM",
     " M  M",
     "M   M",
     "  M M",
     "   M ",
     "     "]

KIH=["  M  ",
     "MMMMM",
     "  M  ",
     "MMMMM",
     "  M  ",
     "  M  ",
     "     "]

KUH=["     ",
     " MMMM",
     "M   M",
     "    M",
     "    M",
     " MMM ",
     "     "]

KEH=[" M   ",
     " MMMM",
     "M  M ",
     "   M ",
     "   M ",
     "  M  ",
     "     "]

KOH=["     ",
     "MMMMM",
     "    M",
     "    M",
     "    M",
     "MMMMM",
     "     "]

GAH=["  M  M",
     "MMMMM ",
     " M  M ",
     "M   M ",
     "  M M ",
     "   M  ",
     "      "]

GIH=["  M  M",
     "MMMMM ",
     "  M   ",
     "MMMMM ",
     "  M   ",
     "  M   ",
     "      "]

GUH=["     M",
     " MMMM ",
     "M   M ",
     "    M ",
     "    M ",
     " MMM  ",
     "      "]

GEH=[" M   M",
     " MMMM ",
     "M  M  ",
     "   M  ",
     "   M  ",
     "  M   ",
     "      "]

GOH=["     M",
     "MMMMM ",
     "    M ",
     "    M ",
     "    M ",
     "MMMMM ",
     "      "]

SAH=[" M M ",
     "MMMMM",
     " M M ",
     "   M ",
     "   M ",
     "  M  ",
     "     "]

SIH=["MM   ",
     "    M",
     "MM  M",
     "    M",
     "   M ",
     " MM  ",
     "     "]

SUH=["     ",
     "MMMMM",
     "   M ",
     "  M  ",
     " M M ",
     "M   M",
     "     "]

SEH=[" M   ",
     "MMMMM",
     " M  M",
     " M   ",
     " M   ",
     " MMMM",
     "     "]

SOH=["     ",
     "M   M",
     " M  M",
     "    M",
     "    M",
     " MMM ",
     "     "]

ZAH=[" M M M",
     "MMMMM ",
     " M M  ",
     "   M  ",
     "   M  ",
     "  M   ",
     "      "]

ZIH=["MM   M",
     "    M ",
     "MM  M ",
     "    M ",
     "   M  ",
     " MM   ",
     "      "]

ZUH=["     M",
     "MMMMM ",
     "   M  ",
     "  M   ",
     " M M  ",
     "M   M ",
     "      "]

ZEH=[" M   M",
     "MMMMM ",
     " M  M ",
     " M    ",
     " M    ",
     " MMMM ",
     "      "]

ZOH=["     M",
     "M   M ",
     " M  M ",
     "    M ",
     "    M ",
     " MMM  ",
     "      "]

TAH=["     ",
     " MMMM",
     "M   M",
     " MMMM",
     "    M",
     " MMM ",
     "     "]

TIH=[" MMM ",
     "  M  ",
     "MMMMM",
     "  M  ",
     "  M  ",
     " M   ",
     "     "]

TUH=["     ",
     "M M M",
     "M M M",
     "    M",
     "    M",
     " MMM ",
     "     "]

LTUH=["    ",
      "    ",
      "MM M",
      "MM M",
      "   M",
      " MM ",
      "    "]

TEH=[" MMM ",
     "     ",
     "MMMMM",
     "  M  ",
     "  M  ",
     " M   ",
     "     "]

TOH=["M  ",
     "M  ",
     "MM ",
     "M M",
     "M  ",
     "M  ",
     "   "]

DAH=["     M",
     " MMMM ",
     "M   M ",
     " MMMM ",
     "    M ",
     " MMM  ",
     "      "]

DIH=[" MMM M",
     "  M   ",
     "MMMMM ",
     "  M   ",
     "  M   ",
     " M    ",
     "      "]

DUH=["     M",
     "M M M ",
     "M M M ",
     "    M ",
     "    M ",
     " MMM  ",
     "      "]

DEH=[" MMM M",
     "      ",
     "MMMMM ",
     "  M   ",
     "  M   ",
     " M    ",
     "      "]

DOH=[" M  M",
     " M   ",
     " MM  ",
     " M M ",
     " M   ",
     " M   ",
     "     "]

NAH=["  M  ",
     "MMMMM",
     "  M  ",
     "  M  ",
     "  M  ",
     " M   ",
     "     "]

NIH=["     ",
     " MMM ",
     "     ",
     "     ",
     "     ",
     "MMMMM",
     "     "]

NUH=["     ",
     "MMMMM",
     "   M ",
     " MM  ",
     " M M ",
     "M   M",
     "     "]

NEH=["  M  ",
     "MMMMM",
     "   M ",
     "  M  ",
     " MMM ",
     "M M M",
     "     "]

NOH=["   ",
     "  M",
     "  M",
     "  M",
     " M ",
     "M  ",
     "   "]

HAH=["   M ",
     " M M ",
     " M M ",
     " M  M",
     " M  M",
     "M   M",
     "     "]

HIH=["     ",
     "M    ",
     "MMMMM",
     "M    ",
     "M    ",
     "MMMMM",
     "     "]

HUH=["     ",
     "MMMMM",
     "    M",
     "    M",
     "    M",
     " MMM ",
     "     "]

HEH=["     ",
     " M   ",
     "MMM  ",
     "M  M ",
     "    M",
     "     ",
     "     "]

HOH=["  M  ",
     "MNMMM",
     "  M  ",
     "M M M",
     "M M M",
     "  M  ",
     "     "]

BAH=["   M M",
     " M M  ",
     " M M  ",
     " M MM ",
     " M  M ",
     "M   M ",
     "      "]

BIH=["     M",
     "M     ",
     "MMMMM ",
     "M     ",
     "M     ",
     "MMMMM ",
     "      "]

BUH=["     M",
     "MMMMM ",
     "    M ",
     "    M ",
     "    M ",
     " MMM  ",
     "      "]

BEH=["   M ",
     " M   ",
     "MMM  ",
     "M  M ",
     "    M",
     "     ",
     "     "]

BOH=["  M  M",
     "MMMMM ",
     "  M   ",
     "M M M ",
     "M M M ",
     "  M   ",
     "      "]

MAH=["     ",
     "MMMMM",
     "    M",
     " M M ",
     "  M  ",
     "   M ",
     "     "]

MIH=["   ",
     "MMM",
     "   ",
     "MMM",
     "   ",
     "MMM",
     "   "]

MUH=["     ",
     "  M  ",
     " M   ",
     "M   M",
     "MMMMM",
     "    M",
     "     "]

MEH=["     ",
     "    M",
     " M M ",
     "  M  ",
     " M M ",
     "M    ",
     "     "]

MOH=["     ",
     "MMMM ",
     " M   ",
     "MMMM ",
     " M   ",
     " MMMM",
     "     "]

YAH=[" M   ",
     "MMMMM",
     " M M ",
     " M   ",
     " M   ",
     " M   ",
     "     "]

LYAH=["    ",
      "    ",
      " M  ",
      "MMMM",
      " M M",
      " M  ",
      "    "]

YUH=["     ",
     " MMM ",
     "   M ",
     "   M ",
     "   M ",
     "MMMMM",
     "     "]

LYUH=["    ",
      "    ",
      "    ",
      " MM ",
      "  M ",
      "MMMM",
      "    "]

YOH=["     ",
     "MMMMM",
     "    M",
     "MMMMM",
     "    M",
     "MMMMM",
     "     "]

LYOH=["    ",
      "    ",
      "    ",
      " MMM",
      "  MM",
      " MMM",
      "    "]

RAH=[" MMM ",
     "     ",
     "MMMMM",
     "    M",
     "    M",
     "  MM ",
     "     "]

RIH=["M M",
     "M M",
     "M M",
     "  M",
     "  M",
     " M ",
     "   "]

RUH=["   M ",
     " M M ",
     " M M ",
     " M M ",
     " M MM",
     "M  M ",
     "     "]

REH=["M  ",
     "M  ",
     "M  ",
     "M  ",
     "M M",
     "MM ",
     "   "]

ROH=["     ",
     "MMMMM",
     "M   M",
     "M   M",
     "M   M",
     "MMMMM",
     "     "]

WAH=["     ",
     "MMMMM",
     "M   M",
     "    M",
     "    M",
     "  MM ",
     "     "]

WOH=["     ",
     "MMMMM",
     "    M",
     "MMMMM",
     "    M",
     " MMM ",
     "     "]

NNH=["     ",
     "M   M",
     " M  M",
     "    M",
     "   M ",
     " MM  ",
     "     "]

ZRV=["      ",
      " MMM ",
      "M   M",
      "M   M",
      "M   M",
      " MMM ",
      "     "]

ONV=["      ",
      "     ",
      "    M",
      "MMMMM",
      " M  M",
      "     ",
      "     "]

TWV=["      ",
      " M  M",
      "M M M",
      "M M M",
      "M  MM",
      " M  M",
      "     "]

THV=["     ",
     " M M ",
     "M M M",
     "M M M",
     "M   M",
     " M M ",
     "     "]

FOV=["     ",
     "   M ",
     " MMMM",
     "   M ",
     "M  M ",
     " MMM ",
     "     "]

FIV=["     ",
     "   M ",
     "M M M",
     "M M M",
     "M M M",
     "MMM M",
     "     "]

SXV=["     ",
     "   M ",
     "M M M",
     "M M M",
     "M M M",
     " MMM ",
     "     "]

SVV=["     ",
     "MM   ",
     "M M  ",
     "M  MM",
     "M    ",
     "MM   ",
     "     "]

EIV=["     ",
     " M M ",
     "M M M",
     "M M M",
     "M M M",
     " M M ",
     "     "]

INV=["     ",
     " MMM ",
     "M M M",
     "M M M",
     "M M M",
     " M   ",
     "     "]

AAV=["     ",
     " MMMM",
     "M  M ",
     "M  M ",
     "M  M ",
     " MMMM",
     "     "]

BBV=["     ",
     " M M ",
     "M M M",
     "M M M ",
     "M M M",
     "MMMMM",
     "     "]

CCV=["     ",
     " M M ",
     "M   M",
     "M   M",
     "M   M",
     " MMM ",
     "     "]

DDV=["     ",
     " MMM ",
     "M   M",
     "M   M",
     "M   M",
     "MMMMM",
     "     "]

EEV=["     ",
     "M   M",
     "M M M",
     "M M M",
     "M M M",
     "MMMMM",
     "     "]

FFV=["     ",
     "M    ",
     "M M  ",
     "M M  ",
     "M M  ",
     "MMMMM",
     "     "]

GGV=["     ",
     " M MM",
     "M M M",
     "M M M",
     "M   M",
     " MMM",
     "     "]

HHV=["     ",
     "MMMMM",
     "  M  ",
     "  M  ",
     "  M  ",
     "MMMMM",
     "     "]

IIV=["     ",
     "     ",
     "M   M",
     "MMMMM",
     "M   M",
     "     ",
     "     "]

JJV=["     ",
     "M    ",
     "MMMM ",
     "M   M",
     "M   M",
     "   M ",
     "     "]

KKV=["     ",
     "M   M",
     " M M ",
     "  M  ",
     "  M  ",
     "MMMMM",
     "     "]

LLV=["     ",
     "    M",
     "    M",
     "    M",
     "    M",
     "MMMMM",
     "     "]

MMV=["     ",
     "MMMMM",
     " M   ",
     "  M  ",
     " M   ",
     "MMMMM",
     "     "]

NNV=["     ",
     "MMMMM",
     "   M ",
     "  M  ",
     " M   ",
     "MMMMM",
     "     "]

OOV=["     ",
     " MMM ",
     "M   M",
     "M   M",
     "M   M",
     " MMM ",
     "     "]

PPV=["     ",
     " M   ",
     "M M  ",
     "M M  ",
     "M M  ",
     "MMMMM",
     "     "]

QQV=["     ",
     " MM M",
     "M  M ",
     "M   M",
     "M   M",
     " MMM ",
     "     "]

RRV=["     ",
     " M MM",
     "M M  ",
     "M M  ",
     "M M  ",
     "MMMMM",
     "     "]

SSV=["     ",
     "M  M ",
     "M M M",
     "M M M",
     "M M M",
     " M  M",
     "     "]

TTV=["     ",
     "M    ",
     "M    ",
     "MMMMM",
     "M    ",
     "M    ",
     "     "]

UUV=["     ",
     "MMMM ",
     "    M",
     "    M",
     "    M",
     "MMMM ",
     "     "]

VVV=["     ",
     "MMM  ",
     "   M ",
     "    M",
     "   M ",
     "MMM  ",
     "     "]

WWV=["     ",
     "MMMMM",
     "   M ",
     "  M  ",
     "   M ",
     "MMMMM",
     "     "]

XXV=["     ",
     "M   M",
     " M M ",
     "  M  ",
     " M M ",
     "M   M",
     "     "]

YYV=["     ",
     "M    ",
     " M   ",
     "  MMM",
     " M   ",
     "M    ",
     "     "]

ZZV=["     ",
     "M   M",
     "MM  M",
     "M M M",
     "M  MM",
     "M   M",
     "     "]

EXCV=["     ",
      "     ",
      "MMM M",
      "     ",
      "MMM M",
      "     ",
      "     "]

QUEV=["      ",
      " MM   ",
      "M  M  ",
      "M  MMM",
      "M     ",
      " MM   ",
      "      "]

AV=["     ",
    "MM   ",
    "M M  ",
    "M MM ",
    "M   M",
    "M    ",
    "     "]

IV=["      ",
    "M     ",
    " M    ",
    " MMMMM",
    "  M   ",
    "  M   ",
    "      "]

UV=["      ",
    " MMMM ",
    " M   M",
    "MM   M",
    " M    ",
    " MM   ",
    "      "]

EV=["     ",
    "    M",
    "M   M",
    "MMMMM",
    "M   M",
    "    M",
    "     "]

OV=["      ",
    " M    ",
    "MMMMMM",
    " MM   ",
    " M M  ",
    " M  M ",
    "      "]

KAV=["      ",
     " MMMM ",
     " M   M",
     "MM  M ",
     " MM   ",
     " M M  ",
     "      "]

KIV=["      ",
     " M M  ",
     " M M  ",
     "MMMMMM",
     " M M  ",
     " M M  ",
     "      "]

KUV=["     ",
     "MMMM ",
     "M   M",
     "M   M",
     "M   M",
     " M   ",
     "     "]

KEV=["      ",
     " M    ",
     " MMMM ",
     " M   M",
     "MM    ",
     "  M   ",
     "      "]

KOV=["     ",
     "MMMMM",
     "M   M",
     "M   M",
     "M   M",
     "M   M",
     "     "]

GAV=["M     ",
     " MMMM ",
     " M   M",
     "MM  M ",
     " MM   ",
     " M M  ",
     "      "]

GIV=["M     ",
     " M M  ",
     " M M  ",
     "MMMMMM",
     " M M  ",
     " M M  ",
     "      "]

GUV=["M     ",
     " MMMM ",
     " M   M",
     " M   M",
     " M   M",
     "  M   ",
     "      "]

GEV=["M     ",
     " M    ",
     " MMMM ",
     " M   M",
     "MM    ",
     "  M   ",
     "      "]

GOV=["M     ",
     " MMMMM",
     " M   M",
     " M   M",
     " M   M",
     " M   M",
     "      "]

SAV=["      ",
     " M    ",
     "MMMMM ",
     " M   M",
     "MMM   ",
     " M    ",
     "      "]

SIV=["      ",
     " MMM  ",
     "    M ",
     "     M",
     "M M  M",
     "M M   ",
     "      "]

SUV=["     ",
     "M   M",
     "MM M ",
     "M M  ",
     "M  M ",
     "M   M",
     "     "]

SEV=["      ",
     " MM  M",
     " M   M",
     " M   M",
     "MMMMMM",
     " M    ",
     "      "]

SOV=["     ",
     "MMMM ",
     "    M",
     "    M",
     " M  M",
     "M    ",
     "     "]

ZAV=["M     ",
     " M    ",
     "MMMMM ",
     " M   M",
     "MMM   ",
     " M    ",
     "     "]

ZIV=["M     ",
     " MMM  ",
     "    M ",
     "     M",
     "M M  M",
     "M M   ",
     "      "]

ZUV=["M     ",
     " M   M",
     " MM M ",
     " M M  ",
     " M  M ",
     " M   M",
     "      "]

ZEV=["M     ",
     " MM  M",
     " M   M",
     " M   M",
     "MMMMMM",
     " M    ",
     "      "]

ZOV=["M     ",
     " MMMM ",
     "     M",
     "     M",
     "  M  M",
     " M    ",
     "      "]

TAV=["     ",
     "MMMM ",
     "M M M",
     "M M M",
     "M M M",
     " M   ",
     "     "]

TIV=["      ",
     "  M   ",
     "M M   ",
     "MMMMM ",
     "M M  M",
     "  M   ",
     "      "]

TUV=["     ",
     "MMMM ",
     "    M",
     "MM  M",
     "    M",
     "MM   ",
     "     "]

LTUV=["    ",
      "MMM ",
      "   M",
      "MM M",
      "MM  ",
      "    ",
      "    "]

TEV=["      ",
     "  M   ",
     "M M   ",
     "M MMM ",
     "M M  M",
     "  M   ",
     "      "]

TOV=["      ",
     "      ",
     "   M  ",
     "  M   ",
     "MMMMMM",
     "      ",
     "      "]

DAV=["M     ",
     " MMMM ",
     " M M M",
     " M M M",
     " M M M",
     "  M   ",
     "      "]

DIV=["M     ",
     "  M   ",
     "M M   ",
     "MMMMM ",
     "M M  M",
     "  M   ",
     "      "]

DUV=["M     ",
     " MMMM ",
     "     M",
     " MM  M",
     "     M",
     " MM   ",
     "      "]

DEV=["M     ",
     "  M   ",
     "M M   ",
     "M MMM ",
     "M M  M",
     "  M   ",
     "      "]

DOV=["      ",
     "M     ",
     "   M  ",
     "  M   ",
     "MMMMMM",
     "      ",
     "      "]

NAV=["      ",
     " M    ",
     " M    ",
     "MMMMM ",
     " M   M",
     " M    ",
     "      "]

NIV=["     ",
     "    M",
     "M   M",
     "M   M",
     "M   M",
     "    M",
     "     "]

NUV=["     ",
     "M   M",
     "MM M ",
     "M M  ",
     "M MM ",
     "M   M",
     "     "]

NEV=["      ",
     " M   M",
     " MM M ",
     "MM MMM",
     " M  M ",
     " M   M",
     "      "]

NOV=["     ",
     "     ",
     "MMM  ",
     "   M ",
     "    M",
     "     ",
     "     "]

HAV=["      ",
     "   MMM",
     "MMM   ",
     "      ",
     " MMMM ",
     "     M",
     "      "]

HIV=["     ",
     " M  M",
     " M  M",
     " M  M",
     " M  M",
     "MMMMM",
     "     "]

HUV=["     ",
     "MMMM ",
     "M   M",
     "M   M",
     "M   M",
     "M    ",
     "     "]

HEV=["    ",
     "   M",
     "  M ",
     " M  ",
     "MM  ",
     " MM ",
     "    "]

HOV=["      ",
     " M MM ",
     " M    ",
     "MMMMMM",
     " M    ",
     " M MM ",
     "      "]

BAV=["M     ",
     "   MMM",
     "MMMM  ",
     "      ",
     " MMMM ",
     "     M",
     "      "]

BIV=["M    ",
     " M  M",
     " M  M",
     " M  M",
     " M  M",
     "MMMMM",
     "     "]

BUV=["M     ",
     " MMMM ",
     " M   M",
     " M   M",
     " M   M",
     " M    ",
     "      "]

BEV=["     ",
     "M   M",
     "   M ",
     "  M  ",
     " MM  ",
     "  MM ",
     "     "]

BOV=["M     ",
     " M MM ",
     " M    ",
     "MMMMMM",
     " M    ",
     " M MM ",
     "      "]

MAV=["     ",
     "MM   ",
     "M M M",
     "M  M ",
     "M M  ",
     "M    ",
     "     "]

MIV=["     ",
     "     ",
     "M M M",
     "M M M",
     "M M M",
     "     ",
     "     "]

MUV=["     ",
     "  MMM",
     "   M ",
     "M  M ",
     " M M ",
     "  MM ",
     "     "]

MEV=["     ",
     "M    ",
     " M M ",
     "  M  ",
     " M M ",
     "    M",
     "     "]

MOV=["     ",
     "    M",
     "M M M",
     "M M M",
     "MMMMM",
     "M M  ",
     "     "]

YAV=["      ",
     " M    ",
     " MM   ",
     " M    ",
     "MMMMMM",
     " M    ",
     "      "]

LYAV=["    ",
      " MM ",
      " M  ",
      "MMMM",
      " M  ",
      "    ",
      "    "]

YUV=["     ",
     "    M",
     "MMMMM",
     "M   M",
     "M   M",
     "    M",
     "     "]

LYUV=["   ",
      "  M",
      "MMM",
      "M M",
      "  M",
      "   ",
      "   "]

YOV=["     ",
     "MMMMM",
     "M M M",
     "M M M",
     "M M M",
     "M M M",
     "     "]

LYOV=["   ",
      "MMM",
      "MMM",
      "M M",
      "   ",
      "   ",
      "   "]

RAV=["      ",
     "  MMM ",
     "M M  M",
     "M M  M",
     "M M   ",
     "  M   ",
     "      "]

RIV=["      ",
     "      ",
     "MMMMM ",
     "     M",
     "MMM   ",
     "      ",
     "      "]

RUV=["      ",
     "    M ",
     "MMMMMM",
     "      ",
     " MMMM ",
     "     M",
     "      "]

REV=["      ",
     "      ",
     "    M ",
     "     M",
     "MMMMMM",
     "      ",
     "      "]

ROV=["     ",
     "MMMMM",
     "M   M",
     "M   M",
     "M   M",
     "MMMMM",
     "     "]

WAV=["     ",
     "MMMM ",
     "M   M",
     "M   M",
     "M    ",
     "MM   ",
     "     "]

WOV=["     ",
     "MMMM ",
     "M M M",
     "M M M",
     "M M M",
     "M M  ",
     "     "]

NNV=["     ",
     "MMM  ",
     "   M ",
     "    M",
     " M  M",
     "M    ",
     "     "]

BLK=["     ",
     "     ",
     "     ",
     "     ",
     "     ",
     "     ",
     "     "]


AMONG=[" BBBB ",
       "GGEEBB",
       "EEEEBB",
       " BBBBB",
       " BBBBB",
       " BBBB ",
       " B  B "]


# Define Message
M11 = HAH
M12 = RUH
M13 = TIH
M14 = BAR
M15 = EXCH
M16 = BLK


# Define colours
MSGcolour = (255, 255, 255)
BDYcolour = (255, 0, 0)
EYEcolour = (0, 255, 255)
GLScolour = (255, 255, 255)


# Scroll Velocity
scroll = 100


# Function to update display with numbers/text
def updatedisplay(displaymap):
    x=0
    y=0
    for row in displaymap:
        for line in row:
            for char in line:
                if x < w and y <h:
                    if char == "M":
                        r, g, b = MSGcolour
                    elif char == "B":
                        r, g, b = BDYcolour
                    elif char == "E":
                        r, g, b = EYEcolour
                    elif char == "G":
                        r, g, b = GLScolour
                    else:
                        r, g, b = 0, 0, 0
                    picounicorn.set_pixel(x, y, r, g, b)
                x+=1
            x=0
        y+=1
    return displaymap


# Function to generate an 2D array to represent the message in the format
def generatemessage():
    fulldisplay = [["                {} {} {} {} {} {}                ".format(M11[i],M12[i],M13[i],M14[i],M15[i],M16[i])] for i in range(h)]
    return fulldisplay


# Function to generate an 2D array to represent the among in the format
def generateamong():
    fulldisplay = [["                {} {} {} {}        ".format(AMONG[i],AMONG[i],AMONG[i],AMONG[i])] for i in range(h)]    
    return fulldisplay
    
    
#Function to make the "display map" seem as though it is "scrolling" (loop)
def scrolldisplay(displaymap):
    scrollmap = []
    rowcount = 0
    for row in displaymap:
        scrollmap.append([])
        for line in row:
            scrollmap[rowcount]= [line[1:]+line[0]]
        rowcount += 1
    return scrollmap


# Button A pressed
def buttonA_press():
    print("You press the button A!")
    count = 0
    while count <= 0:
        apraspberry()
        ud = 1
        while ud <= udcount:
            dnraspberry()
            upraspberry()
            ud += 1
        vnraspberry()
        count += 1

# Button B pressed
# Define colours
WHTcolour = (255, 255, 255)


def buttonB_press():
    print("You press the button B!")
    count = 0
    sensor_temp = machine.ADC(4)
    conversion_factor = 3.3 / (65535)
    while count <= 10:        
        reading = sensor_temp.read_u16() * conversion_factor
#        temperature = 27 - (reading - 0.706)/0.001721  #Defolt
        temperature = 27 - (reading - 0.716)/0.001721
        
        temp1 = int(temperature / 10)
        temp2 = int(temperature - temp1 * 10)
        temp3 = int(temperature * 10 - temp1 * 100 - temp2 * 10)
        
        # Change colour depending on temperature
        if 0 < temperature <= 10:
            TMPcolour = (0, 0, 255)
        elif 10 < temperature <= 20:
            TMPcolour = (0, 255, 255)
        elif 20 < temperature <= 30:
            TMPcolour = (0, 255, 0)
        elif 30 < temperature <= 40:
            TMPcolour = (255, 255, 0)
        elif 40 < temperature <= 50:
            TMPcolour = (255, 0, 0)
        else:
            TMPcolour = (255, 255, 255)
        
        # Function to update display with numbers/text
        def updatedisplay(displaymap):
            x = 0
            y = 0
            for row in displaymap:
                for line in row:
                    for char in line:
                        if x < w and y <h:
                            if char == "T":
                                r, g, b = TMPcolour
                            elif char == "W":
                                r, g, b = WHTcolour
                            else:
                                r,g,b=0,0,0
                            picounicorn.set_pixel(x, y, r, g, b)
                        x += 1
                    x = 0
                y += 1
            return displaymap
        
        # Function to generate an 2D array to represent the current temperature in the format
        def generatetemp(temp1, temp2, temp3):
            temp1pix = [item.replace("X","T") for item in tempdict[temp1]]
            temp2pix = [item.replace("X","T") for item in tempdict[temp2]]
            temp3pix = [item.replace("X","T") for item in tempdict[temp3]]
            fulldisplay = [["{} {}{}{} {} ".format(temp1pix[i], temp2pix[i], DOT[i], temp3pix[i], LETTERC[i])] for i in range(h)]
            return fulldisplay
        
        # Temperature display
        updatedisplay(generatetemp(temp1, temp2, temp3))
        utime.sleep_ms(1000)
        count += 1
    cleardisplay()
    
    
# Button X pressed
def buttonX_press():
    print("You press the button X!")
    count = 0
    while count <= 0:
        currentdisplaymap = updatedisplay(generatemessage())
        for i in range(w*3):
            currentdisplaymap = updatedisplay(scrolldisplay(currentdisplaymap))
            utime.sleep_ms(scroll)
        cleardisplay()
        count += 1


# Button Y pressed
def buttonY_press():
    print("You press the button Y!")
    count = 0
    while count <= 0:
        currentdisplaymap = updatedisplay(generateamong())
        for i in range(w*3):
            currentdisplaymap = updatedisplay(scrolldisplay(currentdisplaymap))
            utime.sleep_ms(scroll)
        cleardisplay()
        count += 1

# Main
count = 0

while True:
    rainbowdisplay()
    if picounicorn.is_pressed(picounicorn.BUTTON_A):
        buttonA_press()
    elif picounicorn.is_pressed(picounicorn.BUTTON_B):
        buttonB_press()
    elif picounicorn.is_pressed(picounicorn.BUTTON_X):
        buttonX_press()
    elif picounicorn.is_pressed(picounicorn.BUTTON_Y):
        buttonY_press()
    else:
        count += 1
        print(count)
    utime.sleep_ms(1000)