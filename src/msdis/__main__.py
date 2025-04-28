import argparse
from importlib.resources import files

import msdis.control.acceptance as acc
import msdis.control.approx as approx
import msdis.control.interactive as inter


FRAMEWORKS_DICT = {
    'aba': files('msdis.encoding').joinpath('aba.lp'),
    'af': files('msdis.encoding').joinpath('af.lp'),
}


def main():
    args = argparse.ArgumentParser()
    args.add_argument('-p', dest='problem', type=str, required=True)
    args.add_argument('-f', dest='framework', type=str, required=True)
    args.add_argument('-g', dest='goal', type=str, required=True)
    args.add_argument('-a', dest='approx', type=int)
    args.add_argument('-i', dest='interactive', action='store_true')
    args = args.parse_args()

    encoding = str(FRAMEWORKS_DICT[args.framework])

    if args.interactive:
        inter.run(args.problem, args.goal, encoding)
    elif args.approx is not None:
        approx.run(args.problem, args.goal, args.approx, encoding)
    else:
        print(acc.run(args.problem, args.goal, encoding))
        
if __name__ == '__main__':
    main()


    