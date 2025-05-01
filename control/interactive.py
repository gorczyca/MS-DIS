from clingo import Control, Number, Function


def run(instance, base, encoding):
  ctl = Control(['--warn=none'])
  ctl.load(instance)
  ctl.load(encoding)
  ctl.add('base', [], base)
  ctl.ground([('base', ())])

  step = 0
  moves = []

  print(f'Setting: {base}')   
  while True:
    print('Current dispute:\n'+'\n'.join(f"{i}. {e}" for i, e in enumerate(moves)))
    ctl.ground([('updateState', [Number(step)])])    
    p_win = Function('end', [Number(step), Function("p")])
    res = ctl.solve(assumptions=[(p_win, True)])
    if res.satisfiable:
        print('YES')
        return
    o_win = Function('end', [Number(step), Function("o")])
    res = ctl.solve(assumptions=[(o_win, False)])
    if res.unsatisfiable:
        print('NO')
        return
        
    step += 1
    with ctl.solve(yield_=True) as handle:
        for m in handle: 
            pm_atoms = list(filter(lambda atom:
                atom.name == 'pm' 
                and len(atom.arguments) > 0
                and atom.arguments[0] == Number(step-1), m.symbols(atoms=True)))
            
            print('Possible moves:\n'+'\n'.join(f"{i}. {str(e)}" for i, e in enumerate(pm_atoms)))
            sel_move = pm_atoms[int(input(f"Select (0-{len(pm_atoms)-1}): "))]
            move = Function('m', [Number(step), *sel_move.arguments[1:]])
            moves = [*moves, str(move)]
            
    ctl.ground([('pmc', [Number(step), *move.arguments[1:]])])
    