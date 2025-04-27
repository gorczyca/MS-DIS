#TODO:

from clingo import Control, Number, Function
import sys


def on_model(model):
    print("Answer:")
    for atom in model.symbols(shown=True):
        print(f"  {atom}")


def run(instance, goal, encoding):
  ctl = Control(['--warn=none'])
  ctl.load(instance)
  ctl.load(encoding)
  ctl.add('base', [], f'g({goal}).')
  ctl.ground([('base', ())])
  step = 0
  while True:
    ctl.ground([('updateState', [Number(step)])])
    # ctl.solve(on_model=on_model)
    p_win = Function('end', [Number(step), Function("p")])
    # res = ctl.solve(assumptions=[(p_win, True)], on_model=on_model)
    res = ctl.solve(assumptions=[(p_win, True)])
    if res.satisfiable:
        return 'yes', step, None, None, None
    o_win = Function('end', [Number(step), Function("o")])
    # res = ctl.solve(assumptions=[(o_win, False)], on_model=on_model)
    res = ctl.solve(assumptions=[(o_win, False)])
    if res.unsatisfiable:
        return 'no', step, None, None, None
    step += 1
    ctl.ground([('step', [Number(step)])])

