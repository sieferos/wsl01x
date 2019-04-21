- [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/)
- [Running a Container](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html)
- [Opening Chrome From the OSX Terminal](http://alexba.in/blog/2012/03/23/open-chrome-from-terminal/)

```bash
    $ docker pull jupyter/tensorflow-notebook
```

```bash
    $ cd ~/Daniel/TNPS/ && docker run --name "jupyter-tensorflow-notebook" --rm -v "$PWD":/home/jovyan/work -p 8888:8888 jupyter/tensorflow-notebook
```

```bash
    $ chrome http://localhost:8888/?token=d079e725e1c15475a4ed64270bd165c52680d4f35adaaeb1
```
