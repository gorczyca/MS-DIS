import argparse
from importlib.resources import files

import msdis.control.acceptance as acc
import msdis.control.approx as approx
import msdis.control.interactive as inter

def main():
    args = argparse.ArgumentParser()
    args.add_argument('-p', dest='problem', type=str, required=True)
    args.add_argument('-f', dest='framework', type=str, required=True)
    args.add_argument('-g', dest='goal', type=str, required=True)
    args.add_argument('-a', dest='approx', type=int)
    args.add_argument('-i', dest='interactive', action='store_true')
    args = args.parse_args()
    
    # Get the package root directory
    package_root = files('msdis')
    
    # Construct the path to the encoding files
    encoding_files = {
        'aba': package_root / 'encoding' / 'aba.lp',
        'af': package_root / 'encoding' / 'af.lp',
    }
    encoding = str(encoding_files[args.framework])

    if args.interactive:
        inter.run(args.problem, args.goal, encoding)
    elif args.approx is not None:
        approx.run(args.problem, args.goal, args.approx, encoding)
    else:
        print(acc.run(args.problem, args.goal, encoding))
            
if __name__ == '__main__':
    main()


    