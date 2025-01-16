# Points

The addon can be used to manage dkp based guild loot system. We used it in our guild in Classic Era. The addon uses the officer notes as database.

## Features
- Points management (add/remove/decay/view)
  - add/remove/decay generate transactions, each transaction has timestamp and reason
  - view window can be sorted (by name / by points) with right mouse click
- Transaction history (exportable in CSV) - there is no syncing between different clients. However transactions are timestamped so they can easily be merged into an external sheet. Guildies can use the guild panel to view their own points.
- Main-Alt linking - ability to share points between characters.
- Data Exports (csv)
  - Standings
  - Transaction
  - Consumables used in raid
  - Not very portable but the addon is able to track point changes to see if officers are adding points without permission
- Groups - Ability to provide Gargul Formatted csv of groups and use it to automatically sort groups for specific bosses
- Auto award on boss kills - the addon has default values (can be adjusted in code) to auto award the raid with points based on the boss killed
- Bidding - This is done through the addon Gargul (gdkp). Basically you start a normal gdkp session (multi-bid) and let people bid on items as if they were using gold. If you are loot master then in the top right corner of the window you will see a button called "Deduct" (its not there by default, this addon plugs it in). When the session is done, click on the button and the addon will remove all points, add transactions and remove the points. Each transaction will have the items won listed in the "reason" field. The addon also checks for overbids, it will send a message in guild if some1 is trying to bid with more points than their current amount.

## Screenshots

### Points view (by name)
![image](https://github.com/user-attachments/assets/e4579ed5-719f-494f-a828-d0eee338ba85)
### Points view (by points)
![image](https://github.com/user-attachments/assets/b9ad0883-3d48-4bd4-8cb5-f43ec9c06ffb)
### Main-Alt links
![image](https://github.com/user-attachments/assets/8cd0377f-3881-4ad6-9af8-b3290844b2ef)
### Standings export
![image](https://github.com/user-attachments/assets/8e1c3118-6e1c-44d7-97d9-4b663e5102e0)
### Transaction export
![image](https://github.com/user-attachments/assets/e6061ec9-00cd-4e2e-8d15-77592f89727e)
### Add/Remove points
![image](https://github.com/user-attachments/assets/faa73d37-5172-4925-b218-181461c26210)

