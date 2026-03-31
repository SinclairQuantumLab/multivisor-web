# `multivisor` web dashboard to control `supervisor` process managers 

## Installation
1. `git clone` this repo (recommeded location: `~/Projects/multivisor-web/`)
2. make `./Startup_bash` excecutable:
    ```bash
    $ chmod +x ./Startup_bash
    ```
3. Install `multivisor[web]` using `uv`

    ```bash
    $ uv sync
    ```

3. (Optional) To make `multivisor` requires login, uncomment `username` and `password` in `multivisor.conf`'s `[global]` section:

    ```ini
    [global]
    name=sinclair-multivisor
    username=sinclair-admin
    password=<usual one>
    ```

    run the below command in terminal and optain a random hash value:
    ```bash
    $ python -c 'import os; import binascii; print(binascii.hexlify(os.urandom(32)))'
    b'b934709240f6be65790f082b93db9340b59d975cabef57981d08c6c92b906d27' # example output
    ```

    Create `.env` file in the repo folder and add `MULTIVISOR_SECRET_KEY` with the hash value obtained (inside the `b'XXX'` binary-number indication format):

    ```bash
    # in .env file
    MULTIVISOR_SECRET_KEY=b934709240f6be65790f082b93db9340b59d975cabef57981d08c6c92b906d27
    ```

4. Run `./Startup_bash` directly in terminal:

    ```bash
    $ export $(cat ./.env | xargs) # if .env was create in Step 3 above
    $ uv run multivisor -c multivisor.conf
    ```

    Alternatively, via `supervisor` using the `supervisor/multivisor-web.conf` supervisor configuration file. Copy it to, e.g., `/etc/supervisor/conf.d`.


## Known issues
### Open issues
- (listed: 2026/03/14) favicon would be good to be added.


### Resolved issues
- (listed: 2026/03/14) The webpage seems to periodically re-establish connections to the server in every 1.5 min. However, if it is accessed through an address which is not something recognized in local network (e.g., accessed from WAN via, e.g., reverse proxy (our usual case),  port forwarding)<br />
<!-- (resolved: 2026/03/16) It was too early termination of server connection due to nginx-proxy-manager. Adding the below configuration script in *nginx-proxy-manager web UI > * -->

## Other options for centralized web UI supervisor management

Consider other when multivisor becomes not sustainable

- [Supervisors](https://github.com/julien6387/supvisors): Very comprehensive dashboard. The creator of `supervisor`, [tiagocoutinho](https://github.com/tiagocoutinho) has been involved.

- [supervisord-monitor](https://github.com/mlazarov/supervisord-monitor): got most stars in github (957 as of 2026/03/14). Simple & organized (while not so pretty...)


## Discussions
- Q. Why Why not other web UIs?<br />
A.

- Q. Why not running in Docker? It is just a web service.<br />
A. Because `multivisor` is not so robust or actively maintained system, and therefore it might have to


## Developer's note
- The `multivisor` here was initially installed using `uv` as below:

    ```bash
    $ uv init --python 3.11
    $ uv add "multivisor[web,cli]==6.0.3"
    ```
