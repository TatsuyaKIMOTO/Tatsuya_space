from PIL import Image

def image_to_ascii(image_path, width=50, chars=' .:-=+*#%@'):
    img = Image.open(image_path).convert('L')
    img = img.resize((width, int(img.height * width / img.width / 2)))
    pixels = img.getdata()
    return ''.join(chars[min(int(p / 25), len(chars) - 1)] for p in pixels)

# how to use
image_path = "Input paht\hogehoge.jpg"
print('\n'.join(image_to_ascii(image_path)[i:i+50] for i in range(0, 2500, 50)))
