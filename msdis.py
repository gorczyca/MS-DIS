import argparse, os

import control.acceptance as acc
import control.approx as approx
import control.interactive as inter

ENCODING_FILES = {
    'aba': 'encoding/aba/aba.lp',
    'af': 'encoding/af/af.lp'
}


def main():
    args = argparse.ArgumentParser()
    args.add_argument('-p', dest='problem', type=str, required=True)
    args.add_argument('-f', dest='framework', type=str, required=True)
    args.add_argument('-b', dest='base', type=str, required=True)
    args.add_argument('-x', dest='approx', type=int)
    args.add_argument('-v', dest='vis_encoding', type=str)
    args.add_argument('-i', dest='interactive', action='store_true')
    args.add_argument('-d', dest='debug', action='store_true')
    args = args.parse_args()
    
    __dir__ = os.path.dirname(os.path.abspath(__file__))
    encoding_path = os.path.join(__dir__, ENCODING_FILES[args.framework])

    if args.interactive:
        inter.run(args.problem, args.base, encoding_path, vis_encoding=args.vis_encoding, debug=args.debug)
    elif args.approx is not None:
        horizon = int(args.approx)
        print(approx.run(args.problem, args.base, horizon, encoding_path))
    else:
        print(acc.run(args.problem, args.base, encoding_path))
            
            
if __name__ == '__main__':
    main()


    