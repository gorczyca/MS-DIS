from clingo import Control, Number, Function


def run(instance, base, horizon, encoding):
  ctl = Control(['--warn=none'])
  ctl.load(instance)
  ctl.load(encoding)
  ctl.add('base', [], base)
  ctl.ground([('base', ())])
  step = 0
  while True:    
    ctl.ground([('updateState', [Number(step)])])
    p_win = Function('end', [Number(step), Function("p")])
    res = ctl.solve(assumptions=[(p_win, True)])
    if res.satisfiable:
        return 'YES'

    step += 1
    if step >= horizon:
        return 'NO'
     
    ctl.ground([('step', [Number(step)])])