- [continuumio/anaconda](https://hub.docker.com/r/continuumio/anaconda/)
- [Opening Chrome From the OSX Terminal](http://alexba.in/blog/2012/03/23/open-chrome-from-terminal/)

```bash
    $ docker pull continuumio/anaconda
```

```bash
    $ docker run -i -t continuumio/anaconda /bin/bash
```

```bash
    $ cd ~/github/sieferos/wsl01x/ && docker run -i -t -p 8888:8888 continuumio/anaconda /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"

    $ chrome http://localhost:8888
```
