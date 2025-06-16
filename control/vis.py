from clingraph import Factbase, graphviz
from clingo import Control

import tkinter as tk
from PIL import Image, ImageTk

import os




def show_image(image_path, window_title="MyWindow", height=1000, width=600):
    root = tk._default_root
    if not root:
        root = tk.Tk()
        root.withdraw()

    # Find or create window by title
    for window in root.winfo_children():
        if isinstance(window, tk.Toplevel) and window.title() == window_title:
            break
    else:
        window = tk.Toplevel()
        window.title(window_title)
        window.geometry(f"{width}x{height}")  # fixed size window
        window.resizable(True, True)  # Allow resizing

    # Clear old content
    for widget in window.winfo_children():
        widget.destroy()

    img = Image.open(image_path)
    tk_img = ImageTk.PhotoImage(img)

    label = tk.Label(window, image=tk_img)
    label.image = tk_img  # keep reference
    label.pack()

    # Start event loop if needed
    if not root.children:
        root.mainloop()

    

def visualize(model, vis_encoding):
    # convert the model to a string of facts
    ctl = Control(['--warn=none'])
    ctl.load(vis_encoding)
    facts = '. '.join(str(m) for m in model.symbols(atoms=True)) + '.'
    ctl.add('base', [], facts)
    ctl.ground([('base', ())])
    
    fb = Factbase()
    
    with ctl.solve(yield_=True) as handle:
        for m in handle: # the only model
            fb.add_model(m)
            graphs = graphviz.compute_graphs(fb, graphviz_type='digraph')
            graphviz.render(graphs, format="png") # todo: set filename
            show_image("out/" + sorted(os.listdir("out"))[-1])
 
            
            

