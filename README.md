```
███╗   ███╗███████╗      ██████╗ ██╗███████╗
████╗ ████║██╔════╝      ██╔══██╗██║██╔════╝
██╔████╔██║███████╗█████╗██║  ██║██║███████╗
██║╚██╔╝██║╚════██║╚════╝██║  ██║██║╚════██║
██║ ╚═╝ ██║███████║      ██████╔╝██║███████║
╚═╝     ╚═╝╚══════╝      ╚═════╝ ╚═╝╚══════╝
                                            
```

## Installation
[clingo](https://potassco.org/clingo/python-api/5.4/) python module is required. It can be installed via conda:

```
conda env create -f environment.yml
conda activate clingo-env
```


## Run
### ABA:
under admissible semantics, with instance `<INSTANCE>` and goal `<GOAL>`, run: 
```
python msdis.py -f aba -p <INSTANCE> -b "g(<GOAL>). tt(ta). at(dabf)." 
```

for example:

```
python msdis.py -f aba -p test-instances/aba-test-instance.lp -b "g(a4). tt(ta). at(dabf)." 
```

For stable semantics, set `tt(ts). at(ts).` as below:
```
python msdis.py -f aba -p test-instances/aba-test-instance.lp -b "g(a4). tt(ts). at(dc)." 
```

### AF:
```
python msdis.py -f af -p test-instances/af-test-instance.lp -b "g(36)."

```

## Interactive mode:
Provide the `-i` flag, e.g.:
```
python msdis.py -f aba -p test-instances/aba-test-instance.lp -i -b "g(a4). tt(ta). at(dabf)." 
```
(same with different instance)
```
python msdis.py -f aba -p test-instances/paper-running-example-aba.lp -i -b "g(s). tt(ta). at(dabf)." 
```

## Approximate reasoning
Provide the horizon (upper bound on the number of moves) with `-x <HORIZON>` e.g. 
```
python msdis.py -f aba -p test-instances/aba-test-instance.lp -b "g(a4). tt(ta). at(dabf)." -x 15
```

## Visualisation

Provide a visualisation clingraph encoding with a `-v <ENCODING>` parameter, e.g.:


| Encoding     | Command example                                                                                      | Screenshot                       |
|--------------|----------------------------------------------------------------------------------------------------|--------------------------------|
| AF encoding 1| `python msdis.py -f af -p test-instances/af-ex2.lp -i -b "g(a10)." -v encoding/af/af-vis1.lp`       | ![AF encoding 1](img/af-vis1.png)  |
| AF encoding 2| `python msdis.py -f af -p test-instances/af-ex2.lp -i -b "g(a10)." -v encoding/af/af-vis2.lp`       | ![AF encoding 2](img/af-vis2.gif)  |
| AF encoding 3| `python msdis.py -f af -p test-instances/af-ex2.lp -i -b "g(a10)." -v encoding/af/af-vis3.lp`       | ![AF encoding 3](img/af-vis3.png)  |
| AF encoding 4| `python msdis.py -f af -p test-instances/af-ex2.lp -i -b "g(a10)." -v encoding/af/af-vis4.lp`       | ![AF encoding 4](img/af-vis4.png)  |
| AF encoding 4 raw| `python msdis.py -f af -p test-instances/af-ex2.lp -i -b "g(a10)." -v encoding/af/af-vis4.lp`       | ![AF encoding 4 raw](img/af-vis4.png)  |
| ABA          | `python msdis.py -f aba -p test-instances/paper-running-example-aba.lp -b "g(s). at(dabf). tt(ta)." -i -v encoding/aba/aba-vis.lp` | ![ABA 1](img/aba-vis.png)           |
| ABA 2         | `python msdis.py -f aba -p test-instances/paper-running-example-aba.lp -b "g(s). at(dabf). tt(ta)." -i -v encoding/aba/aba-vis2.lp` | ![ABA 2](img/aba-vis2.png)           |

<!-- `clingo encoding/aba/full_leq0.lp encoding/aba/aba-paper-test-file2.lp encoding/aba/aba-vis2.lp -n0 --outf=2  | clingraph --out=render --format=pdf --type=digraph` -->