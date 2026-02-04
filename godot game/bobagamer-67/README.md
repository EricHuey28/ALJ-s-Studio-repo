# Bobarista Assassin Prototype

## Overview
This is a prototype for "Bobarista Assassin", a game where you serve boba during the day to gather intel, and assassinate targets at night.

## Controls

### General
- **Mouse**: UI Interaction (Day Phase), Aiming (Night Phase)

### Night Phase (Combat)
- **W, A, S, D**: Move
- **Shift**: Run
- **Ctrl**: Crouch / Sneak (Slower movement)
- **Mouse Cursor**: Character faces cursor
- **Left Click**: Attack (Melee/Shoot)
- **Right Click**: Aim (Slows movement for precision)
- **1**: Equip Main Weapon
- **2**: Equip Melee Weapon

## Gameplay Loop

### Day Phase (The Shop)
- You have 30 seconds to serve as many correct orders as possible.
- Look at the **Order** label to see required ingredients (e.g., "Tea, Milk, Boba").
- Click the ingredient buttons to add them to your **Current Mix**.
- Click **SERVE** to submit the order.
- Correct orders grant **Intel**.
- When the shift ends, you proceed to the Night Mission.

### Night Phase (The Mission)
- Your goal is to eliminate the **Target** (Red enemy).
- Avoid or eliminate guards.
- If you are detected, enemies will chase you.
- Use your gathered Intel (from Day Phase) to unlock better loadouts (Simulated in this prototype: High intel = better starting weapon level).
- Once the Target is eliminated, the mission is complete and you return to the Day Phase.

## Running the Game
Open this project in Godot Engine (v4.0+) and press **F5** or run the Main Scene (`DayPhase.tscn`).
