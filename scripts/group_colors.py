import json
import random
import colorsys
from data import *

def generate_group_colors():
    groups = map(lambda x: x[2], cal_ids)
    out = []
    for g in groups:
        h = random.uniform(0, 1)
        s = random.uniform(0.6, 0.7)
        v = random.uniform(0.65, 0.8)

        rgb = colorsys.hsv_to_rgb(h, s, v)
        rgb = tuple(map(lambda x: round(x*255), rgb))
        col = '#%02X%02X%02X' % rgb

        print((g,col))
        out.append( (g, col) )

    f = open('data/group_colors.json', 'w')
    json.dump(out, f)
    f.close()
    
if __name__ == '__main__':
    generate_group_colors()
