import argparse
from importlib.resources import files

import control.acceptance as acc
import control.approx as approx
import control.interactive as inter

def main():
    args = argparse.ArgumentParser()
    args.add_argument('-p', dest='problem', type=str, required=True)
    args.add_argument('-f', dest='framework', type=str, required=True)
    args.add_argument('-g', dest='goal', type=str, required=True)
    args.add_argument('-a', dest='approx', type=int)
    args.add_argument('-i', dest='interactive', action='store_true')
    args = args.parse_args()
    
    encoding_files = {
        'aba': 'encoding/aba.lp',
        'af': 'encoding/af.lp',
    }

    if args.interactive:
        inter.run(args.problem, args.goal, encoding_files[args.framework])
    elif args.approx is not None:
        approx.run(args.problem, args.goal, args.approx, encoding_files[args.framework])
    else:
        print(acc.run(args.problem, args.goal, encoding_files[args.framework]))
            
if __name__ == '__main__':
    main()


    