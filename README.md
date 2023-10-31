# lasrcop
Leightweight Automated Session Recording to Certify Original Programming

LASRCOP is designed to augment programming classes by recording student work in order to help detect plagerism, as well as defend against false alegations of plagerism.  Session recording comes with the added benefit of giving teachers insight into a student's thought process as they program.

LASRCOP is a set of Bash scripts which utilize [Asciinema](https://asciinema.org/) in order to record, save, and replay sessions.  Sessions are saved locally to disk, and can be replayed in real time, at will, when needed.

# Setup
Asciinema is the only software dependency.  It should be available in most Linux distro repositories.  For instance...

```
sudo apt update
sudo apt install asciinema
```

You'll also need to create a directory to store session files.  It is strongly recommended to do this on a seperate disk or partition.  It is also recommended to remove global read permission from this directory, to protect user privacy.

```
sudo mkdir /var/sessions
sudo chmod o-r /var/sessions
```

The `lasrcop.sh` script should be installed in a directory which is in the standard `PATH` environment variable.  I.e.

```
sudo cp lasrcop.sh /usr/local/bin/lasrcop
```

Finally, enable LASRCOP for specific Linux users or groups in your SSHd config with the `Match` and `ForceCommand` directives.

```
# sudo nano /etc/sshd/sshd_config

# Enable LASRCOP for a specific user account
Match User john.doe
  ForceCommand /usr/local/bin/lasrcop

# Enable LASRCOP for a specific group
Match Group students
  ForceCommand /usr/local/bin/lasrcop

# Enable LASRCOP for a specific group, exclusing a specific user
Match Group students User *,!john.doe
  ForceCommand /usr/local/bin/lasrcop
```

Then restart your SSHd to make the changes take effect.

```
sudo systemctl restart ssh
```

# Usage
Upon first login, each user will be asked to consent to recording and monitoring while using the server.  This prompt should only appear once.  Session recording should then begin transparently and automatically.

Session recordings can be found in the `/var/sessions` directory, organized by username and named by timestamp of when the session began.  To review session recordings, switch to the `root` account and run, for instance...

```
asciinema play /var/sessions/john.doe/2023:07:31-11:03:35.cast
```

Session statistics can be gathered with the included `stats.sh` script.  When run, it will generate a CSV file with information about number of users, number of sessions, and disk usage over time.  To use it, review the config settings at the top of the script and then simply run (as root)...

```
./stats.sh
```

# Credits
HUGE thanks to the Asciinema team for such an amazing tool!  LASRCOP is nothing more than a small wrapper script for this already-incredible piece of software.  All credit to Asciinema for the heavy lift of session recording and replay.
