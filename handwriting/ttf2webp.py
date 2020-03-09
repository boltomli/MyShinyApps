from PIL import Image, ImageFont
from handright import Template, handwrite

def convert(text, font, path):
    template = Template(
        background=Image.new(mode='1', size=(900, 1000), color=1),
        font_size=72,
        font=ImageFont.truetype(font),
        line_spacing=150,
        fill=0,
        left_margin=100,
        top_margin=100,
        right_margin=100,
        bottom_margin=100,
        word_spacing=15,
        line_spacing_sigma=6,
        font_size_sigma=12,
        word_spacing_sigma=3,
        perturb_x_sigma=4,
        perturb_y_sigma=4,
        perturb_theta_sigma=0.05,
    )
    images = handwrite(text, template)
    for _,im in enumerate(images):
        im.save(path)
