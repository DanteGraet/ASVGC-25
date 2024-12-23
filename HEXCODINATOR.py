import math

def hex_to_rgb(hex_code):
    hex_code = hex_code.lstrip('#')

    if len(hex_code) != 6 or not all(c in "0123456789ABCDEFabcdef" for c in hex_code):
        raise ValueError("Bad hex code.")

    r = round(int(hex_code[0:2], 16) / 255)
    g = round(int(hex_code[2:4], 16) / 255)
    b = round(int(hex_code[4:6], 16) / 255)

    return r, g, b

def round(num):
    return math.floor(num*100)/100

while True:

    user_input = input("\nEnter hex code: ").strip()
    try:
        rgb = hex_to_rgb(user_input)
        print("{"+str(rgb[0])+","+str(rgb[1])+","+str(rgb[2])+"}")
    except ValueError as e:
        print(e)
