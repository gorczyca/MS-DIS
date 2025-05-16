import argparse, os, sys
from clingo import Control, Number, Function

def run(instance, base, encoding):
  ctl = Control(['--warn=none'])
  
  framework_str = convert_framework(instance)
  ctl.load(encoding)
  ctl.add('base', [], framework_str)
  ctl.add('base', [], base)
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
    
    
def convert_framework(file_path):
    assumptions = []
    rules = []
    contraries = []

    with open(file_path, "r") as f:
        text = f.read().split("\n")
    if not text[0].startswith("p aba"):
        raise Exception(f"File '{file_path}' is not in ICCMA25 format (missing p-line).")
    for line in text[1:]:
        if line.startswith("a "):
            assumptions.append(line.split()[1])
        elif line.startswith("r "):
            components = line.split()[1:]
            head, body = components[0], components[1:]
            rules.append((head,body))
        elif line.startswith("c "):
            components = line.split()
            contraries.append((components[1], components[2]))
        elif line.startswith("#") or not line:
            continue
        else:
            raise Exception(f"Unrecognized line in the input file '{file_path}': '{line}'")
        
    framework_str = ''
    for asm in assumptions:
        framework_str += f'assumption({asm}). '
    for i, rule in enumerate(rules):
        framework_str += f'head(r{i},{rule[0]}). '
        for b in rule[1]:
            framework_str += f'body(r{i},{b}). '
    for ctr in contraries:
        framework_str += f'contrary({ctr[0]}, {ctr[1]}). '
        
    return framework_str


def main():
    
    if len(sys.argv) == 1:
        print("MS-DIS v1.0")
        print("Piotr Gorczyca, piotr.gorczyca@tu-dresden.de")
        print("Martin Diller, martin.diller@tu-dresden.de")
        return  
    
    args = argparse.ArgumentParser()
    
    # Add --problems as a string argument
    args.add_argument('--problems', action='store_true')

    # Short flags as boolean switches
    # args.add_argument('-p', action='store_true', help="Flag p")
    # args.add_argument('-f', action='store_true', help="Flag f")
    # args.add_argument('-a', action='store_true', help="Flag a")
    args.add_argument('-p', dest='chosen_problem', type=str)
    args.add_argument('-f', dest='file', type=str)
    args.add_argument('-a', dest='query', type=str)
    args = args.parse_args()
    
    if(args.problems):
        print('[DC-CO,DC-ST]')
        return
    
    base = ''
    
    if args.chosen_problem == 'DC-CO':
        base = f'g({args.query}). at(dabf). tt(ta).'
    elif args.chosen_problem == 'DC-ST':
        base = f'g({args.query}). at(ds). tt(ts).'
    else:
        print('Wrong problem specified')
        return
        

    __dir__ = os.path.dirname(os.path.abspath(__file__))
    encoding_path = os.path.join(__dir__, 'encoding/aba.lp')


    print(run(args.file, base, encoding_path))
            
            
if __name__ == '__main__':
    main()



    