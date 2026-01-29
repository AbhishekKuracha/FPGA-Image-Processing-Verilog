from PIL import Image

# Open the BMP image
img = Image.open("input.bmp")
img = img.convert("RGB")

width, height = img.size
pixels = img.load()

data = []

# Read pixels from bottom to top (same like MATLAB code)
for i in range(height-1, -1, -1):
    for j in range(width):
        r, g, b = pixels[j, i]
        data.append(r)
        data.append(g)
        data.append(b)

# Write to HEX file
with open("input.hex", "w") as f:
    for v in data:
        f.write(format(v, 'x') + "\n")

print("input.hex created successfully")
