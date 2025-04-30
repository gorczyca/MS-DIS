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
git clone https://github.com/gorczyca/MS-DIS
cd MS-DIS
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
python msdis.py -f aba -p instances/aba-test-instance.lp-b "g(a4). tt(ta). at(dabf)." 
```

For stable semantics, set `tt(ts). at(ts).` as below:
```
python msdis.py -f aba -p instances/aba-test-instance.lp -b "g(a4). tt(ts). at(dc)." 
```

### AF:
```
python msdis.py -f af -p test-instances/af-test-instance.lp -b "g(36)."

```