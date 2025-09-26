import math

f = open("Cofficient.mi", "w")  # Create file

f.write("#File_format=Hex\n")
f.write("#Address_depth=2048\n")
f.write("#Data_width=48\n")

n = 100
Resolution = 536870912  # 2^29
CLK = 24000  # 24Mhz from Clk_Div module

for i in range(0, 2048):
    alpha = math.sin(2 * math.pi * n / 24000) * 0.95
    alpha = round(alpha * Resolution, 0)
    alpha = int(alpha) >> 4
    # --------------------------------------#
    y1 = math.cos(2 * math.pi * n / 24000)
    y1 = round(y1 * Resolution, 0)
    y1 = (int(y1) & 0x01FFFFFE) >> 1

    if n <= 1000:
        f.write("%06x%06x \n" % (alpha, y1))
        n = n + 0.5
    else:
        f.write("%06x%06x \n" % (0, 0))
        n = n + 0.5