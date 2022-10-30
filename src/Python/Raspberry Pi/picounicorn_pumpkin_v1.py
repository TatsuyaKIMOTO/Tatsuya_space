import picounicorn

picounicorn.init()


# From CPython Lib/colorsys.py
def hsv_to_rgb(h, s, v):
    if s == 0.0:
        return v, v, v
    i = int(h * 6.0)
    f = (h * 6.0) - i
    p = v * (1.0 - s)
    q = v * (1.0 - s * f)
    t = v * (1.0 - s * (1.0 - f))
    i = i % 6
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
#改造用に以下コメントアウトしておく。これはオリジナルのもの
# for x in range(w):
#     for y in range(h):
#         r, g, b = [int(c * 255) for c in hsv_to_rgb(x / w, y / h, 1.0)]
#         picounicorn.set_pixel(x, y, r, g, b)

#かぼちゃの絵をつくってみる
picounicorn.set_pixel(0, 0, 0, 0, 0)
picounicorn.set_pixel(0, 1, 0, 0, 0)
picounicorn.set_pixel(0, 2, 0, 0, 0)
picounicorn.set_pixel(0, 3, 0, 0, 0)
picounicorn.set_pixel(0, 4, 0, 0, 0)
picounicorn.set_pixel(0, 5, 0, 0, 0)
picounicorn.set_pixel(0, 6, 0, 0, 0)

picounicorn.set_pixel(1, 0, 0, 0, 0)
picounicorn.set_pixel(1, 1, 0, 0, 0)
picounicorn.set_pixel(1, 2, 0, 0, 0)
picounicorn.set_pixel(1, 3, 0, 0, 0)
picounicorn.set_pixel(1, 4, 0, 0, 0)
picounicorn.set_pixel(1, 5, 0, 0, 0)
picounicorn.set_pixel(1, 6, 0, 0, 0)

picounicorn.set_pixel(2, 0, 0, 0, 0)
picounicorn.set_pixel(2, 1, 0, 0, 0)
picounicorn.set_pixel(2, 2, 0, 0, 0)
picounicorn.set_pixel(2, 3, 0, 0, 0)
picounicorn.set_pixel(2, 4, 0, 0, 0)
picounicorn.set_pixel(2, 5, 0, 0, 0)
picounicorn.set_pixel(2, 6, 0, 0, 0)

picounicorn.set_pixel(2, 0, 0, 0, 0)
picounicorn.set_pixel(2, 1, 0, 0, 0)
picounicorn.set_pixel(2, 2, 0, 0, 0)
picounicorn.set_pixel(2, 3, 255, 165, 0)#Orange
picounicorn.set_pixel(2, 4, 255, 165, 0)
picounicorn.set_pixel(2, 5, 255, 165, 0)
picounicorn.set_pixel(2, 6, 0, 0, 0)

picounicorn.set_pixel(3, 0, 0, 0, 0)
picounicorn.set_pixel(3, 1, 0, 0, 0)
picounicorn.set_pixel(3, 2, 255, 165, 0)
picounicorn.set_pixel(3, 3, 255, 165, 0)
picounicorn.set_pixel(3, 4, 0, 0, 0)
picounicorn.set_pixel(3, 5, 255, 165, 0)
picounicorn.set_pixel(3, 6, 255, 165, 0)

picounicorn.set_pixel(4, 0, 0, 0, 0)
picounicorn.set_pixel(4, 1, 255, 165, 0)
picounicorn.set_pixel(4, 2, 255, 165, 0)
picounicorn.set_pixel(4, 3, 0, 0, 0)
picounicorn.set_pixel(4, 4, 255, 165, 0)
picounicorn.set_pixel(4, 5, 0, 0, 0)
picounicorn.set_pixel(4, 6, 255, 165, 0)

picounicorn.set_pixel(5, 0, 0, 0, 0)
picounicorn.set_pixel(5, 1, 255, 165, 0)
picounicorn.set_pixel(5, 2, 0, 0, 0)
picounicorn.set_pixel(5, 3, 255, 165, 0)
picounicorn.set_pixel(5, 4, 255, 165, 0)
picounicorn.set_pixel(5, 5, 0, 0, 0)
picounicorn.set_pixel(5, 6, 255, 165, 0)

picounicorn.set_pixel(6, 0, 0, 0, 0)
picounicorn.set_pixel(6, 1, 255, 165, 0)
picounicorn.set_pixel(6, 2, 255, 165, 0)
picounicorn.set_pixel(6, 3, 0, 0, 0)
picounicorn.set_pixel(6, 4, 255, 165, 0)
picounicorn.set_pixel(6, 5, 0, 0, 0)
picounicorn.set_pixel(6, 6, 255, 165, 0)

