# Boba Gamer 67 - Greybox Prototype

## Overview
This is a greybox prototype of the "Boba Assassin" RPG.
The game features two distinct phases: Day (Boba Shop Simulation) and Night (Top-Down Assassination).

## Controls

### Day Phase (Boba Shop)
- **Goal**: Fulfil orders to gather Intel. Special "Contract" orders appear occasionally.
- **Controls**:
    - [1]: Tea
    - [2]: Milk
    - [3]: Syrup
    - [4]: Boba
    - [5]: Ice
    - [Backspace]: Clear Current Mix
    - [Enter]: Serve Order
- **Loop**: Serve orders until time runs out -> Transitions to Night Phase.

### Night Phase (Assassination)
- **Goal**: Find and eliminate the "Target" (Red Enemy).
- **Controls**:
    - [W, A, S, D]: Move
    - [Shift]: Sprint
    - [Ctrl]: Crouch (Slow Move)
    - [Left Click]: Attack (Melee/Shoot)
    - [Right Click]: Steady Aim (Slow Move + Focus)
    - [G]: Ability (Placeholder)
    - [1 / 2]: Switch Weapon
- **Loop**: Kill the Target -> Transitions back to Day Phase (Next Day).

## Implementation Details
- **Player.gd**: Handles top-down movement and combat inputs.
- **DayPhase.gd**: Manages the order generation and scoring (Intel).
- **GameManager.gd**: Persists data (Intel) between scenes.
