from clingo import Control, Number as N, Function as F
from control.vis import visualize

def run(instance, base, encoding, vis_encoding=None, debug=False):
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
    ctl.ground([('updateState', [N(step)])])        
    
    if debug: # debug mode
        with ctl.solve(yield_=True) as handle:
            for m in handle: 
                pm_atoms = list(filter(lambda atom:
                    len(atom.arguments) > 0 and atom.arguments[0] == N(step), m.symbols(shown=True)))


                print('DEBUG:\n' + ' '.join([str(a) for a in pm_atoms]))
                pass
            
    if vis_encoding is not None: # debug mode
        with ctl.solve(yield_=True) as handle:
            for m in handle: 
                visualize(m, vis_encoding)


    
    p_win = F('end', [N(step), F("p")])
    res = ctl.solve(assumptions=[(p_win, True)])
    if res.satisfiable:
        # print('YES')
        input("YES\nPress Enter to exit...")
        return

    o_win = F('end', [N(step), F("o")])
    res = ctl.solve(assumptions=[(o_win, False)])
    if res.unsatisfiable:
        input("NO\nPress Enter to exit...")
        # print('NO')
        return
        
    step += 1
    with ctl.solve(yield_=True) as handle:
        for m in handle: 
            pm_atoms = list(filter(lambda atom:
                atom.name == 'pm' 
                and len(atom.arguments) > 0
                and atom.arguments[0] == N(step-1), m.symbols(atoms=True)))
            
            #             
            print('Possible moves:\n'+'\n'.join(f"{i}. {str(e)}" for i, e in enumerate(pm_atoms)))
            sel_move = pm_atoms[int(input(f"Select (0-{len(pm_atoms)-1}): "))]
            move = F('m', [N(step), *sel_move.arguments[1:]])
            moves = [*moves, str(move)]
            
    ctl.ground([('pmc', [N(step), *move.arguments[1:]])])


    