picounicorn.set_pixel(7, 0, 0, 128, 0)#Green
picounicorn.set_pixel(7, 1, 0, 128, 0)
picounicorn.set_pixel(7, 2, 255, 165, 0)
picounicorn.set_pixel(7, 3, 255, 165, 0)
picounicorn.set_pixel(7, 4, 255, 165, 0)
picounicorn.set_pixel(7, 5, 0, 0, 0)
picounicorn.set_pixel(7, 6, 255, 165, 0)

picounicorn.set_pixel(8, 0, 0, 128, 0)
picounicorn.set_pixel(8, 1, 255, 165, 0)
picounicorn.set_pixel(8, 2, 255, 165, 0)
picounicorn.set_pixel(8, 3, 0, 0, 0)
picounicorn.set_pixel(8, 4, 255, 165, 0)
picounicorn.set_pixel(8, 5, 0, 0, 0)
picounicorn.set_pixel(8, 6, 255, 165, 0)

picounicorn.set_pixel(9, 0, 0, 0, 0)
picounicorn.set_pixel(9, 1, 255, 165, 0)
picounicorn.set_pixel(9, 2, 0, 0, 0)
picounicorn.set_pixel(9, 3, 255, 165, 0)
picounicorn.set_pixel(9, 4, 255, 165, 0)
picounicorn.set_pixel(9, 5, 0, 0, 0)
picounicorn.set_pixel(9, 6, 255, 165, 0)

picounicorn.set_pixel(10, 0, 0, 0, 0)
picounicorn.set_pixel(10, 1, 255, 165, 0)
picounicorn.set_pixel(10, 2, 255, 165, 0)
picounicorn.set_pixel(10, 3, 0, 0, 0)
picounicorn.set_pixel(10, 4, 255, 165, 0)
picounicorn.set_pixel(10, 5, 0, 0, 0)
picounicorn.set_pixel(10, 6, 255, 165, 0)

picounicorn.set_pixel(11, 0, 0, 0, 0)
picounicorn.set_pixel(11, 1, 0, 0, 0)
picounicorn.set_pixel(11, 2, 255, 165, 0)
picounicorn.set_pixel(11, 3, 255, 165, 0)
picounicorn.set_pixel(11, 4, 0, 0, 0)
picounicorn.set_pixel(11, 5, 255, 165, 0)
picounicorn.set_pixel(11, 6, 255, 165, 0)

picounicorn.set_pixel(12, 0, 0, 0, 0)
picounicorn.set_pixel(12, 1, 0, 0, 0)
picounicorn.set_pixel(12, 2, 0, 0, 0)
picounicorn.set_pixel(12, 3, 255, 165, 0)
picounicorn.set_pixel(12, 4, 255, 165, 0)
picounicorn.set_pixel(12, 5, 255, 165, 0)
picounicorn.set_pixel(12, 6, 0, 0, 0)

picounicorn.set_pixel(13, 0, 0, 0, 0)
picounicorn.set_pixel(13, 1, 0, 0, 0)
picounicorn.set_pixel(13, 2, 0, 0, 0)
picounicorn.set_pixel(13, 3, 0, 0, 0)
picounicorn.set_pixel(13, 4, 0, 0, 0)
picounicorn.set_pixel(13, 5, 0, 0, 0)
picounicorn.set_pixel(13, 6, 0, 0, 0)

picounicorn.set_pixel(14, 0, 0, 0, 0)
picounicorn.set_pixel(14, 1, 0, 0, 0)
picounicorn.set_pixel(14, 2, 0, 0, 0)
picounicorn.set_pixel(14, 3, 0, 0, 0)
picounicorn.set_pixel(14, 4, 0, 0, 0)
picounicorn.set_pixel(14, 5, 0, 0, 0)
picounicorn.set_pixel(14, 6, 0, 0, 0)

picounicorn.set_pixel(15, 0, 0, 0, 0)
picounicorn.set_pixel(15, 1, 0, 0, 0)
picounicorn.set_pixel(15, 2, 0, 0, 0)
picounicorn.set_pixel(15, 3, 0, 0, 0)
picounicorn.set_pixel(15, 4, 0, 0, 0)
picounicorn.set_pixel(15, 5, 0, 0, 0)
picounicorn.set_pixel(15, 6, 0, 0, 0)

print("Press Button A")

while not picounicorn.is_pressed(picounicorn.BUTTON_A):  # Wait for Button A to be pressed
    pass

# Clear the display
for x in range(w):
    for y in range(h):
        picounicorn.set_pixel(x, y, 0, 0, 0)

print("Button A pressed!")