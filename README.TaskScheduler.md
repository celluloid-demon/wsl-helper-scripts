Windows Task Scheduler
======================

Options of interest
-------------------

__General__

- Name: `wsl`
- Description: `Attempt at running wsl in background on startup - custom <USERNAME>/.wslconfig settings should then keep it from spinning down`

__General/SecurityOptions__

- Use the following user account: `Jonathan`
- Run only when user is logged on: `TRUE`
- Run with highest privileges: `FALSE`

__Triggers__

- Begin the task: `At log on`
- Specific user: `Jonathan`
- Delay task for: `1 minute`

__Actions__

- Action: `Start a program`
- Program/script: `wsl.exe`
- Add arguments (optional): `-e bash -c "echo dummy"`

__Conditions__

- Start the task only if the computer is on AC power: `FALSE`

__Settings__

- Run task as soon as possible after a scheduled start is missed: `FALSE`
