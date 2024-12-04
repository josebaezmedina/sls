### About
SLS is a simple utility to display directory contents ala ls. Is the slow version of ls designed to add as many features as we think they are useful / fun.

### Prerequisites
- [Leiningen](https://leiningen.org/)

### Instalation
1. Clone the repo 
```bash
 git clone https://github.com/josebaezmedina/sls 
```
2. Enter sls project
```bash
cd sls
```
3. Build with leiningen 
```bash
lein build
```
4. Run it and check if works (see usage section for more info)
```bash
lein run [path] [options]
```

### Alternative
There is a shell script to generate a native image of the utility.

To generate the image just:
```bash
cd sls
bash generate_app.sh
```
This will generate a executable file in:
```bash
sls/bin/sls_app/bin/sls_app
```
And create a sysmlink in your /home/yourusername/bin folder.

### Usage

- List contents of a directory:
```bash 
sls [path] [options]
```
example
```bash
sls /home -t
sls . -a
sls -a -t
sls
```
- Options

| Option | Description              |
| ------ | ------------------------ |
| -t     | shows results as a table |
| -a     | shows hidden files.      |

### Todo

- [x] Basic list
- [x] Hidden files
- [x] Tabular results
- [ ] Column formating
- [ ] Tree view
- [ ] Permissions in tabular format 

### License
Eclipse Public License - v 2.0. See LICENSE


