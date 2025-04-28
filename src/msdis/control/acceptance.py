from clingo import Control, Number, Function


def run(instance, goal, encoding):
  ctl = Control(['--warn=none'])
  ctl.load(instance)
  ctl.load(encoding)
  ctl.add('base', [], f'g({goal}).')
  ctl.ground([('base', ())])
  step = 0
  while True:
    ctl.ground([('updateState', [Number(step)])])
    p_win = Function('end', [Number(step), Function("p")])
    res = ctl.solve(assumptions=[(p_win, True)])
    if res.satisfiable:
        return 'YES'
    o_win = Function('end', [Number(step), Function("o")])
    res = ctl.solve(assumptions=[(o_win, False)])
    if res.unsatisfiable:
        return 'NO'
    step += 1
    ctl.ground([('step', [Number(step)])])
