# `multivisor` web dashboard to control `supervisor` process managers 

## Installation
1. Install `multivisor[web]` via `pip`

    Recommended to install in a conda env
    ```bash
    #c onda create -n multivisor python=3.11
    # conda activate mutlvisor
    pip install multivisor[web]
    ```
2. Download this folder and make `./Startup_bash` excecutable.
    ```bash
    chmod +x ./Startup_bash
    ```
3. Run `./Startup_bash` directly or via `supervisor` using the `supervisor/multivisor.conf` supervisor configuration file. Copy it to, e.g., `/etc/supervisor/conf.d`.